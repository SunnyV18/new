codeunit 50123 CreateOnlinePO
{
    TableNo = POStaging;

    trigger OnRun()
    begin
        CreateOnlinePO4(Rec);
    end;

    var

        glLastVend: code[30];

        glPurchDocNum: Code[50];
        cuFunctions: Codeunit Functions;
        glLastLOcation: Code[30];
        // glPONumber: code[30];

        glPOType: Text[30];
        glPOcreated: Boolean;

        glDocType: Text[10];

    procedure CreateOnlinePO4(Var POStaging: Record POStaging)
    var
        int: Integer;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        // POStaging: Record POStaging;
        PONo: Code[20];
        VendorOrderNo: Code[20];
        VendorShipmentNo: Code[20];
        recPurchHeader: Record 38;
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
        enumDocType: Enum "Document Type Enum";
        POcreated: Boolean;
        PHeader: Record "Purchase Header";
        TabLocation: Record Location;
        txtBarcode: text;
        recItem: Record 27;
        FCLocation: Integer;
        ItemTest: Record Item;
        PoStag: Record POStaging;
    begin

        Clear(txtBarcode);
        if StrLen(POStaging.barcode) > 20 then
            txtBarcode := CopyStr(POStaging.barcode, StrLen(POStaging.barcode) - 20 + 1)
        else
            txtBarcode := POStaging.barcode;

        POcreated := false;
        Clear(glPOcreated);
        // POStaging.Reset();
        // POStaging.SetCurrentKey(po_number, designer_id, PO_type2);
        // //POStaging.SetFilter(po_number, '1011|1012|1013');
        // POStaging.SetRange(po_status, false);
        // if POStaging.FindSet() then
        //     repeat
        //Message('%1', POStaging.id);


        Curr_PONo := POStaging.po_number;
        Curr_PoType := Format(POStaging.PO_type2);
        Curr_Vendor := Format(POStaging.designer_id);

        // if (Curr_PONo <> Last_PONo) OR (Curr_Vendor <> Last_Vendor) OR (Curr_PoType <> Last_PoType) then begin
        if (glLastVend <> Curr_Vendor) or (glPurchDocNum <> Curr_PONo) Or (glPOType <> Curr_PoType) then begin
            Evaluate(PONo, Format(POStaging.po_number));
            PurchHeader.Reset();
            PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
            PurchHeader.SetRange("No.", PONo);
            if not PurchHeader.FindFirst() then begin
                PurchHeader.Init();
                PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
                PurchHeader.Validate("No.", PONo);
                PurchHeader.Insert(true);//CITS_RS 140323 
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
                // Evaluate(ReqReceiptDate, Format((POStaging.order_delivery_date)));//comment>>
                // PurchHeader.Validate("Requested Receipt Date", ReqReceiptDate);
                // Evaluate(Status, Format(POStaging.Status));
                // PurchHeader.Validate(Status, Status);
                PurchHeader.Validate(SystemModifiedAt, POStaging.date_modified);//<<
                if POStaging.fc_location = '' then Error('FC Location is empty');  //>>>>>>>>>>  commented170623AS                                               //PurchHeader.Validate("fc location", POStaging.fc_location);
                Evaluate(FCLocation, POStaging.fc_location);
                TabLocation.Reset();
                TabLocation.SetRange("fc_location ID", FCLocation);
                if TabLocation.FindFirst() then
                    PurchHeader."fc location" := TabLocation.Code
                else
                    Error('FC location %1 not found in the system !', FCLocation);////<<<<<<<<<
                                                                                  //PurchHeader."fc location" := 'ONL';

                // Evaluate(LocationCode, Format(POStaging.fc_location));
                //PurchHeader.Validate("Location Code", LocationCode);
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
                // Evaluate(GSTVendorType, Format(POStaging.gst_registered));//>>
                // PurchHeader.Validate("GST Vendor Type", GSTVendorType);//<<
                //PurchHeader.Validate("Document Date", DocumentDate);
                //PurchHeader.Validate("Vendor GST Reg. No.", POStaging.gst_no);//<<
                //Attributes>>
                PurchHeader.Validate("Parent Designer Id", Format(POStaging.parent_designer_id));
                PurchHeader.Validate("F Team Approval", POStaging.f_team_approval);
                PurchHeader.Validate("F Team Approval date", POStaging.f_team_approval_date);
                PurchHeader.Validate("F Team Remark", POStaging.f_team_remark);
                PurchHeader.Validate("Po Excelsheet Name", POStaging.po_excelsheet_name);
                PurchHeader.Validate("Is Alter Po", POStaging.is_alter_po);
                PurchHeader.Validate("Is Email Sent", POStaging.is_email_sent);
                PurchHeader.Validate("Date Added", POStaging.date_added);
                PurchHeader.Validate("Po Status", POStaging.po_status);
                PurchHeader.Validate("Po Sent Date", POStaging.po_sent_date);
                PurchHeader.Validate("Modified by", POStaging.modified_by);
                PurchHeader.Validate("Merchandiser Name", POStaging.merchandiser_name);
                //Attributes<<
                PurchHeader."Location Code" := 'ONL'; //added170623
                PurchHeader.Validate(Status, PurchHeader.Status::Open);
                if Format(POStaging.PO_type2) <> '' then
                    Evaluate(PurchHeader."PO type", Format(POStaging.PO_type2));
                //PurchHeader."Location Code" := POStaging.fc_location;
                if PurchHeader.Modify(false) then begin
                    //POStaging."Record Status" := POStaging."Record Status"::Created;
                    // POStaging.po_status := true;//150223 Data type changed to code for po_status field
                    POStaging."Record Status" := POStaging."Record Status"::Created;
                    POStaging.Modify();
                    POcreated := true;
                    // glPOcreated := true;
                    // PHeader.Reset(); ///comented170623
                    // PHeader.SetRange("No.", PurchHeader."No.");
                    // PHeader.SetRange("Document Type", PurchHeader."Document Type");
                    // if PHeader.FindFirst() then begin
                    //     if POStaging.fc_location = '' then Error('FC Location is empty');
                    //     Evaluate(FCLocation, POStaging.fc_location);
                    //     TabLocation.Reset();
                    //     TabLocation.SetRange("fc_location ID", FCLocation);
                    //     if TabLocation.FindFirst() then
                    //         PHeader."Location Code" := TabLocation.Code
                    //     else
                    //         Error('FC location %1 not found in the system !', FCLocation);
                    //     PHeader.Modify();
                    // end;
                end;
                //Message('Purchase order %1 Created', POStaging.po_number);
                Line_No := 10000;
                PurchLine.Init();
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := Line_No;
                PurchLine.Validate(Type, PurchLine.Type::Item);
                glPurchDocNum := PurchHeader."No.";
                glDocType := format(PurchHeader."Document Type");
                // PurchLine.Validate("No.", POStaging.product_id);//as discussed on 070223
                PurchLine.Validate("No.", txtBarcode);
                PurchLine.Validate("Unit of Measure", 'PCS');
                PurchLine.Validate(Quantity, POStaging.Quantity);
                Evaluate(UnitCost, Format(POStaging.cost_to_customer));
                if (UnitCost = 0) or (UnitCost = 1) then
                    Error('Direct unit Cost should not equal to 0 or 1');
                PurchLine.Validate("Direct Unit Cost", UnitCost);
                Evaluate(MRP, Format(POStaging.mrp_to_customer));
                PurchLine.Validate(MRP, MRP);
                //PurchLine."Location Code" := POStaging.fc_location;
                if POStaging.fc_location = '' then Error('FC Location is empty');
                Evaluate(FCLocation, POStaging.fc_location);
                TabLocation.Reset();
                TabLocation.SetRange("fc_location ID", FCLocation);
                if TabLocation.FindFirst() then
                    PurchLine."Location Code" := TabLocation.Code
                else
                    Error('FC location %1 not found in the system !', FCLocation);
                Evaluate(LineDiscountAmount, Format(POStaging.designer_discount));
                PurchLine.Validate("Line Discount %", LineDiscountAmount);
                PurchLine.Validate("Qty. to Receive", 0);
                PurchLine.Insert(true);
                if recItem.Get(txtBarcode) then begin
                    recItem."PO No." := PurchLine."Document No.";
                    recItem.Modify();
                end;
            end else begin                             //added120123
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
                    PurchLine.Validate("No.", txtBarcode);
                    PurchLine.Validate("Unit of Measure", 'PCS');
                    PurchLine.Validate(Quantity, POStaging.Quantity);
                    // Evaluate(Quantity, Format(POStaging.Quantity));
                    // PurchLine.Validate(Quantity, Quantity);
                    Evaluate(UnitCost, Format(POStaging.cost_to_customer));
                    if (UnitCost = 0) or (UnitCost = 1) then
                        Error('Direct unit Cost should not equal to 0 or 1');
                    PurchLine.Validate("Direct Unit Cost", UnitCost);
                    Evaluate(MRP, Format(POStaging.mrp_to_customer));
                    PurchLine.Validate(MRP, MRP);
                    //PurchLine.Validate("Location Code", POStaging.fc_location);
                    //PurchLine."Location Code" := POStaging.fc_location;
                    Evaluate(FCLocation, POStaging.fc_location);
                    if POStaging.fc_location = '' then Error('FC Location is empty');
                    TabLocation.Reset();
                    TabLocation.SetRange("fc_location ID", FCLocation);
                    if TabLocation.FindFirst() then
                        PurchLine."Location Code" := TabLocation.Code
                    else
                        Error('FC location %1 not found in the system', FCLocation);
                    Evaluate(LineDiscountAmount, Format(POStaging.designer_discount));
                    PurchLine.Validate("Line Discount %", LineDiscountAmount);
                    PurchLine.Validate("Qty. to Receive", 0);
                    PurchLine.Insert(true);
                    POStaging."Record Status" := POStaging."Record Status"::Created;
                    POStaging.Modify();
                    if recItem.Get(txtBarcode) then begin
                        recItem."PO No." := PurchLine."Document No.";
                        recItem.Modify();
                    end;

                end;
            end;
            // else begin
            //     Message('Purchase Order not created');
            //     // Error('Data should matches the validation to equivalant on PO Number,Vendor No. and Po Type');
            // end;
        end else begin
            evaluate(enumDocType, glDocType);
            PurchLine.Reset();
            // PurchLine.SetRange("Document Type", PurchHeader."Document Type");
            // PurchLine.SetRange("Document No.", PurchHeader."No.");
            PurchLine.SetRange("Document Type", enumDocType);
            PurchLine.SetRange("Document No.", glPurchDocNum);
            if PurchLine.FindLast() then begin
                Line_No := PurchLine."Line No." + 10000;
                PurchLine.Init();
                // PurchLine."Document Type" := PurchHeader."Document Type";
                // PurchLine."Document No." := PurchHeader."No.";
                // PurchLine."Line No." := Line_No;
                recPurchHeader.get(1, glPurchDocNum);//CITS_RS 130423
                PurchLine."Document Type" := recPurchHeader."Document Type";
                PurchLine."Document No." := recPurchHeader."No.";
                PurchLine."Line No." := Line_No;
                PurchLine.Validate(Type, PurchLine.Type::Item);
                // PurchLine.Validate("No.", POStaging.product_id);// as discssed on 070223
                PurchLine.Validate("No.", txtBarcode);
                PurchLine.Validate("Unit of Measure", 'PCS');
                PurchLine.Validate(Quantity, POStaging.Quantity);
                // Evaluate(Quantity, Format(POStaging.Quantity));
                // PurchLine.Validate(Quantity, Quantity);
                Evaluate(UnitCost, Format(POStaging.cost_to_customer));
                if (UnitCost = 0) or (UnitCost = 1) then
                    Error('Direct unit Cost should not equal to 0 or 1');
                PurchLine.Validate("Direct Unit Cost", UnitCost);
                //PurchLine.Validate("Direct Unit Cost", UnitCost);
                Evaluate(MRP, Format(POStaging.mrp_to_customer));
                PurchLine.Validate(MRP, MRP);
                //PurchLine.Validate("Location Code", POStaging.fc_location);
                //PurchLine."Location Code" := POStaging.fc_location;
                Evaluate(FCLocation, POStaging.fc_location);
                if POStaging.fc_location = '' then Error('FC Location is empty');
                TabLocation.Reset();
                TabLocation.SetRange("fc_location ID", FCLocation);
                if TabLocation.FindFirst() then
                    PurchLine."Location Code" := TabLocation.Code
                else
                    Error('FC location %1 not found in the system', FCLocation);
                Evaluate(LineDiscountAmount, Format(POStaging.designer_discount));
                PurchLine.Validate("Line Discount %", LineDiscountAmount);
                PurchLine.Validate("Qty. to Receive", 0);
                PurchLine.Insert(true);
                POStaging."Record Status" := POStaging."Record Status"::Created;
                POStaging."Record Status" := POStaging."Record Status"::Created;
                // POStaging.po_status := true;
                POStaging.Modify();

                if recItem.Get(txtBarcode) then begin
                    recItem."PO No." := PurchLine."Document No.";
                    recItem.Modify();
                    // PurchLine.Insert(true);
                end;
            end;

            Last_PONo := POStaging.po_number;
            Last_PoType := Format(POStaging.PO_type2);
            Last_Vendor := Format(POStaging.designer_id);


            // until POStaging.Next() = 0;
        end;
        glPurchDocNum := POStaging.po_number;
        glPOType := Format(POStaging.PO_type2);
        glLastVend := Format(POStaging.designer_id);
    end;
}