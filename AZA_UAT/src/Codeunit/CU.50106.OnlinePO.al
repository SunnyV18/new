codeunit 50106 OnlinePO
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        if Rec."Parameter String" = 'CreateOnlinePO' then
            ProcessOnlinePOs();

        if Rec."Parameter String" = 'CreateCustomer' then
            ProcessCustomers();
    end;


    //***Not in use***
    procedure CreateOnlinePO()
    var
        int: Integer;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        POStaging: Record POStaging;
        PONo: Code[20];
        VendorNo: Code[20];
        DocumentDate: Date;
        Line_No: Integer;
    begin
        POStaging.Reset();
        if POStaging.FindSet() then
            repeat
                Evaluate(PONo, Format(POStaging.id));
                PurchHeader.Reset();
                PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
                PurchHeader.SetRange("No.", PONo);
                if PurchHeader.FindFirst() then begin
                    PurchHeader.Init();
                    PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
                    PurchHeader.Validate("No.", PONo);
                    Evaluate(VendorNo, Format(POStaging.designer_id));
                    PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
                    Evaluate(DocumentDate, Format(POStaging.date_added));
                    PurchHeader.Validate("Document Date", DocumentDate);
                    PurchHeader.Validate(Status, PurchHeader.Status::Open);
                    Evaluate(PurchHeader."PO type", Format(POStaging.po_type));
                    PurchHeader.Insert();

                    Line_No := 10000;
                    PurchLine.Init();
                    PurchLine."Document Type" := PurchHeader."Document Type";
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine."Line No." := Line_No;
                    PurchLine.Validate(Type, PurchLine.Type::Item);
                    PurchLine.Validate("No.", POStaging.product_id);
                    PurchLine.Validate("Unit of Measure", 'PCS');
                    PurchLine.Validate(Quantity, POStaging.Quantity);
                    PurchLine.Insert(true);
                end else begin
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                    PurchLine.SetRange("Document No.", PurchHeader."No.");
                    if PurchLine.FindLast() then begin
                        Line_No := PurchLine."Line No." + 10000;
                        PurchLine.Init();
                        PurchLine."Document Type" := PurchHeader."Document Type";
                        PurchLine."Document No." := PurchHeader."No.";
                        PurchLine."Line No." := Line_No;
                        PurchLine.Validate(Type, PurchLine.Type::Item);
                        PurchLine.Validate("No.", POStaging.product_id);
                        PurchLine.Validate("Unit of Measure", 'PCS');
                        PurchLine.Validate(Quantity, POStaging.Quantity);
                        PurchLine.Insert(true);
                    end;
                end;
            until POStaging.Next() = 0;
    end;

    //***Not in use***
    procedure CreateOnlinePO2()
    var
        int: Integer;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        POStaging: Record POStaging;
        PONo: Code[20];
        VendorOrderNo: Code[20];
        VendorShipmentNo: Code[20];
        NewVendorShipmentNo: Code[20];
        NewVendorOrderNo: Code[20];
        Orderdate: Date;
        VendorNo: Code[20];
        PromiseReceiptdate: Date;
        ReqReceiptDate: Date;
        Status: Option;
        SystemModifiedAt: Code[20];
        LocationCode: Code[10];
        ShipAddress1: Text[50];
        ShipAddress2: Text[50];
        ShipCity: Text[50];
        ShipState: Text[50];
        ShipPostCode: Code[20];
        DocumentDate: Date;
        Line_No: Integer;
        Address: Text[250];
        Address2: Text[50];
        City: Text[50];
        State: Text[50];
        PostCode: Code[20];
        GSTVendorType: Option;
        Quantity: Decimal;
        UnitCost: Decimal;
        MRP: Decimal;
        LineDiscountAmount: Decimal;
        Curr_PoType: Text;
        Curr_Vendor: Code[20];
        Curr_PONo: Code[20];
        Last_PONo: Code[20];
        Last_Vendor: Code[20];
        Last_PoType: Text;

    begin
        POStaging.Reset();
        POStaging.SetCurrentKey(po_number);
        POStaging.SetRange("Record Status", POStaging."Record Status"::" ");
        // POStaging.SetRange(po_status, false);
        if POStaging.FindSet() then
            repeat
                Curr_PONo := POStaging.po_number;
                Curr_PoType := Format(POStaging.PO_type2);
                Curr_Vendor := Format(POStaging.designer_id);
                if (Curr_PONo = Last_PONo) AND (Curr_Vendor = Last_Vendor) AND (Curr_PoType = Last_PoType) then begin
                    Evaluate(PONo, Format(POStaging.po_number));
                    PurchHeader.Reset();
                    PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
                    PurchHeader.SetRange("No.", PONo);
                    if not PurchHeader.FindFirst() then begin
                        PurchHeader.Init();
                        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
                        PurchHeader.Validate("No.", PONo);
                        Evaluate(VendorNo, Format(POStaging.designer_id));
                        PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
                        Evaluate(VendorOrderNo, Format(POStaging.order_number));
                        PurchHeader.Validate("Vendor Order No.", VendorOrderNo);
                        Evaluate(VendorShipmentNo, Format((POStaging.order_detail_id)));
                        PurchHeader.Validate("Vendor Shipment No.", VendorShipmentNo);
                        Evaluate(Orderdate, Format(POStaging.order_date));
                        PurchHeader.Validate("Order Date", Orderdate);
                        // Evaluate(VendorNo, Format(POStaging.parent_designer_id));
                        // PurchHeader.Validate("Vendor Order No.", VendorNo);
                        Evaluate(PromiseReceiptdate, Format(POStaging.delivery_date));////
                        PurchHeader.Validate("Promised Receipt Date", PromiseReceiptdate);
                        Evaluate(ReqReceiptDate, Format((POStaging.order_delivery_date)));
                        PurchHeader.Validate("Requested Receipt Date", ReqReceiptDate);
                        Evaluate(Status, Format(POStaging.Status));
                        PurchHeader.Validate(Status, Status);
                        PurchHeader.Validate(SystemModifiedAt, POStaging.date_modified);////
                        Evaluate(LocationCode, Format(POStaging.fc_location));
                        PurchHeader.Validate("Location Code", LocationCode);
                        Evaluate(ShipAddress1, Format(POStaging.address_line_one));
                        PurchHeader.Validate("Ship-to Address", ShipAddress1);
                        Evaluate(ShipAddress2, Format(POStaging.address_line_two));
                        PurchHeader.Validate("Ship-to Address 2", ShipAddress2);
                        Evaluate(ShipCity, Format(POStaging.city));
                        PurchHeader.Validate("Ship-to City", ShipCity);
                        Evaluate(ShipState, Format((POStaging.state)));
                        PurchHeader.Validate("Ship-to County", ShipState);
                        Evaluate(ShipPostCode, Format(POStaging.pin_code));
                        PurchHeader.Validate("Ship-to Post Code", ShipPostCode);
                        Evaluate(Address, Format(POStaging.address_line1));
                        PurchHeader.Validate("Pay-to Address", Address);
                        Evaluate(Address2, Format(POStaging.address_line2));
                        PurchHeader.Validate("Pay-to Address 2", Address2);
                        Evaluate(City, Format(POStaging.city));
                        PurchHeader.Validate("Pay-to City", City);
                        Evaluate(State, Format(POStaging.state));
                        PurchHeader.Validate("Pay-to County", State);
                        Evaluate(GSTVendorType, Format(POStaging.gst_registered));//
                        PurchHeader.Validate("GST Vendor Type", GSTVendorType);//
                        //PurchHeader.Validate("Document Date", DocumentDate);
                        PurchHeader.Validate(Status, PurchHeader.Status::Open);
                        if Format(POStaging.PO_type2) <> '' then
                            Evaluate(PurchHeader."PO type", Format(POStaging.PO_type2));
                        if PurchHeader.Insert(true) then begin
                            POStaging."Record Status" := POStaging."Record Status"::Created;
                            // POStaging.po_status := true;
                            POStaging.Modify();
                        end;

                        Line_No := 10000;
                        PurchLine.Init();
                        PurchLine."Document Type" := PurchHeader."Document Type";
                        PurchLine."Document No." := PurchHeader."No.";
                        PurchLine."Line No." := Line_No;
                        PurchLine.Validate(Type, PurchLine.Type::Item);
                        PurchLine.Validate("No.", POStaging.product_id);
                        PurchLine.Validate("Unit of Measure", 'PCS');
                        PurchLine.Validate(Quantity, POStaging.Quantity);
                        Evaluate(Quantity, Format(POStaging.Quantity));
                        PurchLine.Validate(Quantity, Quantity);
                        Evaluate(UnitCost, Format(POStaging.cost_to_customer));
                        PurchLine.Validate("Unit Cost", UnitCost);
                        Evaluate(MRP, Format(POStaging.mrp_to_customer));
                        PurchLine.Validate(MRP, MRP);
                        Evaluate(LineDiscountAmount, Format(POStaging.designer_discount));
                        PurchLine.Validate("Line Discount Amount", LineDiscountAmount);
                        PurchLine.Insert(true);
                    end else begin
                        PurchLine.Reset();
                        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                        PurchLine.SetRange("Document No.", PurchHeader."No.");
                        if PurchLine.FindLast() then begin
                            Line_No := PurchLine."Line No." + 10000;
                            PurchLine.Init();
                            PurchLine."Document Type" := PurchHeader."Document Type";
                            PurchLine."Document No." := PurchHeader."No.";
                            PurchLine."Line No." := Line_No;
                            PurchLine.Validate(Type, PurchLine.Type::Item);
                            PurchLine.Validate("No.", POStaging.product_id);
                            PurchLine.Validate("Unit of Measure", 'PCS');
                            PurchLine.Validate(Quantity, POStaging.Quantity);
                            Evaluate(Quantity, Format(POStaging.Quantity));
                            PurchLine.Validate(Quantity, Quantity);
                            Evaluate(UnitCost, Format(POStaging.cost_to_customer));
                            PurchLine.Validate("Unit Cost", UnitCost);
                            Evaluate(MRP, Format(POStaging.mrp_to_customer));
                            PurchLine.Validate(MRP, MRP);
                            Evaluate(LineDiscountAmount, Format(POStaging.designer_discount));
                            PurchLine.Validate("Line Discount Amount", LineDiscountAmount);
                            PurchLine.Insert(true);
                            POStaging."Record Status" := POStaging."Record Status"::Created;
                            // POStaging.po_status := true;
                            POStaging.Modify();
                            // PurchLine.Insert(true);

                        end;
                    end;
                end;
                Last_PONo := POStaging.po_number;
                Last_PoType := Format(POStaging.PO_type2);
                Last_Vendor := Format(POStaging.designer_id);

            until POStaging.Next() = 0;
    end;


    //***Not in use***
    procedure CreateOnlinePO3()
    var
        int: Integer;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        POStaging: Record POStaging;
        PONo: Code[20];
        VendorOrderNo: Code[20];
        VendorShipmentNo: Code[20];
        Orderdate: Date;
        VendorNo: Code[20];
        PromiseReceiptdate: Date;
        ReqReceiptDate: Date;
        Status: Option;
        SystemModifiedAt: Code[20];
        LocationCode: Code[10];
        ShipAddress1: Text[250];
        ShipAddress2: Text[50];
        ShipCity: Text[50];
        ShipState: Text[50];
        ShipPostCode: Code[20];
        DocumentDate: Date;
        Line_No: Integer;
        Address: Text[50];
        Address2: Text[50];
        City: Text[50];
        State: Text[50];
        PostCode: Code[20];
        GSTVendorType: Option;
        Quantity: Decimal;
        UnitCost: Decimal;
        MRP: Decimal;
        LineDiscountAmount: Decimal;
        recVendor: Record Vendor;
        CurrVendor: Code[20];
        CurrPOtype: Text;
        LastPotype: Text;
        LastVendor: Code[20];
    begin
        POStaging.Reset();
        POStaging.SetCurrentKey(designer_id, PO_type2);
        POStaging.SetRange("Record Status", POStaging."Record Status"::Created);
        // POStaging.SetRange(po_status, false);
        if POStaging.FindSet(true) then begin
            repeat
                CurrVendor := Format(POStaging.designer_id);
                CurrPOtype := Format(POStaging.PO_type2);
                if (LastVendor <> CurrVendor) or (CurrPotype <> LastPOtype) then begin
                    if not recVendor.get(CurrVendor) then
                        Error('Vendor doesn''t exist with no %1', CurrVendor);
                    Evaluate(PONo, Format(POStaging.id));
                    // PurchHeader.Reset();
                    // PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
                    // PurchHeader.SetRange("No.", PONo);
                    // if not PurchHeader.FindFirst() then begin
                    PurchHeader.Init();
                    PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
                    PurchHeader.Validate("No.", PONo);
                    Evaluate(VendorNo, Format(POStaging.designer_id));
                    PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
                    Evaluate(VendorOrderNo, Format(POStaging.order_number));
                    PurchHeader.Validate("Vendor Order No.", VendorOrderNo);
                    Evaluate(VendorShipmentNo, Format((POStaging.order_detail_id)));
                    PurchHeader.Validate("Vendor Shipment No.", VendorShipmentNo);
                    Evaluate(Orderdate, Format(POStaging.order_date));
                    PurchHeader.Validate("Order Date", Orderdate);
                    // Evaluate(VendorNo, Format(POStaging.parent_designer_id));
                    // PurchHeader.Validate("Vendor Order No.", VendorNo);
                    Evaluate(PromiseReceiptdate, Format(POStaging.delivery_date));
                    PurchHeader.Validate("Promised Receipt Date", PromiseReceiptdate);
                    // Evaluate(ReqReceiptDate, Format((POStaging.order_delivery_date)));
                    // PurchHeader.Validate("Requested Receipt Date", ReqReceiptDate);
                    // Evaluate(Status, Format(POStaging.Status));
                    // PurchHeader.Validate(Status, Status);
                    // Evaluate(SystemModifiedAt, Format(POStaging.date_modified));
                    // PurchHeader.Validate(SystemModifiedBy, SystemModifiedAt);
                    Evaluate(LocationCode, Format(POStaging.fc_location));
                    PurchHeader.Validate("Location Code", LocationCode);
                    Evaluate(ShipAddress1, Format(POStaging.address_line_one));
                    PurchHeader.Validate("Ship-to Address", ShipAddress1);
                    Evaluate(ShipAddress2, Format(POStaging.address_line_two));
                    PurchHeader.Validate("Ship-to Address 2", ShipAddress2);
                    Evaluate(ShipCity, Format(POStaging.city));
                    PurchHeader.Validate("Ship-to City", ShipCity);
                    Evaluate(ShipState, Format((POStaging.state)));
                    PurchHeader.Validate("Ship-to County", ShipState);
                    Evaluate(ShipPostCode, Format(POStaging.pin_code));
                    PurchHeader.Validate("Ship-to Post Code", ShipPostCode);
                    Evaluate(Address, Format(POStaging.address_line1));
                    PurchHeader.Validate("Pay-to Address", Address);
                    Evaluate(Address2, Format(POStaging.address_line2));
                    PurchHeader.Validate("Pay-to Address 2", Address2);
                    Evaluate(City, Format(POStaging.city));
                    PurchHeader.Validate("Pay-to City", City);
                    Evaluate(State, Format(POStaging.state));
                    PurchHeader.Validate("Pay-to County", State);
                    // Evaluate(GSTVendorType, Format(POStaging.gst_registered));
                    // PurchHeader.Validate("GST Vendor Type", GSTVendorType);
                    //PurchHeader.Validate("Document Date", DocumentDate);
                    PurchHeader.Validate(Status, PurchHeader.Status::Open);
                    if Format(POStaging.PO_type2) <> '' then
                        Evaluate(PurchHeader."PO type", Format(POStaging.PO_type2));
                    if PurchHeader.Insert() then begin
                        POStaging."Record Status" := POStaging."Record Status"::Created;
                        // POStaging.po_status := true;
                        POStaging.Modify();
                    end;

                    Line_No := 10000;
                    PurchLine.Init();
                    PurchLine."Document Type" := PurchHeader."Document Type";
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine."Line No." := Line_No;
                    PurchLine.Validate(Type, PurchLine.Type::Item);
                    PurchLine.Validate("No.", POStaging.product_id);
                    PurchLine.Validate("Unit of Measure", 'PCS');
                    PurchLine.Validate(Quantity, POStaging.Quantity);
                    Evaluate(Quantity, Format(POStaging.Quantity));
                    PurchLine.Validate(Quantity, Quantity);
                    Evaluate(UnitCost, Format(POStaging.cost_to_customer));
                    PurchLine.Validate("Unit Cost", UnitCost);
                    Evaluate(MRP, Format(POStaging.mrp_to_customer));
                    PurchLine.Validate(MRP, MRP);
                    Evaluate(LineDiscountAmount, Format(POStaging.designer_discount));
                    PurchLine.Validate("Line Discount Amount", LineDiscountAmount);
                    //PurchLine.Insert(true);
                    // end;
                end else begin
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                    PurchLine.SetRange("Document No.", PurchHeader."No.");
                    if PurchLine.FindLast() then begin
                        Line_No := PurchLine."Line No." + 10000;
                        PurchLine.Init();
                        PurchLine."Document Type" := PurchHeader."Document Type";
                        PurchLine."Document No." := PurchHeader."No.";
                        PurchLine."Line No." := Line_No;
                        PurchLine.Validate(Type, PurchLine.Type::Item);
                        PurchLine.Validate("No.", POStaging.product_id);
                        PurchLine.Validate("Unit of Measure", 'PCS');
                        PurchLine.Validate(Quantity, POStaging.Quantity);
                        Evaluate(Quantity, Format(POStaging.Quantity));
                        PurchLine.Validate(Quantity, Quantity);
                        Evaluate(UnitCost, Format(POStaging.cost_to_customer));
                        PurchLine.Validate("Unit Cost", UnitCost);
                        Evaluate(MRP, Format(POStaging.mrp_to_customer));
                        PurchLine.Validate(MRP, MRP);
                        Evaluate(LineDiscountAmount, Format(POStaging.designer_discount));
                        PurchLine.Validate("Line Discount Amount", LineDiscountAmount);

                    end;
                end;
                LastVendor := Format(POStaging.designer_id);
                LastPotype := Format(POStaging.PO_type2);
                PurchLine.Insert(true);
            until POStaging.Next() = 0;
        end;
    end;

    procedure ProcessOnlinePOs()
    var
        recPOStaging: Record POStaging;
        errorLog: Record ErrorCapture;
        recPOStaging1: Record POStaging;
        recPurchHeader: Record "Purchase Header";
        txtBarcode: text;
        errorFound: Boolean;
        cuFunctions: Codeunit Functions;
        PoStag: Record POStaging;
        ItemTest: Record Item;
    begin
        recPOStaging.Reset();
        recPOStaging.SetCurrentKey(po_number, designer_id, PO_type2);
        recPOStaging.SetRange("Record Status", recPOStaging."Record Status"::" ");
        if recPOStaging.Find('-') then
            repeat
                Clear(txtBarcode);
                if StrLen(recPOStaging.barcode) > 20 then
                    txtBarcode := CopyStr(recPOStaging.barcode, StrLen(recPOStaging.barcode) - 20 + 1)
                else
                    txtBarcode := recPOStaging.barcode;
                //   if CheckItemApproveForSale(recPOStaging) then begin
                Commit();
                if not CreateOnlinePO4.Run(recPOStaging) then begin
                    //cuFunctions.CreateErrorLog(2, '', recPOStaging."Entry No.", recPOStaging.designer_id, txtBarcode, recPOStaging.po_number);
                    cuFunctions.CreateErrorLogPO('', recPOStaging."Entry No.", recPOStaging.designer_id, txtBarcode, recPOStaging.po_number);
                    errorFound := true;
                    // recPOStaging1.Get(recPOStaging."Entry No.");
                    recPOStaging1.Get(recPOStaging.po_number, txtBarcode);
                    recPOStaging1."Record Status" := recPOStaging1."Record Status"::Error;
                    recPOStaging1.Modify();
                    // if recPurchHeader.get(recPOStaging1.po_number) then
                    //     recPurchHeader.Delete();//Deleting header in case line creation resulted in exception 270123
                    recPurchHeader.Reset();
                    recPurchHeader.SetRange("Document Type", recPurchHeader."Document Type"::Order);
                    recPurchHeader.SetRange("No.", recPOStaging1.po_number);
                    if recPurchHeader.FindFirst() then
                        recPurchHeader.Delete();
                end else
                    glPOcreated := true;
            // end else begin
            //     cuFunctions.CreateErrorLog(2, '', recPOStaging."Entry No.", recPOStaging.designer_id, txtBarcode, recPOStaging.po_number);
            // end;
            until recPOStaging.Next() = 0;

        //For errors        
        /*recPOStaging.Reset();
        recPOStaging.SetCurrentKey(po_number, designer_id, PO_type2);
        recPOStaging.SetRange("Record Status", recPOStaging."Record Status"::Error);
        recPOStaging.SetRange("Error Date", Today - 2, Today);
        if recPOStaging.Find('-') then
            repeat
                if not CreateOnlinePO4(recPOStaging) then begin
                    cuFunctions.CreateErrorLog(2, '', recPOStaging."Entry No.", recPOStaging.designer_id, txtBarcode, recPOStaging.po_number);
                    recPOStaging1.Get(recPOStaging."Entry No.");
                    recPOStaging1."Record Status" := recPOStaging1."Record Status"::Error;
                    recPOStaging1."Error Date" := Today;
                    recPOStaging1.Modify();
                    // if recPurchHeader.get(recPOStaging1.po_number) then
                    //     recPurchHeader.Delete();//Deleting header in case line creation resulted in exception 270123
                    recPurchHeader.Reset();
                    recPurchHeader.SetRange("Document Type", recPurchHeader."Document Type"::Order);
                    recPurchHeader.SetRange("No.", recPOStaging1.po_number);
                    if recPurchHeader.FindFirst() then
                        recPurchHeader.Delete();
                end else
                    glPOcreated := true;
            until recPOStaging.Next() = 0;*/

        if glPOcreated then
            Message('Purchase Order created')
        else
            Message(' No Purchase Order created');

    end;

    [TryFunction]
    procedure CheckItemApproveForSale(recPOStaging: Record POStaging)
    var
        // recPOStaging: Record POStaging;
        errorLog: Record ErrorCapture;
        recPOStaging1: Record POStaging;
        recPurchHeader: Record "Purchase Header";
        txtBarcode: text;
        errorFound: Boolean;
        cuFunctions: Codeunit Functions;
        PoStag: Record POStaging;
        ItemTest: Record Item;
    begin
        PoStag.Reset();
        PoStag.SetRange("Record Status", PoStag."Record Status"::" ");
        PoStag.SetRange(po_number, recPOStaging.po_number);
        if PoStag.FindSet() then
            repeat
                Clear(txtBarcode);
                if StrLen(recPOStaging.barcode) > 20 then
                    txtBarcode := CopyStr(recPOStaging.barcode, StrLen(recPOStaging.barcode) - 20 + 1)
                else
                    txtBarcode := recPOStaging.barcode;

                if ItemTest.Get(txtBarcode) then
                    if not (ItemTest."fc location" = 'ONL') or (ItemTest."fc location" = 'KWH') or (ItemTest."fc location" = 'AOD') or (ItemTest."fc location" = 'AOM') or (ItemTest."fc location" = 'AOM15') then
                        if ItemTest."Is Approved for Sale" = false then
                            Error('Item %1 is not approved for sale', ItemTest."No.");
            //  cuFunctions.CreateErrorLog(2, '', recPOStaging."Entry No.", recPOStaging.designer_id, txtBarcode, recPOStaging.po_number);
            until PoStag.Next() = 0;
    end;

    //[TryFunction]



    procedure ProcessCustomers()
    var
        recCustStaging: Record CustomerStaging;
        recErrorLog: Record ErrorCapture;
        errorFound: Boolean;
        recCustomer: Record 18;
        recCustStaging1: Record CustomerStaging;
    begin
        recCustStaging.Reset();
        recCustStaging.SetRange(Record_Status, recCustStaging.Record_Status::" ");
        if recCustStaging.Find('-') then
            repeat
                Commit();
                if not CreateCustomer.Run(recCustStaging) then begin
                    // cuFunctions.CreateErrorLog(4, '', recCustStaging."Entry No.", format(recCustStaging.site_user_id), '', '');
                    cuFunctions.CreateErrorLogCustVend(4, '', recCustStaging."Entry No.", format(recCustStaging.site_user_id), '', '');
                    errorFound := true;//CITS_RS 150223
                    recCustStaging1.Get(recCustStaging."Entry No.");
                    recCustStaging1.Record_Status := recCustStaging1.Record_Status::Error;
                    recCustStaging1."Error Date" := Today;
                    recCustStaging1.Modify();
                    if recCustomer.get(recCustStaging.site_user_id) then
                        recCustomer.Delete();

                end;
            until recCustStaging.Next() = 0;


        //For errors
        /*recCustStaging.Reset();
        recCustStaging.SetRange(Record_Status, recCustStaging.Record_Status::Error);
        recCustStaging.SetRange("Error Date", Today - 2, Today);
        if recCustStaging.Find('-') then
            repeat
                if not CreateCustomer(recCustStaging) then begin
                    cuFunctions.CreateErrorLog(4, '', recCustStaging."Entry No.", format(recCustStaging.site_user_id), '', '');
                    recCustStaging1.Get(recCustStaging."Entry No.");
                    recCustStaging1.Record_Status := recCustStaging1.Record_Status::Error;
                    recCustStaging1."Error Date" := Today;
                    recCustStaging1.Modify();
                    if recCustomer.get(recCustStaging.site_user_id) then
                        recCustomer.Delete();
                end else begin
                    recCustStaging.Record_Status := recCustStaging.Record_Status::Created;
                    recCustStaging.Modify();
                    recErrorLog.Reset();
                    recErrorLog.SetRange("Source Entry No.", recCustStaging."Entry No.");
                    //recErrorLog.SetRange();
                    if recErrorLog.FindSet() then
                        repeat
                            recErrorLog.Delete();
                        until recErrorLog.Next() = 0;
                end;
            until recCustStaging.Next() = 0;*/
    end;

    //[TryFunction]


    //procedure UpdateCustomer(RecCustStage: Record custo)

    var
        CreateCustomer: Codeunit CreateCustomer;
        CreateOnlinePO4: Codeunit CreateOnlinePO;
        Blank: Integer;

        glLastVend: code[30];

        glPurchDocNum: Code[50];
        cuFunctions: Codeunit Functions;
        glLastLOcation: Code[30];
        // glPONumber: code[30];

        glPOType: Text[30];
        glPOcreated: Boolean;

        glDocType: Text[10];
    //JobQueueEnt: Record "Job Queue Entry";
}