codeunit 50111 SalesOrderCreation
{
    trigger OnRun()
    begin
        ProcessSalesOrders();
    end;

    procedure ProcessSalesOrders()
    var
        recSOStaging: Record SalesOrder_Staging;
        recTaxTrans: Record "LSCIN Tax Transaction Value";
        recTaxTranssValue: Record "Tax Transaction Value";
        errorFound: Boolean;
        cuFunctions: Codeunit Functions;
        errorlog: Record ErrorCapture;

    begin
        ClearLastError();
        recSOStaging.Reset();
        recSOStaging.SetRange("Record Status", recSOStaging."Record Status"::" ");
        if recSOStaging.Find('-') then
            repeat
                //if not CreateSalesOrder(recSOStaging) then begin
                if not CreateSalesOrder(recSOStaging) or (GetLastErrorText() <> '') then begin
                    //  if GetLastErrorText() <> '' then begin
                    //cuFunctions.CreateErrorLog(7, '', recSOStaging."Entry No.", recSOStaging.site_user_id, '', format(recSOStaging.order_id));
                    cuFunctions.CreateErrorLogSO('', recSOStaging."Entry No.", recSOStaging.site_user_id, '', format(recSOStaging.order_id));
                    errorFound := true;
                    recSOStaging."Record Status" := recSOStaging."Record Status"::Error;
                    recSOStaging."Error Date" := Today;
                    recSOStaging.Modify(false);
                end else begin
                    if boolupdated then
                        recSOStaging."Record Status" := recSOStaging."Record Status"::Updated
                    else
                        recSOStaging."Record Status" := recSOStaging."Record Status"::Created;
                    recSOStaging."SO Created" := true;
                    recSOStaging.Modify();
                end;
            until recSOStaging.Next() = 0;

        //for errors

        /*recSOStaging.Reset();
        recSOStaging.SetRange("Record Status", recSOStaging."Record Status"::Error);
        recSOStaging.SetRange("Error Date", Today - 2, Today);
        if recSOStaging.Find('-') then
            repeat
                if not CreateSalesOrder(recSOStaging) then begin
                    cuFunctions.CreateErrorLog(7, '', recSOStaging."Entry No.", recSOStaging.site_user_id, '', recSOStaging.order_id);
                    recSOStaging."Record Status" := recSOStaging."Record Status"::Error;
                    recSOStaging."Error Date" := Today;
                    recSOStaging.Modify(false);
                end else begin
                    if boolupdated then
                        recSOStaging."Record Status" := recSOStaging."Record Status"::Updated
                    else
                        recSOStaging."Record Status" := recSOStaging."Record Status"::Created;
                    recSOStaging."SO Created" := true;
                    recSOStaging.Modify();
                    errorlog.Reset();
                    errorlog.SetRange("Source Entry No.", recSOStaging."Entry No.");
                    //errorlog.SetRange();
                    if errorlog.FindSet() then
                        repeat
                            errorlog.Delete();
                        until errorlog.Next() = 0;

                end;
            until recSOStaging.Next() = 0;*/
    end;

    [TryFunction]
    procedure CreateSalesOrder(SalesStaging: Record SalesOrder_Staging)
    var
        SalHeader: Record "Sales Header";
        SalesHeaderstat: Record "Sales Header";
        SalesHeaderstat1: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        NOSeriesMgmt: Codeunit NoSeriesManagement;
        SalesReceiveblesetup: Record "Sales & Receivables Setup";
        DetailSalesStaging: Record SalesOrderDtls_Staging;
        SalesLinedlt: Record "Sales Line";
        SalesHeaderdlt: Record "Sales Header";
        totprice: Decimal;
        DocNoVar: Code[20];
        LineNo: Integer;
        NO: Integer;
        HashBool: Boolean;
        Location: Record Location;
        Store: Record "LSC Store";
        FCLocation: Integer;
        Contact: Record Contact;
        ContactNo: Code[20];
        intBarcodeLenght: Integer;
        MarkSetup: Record "Marketing Setup";
        SalesPerson: Record "Salesperson/Purchaser";
        SalesPersoncode: Code[20];
        DetailStaging: Record SalesOrderDtls_Staging;
        Orderid: Integer;
        Country: Record "Country/Region";
        SHeader: Record 36;
        Salesline1: Record 37;
        Salesline2: Record 37;
        Salesline3: Record 37;
        Salesline4: Record 37;
        Salesline5: Record 37;
        SLine: Record 37;
        SLine1: Record 37;
        SLine2: Record 37;
        SLineOP: Record 37;
        SLineMulStatus: Record 37;
        SLineClr: Record 37;
        lineNo1: Integer;
        ItemChargeAssignment: Record "Item Charge Assignment (Sales)";
        ItemChargeAssignment1: Record "Item Charge Assignment (Sales)";
        PurHeader: Record 38;
        PurLine: Record 39;
        ChargeBoo: Boolean;
        PurPaybleSetup: Record "Purchases & Payables Setup";
        Salespost: Codeunit "Sales-Post";
        txtBarcode: Text;
        ShiptoAdd: Record "Ship-to Address";
        Shiptocode: Code[20];
        salesheader1: Record 36;
        salesheader2: Record 36;
        salesheader3: Record 36;
        salesheader4: Record 36;
        ActionStatus1: Record Action_Status_Sales;
        ActionStatus2: Record Action_Status_Sales;
        OrderNo: Integer;
        SalInvhdr: Record "Sales Invoice Header";
        SalInvhdr1: Record "Sales Invoice Header";
        SalInvhdr2: Record "Sales Invoice Header";
        SalInvline: Record "Sales Invoice Line";
        SalInvline1: Record "Sales Invoice Line";
        SalInvline2: Record "Sales Invoice Line";
        ReturnitemFound: Boolean;
        Detailstage: Record SalesOrderDtls_Staging;
        Cust1: Record 18;
        GstGroup: Record "GST Group";
        GSTgc: Code[20];
        Gstrate: Decimal;
        Gstrate1: Decimal;
        HSN: Code[20];
        GSTgc1: Code[20];
        Gstrate2: Decimal;
        HSN1: Code[20];
        LineAmt: Decimal;
        LineAmt1: Decimal;
        TotalDiscPercent: Decimal;
        Subt1: Decimal;
        Subt2: Decimal;
        Item2: Record Item;
        AmtExcluGST: Decimal;
        sos: Page "Sales Order Subform";
        SalesHash: Record "Shipment Action Hash";
        SlineUpdtd: Record 37;
        ItemTest: Record item;
        ItemmTestBool: Boolean;
    begin
        ClearLastError();
        Clear(boolupdated);
        // SalesStaging.Reset();
        // SalesStaging.SetRange("SO Created", false);
        // if SalesStaging.FindSet() then
        //     repeat
        // Evaluate(Orderid, SalesStaging.order_id);
        // ActionStatus1.Reset();
        // ActionStatus1.SetRange(SO_ID, Orderid);
        // ActionStatus1.SetRange(Processed, false);
        // if not ActionStatus1.FindFirst() then
        //     Error('Action Id is not available of this %1 Order Id', SalesStaging.order_id);
        SHeader.Reset();
        SHeader.SetRange("Document Type", SHeader."Document Type"::Order);
        SHeader.SetRange("No.", SalesStaging.order_id);
        if not SHeader.FindFirst() then begin
            SalInvhdr.Reset();
            SalInvhdr.SetRange("Order No.", SalesStaging.order_id);
            if SalInvhdr.FindFirst() then begin
                ReturnitemFound := false;
                Evaluate(SOIDint, SalesStaging.order_id);
                ActionStatus2.Reset();
                ActionStatus2.SetRange(SO_ID, SOIDint);
                ActionStatus2.SetRange(Processed, false);
                if ActionStatus2.FindSet() then
                    repeat
                        SalesHash.Reset();
                        SalesHash.SetRange(hash, ActionStatus2.hash);
                        if SalesHash.FindFirst() then
                            HashBool := true else begin
                            //>>>>>>>>>>>>
                            SalInvhdr.Reset();
                            SalInvhdr.SetRange("Order No.", SalesStaging.order_id);
                            if SalInvhdr.FindSet() then
                                repeat
                                    // Detailstage.Reset();
                                    // Detailstage.SetRange(order_id, ActionStatus2.SO_ID);
                                    // Detailstage.SetRange(order_detail_id, ActionStatus2.SO_Detail_ID);
                                    // if Detailstage.FindFirst() then begin
                                    SalInvline.Reset();
                                    SalInvline.SetRange("Document No.", SalInvhdr."No.");
                                    SalInvline.SetRange(Type, SIL.Type::Item);
                                    // SalInvline.SetRange("No.", Detailstage.barcode);
                                    SalInvline.SetRange("Line No.", ActionStatus2.SO_Detail_ID);
                                    SalInvline.SetRange(Quantity, 1);
                                    if SalInvline.FindFirst() then begin
                                        ReturnitemFound := true;
                                        case ActionStatus2."Action ID" of
                                            7:
                                                begin
                                                    SalesReceiveblesetup.Get();
                                                    SalRetHdr.Init();
                                                    SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                                    SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                                    SalRetHdr.Validate("Sell-to Customer No.", SalInvhdr."Sell-to Customer No.");
                                                    SalRetHdr.Validate(State, SalInvhdr.State);
                                                    SalRetHdr."Sell-to E-Mail" := SalInvhdr."Sell-to E-Mail";
                                                    SalRetHdr."Bill-to Name" := SalInvhdr."Bill-to Name";
                                                    SalRetHdr."Bill-to Address" := SalInvhdr."Bill-to Address";
                                                    SalRetHdr."Bill-to City" := SalInvhdr."Bill-to City";
                                                    SalRetHdr."Bill-to Post Code" := SalInvhdr."Bill-to Post Code";
                                                    SalRetHdr."Bill-to Country/Region Code" := SalInvhdr."Bill-to Country/Region Code";
                                                    SalRetHdr."Ship-to Name" := SalInvhdr."Ship-to Name";
                                                    SalRetHdr."Ship-to Address" := SalInvhdr."Ship-to Address";
                                                    SalRetHdr."Ship-to City" := SalInvhdr."Ship-to City";
                                                    //SalRetHdr."Ship-to Code" := SalInvhdr."Ship-to Code";
                                                    SalRetHdr.Validate("Ship-to Code", SalInvhdr."Ship-to Code");
                                                    SalRetHdr.Validate("GST Bill-to State Code", SalInvhdr."GST Bill-to State Code");
                                                    SalRetHdr."Ship-to Country/Region Code" := SalInvhdr."Ship-to Country/Region Code";
                                                    //SalRetHdr."Location Code" := SalInvhdr."Location Code";//location

                                                    SalRetHdr."Bill-to Contact No." := SalInvhdr."Bill-to Contact No.";
                                                    SalRetHdr."Sell-to Contact No." := SalInvhdr."Sell-to Contact No.";
                                                    SalRetHdr."Salesperson Code" := SalInvhdr."Salesperson Code";
                                                    SalRetHdr.Validate("Location Code", SalInvhdr."Location Code");
                                                    SalRetHdr.Validate("Invoice Discount Value", SalInvhdr."Invoice Discount Value");
                                                    if SalRetHdr.Insert() then begin
                                                        ActionStatus2.Processed := true;
                                                        ActionStatus2.Modify();
                                                    end;
                                                    //>>LINE
                                                    SalRetLine.Init();
                                                    SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                                    SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                                    SalRetLine."Line No." := 10000;
                                                    SalRetLine.Validate(Type, SalInvLine.Type);
                                                    SalRetLine.Validate("No.", SalInvLine."No.");
                                                    SalRetLine."Product Id" := SalInvLine."Product Id";
                                                    SalRetLine."Aza Online Code" := SalInvLine."Aza Online Code";
                                                    SalRetLine."Location Code" := SalInvLine."Location Code";
                                                    // SalRetLine.Quantity := SalInvLine.Quantity;
                                                    SalRetLine.Validate(Quantity, SalInvline.Quantity);
                                                    SalRetLine."Amount Including VAT" := SalInvLine."Amount Including VAT";
                                                    SalRetLine."Discount Percent By Aza" := SalInvLine."Discount Percent By Aza";
                                                    SalRetLine."Discount Percent By Desg" := SalInvLine."Discount Percent By Desg";
                                                    SalRetLine."Promo Discount" := SalInvLine."Promo Discount";
                                                    SalRetLine."Credit By Product" := SalInvLine."Credit By Product";
                                                    SalRetLine."Loyalty By Product" := SalInvLine."Loyalty By Product";
                                                    SalRetLine."Unit Price" := SalInvLine."Unit Price";
                                                    SalRetLine.Amount := SalInvLine.Amount;
                                                    SalRetLine."Unit Cost" := SalInvLine."Unit Cost";
                                                    SalRetLine."SubTotal 1" := SalInvLine."SubTotal 1";
                                                    SalRetLine."SubTotal 2" := SalInvLine."SubTotal 2";
                                                    SalRetLine.Validate("Line Discount Amount", SalInvline."Line Discount Amount");

                                                    SalRetLine."Shipping Status" := SalInvline."Shipping Status";
                                                    SalRetLine."Is Return And Exchange" := SalInvLine."Is Return And Exchange";
                                                    SalRetLine."Shipping Company Name" := SalInvLine."Shipping Company Name";
                                                    SalRetLine."Shipping Company Name RTV" := SalInvLine."Shipping Company Name RTV";
                                                    SalRetLine."Tracking Id" := SalInvLine."Tracking Id";
                                                    SalRetLine."Tracking Id RTV" := SalInvLine."Tracking Id RTV";
                                                    //SalRetLine."Requested Delivery Date" := SalInvLine."Requested Delivery Date";
                                                    SalRetLine."Delivery Date RTV" := SalInvLine."Delivery Date RTV";
                                                    SalRetLine."Track date" := SalInvLine."Track date";
                                                    SalRetLine."Track Date RTV" := SalInvLine."Track Date RTV";
                                                    SalRetLine."Invoice Number" := SalInvLine."Invoice Number";
                                                    SalRetLine."Invoice Number RTV" := SalInvLine."Invoice Number RTV";
                                                    SalRetLine."Dispatch Date " := SalInvLine."Dispatch Date ";
                                                    SalRetLine."In Warehouse" := SalInvLine."In Warehouse";
                                                    SalRetLine."Shipment Date" := SalInvLine."Shipment Date";
                                                    SalRetLine."Ship Date RTV" := SalInvLine."Ship Date RTV";
                                                    SalRetLine."Net Weight" := SalInvLine."Net Weight";
                                                    SalRetLine."Ship Mode" := SalInvLine."Ship Mode";
                                                    SalRetLine."Loyalty Points" := SalInvLine."Loyalty Points";
                                                    SalRetLine."Loyalty Flag" := SalInvLine."Loyalty Flag";
                                                    SalRetLine."Estm Delivery Date" := SalInvLine."Estm Delivery Date";
                                                    SalRetLine."Is Customization Received" := SalInvLine."Is Customization Received";
                                                    SalRetLine."Is Blouse Customization Received" := SalInvLine."Is Blouse Customization Received";
                                                    SalRetLine."Alteration Charges" := SalInvLine."Alteration Charges";
                                                    SalRetLine."Line Amount" := SalInvLine."Unit Price" - SalInvline."Line Discount Amount";
                                                    //SalRetLine.Validate("Line Discount %", SalInvline1."Line Discount %");
                                                    SalRetLine.Insert();
                                                    //<<returnorder
                                                    RefInvNumber.Init();
                                                    RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                    RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                    RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                    RefInvNumber."Reference Invoice Nos." := SalInvline."Document No.";
                                                    RefInvNumber.Verified := true;
                                                    RefInvNumber.Insert();
                                                    //Posting>>
                                                    SalRetHdr.Receive := true;
                                                    SalRetHdr.Invoice := true;
                                                    SalRetHdr.Modify();
                                                    Clear(Salespost);
                                                    Salespost.Run(SalRetHdr);
                                                    Message('Return Order Posted');
                                                    //Hash insertion>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus2.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus2.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus2."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus2.SO_Detail_ID);
                                                    SalesHash.Insert();

                                                    SalInvline."Shipping Status" := 'RETURNED';
                                                    SalInvline.Modify();
                                                    //For status update in SalesShipment
                                                    SSH.Reset();
                                                    SSH.SetRange("Order No.", SalesStaging.order_id);
                                                    if SSH.FindSet() then
                                                        repeat
                                                            Detailstage.Reset();
                                                            Detailstage.SetRange(order_id, ActionStatus2.SO_ID);
                                                            Detailstage.SetRange(order_detail_id, ActionStatus2.SO_Detail_ID);
                                                            if Detailstage.FindFirst() then begin
                                                                SSL.Reset();
                                                                SSL.SetRange("Document No.", SSH."No.");
                                                                SSL.SetRange(Type, SIL.Type::Item);
                                                                SSL.SetRange("No.", Detailstage.barcode);
                                                                //SSL.SetRange(Quantity, 1);
                                                                if SSL.FindFirst() then begin
                                                                    SSL."Shipping Status" := 'RETURNED';
                                                                    SSL.Modify();
                                                                end;
                                                            end;
                                                        until SSH.Next() = 0;
                                                end;
                                            8:
                                                begin
                                                    //>>>>
                                                    SalesReceiveblesetup.Get();
                                                    SalRetHdr.Init();
                                                    SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                                    SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                                    SalRetHdr.Validate("Sell-to Customer No.", SalInvhdr."Sell-to Customer No.");
                                                    SalRetHdr.Validate(State, SalInvhdr.State);
                                                    SalRetHdr."Sell-to E-Mail" := SalInvhdr."Sell-to E-Mail";
                                                    SalRetHdr."Bill-to Name" := SalInvhdr."Bill-to Name";
                                                    SalRetHdr."Bill-to Address" := SalInvhdr."Bill-to Address";
                                                    SalRetHdr."Bill-to City" := SalInvhdr."Bill-to City";
                                                    SalRetHdr."Bill-to Post Code" := SalInvhdr."Bill-to Post Code";
                                                    SalRetHdr."Bill-to Country/Region Code" := SalInvhdr."Bill-to Country/Region Code";
                                                    SalRetHdr."Ship-to Name" := SalInvhdr."Ship-to Name";
                                                    SalRetHdr."Ship-to Address" := SalInvhdr."Ship-to Address";
                                                    SalRetHdr."Ship-to City" := SalInvhdr."Ship-to City";
                                                    SalRetHdr.Validate("Ship-to Code", SalInvhdr."Ship-to Code");
                                                    // SalRetHdr."Ship-to Code" := SalInvhdr."Ship-to Code";
                                                    SalRetHdr."Ship-to Country/Region Code" := SalInvhdr."Ship-to Country/Region Code";
                                                    //SalRetHdr."Location Code" := SalInvhdr."Location Code";//location
                                                    SalRetHdr."Bill-to Contact No." := SalInvhdr."Bill-to Contact No.";
                                                    SalRetHdr."Sell-to Contact No." := SalInvhdr."Sell-to Contact No.";
                                                    SalRetHdr."Salesperson Code" := SalInvhdr."Salesperson Code";
                                                    SalRetHdr.Validate("Location Code", SalInvhdr."Location Code");
                                                    SalRetHdr.Validate("Invoice Discount Value", SalInvhdr."Invoice Discount Value");
                                                    if SalRetHdr.Insert() then begin
                                                        ActionStatus2.Processed := true;
                                                        ActionStatus2.Modify();
                                                    end;
                                                    //>>LINE
                                                    SalRetLine.Init();
                                                    SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                                    SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                                    SalRetLine."Line No." := 10000;
                                                    SalRetLine.Validate(Type, SalInvLine.Type);
                                                    SalRetLine.Validate("No.", SalInvLine."No.");
                                                    SalRetLine."Product Id" := SalInvLine."Product Id";
                                                    SalRetLine."Aza Online Code" := SalInvLine."Aza Online Code";
                                                    SalRetLine."Location Code" := SalInvLine."Location Code";
                                                    // SalRetLine.Validate(Quantity, SalInvline.Quantity);
                                                    // SalRetLine.Validate("Unit Price", SalInvLine."Unit Price");
                                                    // SalRetLine.Validate("Unit Cost", SalInvLine."Unit Cost");
                                                    // SalRetLine.Validate(Amount, SalInvLine.Amount);
                                                    // SalRetLine."Amount Including VAT" := SalInvLine."Amount Including VAT";
                                                    // SalRetLine.validate("Line Discount %", SalInvLine."Line Discount %");
                                                    // SalRetLine."Discount Percent By Aza" := SalInvLine."Discount Percent By Aza";
                                                    // SalRetLine."Discount Percent By Desg" := SalInvLine."Discount Percent By Desg";
                                                    // SalRetLine."Promo Discount" := SalInvLine."Promo Discount";
                                                    // SalRetLine."Credit By Product" := SalInvLine."Credit By Product";
                                                    // SalRetLine."Loyalty By Product" := SalInvLine."Loyalty By Product";
                                                    // SalRetLine.Quantity := SalInvLine.Quantity;
                                                    SalRetLine.Validate(Quantity, SalInvline.Quantity);
                                                    SalRetLine."Amount Including VAT" := SalInvLine."Amount Including VAT";
                                                    SalRetLine."Discount Percent By Aza" := SalInvLine."Discount Percent By Aza";
                                                    SalRetLine."Discount Percent By Desg" := SalInvLine."Discount Percent By Desg";
                                                    SalRetLine."Promo Discount" := SalInvLine."Promo Discount";
                                                    SalRetLine."Credit By Product" := SalInvLine."Credit By Product";
                                                    SalRetLine."Loyalty By Product" := SalInvLine."Loyalty By Product";
                                                    SalRetLine."Unit Price" := SalInvLine."Unit Price";
                                                    SalRetLine.Amount := SalInvLine.Amount;
                                                    SalRetLine."Unit Cost" := SalInvLine."Unit Cost";
                                                    SalRetLine."SubTotal 1" := SalInvLine."SubTotal 1";
                                                    SalRetLine."SubTotal 2" := SalInvLine."SubTotal 2";
                                                    SalRetLine.Validate("Line Discount Amount", SalInvline."Line Discount Amount");

                                                    SalRetLine."Shipping Status" := SalInvline."Shipping Status";
                                                    SalRetLine."Is Return And Exchange" := SalInvLine."Is Return And Exchange";
                                                    SalRetLine."Shipping Company Name" := SalInvLine."Shipping Company Name";
                                                    SalRetLine."Shipping Company Name RTV" := SalInvLine."Shipping Company Name RTV";
                                                    SalRetLine."Tracking Id" := SalInvLine."Tracking Id";
                                                    SalRetLine."Tracking Id RTV" := SalInvLine."Tracking Id RTV";
                                                    //SalRetLine."Requested Delivery Date" := SalInvLine."Requested Delivery Date";
                                                    SalRetLine."Delivery Date RTV" := SalInvLine."Delivery Date RTV";
                                                    SalRetLine."Track date" := SalInvLine."Track date";
                                                    SalRetLine."Track Date RTV" := SalInvLine."Track Date RTV";
                                                    SalRetLine."Invoice Number" := SalInvLine."Invoice Number";
                                                    SalRetLine."Invoice Number RTV" := SalInvLine."Invoice Number RTV";
                                                    SalRetLine."Dispatch Date " := SalInvLine."Dispatch Date ";
                                                    SalRetLine."In Warehouse" := SalInvLine."In Warehouse";
                                                    SalRetLine."Shipment Date" := SalInvLine."Shipment Date";
                                                    SalRetLine."Ship Date RTV" := SalInvLine."Ship Date RTV";
                                                    SalRetLine."Net Weight" := SalInvLine."Net Weight";
                                                    SalRetLine."Ship Mode" := SalInvLine."Ship Mode";
                                                    SalRetLine."Loyalty Points" := SalInvLine."Loyalty Points";
                                                    SalRetLine."Loyalty Flag" := SalInvLine."Loyalty Flag";
                                                    SalRetLine."Estm Delivery Date" := SalInvLine."Estm Delivery Date";
                                                    SalRetLine."Is Customization Received" := SalInvLine."Is Customization Received";
                                                    SalRetLine."Is Blouse Customization Received" := SalInvLine."Is Blouse Customization Received";
                                                    SalRetLine."Alteration Charges" := SalInvLine."Alteration Charges";
                                                    SalRetLine."Line Amount" := SalInvLine."Unit Price" - SalInvline."Line Discount Amount";
                                                    //SalRetLine.Validate("Line Discount %", SalInvline1."Line Discount %");
                                                    SalRetLine.Insert();
                                                    //<<returnorder
                                                    RefInvNumber.Init();
                                                    RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                    RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                    RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                    RefInvNumber."Reference Invoice Nos." := SalInvline."Document No.";
                                                    RefInvNumber.Verified := true;
                                                    RefInvNumber.Insert();
                                                    //Posting>>
                                                    SalRetHdr.Receive := true;
                                                    SalRetHdr.Invoice := true;
                                                    SalRetHdr.Modify();
                                                    Clear(Salespost);
                                                    Salespost.Run(SalRetHdr);
                                                    Message('Return Order Posted');
                                                    //Hash insertion>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus2.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus2.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus2."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus2.SO_Detail_ID);
                                                    SalesHash.Insert();

                                                    SalInvline."Shipping Status" := 'COD RTO';
                                                    SalInvline.Modify();

                                                    //For status update in SalesShipment
                                                    SSH.Reset();
                                                    SSH.SetRange("Order No.", SalesStaging.order_id);
                                                    if SSH.FindSet() then
                                                        repeat
                                                            Detailstage.Reset();
                                                            Detailstage.SetRange(order_id, ActionStatus2.SO_ID);
                                                            Detailstage.SetRange(order_detail_id, ActionStatus2.SO_Detail_ID);
                                                            if Detailstage.FindFirst() then begin
                                                                SSL.Reset();
                                                                SSL.SetRange("Document No.", SSH."No.");
                                                                SSL.SetRange(Type, SIL.Type::Item);
                                                                SSL.SetRange("No.", Detailstage.barcode);
                                                                //SSL.SetRange(Quantity, 1);
                                                                if SSL.FindFirst() then begin
                                                                    SSL."Shipping Status" := 'COD RTO';
                                                                    SSL.Modify();
                                                                end;
                                                            end;
                                                        until SSH.Next() = 0;
                                                end;
                                            9: //prepaid rto
                                                begin
                                                    //>>>>
                                                    SalesReceiveblesetup.Get();
                                                    SalRetHdr.Init();
                                                    SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                                    SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                                    SalRetHdr.Validate("Sell-to Customer No.", SalInvhdr."Sell-to Customer No.");
                                                    SalRetHdr.Validate(State, SalInvhdr.State);
                                                    SalRetHdr."Sell-to E-Mail" := SalInvhdr."Sell-to E-Mail";
                                                    SalRetHdr."Bill-to Name" := SalInvhdr."Bill-to Name";
                                                    SalRetHdr."Bill-to Address" := SalInvhdr."Bill-to Address";
                                                    SalRetHdr."Bill-to City" := SalInvhdr."Bill-to City";
                                                    SalRetHdr."Bill-to Post Code" := SalInvhdr."Bill-to Post Code";
                                                    SalRetHdr."Bill-to Country/Region Code" := SalInvhdr."Bill-to Country/Region Code";
                                                    SalRetHdr."Ship-to Name" := SalInvhdr."Ship-to Name";
                                                    SalRetHdr."Ship-to Address" := SalInvhdr."Ship-to Address";
                                                    SalRetHdr."Ship-to City" := SalInvhdr."Ship-to City";
                                                    SalRetHdr.Validate("Ship-to Code", SalInvhdr."Ship-to Code");
                                                    //SalRetHdr."Ship-to Code" := SalInvhdr."Ship-to Code";
                                                    SalRetHdr."Ship-to Country/Region Code" := SalInvhdr."Ship-to Country/Region Code";
                                                    //SalRetHdr."Location Code" := SalInvhdr."Location Code";//location
                                                    SalRetHdr."Bill-to Contact No." := SalInvhdr."Bill-to Contact No.";
                                                    SalRetHdr."Sell-to Contact No." := SalInvhdr."Sell-to Contact No.";
                                                    SalRetHdr."Salesperson Code" := SalInvhdr."Salesperson Code";
                                                    SalRetHdr.Validate("Location Code", SalInvhdr."Location Code");
                                                    SalRetHdr.Validate("Invoice Discount Value", SalInvhdr."Invoice Discount Value");
                                                    if SalRetHdr.Insert() then begin
                                                        ActionStatus2.Processed := true;
                                                        ActionStatus2.Modify();
                                                    end;
                                                    // //>>LINE
                                                    // SalRetLine.Init();
                                                    // SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                                    // SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                                    // SalRetLine."Line No." := 10000;
                                                    // SalRetLine.Validate(Type, SalInvLine.Type);
                                                    // SalRetLine.Validate("No.", SalInvLine."No.");
                                                    // SalRetLine."Location Code" := SalInvLine."Location Code";
                                                    // SalRetLine.Validate(Quantity, SalInvLine.Quantity);
                                                    // SalRetLine.Validate("Unit Price", SalInvLine."Unit Price");
                                                    // SalRetLine.Validate("Unit Cost", SalInvLine."Unit Cost");
                                                    // SalRetLine.Validate(Amount, SalInvLine.Amount);
                                                    // SalRetLine."Amount Including VAT" := SalInvLine."Amount Including VAT";
                                                    // SalRetLine.validate("Line Discount %", SalInvLine."Line Discount %");
                                                    // SalRetLine."Shipment Date" := SalInvLine."Shipment Date";
                                                    // SalRetLine."Net Weight" := SalInvLine."Net Weight";
                                                    // if SalRetLine.Insert() then begin
                                                    //     ActionStatus2.Processed := true;
                                                    //     ActionStatus2.Modify();
                                                    // end;
                                                    //>>LINE
                                                    SalRetLine.Init();
                                                    SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                                    SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                                    SalRetLine."Line No." := 10000;
                                                    SalRetLine.Validate(Type, SalInvLine.Type);
                                                    SalRetLine.Validate("No.", SalInvLine."No.");
                                                    SalRetLine."Product Id" := SalInvLine."Product Id";
                                                    SalRetLine."Aza Online Code" := SalInvLine."Aza Online Code";
                                                    SalRetLine."Location Code" := SalInvLine."Location Code";
                                                    SalRetLine.Validate(Quantity, SalInvline.Quantity);
                                                    SalRetLine."Amount Including VAT" := SalInvLine."Amount Including VAT";
                                                    SalRetLine."Discount Percent By Aza" := SalInvLine."Discount Percent By Aza";
                                                    SalRetLine."Discount Percent By Desg" := SalInvLine."Discount Percent By Desg";
                                                    SalRetLine."Promo Discount" := SalInvLine."Promo Discount";
                                                    SalRetLine."Credit By Product" := SalInvLine."Credit By Product";
                                                    SalRetLine."Loyalty By Product" := SalInvLine."Loyalty By Product";
                                                    SalRetLine."Unit Price" := SalInvLine."Unit Price";
                                                    SalRetLine.Amount := SalInvLine.Amount;
                                                    SalRetLine."Unit Cost" := SalInvLine."Unit Cost";
                                                    SalRetLine."SubTotal 1" := SalInvLine."SubTotal 1";
                                                    SalRetLine."SubTotal 2" := SalInvLine."SubTotal 2";
                                                    SalRetLine.Validate("Line Discount Amount", SalInvline."Line Discount Amount");
                                                    SalRetLine."Shipping Status" := SalInvline."Shipping Status";
                                                    SalRetLine."Is Return And Exchange" := SalInvLine."Is Return And Exchange";
                                                    SalRetLine."Shipping Company Name" := SalInvLine."Shipping Company Name";
                                                    SalRetLine."Shipping Company Name RTV" := SalInvLine."Shipping Company Name RTV";
                                                    SalRetLine."Tracking Id" := SalInvLine."Tracking Id";
                                                    SalRetLine."Tracking Id RTV" := SalInvLine."Tracking Id RTV";
                                                    //SalRetLine."Requested Delivery Date" := SalInvLine."Requested Delivery Date";
                                                    SalRetLine."Delivery Date RTV" := SalInvLine."Delivery Date RTV";
                                                    SalRetLine."Track date" := SalInvLine."Track date";
                                                    SalRetLine."Track Date RTV" := SalInvLine."Track Date RTV";
                                                    SalRetLine."Invoice Number" := SalInvLine."Invoice Number";
                                                    SalRetLine."Invoice Number RTV" := SalInvLine."Invoice Number RTV";
                                                    SalRetLine."Dispatch Date " := SalInvLine."Dispatch Date ";
                                                    SalRetLine."In Warehouse" := SalInvLine."In Warehouse";
                                                    SalRetLine."Shipment Date" := SalInvLine."Shipment Date";
                                                    SalRetLine."Ship Date RTV" := SalInvLine."Ship Date RTV";
                                                    SalRetLine."Net Weight" := SalInvLine."Net Weight";
                                                    SalRetLine."Ship Mode" := SalInvLine."Ship Mode";
                                                    SalRetLine."Loyalty Points" := SalInvLine."Loyalty Points";
                                                    SalRetLine."Loyalty Flag" := SalInvLine."Loyalty Flag";
                                                    SalRetLine."Estm Delivery Date" := SalInvLine."Estm Delivery Date";
                                                    SalRetLine."Is Customization Received" := SalInvLine."Is Customization Received";
                                                    SalRetLine."Is Blouse Customization Received" := SalInvLine."Is Blouse Customization Received";
                                                    SalRetLine."Alteration Charges" := SalInvLine."Alteration Charges";
                                                    SalRetLine."Line Amount" := SalInvLine."Unit Price" - SalInvline."Line Discount Amount";
                                                    //SalRetLine.Validate("Line Discount %", SalInvline1."Line Discount %");
                                                    SalRetLine.Insert();
                                                    //<<returnorder
                                                    RefInvNumber.Init();
                                                    RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                    RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                    RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                    RefInvNumber."Reference Invoice Nos." := SalInvline."Document No.";
                                                    RefInvNumber.Verified := true;
                                                    RefInvNumber.Insert();
                                                    //Posting>>
                                                    SalRetHdr.Receive := true;
                                                    SalRetHdr.Invoice := true;
                                                    SalRetHdr.Modify();
                                                    Clear(Salespost);
                                                    Salespost.Run(SalRetHdr);
                                                    Message('Return Order Posted');
                                                    //Hash insertion>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus2.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus2.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus2."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus2.SO_Detail_ID);
                                                    SalesHash.Insert();

                                                    SalInvline."Shipping Status" := 'PREPAID RTO';
                                                    SalInvline.Modify();

                                                    //For status update in SalesShipment
                                                    SSH.Reset();
                                                    SSH.SetRange("Order No.", SalesStaging.order_id);
                                                    if SSH.FindSet() then
                                                        repeat
                                                            Detailstage.Reset();
                                                            Detailstage.SetRange(order_id, ActionStatus2.SO_ID);
                                                            Detailstage.SetRange(order_detail_id, ActionStatus2.SO_Detail_ID);
                                                            if Detailstage.FindFirst() then begin
                                                                SSL.Reset();
                                                                SSL.SetRange("Document No.", SSH."No.");
                                                                SSL.SetRange(Type, SIL.Type::Item);
                                                                SSL.SetRange("No.", Detailstage.barcode);
                                                                //SSL.SetRange(Quantity, 1);
                                                                if SSL.FindFirst() then begin
                                                                    SSL."Shipping Status" := 'PREPAID RTO';
                                                                    SSL.Modify();
                                                                end;
                                                            end;
                                                        until SSH.Next() = 0;
                                                end;
                                            10:                    //DELIVERED
                                                begin
                                                    SalInvline."Shipping Status" := 'DELIVERED';
                                                    if SalInvline.Modify() then begin
                                                        ActionStatus2.Processed := true;
                                                        ActionStatus2.Modify()
                                                    end;

                                                    SSH.Reset();
                                                    SSH.SetRange("Order No.", SalesStaging.order_id);
                                                    if SSH.FindSet() then
                                                        repeat
                                                            Detailstage.Reset();
                                                            Detailstage.SetRange(order_id, ActionStatus2.SO_ID);
                                                            Detailstage.SetRange(order_detail_id, ActionStatus2.SO_Detail_ID);
                                                            if Detailstage.FindFirst() then begin
                                                                SSL.Reset();
                                                                SSL.SetRange("Document No.", SSH."No.");
                                                                SSL.SetRange(Type, SIL.Type::Item);
                                                                SSL.SetRange("No.", Detailstage.barcode);
                                                                //SSL.SetRange(Quantity, 1);
                                                                if SSL.FindFirst() then begin
                                                                    SSL."Shipping Status" := 'DELIVERED';
                                                                    SSL.Modify();
                                                                    //Hash insertion>>>>>>>>>>
                                                                    SalesHash.Init();
                                                                    SalesHash.Validate(hash, ActionStatus2.hash);
                                                                    SalesHash.Validate("So No.", Format(ActionStatus2.SO_ID));
                                                                    SalesHash.Validate("Action ID", ActionStatus2."Action ID");
                                                                    SalesHash.Validate("SO Detail ID", ActionStatus2.SO_Detail_ID);
                                                                    SalesHash.Insert();
                                                                end;
                                                            end;
                                                        until SSH.Next() = 0;
                                                end;
                                            11:                    //QC PASS
                                                begin
                                                    SalInvline."Shipping Status" := 'QC PASS';
                                                    if SalInvline.Modify() then begin
                                                        ActionStatus2.Processed := true;
                                                        ActionStatus2.Modify()
                                                    end;

                                                    SSH.Reset();
                                                    SSH.SetRange("Order No.", SalesStaging.order_id);
                                                    if SSH.FindSet() then
                                                        repeat
                                                            Detailstage.Reset();
                                                            Detailstage.SetRange(order_id, ActionStatus2.SO_ID);
                                                            Detailstage.SetRange(order_detail_id, ActionStatus2.SO_Detail_ID);
                                                            if Detailstage.FindFirst() then begin
                                                                SSL.Reset();
                                                                SSL.SetRange("Document No.", SSH."No.");
                                                                SSL.SetRange(Type, SIL.Type::Item);
                                                                SSL.SetRange("No.", Detailstage.barcode);
                                                                //SSL.SetRange(Quantity, 1);
                                                                if SSL.FindFirst() then begin
                                                                    SSL."Shipping Status" := 'QC PASS';
                                                                    SSL.Modify();
                                                                    //Hash insertion>>>>>>>>>>
                                                                    SalesHash.Init();
                                                                    SalesHash.Validate(hash, ActionStatus2.hash);
                                                                    SalesHash.Validate("So No.", Format(ActionStatus2.SO_ID));
                                                                    SalesHash.Validate("Action ID", ActionStatus2."Action ID");
                                                                    SalesHash.Validate("SO Detail ID", ActionStatus2.SO_Detail_ID);
                                                                    SalesHash.Insert();
                                                                end;
                                                            end;
                                                        until SSH.Next() = 0;
                                                end;
                                            12:                    //PICKED
                                                begin
                                                    SalInvline."Shipping Status" := 'PICKED';
                                                    if SalInvline.Modify() then begin
                                                        ActionStatus2.Processed := true;
                                                        ActionStatus2.Modify()
                                                    end;

                                                    SSH.Reset();
                                                    SSH.SetRange("Order No.", SalesStaging.order_id);
                                                    if SSH.FindSet() then
                                                        repeat
                                                            Detailstage.Reset();
                                                            Detailstage.SetRange(order_id, ActionStatus2.SO_ID);
                                                            Detailstage.SetRange(order_detail_id, ActionStatus2.SO_Detail_ID);
                                                            if Detailstage.FindFirst() then begin
                                                                SSL.Reset();
                                                                SSL.SetRange("Document No.", SSH."No.");
                                                                SSL.SetRange(Type, SIL.Type::Item);
                                                                SSL.SetRange("No.", Detailstage.barcode);
                                                                //SSL.SetRange(Quantity, 1);
                                                                if SSL.FindFirst() then begin
                                                                    SSL."Shipping Status" := 'PICKED';
                                                                    SSL.Modify();
                                                                    //Hash insertion>>>>>>>>>>
                                                                    SalesHash.Init();
                                                                    SalesHash.Validate(hash, ActionStatus2.hash);
                                                                    SalesHash.Validate("So No.", Format(ActionStatus2.SO_ID));
                                                                    SalesHash.Validate("Action ID", ActionStatus2."Action ID");
                                                                    SalesHash.Validate("SO Detail ID", ActionStatus2.SO_Detail_ID);
                                                                    SalesHash.Insert();
                                                                end;
                                                            end;
                                                        until SSH.Next() = 0;
                                                end;
                                        end;
                                    end;
                                //  end;
                                until (SalInvhdr.Next() = 0);// or ReturnitemFound;
                        end;
                    until ActionStatus2.Next() = 0;
                Message('1st action status performed, Posted docs %1', GetLastErrorText());
            end;
            if not ReturnitemFound then begin
                DetailStaging.Reset();
                Evaluate(Orderid, SalesStaging.order_id);
                DetailStaging.SetRange(order_id, Orderid);
                DetailStaging.SetRange("Line Created", false);
                if DetailStaging.FindFirst() then begin
                    SalesReceiveblesetup.Get();
                    MarkSetup.Get();
                    SalHeader.Init();
                    SalHeader.Validate("Document Type", SalHeader."Document Type"::Order);
                    SalHeader."No." := SalesStaging.order_id; //NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Order Nos.", Today, true);
                    Cust1.Get(SalesStaging.site_user_id);
                    SalHeader.Validate("Sell-to Customer No.", SalesStaging.site_user_id);
                    SalHeader."Sell-to E-Mail" := SalesStaging.site_user_email;
                    SalHeader."Bill-to Name" := SalesStaging.billing_name;
                    SalHeader."Bill-to Address" := SalesStaging.billing_address;
                    SalHeader."Bill-to City" := SalesStaging.billing_city;
                    SalHeader."Bill-to Post Code" := SalesStaging.billing_postal_code;

                    Country.Reset();
                    Country.SetRange(Name, SalesStaging.billing_country);
                    if Country.FindFirst() then
                        SalHeader."Bill-to Country/Region Code" := Country.Code;
                    SalHeader."Ship-to Name" := SalesStaging.shipping_name;
                    SalHeader."Ship-to Address" := SalesStaging.shipping_address;
                    SalHeader."Ship-to City" := SalesStaging.shipping_city;
                    ShiptoAdd.Reset();
                    ShiptoAdd.SetRange("Customer No.", SalHeader."Sell-to Customer No.");
                    ShiptoAdd.SetRange("Post Code", SalesStaging.shipping_postal_code);
                    if ShiptoAdd.FindFirst() then
                        SalHeader.Validate("Ship-to Code", ShiptoAdd.Code)
                    else begin
                        ShiptoAdd.Init();
                        ShiptoAdd."Customer No." := SalHeader."Sell-to Customer No.";
                        ShiptoAdd.Code := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Ship to Address no. Series", Today, true);
                        ShiptoAdd."Post Code" := SalesStaging.shipping_postal_code;
                        ShiptoAdd.Name := SalesStaging.shipping_name;
                        shiptoadd.Address := SalesStaging.shipping_address;
                        ShiptoAdd.City := SalesStaging.shipping_city;
                        ShiptoAdd.State := SalesStaging.shipping_state;
                        ShiptoAdd."Phone No." := SalesStaging.shipping_phone;
                        Shiptocode := ShiptoAdd.Code;
                        ShiptoAdd.Insert();
                        SalHeader.Validate("Ship-to Code", Shiptocode);

                    end;
                    Country.Reset();
                    Country.SetRange(Name, SalesStaging.shipping_country);
                    if Country.FindFirst() then
                        SalHeader."Ship-to Country/Region Code" := Country.Code;
                    //SalHeader."Ship email":=SalesStaging.shipping_email);
                    SalHeader.Validate("Billing Locality", SalesStaging.billing_locality);
                    SalHeader.Validate("Billing State", SalesStaging.billing_state);
                    SalHeader.Validate("Billing Email", SalesStaging.billing_email);
                    SalHeader.Validate("Billing Landmark", SalesStaging.billing_landmark);
                    SalHeader.Validate("Shipping Locality", SalesStaging.shipping_locality);
                    SalHeader.Validate("Shipping State", SalesStaging.shipping_state);
                    SalHeader.Validate("GST Ship-to State Code", SalesStaging.shipping_state);
                    // SalHeader.Validate("GST Bill-to State Code", SalesStaging.shipping_state);//Naveen
                    SalHeader.Validate("Shipping Landmark", SalesStaging.shipping_landmark);
                    Contact.Init();
                    Contact."No." := NOSeriesMgmt.GetNextNo(MarkSetup."Contact Nos.", Today, true);
                    Contact."Phone No." := SalesStaging.billing_phone;
                    Contact.Insert();
                    Contact.Reset();
                    Contact.SetRange("Phone No.", SalesStaging.billing_phone);
                    if Contact.FindFirst() then
                        SalHeader."Bill-to Contact No." := Contact."No.";
                    //SalHeader.Validate("Bill-to Contact No.", Contact."No.");
                    Contact.Init();
                    Contact."No." := NOSeriesMgmt.GetNextNo(MarkSetup."Contact Nos.", Today, true);
                    Contact."Phone No." := SalesStaging.shipping_phone;
                    Contact.Insert();
                    Contact.Reset();
                    Contact.SetRange("Phone No.", SalesStaging.shipping_phone);
                    if Contact.FindFirst() then
                        SalHeader."Sell-to Contact No." := Contact."No.";
                    //SalHeader.Validate("Sell-to Contact No.", Contact."No.");
                    //>>
                    SalHeader.Validate("Promo Code", SalesStaging.promo_code);
                    SalHeader.Validate("Invoice Discount Value", SalesStaging.promo_discount);
                    SalHeader.Validate("Redeem Points", SalesStaging.redeem_points);
                    SalHeader.Validate("Redeem Points Credit", SalesStaging.redeem_points_credit);
                    SalHeader.Validate("Shipping Amount", SalesStaging.shipping_amount);
                    SalHeader.Validate("Duties & Taxes", SalesStaging.duties_and_taxes);
                    Evaluate(totprice, SalesStaging.total_price);
                    SalHeader.Validate("Total Price", totprice);
                    SalHeader.Validate("Date Added", SalesStaging.date_added);
                    SalHeader.Validate("Date Modified", SalesStaging.date_modified);
                    SalHeader.Validate("Order Status", SalesStaging.order_status);
                    SalHeader.Validate(Currency, SalesStaging.currency);
                    SalHeader.Validate("Currency Rate", SalesStaging.currency_rate);
                    SalHeader.Validate("State Tax Type", SalesStaging.state_tax_type);
                    SalHeader.Validate("Pan Number", SalesStaging.pan_number);
                    // SalHeader.Validate("Gift Message", SalesStaging.gift_message);
                    // SalHeader.Validate("Is Special Order", SalesStaging.is_special_order);
                    // SalHeader.Validate("Special Message", SalesStaging.special_message);

                    SalesPerson.Reset();
                    SalesPerson.SetRange(Name, SalesStaging.sale_person);
                    if SalesPerson.FindFirst() then
                        SalHeader.Validate("Salesperson Code", SalesPerson.Code)
                    else begin
                        SalesPerson.Init();
                        SalesPerson.Code := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Salesperson No. Series", Today, true);
                        SalesPerson.Name := SalesStaging.sale_person;
                        SalesPersoncode := SalesPerson.Code;
                        SalesPerson.Insert();

                        SalHeader."Salesperson Code" := SalesPersoncode;
                    end;
                    // SalHeader.Validate("COD Confirm", SalesStaging.cod_confirm);
                    SalHeader.Validate("Charge Back Remark", SalesStaging.charge_back_remark);
                    SalHeader.Validate("Charge Back Date", SalesStaging.charge_back_date);
                    SalHeader.Validate("Loyalty Point", SalesStaging.loyalty_points);
                    SalHeader.Validate("Loyalty Percent", SalesStaging.loyalty_percent);
                    SalHeader.Validate("Loyalty Unit", SalesStaging.loyalty_unit);
                    SalHeader.Validate("Redeem Loyalty points", SalesStaging.redeem_loyalty_points);
                    SalHeader.Validate("New Shipping Address", SalesStaging.new_shipping_address);
                    SalHeader.Validate("Is Loyalty Free Ship", SalesStaging.is_loyalty_free_ship);
                    SalHeader.Validate("Current loyalty Tier", SalesStaging.current_loyalty_tier);
                    //SalHeader."Location Code" := 'ONL';
                    SalHeader.Validate("Location Code", 'ONL');
                    // if SalHeader.Insert() then
                    SalHeader."Payment Id" := SalesStaging.payment_id;
                    SalHeader."Transaction Id" := SalesStaging.transaction_id;
                    SalHeader."Payer Id" := SalesStaging.payer_id;
                    SalHeader."Payment Method" := SalesStaging.payment_method;
                    //>>>>>>>>>>>>>>>Not creating Header when item is not available>>>>>>>>>>>>>>>>>
                    ItemmTestBool := false;
                    Evaluate(NO, SalHeader."No.");
                    DetailSalesStaging.Reset();
                    DetailSalesStaging.SetRange(order_id, NO);
                    DetailSalesStaging.SetRange("Line Created", false);//added170623
                    if DetailSalesStaging.FindSet() then begin
                        repeat
                            Clear(txtBarcode);
                            if StrLen(DetailSalesStaging.barcode) > 20 then
                                txtBarcode := CopyStr(DetailSalesStaging.barcode, StrLen(DetailSalesStaging.barcode) - 20 + 1)
                            else
                                txtBarcode := DetailSalesStaging.barcode;
                            if not ItemTest.Get(txtBarcode) then begin
                                Error('Item No. does not exist');
                                //ItemmTestBool := true;
                                // if ItemTest."Is Approved for Sale" = false then
                                //     Error('Item %1 is not approved for sale', ItemTest."No.");

                            end;
                        // if ItemmTestBool = false then
                        //     Error('Item No. does not exist');
                        until DetailSalesStaging.Next() = 0;

                    end;

                    SalHeader.Insert();
                    //  Message('%1', SalHeader."Location Code");
                    SHVar := SalHeader."No.";
                    Message('After header insert %1', GetLastErrorText());
                    // begin
                    //     SalesStaging."SO Created" := true;
                    //     SalesStaging."Record Status" := SalesStaging."Record Status"::Created;
                    //     SalesStaging.Modify();
                    //     Message('Sales Header %1 Created', SalHeader."No.");
                    // end;
                    Evaluate(NO, SalHeader."No.");
                    DetailSalesStaging.Reset();
                    DetailSalesStaging.SetRange(order_id, NO);
                    DetailSalesStaging.SetRange("Line Created", false);//added170623
                    if DetailSalesStaging.FindSet() then
                        repeat
                            Clear(txtBarcode);
                            if StrLen(DetailSalesStaging.barcode) > 20 then
                                txtBarcode := CopyStr(DetailSalesStaging.barcode, StrLen(DetailSalesStaging.barcode) - 20 + 1)
                            else
                                txtBarcode := DetailSalesStaging.barcode;
                            SalesLine.Init();
                            SalesLine.Validate("Document Type", SalHeader."Document Type");
                            SalesLine.Validate("Document No.", SalHeader."No.");
                            SalesLine."Line No." := DetailSalesStaging.order_detail_id;
                            SalesLine.Type := SalesLine.Type::Item;
                            // SalesLine.Validate("No.", DetailSalesStaging.invoice_item_number);
                            SalesLine.Validate("No.", txtBarcode);
                            SalesLine.Validate(Description, DetailSalesStaging.product_title);
                            SalesLine.Validate("Product Id", DetailSalesStaging.product_id);
                            SalesLine.Validate("Aza Online Code", DetailSalesStaging.aza_online_code);
                            //SalesLine.Validate("Tax Category", DetailSalesStaging.category_id);
                            if not Evaluate(FCLocation, DetailSalesStaging.fc_location) then Error('FC location %1 is not mapped in the master', FCLocation);
                            Location.Reset();
                            Location.SetRange("fc_location ID", FCLocation);
                            if Location.FindFirst() then begin
                                //SalesLine."Location Code" := Location.Code;
                                SalesLine.Validate("Location Code", Location.Code);
                            end;
                            SalesLine.Validate(Quantity, DetailSalesStaging.actual_quantity);
                            // SalesLine.Validate("Quantity (Base)", DetailSalesStaging.quantity);
                            SalesLine.Validate("Unit Price", DetailSalesStaging.product_price);
                            SalesLine.Validate("Unit Cost", DetailSalesStaging.product_cost);
                            SalesLine.Validate(Amount, DetailSalesStaging.product_amount);
                            SalesLine.Validate("Amount Including VAT", DetailSalesStaging.actual_amount);
                            SalesLine.Validate("Qty. to Ship", 0);
                            SalesLine.Validate("Discount Percent By Aza", DetailSalesStaging.discount_percent_by_aza);
                            SalesLine.Validate("Discount Percent By Desg", DetailSalesStaging.discount_percent_by_desg);
                            if (DetailSalesStaging.discount_percent_by_aza + DetailSalesStaging.discount_percent_by_desg)
                                                          <= DetailSalesStaging.discount_percent then
                                TotalDiscPercent := DetailSalesStaging.discount_percent
                            else
                                TotalDiscPercent := (DetailSalesStaging.discount_percent_by_aza + DetailSalesStaging.discount_percent_by_desg);
                            Subt1 := DetailSalesStaging.product_price - ((DetailSalesStaging.product_price * TotalDiscPercent) / 100);
                            SalesLine.Validate("SubTotal 1", Subt1);
                            SalesLine.Validate("Promo Discount", DetailSalesStaging.promo_discount);
                            if DetailSalesStaging.promo_discount > 0 then
                                SalesLine.Validate("SubTotal 2", (Subt1 - DetailSalesStaging.promo_discount))
                            else
                                SalesLine.Validate("SubTotal 2", Subt1);
                            SalesLine.Validate("Credit By Product", DetailSalesStaging.credit_by_product);
                            SalesLine.Validate("Loyalty By Product", DetailSalesStaging.loyalty_by_product);
                            if (DetailSalesStaging.credit_by_product > 0) or (DetailSalesStaging.loyalty_by_product > 0) then begin
                                Subt2 := SalesLine."SubTotal 2" - (DetailSalesStaging.credit_by_product + DetailSalesStaging.loyalty_by_product);
                                // SalesLine.Validate("Line Amount", Subt2);
                            end else begin
                                //SalesLine.Validate("Line Amount", SalesLine."SubTotal 2");
                                Subt2 := SalesLine."SubTotal 2";
                            end;
                            if SalesStaging.duties_and_taxes > 0 then
                                SalesLine.Validate("Line Amount", Subt2)
                            else begin
                                if Item2.Get(txtBarcode) then begin
                                    GstGroup.Reset();
                                    GstGroup.SetRange(Code, Item2."GST Group Code");
                                    if GstGroup.FindFirst() then
                                        Gstrate1 := GstGroup."GST %";
                                end;
                                AmtExcluGST := Subt2 - ((Subt2 * Gstrate1) / (100 + gstrate1));
                                SalesLine.Validate("Line Amount", AmtExcluGST);
                            end;
                            // if DetailSalesStaging.shipping_status = 'PROCESSING' then
                            //     SalesLine.Validate("Shipping Status", 'OPEN');
                            // if DetailSalesStaging.shipping_status = 'SHIPPED' then
                            //     SalesLine.Validate("Shipping Status", 'SHIP');
                            // if DetailSalesStaging.shipping_status = 'RETURNED' then
                            //     SalesLine.Validate("Shipping Status", 'RETURNED');
                            // if DetailSalesStaging.shipping_status = 'RTV PERMANENT DONE' then
                            //     SalesLine.Validate("Shipping Status", 'RTV PERMANENT DONE');
                            // if DetailSalesStaging.shipping_status = 'CANCELLED' then
                            //     SalesLine.Validate("Shipping Status", 'CANCELLED');
                            SalesLine.Validate("Is Return And Exchange", DetailSalesStaging.is_return_and_exchange);
                            SalesLine.Validate("Shipping Company Name", DetailSalesStaging.shipping_company_name);
                            SalesLine.Validate("Shipping Company Name RTV", DetailSalesStaging.shipping_company_name_rtv);
                            SalesLine.Validate("Tracking Id", DetailSalesStaging.tracking_id);
                            SalesLine.Validate("Tracking Id RTV", DetailSalesStaging.tracking_id_rtv);
                            SalesLine.Validate("Requested Delivery Date", DetailSalesStaging.delivery_date);
                            SalesLine.Validate("Delivery Date RTV", DetailSalesStaging.delivery_date_rtv);
                            SalesLine.Validate("Track date", DetailSalesStaging.track_date);
                            SalesLine.Validate("Track Date RTV", DetailSalesStaging.track_date_rtv);
                            SalesLine.Validate("Invoice Number", DetailSalesStaging.invoice_number);
                            SalesLine.Validate("Invoice Number RTV", DetailSalesStaging.invoice_number_rtv);
                            SalesLine.Validate("Dispatch Date ", DetailSalesStaging.dispatch_date);
                            SalesLine.Validate("In Warehouse", DetailSalesStaging.in_warehouse);
                            SalesLine.Validate("Shipment Date", DetailSalesStaging.ship_date);
                            SalesLine.Validate("Ship Date RTV", DetailSalesStaging.ship_date_rtv);
                            SalesLine.Validate("Net Weight", DetailSalesStaging.weight);
                            SalesLine.Validate("Ship Mode", DetailSalesStaging.ship_mode);
                            //SalesLine.Validate("Posting Date", DetailSalesStaging.order_confirm_date);
                            SalesLine.Validate("Loyalty Points", DetailSalesStaging.loyalty_points);
                            SalesLine.Validate("Loyalty Flag", DetailSalesStaging.loyalty_flag);
                            SalesLine.validate("Estm Delivery Date", DetailSalesStaging.estm_delivery_date);
                            SalesLine.Validate("Is Customization Received", DetailSalesStaging.is_customization_received);
                            SalesLine.Validate("Is Blouse Customization Received", DetailSalesStaging.is_blouse_customization_received);
                            SalesLine.Validate("Alteration Charges", DetailSalesStaging.alteration_charges);
                            if SalesLine.Insert() then begin
                                DetailSalesStaging."Line Created" := true;
                                DetailSalesStaging.Modify();
                                // Message('%1', SalHeader."Location Code");
                                // Message('%1', SalesLine."GST Jurisdiction Type");
                            end;
                            Message('After line insert %1', GetLastErrorText());
                            DocNoVar := SalesLine."Document No.";
                        until DetailSalesStaging.Next() = 0;



                    //>>>>>>>>>shipping chargesline>>>>>>>>>>>>>>>>>>
                    if SalesStaging.shipping_amount <> 0 then begin
                        Salesline1.Init();
                        Salesline1.Validate("Document Type", SalHeader."Document Type");
                        Salesline1.Validate("Document No.", SalHeader."No.");
                        Salesline1."Line No." := SalesLine."Line No." + 99999;
                        Salesline1.Validate(Type, Salesline1.Type::"Charge (Item)");
                        Salesline1.Validate("No.", 'SHIPPING');
                        // Salesline1."Location Code":='ONL';

                        //Salesline1."Unit Price Incl. of Tax" := SalesStaging.shipping_amount;
                        if SalesStaging.duties_and_taxes > 0 then
                            Salesline1.Validate("Unit Price", SalesStaging.shipping_amount)
                        else begin
                            Salesline2.Reset();
                            Salesline2.SetRange("Document Type", SalHeader."Document Type");
                            Salesline2.SetRange("Document No.", SalHeader."No.");
                            if Salesline2.FindSet() then
                                repeat
                                    GstGroup.Reset();
                                    GstGroup.SetRange(Code, Salesline2."GST Group Code");
                                    if GstGroup.FindFirst() then begin
                                        if GstGroup."GST %" > GSTrate then begin
                                            Gstrate := GstGroup."GST %";
                                            GSTgc := Salesline2."GST Group Code";
                                            HSN := Salesline2."HSN/SAC Code";
                                        end;
                                    end;
                                until Salesline2.Next() = 0;
                            LineAmt := SalesStaging.shipping_amount - ((Gstrate * SalesStaging.shipping_amount) / (100 + Gstrate));
                            // Salesline1.Validate("Unit Price", LineAmt);

                            //Salesline1."Line Amount" := LineAmt;
                            Salesline1.Validate("GST Group Code", GSTgc);
                            Salesline1.Validate("HSN/SAC Code", HSN);
                            Salesline1.Validate("Unit Price", LineAmt);
                        end;
                        Salesline1.Validate(Quantity, 1);
                        Salesline1.Insert();
                    end;

                    if DetailSalesStaging.alteration_charges <> 0 then begin
                        Salesline4.Init();
                        Salesline4.Validate("Document Type", SalHeader."Document Type");
                        Salesline4.Validate("Document No.", SalHeader."No.");
                        Salesline4."Line No." := SalesLine."Line No." + 100101;
                        Salesline4.Validate(Type, Salesline4.Type::"Charge (Item)");
                        Salesline4.Validate("No.", 'ALTERATION');
                        //Salesline1."Unit Price Incl. of Tax" := SalesStaging.shipping_amount;
                        if SalesStaging.duties_and_taxes > 0 then
                            Salesline4.Validate("Unit Price", DetailSalesStaging.alteration_charges)
                        else begin
                            Salesline5.Reset();
                            Salesline5.SetRange("Document Type", SalHeader."Document Type");
                            Salesline5.SetRange("Document No.", SalHeader."No.");
                            if Salesline5.FindSet() then
                                repeat
                                    GstGroup.Reset();
                                    GstGroup.SetRange(Code, Salesline5."GST Group Code");
                                    if GstGroup.FindFirst() then begin
                                        if GstGroup."GST %" > Gstrate2 then begin
                                            Gstrate2 := GstGroup."GST %";
                                            GSTgc1 := Salesline5."GST Group Code";
                                            HSN1 := Salesline5."HSN/SAC Code";
                                        end;
                                    end;
                                until Salesline5.Next() = 0;
                            LineAmt1 := DetailSalesStaging.alteration_charges - ((Gstrate2 * DetailSalesStaging.alteration_charges) / (100 + Gstrate2));

                            Salesline4.Validate("GST Group Code", GSTgc1);
                            Salesline4.Validate("HSN/SAC Code", HSN1);
                            Salesline4.Validate("Unit Price", LineAmt1);
                        end;
                        Salesline4.Validate(Quantity, 1);
                        Salesline4.Insert();
                    end;

                    if SalesStaging.duties_and_taxes > 0 then begin
                        Salesline3.Init();
                        Salesline3.Validate("Document Type", SalHeader."Document Type");
                        Salesline3.Validate("Document No.", SalHeader."No.");
                        Salesline3."Line No." := SalesLine."Line No." + 101001;
                        Salesline3.Validate(Type, Salesline1.Type::"Charge (Item)");
                        Salesline3.Validate("No.", 'DUTIES & TAXES');
                        Salesline3.Validate(Quantity, 1);
                        Salesline3.Validate("Unit Price", SalesStaging.duties_and_taxes);
                        Salesline3.Insert();
                    end;
                    Message('After charge item line insert %1', GetLastErrorText());

                    // //header deletion in case of no lines existed>>>>>>
                    // SalesLinedlt.Reset();
                    // SalesLinedlt.SetRange("Document Type", SalesLinedlt."Document Type"::Order);
                    // SalesLinedlt.SetRange("Document No.", DocNoVar);
                    // SalesLinedlt.SetRange(Type, SalesLinedlt.Type::Item);
                    // if not SalesLinedlt.FindFirst() then
                    //     if SalesHeaderdlt.Get(SalesHeaderdlt."Document Type"::Order, DocNoVar) then
                    //         SalesHeaderdlt.DeleteAll();
                    // //<<<<<<<<<<<<<<<<<<

                    // end;
                    Evaluate(SOIDint, SHVar);
                    ActionStatus.Reset();
                    ActionStatus.SetRange(SO_ID, SOIDint);
                    ActionStatus.SetRange(Processed, false);
                    if ActionStatus.FindSet() then
                        repeat
                            SalesHash.Reset();
                            // SalesHash.SetRange("So No.", Format(ActionStatus.SO_ID));
                            // SalesHash.SetRange("SO Detail ID", ActionStatus.SO_Detail_ID);
                            SalesHash.SetRange(hash, ActionStatus.hash);
                            if not SalesHash.FindFirst() then begin
                                // SalesHash.Init();
                                // SalesHash.Validate(hash, ActionStatus.hash);
                                // SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                // SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                // SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                // SalesHash.Insert();
                                case ActionStatus."Action ID" of
                                    1:                   //processing
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SalHeader."No.");
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                sline."Shipping Status" := 'OPEN';
                                                if SLine.Modify() then
                                                    ActionStatus.Processed := true;
                                                ActionStatus.Modify();
                                                //Hash insertion>>>>>>>>>>>>
                                                SalesHash.Init();
                                                SalesHash.Validate(hash, ActionStatus.hash);
                                                SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                SalesHash.Insert();
                                            end;
                                        end;
                                    2:                   //RTV Alteration
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SalHeader."No.");
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                SLine."Shipping Status" := 'RTV Alteration';
                                                SLine.Modify();
                                                ActionStatus.Processed := true;
                                                ActionStatus.Modify();
                                                //Hash insertion>>>>>>>>>>>>
                                                SalesHash.Init();
                                                SalesHash.Validate(hash, ActionStatus.hash);
                                                SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                SalesHash.Insert();
                                            end;
                                            // Clear(VendNo);
                                            // Clear(ItemCost);
                                            // if Item.Get(txtBarcode) then begin
                                            //     VendNo := Item."Vendor No.";
                                            //     ItemCost := Item."Unit Cost";
                                            // end;
                                            // //<<<<<Purchase return Order>>>>>>>>>>>>>>>>
                                            // SLine.Reset();
                                            // SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            // SLine.SetRange("Document No.", SalHeader."No.");
                                            // SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            // //SLine.SetRange("No.", txtBarcode);
                                            // if SLine.FindFirst() then begin
                                            //     if VendNo <> LastVendor then begin
                                            //         PurPaybleSetup.Get();
                                            //         PurHeader.Init();
                                            //         PurHeader."Document Type" := PurHeader."Document Type"::"Return Order";
                                            //         PurHeader."No." := NOSeriesMgmt.GetNextNo(PurPaybleSetup."Return Order Nos.", Today, true);
                                            //         PurHeader.Validate("Buy-from Vendor No.", VendNo);
                                            //         if PurHeader.Insert() then begin
                                            //             Message('RTV %1 Created', PurHeader."No.");
                                            //             SLine."Shipping Status" := 'RTV Alteration';
                                            //             SLine.Modify();
                                            //         end;
                                            //         PurLine.Init();
                                            //         PurLine."Document Type" := PurHeader."Document Type";
                                            //         PurLine."Document No." := PurHeader."No.";
                                            //         PurLine."Line No." := 10000;
                                            //         PurLine.Type := SLine.Type;
                                            //         PurLine.Validate("No.", SLine."No.");
                                            //         PurLine."Unit Price (LCY)" := ItemCost;
                                            //         PurLine.Validate(Quantity, SLine.Quantity);
                                            //         if PurLine.Insert() then begin
                                            //             ActionStatus.Processed := true;
                                            //             ActionStatus.Modify();
                                            //         end;
                                            //         LastVendor := VendNo;
                                            //         POOrderNo := PurHeader."No.";
                                            //     end else begin
                                            //         PurLine.Init();
                                            //         PurLine."Document Type" := PurLine."Document Type"::"Return Order";
                                            //         PurLine."Document No." := POOrderNo;
                                            //         PurLine."Line No." := DetailSalesStaging.order_detail_id;
                                            //         PurLine.Type := SLine.Type;
                                            //         PurLine.Validate("No.", SLine."No.");
                                            //         PurLine."Unit Price (LCY)" := ItemCost;
                                            //         PurLine.Validate(Quantity, SLine.Quantity);
                                            //         if PurLine.Insert() then begin
                                            //             ActionStatus.Processed := true;
                                            //             ActionStatus.Modify();
                                            //         end;
                                            //     end;
                                            // end;
                                            // //For Status updation in posting documents>>>>>>>>>>>>>
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'RTV Alteration';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'RTV Alteration';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;

                                        end;
                                    3:                   //RTV PERMANENT DONE
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SalHeader."No.");
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                SLine."Shipping Status" := 'RTV PERMANENT DONE';
                                                SLine.Modify();
                                                ActionStatus.Processed := true;
                                                ActionStatus.Modify();
                                                //Hash insertion>>>>>>>>>>>>
                                                SalesHash.Init();
                                                SalesHash.Validate(hash, ActionStatus.hash);
                                                SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                SalesHash.Insert();
                                            end;
                                            // Clear(VendNo);
                                            // Clear(ItemCost);
                                            // if Item.Get(txtBarcode) then begin
                                            //     VendNo := Item."Vendor No.";
                                            //     ItemCost := Item."Unit Cost";
                                            // end;
                                            // //<<<<<Purchase return Order>>>>>>>>>>>>>>>>
                                            // SLine.Reset();
                                            // SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            // SLine.SetRange("Document No.", SalHeader."No.");
                                            // SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            // //SLine.SetRange("No.", txtBarcode);
                                            // if SLine.FindFirst() then begin
                                            //     if VendNo <> LastVendor then begin
                                            //         PurPaybleSetup.Get();
                                            //         PurHeader.Init();
                                            //         PurHeader."Document Type" := PurHeader."Document Type"::"Return Order";
                                            //         PurHeader."No." := NOSeriesMgmt.GetNextNo(PurPaybleSetup."Return Order Nos.", Today, true);
                                            //         PurHeader.Validate("Buy-from Vendor No.", VendNo);
                                            //         if PurHeader.Insert() then begin
                                            //             Message('RTV %1 Created', PurHeader."No.");
                                            //             SLine."Shipping Status" := 'RTV PERMANENT DONE';
                                            //             SLine.Modify();
                                            //         end;
                                            //         PurLine.Init();
                                            //         PurLine."Document Type" := PurHeader."Document Type";
                                            //         PurLine."Document No." := PurHeader."No.";
                                            //         PurLine."Line No." := 10000;
                                            //         PurLine.Type := SLine.Type;
                                            //         PurLine.Validate("No.", SLine."No.");
                                            //         PurLine."Unit Price (LCY)" := ItemCost;
                                            //         PurLine.Validate(Quantity, SLine.Quantity);
                                            //         if PurLine.Insert() then begin
                                            //             ActionStatus.Processed := true;
                                            //             ActionStatus.Modify();
                                            //         end;
                                            //         LastVendor := VendNo;
                                            //         POOrderNo := PurHeader."No.";
                                            //     end else begin
                                            //         PurLine.Init();
                                            //         PurLine."Document Type" := PurLine."Document Type"::"Return Order";
                                            //         PurLine."Document No." := POOrderNo;
                                            //         PurLine."Line No." := DetailSalesStaging.order_detail_id;
                                            //         PurLine.Type := SLine.Type;
                                            //         PurLine.Validate("No.", SLine."No.");
                                            //         PurLine."Unit Price (LCY)" := ItemCost;
                                            //         PurLine.Validate(Quantity, SLine.Quantity);
                                            //         if PurLine.Insert() then begin
                                            //             ActionStatus.Processed := true;
                                            //             ActionStatus.Modify();
                                            //         end;
                                            //     end;
                                            // end;
                                            //For Status updation in posting documents>>>>>>>>>>>>>
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'RTV PERMANENT DONE';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'RTV PERMANENT DONE';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;

                                        end;
                                    4:                   //SHIPPED
                                        begin
                                            /*    // ClearLastError();
                                                salesheader1.Reset();
                                                salesheader1.SetRange("Document Type", salesheader1."Document Type"::Order);
                                                salesheader1.SetRange("No.", SalHeader."No.");
                                                salesheader1.SetRange(Status, salesheader1.Status::Released);
                                                if salesheader1.FindFirst() then begin
                                                    salesheader1.Validate(Status, salesheader1.Status::Open);
                                                    salesheader1.Modify(true);
                                                end;

                                                //for clear//>>>>>>>>
                                                SLineClr.Reset();
                                                SLineClr.SetRange("Document Type", SLineClr."Document Type"::Order);
                                                SLineClr.SetRange("Document No.", SalHeader."No.");
                                                SLineClr.SetFilter("Qty. to Ship", '<>%1', 0);
                                                if SLineClr.FindSet(true) then
                                                    repeat
                                                        SLineClr.Validate("Qty. to Ship", 0);
                                                        SLineClr.Modify(true);
                                                    until SLineClr.Next() = 0;
                                                //if DetailSalesStaging.shipping_status = 'SHIPPED' then begin //nwadded
                                                // Clear(txtBarcode);
                                                // if StrLen(DetailSalesStaging.barcode) > 20 then
                                                //     txtBarcode := CopyStr(DetailSalesStaging.barcode, StrLen(DetailSalesStaging.barcode) - 20 + 1)
                                                // else
                                                //     txtBarcode := DetailSalesStaging.barcode;

                                                ActionStatus1.Reset();
                                                ActionStatus1.SetRange(SO_ID, SOIDint);
                                                ActionStatus1.SetRange(Processed, false);
                                                ActionStatus1.SetRange("Action ID", 4);
                                                if ActionStatus1.FindSet() then
                                                    repeat
                                                        SLine.Reset();
                                                        SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                                        SLine.SetRange("Document No.", SalHeader."No.");
                                                        SLine.SetRange("Line No.", ActionStatus1.SO_Detail_ID);
                                                        if SLine.FindFirst() then begin
                                                            SLine.Validate("Qty. to Ship", 1);
                                                            sline."Shipping Status" := 'SHIP';
                                                            SLine.Modify(true);
                                                            // ActionStatus1.Processed := true;
                                                            // ActionStatus1.Modify();//130623
                                                        end;
                                                    // ActionStatus1.Processed := true;
                                                    // ActionStatus1.Modify();
                                                    until ActionStatus1.Next() = 0;
                                                //shippingchargeline>>>>>>>>>>>>>>>>>>>>>>>>
                                                SLine1.Reset();
                                                SLine1.SetRange("Document Type", SLine1."Document Type"::Order);
                                                SLine1.SetRange("Document No.", SalHeader."No.");
                                                SLine1.SetFilter("Quantity Shipped", '>%1', 0);
                                                if not SLine1.FindFirst() then begin
                                                    SLine1.Reset();
                                                    SLine1.SetRange("Document Type", SLine1."Document Type"::Order);
                                                    SLine1.SetRange("Document No.", SalHeader."No.");
                                                    SLine1.SetRange(Type, SLine1.Type::"Charge (Item)");
                                                    if SLine1.FindSet() then
                                                        repeat //begin
                                                            SLine1.Validate("Qty. to Ship", 1);
                                                            SLine1."Shipping Status" := 'SHIP';
                                                            SLine1.Modify(true);

                                                            SLine2.Reset();
                                                            SLine2.SetRange("Document Type", SLine1."Document Type"::Order);
                                                            SLine2.SetRange("Document No.", SalHeader."No.");
                                                            SLine2.SetFilter("Qty. to Ship", '>%1', 0);
                                                            SLine2.SetFilter(Type, '<>%1', SLine2.Type::"Charge (Item)");
                                                            if SLine2.FindFirst() then begin
                                                                // ItemChargeAssignment.Reset();
                                                                // ItemChargeAssignment.SetRange("Document Type", ItemChargeAssignment."Document Type"::Order);
                                                                // ItemChargeAssignment.SetRange("Document No.", SLine2."Document No.");
                                                                // if ItemChargeAssignment.FindSet() then
                                                                //     ItemChargeAssignment.DeleteAll();
                                                                LineNo1 := lineNo1 + 10001;
                                                                ItemChargeAssignment.Init();
                                                                ItemChargeAssignment.Validate("Document Type", ItemChargeAssignment."Document Type"::Order);
                                                                ItemChargeAssignment.Validate("Document No.", SLine2."Document No.");
                                                                ItemChargeAssignment.Validate("Document Line No.", SLine1."Line No.");
                                                                ItemChargeAssignment.Validate("Line No.", lineNo1);
                                                                ItemChargeAssignment.Insert();
                                                                ItemChargeAssignment.Validate("Applies-to Doc. No.", SLine2."Document No.");
                                                                ItemChargeAssignment.Validate("Applies-to Doc. Type", ItemChargeAssignment."Document Type"::Order);
                                                                ItemChargeAssignment.Validate("Applies-to Doc. Line No.", SLine2."Line No.");
                                                                ItemChargeAssignment.Validate("Item No.", SLine2."No.");
                                                                ItemChargeAssignment.Validate("Qty. to Assign", 1);
                                                                if ItemChargeAssignment.Modify() then
                                                                    Message('Item Charge line inserted');
                                                            end;
                                                        until SLine1.Next() = 0;     // end;
                                                end;
                                                //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


                                                //<<<<Posting>>>>>>>>>>>>>>>
                                                SLine.Reset();
                                                SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                                SLine.SetRange("Document No.", SalHeader."No.");
                                                SLine.SetFilter("Qty. to Ship", '<>%1', 0);
                                                //SLine.SetFilter("Qty. to Invoice", '<>%1', 0);
                                                if SLine.FindFirst() then begin
                                                    Clear(salesheader3);
                                                    if salesheader3.Get(1, SalHeader."No.") then begin
                                                        salesheader3.Validate(Status, salesheader3.Status::Released);
                                                        salesheader3.Modify();
                                                        salesheader3.Ship := true;
                                                        salesheader3.Invoice := true;
                                                        //SHeader.Modify();
                                                        //Commit();
                                                        if Not postSalesOrderShipment(salesheader3) then begin
                                                            if GetLastErrorText() <> '' then begin
                                                                SalesShpHdr.Reset();
                                                                SalesShpHdr.SetRange("Order No.", SalHeader."No.");
                                                                if SalesShpHdr.FindLast() then begin
                                                                    // salesshpLine.Reset();
                                                                    // salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
                                                                    // if not salesshpLine.FindFirst() then begin
                                                                    SalesShpHdr."No. Printed" := 1;
                                                                    SalesShpHdr.Modify();
                                                                    SalesShpHdr.Delete(true);
                                                                    //Message('ship hdr delete due to error');
                                                                    //exit(false);
                                                                    // end;

                                                                end;
                                                                SalesInvoiceHdr.Reset();
                                                                SalesInvoiceHdr.SetRange("Order No.", SalHeader."No.");
                                                                if SalesInvoiceHdr.FindLast() then begin
                                                                    SalesInvoiceHdr."No. Printed" := 1;
                                                                    SalesInvoiceHdr.Modify();
                                                                    SalesInvoiceHdr.Delete(true);
                                                                end;
                                                                if salesheader4.Get(1, SalHeader."No.") then begin
                                                                    salesheader4.Validate(Status, salesheader4.Status::Open);
                                                                    salesheader4.Modify();
                                                                end;
                                                                SLine.Reset();
                                                                SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                                                SLine.SetRange("Document No.", SalHeader."No.");
                                                                //SLine.SetRange("No.", txtBarcode);
                                                                SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                                                if SLine.FindFirst() then begin
                                                                    SLine.Validate("Qty. to Ship", 0);
                                                                    sline."Shipping Status" := 'OPEN';
                                                                    SLine.Modify(true);
                                                                end;
                                                            end;
                                                        end else begin
                                                            ActionStatus.Processed := true;
                                                            ActionStatus.Modify();
                                                            Message('Sales order %1 posted', SalHeader."No.");
                                                        end;
                                                    end;
                                                end;
                                           */
                                            //Hash insertion>>>>>>>>>>>>
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                    13:                   //CANCELED
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SalHeader."No.");
                                            // SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                SLine."Shipping Status" := 'CANCELED';
                                                SLine.Validate("Qty. to Ship", 0);
                                                if SLine.Modify() then begin
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                end;
                                            end;
                                            //>>>>>>>>>>>>>>SlineTabmodifyerror<<<<<<<<<<<<<

                                            //For Status updation in posting documents>>>>>>>>>>>>>
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'CANCELED';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'CANCELED';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;
                                        end;
                                    5:                  //CANCELLED
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SHeader."No.");
                                            //SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                SLine."Shipping Status" := 'CANCELLED';
                                                SLine.Validate("Qty. to Ship", 0);
                                                if SLine.Modify() then begin
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                    //Hash insertion>>>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                    SalesHash.Insert();
                                                end;
                                            end;
                                            //SlineTabmodifyerror

                                            //For Status updation in posting documents>>>>>>>>>>>>>
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'CANCELLED';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'CANCELLED';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;
                                        end;
                                    6:                   //REVERSE PICKUP DONE
                                        begin
                                            // Clear(txtBarcode);
                                            // if StrLen(DetailSalesStaging.barcode) > 20 then
                                            //     txtBarcode := CopyStr(DetailSalesStaging.barcode, StrLen(DetailSalesStaging.barcode) - 20 + 1)
                                            // else
                                            //     txtBarcode := DetailSalesStaging.barcode;
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SHeader."No.");
                                            //SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                sline."Shipping Status" := 'REVERSE PICKUP DONE';
                                                if SLine.Modify() then begin///>
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                    //Hash insertion>>>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                    SalesHash.Insert();
                                                end;
                                            end;

                                            //For Status updation in posting documents>>>>>>>>>>>>>
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'REVERSE PICKUP DONE';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;
                                            SSH.Reset();
                                            SSH.SetRange("Order No.", SalHeader."No.");
                                            if SSH.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", Detailstage.barcode);
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'REVERSE PICKUP DONE';
                                                            SSL.Modify();
                                                        end;
                                                    end;
                                                until SSH.Next() = 0;
                                        end;
                                    7:                   //RETURNED
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SHeader."No.");
                                            // SLine.SetRange("No.", DetailSalesStaging.invoice_item_number);
                                            //SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            SLine.SetFilter("Shipping Status", '%1|%2', 'SHIP', 'DELIVERED');
                                            //SLine.SetRange("Shipping Status", 'SHIP');
                                            if SLine.FindFirst() then begin
                                                SLine."Shipping Status" := 'RETURNED';
                                                //>>
                                                SalesReceiveblesetup.Get();
                                                SalRetHdr.Init();
                                                SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                                SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                                SalRetHdr.Validate("Sell-to Customer No.", SalHeader."Sell-to Customer No.");
                                                SalRetHdr.Validate(State, SalHeader.State);
                                                SalRetHdr."Sell-to E-Mail" := SalHeader."Sell-to E-Mail";
                                                SalRetHdr."Bill-to Name" := SalHeader."Bill-to Name";
                                                SalRetHdr."Bill-to Address" := SalHeader."Bill-to Address";
                                                SalRetHdr."Bill-to City" := SalHeader."Bill-to City";
                                                SalRetHdr."Bill-to Post Code" := SalHeader."Bill-to Post Code";
                                                SalRetHdr."Bill-to Country/Region Code" := SalHeader."Bill-to Country/Region Code";
                                                SalRetHdr."Ship-to Name" := SalHeader."Ship-to Name";
                                                SalRetHdr."Ship-to Address" := SalHeader."Ship-to Address";
                                                SalRetHdr."Ship-to City" := SalHeader."Ship-to City";
                                                SalRetHdr."Ship-to Code" := SalHeader."Ship-to Code";
                                                SalRetHdr."Ship-to Country/Region Code" := SalHeader."Ship-to Country/Region Code";
                                                SalRetHdr."Location Code" := SalHeader."Location Code";//location
                                                SalRetHdr.Validate("Billing Locality", SalHeader."Billing Locality");
                                                SalRetHdr.Validate("Billing State", SalHeader."Billing State");
                                                SalRetHdr.Validate("Billing Email", SalHeader."Billing Email");
                                                SalRetHdr.Validate("Billing Landmark", SalHeader."Billing Landmark");
                                                SalRetHdr.Validate("Shipping Locality", SalHeader."Shipping Locality");
                                                SalRetHdr.Validate("Shipping State", SalHeader."Shipping State");
                                                SalRetHdr.Validate("Shipping Landmark", SalHeader."Shipping Landmark");
                                                SalRetHdr."Bill-to Contact No." := SalHeader."Bill-to Contact No.";
                                                SalRetHdr."Sell-to Contact No." := SalHeader."Sell-to Contact No.";
                                                SalRetHdr."Salesperson Code" := SalHeader."Salesperson Code";
                                                //>>
                                                SalRetHdr.Validate("Promo Code", SalHeader."Promo Code");
                                                SalRetHdr.Validate("Invoice Discount Value", SalHeader."Invoice Discount Value");
                                                SalRetHdr.Validate("Redeem Points", SalHeader."Redeem Points");
                                                SalRetHdr.Validate("Redeem Points Credit", SalHeader."Redeem Points Credit");
                                                SalRetHdr.Validate("Shipping Amount", SalHeader."Shipping Amount");
                                                SalRetHdr.Validate("Duties & Taxes", SalHeader."Duties & Taxes");
                                                SalRetHdr.Validate("Total Price", SalHeader."Total Price");
                                                SalRetHdr.Validate("Date Added", SalHeader."Date Added");
                                                SalRetHdr.Validate("Date Modified", SalHeader."Date Modified");
                                                SalRetHdr.Validate("Order Status", SalHeader."Order Status");
                                                SalRetHdr.Validate(Currency, SalHeader.currency);
                                                SalRetHdr.Validate("Currency Rate", SalHeader."Currency Rate");
                                                SalRetHdr.Validate("State Tax Type", SalHeader."State Tax Type");
                                                SalRetHdr.Validate("Pan Number", SalHeader."Pan Number");
                                                // SalRetHdr.Validate("Gift Message", SalHeader."Gift Message");
                                                // SalRetHdr.Validate("Is Special Order", SalHeader."Is Special Order");
                                                // SalRetHdr.Validate("Special Message", SalHeader."Special Message");
                                                // SalRetHdr.Validate("COD Confirm", SalHeader."COD Confirm");
                                                SalRetHdr.Validate("Charge Back Remark", SalHeader."Charge Back Remark");
                                                SalRetHdr.Validate("Charge Back Date", SalHeader."Charge Back Date");
                                                SalRetHdr.Validate("Loyalty Point", SalHeader."Loyalty Point");
                                                SalRetHdr.Validate("Loyalty Percent", SalHeader."Loyalty Percent");
                                                SalRetHdr.Validate("Loyalty Unit", SalHeader."Loyalty Unit");
                                                SalRetHdr.Validate("Redeem Loyalty points", SalHeader."Redeem Loyalty points");
                                                SalRetHdr.Validate("New Shipping Address", SalHeader."New Shipping Address");
                                                SalRetHdr.Validate("Is Loyalty Free Ship", SalHeader."Is Loyalty Free Ship");
                                                SalRetHdr.Validate("Current loyalty Tier", SalHeader."Current loyalty Tier");
                                                SalRetHdr.Insert();
                                                //>>LINE
                                                SalRetLine.Init();
                                                SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                                SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                                SalRetLine."Line No." := 10000;
                                                SalRetLine.Validate(Type, SLine.Type);
                                                SalRetLine.Validate("No.", SLine."No.");
                                                SalRetLine."Product Id" := SLine."Product Id";
                                                SalRetLine."Aza Online Code" := SLine."Aza Online Code";
                                                SalRetLine."Location Code" := SLine."Location Code";
                                                // SalRetLine.Validate(Quantity, SLine.Quantity);
                                                // //SalRetLine."Quantity (Base)" := SLine."Quantity (Base)";
                                                // //SalRetLine.Quantity := SLine.Quantity;
                                                // SalRetLine.Validate("Unit Price", SLine."Unit Price");
                                                // //SalRetLine.Validate("Unit Cost", SLine."Unit Cost");
                                                // //SalRetLine.Validate(Amount, SLine.Amount);
                                                // SalRetLine."Amount Including VAT" := SLine."Amount Including VAT";
                                                // // SalRetLine.validate("Line Discount %", SLine."Line Discount %");
                                                // SalRetLine."Discount Percent By Aza" := SLine."Discount Percent By Aza";
                                                // SalRetLine."Discount Percent By Desg" := SLine."Discount Percent By Desg";
                                                // SalRetLine."Promo Discount" := SLine."Promo Discount";
                                                // SalRetLine."Credit By Product" := SLine."Credit By Product";
                                                // SalRetLine."Loyalty By Product" := SLine."Loyalty By Product";
                                                // SalRetLine."Unit Price" := SLine."Unit Price";
                                                // SalRetLine.Amount := SLine.Amount;
                                                // SalRetLine."Unit Cost" := SLine."Unit Cost";
                                                // SalRetLine."SubTotal 1" := SLine."SubTotal 1";
                                                // SalRetLine."SubTotal 2" := SLine."SubTotal 2";
                                                // SalRetLine."Line Amount" := SLine."Line Amount";
                                                SalRetLine.Validate(Quantity, SLine.Quantity);
                                                SalRetLine."Amount Including VAT" := SLine."Amount Including VAT";
                                                SalRetLine."Discount Percent By Aza" := SLine."Discount Percent By Aza";
                                                SalRetLine."Discount Percent By Desg" := SLine."Discount Percent By Desg";
                                                SalRetLine."Promo Discount" := SLine."Promo Discount";
                                                SalRetLine."Credit By Product" := SLine."Credit By Product";
                                                SalRetLine."Loyalty By Product" := SLine."Loyalty By Product";
                                                SalRetLine."Unit Price" := SLine."Unit Price";
                                                SalRetLine.Amount := SLine.Amount;
                                                SalRetLine."Unit Cost" := SLine."Unit Cost";
                                                SalRetLine."SubTotal 1" := SLine."SubTotal 1";
                                                SalRetLine."SubTotal 2" := SLine."SubTotal 2";
                                                SalRetLine.Validate("Line Discount Amount", SLine."Line Discount Amount");

                                                SalRetLine."Shipping Status" := SLine."Shipping Status";
                                                SalRetLine."Is Return And Exchange" := SLine."Is Return And Exchange";
                                                SalRetLine."Shipping Company Name" := SLine."Shipping Company Name";
                                                SalRetLine."Shipping Company Name RTV" := SLine."Shipping Company Name RTV";
                                                SalRetLine."Tracking Id" := SLine."Tracking Id";
                                                SalRetLine."Tracking Id RTV" := SLine."Tracking Id RTV";
                                                SalRetLine."Requested Delivery Date" := SLine."Requested Delivery Date";
                                                SalRetLine."Delivery Date RTV" := SLine."Delivery Date RTV";
                                                SalRetLine."Track date" := SLine."Track date";
                                                SalRetLine."Track Date RTV" := SLine."Track Date RTV";
                                                SalRetLine."Invoice Number" := SLine."Invoice Number";
                                                SalRetLine."Invoice Number RTV" := SLine."Invoice Number RTV";
                                                SalRetLine."Dispatch Date " := SLine."Dispatch Date ";
                                                SalRetLine."In Warehouse" := SLine."In Warehouse";
                                                SalRetLine."Shipment Date" := SLine."Shipment Date";
                                                SalRetLine."Ship Date RTV" := SLine."Ship Date RTV";
                                                SalRetLine."Net Weight" := SLine."Net Weight";
                                                SalRetLine."Ship Mode" := SLine."Ship Mode";
                                                SalRetLine."Loyalty Points" := SLine."Loyalty Points";
                                                SalRetLine."Loyalty Flag" := SLine."Loyalty Flag";
                                                SalRetLine."Estm Delivery Date" := SLine."Estm Delivery Date";
                                                SalRetLine."Is Customization Received" := SLine."Is Customization Received";
                                                SalRetLine."Is Blouse Customization Received" := SLine."Is Blouse Customization Received";
                                                SalRetLine."Alteration Charges" := SLine."Alteration Charges";
                                                SalRetLine."Line Amount" := SLine."Unit Price" - SLine."Line Discount Amount";
                                                SalRetLine.Insert();
                                                //<<returnorder
                                                // RefInvNumber.Reset();
                                                // RefInvNumber.SetRange("Document No.", SalRetHdr."No.");
                                                // RefInvNumber.SetRange("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                // RefInvNumber.SetRange("Source No.", SalRetHdr."Sell-to Customer No.");
                                                // if RefInvNumber.FindFirst() then begin

                                                SIH.Reset();
                                                SIH.SetRange("Order No.", SalHeader."No.");
                                                if SIH.FindSet() then
                                                    repeat
                                                        SIL.Reset();
                                                        SIL.SetRange("Document No.", SIH."No.");
                                                        SIL.SetRange(Type, SIL.Type::Item);
                                                        SIL.SetRange("No.", SalRetLine."No.");
                                                        //SIL.SetRange(Quantity, 1);
                                                        if SIL.FindFirst() then begin
                                                            RefInvNumber.Init();
                                                            RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                            RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                            RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                            RefInvNumber."Reference Invoice Nos." := SIL."Document No.";
                                                            RefInvNumber.Verified := true;
                                                            RefInvNumber.Insert();

                                                            SIL."Shipping Status" := 'RETURNED';
                                                            SIL.Modify();
                                                        end;
                                                    until SIH.Next() = 0;
                                                SSH.Reset();
                                                SSH.SetRange("Order No.", SalHeader."No.");
                                                if SSH.FindSet() then
                                                    repeat
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", SalRetLine."No.");
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'RETURNED';
                                                            SSL.Modify();
                                                        end;
                                                    until SSH.Next() = 0;
                                                // end;
                                                //Posting>>
                                                SalRetHdr.Receive := true;
                                                SalRetHdr.Invoice := true;
                                                SalRetHdr.Modify();
                                                Clear(Salespost);
                                                Salespost.Run(SalRetHdr);
                                                Message('Return Order Posted');
                                                if SLine.Modify() then begin
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                    //Hash insertion>>>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                    SalesHash.Insert();
                                                end;
                                                //end;
                                            end;
                                        end;
                                    8:                   //COD RTO
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SHeader."No.");
                                            // SLine.SetRange("No.", DetailSalesStaging.invoice_item_number);
                                            //SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            SLine.SetFilter("Shipping Status", '%1|%2', 'SHIP', 'DELIVERED');
                                            //SLine.SetRange("Shipping Status", 'SHIP');
                                            if SLine.FindFirst() then begin
                                                SLine."Shipping Status" := 'COD RTO';
                                                //>>
                                                SalesReceiveblesetup.Get();
                                                SalRetHdr.Init();
                                                SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                                SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                                SalRetHdr.Validate("Sell-to Customer No.", SalHeader."Sell-to Customer No.");
                                                SalRetHdr.Validate(State, SalHeader.State);
                                                SalRetHdr."Sell-to E-Mail" := SalHeader."Sell-to E-Mail";
                                                SalRetHdr."Bill-to Name" := SalHeader."Bill-to Name";
                                                SalRetHdr."Bill-to Address" := SalHeader."Bill-to Address";
                                                SalRetHdr."Bill-to City" := SalHeader."Bill-to City";
                                                SalRetHdr."Bill-to Post Code" := SalHeader."Bill-to Post Code";
                                                SalRetHdr."Bill-to Country/Region Code" := SalHeader."Bill-to Country/Region Code";
                                                SalRetHdr."Ship-to Name" := SalHeader."Ship-to Name";
                                                SalRetHdr."Ship-to Address" := SalHeader."Ship-to Address";
                                                SalRetHdr."Ship-to City" := SalHeader."Ship-to City";
                                                SalRetHdr."Ship-to Code" := SalHeader."Ship-to Code";
                                                SalRetHdr."Ship-to Country/Region Code" := SalHeader."Ship-to Country/Region Code";
                                                SalRetHdr."Location Code" := SalHeader."Location Code";//location
                                                SalRetHdr.Validate("Billing Locality", SalHeader."Billing Locality");
                                                SalRetHdr.Validate("Billing State", SalHeader."Billing State");
                                                SalRetHdr.Validate("Billing Email", SalHeader."Billing Email");
                                                SalRetHdr.Validate("Billing Landmark", SalHeader."Billing Landmark");
                                                SalRetHdr.Validate("Shipping Locality", SalHeader."Shipping Locality");
                                                SalRetHdr.Validate("Shipping State", SalHeader."Shipping State");
                                                SalRetHdr.Validate("Shipping Landmark", SalHeader."Shipping Landmark");
                                                SalRetHdr."Bill-to Contact No." := SalHeader."Bill-to Contact No.";
                                                SalRetHdr."Sell-to Contact No." := SalHeader."Sell-to Contact No.";
                                                SalRetHdr."Salesperson Code" := SalHeader."Salesperson Code";
                                                //>>
                                                SalRetHdr.Validate("Promo Code", SalHeader."Promo Code");
                                                SalRetHdr.Validate("Invoice Discount Value", SalHeader."Invoice Discount Value");
                                                SalRetHdr.Validate("Redeem Points", SalHeader."Redeem Points");
                                                SalRetHdr.Validate("Redeem Points Credit", SalHeader."Redeem Points Credit");
                                                SalRetHdr.Validate("Shipping Amount", SalHeader."Shipping Amount");
                                                SalRetHdr.Validate("Duties & Taxes", SalHeader."Duties & Taxes");
                                                SalRetHdr.Validate("Total Price", SalHeader."Total Price");
                                                SalRetHdr.Validate("Date Added", SalHeader."Date Added");
                                                SalRetHdr.Validate("Date Modified", SalHeader."Date Modified");
                                                SalRetHdr.Validate("Order Status", SalHeader."Order Status");
                                                SalRetHdr.Validate(Currency, SalHeader.currency);
                                                SalRetHdr.Validate("Currency Rate", SalHeader."Currency Rate");
                                                SalRetHdr.Validate("State Tax Type", SalHeader."State Tax Type");
                                                SalRetHdr.Validate("Pan Number", SalHeader."Pan Number");
                                                // SalRetHdr.Validate("Gift Message", SalHeader."Gift Message");
                                                // SalRetHdr.Validate("Is Special Order", SalHeader."Is Special Order");
                                                // SalRetHdr.Validate("Special Message", SalHeader."Special Message");
                                                // SalRetHdr.Validate("COD Confirm", SalHeader."COD Confirm");
                                                SalRetHdr.Validate("Charge Back Remark", SalHeader."Charge Back Remark");
                                                SalRetHdr.Validate("Charge Back Date", SalHeader."Charge Back Date");
                                                SalRetHdr.Validate("Loyalty Point", SalHeader."Loyalty Point");
                                                SalRetHdr.Validate("Loyalty Percent", SalHeader."Loyalty Percent");
                                                SalRetHdr.Validate("Loyalty Unit", SalHeader."Loyalty Unit");
                                                SalRetHdr.Validate("Redeem Loyalty points", SalHeader."Redeem Loyalty points");
                                                SalRetHdr.Validate("New Shipping Address", SalHeader."New Shipping Address");
                                                SalRetHdr.Validate("Is Loyalty Free Ship", SalHeader."Is Loyalty Free Ship");
                                                SalRetHdr.Validate("Current loyalty Tier", SalHeader."Current loyalty Tier");
                                                SalRetHdr.Insert();
                                                //>>LINE
                                                SalRetLine.Init();
                                                SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                                SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                                SalRetLine."Line No." := 10000;
                                                SalRetLine.Validate(Type, SLine.Type);
                                                SalRetLine.Validate("No.", SLine."No.");
                                                SalRetLine."Product Id" := SLine."Product Id";
                                                SalRetLine."Aza Online Code" := SLine."Aza Online Code";
                                                SalRetLine."Location Code" := SLine."Location Code";
                                                SalRetLine.Validate(Quantity, SLine.Quantity);
                                                SalRetLine."Amount Including VAT" := SLine."Amount Including VAT";
                                                SalRetLine."Discount Percent By Aza" := SLine."Discount Percent By Aza";
                                                SalRetLine."Discount Percent By Desg" := SLine."Discount Percent By Desg";
                                                SalRetLine."Promo Discount" := SLine."Promo Discount";
                                                SalRetLine."Credit By Product" := SLine."Credit By Product";
                                                SalRetLine."Loyalty By Product" := SLine."Loyalty By Product";
                                                SalRetLine."Unit Price" := SLine."Unit Price";
                                                SalRetLine.Amount := SLine.Amount;
                                                SalRetLine."Unit Cost" := SLine."Unit Cost";
                                                SalRetLine."SubTotal 1" := SLine."SubTotal 1";
                                                SalRetLine."SubTotal 2" := SLine."SubTotal 2";
                                                SalRetLine.Validate("Line Discount Amount", SLine."Line Discount Amount");
                                                SalRetLine."Shipping Status" := SLine."Shipping Status";
                                                SalRetLine."Is Return And Exchange" := SLine."Is Return And Exchange";
                                                SalRetLine."Shipping Company Name" := SLine."Shipping Company Name";
                                                SalRetLine."Shipping Company Name RTV" := SLine."Shipping Company Name RTV";
                                                SalRetLine."Tracking Id" := SLine."Tracking Id";
                                                SalRetLine."Tracking Id RTV" := SLine."Tracking Id RTV";
                                                SalRetLine."Requested Delivery Date" := SLine."Requested Delivery Date";
                                                SalRetLine."Delivery Date RTV" := SLine."Delivery Date RTV";
                                                SalRetLine."Track date" := SLine."Track date";
                                                SalRetLine."Track Date RTV" := SLine."Track Date RTV";
                                                SalRetLine."Invoice Number" := SLine."Invoice Number";
                                                SalRetLine."Invoice Number RTV" := SLine."Invoice Number RTV";
                                                SalRetLine."Dispatch Date " := SLine."Dispatch Date ";
                                                SalRetLine."In Warehouse" := SLine."In Warehouse";
                                                SalRetLine."Shipment Date" := SLine."Shipment Date";
                                                SalRetLine."Ship Date RTV" := SLine."Ship Date RTV";
                                                SalRetLine."Net Weight" := SLine."Net Weight";
                                                SalRetLine."Ship Mode" := SLine."Ship Mode";
                                                SalRetLine."Loyalty Points" := SLine."Loyalty Points";
                                                SalRetLine."Loyalty Flag" := SLine."Loyalty Flag";
                                                SalRetLine."Estm Delivery Date" := SLine."Estm Delivery Date";
                                                SalRetLine."Is Customization Received" := SLine."Is Customization Received";
                                                SalRetLine."Is Blouse Customization Received" := SLine."Is Blouse Customization Received";
                                                SalRetLine."Alteration Charges" := SLine."Alteration Charges";

                                                SalRetLine."Line Amount" := SLine."Unit Price" - SLine."Line Discount Amount";
                                                SalRetLine.Insert();
                                                //<<returnorder
                                                // RefInvNumber.Reset();
                                                // RefInvNumber.SetRange("Document No.", SalRetHdr."No.");
                                                // RefInvNumber.SetRange("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                // RefInvNumber.SetRange("Source No.", SalRetHdr."Sell-to Customer No.");
                                                // if RefInvNumber.FindFirst() then begin
                                                //     RefInvNumber."Reference Invoice Nos." := SalHeader."No.";
                                                //     RefInvNumber.Verified := true;
                                                //     RefInvNumber.Modify();
                                                // end;
                                                SIH.Reset();
                                                SIH.SetRange("Order No.", SalHeader."No.");
                                                if SIH.FindSet() then
                                                    repeat
                                                        SIL.Reset();
                                                        SIL.SetRange("Document No.", SIH."No.");
                                                        SIL.SetRange(Type, SIL.Type::Item);
                                                        SIL.SetRange("No.", SalRetLine."No.");
                                                        //SIL.SetRange(Quantity, 1);
                                                        if SIL.FindFirst() then begin
                                                            RefInvNumber.Init();
                                                            RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                            RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                            RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                            RefInvNumber."Reference Invoice Nos." := SIL."Document No.";
                                                            RefInvNumber.Verified := true;
                                                            RefInvNumber.Insert();

                                                            SIL."Shipping Status" := 'RETURNED';
                                                            SIL.Modify();
                                                        end;
                                                    until SIH.Next() = 0;
                                                SSH.Reset();
                                                SSH.SetRange("Order No.", SalHeader."No.");
                                                if SSH.FindSet() then
                                                    repeat
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", SalRetLine."No.");
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'RETURNED';
                                                            SSL.Modify();

                                                        end;
                                                    until SSH.Next() = 0;

                                                //Posting>>
                                                SalRetHdr.Receive := true;
                                                SalRetHdr.Invoice := true;
                                                SalRetHdr.Modify();
                                                Clear(Salespost);
                                                Salespost.Run(SalRetHdr);
                                                Message('Return Order Posted');
                                                if SLine.Modify() then begin
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                    //Hash insertion>>>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                    SalesHash.Insert();
                                                end;
                                                //end;
                                            end;
                                        end;
                                    9:                   //Prepaid RTO
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SHeader."No.");
                                            // SLine.SetRange("No.", DetailSalesStaging.invoice_item_number);
                                            //SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            //SLine.SetRange("Shipping Status", 'SHIP');
                                            SLine.SetFilter("Shipping Status", '%1|%2', 'SHIP', 'DELIVERED');
                                            if SLine.FindFirst() then begin
                                                SLine."Shipping Status" := 'PREPAID RTO';
                                                //>>
                                                SalesReceiveblesetup.Get();
                                                SalRetHdr.Init();
                                                SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                                SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                                SalRetHdr.Validate("Sell-to Customer No.", SalHeader."Sell-to Customer No.");
                                                SalRetHdr.Validate(State, SalHeader.State);
                                                SalRetHdr."Sell-to E-Mail" := SalHeader."Sell-to E-Mail";
                                                SalRetHdr."Bill-to Name" := SalHeader."Bill-to Name";
                                                SalRetHdr."Bill-to Address" := SalHeader."Bill-to Address";
                                                SalRetHdr."Bill-to City" := SalHeader."Bill-to City";
                                                SalRetHdr."Bill-to Post Code" := SalHeader."Bill-to Post Code";
                                                SalRetHdr."Bill-to Country/Region Code" := SalHeader."Bill-to Country/Region Code";
                                                SalRetHdr."Ship-to Name" := SalHeader."Ship-to Name";
                                                SalRetHdr."Ship-to Address" := SalHeader."Ship-to Address";
                                                SalRetHdr."Ship-to City" := SalHeader."Ship-to City";
                                                SalRetHdr."Ship-to Code" := SalHeader."Ship-to Code";
                                                SalRetHdr."Ship-to Country/Region Code" := SalHeader."Ship-to Country/Region Code";
                                                SalRetHdr."Location Code" := SalHeader."Location Code";//location
                                                SalRetHdr.Validate("Billing Locality", SalHeader."Billing Locality");
                                                SalRetHdr.Validate("Billing State", SalHeader."Billing State");
                                                SalRetHdr.Validate("Billing Email", SalHeader."Billing Email");
                                                SalRetHdr.Validate("Billing Landmark", SalHeader."Billing Landmark");
                                                SalRetHdr.Validate("Shipping Locality", SalHeader."Shipping Locality");
                                                SalRetHdr.Validate("Shipping State", SalHeader."Shipping State");
                                                SalRetHdr.Validate("Shipping Landmark", SalHeader."Shipping Landmark");
                                                SalRetHdr."Bill-to Contact No." := SalHeader."Bill-to Contact No.";
                                                SalRetHdr."Sell-to Contact No." := SalHeader."Sell-to Contact No.";
                                                SalRetHdr."Salesperson Code" := SalHeader."Salesperson Code";
                                                //>>
                                                SalRetHdr.Validate("Promo Code", SalHeader."Promo Code");
                                                SalRetHdr.Validate("Invoice Discount Value", SalHeader."Invoice Discount Value");
                                                SalRetHdr.Validate("Redeem Points", SalHeader."Redeem Points");
                                                SalRetHdr.Validate("Redeem Points Credit", SalHeader."Redeem Points Credit");
                                                SalRetHdr.Validate("Shipping Amount", SalHeader."Shipping Amount");
                                                SalRetHdr.Validate("Duties & Taxes", SalHeader."Duties & Taxes");
                                                SalRetHdr.Validate("Total Price", SalHeader."Total Price");
                                                SalRetHdr.Validate("Date Added", SalHeader."Date Added");
                                                SalRetHdr.Validate("Date Modified", SalHeader."Date Modified");
                                                SalRetHdr.Validate("Order Status", SalHeader."Order Status");
                                                SalRetHdr.Validate(Currency, SalHeader.currency);
                                                SalRetHdr.Validate("Currency Rate", SalHeader."Currency Rate");
                                                SalRetHdr.Validate("State Tax Type", SalHeader."State Tax Type");
                                                SalRetHdr.Validate("Pan Number", SalHeader."Pan Number");
                                                // SalRetHdr.Validate("Gift Message", SalHeader."Gift Message");
                                                // SalRetHdr.Validate("Is Special Order", SalHeader."Is Special Order");
                                                // SalRetHdr.Validate("Special Message", SalHeader."Special Message");
                                                // SalRetHdr.Validate("COD Confirm", SalHeader."COD Confirm");
                                                SalRetHdr.Validate("Charge Back Remark", SalHeader."Charge Back Remark");
                                                SalRetHdr.Validate("Charge Back Date", SalHeader."Charge Back Date");
                                                SalRetHdr.Validate("Loyalty Point", SalHeader."Loyalty Point");
                                                SalRetHdr.Validate("Loyalty Percent", SalHeader."Loyalty Percent");
                                                SalRetHdr.Validate("Loyalty Unit", SalHeader."Loyalty Unit");
                                                SalRetHdr.Validate("Redeem Loyalty points", SalHeader."Redeem Loyalty points");
                                                SalRetHdr.Validate("New Shipping Address", SalHeader."New Shipping Address");
                                                SalRetHdr.Validate("Is Loyalty Free Ship", SalHeader."Is Loyalty Free Ship");
                                                SalRetHdr.Validate("Current loyalty Tier", SalHeader."Current loyalty Tier");
                                                SalRetHdr.Insert();
                                                //>>LINE
                                                SalRetLine.Init();
                                                SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                                SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                                SalRetLine."Line No." := 10000;
                                                SalRetLine.Validate(Type, SLine.Type);
                                                SalRetLine.Validate("No.", SLine."No.");
                                                SalRetLine."Product Id" := SLine."Product Id";
                                                SalRetLine."Aza Online Code" := SLine."Aza Online Code";
                                                SalRetLine."Location Code" := SLine."Location Code";
                                                SalRetLine.Validate(Quantity, SLine.Quantity);
                                                SalRetLine."Amount Including VAT" := SLine."Amount Including VAT";
                                                SalRetLine."Discount Percent By Aza" := SLine."Discount Percent By Aza";
                                                SalRetLine."Discount Percent By Desg" := SLine."Discount Percent By Desg";
                                                SalRetLine."Promo Discount" := SLine."Promo Discount";
                                                SalRetLine."Credit By Product" := SLine."Credit By Product";
                                                SalRetLine."Loyalty By Product" := SLine."Loyalty By Product";
                                                SalRetLine."Unit Price" := SLine."Unit Price";
                                                SalRetLine.Amount := SLine.Amount;
                                                SalRetLine."Unit Cost" := SLine."Unit Cost";
                                                SalRetLine."SubTotal 1" := SLine."SubTotal 1";
                                                SalRetLine."SubTotal 2" := SLine."SubTotal 2";
                                                SalRetLine.Validate("Line Discount Amount", SLine."Line Discount Amount");
                                                SalRetLine."Shipping Status" := SLine."Shipping Status";
                                                SalRetLine."Is Return And Exchange" := SLine."Is Return And Exchange";
                                                SalRetLine."Shipping Company Name" := SLine."Shipping Company Name";
                                                SalRetLine."Shipping Company Name RTV" := SLine."Shipping Company Name RTV";
                                                SalRetLine."Tracking Id" := SLine."Tracking Id";
                                                SalRetLine."Tracking Id RTV" := SLine."Tracking Id RTV";
                                                SalRetLine."Requested Delivery Date" := SLine."Requested Delivery Date";
                                                SalRetLine."Delivery Date RTV" := SLine."Delivery Date RTV";
                                                SalRetLine."Track date" := SLine."Track date";
                                                SalRetLine."Track Date RTV" := SLine."Track Date RTV";
                                                SalRetLine."Invoice Number" := SLine."Invoice Number";
                                                SalRetLine."Invoice Number RTV" := SLine."Invoice Number RTV";
                                                SalRetLine."Dispatch Date " := SLine."Dispatch Date ";
                                                SalRetLine."In Warehouse" := SLine."In Warehouse";
                                                SalRetLine."Shipment Date" := SLine."Shipment Date";
                                                SalRetLine."Ship Date RTV" := SLine."Ship Date RTV";
                                                SalRetLine."Net Weight" := SLine."Net Weight";
                                                SalRetLine."Ship Mode" := SLine."Ship Mode";
                                                SalRetLine."Loyalty Points" := SLine."Loyalty Points";
                                                SalRetLine."Loyalty Flag" := SLine."Loyalty Flag";
                                                SalRetLine."Estm Delivery Date" := SLine."Estm Delivery Date";
                                                SalRetLine."Is Customization Received" := SLine."Is Customization Received";
                                                SalRetLine."Is Blouse Customization Received" := SLine."Is Blouse Customization Received";
                                                SalRetLine."Alteration Charges" := SLine."Alteration Charges";

                                                SalRetLine."Line Amount" := SLine."Unit Price" - SLine."Line Discount Amount";
                                                SalRetLine.Insert();
                                                //<<returnorder
                                                // RefInvNumber.Reset();
                                                // RefInvNumber.SetRange("Document No.", SalRetHdr."No.");
                                                // RefInvNumber.SetRange("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                // RefInvNumber.SetRange("Source No.", SalRetHdr."Sell-to Customer No.");
                                                // if RefInvNumber.FindFirst() then begin
                                                //     RefInvNumber."Reference Invoice Nos." := SalHeader."No.";
                                                //     RefInvNumber.Verified := true;
                                                //     RefInvNumber.Modify();
                                                // end;
                                                SIH.Reset();
                                                SIH.SetRange("Order No.", SalHeader."No.");
                                                if SIH.FindSet() then
                                                    repeat
                                                        SIL.Reset();
                                                        SIL.SetRange("Document No.", SIH."No.");
                                                        SIL.SetRange(Type, SIL.Type::Item);
                                                        SIL.SetRange("No.", SalRetLine."No.");
                                                        //SIL.SetRange(Quantity, 1);
                                                        if SIL.FindFirst() then begin
                                                            RefInvNumber.Init();
                                                            RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                            RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                            RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                            RefInvNumber."Reference Invoice Nos." := SIL."Document No.";
                                                            RefInvNumber.Verified := true;
                                                            RefInvNumber.Insert();

                                                            SIL."Shipping Status" := 'RETURNED';
                                                            SIL.Modify();
                                                        end;
                                                    until SIH.Next() = 0;
                                                SSH.Reset();
                                                SSH.SetRange("Order No.", SalHeader."No.");
                                                if SSH.FindSet() then
                                                    repeat
                                                        SSL.Reset();
                                                        SSL.SetRange("Document No.", SSH."No.");
                                                        SSL.SetRange(Type, SIL.Type::Item);
                                                        SSL.SetRange("No.", SalRetLine."No.");
                                                        //SSL.SetRange(Quantity, 1);
                                                        if SSL.FindFirst() then begin
                                                            SSL."Shipping Status" := 'RETURNED';
                                                            SSL.Modify();
                                                        end;
                                                    until SSH.Next() = 0;

                                                //Posting>>
                                                SalRetHdr.Receive := true;
                                                SalRetHdr.Invoice := true;
                                                SalRetHdr.Modify();
                                                Clear(Salespost);
                                                Salespost.Run(SalRetHdr);
                                                Message('Return Order Posted');
                                                if SLine.Modify() then begin
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                    //Hash insertion>>>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                    SalesHash.Insert();
                                                end;
                                                //end;
                                            end;
                                        end;
                                    10:                  //DELIVERED
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SalHeader."No.");
                                            // SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                Sline."Shipping Status" := 'DELIVERED';
                                                if SLine.Modify() then begin///>
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                    //Hash insertion>>>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                    SalesHash.Insert();
                                                end;
                                            end;
                                            SalInvhdr.Reset();
                                            SalInvhdr.SetRange("Order No.", SalesStaging.order_id);
                                            if SalInvhdr.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SalInvline.Reset();
                                                        SalInvline.SetRange("Document No.", SalInvhdr."No.");
                                                        SalInvline.SetRange(Type, SIL.Type::Item);
                                                        SalInvline.SetRange("No.", Detailstage.barcode);
                                                        if SalInvline.FindFirst() then begin
                                                            // if SalInvline.Quantity <> 0 then begin
                                                            SalInvline."Shipping Status" := 'DELIVERED';
                                                            SalInvline.Modify();
                                                            // end;
                                                        end;
                                                    end;
                                                until SalInvhdr.Next() = 0;
                                            SalesShpHdr.Reset();
                                            SalesShpHdr.SetRange("Order No.", SalesStaging.order_id);
                                            if SalesShpHdr.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        salesshpLine.Reset();
                                                        salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
                                                        salesshpLine.SetRange(Type, SIL.Type::Item);
                                                        salesshpLine.SetRange("No.", Detailstage.barcode);
                                                        if salesshpLine.FindFirst() then begin
                                                            //if salesshpLine.Quantity <> 0 then begin
                                                            salesshpLine."Shipping Status" := 'DELIVERED';
                                                            salesshpLine.Modify();
                                                            //end;
                                                        end;
                                                    end;
                                                until SalesShpHdr.Next() = 0;
                                        end;
                                    11:                  //QC PASS
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SalHeader."No.");
                                            // SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                Sline."Shipping Status" := 'QC PASS';
                                                if SLine.Modify() then begin///>
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                    //Hash insertion>>>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                    SalesHash.Insert();
                                                end;
                                            end;
                                            SalInvhdr.Reset();
                                            SalInvhdr.SetRange("Order No.", SalesStaging.order_id);
                                            if SalInvhdr.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SalInvline.Reset();
                                                        SalInvline.SetRange("Document No.", SalInvhdr."No.");
                                                        SalInvline.SetRange(Type, SIL.Type::Item);
                                                        SalInvline.SetRange("No.", Detailstage.barcode);
                                                        if SalInvline.FindFirst() then begin
                                                            // if SalInvline.Quantity <> 0 then begin
                                                            SalInvline."Shipping Status" := 'QC PASS';
                                                            SalInvline.Modify();
                                                            // end;
                                                        end;
                                                    end;
                                                until SalInvhdr.Next() = 0;
                                            SalesShpHdr.Reset();
                                            SalesShpHdr.SetRange("Order No.", SalesStaging.order_id);
                                            if SalesShpHdr.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        salesshpLine.Reset();
                                                        salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
                                                        salesshpLine.SetRange(Type, SIL.Type::Item);
                                                        salesshpLine.SetRange("No.", Detailstage.barcode);
                                                        if salesshpLine.FindFirst() then begin
                                                            //if salesshpLine.Quantity <> 0 then begin
                                                            salesshpLine."Shipping Status" := 'QC PASS';
                                                            salesshpLine.Modify();
                                                            //end;
                                                        end;
                                                    end;
                                                until SalesShpHdr.Next() = 0;
                                        end;
                                    12:                  //PICKED
                                        begin
                                            SLine.Reset();
                                            SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                            SLine.SetRange("Document No.", SalHeader."No.");
                                            // SLine.SetRange("No.", txtBarcode);
                                            SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                            if SLine.FindFirst() then begin
                                                Sline."Shipping Status" := 'PICKED';
                                                if SLine.Modify() then begin///>
                                                    ActionStatus.Processed := true;
                                                    ActionStatus.Modify();
                                                    //Hash insertion>>>>>>>>>>>>
                                                    SalesHash.Init();
                                                    SalesHash.Validate(hash, ActionStatus.hash);
                                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                                    SalesHash.Insert();
                                                end;
                                            end;
                                            SalInvhdr.Reset();
                                            SalInvhdr.SetRange("Order No.", SalesStaging.order_id);
                                            if SalInvhdr.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        SalInvline.Reset();
                                                        SalInvline.SetRange("Document No.", SalInvhdr."No.");
                                                        SalInvline.SetRange(Type, SIL.Type::Item);
                                                        SalInvline.SetRange("No.", Detailstage.barcode);
                                                        if SalInvline.FindFirst() then begin
                                                            // if SalInvline.Quantity <> 0 then begin
                                                            SalInvline."Shipping Status" := 'PICKED';
                                                            SalInvline.Modify();
                                                            // end;
                                                        end;
                                                    end;
                                                until SalInvhdr.Next() = 0;
                                            SalesShpHdr.Reset();
                                            SalesShpHdr.SetRange("Order No.", SalesStaging.order_id);
                                            if SalesShpHdr.FindSet() then
                                                repeat
                                                    Detailstage.Reset();
                                                    Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                                    Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                                    if Detailstage.FindFirst() then begin
                                                        salesshpLine.Reset();
                                                        salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
                                                        salesshpLine.SetRange(Type, SIL.Type::Item);
                                                        salesshpLine.SetRange("No.", Detailstage.barcode);
                                                        if salesshpLine.FindFirst() then begin
                                                            //if salesshpLine.Quantity <> 0 then begin
                                                            salesshpLine."Shipping Status" := 'PICKED';
                                                            salesshpLine.Modify();
                                                            //end;
                                                        end;
                                                    end;
                                                until SalesShpHdr.Next() = 0;
                                        end;
                                end;
                                Message('After first action status %1', GetLastErrorText());
                            end;
                        until ActionStatus.Next() = 0;

                end;
            end;
        end else begin
            Evaluate(SOIDint, SHeader."No.");
            //Added 130623 New requirenmentKtn>>>>>>>>
            DetailSalesStaging.Reset();
            DetailSalesStaging.SetRange(order_id, SOIDint);
            DetailSalesStaging.SetRange("Line Created", false);
            if DetailSalesStaging.FindSet() then
                repeat
                    SlineUpdtd.Reset();
                    SlineUpdtd.SetRange("Document Type", SHeader."Document Type");
                    SlineUpdtd.SetRange("Document No.", SHeader."No.");
                    SlineUpdtd.SetRange("Line No.", DetailSalesStaging.order_detail_id);
                    if SlineUpdtd.FindFirst() then begin
                        if not Evaluate(FCLocation, DetailSalesStaging.fc_location) then Error('FC location %1 is not mapped in the master', FCLocation);
                        Location.Reset();
                        Location.SetRange("fc_location ID", FCLocation);
                        if Location.FindFirst() then begin
                            if SalesHeaderstat.Get(SalesHeaderstat."Document Type"::Order, SHeader."No.") then begin
                                if SalesHeaderstat.Status = SalesHeaderstat.Status::Released then
                                    SalesHeaderstat.Status := SalesHeaderstat.Status::Open;
                                SalesHeaderstat.Modify();
                            end;
                            SlineUpdtd.Validate("Location Code", Location.Code);
                            //SlineUpdtd."Location Code" := Location.Code;
                            //>>>>>
                            // if SalesHeaderstat1.Get(SalesHeaderstat1."Document Type"::Order, SHeader."No.") then begin
                            //     if SalesHeaderstat1.Status = SalesHeaderstat1.Status::Open then
                            //         SalesHeaderstat1.Status := SalesHeaderstat1.Status::Released;
                            //     SalesHeaderstat1.Modify();
                            // end;//commented120723ktn
                        end;

                        SlineUpdtd.Modify();
                        DetailSalesStaging."Line Created" := true;
                        DetailSalesStaging.Modify();
                    end;
                until DetailSalesStaging.Next() = 0;
            //<<<<<<<<<<<<<<<<
            ActionStatus.Reset();
            ActionStatus.SetRange(SO_ID, SOIDint);
            ActionStatus.SetRange(Processed, false);
            if ActionStatus.FindSet() then
                repeat
                    SalesHash.Reset();
                    // SalesHash.SetRange("So No.", Format(ActionStatus.SO_ID));
                    // SalesHash.SetRange("SO Detail ID", ActionStatus.SO_Detail_ID);
                    SalesHash.SetRange(hash, ActionStatus.hash);
                    if SalesHash.FindFirst() then
                        HashBool := true else begin
                        // SalesHash.Init();
                        // SalesHash.Validate(hash, ActionStatus.hash);
                        // SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                        // SalesHash.Validate("Action ID", ActionStatus."Action ID");
                        // SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                        // SalesHash.Insert();
                        case ActionStatus."Action ID" of
                            1:                   //proceessing
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        sline."Shipping Status" := 'OPEN';
                                        if SLine.Modify() then begin
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                    end;
                                    // Commit();
                                    // SHeader.PrepareOpeningDocumentStatistics();

                                end;
                            2:                    //RTV Alteration
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        SLine."Shipping Status" := 'RTV Alteration';
                                        SLine.Modify();
                                        ActionStatus.Processed := true;
                                        ActionStatus.Modify();
                                        SalesHash.Init();
                                        SalesHash.Validate(hash, ActionStatus.hash);
                                        SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                        SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                        SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                        SalesHash.Insert();
                                    end;
                                    // SLine.Reset();
                                    // SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    // SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    // //SLine.SetRange("No.", txtBarcode);
                                    // if SLine.FindFirst() then begin
                                    //     Clear(VendNo);
                                    //     Clear(ItemCost);
                                    //     if Item.Get(SLine."No.") then begin
                                    //         VendNo := Item."Vendor No.";
                                    //         ItemCost := Item."Unit Cost";
                                    //     end;
                                    //     if VendNo <> LastVendor then begin
                                    //         PurPaybleSetup.Get();
                                    //         PurHeader.Init();
                                    //         PurHeader."Document Type" := PurHeader."Document Type"::"Return Order";
                                    //         PurHeader."No." := NOSeriesMgmt.GetNextNo(PurPaybleSetup."Return Order Nos.", Today, true);
                                    //         PurHeader.Validate("Buy-from Vendor No.", VendNo);
                                    //         if PurHeader.Insert() then begin
                                    //             Message('RTV %1 Created', PurHeader."No.");
                                    //             SLine."Shipping Status" := 'RTV Alteration';
                                    //             SLine.Modify();
                                    //         end;
                                    //         PurLine.Init();
                                    //         PurLine."Document Type" := PurHeader."Document Type";
                                    //         PurLine."Document No." := PurHeader."No.";
                                    //         PurLine."Line No." := 10000;
                                    //         PurLine.Type := SLine.Type;
                                    //         PurLine.Validate("No.", SLine."No.");
                                    //         PurLine."Unit Price (LCY)" := ItemCost;
                                    //         PurLine.Validate(Quantity, SLine.Quantity);
                                    //         if PurLine.Insert() then begin
                                    //             ActionStatus.Processed := true;
                                    //             ActionStatus.Modify();
                                    //             boolupdated := true;
                                    //         end;
                                    //         LastVendor := VendNo;
                                    //         POOrderNo := PurHeader."No.";
                                    //     end else begin
                                    //         PurLine.Init();
                                    //         PurLine."Document Type" := PurLine."Document Type"::"Return Order";
                                    //         PurLine."Document No." := POOrderNo;
                                    //         PurLine."Line No." := DetailSalesStaging.order_detail_id;
                                    //         PurLine.Type := SLine.Type;
                                    //         PurLine.Validate("No.", SLine."No.");
                                    //         PurLine."Unit Price (LCY)" := ItemCost;
                                    //         PurLine.Validate(Quantity, SLine.Quantity);
                                    //         if PurLine.Insert() then begin
                                    //             ActionStatus.Processed := true;
                                    //             ActionStatus.Modify();
                                    //             boolupdated := true;
                                    //         end;
                                    //     end;
                                    // end;
                                    //For Status updation in posting documents>>>>>>>>>>>>>
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'RTV Alteration';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'RTV Alteration';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                end;
                            3:                    //RTV PERMANENT DONE
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        SLine."Shipping Status" := 'RTV PERMANENT DONE';
                                        SLine.Modify();
                                        ActionStatus.Processed := true;
                                        ActionStatus.Modify();
                                        SalesHash.Init();
                                        SalesHash.Validate(hash, ActionStatus.hash);
                                        SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                        SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                        SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                        SalesHash.Insert();
                                    end;
                                    // //<<<<<Purchase return Order>>>>>>>>>>>>>>>>
                                    // SLine.Reset();
                                    // SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    // SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    // //SLine.SetRange("No.", txtBarcode);
                                    // if SLine.FindFirst() then begin
                                    //     Clear(VendNo);
                                    //     Clear(ItemCost);
                                    //     if Item.Get(SLine."No.") then begin
                                    //         VendNo := Item."Vendor No.";
                                    //         ItemCost := Item."Unit Cost";
                                    //     end;
                                    //     if VendNo <> LastVendor then begin
                                    //         PurPaybleSetup.Get();
                                    //         PurHeader.Init();
                                    //         PurHeader."Document Type" := PurHeader."Document Type"::"Return Order";
                                    //         PurHeader."No." := NOSeriesMgmt.GetNextNo(PurPaybleSetup."Return Order Nos.", Today, true);
                                    //         PurHeader.Validate("Buy-from Vendor No.", VendNo);
                                    //         if PurHeader.Insert() then begin
                                    //             Message('RTV %1 Created', PurHeader."No.");
                                    //             SLine."Shipping Status" := 'RTV PERMANENT DONE';
                                    //             SLine.Modify();
                                    //         end;
                                    //         PurLine.Init();
                                    //         PurLine."Document Type" := PurHeader."Document Type";
                                    //         PurLine."Document No." := PurHeader."No.";
                                    //         PurLine."Line No." := 10000;
                                    //         PurLine.Type := SLine.Type;
                                    //         PurLine.Validate("No.", SLine."No.");
                                    //         PurLine."Unit Price (LCY)" := ItemCost;
                                    //         PurLine.Validate(Quantity, SLine.Quantity);
                                    //         if PurLine.Insert() then begin
                                    //             ActionStatus.Processed := true;
                                    //             ActionStatus.Modify();
                                    //             boolupdated := true;
                                    //         end;
                                    //         LastVendor := VendNo;
                                    //         POOrderNo := PurHeader."No.";
                                    //     end else begin
                                    //         PurLine.Init();
                                    //         PurLine."Document Type" := PurLine."Document Type"::"Return Order";
                                    //         PurLine."Document No." := POOrderNo;
                                    //         PurLine."Line No." := DetailSalesStaging.order_detail_id;
                                    //         PurLine.Type := SLine.Type;
                                    //         PurLine.Validate("No.", SLine."No.");
                                    //         PurLine."Unit Price (LCY)" := ItemCost;
                                    //         PurLine.Validate(Quantity, SLine.Quantity);
                                    //         if PurLine.Insert() then begin
                                    //             ActionStatus.Processed := true;
                                    //             ActionStatus.Modify();
                                    //             boolupdated := true;
                                    //         end;
                                    //     end;
                                    // end;
                                    //For Status updation in posting documents>>>>>>>>>>>>>
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'RTV PERMANENT DONE';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'RTV PERMANENT DONE';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                end;
                            4:                   //SHIPPED
                                begin
                                    /*  //ClearLastError();
                                      salesheader1.Reset();
                                      salesheader1.SetRange("Document Type", salesheader1."Document Type"::Order);
                                      salesheader1.SetRange("No.", SHeader."No.");
                                      salesheader1.SetRange(Status, salesheader1.Status::Released);
                                      if salesheader1.FindFirst() then begin
                                          salesheader1.Validate(Status, salesheader1.Status::Open);
                                          salesheader1.Modify(true);
                                      end;

                                      //for clear//>>>>>>>>
                                      SLineClr.Reset();
                                      SLineClr.SetRange("Document Type", SLineClr."Document Type"::Order);
                                      SLineClr.SetRange("Document No.", SHeader."No.");
                                      SLineClr.SetFilter("Qty. to Ship", '<>%1', 0);
                                      if SLineClr.FindSet(true) then
                                          repeat
                                              SLineClr.Validate("Qty. to Ship", 0);
                                              SLineClr.Modify(true);
                                          until SLineClr.Next() = 0;

                                      ActionStatus1.Reset();
                                      ActionStatus1.SetRange(SO_ID, SOIDint);
                                      ActionStatus1.SetRange(Processed, false);
                                      ActionStatus1.SetRange("Action ID", 4);
                                      if ActionStatus1.FindSet() then
                                          repeat
                                              SLineMulStatus.Reset();
                                              SLineMulStatus.SetRange("Document Type", SLineMulStatus."Document Type"::Order);
                                              SLineMulStatus.SetRange("Document No.", SHeader."No.");
                                              SLineMulStatus.SetRange("Line No.", ActionStatus1.SO_Detail_ID);
                                              if SLineMulStatus.FindFirst() then begin
                                                  SLineMulStatus.Validate("Qty. to Ship", 1);
                                                  SLineMulStatus."Shipping Status" := 'SHIP';
                                                  SLineMulStatus.Modify(true);
                                                  // ActionStatus1.Processed := true;
                                                  // ActionStatus1.Modify();
                                              end;
                                          // ActionStatus1.Processed := true;
                                          // ActionStatus1.Modify();
                                          until ActionStatus1.Next() = 0;

                                      //shippingchargeline>>>>>>>>>>>>>>>>>>>>>>>>
                                      SLine1.Reset();
                                      SLine1.SetRange("Document Type", SLine1."Document Type"::Order);
                                      SLine1.SetRange("Document No.", SHeader."No.");
                                      SLine1.SetFilter("Quantity Shipped", '>%1', 0);
                                      if not SLine1.FindFirst() then begin
                                          // SLine1.Reset();
                                          // SLine1.SetRange("Document Type", SLine1."Document Type"::Order);
                                          // SLine1.SetRange("Document No.", SHeader."No.");
                                          // SLine1.SetRange(Type, SLine1.Type::"Charge (Item)");
                                          // if SLine1.FindFirst() then
                                          //     repeat //begin
                                          //         SLine1.Validate("Qty. to Ship", 1);
                                          //         SLine1."Shipping Status" := 'SHIP';
                                          //         SLine1.Modify(true);

                                          //         SLine2.Reset();
                                          //         SLine2.SetRange("Document Type", SLine1."Document Type"::Order);
                                          //         SLine2.SetRange("Document No.", SHeader."No.");
                                          //         SLine2.SetFilter("Qty. to Ship", '>%1', 0);
                                          //         SLine2.SetFilter(Type, '<>%1', SLine2.Type::"Charge (Item)");
                                          //         if SLine2.FindFirst() then begin
                                          //             // ItemChargeAssignment.Reset();
                                          //             // ItemChargeAssignment.SetRange("Document Type", ItemChargeAssignment."Document Type"::Order);
                                          //             // ItemChargeAssignment.SetRange("Document No.", SLine2."Document No.");
                                          //             // if ItemChargeAssignment.FindSet() then
                                          //             //     ItemChargeAssignment.DeleteAll();
                                          //             LineNo1 := SLine2."Line No." + 10011;
                                          //             ItemChargeAssignment.Init();
                                          //             ItemChargeAssignment.Validate("Document Type", ItemChargeAssignment."Document Type"::Order);
                                          //             ItemChargeAssignment.Validate("Document No.", SLine2."Document No.");
                                          //             ItemChargeAssignment.Validate("Document Line No.", SLine1."Line No.");
                                          //             ItemChargeAssignment.Validate("Line No.", lineNo1);
                                          //             ItemChargeAssignment.Insert();
                                          //             ItemChargeAssignment.Validate("Applies-to Doc. No.", SLine2."Document No.");
                                          //             ItemChargeAssignment.Validate("Applies-to Doc. Type", ItemChargeAssignment."Document Type"::Order);
                                          //             ItemChargeAssignment.Validate("Applies-to Doc. Line No.", SLine2."Line No.");
                                          //             ItemChargeAssignment.Validate("Item No.", SLine2."No.");
                                          //             ItemChargeAssignment.Validate("Qty. to Assign", 1);
                                          //             // ItemChargeAssignment."Qty. to Assign" := 1;
                                          //             // ItemChargeAssignment."Amount to Assign" := SLine1."Unit Price";
                                          //             //ItemChargeAssignment.Validate("Amount to Assign", SLine1."Line Amount");
                                          //             if ItemChargeAssignment.Modify() then
                                          //                 Message('Item Charge line inserted');

                                          //         end;
                                          //     until SLine1.Next() = 0; // end;
                                          SLine2.Reset();
                                          SLine2.SetRange("Document Type", SLine1."Document Type"::Order);
                                          SLine2.SetRange("Document No.", SHeader."No.");
                                          SLine2.SetFilter("Qty. to Ship", '>%1', 0);
                                          SLine2.SetFilter(Type, '<>%1', SLine2.Type::"Charge (Item)");
                                          if SLine2.FindFirst() then begin
                                              lineNo1 := SLine2."Line No.";
                                              SLine1.Reset();
                                              SLine1.SetRange("Document Type", SLine1."Document Type"::Order);
                                              SLine1.SetRange("Document No.", SHeader."No.");
                                              SLine1.SetRange(Type, SLine1.Type::"Charge (Item)");
                                              if SLine1.FindSet() then
                                                  repeat //begin
                                                      SLine1.Validate("Qty. to Ship", 1);
                                                      SLine1."Shipping Status" := 'SHIP';
                                                      SLine1.Modify(true);
                                                      LineNo1 := LineNo1 + 10001;

                                                      ItemChargeAssignment1.Reset();
                                                      ItemChargeAssignment1.SetRange("Document Type", ItemChargeAssignment."Document Type"::Order);
                                                      ItemChargeAssignment1.SetRange("Document No.", SLine2."Document No.");
                                                      ItemChargeAssignment1.SetRange("Document Line No.", SLine1."Line No.");
                                                      ItemChargeAssignment1.SetRange("Line No.", lineNo1);
                                                      if not ItemChargeAssignment1.FindFirst() then begin
                                                          ItemChargeAssignment.Init();
                                                          ItemChargeAssignment.Validate("Document Type", ItemChargeAssignment."Document Type"::Order);
                                                          ItemChargeAssignment.Validate("Document No.", SLine2."Document No.");
                                                          ItemChargeAssignment.Validate("Document Line No.", SLine1."Line No.");
                                                          ItemChargeAssignment.Validate("Line No.", lineNo1);
                                                          ItemChargeAssignment.Insert();
                                                          ItemChargeAssignment.Validate("Applies-to Doc. No.", SLine2."Document No.");
                                                          ItemChargeAssignment.Validate("Applies-to Doc. Type", ItemChargeAssignment."Document Type"::Order);
                                                          ItemChargeAssignment.Validate("Applies-to Doc. Line No.", SLine2."Line No.");
                                                          ItemChargeAssignment.Validate("Item No.", SLine2."No.");
                                                          ItemChargeAssignment.Validate("Qty. to Assign", 1);
                                                          // ItemChargeAssignment."Qty. to Assign" := 1;
                                                          // ItemChargeAssignment."Amount to Assign" := SLine1."Unit Price";
                                                          //ItemChargeAssignment.Validate("Amount to Assign", SLine1."Line Amount");
                                                          // if ItemChargeAssignment.Modify() then
                                                          //     Message('Item Charge line inserted');
                                                          ItemChargeAssignment.Modify();
                                                          Message('Item Charge line inserted');
                                                      end;
                                                  until SLine1.Next() = 0; // end;
                                          end;
                                      end;
                                      //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

                                      //<<<<Posting>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                      SLine.Reset();
                                      SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                      SLine.SetRange("Document No.", SHeader."No.");
                                      SLine.SetFilter("Qty. to Ship", '<>%1', 0);
                                      if SLine.FindFirst() then begin
                                          Clear(salesheader3);
                                          if salesheader3.Get(1, SHeader."No.") then begin
                                              salesheader3.Validate(Status, salesheader3.Status::Released);
                                              salesheader3.Modify();
                                              salesheader3.Ship := true;
                                              salesheader3.Invoice := true;
                                              //SHeader.Modify();
                                              //Commit();

                                              if Not postSalesOrderShipment(salesheader3) then begin
                                                  if GetLastErrorText() <> '' then begin
                                                      SalesShpHdr.Reset();
                                                      SalesShpHdr.SetRange("Order No.", SHeader."No.");
                                                      if SalesShpHdr.FindLast() then begin
                                                          // salesshpLine.Reset();
                                                          // salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
                                                          // if not salesshpLine.FindFirst() then begin
                                                          SalesShpHdr."No. Printed" := 1;
                                                          SalesShpHdr.Modify();
                                                          SalesShpHdr.Delete(true);
                                                          //Message('ship hdr delete due to error');
                                                          //exit(false);
                                                          // end;
                                                      end;
                                                      SalesInvoiceHdr.Reset();
                                                      SalesInvoiceHdr.SetRange("Order No.", SHeader."No.");
                                                      if SalesInvoiceHdr.FindLast() then begin
                                                          SalesInvoiceHdr."No. Printed" := 1;
                                                          SalesInvoiceHdr.Modify();
                                                          SalesInvoiceHdr.Delete(true);
                                                      end;

                                                      if salesheader4.Get(1, SHeader."No.") then begin
                                                          salesheader4.Validate(Status, salesheader4.Status::Open);
                                                          salesheader4.Modify();
                                                      end;
                                                      SLineOP.Reset();
                                                      SLineOP.SetRange("Document Type", SLineOP."Document Type"::Order);
                                                      SLineOP.SetRange("Document No.", SHeader."No.");
                                                      SLineOP.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                                      if SLineOP.FindFirst() then begin
                                                          SLineOP.Validate("Qty. to Ship", 0);
                                                          SLineOP."Shipping Status" := 'OPEN';
                                                          //SLineOP.Modify(true);
                                                          SLineOP.Modify();
                                                      end;
                                                  end;
                                              end else begin
                                                  ActionStatus.Processed := true;
                                                  ActionStatus.Modify();
                                                  boolupdated := true;
                                                  Message('Sales order %1 posted', SHeader."No.");
                                              end;
                                          end;
                                      end;
                                 */
                                    SalesHash.Init();
                                    SalesHash.Validate(hash, ActionStatus.hash);
                                    SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                    SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                    SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                    SalesHash.Insert();
                                end;
                            13:                    //CANCELED
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        SLine."Shipping Status" := 'CANCELED';
                                        SLine.Validate("Qty. to Ship", 0);
                                        if SLine.Modify() then begin
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                        end;
                                    end;
                                    //SlineTabmodifyerror

                                    //For Status updation in posting documents>>>>>>>>>>>>>
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'CANCELED';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'CANCELED';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                end;
                            5:                    //CANCELLED
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    //SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        SLine."Shipping Status" := 'CANCELLED';
                                        SLine.Validate("Qty. to Ship", 0);
                                        if SLine.Modify() then begin
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                    end;
                                    //SlineTabmodifyerror

                                    //For Status updation in posting documents>>>>>>>>>>>>>
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'CANCELLED';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'CANCELLED';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                end;
                            6:                   //REVERSE PICKUP DONE
                                begin
                                    // Clear(txtBarcode);
                                    // if StrLen(DetailSalesStaging.barcode) > 20 then
                                    //     txtBarcode := CopyStr(DetailSalesStaging.barcode, StrLen(DetailSalesStaging.barcode) - 20 + 1)
                                    // else
                                    //     txtBarcode := DetailSalesStaging.barcode;
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    //SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        sline."Shipping Status" := 'REVERSE PICKUP DONE';
                                        if SLine.Modify() then begin///>
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                    end;

                                    //For Status updation in posting documents>>>>>>>>>>>>>
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'REVERSE PICKUP DONE';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                    SSH.Reset();
                                    SSH.SetRange("Order No.", SHeader."No.");
                                    if SSH.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", Detailstage.barcode);
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'REVERSE PICKUP DONE';
                                                    SSL.Modify();
                                                end;
                                            end;
                                        until SSH.Next() = 0;
                                end;
                            7:                    //RETURNED
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("No.", DetailSalesStaging.invoice_item_number);
                                    //SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    //SLine.SetFilter("Shipping Status", '%1|%2', 'SHIP', 'DELIVERED');
                                    if SLine.FindFirst() then begin
                                        SLine."Shipping Status" := 'RETURNED';
                                        //>>
                                        SalesReceiveblesetup.Get();
                                        SalRetHdr.Init();
                                        SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                        SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                        SalRetHdr.Validate("Sell-to Customer No.", SHeader."Sell-to Customer No.");
                                        SalRetHdr.Validate(State, SHeader.State);
                                        SalRetHdr."Sell-to E-Mail" := SHeader."Sell-to E-Mail";
                                        SalRetHdr."Bill-to Name" := SHeader."Bill-to Name";
                                        SalRetHdr."Bill-to Address" := SHeader."Bill-to Address";
                                        SalRetHdr."Bill-to City" := SHeader."Bill-to City";
                                        SalRetHdr."Bill-to Post Code" := SHeader."Bill-to Post Code";
                                        SalRetHdr."Bill-to Country/Region Code" := SHeader."Bill-to Country/Region Code";
                                        SalRetHdr."Ship-to Name" := SHeader."Ship-to Name";
                                        SalRetHdr."Ship-to Address" := SHeader."Ship-to Address";
                                        SalRetHdr."Ship-to City" := SHeader."Ship-to City";
                                        SalRetHdr."Ship-to Code" := SHeader."Ship-to Code";
                                        SalRetHdr."Ship-to Country/Region Code" := SHeader."Ship-to Country/Region Code";
                                        //SalRetHdr."Location Code" := SHeader."Location Code";//location
                                        SalRetHdr.Validate("Location Code", SHeader."Location Code");
                                        SalRetHdr.Validate("Billing Locality", SHeader."Billing Locality");
                                        SalRetHdr.Validate("Billing State", SHeader."Billing State");
                                        SalRetHdr.Validate("Billing Email", SHeader."Billing Email");
                                        SalRetHdr.Validate("Billing Landmark", SHeader."Billing Landmark");
                                        SalRetHdr.Validate("Shipping Locality", SHeader."Shipping Locality");
                                        SalRetHdr.Validate("Shipping State", SHeader."Shipping State");
                                        SalRetHdr.Validate("Shipping Landmark", SHeader."Shipping Landmark");
                                        SalRetHdr."Bill-to Contact No." := SHeader."Bill-to Contact No.";
                                        SalRetHdr."Sell-to Contact No." := SHeader."Sell-to Contact No.";
                                        SalRetHdr."Salesperson Code" := SHeader."Salesperson Code";
                                        //>>
                                        SalRetHdr.Validate("Promo Code", SHeader."Promo Code");
                                        SalRetHdr.Validate("Invoice Discount Value", SHeader."Invoice Discount Value");
                                        SalRetHdr.Validate("Redeem Points", SHeader."Redeem Points");
                                        SalRetHdr.Validate("Redeem Points Credit", SHeader."Redeem Points Credit");
                                        SalRetHdr.Validate("Shipping Amount", SHeader."Shipping Amount");
                                        SalRetHdr.Validate("Duties & Taxes", SHeader."Duties & Taxes");
                                        SalRetHdr.Validate("Total Price", SHeader."Total Price");
                                        SalRetHdr.Validate("Date Added", SHeader."Date Added");
                                        SalRetHdr.Validate("Date Modified", SHeader."Date Modified");
                                        SalRetHdr.Validate("Order Status", SHeader."Order Status");
                                        SalRetHdr.Validate(Currency, SHeader.currency);
                                        SalRetHdr.Validate("Currency Rate", SHeader."Currency Rate");
                                        SalRetHdr.Validate("State Tax Type", SHeader."State Tax Type");
                                        SalRetHdr.Validate("Pan Number", SHeader."Pan Number");
                                        // SalRetHdr.Validate("Gift Message", SHeader."Gift Message");
                                        // SalRetHdr.Validate("Is Special Order", SHeader."Is Special Order");
                                        // SalRetHdr.Validate("Special Message", SHeader."Special Message");
                                        // SalRetHdr.Validate("COD Confirm", SHeader."COD Confirm");
                                        SalRetHdr.Validate("Charge Back Remark", SHeader."Charge Back Remark");
                                        SalRetHdr.Validate("Charge Back Date", SHeader."Charge Back Date");
                                        SalRetHdr.Validate("Loyalty Point", SHeader."Loyalty Point");
                                        SalRetHdr.Validate("Loyalty Percent", SHeader."Loyalty Percent");
                                        SalRetHdr.Validate("Loyalty Unit", SHeader."Loyalty Unit");
                                        SalRetHdr.Validate("Redeem Loyalty points", SHeader."Redeem Loyalty points");
                                        SalRetHdr.Validate("New Shipping Address", SHeader."New Shipping Address");
                                        SalRetHdr.Validate("Is Loyalty Free Ship", SHeader."Is Loyalty Free Ship");
                                        SalRetHdr.Validate("Current loyalty Tier", SHeader."Current loyalty Tier");
                                        SalRetHdr.Insert();
                                        //>>LINE
                                        SalRetLine.Init();
                                        SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                        SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                        SalRetLine."Line No." := 10000;
                                        SalRetLine.Validate(Type, SLine.Type);
                                        // Clear(txtBarcode);
                                        // if StrLen(DetailSalesStaging.barcode) > 20 then
                                        //     txtBarcode := CopyStr(DetailSalesStaging.barcode, StrLen(DetailSalesStaging.barcode) - 20 + 1)
                                        // else
                                        //     txtBarcode := DetailSalesStaging.barcode;
                                        SalRetLine.Validate("No.", SLine."No.");
                                        SalRetLine."Product Id" := SLine."Product Id";
                                        SalRetLine."Aza Online Code" := SLine."Aza Online Code";
                                        SalRetLine."Location Code" := SLine."Location Code";
                                        SalRetLine.Validate(Quantity, SLine.Quantity);
                                        SalRetLine."Amount Including VAT" := SLine."Amount Including VAT";
                                        SalRetLine."Discount Percent By Aza" := SLine."Discount Percent By Aza";
                                        SalRetLine."Discount Percent By Desg" := SLine."Discount Percent By Desg";
                                        SalRetLine."Promo Discount" := SLine."Promo Discount";
                                        SalRetLine."Credit By Product" := SLine."Credit By Product";
                                        SalRetLine."Loyalty By Product" := SLine."Loyalty By Product";
                                        SalRetLine."Unit Price" := SLine."Unit Price";
                                        SalRetLine.Amount := SLine.Amount;
                                        SalRetLine."Unit Cost" := SLine."Unit Cost";
                                        SalRetLine."SubTotal 1" := SLine."SubTotal 1";
                                        SalRetLine."SubTotal 2" := SLine."SubTotal 2";
                                        SalRetLine.Validate("Line Discount Amount", SLine."Line Discount Amount");
                                        SalRetLine."Shipping Status" := SLine."Shipping Status";
                                        SalRetLine."Is Return And Exchange" := SLine."Is Return And Exchange";
                                        SalRetLine."Shipping Company Name" := SLine."Shipping Company Name";
                                        SalRetLine."Shipping Company Name RTV" := SLine."Shipping Company Name RTV";
                                        SalRetLine."Tracking Id" := SLine."Tracking Id";
                                        SalRetLine."Tracking Id RTV" := SLine."Tracking Id RTV";
                                        SalRetLine."Requested Delivery Date" := SLine."Requested Delivery Date";
                                        SalRetLine."Delivery Date RTV" := SLine."Delivery Date RTV";
                                        SalRetLine."Track date" := SLine."Track date";
                                        SalRetLine."Track Date RTV" := SLine."Track Date RTV";
                                        SalRetLine."Invoice Number" := SLine."Invoice Number";
                                        SalRetLine."Invoice Number RTV" := SLine."Invoice Number RTV";
                                        SalRetLine."Dispatch Date " := SLine."Dispatch Date ";
                                        SalRetLine."In Warehouse" := SLine."In Warehouse";
                                        SalRetLine."Shipment Date" := SLine."Shipment Date";
                                        SalRetLine."Ship Date RTV" := SLine."Ship Date RTV";
                                        SalRetLine."Net Weight" := SLine."Net Weight";
                                        SalRetLine."Ship Mode" := SLine."Ship Mode";
                                        SalRetLine."Loyalty Points" := SLine."Loyalty Points";
                                        SalRetLine."Loyalty Flag" := SLine."Loyalty Flag";
                                        SalRetLine."Estm Delivery Date" := SLine."Estm Delivery Date";
                                        SalRetLine."Is Customization Received" := SLine."Is Customization Received";
                                        SalRetLine."Is Blouse Customization Received" := SLine."Is Blouse Customization Received";
                                        SalRetLine."Alteration Charges" := SLine."Alteration Charges";
                                        SalRetLine."Line Amount" := SLine."Unit Price" - SLine."Line Discount Amount";
                                        SalRetLine.Insert();
                                        //<<returnorder
                                        // RefInvNumber.Reset();
                                        // RefInvNumber.SetRange("Document No.", SalRetHdr."No.");
                                        // RefInvNumber.SetRange("Document Type", RefInvNumber."Document Type"::"Return Order");
                                        // RefInvNumber.SetRange("Source No.", SalRetHdr."Sell-to Customer No.");
                                        // if RefInvNumber.FindFirst() then begin
                                        SIH.Reset();
                                        SIH.SetRange("Order No.", SHeader."No.");
                                        if SIH.FindSet() then
                                            repeat
                                                SIL.Reset();
                                                SIL.SetRange("Document No.", SIH."No.");
                                                SIL.SetRange(Type, SIL.Type::Item);
                                                SIL.SetRange("No.", SalRetLine."No.");
                                                //SIL.SetRange(Quantity, 1);
                                                if SIL.FindFirst() then begin
                                                    RefInvNumber.Init();
                                                    RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                    RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                    RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                    RefInvNumber."Reference Invoice Nos." := SIL."Document No.";
                                                    RefInvNumber.Verified := true;
                                                    RefInvNumber.Insert();

                                                    SIL."Shipping Status" := 'RETURNED';
                                                    SIL.Modify();
                                                end;
                                            until SIH.Next() = 0;
                                        SSH.Reset();
                                        SSH.SetRange("Order No.", SHeader."No.");
                                        if SSH.FindSet() then
                                            repeat
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", SalRetLine."No.");
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'RETURNED';
                                                    SSL.Modify();
                                                end;
                                            until SSH.Next() = 0;

                                        //end;
                                        //Posting>>
                                        SalRetHdr.Receive := true;
                                        SalRetHdr.Invoice := true;
                                        SalRetHdr.Modify();
                                        Clear(Salespost);
                                        Salespost.Run(SalRetHdr);
                                        Message('Return Order Posted');
                                        if SLine.Modify() then begin
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                        //end;
                                    end;
                                end;
                            8:                    //COD RTO
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("No.", DetailSalesStaging.invoice_item_number);
                                    //SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    // SLine.SetRange("Shipping Status", 'SHIP');
                                    SLine.SetFilter("Shipping Status", '%1|%2', 'SHIP', 'DELIVERED');
                                    if SLine.FindFirst() then begin
                                        SLine."Shipping Status" := 'COD RTO';
                                        //>>
                                        SalesReceiveblesetup.Get();
                                        SalRetHdr.Init();
                                        SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                        SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                        SalRetHdr.Validate("Sell-to Customer No.", SHeader."Sell-to Customer No.");
                                        SalRetHdr.Validate(State, SHeader.State);
                                        SalRetHdr."Sell-to E-Mail" := SHeader."Sell-to E-Mail";
                                        SalRetHdr."Bill-to Name" := SHeader."Bill-to Name";
                                        SalRetHdr."Bill-to Address" := SHeader."Bill-to Address";
                                        SalRetHdr."Bill-to City" := SHeader."Bill-to City";
                                        SalRetHdr."Bill-to Post Code" := SHeader."Bill-to Post Code";
                                        SalRetHdr."Bill-to Country/Region Code" := SHeader."Bill-to Country/Region Code";
                                        SalRetHdr."Ship-to Name" := SHeader."Ship-to Name";
                                        SalRetHdr."Ship-to Address" := SHeader."Ship-to Address";
                                        SalRetHdr."Ship-to City" := SHeader."Ship-to City";
                                        SalRetHdr."Ship-to Code" := SHeader."Ship-to Code";
                                        SalRetHdr."Ship-to Country/Region Code" := SHeader."Ship-to Country/Region Code";
                                        // SalRetHdr."Location Code" := SHeader."Location Code";//location
                                        SalRetHdr.Validate("Location Code", SHeader."Location Code");
                                        SalRetHdr.Validate("Billing Locality", SHeader."Billing Locality");
                                        SalRetHdr.Validate("Billing State", SHeader."Billing State");
                                        SalRetHdr.Validate("Billing Email", SHeader."Billing Email");
                                        SalRetHdr.Validate("Billing Landmark", SHeader."Billing Landmark");
                                        SalRetHdr.Validate("Shipping Locality", SHeader."Shipping Locality");
                                        SalRetHdr.Validate("Shipping State", SHeader."Shipping State");
                                        SalRetHdr.Validate("Shipping Landmark", SHeader."Shipping Landmark");
                                        SalRetHdr."Bill-to Contact No." := SHeader."Bill-to Contact No.";
                                        SalRetHdr."Sell-to Contact No." := SHeader."Sell-to Contact No.";
                                        SalRetHdr."Salesperson Code" := SHeader."Salesperson Code";
                                        //>>
                                        SalRetHdr.Validate("Promo Code", SHeader."Promo Code");
                                        SalRetHdr.Validate("Invoice Discount Value", SHeader."Invoice Discount Value");
                                        SalRetHdr.Validate("Redeem Points", SHeader."Redeem Points");
                                        SalRetHdr.Validate("Redeem Points Credit", SHeader."Redeem Points Credit");
                                        SalRetHdr.Validate("Shipping Amount", SHeader."Shipping Amount");
                                        SalRetHdr.Validate("Duties & Taxes", SHeader."Duties & Taxes");
                                        SalRetHdr.Validate("Total Price", SHeader."Total Price");
                                        SalRetHdr.Validate("Date Added", SHeader."Date Added");
                                        SalRetHdr.Validate("Date Modified", SHeader."Date Modified");
                                        SalRetHdr.Validate("Order Status", SHeader."Order Status");
                                        SalRetHdr.Validate(Currency, SHeader.currency);
                                        SalRetHdr.Validate("Currency Rate", SHeader."Currency Rate");
                                        SalRetHdr.Validate("State Tax Type", SHeader."State Tax Type");
                                        SalRetHdr.Validate("Pan Number", SHeader."Pan Number");
                                        // SalRetHdr.Validate("Gift Message", SHeader."Gift Message");
                                        // SalRetHdr.Validate("Is Special Order", SHeader."Is Special Order");
                                        // SalRetHdr.Validate("Special Message", SHeader."Special Message");
                                        // SalRetHdr.Validate("COD Confirm", SHeader."COD Confirm");
                                        SalRetHdr.Validate("Charge Back Remark", SHeader."Charge Back Remark");
                                        SalRetHdr.Validate("Charge Back Date", SHeader."Charge Back Date");
                                        SalRetHdr.Validate("Loyalty Point", SHeader."Loyalty Point");
                                        SalRetHdr.Validate("Loyalty Percent", SHeader."Loyalty Percent");
                                        SalRetHdr.Validate("Loyalty Unit", SHeader."Loyalty Unit");
                                        SalRetHdr.Validate("Redeem Loyalty points", SHeader."Redeem Loyalty points");
                                        SalRetHdr.Validate("New Shipping Address", SHeader."New Shipping Address");
                                        SalRetHdr.Validate("Is Loyalty Free Ship", SHeader."Is Loyalty Free Ship");
                                        SalRetHdr.Validate("Current loyalty Tier", SHeader."Current loyalty Tier");
                                        SalRetHdr.Insert();
                                        //>>LINE
                                        SalRetLine.Init();
                                        SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                        SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                        SalRetLine."Line No." := 10000;
                                        SalRetLine.Validate(Type, SLine.Type);
                                        SalRetLine.Validate("No.", SLine."No.");
                                        SalRetLine."Product Id" := SLine."Product Id";
                                        SalRetLine."Aza Online Code" := SLine."Aza Online Code";
                                        SalRetLine."Location Code" := SLine."Location Code";
                                        SalRetLine.Validate(Quantity, SLine.Quantity);
                                        SalRetLine."Amount Including VAT" := SLine."Amount Including VAT";
                                        SalRetLine."Discount Percent By Aza" := SLine."Discount Percent By Aza";
                                        SalRetLine."Discount Percent By Desg" := SLine."Discount Percent By Desg";
                                        SalRetLine."Promo Discount" := SLine."Promo Discount";
                                        SalRetLine."Credit By Product" := SLine."Credit By Product";
                                        SalRetLine."Loyalty By Product" := SLine."Loyalty By Product";
                                        SalRetLine."Unit Price" := SLine."Unit Price";
                                        SalRetLine.Amount := SLine.Amount;
                                        SalRetLine."Unit Cost" := SLine."Unit Cost";
                                        SalRetLine."SubTotal 1" := SLine."SubTotal 1";
                                        SalRetLine."SubTotal 2" := SLine."SubTotal 2";
                                        SalRetLine.Validate("Line Discount Amount", SLine."Line Discount Amount");
                                        SalRetLine."Shipping Status" := SLine."Shipping Status";
                                        SalRetLine."Is Return And Exchange" := SLine."Is Return And Exchange";
                                        SalRetLine."Shipping Company Name" := SLine."Shipping Company Name";
                                        SalRetLine."Shipping Company Name RTV" := SLine."Shipping Company Name RTV";
                                        SalRetLine."Tracking Id" := SLine."Tracking Id";
                                        SalRetLine."Tracking Id RTV" := SLine."Tracking Id RTV";
                                        SalRetLine."Requested Delivery Date" := SLine."Requested Delivery Date";
                                        SalRetLine."Delivery Date RTV" := SLine."Delivery Date RTV";
                                        SalRetLine."Track date" := SLine."Track date";
                                        SalRetLine."Track Date RTV" := SLine."Track Date RTV";
                                        SalRetLine."Invoice Number" := SLine."Invoice Number";
                                        SalRetLine."Invoice Number RTV" := SLine."Invoice Number RTV";
                                        SalRetLine."Dispatch Date " := SLine."Dispatch Date ";
                                        SalRetLine."In Warehouse" := SLine."In Warehouse";
                                        SalRetLine."Shipment Date" := SLine."Shipment Date";
                                        SalRetLine."Ship Date RTV" := SLine."Ship Date RTV";
                                        SalRetLine."Net Weight" := SLine."Net Weight";
                                        SalRetLine."Ship Mode" := SLine."Ship Mode";
                                        SalRetLine."Loyalty Points" := SLine."Loyalty Points";
                                        SalRetLine."Loyalty Flag" := SLine."Loyalty Flag";
                                        SalRetLine."Estm Delivery Date" := SLine."Estm Delivery Date";
                                        SalRetLine."Is Customization Received" := SLine."Is Customization Received";
                                        SalRetLine."Is Blouse Customization Received" := SLine."Is Blouse Customization Received";
                                        SalRetLine."Alteration Charges" := SLine."Alteration Charges";
                                        SalRetLine."Line Amount" := SLine."Unit Price" - SLine."Line Discount Amount";
                                        SalRetLine.Insert();
                                        //<<returnorder
                                        // RefInvNumber.Reset();
                                        // RefInvNumber.SetRange("Document No.", SalRetHdr."No.");
                                        // RefInvNumber.SetRange("Document Type", RefInvNumber."Document Type"::"Return Order");
                                        // RefInvNumber.SetRange("Source No.", SalRetHdr."Sell-to Customer No.");
                                        // if RefInvNumber.FindFirst() then begin
                                        //     RefInvNumber."Reference Invoice Nos." := SHeader."No.";
                                        //     RefInvNumber.Verified := true;
                                        //     RefInvNumber.Modify();
                                        // end;
                                        SIH.Reset();
                                        SIH.SetRange("Order No.", SHeader."No.");
                                        if SIH.FindSet() then
                                            repeat
                                                SIL.Reset();
                                                SIL.SetRange("Document No.", SIH."No.");
                                                SIL.SetRange(Type, SIL.Type::Item);
                                                SIL.SetRange("No.", SalRetLine."No.");
                                                //SIL.SetRange(Quantity, 1);
                                                if SIL.FindFirst() then begin
                                                    RefInvNumber.Init();
                                                    RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                    RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                    RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                    RefInvNumber."Reference Invoice Nos." := SIL."Document No.";
                                                    RefInvNumber.Verified := true;
                                                    RefInvNumber.Insert();

                                                    SIL."Shipping Status" := 'COD RTO';
                                                    SIL.Modify();
                                                end;
                                            until SIH.Next() = 0;
                                        SSH.Reset();
                                        SSH.SetRange("Order No.", SHeader."No.");
                                        if SSH.FindSet() then
                                            repeat
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", SalRetLine."No.");
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'COD RTO';
                                                    SSL.Modify();
                                                end;
                                            until SSH.Next() = 0;


                                        //Posting>>
                                        SalRetHdr.Receive := true;
                                        SalRetHdr.Invoice := true;
                                        SalRetHdr.Modify();
                                        Clear(Salespost);
                                        Salespost.Run(SalRetHdr);
                                        Message('Return Order Posted');
                                        if SLine.Modify() then begin
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                        //end;
                                    end;
                                end;
                            9:                    //Prepaid RTO
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("No.", DetailSalesStaging.invoice_item_number);
                                    //SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    //SLine.SetRange("Shipping Status", 'SHIP');
                                    SLine.SetFilter("Shipping Status", '%1|%2', 'SHIP', 'DELIVERED');
                                    if SLine.FindFirst() then begin
                                        SLine."Shipping Status" := 'PREPAID RTO';
                                        //>>
                                        SalesReceiveblesetup.Get();
                                        SalRetHdr.Init();
                                        SalRetHdr.Validate("Document Type", SalRetHdr."Document Type"::"Return Order");
                                        SalRetHdr."No." := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Return Order Nos.", Today, true);
                                        SalRetHdr.Validate("Sell-to Customer No.", SHeader."Sell-to Customer No.");
                                        SalRetHdr.Validate(State, SHeader.State);
                                        SalRetHdr."Sell-to E-Mail" := SHeader."Sell-to E-Mail";
                                        SalRetHdr."Bill-to Name" := SHeader."Bill-to Name";
                                        SalRetHdr."Bill-to Address" := SHeader."Bill-to Address";
                                        SalRetHdr."Bill-to City" := SHeader."Bill-to City";
                                        SalRetHdr."Bill-to Post Code" := SHeader."Bill-to Post Code";
                                        SalRetHdr."Bill-to Country/Region Code" := SHeader."Bill-to Country/Region Code";
                                        SalRetHdr."Ship-to Name" := SHeader."Ship-to Name";
                                        SalRetHdr."Ship-to Address" := SHeader."Ship-to Address";
                                        SalRetHdr."Ship-to City" := SHeader."Ship-to City";
                                        SalRetHdr."Ship-to Code" := SHeader."Ship-to Code";
                                        SalRetHdr."Ship-to Country/Region Code" := SHeader."Ship-to Country/Region Code";
                                        SalRetHdr.Validate("Location Code", SHeader."Location Code");
                                        //SalRetHdr."Location Code" := SHeader."Location Code";//location
                                        SalRetHdr.Validate("Billing Locality", SHeader."Billing Locality");
                                        SalRetHdr.Validate("Billing State", SHeader."Billing State");
                                        SalRetHdr.Validate("Billing Email", SHeader."Billing Email");
                                        SalRetHdr.Validate("Billing Landmark", SHeader."Billing Landmark");
                                        SalRetHdr.Validate("Shipping Locality", SHeader."Shipping Locality");
                                        SalRetHdr.Validate("Shipping State", SHeader."Shipping State");
                                        SalRetHdr.Validate("Shipping Landmark", SHeader."Shipping Landmark");
                                        SalRetHdr."Bill-to Contact No." := SHeader."Bill-to Contact No.";
                                        SalRetHdr."Sell-to Contact No." := SHeader."Sell-to Contact No.";
                                        SalRetHdr."Salesperson Code" := SHeader."Salesperson Code";
                                        //>>
                                        SalRetHdr.Validate("Promo Code", SHeader."Promo Code");
                                        SalRetHdr.Validate("Invoice Discount Value", SHeader."Invoice Discount Value");
                                        SalRetHdr.Validate("Redeem Points", SHeader."Redeem Points");
                                        SalRetHdr.Validate("Redeem Points Credit", SHeader."Redeem Points Credit");
                                        SalRetHdr.Validate("Shipping Amount", SHeader."Shipping Amount");
                                        SalRetHdr.Validate("Duties & Taxes", SHeader."Duties & Taxes");
                                        SalRetHdr.Validate("Total Price", SHeader."Total Price");
                                        SalRetHdr.Validate("Date Added", SHeader."Date Added");
                                        SalRetHdr.Validate("Date Modified", SHeader."Date Modified");
                                        SalRetHdr.Validate("Order Status", SHeader."Order Status");
                                        SalRetHdr.Validate(Currency, SHeader.currency);
                                        SalRetHdr.Validate("Currency Rate", SHeader."Currency Rate");
                                        SalRetHdr.Validate("State Tax Type", SHeader."State Tax Type");
                                        SalRetHdr.Validate("Pan Number", SHeader."Pan Number");
                                        // SalRetHdr.Validate("Gift Message", SHeader."Gift Message");
                                        // SalRetHdr.Validate("Is Special Order", SHeader."Is Special Order");
                                        // SalRetHdr.Validate("Special Message", SHeader."Special Message");
                                        // SalRetHdr.Validate("COD Confirm", SHeader."COD Confirm");
                                        SalRetHdr.Validate("Charge Back Remark", SHeader."Charge Back Remark");
                                        SalRetHdr.Validate("Charge Back Date", SHeader."Charge Back Date");
                                        SalRetHdr.Validate("Loyalty Point", SHeader."Loyalty Point");
                                        SalRetHdr.Validate("Loyalty Percent", SHeader."Loyalty Percent");
                                        SalRetHdr.Validate("Loyalty Unit", SHeader."Loyalty Unit");
                                        SalRetHdr.Validate("Redeem Loyalty points", SHeader."Redeem Loyalty points");
                                        SalRetHdr.Validate("New Shipping Address", SHeader."New Shipping Address");
                                        SalRetHdr.Validate("Is Loyalty Free Ship", SHeader."Is Loyalty Free Ship");
                                        SalRetHdr.Validate("Current loyalty Tier", SHeader."Current loyalty Tier");
                                        SalRetHdr.Insert();
                                        //>>LINE
                                        SalRetLine.Init();
                                        SalRetLine.Validate("Document Type", SalRetHdr."Document Type");
                                        SalRetLine.Validate("Document No.", SalRetHdr."No.");
                                        SalRetLine."Line No." := 10000;
                                        SalRetLine.Validate(Type, SLine.Type);
                                        SalRetLine.Validate("No.", SLine."No.");
                                        SalRetLine."Product Id" := SLine."Product Id";
                                        SalRetLine."Aza Online Code" := SLine."Aza Online Code";
                                        SalRetLine."Location Code" := SLine."Location Code";
                                        SalRetLine.Validate(Quantity, SLine.Quantity);
                                        SalRetLine."Amount Including VAT" := SLine."Amount Including VAT";
                                        SalRetLine."Discount Percent By Aza" := SLine."Discount Percent By Aza";
                                        SalRetLine."Discount Percent By Desg" := SLine."Discount Percent By Desg";
                                        SalRetLine."Promo Discount" := SLine."Promo Discount";
                                        SalRetLine."Credit By Product" := SLine."Credit By Product";
                                        SalRetLine."Loyalty By Product" := SLine."Loyalty By Product";
                                        SalRetLine."Unit Price" := SLine."Unit Price";
                                        SalRetLine.Amount := SLine.Amount;
                                        SalRetLine."Unit Cost" := SLine."Unit Cost";
                                        SalRetLine."SubTotal 1" := SLine."SubTotal 1";
                                        SalRetLine."SubTotal 2" := SLine."SubTotal 2";
                                        SalRetLine.Validate("Line Discount Amount", SLine."Line Discount Amount");
                                        SalRetLine."Shipping Status" := SLine."Shipping Status";
                                        SalRetLine."Is Return And Exchange" := SLine."Is Return And Exchange";
                                        SalRetLine."Shipping Company Name" := SLine."Shipping Company Name";
                                        SalRetLine."Shipping Company Name RTV" := SLine."Shipping Company Name RTV";
                                        SalRetLine."Tracking Id" := SLine."Tracking Id";
                                        SalRetLine."Tracking Id RTV" := SLine."Tracking Id RTV";
                                        SalRetLine."Requested Delivery Date" := SLine."Requested Delivery Date";
                                        SalRetLine."Delivery Date RTV" := SLine."Delivery Date RTV";
                                        SalRetLine."Track date" := SLine."Track date";
                                        SalRetLine."Track Date RTV" := SLine."Track Date RTV";
                                        SalRetLine."Invoice Number" := SLine."Invoice Number";
                                        SalRetLine."Invoice Number RTV" := SLine."Invoice Number RTV";
                                        SalRetLine."Dispatch Date " := SLine."Dispatch Date ";
                                        SalRetLine."In Warehouse" := SLine."In Warehouse";
                                        SalRetLine."Shipment Date" := SLine."Shipment Date";
                                        SalRetLine."Ship Date RTV" := SLine."Ship Date RTV";
                                        SalRetLine."Net Weight" := SLine."Net Weight";
                                        SalRetLine."Ship Mode" := SLine."Ship Mode";
                                        SalRetLine."Loyalty Points" := SLine."Loyalty Points";
                                        SalRetLine."Loyalty Flag" := SLine."Loyalty Flag";
                                        SalRetLine."Estm Delivery Date" := SLine."Estm Delivery Date";
                                        SalRetLine."Is Customization Received" := SLine."Is Customization Received";
                                        SalRetLine."Is Blouse Customization Received" := SLine."Is Blouse Customization Received";
                                        SalRetLine."Alteration Charges" := SLine."Alteration Charges";
                                        SalRetLine."Line Amount" := SLine."Unit Price" - SLine."Line Discount Amount";
                                        SalRetLine.Insert();
                                        //<<returnorder
                                        SIH.Reset();
                                        SIH.SetRange("Order No.", SHeader."No.");
                                        if SIH.FindSet() then
                                            repeat
                                                SIL.Reset();
                                                SIL.SetRange("Document No.", SIH."No.");
                                                SIL.SetRange(Type, SIL.Type::Item);
                                                SIL.SetRange("No.", SalRetLine."No.");
                                                //SIL.SetRange(Quantity, 1);
                                                if SIL.FindFirst() then begin
                                                    RefInvNumber.Init();
                                                    RefInvNumber.validate("Document Type", RefInvNumber."Document Type"::"Return Order");
                                                    RefInvNumber.Validate("Document No.", SalRetHdr."No.");
                                                    RefInvNumber.Validate("Source No.", SalRetHdr."Bill-to Customer No.");
                                                    RefInvNumber."Reference Invoice Nos." := SIL."Document No.";
                                                    RefInvNumber.Verified := true;
                                                    RefInvNumber.Insert();

                                                    SIL."Shipping Status" := 'PREPAID RTO';
                                                    SIL.Modify();
                                                end;
                                            until SIH.Next() = 0;
                                        SSH.Reset();
                                        SSH.SetRange("Order No.", SHeader."No.");
                                        if SSH.FindSet() then
                                            repeat
                                                SSL.Reset();
                                                SSL.SetRange("Document No.", SSH."No.");
                                                SSL.SetRange(Type, SIL.Type::Item);
                                                SSL.SetRange("No.", SalRetLine."No.");
                                                //SSL.SetRange(Quantity, 1);
                                                if SSL.FindFirst() then begin
                                                    SSL."Shipping Status" := 'PREPAID RTO';
                                                    SSL.Modify();
                                                end;
                                            until SSH.Next() = 0;

                                        //Posting>>
                                        SalRetHdr.Receive := true;
                                        SalRetHdr.Invoice := true;
                                        SalRetHdr.Modify();
                                        Clear(Salespost);
                                        Salespost.Run(SalRetHdr);
                                        Message('Return Order Posted');
                                        if SLine.Modify() then begin
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                        //end;
                                    end;
                                end;
                            10:                    //DELIVERED
                                begin

                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        sline."Shipping Status" := 'DELIVERED';
                                        if SLine.Modify() then begin///>
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                    end;
                                    SalInvhdr.Reset();
                                    SalInvhdr.SetRange("Order No.", SHeader."No.");
                                    if SalInvhdr.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SalInvline.Reset();
                                                SalInvline.SetRange("Document No.", SalInvhdr."No.");
                                                SalInvline.SetRange(Type, SIL.Type::Item);
                                                SalInvline.SetRange("No.", Detailstage.barcode);
                                                if SalInvline.FindFirst() then begin
                                                    // if SalInvline.Quantity <> 0 then begin
                                                    SalInvline."Shipping Status" := 'DELIVERED';
                                                    SalInvline.Modify();
                                                    // end;
                                                end;
                                            end;
                                        until SalInvhdr.Next() = 0;
                                    SalesShpHdr.Reset();
                                    SalesShpHdr.SetRange("Order No.", SHeader."No.");
                                    if SalesShpHdr.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                salesshpLine.Reset();
                                                salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
                                                salesshpLine.SetRange(Type, SIL.Type::Item);
                                                salesshpLine.SetRange("No.", Detailstage.barcode);
                                                if salesshpLine.FindFirst() then begin
                                                    //if salesshpLine.Quantity <> 0 then begin
                                                    salesshpLine."Shipping Status" := 'DELIVERED';
                                                    salesshpLine.Modify();
                                                    //end;
                                                end;
                                            end;
                                        until SalesShpHdr.Next() = 0;
                                end;
                            11:                    //QC PASS
                                begin

                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        sline."Shipping Status" := 'QC PASS';
                                        if SLine.Modify() then begin///>
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                    end;
                                    SalInvhdr.Reset();
                                    SalInvhdr.SetRange("Order No.", SHeader."No.");
                                    if SalInvhdr.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SalInvline.Reset();
                                                SalInvline.SetRange("Document No.", SalInvhdr."No.");
                                                SalInvline.SetRange(Type, SIL.Type::Item);
                                                SalInvline.SetRange("No.", Detailstage.barcode);
                                                if SalInvline.FindFirst() then begin
                                                    // if SalInvline.Quantity <> 0 then begin
                                                    SalInvline."Shipping Status" := 'QC PASS';
                                                    SalInvline.Modify();
                                                    // end;
                                                end;
                                            end;
                                        until SalInvhdr.Next() = 0;
                                    SalesShpHdr.Reset();
                                    SalesShpHdr.SetRange("Order No.", SHeader."No.");
                                    if SalesShpHdr.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                salesshpLine.Reset();
                                                salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
                                                salesshpLine.SetRange(Type, SIL.Type::Item);
                                                salesshpLine.SetRange("No.", Detailstage.barcode);
                                                if salesshpLine.FindFirst() then begin
                                                    //if salesshpLine.Quantity <> 0 then begin
                                                    salesshpLine."Shipping Status" := 'QC PASS';
                                                    salesshpLine.Modify();
                                                    //end;
                                                end;
                                            end;
                                        until SalesShpHdr.Next() = 0;
                                end;
                            12:                    //PICKED
                                begin
                                    SLine.Reset();
                                    SLine.SetRange("Document Type", SLine."Document Type"::Order);
                                    SLine.SetRange("Document No.", SHeader."No.");
                                    // SLine.SetRange("No.", txtBarcode);
                                    SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                                    if SLine.FindFirst() then begin
                                        sline."Shipping Status" := 'PICKED';
                                        if SLine.Modify() then begin///>
                                            ActionStatus.Processed := true;
                                            ActionStatus.Modify();
                                            boolupdated := true;
                                            SalesHash.Init();
                                            SalesHash.Validate(hash, ActionStatus.hash);
                                            SalesHash.Validate("So No.", Format(ActionStatus.SO_ID));
                                            SalesHash.Validate("Action ID", ActionStatus."Action ID");
                                            SalesHash.Validate("SO Detail ID", ActionStatus.SO_Detail_ID);
                                            SalesHash.Insert();
                                        end;
                                    end;
                                    SalInvhdr.Reset();
                                    SalInvhdr.SetRange("Order No.", SHeader."No.");
                                    if SalInvhdr.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                SalInvline.Reset();
                                                SalInvline.SetRange("Document No.", SalInvhdr."No.");
                                                SalInvline.SetRange(Type, SIL.Type::Item);
                                                SalInvline.SetRange("No.", Detailstage.barcode);
                                                if SalInvline.FindFirst() then begin
                                                    // if SalInvline.Quantity <> 0 then begin
                                                    SalInvline."Shipping Status" := 'PICKED';
                                                    SalInvline.Modify();
                                                    // end;
                                                end;
                                            end;
                                        until SalInvhdr.Next() = 0;
                                    SalesShpHdr.Reset();
                                    SalesShpHdr.SetRange("Order No.", SHeader."No.");
                                    if SalesShpHdr.FindSet() then
                                        repeat
                                            Detailstage.Reset();
                                            Detailstage.SetRange(order_id, ActionStatus.SO_ID);
                                            Detailstage.SetRange(order_detail_id, ActionStatus.SO_Detail_ID);
                                            if Detailstage.FindFirst() then begin
                                                salesshpLine.Reset();
                                                salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
                                                salesshpLine.SetRange(Type, SIL.Type::Item);
                                                salesshpLine.SetRange("No.", Detailstage.barcode);
                                                if salesshpLine.FindFirst() then begin
                                                    //if salesshpLine.Quantity <> 0 then begin
                                                    salesshpLine."Shipping Status" := 'PICKED';
                                                    salesshpLine.Modify();
                                                    //end;
                                                end;
                                            end;
                                        until SalesShpHdr.Next() = 0;
                                end;
                        end;
                        Message('After second action status %1', GetLastErrorText());
                    end;
                until ActionStatus.Next() = 0;
        end;
        //<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>commented100323

        // //>>For Return order>>>>>>>>>>>>>>
        // Evaluate(myInt, SHeader."No.");
        // DetailSalesStaging.Reset();
        // DetailSalesStaging.SetRange(order_id, myInt);
        // DetailSalesStaging.SetRange("Line Created", false);
        // if DetailSalesStaging.FindSet() then
        //     repeat
        //         if DetailSalesStaging.shipping_status = 'RETURNED' then begin
        //         end;
        //     //end;
        //     until DetailSalesStaging.Next() = 0;

        // //160223 CITS_RS QC PASS Added
        // DetailSalesStaging.Reset();
        // DetailSalesStaging.SetRange(order_id, myInt);
        // DetailSalesStaging.SetRange("Line Created", false);
        // if DetailSalesStaging.FindSet() then
        //     repeat
        //         if DetailSalesStaging.shipping_status = 'QCPASS' then begin
        //         end;
        //     // end;
        //     until DetailSalesStaging.Next() = 0;
        //commented shipped>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        // 4:                   //SHIPPED
        //                             begin
        //                                 ClearLastError();
        //                                 salesheader1.Reset();
        //                                 salesheader1.SetRange("Document Type", salesheader1."Document Type"::Order);
        //                                 salesheader1.SetRange("No.", SalHeader."No.");
        //                                 salesheader1.SetRange(Status, salesheader1.Status::Released);
        //                                 if salesheader1.FindFirst() then begin
        //                                     salesheader1.Validate(Status, salesheader1.Status::Open);
        //                                     salesheader1.Modify(true);
        //                                 end;

        //                                 //for clear//>>>>>>>>
        //                                 SLine.Reset();
        //                                 SLine.SetRange("Document Type", SLine."Document Type"::Order);
        //                                 SLine.SetRange("Document No.", SalHeader."No.");
        //                                 SLine.SetFilter("Qty. to Ship", '<>%1', 0);
        //                                 if SLine.FindSet(true) then
        //                                     repeat
        //                                         SLine.Validate("Qty. to Ship", 0);
        //                                         SLine.Modify(true);
        //                                     until SLine.Next() = 0;
        //                                 //if DetailSalesStaging.shipping_status = 'SHIPPED' then begin //nwadded
        //                                 // Clear(txtBarcode);
        //                                 // if StrLen(DetailSalesStaging.barcode) > 20 then
        //                                 //     txtBarcode := CopyStr(DetailSalesStaging.barcode, StrLen(DetailSalesStaging.barcode) - 20 + 1)
        //                                 // else
        //                                 //     txtBarcode := DetailSalesStaging.barcode;

        //                                 SLine.Reset();
        //                                 SLine.SetRange("Document Type", SLine."Document Type"::Order);
        //                                 SLine.SetRange("Document No.", SalHeader."No.");
        //                                 SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
        //                                 if SLine.FindFirst() then begin
        //                                     SLine.Validate("Qty. to Ship", 1);
        //                                     //SLine.Validate("Qty. to Invoice", 1);
        //                                     sline."Shipping Status" := 'SHIP';
        //                                     SLine.Modify(true);
        //                                 end;
        //                                 //<<<<Posting>>>>>>>>>>>>>>>
        //                                 SLine.Reset();
        //                                 SLine.SetRange("Document Type", SLine."Document Type"::Order);
        //                                 SLine.SetRange("Document No.", SalHeader."No.");
        //                                 SLine.SetFilter("Qty. to Ship", '<>%1', 0);
        //                                 //SLine.SetFilter("Qty. to Invoice", '<>%1', 0);
        //                                 if SLine.FindFirst() then begin
        //                                     Clear(salesheader3);
        //                                     if salesheader3.Get(1, SalHeader."No.") then begin
        //                                         salesheader3.Validate(Status, salesheader3.Status::Released);
        //                                         salesheader3.Modify();
        //                                         salesheader3.Ship := true;
        //                                         salesheader3.Invoice := true;
        //                                         //SHeader.Modify();
        //                                         //Commit();
        //                                         if Not postSalesOrderShipment(salesheader3) then begin
        //                                             if GetLastErrorText() <> '' then begin
        //                                                 SalesShpHdr.Reset();
        //                                                 SalesShpHdr.SetRange("Order No.", SalHeader."No.");
        //                                                 if SalesShpHdr.FindLast() then begin
        //                                                     // salesshpLine.Reset();
        //                                                     // salesshpLine.SetRange("Document No.", SalesShpHdr."No.");
        //                                                     // if not salesshpLine.FindFirst() then begin
        //                                                     SalesShpHdr."No. Printed" := 1;
        //                                                     SalesShpHdr.Modify();
        //                                                     SalesShpHdr.Delete(true);
        //                                                     //Message('ship hdr delete due to error');
        //                                                     //exit(false);
        //                                                     // end;

        //                                                 end;
        //                                                 if salesheader4.Get(1, SalHeader."No.") then begin
        //                                                     salesheader4.Validate(Status, salesheader4.Status::Open);
        //                                                     salesheader4.Modify();
        //                                                 end;
        //                                                 SLine.Reset();
        //                                                 SLine.SetRange("Document Type", SLine."Document Type"::Order);
        //                                                 SLine.SetRange("Document No.", SalHeader."No.");
        //                                                 //SLine.SetRange("No.", txtBarcode);
        //                                                 SLine.SetRange("Line No.", ActionStatus.SO_Detail_ID);
        //                                                 if SLine.FindFirst() then begin
        //                                                     SLine.Validate("Qty. to Ship", 0);
        //                                                     sline."Shipping Status" := 'OPEN';
        //                                                     SLine.Modify(true);
        //                                                 end;
        //                                             end;
        //                                         end else begin
        //                                             ActionStatus.Processed := true;
        //                                             ActionStatus.Modify();
        //                                             Message('Sales order %1 posted', SHeader."No.");
        //                                         end;
        //                                     end;
        //                                 end;
        //                             end;

        // //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<commented170623AS
        // SalLine.Reset();
        // SalLine.SetRange("Document Type", SalLine."Document Type"::Order);
        // SalLine.SetRange("Document No.", DocNoVar);
        // if SalLine.FindFirst() then begin
        //     SalesHeader.Reset();
        //     SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        //     SalesHeader.SetRange("No.", DocNoVar);
        //     if SalesHeader.FindFirst() then begin
        //         SalesHeader."Location Code" := SalLine."Location Code";
        //         SalesHeader.Modify();
        //         // Message('%1', SalLine."GST Jurisdiction Type");
        //     end;
        // end;
        // //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    end;

    [TryFunction]
    procedure postSalesOrderShipment(Sh: Record "Sales Header")
    var
        myInt: Integer;
        SalesPost: Codeunit "Sales-Post";

    begin
        Salespost.Run(Sh);
        Message('Afterposting %1', GetLastErrorText());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdateLocationCode', '', false, false)]
    local procedure OnBeforeUpdateLocationCode(var SalesLine: Record "Sales Line"; var IsHandled: Boolean);
    begin
        IsHandled := false;
    end;

    var
        myInt: Integer;
        StatusVar: Code[20];
        Truee: Boolean;
        Ship: code[10];
        Return: code[10];
        ItemCost: Decimal;
        VendNo: Code[20];
        Item: Record Item;
        SHVar: Code[20];
        SaleslineExt: Record 37;
        RefInvNumber: Record 18011;
        SalesShpHdr: Record "Sales Shipment Header";
        salesshpLine: Record "Sales Shipment Line";
        SalesInvoiceHdr: Record "Sales Invoice Header";
        ActionStatus: Record Action_Status_Sales;
        SOIDint: Integer;
        boolupdated: Boolean;
        int: Integer;
        ReturnOrdNo: code[10];
        LastCustomer: Code[20];
        LastVendor: Code[20];
        POOrderNo: code[20];
        LineNo: code[10];
        salesLine1: Record 37;
        SalRetHdr: Record "Sales Header";
        SalRetLine: Record "Sales Line";
        SIH: Record "Sales Invoice Header";
        SIL: Record "Sales Invoice Line";
        SSH: Record "Sales Shipment Header";
        SSL: Record "Sales Shipment Line";
}