codeunit 50103 PO_CreationfromStaging
{
    SingleInstance = true;
    TableNo = 472;
    trigger OnRun()
    begin
        if Rec."Parameter String" = 'GRN' then
            ProcessGRNRecords();
        if Rec."Parameter String" = 'CreatePO' then
            ProcessPOs();
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeRunCommand', '', false, false)]



    //*******Not in use**********
    [TryFunction]
    procedure CreatePO()
    var
        CU_NOSeriesMgmt: Codeunit NoSeriesManagement;
        recPurPayableSet: Record "Purchases & Payables Setup";
        recItemStaging: Record Aza_Item;
        recPurHeader: Record "Purchase Header";
        recPurLine: Record "Purchase Line";
        currVendor: Code[10];
        prevVendor: Code[10];
        intLineNo: Integer;
        recItemStageVendor: Record Aza_Item;
        recItem: Record Item;
        recVendor: Record Vendor;
        intVendID: Integer;
        recRetailUser: Record "LSC Retail User";
        recUserSetup: Record "User Setup";
    begin
        /*recRetailUser.Reset();
        recRetailUser.SetRange(ID, UserId);
        if recRetailUser.FindFirst() then;


        currVendor := format(recItemStageVendor.parent_designer_id);


        if (prevVendor <> currVendor) then begin
            if (prevVendor = '') or (prevVendor <> currVendor) then
                prevVendor := currVendor;
            Evaluate(intVendID, prevVendor);
            // prevVendor := recItemStaging.designer_code;

            recItemStageVendor.Reset();
            recItemStageVendor.SetCurrentKey(parent_designer_id, "po_type");
            recItemStageVendor.SetRange("Record Status", recItemStageVendor."Record Status"::Created);
            recItemStageVendor.SetRange("PO Created", false);
            if recItemStageVendor.FindSet() then
                repeat

                    currVendor := format(recItemStageVendor.parent_designer_id);
                    if (prevVendor <> currVendor) then begin
                        if not recVendor.get(prevVendor) then
                            Error('Vendor not created');

                        CaptureError_POCreation(recItemStageVendor);
                        recPurPayableSet.Get();
                        recPurHeader.Init();
                        recPurHeader.validate("Document Type", recPurHeader."Document Type"::Order);
                        recPurHeader."No." := CU_NOSeriesMgmt.GetNextNo(recPurPayableSet."Order Nos.", Today, true);
                        recPurHeader."Gen. Bus. Posting Group" := 'DOMESTIC';
                        recPurHeader.validate("Buy-from Vendor No.", prevVendor);
                        recPurHeader.Validate("Buy-from Address", recVendor.Address);
                        recPurHeader.Validate("Buy-from Address 2", recVendor."Address 2");
                        recPurHeader.Validate("Buy-from City", recVendor.City);
                        recPurHeader.Validate("Buy-from Post Code", recVendor."Post Code");
                        recPurHeader.Validate("Buy-from Country/Region Code", recVendor."Country/Region Code");
                        recPurHeader.Validate("Posting Date", Today);
                        recPurHeader.validate("Document Date", Today);
                        recPurHeader.validate("Order Date", Today);
                        recPurHeader.Validate("Location Code", recRetailUser."Location Code");
                        recPurHeader.Status := recPurHeader.Status::Open;
                        recPurHeader."Vendor Invoice No." := 'Aza' + recItemStageVendor.aza_code;
                        recPurHeader.Insert();
                        intLineNo := 10000;
                        repeat
                            if StrLen(recItemStageVendor.bar_code) > 20 then  //130223 CITS_RS
                                recItem.Get(CopyStr(recItemStageVendor.bar_code, (StrLen(recItemStageVendor.bar_code) - 20), 20))
                            else
                                recItem.Get(recItemStageVendor.bar_code);
                            recPurLine.Reset();
                            recPurLine.Type := recPurLine.Type::Item;
                            recPurLine."Document No." := recPurHeader."No.";
                            recPurLine."Document Type" := recPurLine."Document Type"::Order;
                            recPurLine."Line No." := intLineNo;

                            if StrLen(recItemStageVendor.bar_code) > 20 then begin //130223 CITS_RS
                                recItem.Get(CopyStr(recItemStageVendor.bar_code, (StrLen(recItemStageVendor.bar_code) - 20), 20));
                                recPurLine.validate("No.", CopyStr(recItemStageVendor.bar_code, (StrLen(recItemStageVendor.bar_code) - 20), 20));
                            end else
                                recPurLine.validate("No.", recItemStageVendor.bar_code);
                            recPurLine.Description := recItem.Description;
                            recPurLine."Location Code" := recRetailUser."Location Code";
                            recPurLine.Quantity := 1;
                            recPurLine."Quantity (Base)" := 1;
                            recPurLine."Qty. to Invoice" := 1;
                            recPurLine."Qty. to Receive" := 1;
                            recPurLine."Unit of Measure" := 'PCS';
                            recPurLine.Insert();
                            intLineNo += 10000;
                            recItemStageVendor."PO Created" := true;
                            recItemStageVendor.Modify();
                        until recItemStageVendor.Next() = 0;
                    end;
                    recItem."PO No." := recPurHeader."No.";
                    recItem.Modify();
                until recItemStageVendor.Next() = 0;


        end;
        // until recItemStaging.Next() = 0;

        */

    end;

    procedure CaptureError_POCreation(recItemStage: Record Aza_Item)//; ErrorMsg: text)
    var
        recItemError: Record ErrorCapture;
    begin
        recItemError.Init();
        if recItemError.findlast then
            recItemError."Sr. No" += 1
        else
            recItemError."Sr. No" := 1;
        recItemError.Item_code := recItemStage.bar_code;
        // recItemError.DocumentNum :=
        recItemError."Error DateTime" := CurrentDateTime();
        recItemError.DocumentNum := glDocNum;
        // if ErrorMsg <> '' then
        //     recItemError."Error Remarks" := ErrorMsg
        // else
        recItemError."Error Remarks" := copystr(GetLastErrorText(), 1, 1000);
        recItemError."Process Type" := recItemError."Process Type"::"PO Creation";
        recItemError.Insert();
    end;

    procedure ItemwithPOExistsInStaging(recItemStage: Record Aza_Item): Boolean
    var
        recItemStage1: Record Aza_Item;
        occurrenceCount: Integer;
    begin
        Clear(occurrenceCount);
        recItemStage1.Reset();
        recItemStage1.SetFilter(bar_code, recItemStage.bar_code);
        recItemStage1.SetRange("Record Status", recItemStage1."Record Status"::Created);
        recItemStage1.SetRange("PO Created", true);
        recItemStage1.SetRange(Is_Outward, false);
        if recItemStage1.Find('-') then begin
            repeat
                occurrenceCount += 1
            until recItemStage1.Next() = 0;
        end;

        if occurrenceCount >= 1 then
            exit(true)
        else
            exit(false);

    end;

    procedure ProcessPOs()
    var
        recItemStageVendor: Record Aza_Item;
        txtBarcode: text;
        errorLog: Record ErrorCapture;
        recItemStage1: Record Aza_Item;
        errorFound: Boolean;
        cuFunctions: Codeunit Functions;
        Locationn: Record Location;
        RetailUser: Record "LSC Retail User";
        Fc: Integer;
        Location1: Record Location;
        FcID: Integer;
    //PoCreationNew: Codeunit PoCreation_new;
    begin
        Clear(glLastLOcation);
        Clear(glLastVend);
        Clear(glDocNum);
        Clear(glPOType);
        Clear(glPurchDocNum);
        Clear(glDocType);
        clear(errorFound);//CITS_RS 150223
        Clear(Fc);
        Clear(FcID);
        RetailUser.Get(UserId);
        if Locationn.Get(RetailUser."Location Code") then
            Fc := Locationn."fc_location ID";
        recItemStageVendor.Reset();
        // recItemStageVendor.SetCurrentKey("Entry No.");
        recItemStageVendor.SetCurrentKey(designer_id, "po_type", fc_location);
        // recItemStageVendor.SetFilter(type_of_inventory, '<>%1|%2', 'MTO', 'CO-CUSTOMER ORDER');//170223 MTO items not to be considered in Offline POs//CustOrder added 060423 CITS_RS
        recItemStageVendor.SetFilter(po_type, '<>%1|%2', recItemStageVendor.po_type::"C0-Customer Order", recItemStageVendor.po_type::MTO);
        // recItemStageVendor.SetFilter(fc_location, '<>%1|%2|%3|%4|%5|%6|%7', '1', '361', '362', '1704', '1716', '367', '2');
        if fc <> 0 then
            recItemStageVendor.SetRange(fc_location, Format(Fc));
        // else
        //     recItemStageVendor.SetFilter(fc_location, '=%1|%2|%3', '355', '356', '357');//added02082023
        // recItemStageVendor.SetCurrentKey(designer_id, "po_type");
        recItemStageVendor.SetFilter("Record Status", '=%1|%2', recItemStageVendor."Record Status"::Created, recItemStageVendor."Record Status"::Updated);
        recItemStageVendor.SetRange("PO Created", false);
        if recItemStageVendor.FindSet() then begin
            repeat
                Location1.Reset();
                Evaluate(FcID, recItemStageVendor.fc_location);
                Location1.SetRange("fc_location ID", FcID);
                if Location1.FindFirst() then
                    if Location1."Po Creation" then begin
                        Clear(txtBarcode);
                        if StrLen(recItemStageVendor.bar_code) > 20 then
                            txtBarcode := CopyStr(recItemStageVendor.bar_code, StrLen(recItemStageVendor.bar_code) - 20 + 1)
                        else
                            txtBarcode := recItemStageVendor.bar_code;
                        //if not ItemwithPOExistsInStaging(recItemStageVendor) then//020223 CIIS_RScommented290823
                        Commit();
                        if not CreatePO2.Run(recItemStageVendor) then begin//commented12092023
                                                                           //if not PoCreationNew.Run(recItemStageVendor) then begin
                                                                           //cuFunctions.CreateErrorLog(2, '', recItemStageVendor."Entry No.", format(recItemStageVendor.designer_id), txtBarcode, '');
                            cuFunctions.CreateErrorLogPO('', recItemStageVendor."Entry No.", format(recItemStageVendor.designer_id), txtBarcode, '');
                            recItemStage1.get(recItemStageVendor."Entry No.");
                            recItemStage1."Record Status" := recItemStage1."Record Status"::Error;
                            recItemStage1.Modify();
                        end;
                    end;
            until recItemStageVendor.Next() = 0;
        end;




        /*
        //For errors
        Clear(glLastLOcation);
        Clear(glLastVend);
        Clear(glDocNum);
        Clear(glPOType);
        Clear(glPurchDocNum);
        Clear(glDocType);
        recItemStageVendor.Reset();
        recItemStageVendor.SetCurrentKey(designer_id, "po_type", fc_location);
        recItemStageVendor.SetRange("Record Status", recItemStageVendor."Record Status"::Error);
        recItemStageVendor.SetRange("Error date", Today - 2, Today);
        recItemStageVendor.SetFilter(type_of_inventory, '<>%1', 'MTO');//170223 MTO items not to be considered in Offline POs
        recItemStageVendor.SetRange("PO Created", false);
        if recItemStageVendor.FindSet() then begin
            repeat
                Clear(txtBarcode);
                if StrLen(recItemStageVendor.bar_code) > 20 then
                    txtBarcode := CopyStr(recItemStageVendor.bar_code, StrLen(recItemStageVendor.bar_code) - 20 + 1)
                else
                    txtBarcode := recItemStageVendor.bar_code;
                if not ItemwithPOExistsInStaging(recItemStageVendor) then//020223 CIIS_RS
                    if not CreatePO2(recItemStageVendor) then begin
                        cuFunctions.CreateErrorLog(2, '', recItemStageVendor."Entry No.", format(recItemStageVendor.designer_id), txtBarcode, '');
                        recItemStage1.get(recItemStageVendor."Entry No.");
                        recItemStage1."Record Status" := recItemStage1."Record Status"::Error;
                        recItemStage1."Error date" := Today;
                        recItemStage1.Modify();
                    end else begin
                        recItemStageVendor."Record Status" := recItemStageVendor."Record Status"::Created;
                        errorLog.Reset();
                        errorLog.SetRange("Source Entry No.", recItemStageVendor."Entry No.");
                        errorLog.SetRange(Item_code, txtBarcode);
                        if errorLog.FindSet() then
                            errorLog.Delete();
                    end;
            until recItemStageVendor.Next() = 0;
        end;*/
    end;

    procedure ProcessPOs2()
    var
        recItemStageVendor: Record Aza_Item;
        txtBarcode: text;
        errorLog: Record ErrorCapture;
        recItemStage1: Record Aza_Item;
        errorFound: Boolean;
        cuFunctions: Codeunit Functions;
        Locationn: Record Location;
        RetailUser: Record "LSC Retail User";
        Fc: Integer;
    begin
        Clear(glLastLOcation);
        Clear(glLastVend);
        Clear(glDocNum);
        Clear(glPOType);
        Clear(glPurchDocNum);
        Clear(glDocType);
        clear(errorFound);//CITS_RS 150223
        Clear(Fc);
        RetailUser.Get(UserId);
        if Locationn.Get(RetailUser."Location Code") then
            Fc := Locationn."fc_location ID";
        recItemStageVendor.Reset();
        recItemStageVendor.SetCurrentKey(designer_id, "po_type", fc_location);
        recItemStageVendor.SetFilter(po_type, '<>%1|%2', recItemStageVendor.po_type::"C0-Customer Order", recItemStageVendor.po_type::MTO);
        recItemStageVendor.SetFilter(fc_location, '<>%1', '1');//060423 CITS_RS
        if Fc <> 0 then
            recItemStageVendor.SetRange(fc_location, Format(Fc))
        else
            recItemStageVendor.SetFilter(fc_location, '=%1|%2|%3', '355', '356', '357');//added02082023
        recItemStageVendor.SetFilter("Record Status", '=%1|%2', recItemStageVendor."Record Status"::Created, recItemStageVendor."Record Status"::Updated);
        recItemStageVendor.SetRange("PO Created", false);
        if recItemStageVendor.FindSet() then begin
            repeat
                Clear(txtBarcode);
                if StrLen(recItemStageVendor.bar_code) > 20 then
                    txtBarcode := CopyStr(recItemStageVendor.bar_code, StrLen(recItemStageVendor.bar_code) - 20 + 1)
                else
                    txtBarcode := recItemStageVendor.bar_code;
                if not ItemwithPOExistsInStaging(recItemStageVendor) then Begin//020223 CIIS_RS
                    Commit();
                    if not CreatePO2.Run(recItemStageVendor) then begin
                        cuFunctions.CreateErrorLog(2, '', recItemStageVendor."Entry No.", format(recItemStageVendor.designer_id), txtBarcode, '');
                        recItemStage1.get(recItemStageVendor."Entry No.");
                        recItemStage1."Record Status" := recItemStage1."Record Status"::Error;
                        recItemStage1.Modify();
                    end;
                end;
            until recItemStageVendor.Next() = 0;
        end;
    end;






    //New function created for Customer order PO creation
    [TryFunction]
    procedure CreatePO2_CO(recItemStageVendor: Record Aza_Item; CO_DocumentID: Code[30])
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
        recErrorLog: Record ErrorCapture;
        GSTMaster: Record "GST Master";
    begin
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
            recErrorLog."Process Type" := recErrorLog."Process Type"::"PO Creation";
            recErrorLog."Vendor Code" := recItemStageVendor.designer_id;
            recErrorLog.Insert();
            exit;
        end;


        currVendor := format(recItemStageVendor.designer_id);
        CurrPotype := Format(recItemStageVendor."po_type");
        CurrLocation := recItemStageVendor.fc_location;
        // if (LastVenderNo <> currVendor) or (CurrPotype <> LastPOtype) Or (CurrLocation <> LastLocation) then begin
        //// if (glLastVend <> currVendor) or (glPOType <> CurrPotype) Or (glLastLOcation <> CurrLocation) then begin
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
        recPurHeader.Insert(true);
        recPurHeader."Gen. Bus. Posting Group" := 'DOMESTIC';
        recPurHeader.validate("Buy-from Vendor No.", recItemStageVendor.designer_id);//>><<2905
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
        // recPurHeader.Insert(true);

        recPurHeader1.get(1, recPurHeader."No.");//assuming type as Order for all transactions
        recPurHeader1."Location Code" := FCcode;
        recPurHeader1."PO type" := recPurHeader1."PO type"::"C0-Customer Order";
        recPurHeader1."Customer Order ID" := CO_DocumentID;//060423 CITS_RS
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
        if item1.Get(txtBarcode) then begin
            //recPurLine.Validate("Direct Unit Cost", item1."Unit Cost");
            GSTMaster.Reset();
            GSTMaster.SetRange(GSTMaster.Category, item1."LSC Division Code");
            GSTMaster.SetRange(GSTMaster."Subcategory 1", item1."Item Category Code");
            GSTMaster.SetRange(GSTMaster."Subcategory 2", item1."LSC Retail Product Code");
            GSTMaster.SetRange(Fabric_Type, item1."Fabric Type");
            GSTMaster.SetFilter("From Amount", '<=%1', item1."Unit Cost");
            GSTMaster.SetFilter("To Amount", '>=%1', item1."Unit Cost");
            if GSTMaster.FindFirst() then begin
                recPurLine.Validate("GST Group Code", GSTMaster."GST Group");
                //Naveen
                if recVendor.Get(item1.designerID) then
                    if recVendor."GST Vendor Type" = recVendor."GST Vendor Type"::Unregistered then
                        if recPurLine."GST Reverse Charge" = true then
                            recPurLine.Validate("GST Reverse Charge", true);//Naveen
                recPurLine.Validate("HSN/SAC Code", GSTMaster."HSN Code");
            end;
        end;
        LastPOtype := Format(recItemStageVendor."po_type");
        LastVenderNo := Format(recItemStageVendor.designer_id);
        LastLocation := recItemStageVendor.fc_location;

        glPOType := Format(recItemStageVendor."po_type");
        glLastVend := Format(recItemStageVendor.designer_id);
        glLastLOcation := recItemStageVendor.fc_location;
        if recPurHeader1."GST Vendor Type" = recPurHeader1."GST Vendor Type"::Unregistered then //120623;
            recPurLine."GST Reverse Charge" := true;
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
            PurChaseLine.Validate(MRP, recItemStageVendor.product_price);
            PurChaseLine.Validate(Quantity, 1);
            PurChaseLine.Validate("Unit of Measure", 'PCS');
            if item1.Get(txtBarcode) then
                PurChaseLine.Validate("Direct Unit Cost", item1."Unit Cost");
            PurChaseLine.Modify();
        end;
        /* end
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
                 if item1.Get(txtBarcode) then begin
                     //recPurLine.Validate("Direct Unit Cost", item1."Unit Cost");
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
                     PurChaseLine.Validate(MRP, recItemStageVendor.product_price);
                     PurChaseLine.Validate(Quantity, 1);
                     PurChaseLine.Validate("Unit of Measure", 'PCS');
                     if item1.Get(txtBarcode) then
                         PurChaseLine.Validate("Direct Unit Cost", item1."Unit Cost");
                     // recPurLine.Validate("Direct Unit Cost", recItemStageVendor.product_cost);//as per 02-03-23
                     PurChaseLine.Modify();
                 end;
             end;

         end;*/
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

    procedure ProcessGRNRecords()
    var
        recGRNStaging: Record GRN_Staging;
        cuFunctions: Codeunit Functions;
        recActionStatus: Record ActionStatus_GRN;
        recErrorLog: record ErrorCapture;
        txtBarcode: Text;
        arrPONum: array[999] of Text;
        arrBarcode: array[999] of Text;
        i: Integer;
        intPOID: Integer;
    begin
        recGRNStaging.Reset();
        recGRNStaging.SetRange("Record Status", recGRNStaging."Record Status"::" ");
        if recGRNStaging.Find('-') then begin
            i := 0;
            repeat
                Clear(txtBarcode);
                Clear(glinwardDone);
                if StrLen(recGRNStaging.barcode) > 20 then
                    txtBarcode := CopyStr(recGRNStaging.barcode, StrLen(recGRNStaging.barcode) - 20 + 1)
                else
                    txtBarcode := recGRNStaging.barcode;
                if not ProcessPOGRN(recGRNStaging) then begin
                    //cuFunctions.CreateErrorLog(5, '', recGRNStaging."Entry No.", '', txtBarcode, recGRNStaging.po_number);
                    cuFunctions.CreateErrorLogPO('', recGRNStaging."Entry No.", '', txtBarcode, recGRNStaging.po_number);
                    recGRNStaging."Record Status" := recGRNStaging."Record Status"::Error;
                    recGRNStaging.Modify();
                end else begin
                    i += 1;
                    // if glinwardDone then begin
                    //     arrBarcode[i] := recGRNStaging.barcode;
                    //     arrPONum[i] := recGRNStaging.po_number;

                    // if not receiptAlreadyExists(recGRNStaging.po_number) then
                    //     if not PostShipment(recGRNStaging) then begin
                    // cuFunctions.CreateErrorLog(5, '', recGRNStaging."Entry No.", '', txtBarcode, recGRNStaging.po_number);
                    // recGRNStaging."Record Status" := recGRNStaging."Record Status"::Error;
                    // recGRNStaging.Modify();
                    // end else begin
                    // Evaluate(intPOID, recGRNStaging.po_number);
                    // MarkActionLines(intPOID);
                    // MarkActionLines(recGRNStaging);
                    // recGRNStaging."Record Status" := recGRNStaging."Record Status"::Processed;
                    // recGRNStaging.Modify();
                    // end;
                    // end else begin
                    // Evaluate(intPOID, recGRNStaging.po_number);
                    // MarkActionLines(intPOID);
                    //  MarkActionLines(recGRNStaging);
                    recGRNStaging."Record Status" := recGRNStaging."Record Status"::Processed;
                    recGRNStaging.Modify();
                    //  end;
                end;
            until recGRNStaging.Next() = 0;
            //Taken out from loop to handle multiple barcodes against single PO CITS_TS 130423
            // if glinwardDone then begin
            //     if not receiptAlreadyExists(recGRNStaging.po_number) then
            //         if not PostShipment(recGRNStaging) then begin
            //             cuFunctions.CreateErrorLog(5, '', recGRNStaging."Entry No.", '', txtBarcode, recGRNStaging.po_number);
            //             MarkGRNLines(arrPONum, arrBarcode, i, true);
            //             // recGRNStaging."Record Status" := recGRNStaging."Record Status"::Error;
            //             // recGRNStaging.Modify();
            //         end else begin
            //             MarkActionLines(recGRNStaging);
            //             MarkGRNLines(arrPONum, arrBarcode, i, false);
            //             // recGRNStaging."Record Status" := recGRNStaging."Record Status"::Processed;
            //             // recGRNStaging.Modify();
            //         end;
            // end;
        end;


        //For errors
        /*recGRNStaging.Reset();
        recGRNStaging.SetRange("Record Status", recGRNStaging."Record Status"::Error);
        recGRNStaging.SetRange("Error Date", Today - 2, Today);
        if recGRNStaging.Find('-') then
            repeat
                Clear(txtBarcode);
                if StrLen(recGRNStaging.barcode) > 20 then
                    txtBarcode := CopyStr(recGRNStaging.barcode, StrLen(recGRNStaging.barcode) - 20 + 1)
                else
                    txtBarcode := recGRNStaging.barcode;
                if not ProcessPOGRN(recGRNStaging) then begin
                    cuFunctions.CreateErrorLog(5, '', recGRNStaging."Entry No.", '', txtBarcode, recGRNStaging.po_number);
                    recGRNStaging."Record Status" := recGRNStaging."Record Status"::Error;
                    recGRNStaging.Modify();
                end else begin
                    if glinwardDone then begin
                        if not PostShipment(recGRNStaging) then begin
                            cuFunctions.CreateErrorLog(5, '', recGRNStaging."Entry No.", '', txtBarcode, recGRNStaging.po_number);
                            recGRNStaging."Record Status" := recGRNStaging."Record Status"::Error;
                            recGRNStaging.Modify();
                        end else begin
                            Evaluate(intPOID, recGRNStaging.po_number);
                            MarkActionLines(intPOID);
                            recGRNStaging."Record Status" := recGRNStaging."Record Status"::Processed;
                            recGRNStaging.Modify();
                        end;
                    end else begin
                        Evaluate(intPOID, recGRNStaging.po_number);
                        MarkActionLines(intPOID);
                        recGRNStaging."Record Status" := recGRNStaging."Record Status"::Processed;
                        recGRNStaging.Modify();
                    end;
                    // recErrorLog.Reset();
                    // recErrorLog.SetRange();
                end;
            until recGRNStaging.Next() = 0;*/

    end;

    procedure receiptAlreadyExists(docNum: Code[50]): Boolean
    var
        recPurchReceiptHeader: Record "Purch. Rcpt. Header";
    begin
        recPurchReceiptHeader.Reset();
        recPurchReceiptHeader.SetFilter("Order No.", docNum);
        if not recPurchReceiptHeader.FindFirst() then
            exit(false)
        else
            exit(true);

    end;

    // OnBeforeCheckReceiveInvoiceShip(var PurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckReceiveInvoiceShip', '', false, false)]
    procedure SetShipflag(var PurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
    begin
        PurchHeader.Ship := true;
        PurchHeader.Receive := true;
    end;

    // OnBeforeCheckHeaderPostingType(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckHeaderPostingType', '', false, false)]
    procedure SetShipflag_BeforePosting(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
    begin
        PurchaseHeader.Ship := true;
        PurchaseHeader.Receive := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInsertReceiptHeader', '', false, false)]
    local procedure OnBeforeInsertReceiptHeader(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var IsHandled: Boolean; CommitIsSuppressed: Boolean);
    var
        InvPosSetup: Record "Inventory Posting Setup";
    begin
        if InvPosSetup.Get('ONL', 'RETAIL') then
            if InvPosSetup."Inventory Account" = '' then
                IsHandled := true;
    end;


    [TryFunction]
    procedure PostShipment(recGRNStaging: Record GRN_Staging)
    var
        recPurchHeader: Record "Purchase Header";
    begin
        Clear(boolHandle);
        recPurchHeader.get(1, recGRNStaging.po_number);
        recPurchHeader.validate(Ship, true);
        if recPurchHeader."Vendor Order No." = '' then
            recPurchHeader."Vendor Order No." := recPurchHeader."No.";
        if recPurchHeader."Vendor Invoice No." = '' then
            recPurchHeader."Vendor Invoice No." := recPurchHeader."No.";

        recPurchHeader.Modify();
        Commit();
        //ReleasePurchDoc.PerformManualRelease(recPurchHeader);
        //Codeunit.Run(Codeunit::"Release Purchase Document", recPurchHeader);
        Clear(cuPurchPost);
        // SetShipflag(recPurchHeader, boolHandle);
        // SetShipflag_BeforePosting(recPurchHeader, boolHandle);
        cuPurchPost.Run(recPurchHeader);
    end;

    [TryFunction]
    procedure PostShipmentRTV(PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.validate(Ship, true);
        if PurchHeader."Vendor Order No." = '' then
            PurchHeader."Vendor Order No." := PurchHeader."No.";
        if PurchHeader."Vendor Invoice No." = '' then
            PurchHeader."Vendor Invoice No." := PurchHeader."No.";
        PurchHeader."Posting Date" := Today;

        PurchHeader.Modify();
        Commit();

        Clear(cuPurchPost);
        cuPurchPost.Run(PurchHeader);
    end;

    // procedure MarkActionLines(PO_ID: Integer)
    procedure MarkActionLines(recGRNHeader: Record GRN_Staging)

    var
        recActionStatus: Record ActionStatus_GRN;
        PurHeader1: Record "Purchase Header";
    begin
        recActionStatus.Reset();
        recActionStatus.SetRange(PO_ID, recGRNHeader.po_number);
        // recActionStatus.SetRange(BarCode, recGRNHeader.barcode);//CITS_RS 130423
        recActionStatus.SetRange(Processed, false);
        if recActionStatus.Find('-') then
            repeat
                recActionStatus.Processed := true;
                recActionStatus.Modify();
            until recActionStatus.Next() = 0;
        // PurHeader1.Reset();//for reopen purchase order
        // PurHeader1.SetRange("Document Type", PurHeader1."Document Type"::Order);
        // PurHeader1.SetRange("No.", recGRNHeader.po_number);
        // if PurHeader1.FindFirst() then begin
        //     PurHeader1.Validate(Status, PurHeader1.Status::Open);
        //     PurHeader1.Modify();
        // end;
    end;

    procedure MarkGRNLines(arrPONUm: array[999] of Text; arrBarcode: array[999] of Text; arrcount: Integer; errorFound: Boolean)
    var
        recActionStatus: Record ActionStatus_GRN;
        recGRNHeader1: Record GRN_Staging;
        j: Integer;
    begin
        j := 1;
        while j <= arrcount do begin
            recGRNHeader1.Reset();
            recGRNHeader1.SetRange(po_number, arrPONUm[j]);
            recGRNHeader1.SetRange(barcode, arrBarcode[j]);
            recGRNHeader1.SetRange("Record Status", recGRNHeader1."Record Status"::" ");
            if recGRNHeader1.Find('-') then
                repeat
                    if not errorFound then
                        recGRNHeader1."Record Status" := recGRNHeader1."Record Status"::Processed
                    else
                        recGRNHeader1."Record Status" := recGRNHeader1."Record Status"::Error;
                    recGRNHeader1.Modify();
                until recGRNHeader1.Next() = 0;
            j += 1;
        end;

        // recActionStatus.Reset();
        // recActionStatus.SetRange(PO_ID, recGRNHeader.po_number);
        // recActionStatus.SetRange(BarCode, recGRNHeader.barcode);//CITS_RS 130423
        // recActionStatus.SetRange(Processed, false);

        // if recActionStatus.Find('-') then
        //     repeat
        //         recActionStatus.Processed := true;
        //         recActionStatus.Modify();
        //     until recActionStatus.Next() = 0;

    end;

    [TryFunction]
    procedure ProcessPOGRN(recGRNStaging: Record GRN_Staging)
    var
        recPurchHeader: Record "Purchase Header";
        recActionStatus: Record ActionStatus_GRN;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        recPurchaseLine: Record "Purchase Line";
        PurchaseLineRcvd: Record "Purchase Line";
        cuFunctions: Codeunit Functions;
        recItem: Record Item;
        ReleasePurchDoc: Codeunit 415;
        cuPurchPost: Codeunit "Purch.-Post";
        recVendor: Record 23;
        EditableField: Boolean;
        inwardDone: Boolean;
        PONum: Code[30];
        intPO_ID: Integer;
        PurHeader: Record "Purchase Header";
        PurHeader1: Record "Purchase Header";
        PurLine: Record "Purchase Line";
        VendNo: Code[20];
        ItemCost: Decimal;
        Item: Record Item;
        LastVendor: Code[20];
        PurPaybleSetup: Record "Purchases & Payables Setup";
        NOSeriesMgmt: Codeunit NoSeriesManagement;
        POOrderNo: Code[20];
        LineNo: Integer;
        Itm: Record item;
        GRNHash: Record "GRN Action Hash";
        PurRecHdr: Record "Purch. Rcpt. Header";
        PurRecLine: Record "Purch. Rcpt. Line";
        PurInvHdr: Record "Purch. Inv. Header";
        PurInvLine: Record "Purch. Inv. Line";
        TabLocation: Record Location;
        FCLocation: Integer;
    begin
        if recGRNStaging.po_number = '' then Error('Purchase Order No. is blank for GRN ID %1', recGRNStaging.id);
        clear(inwardDone);
        if Itm.Get(recGRNStaging.barcode) then
            itm."1st GRN Date" := Today;
        recActionStatus.Reset();
        recActionStatus.SetRange(PO_ID, recGRNStaging.po_number);
        //recActionStatus.SetRange(BarCode, recGRNStaging.barcode);//CITTS_RS 130423
        recActionStatus.SetRange(Processed, false);
        if recActionStatus.Find('-') then begin
            repeat
                if not recPurchHeader.get(1, recGRNStaging.po_number) then Error('Purchase Order %1 doesn''t exist !', recGRNStaging.po_number);
                GRNHash.Reset();
                GRNHash.SetRange("PO No.", recActionStatus.PO_ID);
                GRNHash.SetRange(Barcode, recActionStatus.barcode);
                GRNHash.SetRange(hash, recActionStatus.hash);
                if not GRNHash.FindFirst() then begin
                    GRNHash.Init();
                    GRNHash.Validate(hash, recActionStatus.hash);
                    GRNHash.Validate("PO No.", recActionStatus.PO_ID);
                    GRNHash.Validate("Action ID", recActionStatus."Action ID");
                    GRNHash.Validate(Barcode, recActionStatus.BarCode);
                    GRNHash.Insert();

                    PONum := recPurchHeader."No.";
                    recPurchaseLine.reset;
                    recPurchaseLine.SetRange("Document Type", recPurchHeader."Document Type");
                    recPurchaseLine.SetRange("Document No.", recPurchHeader."No.");
                    recPurchaseLine.SetRange("No.", recActionStatus.BarCode);//CITS_RS 130423

                    //recPurchaseLine.SetRange("No.", '');//need barcode field in the GRN API.
                    //  if recPurchaseLine.find('-') then begin
                    if recPurchaseLine.FindLast() then begin
                        // repeat
                        case recActionStatus."Action ID" of
                            1:
                                begin
                                    inwardDone := true;
                                    glinwardDone := true;
                                    PurchaseLineRcvd.Reset();
                                    PurchaseLineRcvd.SetRange("Document Type", recPurchHeader."Document Type");
                                    PurchaseLineRcvd.SetRange("Document No.", recPurchHeader."No.");
                                    PurchaseLineRcvd.SetRange("No.", recActionStatus.BarCode);
                                    PurchaseLineRcvd.SetFilter("Quantity Received", '=%1', 0);
                                    if PurchaseLineRcvd.FindLast() then begin
                                        PurchaseLineRcvd.validate("Qty. to Receive", 1);
                                        PurchaseLineRcvd.validate("QC Action", PurchaseLineRcvd."QC Action"::Inward);
                                        //>>>>>>>>>>>>>for location update in po line before posting
                                        if recGRNStaging.fc_location = '' then
                                            Error('FC Location is empty');
                                        Evaluate(FCLocation, recGRNStaging.fc_location);
                                        TabLocation.Reset();
                                        TabLocation.SetRange("fc_location ID", FCLocation);
                                        if TabLocation.FindFirst() then
                                            PurchaseLineRcvd."Location Code" := TabLocation.Code
                                        else
                                            Error('FC location %1 not found in the system !', FCLocation);
                                        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                        PurchaseLineRcvd.Modify();
                                        // recPurchaseLine.validate("Qty. to Receive", recPurchaseLine.Quantity);
                                        // recPurchaseLine.validate("QC Action", recPurchaseLine."QC Action"::Inward);
                                        // recPurchaseLine.Modify();

                                        PurHeader1.Reset();
                                        PurHeader1.SetRange("Document Type", PurHeader1."Document Type"::Order);
                                        PurHeader1.SetRange("No.", recPurchHeader."No.");
                                        if PurHeader1.FindFirst() then begin
                                            PurHeader1.Validate(Status, PurHeader1.Status::Open);
                                            PurHeader1.Modify();
                                        end;

                                        if not PostShipment(recGRNStaging) then begin
                                            Message('%1', GetLastErrorText());
                                            cuFunctions.CreateErrorLog(5, '', recGRNStaging."Entry No.", '', recPurchaseLine."No.", recGRNStaging.po_number);
                                            recActionStatus.Processed := true;
                                            recActionStatus.Modify();
                                            Message('Inward not posted Status');
                                        end else begin
                                            recActionStatus.Processed := true;
                                            recActionStatus.Modify();
                                            Message('Inward posted Status');
                                        end;
                                    end;
                                    PurRecHdr.Reset();
                                    PurRecHdr.SetRange("Order No.", recPurchaseLine."Document No.");
                                    if PurRecHdr.FindSet() then
                                        repeat
                                            PurRecLine.Reset();
                                            PurRecLine.SetRange("Document No.", recPurchaseLine."No.");
                                            PurRecLine.SetRange(Type, recPurchaseLine.Type::Item);
                                            PurRecLine.SetRange("No.", recPurchaseLine."No.");
                                            if PurRecLine.FindFirst() then begin
                                                PurRecLine."QC Action" := PurRecLine."QC Action"::Inward;
                                                PurRecLine.Modify();
                                            end;
                                        until PurRecHdr.Next() = 0;
                                end;
                            2:
                                begin
                                    recPurchaseLine.validate("QC Action", recPurchaseLine."QC Action"::"QC Pass");
                                    if recPurchaseLine.Modify() then begin
                                        recActionStatus.Processed := true;
                                        recActionStatus.Modify();
                                    end;
                                    Message('QC Pass Status');
                                    PurRecHdr.Reset();
                                    PurRecHdr.SetRange("Order No.", recPurchaseLine."Document No.");
                                    if PurRecHdr.FindSet() then
                                        repeat
                                            PurRecLine.Reset();
                                            PurRecLine.SetRange("Document No.", recPurchaseLine."No.");
                                            PurRecLine.SetRange(Type, recPurchaseLine.Type::Item);
                                            PurRecLine.SetRange("No.", recPurchaseLine."No.");
                                            if PurRecLine.FindFirst() then begin
                                                PurRecLine."QC Action" := PurRecLine."QC Action"::"QC Pass";
                                                PurRecLine.Modify();
                                            end;
                                        until PurRecHdr.Next() = 0;
                                end;
                            3:
                                begin
                                    recPurchaseLine.validate("QC Action", recPurchaseLine."QC Action"::"QC Fail");
                                    if recPurchaseLine.Modify() then begin
                                        recActionStatus.Processed := true;
                                        recActionStatus.Modify();
                                    end;
                                    Message('QC fail status');
                                    PurRecHdr.Reset();
                                    PurRecHdr.SetRange("Order No.", recPurchaseLine."Document No.");
                                    if PurRecHdr.FindSet() then
                                        repeat
                                            PurRecLine.Reset();
                                            PurRecLine.SetRange("Document No.", recPurchaseLine."No.");
                                            PurRecLine.SetRange(Type, recPurchaseLine.Type::Item);
                                            PurRecLine.SetRange("No.", recPurchaseLine."No.");
                                            if PurRecLine.FindFirst() then begin
                                                PurRecLine."QC Action" := PurRecLine."QC Action"::"QC Fail";
                                                PurRecLine.Modify();
                                            end;
                                        until PurRecHdr.Next() = 0;
                                    // PurInvHdr.Reset();
                                    // PurInvHdr.SetRange("Order No.", recPurchaseLine."Document No.");
                                    // if PurInvHdr.FindSet() then
                                    //     repeat
                                    //         PurInvLine.Reset();
                                    //         PurInvLine.SetRange("Document No.", recPurchaseLine."No.");
                                    //         PurInvLine.SetRange(Type, recPurchaseLine.Type::Item);
                                    //         PurInvLine.SetRange("No.", recPurchaseLine."No.");
                                    //         if PurInvLine.FindFirst() then begin
                                    //             PurInvLine."QC Action" := PurInvLine."QC Action"::"QC Fail";
                                    //             PurInvLine.Modify();
                                    //         end;
                                    //     until PurInvHdr.Next() = 0;
                                end;
                            5:
                                begin
                                    recPurchaseLine.validate("QC Action", recPurchaseLine."QC Action"::Outward);
                                    if recPurchaseLine.Modify() then begin
                                        recActionStatus.Processed := true;
                                        recActionStatus.Modify();
                                        Message('Outward Status');
                                    end;
                                    PurRecHdr.Reset();
                                    PurRecHdr.SetRange("Order No.", recPurchaseLine."Document No.");
                                    if PurRecHdr.FindSet() then
                                        repeat
                                            PurRecLine.Reset();
                                            PurRecLine.SetRange("Document No.", recPurchaseLine."No.");
                                            PurRecLine.SetRange(Type, recPurchaseLine.Type::Item);
                                            PurRecLine.SetRange("No.", recPurchaseLine."No.");
                                            if PurRecLine.FindFirst() then begin
                                                PurRecLine."QC Action" := PurRecLine."QC Action"::Outward;
                                                PurRecLine.Modify();
                                            end;
                                        until PurRecHdr.Next() = 0;
                                end;
                            12:      //RTV Alteration
                                begin
                                    Clear(VendNo);
                                    Clear(ItemCost);
                                    Clear(LastVendor);
                                    if Item.Get(recPurchaseLine."No.") then begin
                                        VendNo := Item."Vendor No.";
                                        ItemCost := Item."Unit Cost";
                                    end;
                                    if VendNo <> LastVendor then begin
                                        PurPaybleSetup.Get();
                                        PurHeader.Init();
                                        PurHeader."Document Type" := PurHeader."Document Type"::"Return Order";
                                        PurHeader."No." := NOSeriesMgmt.GetNextNo(PurPaybleSetup."Return Order Nos.", Today, true);
                                        PurHeader.Validate("Buy-from Vendor No.", VendNo);
                                        PurHeader.Validate("RTV Reason", PurHeader."RTV Reason"::"For Alteration");
                                        PurHeader."Location Code" := 'ONL';//recPurchaseLine."Location Code";
                                        PurHeader.PoNoForRTV := recPurchHeader."No.";
                                        PurHeader."PO No." := recPurchHeader."No.";
                                        PurHeader."Document Date" := Today;
                                        if PurHeader.Insert() then begin
                                            Message('RTV %1 Created for Alteration', PurHeader."No.");
                                            recPurchaseLine.validate("QC Action", recPurchaseLine."QC Action"::"RTV Alteration");
                                            recPurchaseLine.Modify();
                                        end;
                                        LineNo := 10000;
                                        PurLine.Init();
                                        PurLine."Document Type" := PurHeader."Document Type";
                                        PurLine."Document No." := PurHeader."No.";
                                        PurLine."Line No." := LineNo;
                                        PurLine.Type := recPurchaseLine.Type;
                                        PurLine.Validate("No.", recPurchaseLine."No.");
                                        PurLine."Location Code" := recPurchaseLine."Location Code";
                                        PurLine.Validate("GST Group Code", '');
                                        PurLine."Unit Price (LCY)" := recPurchaseLine."Direct Unit Cost";
                                        PurLine.Validate(Quantity, recPurchaseLine.Quantity);
                                        //PurLine."Direct Unit Cost" := recPurchaseLine."Direct Unit Cost";
                                        PurLine.validate("Direct Unit Cost", recPurchaseLine."Direct Unit Cost");
                                        if PurLine.Insert() then begin
                                            // recActionStatus.Processed := true;
                                            // recActionStatus.Modify();
                                        end;
                                        LastVendor := VendNo;
                                        POOrderNo := PurHeader."No.";
                                    end else begin
                                        LineNo += 10000;
                                        PurLine.Init();
                                        PurLine."Document Type" := PurLine."Document Type"::"Return Order";
                                        PurLine."Document No." := POOrderNo;
                                        PurLine."Line No." := LineNo;
                                        PurLine.Type := recPurchaseLine.Type;
                                        PurLine.Validate("No.", recPurchaseLine."No.");
                                        // PurLine.Validate("Posting Date", Today);
                                        PurLine."Location Code" := recPurchaseLine."Location Code";
                                        // PurLine.Validate("Location Code", recPurchaseLine."Location Code");
                                        PurLine.Validate("GST Group Code", '');
                                        // PurLine."Unit Price (LCY)" := ItemCost;
                                        PurLine."Unit Price (LCY)" := recPurchaseLine."Direct Unit Cost";
                                        PurLine.Validate(Quantity, recPurchaseLine.Quantity);
                                        //PurLine."Direct Unit Cost" := recPurchaseLine."Direct Unit Cost";
                                        PurLine.validate("Direct Unit Cost", recPurchaseLine."Direct Unit Cost");
                                        if PurLine.Insert() then begin
                                            // recActionStatus.Processed := true;
                                            // recActionStatus.Modify();
                                        end;
                                    end;

                                    if not PostShipmentRTV(PurHeader) then begin
                                        Message('%1', GetLastErrorText());
                                        // recActionStatus.Processed := true;
                                        // recActionStatus.Modify();
                                        Message('RTV Alteration not Posted');
                                        cuFunctions.CreateErrorLog(5, '', recGRNStaging."Entry No.", '', recPurchaseLine."No.", recGRNStaging.po_number);
                                    end else begin
                                        recActionStatus.Processed := true;
                                        recActionStatus.Modify();
                                        Message('RTV Alteration Posted');
                                    end;

                                    // PurHeader1.Reset();
                                    // PurHeader1.SetRange("Document Type", PurHeader1."Document Type"::Order);
                                    // PurHeader1.SetRange("No.", recPurchHeader."No.");
                                    // if PurHeader1.FindFirst() then begin
                                    //     PurHeader1.Validate(Status, PurHeader1.Status::Open);
                                    //     PurHeader1.Modify();
                                    // end;
                                    // POReopenboo := true;
                                    PurRecHdr.Reset();
                                    PurRecHdr.SetRange("Order No.", recPurchaseLine."Document No.");
                                    if PurRecHdr.FindSet() then
                                        repeat
                                            PurRecLine.Reset();
                                            PurRecLine.SetRange("Document No.", recPurchaseLine."No.");
                                            PurRecLine.SetRange(Type, recPurchaseLine.Type::Item);
                                            PurRecLine.SetRange("No.", recPurchaseLine."No.");
                                            if PurRecLine.FindFirst() then begin
                                                PurRecLine."QC Action" := PurRecLine."QC Action"::"RTV Alteration";
                                                PurRecLine.Modify();
                                            end;
                                        until PurRecHdr.Next() = 0;
                                end;
                            13:      //RTV PERMANENT DONE
                                begin
                                    Clear(VendNo);
                                    Clear(ItemCost);
                                    if Item.Get(recPurchaseLine."No.") then begin
                                        VendNo := Item."Vendor No.";
                                        ItemCost := Item."Unit Cost";
                                    end;
                                    if VendNo <> LastVendor then begin
                                        PurPaybleSetup.Get();
                                        PurHeader.Init();
                                        PurHeader."Document Type" := PurHeader."Document Type"::"Return Order";
                                        PurHeader."No." := NOSeriesMgmt.GetNextNo(PurPaybleSetup."Return Order Nos.", Today, true);
                                        PurHeader.Validate("Buy-from Vendor No.", VendNo);
                                        PurHeader.Validate("RTV Reason", PurHeader."RTV Reason"::"Consignment Return");
                                        PurHeader."Location Code" := 'ONL';// recPurchaseLine."Location Code";
                                        PurHeader.PoNoForRTV := recPurchHeader."No.";
                                        PurHeader."PO No." := recPurchHeader."No.";
                                        PurHeader."Document Date" := Today;
                                        if PurHeader.Insert() then begin
                                            Message('RTV %1 Created for Permanent', PurHeader."No.");
                                            // recPurchaseLine.validate("QC Action", recPurchaseLine."QC Action"::;
                                            // recPurchaseLine.Modify();
                                        end;
                                        LineNo := 10000;
                                        PurLine.Init();
                                        PurLine."Document Type" := PurHeader."Document Type";
                                        PurLine."Document No." := PurHeader."No.";
                                        PurLine."Line No." := LineNo;
                                        PurLine.Type := recPurchaseLine.Type;
                                        PurLine.Validate("No.", recPurchaseLine."No.");
                                        PurLine."Location Code" := recPurchaseLine."Location Code";
                                        //PurLine.Validate("Location Code", recPurchaseLine."Location Code");
                                        // PurLine.Validate("Posting Date", Today);
                                        PurLine.Validate("GST Group Code", '');
                                        PurLine."Unit Price (LCY)" := recPurchaseLine."Direct Unit Cost";
                                        PurLine.Validate(Quantity, recPurchaseLine.Quantity);
                                        PurLine.validate("Direct Unit Cost", recPurchaseLine."Direct Unit Cost");
                                        if PurLine.Insert() then begin
                                            recActionStatus.Processed := true;
                                            recActionStatus.Modify();
                                            // Message('RTV PERMANENT STATUS');
                                        end;
                                        LastVendor := VendNo;
                                        POOrderNo := PurHeader."No.";
                                    end else begin
                                        LineNo += 10000;
                                        PurLine.Init();
                                        PurLine."Document Type" := PurLine."Document Type"::"Return Order";
                                        PurLine."Document No." := POOrderNo;
                                        PurLine."Line No." := LineNo;
                                        PurLine.Type := recPurchaseLine.Type;
                                        PurLine.Validate("No.", recPurchaseLine."No.");
                                        PurLine."Location Code" := recPurchaseLine."Location Code";
                                        // PurLine.Validate("Location Code", recPurchaseLine."Location Code");
                                        // PurLine.Validate("Posting Date", Today);
                                        PurLine.Validate("GST Group Code", '');
                                        //PurLine."Unit Price (LCY)" := ItemCost;
                                        PurLine."Unit Price (LCY)" := recPurchaseLine."Direct Unit Cost";
                                        PurLine.Validate(Quantity, recPurchaseLine.Quantity);
                                        PurLine.validate("Direct Unit Cost", recPurchaseLine."Direct Unit Cost");
                                        if PurLine.Insert() then begin
                                            recActionStatus.Processed := true;
                                            recActionStatus.Modify();
                                        end;
                                    end;

                                    if not PostShipmentRTV(PurHeader) then begin
                                        Message('%1', GetLastErrorText());
                                        Message('RTV Permanent not Posted');
                                        recActionStatus.Processed := true;
                                        recActionStatus.Modify();
                                        cuFunctions.CreateErrorLog(5, '', recGRNStaging."Entry No.", '', recPurchaseLine."No.", recGRNStaging.po_number);
                                    end else begin
                                        recActionStatus.Processed := true;
                                        recActionStatus.Modify();
                                        Message('RTV Permanent Posted');
                                    end;

                                end;
                        end;
                        // until recPurchaseLine.Next() = 0;
                    end;
                end;
            until recActionStatus.Next() = 0;
        end else begin
            recGRNStaging."Record Status" := recGRNStaging."Record Status"::Processed;
            recGRNStaging.Modify();
        end;
    end;


    var
        myInt: Integer;
        glDocNum: Code[40];
        glLastVend: code[30];

    var
        CreatePO2: Codeunit CreatePO2;
        boolHandle: Boolean;

        glPurchDocNum: Code[50];
        glLastLOcation: Code[30];
        glPOType: code[30];
        glinwardDone: Boolean;
        POReopenboo: Boolean;
        glDocType: Text[10];
        cuPurchPost: Codeunit "Purch.-Post";
        item1: Record Item;


    // end;
}