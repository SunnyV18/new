codeunit 50124 CreatePO2
{
    TableNo = Aza_Item;
    trigger OnRun()
    begin
        CreatePO2(Rec)
    end;

    var
        glPurchDocNum: Code[50];
        glLastLOcation: Code[30];
        glPOType: code[30];
        glinwardDone: Boolean;
        POReopenboo: Boolean;
        glDocType: Text[10];
        cuPurchPost: Codeunit "Purch.-Post";
        item1: Record Item;
        glLastVend: code[30];

    procedure CreatePO2(Var recItemStageVendor: Record Aza_Item)
    var
        CU_NOSeriesMgmt: Codeunit NoSeriesManagement;
        recPurPayableSet: Record "Purchases & Payables Setup";
        recItemStaging: Record Aza_Item;
        recPurHeader: Record "Purchase Header";
        recPurLine: Record "Purchase Line";
        PurChaseLine: Record "Purchase Line";
        currVendor: Code[30];
        prevVendor: Code[10];
        intLineNo: Integer;
        // recItemStageVendor: Record Aza_Item;
        recItem: Record Item;
        recVendor: Record Vendor;
        intVendID: Integer;
        recRetailUser: Record "LSC Retail User";
        recUserSetup: Record "User Setup";
        LastVenderNo: Text;
        LastPOtype: Text;

        CurrPotype: Code[30];
        CurrLocation: Code[30];
        recItem1: Record 27;
        LastLocation: Text;
        FCLocation: Integer;
        TabLocation: Record Location;
        Store: Record "LSC Store";
        recPurHeader1: Record "Purchase Header";
        FCLocation2: Integer;
        enumDocType: Enum "Document Type Enum";
        recCustOrderHeader: Record "LSC Customer Order Header";
        FCcode: Code[10];
        txtBarcode: text;
        // recItem:Record 27;
        HeaderNo: Code[20];
        recErrorLog: Record ErrorLogPO;
        // recErrorLog: Record ErrorCapture;
        GSTMaster: Record "GST Master";
    begin
        if not PoExistOrNotOnItem(recItemStageVendor) then//070823
            Error('Purchase Order already exist');
        Clear(txtBarcode);
        if StrLen(recItemStageVendor.bar_code) > 20 then
            txtBarcode := CopyStr(recItemStageVendor.bar_code, StrLen(recItemStageVendor.bar_code) - 20 + 1)
        else
            txtBarcode := recItemStageVendor.bar_code;
        recRetailUser.Reset();
        recRetailUser.SetRange(ID, UserId);
        if recRetailUser.FindFirst() then;
        if not recItem.Get(recItemStageVendor.bar_code) then Error('Item %1 not found in the master', recItemStageVendor.bar_code);
        if not recItem."Is Approved for Sale" then begin//Only creating error log,not resulting into error for unapproved items CITS_RS 030323
            recErrorLog.Init();
            if recErrorLog.FindLast() then
                recErrorLog."Sr. No" += 1
            else
                recErrorLog."Sr. No" := 1;
            recErrorLog.Item_code := recItemStageVendor.bar_code;
            recErrorLog."Source Entry No." := recItemStageVendor."Entry No.";
            recErrorLog."Error DateTime" := CurrentDateTime;
            recErrorLog."Error Remarks" := StrSubstNo('Item %1 is not approved for sale', recItemStageVendor.bar_code);
            //recErrorLog."Process Type" := recErrorLog."Process Type"::"PO Creation";
            recErrorLog."Vendor Code" := recItemStageVendor.designer_id;
            recErrorLog.Insert();
            exit;
        end;
        // recItemStageVendor.Reset();
        // recItemStageVendor.SetCurrentKey(designer_id, "po_type");
        // recItemStageVendor.SetRange("Record Status", recItemStageVendor."Record Status"::Created);
        // recItemStageVendor.SetRange("PO Created", false);
        // if recItemStageVendor.FindSet() then begin
        //     repeat
        /* currVendor := format(recItemStageVendor.designer_id);
         CurrPotype := Format(recItemStageVendor."po_type");
         CurrLocation := recItemStageVendor.fc_location;
         // if (LastVenderNo <> currVendor) or (CurrPotype <> LastPOtype) Or (CurrLocation <> LastLocation) then begin
         if (glLastVend <> currVendor) or (glPOType <> CurrPotype) Or (glLastLOcation <> CurrLocation) then begin
             if not recVendor.get(currVendor) then
                 Error('Vendor not created');

             //CaptureError_POCreation(recItemStageVendor);
             Evaluate(FCLocation2, recItemStageVendor.fc_location);
             if recItemStageVendor.fc_location = '' then Error('FC Location is empty');
             TabLocation.Reset();
             TabLocation.SetRange("fc_location ID", FCLocation2);
             if TabLocation.FindFirst() then
                 FCcode := TabLocation.Code
             else
                 Error('FC location %1 doesn''t exist !', FCLocation);

             if Store.Get(FCcode) then
                 HeaderNo := CU_NOSeriesMgmt.GetNextNo(Store."Purchase Order No. Series", Today, true);
             recPurPayableSet.Get();
             recPurHeader.Init();
             recPurHeader.validate("Document Type", recPurHeader."Document Type"::Order);
             recPurHeader."No." := HeaderNo; //CU_NOSeriesMgmt.GetNextNo(recPurPayableSet."Order Nos.", Today, true);
             recPurHeader."Gen. Bus. Posting Group" := 'DOMESTIC';
             recPurHeader.validate("Buy-from Vendor No.", currVendor);
             recPurHeader.Validate("Buy-from Address", recVendor.Address);
             recPurHeader.Validate("Buy-from Address 2", recVendor."Address 2");
             recPurHeader.Validate("Buy-from City", recVendor.City);
             recPurHeader.Validate("Buy-from Post Code", recVendor."Post Code");
             recPurHeader.Validate("Buy-from Country/Region Code", recVendor."Country/Region Code");
             recPurHeader.Validate("Posting Date", Today);
             recPurHeader.validate("Document Date", Today);
             recPurHeader.validate("Order Date", Today);
             recPurHeader.Validate("PO type", recItemStageVendor."po_type");
             if not recItem1.Get(recItemStageVendor.bar_code) then Error('Item %1 doesn''t exist in the master', recItemStageVendor.bar_code);
             if recItem1."Customer Order ID" <> '' then begin
                 recCustOrderHeader.Get(recItem1."Customer Order ID");
                 recPurHeader.Validate("Customer Order ID", recItem1."Customer Order ID");//CITS_RS 170322
                 recPurHeader.validate("Partial Payment", recCustOrderHeader."Partial Payment");//CITS_RS 170322
             end;
             //recPurHeader.Validate("fc location", recItemStageVendor.fc_location);
             //recPurHeader.Validate("Location Code", recItemStageVendor.fc_location);
             if recItemStageVendor.fc_location = '' then Error('FC Location is empty');
             Evaluate(FCLocation, recItemStageVendor.fc_location);
             TabLocation.Reset();
             TabLocation.SetRange("fc_location ID", FCLocation);
             if TabLocation.FindFirst() then begin

                 recPurHeader."fc location" := TabLocation.Code;
                 recPurHeader."Location Code" := TabLocation.code;
             end else
                 Error('FC location %1 doesn''t exist !', FCLocation);


             recPurHeader.Status := recPurHeader.Status::Open;
             recPurHeader."Vendor Invoice No." := 'Aza' + recItemStageVendor.aza_code;
             recPurHeader.Insert(true);

             recPurHeader1.get(1, recPurHeader."No.");//assuming type as Order for all transactions
             recPurHeader1."Location Code" := FCcode;
             recPurHeader1.Modify(true);

             intLineNo := 10000;

             recItem.Get(txtBarcode);
             recPurLine.init();
             recPurLine.Type := recPurLine.Type::Item;
             glPurchDocNum := recPurHeader."No.";
             glDocType := format(recPurHeader."Document Type");
             recPurLine."Document No." := recPurHeader."No.";
             recPurLine."Document Type" := recPurLine."Document Type"::Order;
             recPurLine."Line No." := intLineNo;
             recPurLine.Validate("No.", txtBarcode);
             //recPurLine.Validate("Location Code", recRetailUser."Location Code");
             //recPurLine.Validate("Location Code", recItemStageVendor.fc_location);
             if recItemStageVendor.fc_location = '' then Error('FC Location is empty');
             Evaluate(FCLocation, recItemStageVendor.fc_location);
             TabLocation.Reset();
             TabLocation.SetRange("fc_location ID", FCLocation);
             if TabLocation.FindFirst() then
                 recPurLine."Location Code" := TabLocation.code
             else
                 Error('FC location %1 doesn''t exist !', FCLocation);
             recPurLine.Validate(MRP, recItemStageVendor.product_price);
             recPurLine.Validate(Quantity, 1);
             recPurLine.Validate("Unit of Measure", 'PCS');
             // recPurLine.Validate("Direct Unit Cost", recItemStageVendor.product_cost);//as per02-03-23 
             if item1.Get(txtBarcode) then begin
                 recPurLine.Validate("Direct Unit Cost", item1."Unit Cost");
                 GSTMaster.Reset();
                 GSTMaster.SetRange(GSTMaster.Category, item1."LSC Division Code");
                 GSTMaster.SetRange(GSTMaster."Subcategory 1", item1."Item Category Code");
                 GSTMaster.SetRange(GSTMaster."Subcategory 2", item1."LSC Retail Product Code");
                 GSTMaster.SetRange(Fabric_Type, item1."Fabric Type");
                 GSTMaster.SetFilter("From Amount", '<=%1', item1."Unit Cost");
                 GSTMaster.SetFilter("To Amount", '>=%1', item1."Unit Cost");
                 if GSTMaster.FindFirst() then begin
                     recPurLine.Validate("GST Group Code", GSTMaster."GST Group");
                     recPurLine.Validate("HSN/SAC Code", GSTMaster."HSN Code");
                 end;
             end;
         end
         else begin
             evaluate(enumDocType, glDocType);
             PurChaseLine.Reset();
             // PurchLine.SetRange("Document Type", PurchHeader."Document Type");
             // PurchLine.SetRange("Document No.", PurchHeader."No.");
             PurChaseLine.SetRange("Document Type", enumDocType);
             PurChaseLine.SetRange("Document No.", glPurchDocNum);
             if PurChaseLine.FindLast() then begin
                 intLineNo := PurChaseLine."Line No." + 10000;
                 recPurLine.init();
                 recPurLine.Type := recPurLine.Type::Item;
                 if recPurHeader."No." = '' then
                     recPurLine."Document No." := glPurchDocNum
                 else
                     recPurLine."Document No." := recPurHeader."No.";

                 recPurLine."Document Type" := recPurLine."Document Type"::Order;
                 recPurLine."Line No." := intLineNo;
                 recPurLine.Validate("No.", txtBarcode);
                 //recPurLine.Validate("Location Code", recRetailUser."Location Code");
                 //recPurLine.Validate("Location Code", recItemStageVendor.fc_location);
                 if recItemStageVendor.fc_location = '' then Error('FC Location is empty');
                 Evaluate(FCLocation, recItemStageVendor.fc_location);
                 TabLocation.Reset();
                 TabLocation.SetRange("fc_location ID", FCLocation);
                 if TabLocation.FindFirst() then
                     recPurLine."Location Code" := TabLocation.code
                 else
                     Error('FC location %1 doesn''t exist !', FCLocation);
                 recPurLine.Validate(MRP, recItemStageVendor.product_price);
                 recPurLine.Validate(Quantity, 1);
                 recPurLine.Validate("Unit of Measure", 'PCS');
                 // recPurLine.Validate("Direct Unit Cost", recItemStageVendor.product_cost);//as per 02-03-23
                 if item1.Get(txtBarcode) then begin
                     recPurLine.Validate("Direct Unit Cost", item1."Unit Cost");
                     GSTMaster.Reset();
                     GSTMaster.SetRange(GSTMaster.Category, item1."LSC Division Code");
                     GSTMaster.SetRange(GSTMaster."Subcategory 1", item1."Item Category Code");
                     GSTMaster.SetRange(GSTMaster."Subcategory 2", item1."LSC Retail Product Code");
                     GSTMaster.SetRange(Fabric_Type, item1."Fabric Type");
                     GSTMaster.SetFilter("From Amount", '<=%1', item1."Unit Cost");
                     GSTMaster.SetFilter("To Amount", '>=%1', item1."Unit Cost");
                     if GSTMaster.FindFirst() then begin
                         recPurLine.Validate("GST Group Code", GSTMaster."GST Group");
                         recPurLine.Validate("HSN/SAC Code", GSTMaster."HSN Code");
                     end;
                 end;
             end;

         end;
         LastPOtype := Format(recItemStageVendor."po_type");
         LastVenderNo := Format(recItemStageVendor.designer_id);
         LastLocation := recItemStageVendor.fc_location;

         glPOType := Format(recItemStageVendor."po_type");
         glLastVend := Format(recItemStageVendor.designer_id);
         glLastLOcation := recItemStageVendor.fc_location;
         if recPurLine.Insert(true) then begin
             recItem1.get(txtBarcode);
             recItem1."PO No." := recPurLine."Document No.";
             recItem1.Modify();
             recItemStageVendor."PO Created" := true;
             recItemStageVendor.Modify();
         end;
         //     until recItemStageVendor.Next() = 0;
         // end;*/

        currVendor := format(recItemStageVendor.designer_id);
        CurrPotype := Format(recItemStageVendor."po_type");
        CurrLocation := recItemStageVendor.fc_location;
        // if (LastVenderNo <> currVendor) or (CurrPotype <> LastPOtype) Or (CurrLocation <> LastLocation) then begin
        if (glLastVend <> currVendor) or (glPOType <> CurrPotype) Or (glLastLOcation <> CurrLocation) then begin
            if not recVendor.get(currVendor) then
                Error('Vendor not created');

            //CaptureError_POCreation(recItemStageVendor);
            Evaluate(FCLocation2, recItemStageVendor.fc_location);
            if recItemStageVendor.fc_location = '' then Error('FC Location is empty');
            TabLocation.Reset();
            TabLocation.SetRange("fc_location ID", FCLocation2);
            if TabLocation.FindFirst() then
                FCcode := TabLocation.Code
            else
                Error('FC location %1 doesn''t exist !', FCLocation);

            if Store.Get(FCcode) then
                HeaderNo := CU_NOSeriesMgmt.GetNextNo(Store."Purchase Order No. Series", Today, true);
            recPurPayableSet.Get();
            recPurHeader.Init();
            recPurHeader.validate("Document Type", recPurHeader."Document Type"::Order);
            recPurHeader."No." := HeaderNo; //CU_NOSeriesMgmt.GetNextNo(recPurPayableSet."Order Nos.", Today, true);
            recPurHeader."Gen. Bus. Posting Group" := 'DOMESTIC';
            recPurHeader.validate("Buy-from Vendor No.", currVendor);
            recPurHeader.Validate("Buy-from Address", recVendor.Address);
            recPurHeader.Validate("Buy-from Address 2", recVendor."Address 2");
            recPurHeader.Validate("Buy-from City", recVendor.City);
            recPurHeader.Validate("Buy-from Post Code", recVendor."Post Code");
            recPurHeader.Validate("Buy-from Country/Region Code", recVendor."Country/Region Code");
            recPurHeader.Validate("Posting Date", Today);
            recPurHeader.validate("Document Date", Today);
            recPurHeader.validate("Order Date", Today);
            recPurHeader.Validate("PO type", recItemStageVendor."po_type");
            if not recItem1.Get(recItemStageVendor.bar_code) then Error('Item %1 doesn''t exist in the master', recItemStageVendor.bar_code);
            if recItem1."Customer Order ID" <> '' then begin
                recCustOrderHeader.Get(recItem1."Customer Order ID");
                recPurHeader.Validate("Customer Order ID", recItem1."Customer Order ID");//CITS_RS 170322
                recPurHeader.validate("Partial Payment", recCustOrderHeader."Partial Payment");//CITS_RS 170322
            end;
            //recPurHeader.Validate("fc location", recItemStageVendor.fc_location);
            //recPurHeader.Validate("Location Code", recItemStageVendor.fc_location);
            if recItemStageVendor.fc_location = '' then Error('FC Location is empty');
            Evaluate(FCLocation, recItemStageVendor.fc_location);
            TabLocation.Reset();
            TabLocation.SetRange("fc_location ID", FCLocation);
            if TabLocation.FindFirst() then begin

                recPurHeader."fc location" := TabLocation.Code;
                recPurHeader."Location Code" := TabLocation.code;
            end else
                Error('FC location %1 doesn''t exist !', FCLocation);


            recPurHeader.Status := recPurHeader.Status::Open;
            recPurHeader."Vendor Invoice No." := 'Aza' + recItemStageVendor.aza_code;
            recPurHeader.Insert(true);

            recPurHeader1.get(1, recPurHeader."No.");//assuming type as Order for all transactions
            recPurHeader1."Location Code" := FCcode;
            recPurHeader1.Modify(true);

            intLineNo := 10000;

            recItem.Get(txtBarcode);
            recPurLine.init();
            recPurLine.Type := recPurLine.Type::Item;
            glPurchDocNum := recPurHeader."No.";
            glDocType := format(recPurHeader."Document Type");
            recPurLine."Document No." := recPurHeader."No.";
            recPurLine."Document Type" := recPurLine."Document Type"::Order;
            recPurLine."Line No." := intLineNo;
            recPurLine.Validate("No.", txtBarcode);
            // if item1.Get(txtBarcode) then begin
            //     //recPurLine.Validate("Direct Unit Cost", item1."Unit Cost");
            //     GSTMaster.Reset();
            //     GSTMaster.SetRange(GSTMaster.Category, item1."LSC Division Code");
            //     GSTMaster.SetRange(GSTMaster."Subcategory 1", item1."Item Category Code");
            //     GSTMaster.SetRange(GSTMaster."Subcategory 2", item1."LSC Retail Product Code");
            //     GSTMaster.SetRange(Fabric_Type, item1."Fabric Type");
            //     GSTMaster.SetFilter("From Amount", '<=%1', item1."Unit Cost");
            //     GSTMaster.SetFilter("To Amount", '>=%1', item1."Unit Cost");
            //     if GSTMaster.FindFirst() then begin
            //         recPurLine.Validate("GST Group Code", GSTMaster."GST Group");
            //         //Naveen
            //         if recVendor.Get(item1.designerID) then
            //             if recVendor."GST Vendor Type" = recVendor."GST Vendor Type"::Unregistered then
            //                 if recPurLine."GST Reverse Charge" = true then
            //                     recPurLine.Validate("GST Reverse Charge", true);//Naveen
            //         recPurLine.Validate("HSN/SAC Code", GSTMaster."HSN Code");
            //     end;
            // end;
            LastPOtype := Format(recItemStageVendor."po_type");
            LastVenderNo := Format(recItemStageVendor.designer_id);
            LastLocation := recItemStageVendor.fc_location;

            glPOType := Format(recItemStageVendor."po_type");
            glLastVend := Format(recItemStageVendor.designer_id);
            glLastLOcation := recItemStageVendor.fc_location;
            recPurLine.Validate(Quantity, 1);
            if recPurLine.Insert(true) then begin
                recItem1.get(txtBarcode);
                recItem1."PO No." := recPurLine."Document No.";
                recItem1.Modify();
                recItemStageVendor."PO Created" := true;
                recItemStageVendor.Modify();
            end;
            //recPurLine.Validate("Location Code", recRetailUser."Location Code");
            //recPurLine.Validate("Location Code", recItemStageVendor.fc_location);
            evaluate(enumDocType, glDocType);
            PurChaseLine.Reset();
            PurChaseLine.SetRange("Document Type", enumDocType);
            PurChaseLine.SetRange("Document No.", glPurchDocNum);
            if PurChaseLine.FindFirst() then begin
                if recItemStageVendor.fc_location = '' then Error('FC Location is empty');
                Evaluate(FCLocation, recItemStageVendor.fc_location);
                TabLocation.Reset();
                TabLocation.SetRange("fc_location ID", FCLocation);
                if TabLocation.FindFirst() then
                    PurChaseLine."Location Code" := TabLocation.code
                else
                    Error('FC location %1 doesn''t exist !', FCLocation);
                //PurChaseLine.Validate(MRP, recItemStageVendor.product_price);
                PurChaseLine.Validate(Quantity, 1);
                PurChaseLine.Validate("Unit of Measure", 'PCS');
                // if item1.Get(txtBarcode) then begin
                //     PurChaseLine.Validate("Direct Unit Cost", item1."Unit Cost");
                //     PurChaseLine.Validate("GST Group Code", item1."GST Group Code");
                //     PurChaseLine.Validate("HSN/SAC Code", item1."HSN/SAC Code");
                // end;
                PurChaseLine.Modify();
            end;
        end
        else begin
            evaluate(enumDocType, glDocType);
            PurChaseLine.Reset();
            // PurchLine.SetRange("Document Type", PurchHeader."Document Type");
            // PurchLine.SetRange("Document No.", PurchHeader."No.");
            PurChaseLine.SetRange("Document Type", enumDocType);
            PurChaseLine.SetRange("Document No.", glPurchDocNum);
            if PurChaseLine.FindLast() then begin
                intLineNo := PurChaseLine."Line No." + 10000;
                recPurLine.init();
                recPurLine.Type := recPurLine.Type::Item;
                if recPurHeader."No." = '' then
                    recPurLine."Document No." := glPurchDocNum
                else
                    recPurLine."Document No." := recPurHeader."No.";

                recPurLine."Document Type" := recPurLine."Document Type"::Order;
                recPurLine."Line No." := intLineNo;
                recPurLine.Validate("No.", txtBarcode);
                recPurLine.Validate(Quantity, 1);
                // if item1.Get(txtBarcode) then begin
                //     //recPurLine.Validate("Direct Unit Cost", item1."Unit Cost");
                //     GSTMaster.Reset();
                //     GSTMaster.SetRange(GSTMaster.Category, item1."LSC Division Code");
                //     GSTMaster.SetRange(GSTMaster."Subcategory 1", item1."Item Category Code");
                //     GSTMaster.SetRange(GSTMaster."Subcategory 2", item1."LSC Retail Product Code");
                //     GSTMaster.SetRange(Fabric_Type, item1."Fabric Type");
                //     GSTMaster.SetFilter("From Amount", '<=%1', item1."Unit Cost");
                //     GSTMaster.SetFilter("To Amount", '>=%1', item1."Unit Cost");
                //     if GSTMaster.FindFirst() then begin
                //         recPurLine.Validate("GST Group Code", GSTMaster."GST Group");
                //         recPurLine.Validate("HSN/SAC Code", GSTMaster."HSN Code");
                //     end;
                // end;
                LastPOtype := Format(recItemStageVendor."po_type");
                LastVenderNo := Format(recItemStageVendor.designer_id);
                LastLocation := recItemStageVendor.fc_location;

                glPOType := Format(recItemStageVendor."po_type");
                glLastVend := Format(recItemStageVendor.designer_id);
                glLastLOcation := recItemStageVendor.fc_location;
                if recPurLine.Insert(true) then begin
                    recItem1.get(txtBarcode);
                    recItem1."PO No." := recPurLine."Document No.";
                    recItem1.Modify();
                    recItemStageVendor."PO Created" := true;
                    recItemStageVendor.Modify();
                end;
                //recPurLine.Validate("Location Code", recRetailUser."Location Code");
                //recPurLine.Validate("Location Code", recItemStageVendor.fc_location);
                evaluate(enumDocType, glDocType);
                PurChaseLine.Reset();
                PurChaseLine.SetRange("Document Type", enumDocType);
                PurChaseLine.SetRange("Document No.", glPurchDocNum);
                if PurChaseLine.FindFirst() then begin
                    if recItemStageVendor.fc_location = '' then Error('FC Location is empty');
                    Evaluate(FCLocation, recItemStageVendor.fc_location);
                    TabLocation.Reset();
                    TabLocation.SetRange("fc_location ID", FCLocation);
                    if TabLocation.FindFirst() then
                        PurChaseLine."Location Code" := TabLocation.code
                    else
                        Error('FC location %1 doesn''t exist !', FCLocation);
                    // PurChaseLine.Validate(MRP, recItemStageVendor.product_price);

                    PurChaseLine.Validate("Unit of Measure", 'PCS');
                    // if item1.Get(txtBarcode) then begin
                    //     PurChaseLine.Validate("Direct Unit Cost", item1."Unit Cost");
                    //     PurChaseLine.Validate("GST Group Code", item1."GST Group Code");
                    //     PurChaseLine.Validate("HSN/SAC Code", item1."HSN/SAC Code");
                    // end;
                    PurChaseLine.Validate(Quantity, 1);
                    PurChaseLine.Modify();
                end;
            end;

        end;
        // LastPOtype := Format(recItemStageVendor."po_type");
        // LastVenderNo := Format(recItemStageVendor.designer_id);
        // LastLocation := recItemStageVendor.fc_location;

        // glPOType := Format(recItemStageVendor."po_type");
        // glLastVend := Format(recItemStageVendor.designer_id);
        // glLastLOcation := recItemStageVendor.fc_location;
        // if recPurLine.Insert(true) then begin
        //     recItem1.get(txtBarcode);
        //     recItem1."PO No." := recPurLine."Document No.";
        //     recItem1.Modify();
        //     recItemStageVendor."PO Created" := true;
        //     recItemStageVendor.Modify();
        // end;
        //     until recItemStageVendor.Next() = 0;
        // end;

    end;

    procedure PoExistOrNotOnItem(recItemStage: Record Aza_Item): Boolean
    var
        recItemStage1: Record Aza_Item;
        occurrenceCount: Integer;
        BarCode: Code[20];
        item: Record item;
    begin
        if StrLen(recItemStage.bar_code) > 20 then
            BarCode := CopyStr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)
        else
            BarCode := recItemStage.bar_code;

        if item.Get(BarCode) then
            if item."PO No." = '' then
                exit(true)
            else
                exit(false);
    end;
}