

codeunit 50105 "Custom Events"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Page, Page::"LSC Retail Item Card", 'OnAfterGetCurrRecordEvent', '', false, false)]
    procedure InitializeRetailImage(Rec: Record Item)
    var
        pgRetailItemCardPart: Page RetilCard_ItemPart;
        CurrPage: Page "LSC Retail Item Card";
        cuPosTransaction: codeunit 99001570;

    begin
        pgRetailItemCardPart.SetActiveImage(Rec.RecordId);
        pgRetailItemCardPart.Update(false);
        // CurrPage.RetilCard_ItemPart.Page.SetActiveImage(Rec.RecordId);

        // pgRetailItemCard.RetailItemCard_Ext.PAGE.SetActiveImage(Rec.RecordId);
        // pgRetailItemCard.Re
        // SetActiveImage1(Rec.RecordId);
    end;

    //[EventSubscriber(ObjectType::Table, Database::"LSC Pos Trans. Line", 'OnBeforeInsertEvent', '', false, false)]
    //Not in use
    /*local procedure IncreaseLineNo_Insert(Rec: Record 99008981)
    var
        recPosHeader: Record "LSC POS Transaction";
        intLineNum: Integer;
        recPosLine: Record 99008981;
    begin
        recPosHeader.Get(Rec."Receipt No.");
        if Rec."Customer Order Line" then begin
            // if recPosHeader."Customer Order ID" <> %'' then begin
            recPosLine.Reset();
            recPosLine.SetRange("Receipt No.", Rec."Receipt No.");
            recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
            if recPosLine.FindLast() then
                intLineNum := recPosLine."Line No." - (recPosLine."Line No." mod 10000);

            if Rec."Entry Type" = Rec."Entry Type"::IncomeExpense then begin
                Rec."Line No." := intLineNum + 10000;
            end;
        end;

    end;

    //[EventSubscriber(ObjectType::Table, Database::"LSC Pos Trans. Line", 'OnBeforeModifyEvent', '', false, false)]
    
    local procedure IncreaseLineNo_Modify(Rec: Record 99008981)
    var
        recPosHeader: Record "LSC POS Transaction";
        intLineNum: Integer;
        recPosLine: Record 99008981;
    begin
        recPosHeader.Get(Rec."Receipt No.");
        if Rec."Customer Order Line" then begin
            // if recPosHeader."Customer Order ID" <> %'' then begin
            recPosLine.Reset();
            recPosLine.SetRange("Receipt No.", Rec."Receipt No.");
            recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
            if recPosLine.FindLast() then
                intLineNum := recPosLine."Line No." - (recPosLine."Line No." mod 10000);

            if Rec."Entry Type" = Rec."Entry Type"::IncomeExpense then begin
                Rec."Line No." := intLineNum + 10000;
            end;
        end;

    end;*/

    // procedure OnAfterVoidPostedTransaction(var Rec: Record "LSC POS Transaction")
    /*Not in use
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnAfterVoidPostedTransaction', '', false, false)]
    procedure GSTCustomerType_RefundTransaction(var Rec: Record "LSC POS Transaction")
    var
        recTransactionHeader: Record 99001472;
        recPosHeader: Record "LSC POS Transaction";
    begin
        recTransactionHeader.Reset();
        recTransactionHeader.SetRange("Store No.", Rec."Store No.");
        recTransactionHeader.SetRange("POS Terminal No.", Rec."POS Terminal No.");
        recTransactionHeader.setrange("Retrieved from Receipt No.", Rec."Retrieved from Receipt No.");
        if recTransactionHeader.FindFirst() then begin
            recPosHeader.get(Rec."Receipt No.");
            recPosHeader."LSCIN GST Customer Type" := recTransactionHeader."LSCIN GST Customer Type";
            recPosHeader.Modify();
        end;

    end;*/

    // local procedure OnAfterCustomerRecInsert(var lCustomerRec: Record Customer)
    //CITS_RS 290523
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Create New Customer", 'OnAfterCustomerRecInsert', '', false, false)]
    procedure UpdateGSTValuesInPosCustomer(var lCustomerRec: Record Customer)
    var
        cuPosTransLine: Codeunit 99001570;
        recCustomer: Record 18;
        recStore: record 99001470;
        recHeader: record "LSC POS Transaction";
    begin
        recHeader.get(cuPosTransLine.GetReceiptNo());
        recStore.Get(recHeader."Store No.");
        recCustomer.get(lCustomerRec."No.");
        recCustomer.Address := 'POS Address';
        recCustomer.validate("Country/Region Code", 'IN');//Hardcoding India for Test transactions
        recCustomer.validate("State Code", recStore."LSCIN State Code");
        recCustomer.validate("GST Customer Type", recCustomer."GST Customer Type"::Unregistered);
        recCustomer.Modify();

    end;

    // OnAfterInsertTransHeader(var Transaction: Record "LSC Transaction Header"; var POSTrans: Record "LSC POS Transaction");
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterInsertTransHeader', '', false, false)]
    procedure PopulatePhoneNumberinPostedTrans(var Transaction: Record "LSC Transaction Header"; var POSTrans: Record "LSC POS Transaction");
    var
    begin
        Transaction."Cust. Phone No." := POSTrans."Cust. Phone No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterInsertTransactionsProcessTransactionsV2', '', false, false)]
    // OnAfterInsertTransactionsProcessTransactionsV2(var TransactionHeader: Record "LSC Transaction Header"; var TransSalesEntryTemp: Record "LSC Trans. Sales Entry" temporary; PaymentEntryTemp: Record "LSC Trans. Payment Entry" temporary)
    procedure RemoveTOReferencefromCustOrder(var TransactionHeader: Record "LSC Transaction Header"; var TransSalesEntryTemp: Record "LSC Trans. Sales Entry" temporary; PaymentEntryTemp: Record "LSC Trans. Payment Entry" temporary)
    var
        recCustomer: Record 18;
        recCustomerOrderLine: Record "LSC Customer Order Line";
        recCustomerOrderHeader: Record "LSC Customer Order Header";
        recHeader: Record "LSC POS Transaction";
        recILE: Record 32;
        arrItemCode: array[999] of Text;
        x: Integer;
        y: integer;
        arrInventory: array[999] of integer;
        recItem: Record 27;
        recItemJnlLine: Record 83;
        printUtil: Codeunit 99008903;
        cuItemJnlPost: Codeunit 22;
        cdBatch: Code[30];
        cuPOCreation: Codeunit PO_CreationfromStaging;
        cdJournalTemp: Code[30];
        docStr: Text;
        recItem1: record 27;
        j: Integer;
        intLineNum: Integer;
        recAzaItemStage: Record Aza_Item;
        recPurchaseHeader: Record 38;
        lineCreated: Boolean;
        purchHeaderFound: Boolean;
        recTransSaleEn: record 99001473;
        recStore: Record 99001470;
        recCustOrderPmt: Record "LSC Customer Order Payment";
        decPmtAmt: Decimal;
        i: Integer;
        recTransSalesEntry: Record 99001473;
        recRetailSetup: Record "LSC Retail Setup";
        arrItem: array[999] of code[20];
        arrLineNum: array[999] of Integer;
    begin
        x := 1;
        y := 1;
        Clear(i);
        Clear(purchHeaderFound);
        Clear(arrItemCode);
        recRetailSetup.Get();
        recStore.Get(TransactionHeader."Store No.");
        if recCustomerOrderHeader.Get(TransactionHeader."Customer Order ID") then begin

            recCustomerOrderHeader."Transfer Orders" := 0;
            recCustomerOrderHeader.Modify();
            recCustomerOrderLine.Reset();
            recCustomerOrderLine.SetRange("Document ID", recCustomerOrderHeader."Document ID");
            recCustomerOrderLine.SetFilter("Line Type", '=%1|%2', recCustomerOrderLine."Line Type"::Item, recCustomerOrderLine."Line Type"::IncomeExpense);
            recCustomerOrderLine.SetRange("Inventory Transfer", true);//230223 CITS_RS
            recCustomerOrderLine.SetRange("Ship Order", false);//230223 CITS_RS
            if recCustomerOrderLine.Find('-') then begin
                repeat
                    if recCustomerOrderLine."Line Type" = recCustomerOrderLine."Line Type"::Item then begin//PO Creation in Customer Order
                        recAzaItemStage.Reset();
                        recAzaItemStage.SetRange(bar_code, recCustomerOrderLine.Number);
                        recAzaItemStage.SetFilter(type_of_inventory, '<>%1|%2', 'CON-CONSIGNMENT', 'OR-OUTRIGHT');
                        // recAzaItemStage.SetFilter(po_type, '<>%1|%2', recAzaItemStage.po_type::"C0-Customer Order", recAzaItemStage.po_type::"OR-Outright");//060423 as per manas sir
                        recAzaItemStage.SetFilter("Record Status", '=%1|%2', recAzaItemStage."Record Status"::Created, recAzaItemStage."Record Status"::Updated);
                        recAzaItemStage.SetRange(Is_Outward, false);
                        if recAzaItemStage.FindFirst() then begin
                            i += 1;
                            arrItem[i] := recAzaItemStage.bar_code;
                        end;
                        // cuPOCreation.CreatePO2(recAzaItemStage);

                    end;
                    if recCustomerOrderLine."Line Type" = recCustomerOrderLine."Line Type"::Item then begin
                        recItem.get(recCustomerOrderLine.Number);
                        recItem.ItemSaleReserved := true;//100623
                        recItem."Customer No." := TransactionHeader."Customer No.";//100623
                        recItem."Customer Order ID" := recCustomerOrderHeader."Document ID";
                        recItem.Modify();
                        if recPurchaseHeader.get(1, recItem."PO No.") then begin
                            recPurchaseHeader."Customer Order ID" := recCustomerOrderLine."Document ID";
                            purchHeaderFound := true;
                        end;
                    end;
                    recCustomerOrderLine."Inventory Transfer" := false;
                    recCustomerOrderLine."Store No." := TransactionHeader."Store No.";
                    recCustomerOrderLine."Sourcing Location" := TransactionHeader."Store No.";
                    arrItemCode[x] := recCustomerOrderLine.Number;
                    recCustomerOrderLine.Modify();
                    x += 1;
                until recCustomerOrderLine.Next() = 0;
            end else begin//for items with positive inventory 060723 CITS_RS
                recCustomerOrderLine.Reset();
                recCustomerOrderLine.SetRange("Document ID", recCustomerOrderHeader."Document ID");
                recCustomerOrderLine.SetFilter("Line Type", '=%1', recCustomerOrderLine."Line Type"::Item);
                if recCustomerOrderLine.Find('-') then
                    repeat
                        if recCustomerOrderLine.Status in [recCustomerOrderLine.Status::"To Pick", recCustomerOrderLine.Status::"To Collect"] then begin
                            recItem.get(recCustomerOrderLine.Number);
                            recItem.ItemSaleReserved := true;//100623
                            recItem."Customer No." := TransactionHeader."Customer No.";//100623
                            recItem."Customer Order ID" := recCustomerOrderHeader."Document ID";
                            recItem.Modify();
                            if recPurchaseHeader.get(1, recItem."PO No.") then begin
                                recPurchaseHeader."Customer Order ID" := recCustomerOrderLine."Document ID";
                                purchHeaderFound := true;
                            end;
                        end;
                    until recCustomerOrderLine.Next() = 0;
            end;

            //CITS_RS 270223 Negative adjustment in dummy Location on Customer Order Post
            if x > 1 then begin
                while y <= x do begin
                    recILE.Reset();
                    recILE.SetRange("Item No.", arrItemCode[y]);
                    recILE.SetRange("Location Code", recStore."Dummy Location");
                    recILE.SetFilter("Remaining Quantity", '>%1', 0);
                    if recILE.Find('-') then begin
                        recItem.Get(recILE."Item No.");
                        docStr := CreateItemJnlLine(recItem, TransactionHeader."Store No.", 'negative');
                        cdBatch := SelectStr(1, docStr);
                        cdJournalTemp := SelectStr(2, docStr);
                        evaluate(intLineNum, SelectStr(3, docStr));
                        recItemJnlLine.get(cdJournalTemp, cdBatch, intLineNum);
                        cuItemJnlPost.Run(recItemJnlLine);
                    end;
                    y += 1;
                end;
                Commit();
            end;
            recCustomerOrderHeader.CalcFields("Pre Approved Amount LCY");
            if recCustomerOrderHeader."Pre Approved Amount LCY" < GetCustOrderTotalAmount_Uncollected(recCustomerOrderHeader) then begin
                recCustomerOrderHeader."Partial Payment" := true;
                recCustomerOrderHeader.Modify();
                if purchHeaderFound then
                    recPurchaseHeader."Partial Payment" := true;
            end;
            if purchHeaderFound then
                recPurchaseHeader.Modify();
            if i > 0 then begin
                j := 1;
                while j <= i do begin//create Purchase order on customer order creation
                    recAzaItemStage.Reset();
                    recAzaItemStage.SetRange(bar_code, arrItem[j]);
                    recAzaItemStage.SetFilter(type_of_inventory, '<>%1|%2', 'CON-CONSIGNMENT', 'OR-OUTRIGHT');//060423 as per manas sir
                    recAzaItemStage.SetFilter("Record Status", '=%1|%2', recAzaItemStage."Record Status"::Created, recAzaItemStage."Record Status"::Updated);
                    recAzaItemStage.SetRange(Is_Outward, false);
                    if recAzaItemStage.FindFirst() then begin
                        recItem1.Get(recAzaItemStage.bar_code);
                        if recItem1."PO No." = '' then//060423 IF po already created then exclude.
                            cuPOCreation.CreatePO2_CO(recAzaItemStage, TransactionHeader."Customer Order ID");
                    end;
                    j += 1;
                end;
            end;
            // if recRetailSetup."Remove Misc. Pmt. Lines" then
            //     RemoveMiscPmtLines(TransactionHeader);//CITS_RS 150723
        end;
    end;

    /*
    procedure RemoveMiscPmtLines(TransactionHeader: Record 99001472)
    var
        recTransSaleEn: record 99001473;
        arrLineNum: array[999] of Integer;
        i: integer;
        recCustOrderPmt: Record "LSC Customer Order Payment";
        decPmtAmtHeader: Decimal;
        decCustOrderPmt: decimal;
        y: Integer;
    begin
        Clear(decCustOrderPmt);
        if TransactionHeader.Payment > 0 then begin
            recTransSaleEn.Reset();
            recTransSaleEn.SetRange("Store No.", TransactionHeader."Store No.");
            recTransSaleEn.SetRange("POS Terminal No.", TransactionHeader."POS Terminal No.");
            recTransSaleEn.SetRange("Transaction No.", TransactionHeader."Transaction No.");
            if not recTransSaleEn.FindFirst() then begin//customer order creation transaction
                recCustOrderPmt.Reset();
                recCustOrderPmt.SetRange("Document ID", TransactionHeader."Customer Order ID");
                recCustOrderPmt.SetRange(Type, recCustOrderPmt.Type::Payment);
                if recCustOrderPmt.Find('-') then begin
                    i := 0;
                    repeat
                        decCustOrderPmt += recCustOrderPmt."Pre Approved Amount LCY";
                        if decCustOrderPmt > TransactionHeader.Payment then begin
                            i += 1;
                            arrLineNum[i] := recCustOrderPmt."Line No.";
                        end;
                    // end;
                    until recCustOrderPmt.Next() = 0;
                end;
                y := 1;
                while y <= i do begin
                    recCustOrderPmt.Reset();
                    recCustOrderPmt.SetRange("Document ID", TransactionHeader."Customer Order ID");
                    recCustOrderPmt.SetRange(Type, recCustOrderPmt.Type::Payment);
                    recCustOrderPmt.SetRange("Line No.", arrLineNum[y]);
                    if recCustOrderPmt.FindFirst() then
                        recCustOrderPmt.Delete();
                    y += 1;
                end;
            end;
        end;
    end;
    */

    //  OnAfterPostTransaction(var TransactionHeader_p: Record "LSC Transaction Header")
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Post Utility", 'OnAfterPostTransaction', '', false, false)]
    //Not in use
    /*procedure MarkPartialPayment(var TransactionHeader_p: Record "LSC Transaction Header")
    var
        recCustomerOrderLine: Record "LSC Customer Order Line";
        recCustomerOrderHeader: Record "LSC Customer Order Header";
        recPurchaseHeader: Record 38;
        recItem: Record 27;
    begin
        if recCustomerOrderHeader.Get(TransactionHeader_p."Customer Order ID") then begin
            if recCustomerOrderHeader."Pre Approved Amount" < GetCustOrderTotalAmount(recCustomerOrderHeader) then begin
                recCustomerOrderHeader."Partial Payment" := true;
                recCustomerOrderHeader.Modify();
                recCustomerOrderLine.Reset();
                recCustomerOrderLine.SetRange("Document ID", recCustomerOrderHeader."Document ID");
                recCustomerOrderLine.SetRange("Line Type", recCustomerOrderLine."Line Type"::Item);
                recCustomerOrderLine.SetRange(Status, recCustomerOrderLine.Status::"To Pick");
                if recCustomerOrderLine.Find('-') then begin
                    recItem.get(recCustomerOrderLine.Number);
                    if recPurchaseHeader.get(1, recItem."PO No.") then begin
                        recPurchaseHeader."Partial Payment" := true;
                        recPurchaseHeader.Modify();
                    end;
                end;
            end;
        end;
    end;*/

    // OnAfterTenderKeyPressedEx(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var TenderTypeCode: Code[10]; var TenderAmountText: Text; var IsHandled: Boolean)
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnAfterTenderKeyPressedEx', '', false, false)]
    // procedure MapPaymentTenderinCO()
    // var
    // begin

    // end;


    procedure GetCustOrderTotalAmount_Uncollected(custOrderHeader: Record "LSC Customer Order Header"): Decimal
    var
        recCustOrderLine: Record "LSC Customer Order Line";
        decAmt: Decimal;
        recItem: Record 27;
    begin
        Clear(decAmt);
        recCustOrderLine.Reset();
        recCustOrderLine.SetRange("Document ID", custOrderHeader."Document ID");
        recCustOrderLine.SetFilter("Line Type", '=%1|%2', recCustOrderLine."Line Type"::Item, recCustOrderLine."Line Type"::IncomeExpense);
        // recCustOrderLine.setfilter(Status, '<>%1|%2|%3', recCustOrderLine.Status::Canceled, recCustOrderLine.Status::Rejected, recCustOrderLine.Status::Shortage);
        // recCustOrderLine.SetFilter(Status, '=%1|%2', recCustOrderLine.Status::"To Collect", recCustOrderLine.Status::"To Pick");
        if recCustOrderLine.Find('-') then
            repeat

                if recCustOrderLine.Status in [recCustOrderLine.Status::"To Collect", recCustOrderLine.Status::"To Pick"] then
                    decAmt += recCustOrderLine.Amount;
            // recItem.get(recCustOrderLine.Number);                    
            until recCustOrderLine.Next() = 0;
        exit(decAmt);
    end;

    // [EventSubscriber(ObjectType::Table, Database::"LSC POS Trans. Line", 'OnAfterValidateEvent', 'Number', false, false)]
    procedure OnAfterValidatePosNumber(var Rec: record "LSC POS Trans. Line")
    var
        recItem: record 27;
        recVendor: Record Vendor;
    begin
        if Rec."Entry Status" = Rec."Entry Status"::" " then
            if Rec."Entry Type" = Rec."Entry Type"::Item then begin
                recItem.get(Rec.Number);
                recVendor.get(recItem.designerID);
                Rec."Designer Name" := recVendor.Name;
                Rec.Modify(false);
            end;
    end;

    // procedure OnAfterRunCommand(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var Command: Code[20]; var POSMenuLine: Record "LSC POS Menu Line")
    // procedure OnBeforeRunCommand(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var POSMenuLine: Record "LSC POS Menu Line"; var isHandled: Boolean)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeRunCommand', '', false, false)]
    procedure MarkallItemCustomerOrder(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var POSMenuLine: Record "LSC POS Menu Line"; var isHandled: Boolean)
    var
        cuFunctions: Codeunit Functions;
    begin
        IF POSMenuLine.Command = 'MARK' then
            IF POSMenuLine.Parameter = 'MARKALLCUSTORDER' then begin
                cuFunctions.MarkAllAsCustomerOrder(POSTransaction);
                isHandled := true;
            end;

    end;

    // OnBeforeTotalExecuted(var POSTransaction: Record "LSC POS Transaction"; var IsHandled: Boolean)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnAfterTotalExecuted', '', false, false)]
    local procedure UpdateALterationAmountFIN(var POSTransaction: Record "LSC POS Transaction")//; var IsHandled: Boolean)
    var
        decGSTPer: Decimal;
        recIncExpAccount: Record 99001476;
        POSTransLine: Record 99008981;
        recGLAccount: Record "G/L Account";
        recTransactionHeader: Record 99001472;
        //recPosHeader: Record "LSC POS Transaction";
        recStore: record 99001470;
        decActualAmt: Decimal;
        recCustomer: Record 18;
        decNewPrice: Decimal;
        cdGSTGroup: Code[10];
        decGSTAmt: Decimal;
    begin
        // recStore.get(POSTransaction."Store No.");
        // if recCustomer.get(POSTransaction."Customer No.") then begin
        //     if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
        //         POSTransaction.validate("LSCIN State", recStore."LSCIN State Code");
        //         //recPosHeader.Get(POSTransaction."Receipt No.");
        //         //recPosHeader.validate("LSCIN State", recStore."LSCIN State Code");
        //         //recPosHeader.Modify(false);//310523 added false as param
        //     end;
        // end;


        POSTransLine.Reset();
        POSTransLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
        POSTransLine.SetRange("Entry Status", POSTransLine."Entry Status"::" ");
        POSTransLine.SetRange("Entry Type", POSTransLine."Entry Type"::IncomeExpense);
        if POSTransLine.FindFirst() then begin
            if POSTransLine."CO Prepayment Line" then exit;
            Clear(decGSTPer);
            // recStore.Get(POSTransaction."Store No.");
            if not recIncExpAccount.Get(POSTransLine."Store No.", POSTransLine.Number) then exit;
            if not recIncExpAccount."Alteration Account" then exit;//300323
            recGLAccount.Reset();
            recGLAccount.SetRange("No.", recIncExpAccount."G/L Account");
            if recGLAccount.FindFirst() then
                cdGSTGroup := recGLAccount."GST Group Code";

            case cdGSTGroup of
                'GST 12G':
                    begin
                        decGSTPer := 12
                    end;
                'GST 18G':
                    begin
                        decGSTPer := 18
                    end;
                'GST 28G':
                    begin
                        decGSTPer := 28
                    end;
                'GST 3G':
                    begin
                        decGSTPer := 3
                    end;
                'GST 5G':
                    begin
                        decGSTPer := 5
                    end;
            end;
            if (POSTransLine."Entry Type" = POSTransLine."Entry Type"::IncomeExpense) and
             (POSTransLine."Entry Status" = POSTransLine."Entry Status"::" ") and (POSTransLine.Number = recIncExpAccount."No.") then begin
                decActualAmt := POSTransLine.Price;

                // Original Cost – (Original Cost * (100 / (100 + GST% ) ) )
                // decGSTAmt := POSTransLine.Price - (POSTransLine.Price * (100 / (100 + decGSTPer)));
                decGSTAmt := POSTransLine.Price - (POSTransLine.Price * (100 / (100 + 12)));
                decGSTAmt := Round(decGSTAmt, 0.01, '=');
                // decAmount := POSTransLine.Price;
                // decAmount := decAmount - ((decAmount * decGSTPer) / 100);
                decNewPrice := POSTransLine.Price - decGSTAmt;
                decNewPrice := Round(decNewPrice, 0.01, '=');
                // if decActualAmt <= decNewPrice then begin
                //     POSTransLine.Validate("Net Price", (decNewPrice + decGSTAmt));
                //     POSTransLine.Validate(Amount, (decNewPrice + decGSTAmt));
                // end else begin
                // POSTransLine.Validate("Net Price", decNewPrice);
                // POSTransLine.Validate("Net Amount", decNewPrice);
                // POSTransLine.Validate(Amount, PosTransLine.Price);
                POSTransLine."LSCIN Price Inclusive of Tax" := true;
                POSTransLine.Price := PosTransLine.Price;
                POSTransLine."Net Price" := decNewPrice;
                POSTransLine."Net Amount" := decNewPrice;
                POSTransLine.Amount := decActualAmt;
                POSTransLine.Quantity := 1;
                // POSTransLine.Validate("LSCIN GST Group Type", POSTransLine."LSCIN GST Group Type"::Service);
                // POSTransLine.Validate("LSCIN GST Group Code", cdGSTGroup);
                // POSTransLine.Validate("LSCIN GST Amount",decGSTAmt);
                POSTransLine."LSCIN GST Group Type" := POSTransLine."LSCIN GST Group Type"::Service;
                POSTransLine."LSCIN GST Group Code" := 'GST 12G';
                POSTransLine."LSCIN GST Amount" := decGSTAmt;
                POSTransLine.Modify(false);
            end;
        end;
        if POSTransaction."Sale Is Return Sale" then begin//CITS_RS 210423 updating GST Customer type for retrieved transactions.
            recTransactionHeader.Reset();
            recTransactionHeader.SetRange("Store No.", POSTransaction."Store No.");
            recTransactionHeader.SetRange("POS Terminal No.", POSTransaction."POS Terminal No.");
            recTransactionHeader.setrange("Receipt No.", POSTransaction."Retrieved from Receipt No.");
            if recTransactionHeader.FindFirst() then begin
                /* recPosHeader.get(POSTransaction."Receipt No.");
                recPosHeader."LSCIN GST Customer Type" := recTransactionHeader."LSCIN GST Customer Type";
                recPosHeader.Modify(false); *///310523 added false as param
                POSTransaction."LSCIN GST Customer Type" := recTransactionHeader."LSCIN GST Customer Type";
                POSTransaction.Modify();//KKS POS Transaction Error
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeTotalExecuted', '', false, false)]
    procedure AddItemInventory_ChecksalesStaff(var POSTransaction: Record "LSC POS Transaction"; var IsHandled: Boolean)
    var
        CUPOSTrans: Codeunit "LSC POS Transaction";
        recCustomer: Record 18;
        recItem: Record 27;
        recItemJnlLine: Record 83;
        recStore: Record 99001470;
        //recPosHeader: Record "LSC POS Transaction";
        recPosLine: Record 99008981;
        cuItemJnlPost: Codeunit 22;
        lineCreated: Boolean;
        cdBatch: Code[30];
        cdJournalTemp: Code[30];
        intLineNum: Integer;
        docStr: Text;
    begin
        if (POSTransaction."Customer No." = '') and
         (not POSTransaction."Customer Order Deposit") and (POSTransaction."Customer Order ID" = '') then begin
            //Error('Please assign a customer !');

            CUPOSTrans.PosMessage('Please assign a customer !');
            IsHandled := true;
            Exit;
        end;


        //140623 REC is modified when Sales Staff is assigned, using that modify to change the State
        // in case of unregstered customers
        if POSTransaction."Customer No." <> '' then
            if recCustomer.get(POSTransaction."Customer No.") then
                if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
                    recPosLine.Reset();
                    recPosLine.setrange("Receipt No.", POSTransaction."Receipt No.");
                    recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::FreeText);
                    if recPosLine.FindFirst() then begin
                        if StrPos(recPosLine.Description, 'Cust:') > 0 then
                            if recPosLine."Sales Staff" = '' then begin
                                //Error('Please assign Sales Staff on Customer Line');
                                CUPOSTrans.PosMessage('Please assign Sales Staff on Customer Line');
                                IsHandled := true;
                                Exit;
                            end;
                    end;
                end;

        // //CITS_RS 300523 If customer is unregistered then same state as store will be assigned as store location.
        // recStore.get(POSTransaction."Store No.");
        // recCustomer.get(POSTransaction."Customer No.");
        // if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
        //     recPosHeader.Get(POSTransaction."Receipt No.");
        //     recPosHeader.validate("LSCIN State", recStore."LSCIN State Code");
        //     recPosHeader.Modify(false);//310523 added false as param
        // end;

        //merged 280223 CITS_RS
        recPosLine.Reset();
        recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
        recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item);
        recPosLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
        // recPosLine.SetFilter("Sales Staff",'=%1','');
        if recPosLine.Find('-') then
            repeat
                if recPosLine."Sales Staff" = '' then begin
                    //Error('Please assign sales staff on line %1', recPosLine."Line No." / 10000);
                    CUPOSTrans.PosMessage(StrSubstNo('Please assign sales staff on line %1', recPosLine."Line No." / 10000));
                    IsHandled := true;
                    Exit;
                end;
            until recPosLine.Next() = 0;

        Clear(lineCreated);
        //recPosHeader.Get(POSTransaction."Receipt No.");
        if POSTransaction."Customer Order" and (not POSTransaction."Sale Is Return Sale") then begin
            recPosLine.Reset();
            recPosLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
            recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
            recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item);
            if recPosLine.Find('-') then begin
                repeat
                    recItem.Get(recPosLine.Number);
                    recItem.CalcFields(Inventory);
                    if recItem.Inventory < 1 then begin
                        docStr := CreateItemJnlLine(recItem, POSTransaction."Store No.", 'positive');
                        cdBatch := SelectStr(1, docStr);
                        cdJournalTemp := SelectStr(2, docStr);
                        evaluate(intLineNum, SelectStr(3, docStr));
                        recItemJnlLine.get(cdJournalTemp, cdBatch, intLineNum);
                        cuItemJnlPost.Run(recItemJnlLine);
                        lineCreated := true;
                    end;
                until recPosLine.Next() = 0;
            end;
        end;

        if lineCreated then
            Commit();

    end;

    // OnBeforePostItem(var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean; CalledFromAdjustment: Boolean)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnItemQtyPostingOnBeforeApplyItemLedgEntry', '', false, false)]
    // OnItemQtyPostingOnBeforeApplyItemLedgEntry(var ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry")
    procedure InsertItemDescILE(var ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        recItem: Record 27;
    begin
        recItem.Get(ItemJournalLine."Item No.");
        ItemJournalLine.Description := recItem.Description;
        // ItemLedgerEntry.Description := recItem.Description;
    end;

    // OnBeforeRunCommand(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var POSMenuLine: Record "LSC POS Menu Line"; var isHandled: Boolean)
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnBeforeRunCommand', '', false, false)]//commented for demo CITS_RS 020323
    procedure ChangeSourcingLocation_CO(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var POSMenuLine: Record "LSC POS Menu Line"; var isHandled: Boolean)
    var
        recCustomerOrderHeader: record "LSC Customer Order Header";
        recCustomerOrderLine: record "LSC Customer Order Line";
        recPosLine: record 99008981;

    begin
        if POSMenuLine.Command = 'CHANGESOLOC' then begin
            if POSTransaction."Customer Order" then begin
                if recCustomerOrderHeader.Get(POSTransaction."Customer Order ID") then begin
                    recCustomerOrderLine.Reset();
                    recCustomerOrderLine.SetRange("Document ID", recCustomerOrderHeader."Document ID");
                    recCustomerOrderLine.SetRange("Inventory Transfer", false);//230223 CITS_RS
                    recCustomerOrderLine.SetRange("Ship Order", false);//230223 CITS_RS
                    if recCustomerOrderLine.Find('-') then
                        repeat
                            recCustomerOrderLine."Inventory Transfer" := false;
                            recCustomerOrderLine."Store No." := POSTransaction."Store No.";
                            recCustomerOrderLine."Sourcing Location" := POSTransaction."Store No.";
                            recCustomerOrderLine.Modify();
                        until recCustomerOrderLine.Next() = 0;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"LSC POS Trans. Line", 'OnAfterInsertEvent', '', false, false)]
    procedure LineInserted()
    var
        i: integer;
    begin
        i := 0;
    end;

    // OnBeforeCreatePosTrans(var POSTransaction: Record "LSC POS Transaction"; var CustomerOrderHeaderTmp: Record "LSC Customer Order Header" temporary);
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnBeforeCreatePosTrans', '', false, false)]
    procedure CheckInvOnCollectingCO_UpdateStateinHeader(var POSTransaction: Record "LSC POS Transaction"; var CustomerOrderHeaderTmp: Record "LSC Customer Order Header" temporary);
    var
        recCustOrderHeader: Record "LSC Customer Order Header";
        recCustOrderLine: Record "LSC Customer Order Line";
        recItem: Record 27;
        recCustomer: Record 18;
        recCustomerOrderLine: Record "LSC Customer Order Line";
        recCustomerOrderHeader: Record "LSC Customer Order Header";
        recHeader: Record "LSC POS Transaction";
        recPurchOrder: record "Purchase Header";
    begin
        //if CustomerOrderHeaderTmp.CancelledOrder then exit;
        if CustomerOrderHeaderTmp.CancelledOrder then begin
            recCustOrderLine.Reset();
            recCustOrderLine.SetRange("Document ID", CustomerOrderHeaderTmp."Document ID");
            recCustOrderLine.SetFilter("Line Type", '=%1|%2', recCustOrderLine."Line Type"::Item, recCustOrderLine."Line Type"::Shipping);
            recCustOrderLine.SetRange(Status, recCustOrderLine.Status::"To Pick");
            if recCustOrderLine.Find('-') then begin
                recItem.Get(recCustOrderLine.Number);
                repeat
                    if recItem."PO No." <> '' then begin
                        recPurchOrder.get(1, recItem."PO No.");
                        recPurchOrder."LSC Customer Order ID" := '';
                        recPurchOrder."LSC General Comments" := '';
                        recPurchOrder.Modify(false);
                        // commit;
                    end;

                    recItem.Get(recCustOrderLine.Number);
                    recItem.ItemSaleReserved := false;//100623
                    recItem."Customer No." := '';//100623
                    recItem.Modify();//100623
                until recCustOrderLine.Next() = 0;
            end;
            exit;
        end;
        recCustOrderHeader.get(CustomerOrderHeaderTmp."Document ID");
        recCustOrderLine.Reset();
        recCustOrderLine.SetRange("Document ID", recCustOrderHeader."Document ID");
        recCustOrderLine.SetFilter("Line Type", '=%1|%2', recCustOrderLine."Line Type"::Item, recCustOrderLine."Line Type"::Shipping);
        // recCustOrderLine.SetRange(Status, recCustOrderLine.Status::"To Pick");
        recCustOrderLine.SetRange(Status, recCustOrderLine.Status::"To Collect");//CITS_RS 050623
        if recCustOrderLine.Find('-') then
            repeat
                recItem.Get(recCustOrderLine.Number);
                recItem.CalcFields(Inventory);
                if recItem.Inventory < 1 then
                    Error('Item %1 doesn''t have sufficient inventory in store %2', recItem."No.", POSTransaction."Store No.");
            until recCustOrderLine.Next() = 0;

        //merged 2 events 280223 CITS_RS
        recCustomer.get(CustomerOrderHeaderTmp."Customer No.");
        //commented 080623 CITS_RS
        // recHeader.Get(POSTransaction."Receipt No.");
        // recHeader.validate("LSCIN State", recCustomer."State Code");
        // recHeader.Validate("Customer No.", recCustomer."No.");
        POSTransaction.validate("LSCIN State", recCustomer."State Code");
        POSTransaction.validate("Customer No.", recCustomer."No.");
    end;

    // local procedure OnAfterInsertPosIncomeExpenceTransLine(
    //     var POSTransLine: Record "LSC POS Trans. Line";
    //     var POSTransaction: Record "LSC POS Transaction";
    //     var COHeaderTemp: Record "LSC Customer Order Header" temporary;
    //     var COLineTemp: Record "LSC Customer Order Line" temporary;
    //     var CODiscLineTemp: Record "LSC CO Discount Line" temporary;
    //     var ReceiptNo: Code[20];
    //     var ErrorCode: Code[30];
    //     var ErrorText: text;
    //     var COPaymentTemp: Record "LSC Customer Order Payment" temporary;
    //     var Returnvalue: Boolean;
    //     var Handled: Boolean)
    // begin
    // end; 
    //OnBeforeUpdateCoLineMode
    procedure IsPartialPayment(parmCOHeader: Record "LSC Customer Order Header"): Boolean
    var
        recCOHeader: Record "LSC Customer Order Header";
        recCOPayment: Record "LSC Customer Order Payment";
        decCOTotalAmt: Decimal;
        decCOPmt: Decimal;
        recCOLine: Record "LSC Customer Order Line";
    begin
        // recCOHeader.Get(parmCOHeader."Document ID");
        recCOLine.Reset();
        recCOLine.SetRange("Document ID", parmCOHeader."Document ID");
        recCOLine.SetFilter("Line Type", '=%1|%2', recCOLine."Line Type"::Item, recCOLine."Line Type"::IncomeExpense);
        if recCOLine.find('-') then
            repeat
                if recCOLine.Status in [recCOLine.Status::"To Collect", recCOLine.Status::"To Pick", recCOLine.Status::Collected] then
                    decCOTotalAmt += recCOLine.Amount;
            until recCOLine.Next() = 0;

        recCOPayment.Reset();
        recCOPayment.SetRange("Document ID", parmCOHeader."Document ID");
        recCOPayment.SetRange(Type, recCOPayment.Type::Payment);
        if recCOPayment.Find('-') then
            repeat
                decCOPmt += recCOPayment."Pre Approved Amount LCY";
            until recCOPayment.Next() = 0;

        if decCOPmt = decCOTotalAmt then
            exit(false)
        else
            exit(true);
    end;

    procedure RemovePOReference(parmCOHeaer: Record "LSC Customer Order Header")
    var
        recCustOrderLine: Record "LSC Customer Order Line";
        recItem: Record 27;
        recPurchHeader: Record 38;
    begin
        recCustOrderLine.Reset();
        recCustOrderLine.SetRange("Document ID", parmCOHeaer."Document ID");
        recCustOrderLine.SetRange("Line Type", recCustOrderLine."Line Type"::Item);
        if recCustOrderLine.Find('-') then
            repeat
                if recItem.get(recCustOrderLine.Number) then
                    if recPurchHeader.get(1, recItem."PO No.") then begin
                        recPurchHeader."LSC Customer Order ID" := '';
                        recPurchHeader."Customer Order ID" := '';
                        recPurchHeader."LSC General Comments" := '';
                        recPurchHeader.Modify(false);
                        // commit;
                        // exit;
                    end;

            until recCustOrderLine.Next() = 0;

    end;

    //executes only at the time of collection/partial cancellation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnAfterInsertPosIncomeExpenceTransLine', '', false, false)]
    procedure RecalculateCanelledOrderAmount(
        var POSTransLine: Record "LSC POS Trans. Line";
        var POSTransaction: Record "LSC POS Transaction";
        var COHeaderTemp: Record "LSC Customer Order Header" temporary;
        var COLineTemp: Record "LSC Customer Order Line" temporary;
        var CODiscLineTemp: Record "LSC CO Discount Line" temporary;
        var ReceiptNo: Code[20];
        var ErrorCode: Code[30];
        var ErrorText: text;
        var COPaymentTemp: Record "LSC Customer Order Payment" temporary;
        var Returnvalue: Boolean;
        var Handled: Boolean)
    var
        recCustOrderHeader: record "LSC Customer Order Header";
        recIncExpAccount: record 99001476;
        recCustomerOrderLine: record "LSC Customer Order Line";
        decTotalCOPayAmt: Decimal;
        recCOPaymentLine: record "LSC Customer Order Payment";
        recPosLine: record 99008981;
        decAdvanceAmt: decimal;
        decItemAmt: decimal;
        decFinalizedAmt: Decimal;
        //recPosHeader: record "LSC POS Transaction";
        decCancelledAmt: decimal;
        decIncExpAmt: decimal;
        decCollected: Decimal;
        decPreviousCollection: Decimal;
        decTotalCOAmt: Decimal;
    begin
        Clear(decTotalCOPayAmt);
        Clear(decTotalCOAmt);
        Clear(decPreviousCollection);
        Clear(decCollected);
        // recCustomerOrderLine.setrange("Document ID", COHeaderTemp."Document ID");
        // recCustomerOrderLine.setfilter("Line Type", '=%1|%2', recCustomerOrderLine."Line Type"::Item, recCustomerOrderLine."Line Type"::IncomeExpense);
        // if recCustomerOrderLine.Find('-') then
        //     repeat
        //         decTotalCOAmt += recCustomerOrderLine.Amount;
        //     until recCustomerOrderLine.Next() = 0;
        // if recIncExpAccount.get(POSTransLine."Store No.", POSTransLine.Number) then exit;//excluding alteration lines  190623 
        if not COHeaderTemp.CancelledOrder then begin
            if not IsPartialPayment(COHeaderTemp) then begin
                if (POSTransLine."Entry Type" = POSTransLine."Entry Type"::IncomeExpense) and   //income expense line
                    (recIncExpAccount.get(POSTransLine."Store No.", POSTransLine.Number)) then begin  //partial payments amount correction 230623 CITS_RS
                    if IsPartialCollection(COLineTemp) then begin
                        decCollected := CollectedCOAmount(COLineTemp);
                        recPosLine.get(POSTransLine."Receipt No.", POSTransLine."Line No.");
                        if not recPosLine."CO Prepayment Line" then exit;
                        recPosLine.Price := -(decCollected);// + COLineTemp.Amount);
                        recPosLine."Net Price" := -(decCollected);// + COLineTemp.Amount);
                        recPosLine.Amount := -(decCollected);// + COLineTemp.Amount);
                        recPosLine."Net Amount" := -(decCollected);// + COLineTemp.Amount);
                        recPosLine.Quantity := 1;
                        recPosLine.modify(false);
                    end else begin// final collection or full collection
                        if IsRefundEligible(COHeaderTemp, COLineTemp, decAdvanceAmt, decItemAmt, decCancelledAmt, decIncExpAmt, decPreviousCollection) then;//exit;//CITS_RS 020723
                        decTotalCOAmt := GetCustOrderTotalAmount_Uncollected(COHeaderTemp);
                        if decTotalCOAmt = (decAdvanceAmt - decPreviousCollection) then begin//full advance
                            recPosLine.get(POSTransLine."Receipt No.", POSTransLine."Line No.");
                            if not recPosLine."CO Prepayment Line" then exit;
                            recPosLine.Price := -(decTotalCOAmt);
                            recPosLine."Net Price" := -(decTotalCOAmt);
                            recPosLine.Amount := -(decTotalCOAmt);
                            recPosLine."Net Amount" := -(decTotalCOAmt);
                            recPosLine.Quantity := 1;
                            recPosLine.modify(false);
                        end;
                        /* else begin//partial advance
                            recPosLine.get(POSTransLine."Receipt No.", POSTransLine."Line No.");
                            if not recPosLine."CO Prepayment Line" then exit;
                            recPosHeader.get(recPosLine."Receipt No.");
                            recPosLine.Price := -(CalculateAmtExclofGST(recPosHeader, (decAdvanceAmt - abs((decItemAmt + decIncExpAmt) - decCancelledAmt - decPreviousCollection))));
                            recPosLine."Net Price" := -(CalculateAmtExclofGST(recPosHeader, (decAdvanceAmt - abs((decItemAmt + decIncExpAmt) - decCancelledAmt - decPreviousCollection))));
                            recPosLine.Amount := -(CalculateAmtExclofGST(recPosHeader, (decAdvanceAmt - abs((decItemAmt + decIncExpAmt) - decCancelledAmt - decPreviousCollection))));
                            recPosLine."Net Amount" := -(CalculateAmtExclofGST(recPosHeader, (decAdvanceAmt - abs((decItemAmt + decIncExpAmt) - decCancelledAmt - decPreviousCollection))));
                            recPosLine.Quantity := 1;
                            recPosLine.modify(false);
                        end;*/
                    end;
                end;
            end else begin// partial advance
                if IsRefundEligible(COHeaderTemp, COLineTemp, decAdvanceAmt, decItemAmt, decCancelledAmt, decIncExpAmt, decPreviousCollection) then;//exit;//CITS_RS 020723
                if (POSTransLine."Entry Type" = POSTransLine."Entry Type"::IncomeExpense) and   //income expense line
                    (recIncExpAccount.get(POSTransLine."Store No.", POSTransLine.Number)) then  //partial payments amount correction 230623 CITS_RS
                    if IsPartialCollection(COLineTemp) then begin
                        decCollected := CollectedCOAmount(COLineTemp);
                        if (decAdvanceAmt - decPreviousCollection) < decCollected then
                            decFinalizedAmt := (decAdvanceAmt - decPreviousCollection)
                        else begin
                            if decAdvanceAmt - decPreviousCollection <= 0 then
                                exit
                            else
                                decFinalizedAmt := decCollected;// - (decAdvanceAmt - decPreviousCollection);
                        end;
                        recPosLine.get(POSTransLine."Receipt No.", POSTransLine."Line No.");
                        if not recPosLine."CO Prepayment Line" then exit;
                        recPosLine.Price := -(decFinalizedAmt);// + COLineTemp.Amount);
                        recPosLine."Net Price" := -(decFinalizedAmt);// + COLineTemp.Amount);
                        recPosLine.Amount := -(decFinalizedAmt);// + COLineTemp.Amount);
                        recPosLine."Net Amount" := -(decFinalizedAmt);// + COLineTemp.Amount);
                        recPosLine.Quantity := 1;
                        recPosLine.modify(false);
                    end else begin //final collection
                        decTotalCOAmt := GetCustOrderTotalAmount_Uncollected(COHeaderTemp);
                        if decTotalCOAmt > (decAdvanceAmt - decPreviousCollection) then begin//full advance
                            decFinalizedAmt := (decAdvanceAmt - decPreviousCollection);
                            if decFinalizedAmt <= 0 then exit;
                            recPosLine.get(POSTransLine."Receipt No.", POSTransLine."Line No.");
                            if not recPosLine."CO Prepayment Line" then exit;
                            recPosLine.Price := -(decFinalizedAmt);
                            recPosLine."Net Price" := -(decFinalizedAmt);
                            recPosLine.Amount := -(decFinalizedAmt);
                            recPosLine."Net Amount" := -(decFinalizedAmt);
                            recPosLine.Quantity := 1;
                            recPosLine.modify(false);
                        end;
                    end;
            end;
        end else begin //payment refund line
            //070723++ CITS_RS
            // recCustOrderHeader.Get(COHeaderTemp."Document ID");
            // recCustOrderHeader."Purchase Orders" := 0;
            // recCustOrderHeader.Modify(false);
            RemovePOReference(COHeaderTemp);
            //070723--
            recCOPaymentLine.Reset();
            recCOPaymentLine.SetRange("Document ID", COHeaderTemp."Document ID");
            recCOPaymentLine.SetRange(Type, recCOPaymentLine.Type::Payment);
            if recCOPaymentLine.Find('-') then
                repeat
                    decTotalCOPayAmt += recCOPaymentLine."Pre Approved Amount LCY";
                until recCOPaymentLine.Next() = 0;
            if decTotalCOPayAmt = 0 then exit;

            recPosLine.get(POSTransLine."Receipt No.", POSTransLine."Line No.");
            recPosLine.Price := -(decTotalCOPayAmt);
            recPosLine."Net Price" := -(decTotalCOPayAmt);
            recPosLine.Amount := -(decTotalCOPayAmt);
            recPosLine."Net Amount" := -(decTotalCOPayAmt);
            recPosLine.Quantity := 1;
            recPosLine.modify(false);
        end;
    end;

    procedure CollectedCOAmount(parmCOLine: Record "LSC Customer Order Line"): Decimal
    var
        recCOHeader: Record "LSC Customer Order Header";
        decCollectedAmount: decimal;
        recCOLine: Record "LSC Customer Order Line";
    begin
        Clear(decCollectedAmount);
        if parmCOLine.Status = parmCOLine.Status::Collected then begin
            recCOHeader.Get(parmCOLine."Document ID");
            recCOLine.Reset();
            recCOLine.SetRange("Document ID", recCOHeader."Document ID");
            recCOLine.SetRange("Line Type", recCOLine."Line Type"::Item);
            // recCOLine.SetRange(Status, recCOLine.Status::Collected);
            // recCOLine.SetRange(Status, recCOLine.Status::"To Collect");
            if recCOLine.Find('-') then
                repeat
                    // if recCOLine.Status in [recCOLine.Status::Collected, recCOLine.Status::"To Collect"] then
                    if recCOLine.Status in [recCOLine.Status::"To Collect"] then
                        decCollectedAmount += recCOLine.Amount;
                until recCOLine.Next() = 0;
        end;

        exit(decCollectedAmount);
    end;

    procedure IsPartialCollection(parmCOLine: Record "LSC Customer Order Line"): Boolean
    var
        recCOHeader: Record "LSC Customer Order Header";
        recCOLine: Record "LSC Customer Order Line";
    begin
        if parmCOLine.Status = parmCOLine.Status::Collected then begin
            recCOHeader.Get(parmCOLine."Document ID");
            recCOLine.Reset();
            recCOLine.SetRange("Document ID", recCOHeader."Document ID");
            recCOLine.SetRange("Line Type", recCOLine."Line Type"::Item);
            recCOLine.setfilter(Status, '=%1', recCOLine.Status::"To Pick");//, recCOLine.Status::"To Collect");
            if recCOLine.FindFirst() then
                exit(true)
            else
                exit(false);
        end;
    end;

    procedure CreateItemJnlLine(recItem: Record 27; parmStoreNum: Code[20]; entryType: Text): text
    var
        recItemJnlLine: Record 83;
        intLineNum: Integer;
        recStore: record 99001470;
        recInvSetup: Record "Inventory Setup";
    begin
        clear(intLineNum);
        recStore.Get(parmStoreNum);
        recInvSetup.get;
        recItemJnlLine.Reset();
        recItemJnlLine.setrange("Journal Batch Name", 'DEFAULT');
        recItemJnlLine.SetRange("Journal Template Name", 'ITEM');
        if recItemJnlLine.FindLast() then
            intLineNum := recItemJnlLine."Line No.";

        recItemJnlLine.Init();
        recItemJnlLine.validate("Journal Batch Name", 'DEFAULT');
        recItemJnlLine.Validate("Journal Template Name", 'ITEM');
        if entryType = 'positive' then
            recItemJnlLine.validate("Document No.", 'POSITIVE ADJ. CO')// + recItem."No.", 1, 20));
        else
            if entryType = 'negative' then
                recItemJnlLine.validate("Document No.", 'NEGATIVE ADJ. CO');

        if intLineNum = 0 then
            recItemJnlLine.validate("Line No.", 10000)
        else
            recItemJnlLine.Validate("Line No.", (intLineNum + 10000));
        if entryType = 'positive' then
            recItemJnlLine.Validate("Entry Type", recItemJnlLine."Entry Type"::"Positive Adjmt.")
        else
            if entryType = 'negative' then
                recItemJnlLine.Validate("Entry Type", recItemJnlLine."Entry Type"::"Negative Adjmt.");
        recItemJnlLine.Validate("Posting Date", Today);
        recItemJnlLine.Validate("Item No.", recItem."No.");
        recItemJnlLine.Validate("Inventory Posting Group", recItem."Inventory Posting Group");
        recItemJnlLine.Validate("Unit Cost", recItem."Unit Cost");
        recItemJnlLine.Validate(Quantity, 1);
        recItemJnlLine.Validate("Quantity (Base)", 1);
        recItemJnlLine.validate("Location Code", recStore."Dummy Location");
        recItemJnlLine.Validate("Source Code", 'ITEMJNL');
        recItemJnlLine.Insert();
        exit(recItemJnlLine."Journal Batch Name" + ',' + recItemJnlLine."Journal Template Name" + ',' + format(recItemJnlLine."Line No."));
    end;

    // local procedure OnAfterInsertTransactionsProcessTransactionsV2(var TransactionHeader: Record "LSC Transaction Header"; var TransSalesEntryTemp: Record "LSC Trans. Sales Entry" temporary; PaymentEntryTemp: Record "LSC Trans. Payment Entry" temporary)
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterInsertTransactionsProcessTransactionsV2', '', false, false)]
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeTransactionTendered', '', false, false)]//160223
    // procedure BlockItemSale(var TransactionHeader: Record "LSC Transaction Header"; var TransSalesEntryTemp: Record "LSC Trans. Sales Entry" temporary; PaymentEntryTemp: Record "LSC Trans. Payment Entry" temporary)
    //Not in use
    /*
    procedure BlockItemSale(var POSTransaction: Record "LSC POS Transaction"; var TenderType: Record "LSC Tender Type"; var VoidInProcess: Boolean; var Balance: Decimal)//160223
    var
        recItem: Record 27;
        recPosTransLine: Record 99008981;
        recCustomOrderHeader: record 10016651;
        recCust: Record 18;
        cuPosTrans: codeunit "LSC POS Transaction";
        recCustomerOrderLine: Record 10016652;
        cuPostUtil: Codeunit "LSC Pos Post Utility";
        recPosHeader: Record "LSC POS Transaction";
    begin
        Clear(recPosHeader);
        Clear(recPosTransLine);
        // if (POSTransaction."Customer No." = '') and (POSTransaction."Customer Order ID" = '') then
        //     Error('Please assign a customer first !');
        // if POSTransaction."Customer Order" then begin
        if not POSTransaction."Sale Is Return Sale" then begin//160223

            //if POSTransaction.Payment > 0 then begin
            //   if not POSTransaction."Customer Order" then begin
            recPosTransLine.Reset();
            recPosTransLine.SetRange("Entry Status", recPosTransLine."Entry Status"::" ");
            recPosTransLine.SetRange("Entry Type", recPosTransLine."Entry Type"::Item);
            recPosTransLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
            if recPosTransLine.Find('-') then begin
                repeat
                    recItem.get(recPosTransLine.Number);
                    // if (recItem."No." <> '69000') and (recItem."No." <> 'ADVANCE') then begin
                    //     recItem.ItemSaleReserved := false;
                    // end else begin
                    if not recItem."Is Advance" then begin
                        recItem.ItemSaleReserved := true;
                    end;

                    if POSTransaction."Customer Order" then
                        recItem."Customer No." := POSTransaction."Customer No.";
                    // if recItem."No." = '69000' then
                    //     recItem.ItemSaleReserved := false
                    // else
                    // recItem.ItemSaleReserved := true;
                    recItem."Item Booking Date" := Today;
                    // recItem."Item Delivery Date" := Today;
                    // recItem."Payment Due Date" := calcdate(Today);
                    recItem.Modify();
                until recPosTransLine.Next() = 0;
            end;
            // end;
            //   end else begin
            //   end;
        end else begin
            recCustomOrderHeader.Reset();
            recCustomOrderHeader.Setrange("Document ID", POSTransaction."Customer Order ID");
            if recCustomOrderHeader.Find('-') then begin
                recCustomerOrderLine.Reset();
                recCustomerOrderLine.SetRange("Document ID", recCustomOrderHeader."Document ID");
                recCustomerOrderLine.SetRange("Line Type", recCustomerOrderLine."Line Type"::Item);
                if recCustomerOrderLine.find('-') then
                    repeat
                        recItem.get(recCustomerOrderLine.Number);
                        recItem.ItemSaleReserved := false;
                        recItem."Customer No." := '';
                        recItem.Modify();
                    until recCustomerOrderLine.Next() = 0;
            end else begin
                recPosTransLine.Reset();
                recPosTransLine.SetRange("Entry Status", recPosTransLine."Entry Status"::" ");
                recPosTransLine.SetRange("Entry Type", recPosTransLine."Entry Type"::Item);
                recPosTransLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
                if recPosTransLine.Find('-') then begin
                    repeat
                        recItem.Get(recPosTransLine.Number);
                        recItem.ItemSaleReserved := false;
                        recItem."Customer No." := '';
                        recItem.Modify();
                    until recPosTransLine.Next() = 0;
                end

            end;

        end;
        // end;
    end;
    */

    //CITS_RS 160223
    //270523commented// [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterInsertTransactionsProcessTransactionsV2', '', false, false)]
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeTransactionTendered', '', false, false)]//160223
    //**not in use**
    /*
    procedure BlockItemSaleV2(var TransactionHeader: Record "LSC Transaction Header"; var TransSalesEntryTemp: Record "LSC Trans. Sales Entry" temporary; PaymentEntryTemp: Record "LSC Trans. Payment Entry" temporary)
    // procedure BlockItemSaleV2(var POSTransaction: Record "LSC POS Transaction"; var TenderType: Record "LSC Tender Type"; var VoidInProcess: Boolean; var Balance: Decimal)//160223
    var
        recItem: Record 27;
        recTransSalesEn: Record 99001473;
        recPosTransLine: Record 99008981;
        recCustomOrderHeader: record 10016651;
        recCust: Record 18;
        recCustomerOrderLine: Record 10016652;
        cuPostUtil: Codeunit "LSC Pos Post Utility";
        recPosHeader: Record "LSC POS Transaction";
    begin
        Clear(recPosHeader);
        Clear(recPosTransLine);
        Clear(recTransSalesEn);
        if TransactionHeader."Entry Status" <> TransactionHeader."Entry Status"::" " then exit;

        if not TransactionHeader."Sale Is Return Sale" then begin//160223
            recTransSalesEn.Reset();
            recTransSalesEn.SetRange("Store No.", TransactionHeader."Store No.");
            recTransSalesEn.SetRange("POS Terminal No.", TransactionHeader."POS Terminal No.");
            recTransSalesEn.SetRange("Transaction No.", TransactionHeader."Transaction No.");
            if recTransSalesEn.Find('-') then begin
                repeat
                    recItem.get(recTransSalesEn."Item No.");
                    if not recItem."Is Advance" then begin
                        recItem.ItemSaleReserved := true;
                    end;

                    if TransactionHeader."Customer Order" then
                        recItem."Customer No." := TransactionHeader."Customer No.";
                    recItem."Item Booking Date" := Today;
                    // recItem."Item Delivery Date" := Today;
                    // recItem."Payment Due Date" := calcdate(Today);
                    recItem.Modify();
                until recTransSalesEn.Next() = 0;
            end;
            // end;
            //   end else begin
            //   end;
        end else begin
            recCustomOrderHeader.Reset();
            recCustomOrderHeader.SetRange("Document ID", TransactionHeader."Customer Order ID");
            if recCustomOrderHeader.Find('-') then begin
                recCustomerOrderLine.Reset();
                recCustomerOrderLine.SetRange("Document ID", recCustomOrderHeader."Document ID");
                recCustomerOrderLine.SetRange("Line Type", recCustomerOrderLine."Line Type"::Item);
                if recCustomerOrderLine.find('-') then
                    repeat
                        recItem.get(recCustomerOrderLine.Number);
                        recItem.ItemSaleReserved := false;
                        recItem."Customer No." := '';
                        recItem.Modify();
                    until recCustomerOrderLine.Next() = 0;
            end else begin
                recTransSalesEn.Reset();
                recTransSalesEn.SetRange("Store No.", TransactionHeader."Store No.");
                recTransSalesEn.SetRange("POS Terminal No.", TransactionHeader."POS Terminal No.");
                recTransSalesEn.SetRange("Transaction No.", TransactionHeader."Transaction No.");
                if recTransSalesEn.Find('-') then
                    repeat
                        recItem.Get(recTransSalesEn."Item No.");
                        recItem.ItemSaleReserved := false;
                        recItem."Customer No." := '';
                        recItem.Modify();
                    until recTransSalesEn.Next() = 0;
            end;
        end;
    end;
    */

    // OnBeforeTotalExecuted(var POSTransaction: Record "LSC POS Transaction"; var IsHandled: Boolean)
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnBeforeTotalExecuted', '', false, false)]

    //Not in use
    /*procedure GetErrorCallStack_Before(var POSTransaction: Record "LSC POS Transaction"; var IsHandled: Boolean)
    var
        errorInfoObj: ErrorInfo;
        errorT: ErrorType;
    begin
        // message('Error call stack %1', errorInfoObj.Callstack);
        // message('Errpr detailed message %1', errorInfoObj.DetailedMessage);
        // // Message(errorInfoObj.FieldNo);
        // Message('Error control name %1', errorInfoObj.ControlName);
        // Message('Error type %1', format(errorInfoObj.ErrorType(errorT)));
        CollectErrors();
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnAfterTotalExecuted', '', false, false)]
    procedure GetErrorCallStack_After(var POSTransaction: Record "LSC POS Transaction")
    var
        errorInfoObj: ErrorInfo;
        errorT: ErrorType;
    begin
        CollectErrors();
        // message('Error call stack %1', errorInfoObj.Callstack);
        // message('Errpr detailed message %1', errorInfoObj.DetailedMessage);
        // // Message(errorInfoObj.FieldNo);
        // Message('Error control name %1', errorInfoObj.ControlName);
        // Message('Error type %1', format(errorInfoObj.ErrorType(errorT)));
    end;

    [ErrorBehavior(ErrorBehavior::Collect)]
    procedure CollectErrors()
    var
    begin

    end;*/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'ItemLineOnAfterItemGet', '', false, false)]
    procedure ItemLineOnAfterItemGet(Item: Record Item; var POSTransLine: Record "LSC POS Trans. Line"; var Proceed: Boolean)
    var
        recPosLine: Record 99008981;
        recCust: Record 18;
        recItem: Record 27;
        recVendor: Record 23;
        recPosHeader: record "LSC POS Transaction";
        recCustomer: record 18;
        recStore: record 99001470;
        recHeader: Record "LSC POS Transaction";
        POSTransaction: Record "LSC POS Transaction";
        POSTransCU: Codeunit "LSC POS Transaction";
    begin
        //KKS -1 Hard error Replaced
        IF not POSTransaction.Get(POSTransLine."Receipt No.") then
            exit;
        if POSTransaction."Customer No." <> '' then
            if recCustomer.get(POSTransaction."Customer No.") then
                if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
                    recPosLine.Reset();
                    recPosLine.setrange("Receipt No.", POSTransaction."Receipt No.");
                    recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::FreeText);
                    if recPosLine.FindFirst() then begin
                        if StrPos(recPosLine.Description, 'Cust:') > 0 then
                            if recPosLine."Sales Staff" = '' then begin
                                //Error('Please assign Sales Staff on Customer Line');
                                POSTransCU.PosMessage('Please assign Sales Staff on Customer Line');
                                Proceed := false;
                                Exit;
                            end;
                    end;
                end;
        //KKS -1
        //KKS -2
        recHeader.Reset();
        recHeader.SetRange("Entry Status", recHeader."Entry Status"::Suspended);
        if recHeader.Find('-') then begin//suspended
            repeat
                recPosLine.Reset();
                recPosLine.SetRange("Receipt No.", recHeader."Receipt No.");
                recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item);
                recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
                recPosLine.SetFilter(Number, '=%1', POSTransLine.Number);
                if recPosLine.FindFirst() then
                    repeat
                        recItem.Get(POSTransLine.Number);
                        //Error('Item %1 is suspended in Transaction %1', recItem.Description, recHeader."Receipt No.");
                        POSTransCU.PosMessage(StrSubstNo('Item %1 is suspended in Transaction %1', recItem.Description, recHeader."Receipt No."));
                        Proceed := false;
                        Exit;
                    until recPosLine.Next() = 0;
            until recHeader.Next() = 0;
        end else begin
            recHeader.SetFilter("Entry Status", '<>%1', recHeader."Entry Status"::Suspended);
            if recHeader.FindFirst() then begin//normal
                repeat
                    recPosLine.Reset();
                    recPosLine.SetRange("Receipt No.", recHeader."Receipt No.");
                    recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item);
                    recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
                    recPosLine.SetFilter(Number, '=%1', POSTransLine.Number);
                    if recPosLine.FindFirst() then
                        repeat
                            recItem.Get(POSTransLine.Number);
                            //Error('Item %1 is used in Transaction %1', recItem.Description, recHeader."Receipt No.");
                            POSTransCU.PosMessage(StrSubstNo('Item %1 is used in Transaction %1', recItem.Description, recHeader."Receipt No."));
                            Proceed := false;
                            Exit;
                        until recPosLine.Next() = 0;
                until recHeader.Next() = 0;
            end;

        end;
        //KKS -2

        //KKS -3
        if recItem.Get(POSTransLine.Number) then;
        IF recItem."No." <> '690000' then begin
            recItem.SetFilter("Location Filter", POSTransaction."Store No.");
            recItem.CalcFields(Inventory);
            IF recItem.Inventory < 1 then begin
                POSTransCU.PosMessage(StrSubstNo('Item %1 doesn''t have sufficient inventory in store %2', recItem."No.", POSTransaction."Store No."));
                // Proceed := false;
                //Exit;
            end;
        end;
        if recItem."Customer No." <> '' then begin
            if POSTransaction."Customer No." <> recItem."Customer No." then begin
                recCust.get(recItem."Customer No.");
                //Error('Item %1 is blocked for Customer %2 %3', recItem."No.", recItem."Customer No.", recCust.Name);
                POSTransCU.PosMessage(StrSubstNo('Item %1 is blocked for Customer %2 %3', recItem."No.", recItem."Customer No.", recCust.Name));
                Proceed := false;
                Exit;
            end;
        end;
        //KKS -3
        //KKS -4
        if not POSTransLine."Customer Order Line" then
            if IncExpLineExists(POSTransaction) then begin
                if POSTransLine."Entry Type" = POSTransLine."Entry Type"::Item then Begin
                    //Error('Please removed the alteration before punching items !');
                    POSTransCU.PosMessage('Please removed the alteration before punching items !');
                    Proceed := false;
                    Exit;
                end;
            end;
        if recitem."Is Advance" then exit;
        if recitem.ItemSaleReserved then begin
            //Error('Item %1 has already been sold in store %2', recitem.Description, POSTransaction."Store No.");
            POSTransCU.PosMessage(StrSubstNo('Item %1 has already been sold in store %2', recitem.Description, POSTransaction."Store No."));
            Proceed := false;
            Exit;
        end;

        if not recitem."Is Approved for Sale" then begin
            //Error('Item %1 is not approved for sale. Please contact Finance Team', recitem.Description);
            POSTransCU.PosMessage(StrSubstNo('Item %1 is not approved for sale. Please contact Finance Team', recitem.Description));
            Proceed := false;
            Exit;
        end;
        //KKS -4
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnBeforeInsertItemLine', '', false, false)]
    procedure CheckCustomer(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var CompressEntry: Boolean)
    var
        recPosLine: Record 99008981;
        recCust: Record 18;
        recItem: Record 27;
        recVendor: Record 23;
        recPosHeader: record "LSC POS Transaction";
        recCustomer: record 18;
        recStore: record 99001470;
        recHeader: Record "LSC POS Transaction";
    begin
        //140623 REC is modified when Sales Staff is assigned, using that modify to change the State
        // in case of unregstered customers
        //KKS -1 Removed Hard error
        /*  if POSTransaction."Customer No." <> '' then
             if recCustomer.get(POSTransaction."Customer No.") then
                 if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
                     recPosLine.Reset();
                     recPosLine.setrange("Receipt No.", POSTransaction."Receipt No.");
                     recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::FreeText);
                     if recPosLine.FindFirst() then begin
                         if StrPos(recPosLine.Description, 'Cust:') > 0 then
                             if recPosLine."Sales Staff" = '' then
                                 Error('Please assign Sales Staff on Customer Line');
                     end;
                 end; */
        //KKS -1 Removed Hard error

        //CITS_RS 300523 If customer is unregistered then same state as store will be assigned as store location.
        // if POSTransaction."Customer No." <> '' then begin
        //     recStore.get(POSTransaction."Store No.");
        //     recCustomer.get(POSTransaction."Customer No.");
        //     if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
        //         recPosHeader.Get(POSTransaction."Receipt No.");
        //         recPosHeader.validate("LSCIN State", recStore."LSCIN State Code");
        //         recPosHeader.Modify();
        //     end;
        // end;

        //Checking whether item is already in use or was suspended in another transaction CITS_RS 290523
        //KKS -2 Removed Hard error
        /* recHeader.Reset();
        recHeader.SetRange("Entry Status", recHeader."Entry Status"::Suspended);
        if recHeader.Find('-') then begin//suspended
            repeat
                recPosLine.Reset();
                recPosLine.SetRange("Receipt No.", recHeader."Receipt No.");
                recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item);
                recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
                recPosLine.SetFilter(Number, '=%1', POSTransLine.Number);
                if recPosLine.FindFirst() then
                    repeat
                        recItem.Get(POSTransLine.Number);
                        Error('Item %1 is suspended in Transaction %1', recItem.Description, recHeader."Receipt No.");
                    until recPosLine.Next() = 0;
            until recHeader.Next() = 0;
        end else begin
            recHeader.SetFilter("Entry Status", '<>%1', recHeader."Entry Status"::Suspended);
            if recHeader.FindFirst() then begin//normal
                repeat
                    recPosLine.Reset();
                    recPosLine.SetRange("Receipt No.", recHeader."Receipt No.");
                    recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item);
                    recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
                    recPosLine.SetFilter(Number, '=%1', POSTransLine.Number);
                    if recPosLine.FindFirst() then
                        repeat
                            recItem.Get(POSTransLine.Number);
                            Error('Item %1 is used in Transaction %1', recItem.Description, recHeader."Receipt No.");
                        until recPosLine.Next() = 0;
                until recHeader.Next() = 0;
            end;

        end; */
        //KKS -2 Removed Hard error
        //Customercheck at total 120523
        // if (POSTransaction."Customer No." = '') and (POSTransaction."Customer Order ID" = '') then
        //     Error('Please assign a customer first !');

        if POSTransLine."Entry Status" = POSTransLine."Entry Status"::" " then
            if POSTransLine."Entry Type" = POSTransLine."Entry Type"::Item then begin
                recItem.get(POSTransLine.Number);
                recVendor.get(recItem.designerID);
                POSTransLine."Designer Name" := recVendor.Name;
                // POSTransLine.Modify(false);
            end;
        // recPosLine.Reset();
        // recPosLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
        // recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
        // recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item);
        // if recPosLine.Find('-') then
        //     repeat
        //KKS -3 Removed Hard error
        /* if recItem.Get(POSTransLine.Number) then;
        if recItem."Customer No." <> '' then begin

            if POSTransaction."Customer No." <> recItem."Customer No." then begin
                recCust.get(recItem."Customer No.");
                Error('Item %1 is blocked for Customer %2 %3', recItem."No.", recItem."Customer No.", recCust.Name);
            end;
        end; */
        //KKS -3 Removed Hard error
        //redundant
        /*if recItem."Is Advance" then begin
            if POSTransaction."Customer No." = '' then
                Error('Please assign a customer for advance');
        end;*/
        // until recPosLine.Next() = 0;


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Post Utility", 'OnAfterInsertTransHeader', '', false, false)]
    procedure InsertNoSeriesInTransactionHeader(var Transaction: Record "LSC Transaction Header"; var POSTrans: Record "LSC POS Transaction");
    var
        recStore: Record "LSC Store";
        cuNoSeries: Codeunit NoSeriesManagement;
        recItem: Record 27;
        POSTransLine: Record "LSC POS Trans. Line";
        TransSalesEntry: Record "LSC Trans. Sales Entry";
        LineNo: Integer;
    begin
        if Transaction."Entry Status" <> Transaction."Entry Status"::" " then exit;
        recStore.Get(Transaction."Store No.");

        //Anshu>>
        // if (Transaction."Customer No." <> '') and (IsAdvanceTransaction(Transaction)) then begin
        //     Transaction."Aza Posting No." := cuNoSeries.GetNextNo(recStore."Cust. Adv. Posting No. Series", Today, true);
        //     exit;
        // end;
        POSTransLine.Reset();
        POSTransLine.SetRange("Receipt No.", POSTrans."Receipt No.");
        POSTransLine.SetRange("Entry Status", POSTransLine."Entry Status"::" ");
        POSTransLine.SetRange("Entry Type", POSTransLine."Entry Type"::Item);
        // POSTransLine.SetRange(Number, '69000');
        if POSTransLine.FindFirst() then begin
            recItem.Get(POSTransLine.Number);
            if recItem."Is Advance" then begin
                Transaction."Aza Posting No." := cuNoSeries.GetNextNo(recStore."Cust. Adv. Posting No. Series", Today, true);
                exit;
            end;
        end;
        //Anshu<<
        //LineNo := 10000;
        if Transaction."Customer Order ID" <> '' then
            //if not (TransSalesEntry.get(Transaction."Store No.", Transaction."POS Terminal No.", Transaction."Transaction No.", LineNo)) then begin
            //if Transaction."Customer No." <> '' then begin
            //if Transaction."Net Amount" <= 0 then begin
                if Transaction."VAT Bus.Posting Group" <> '' then begin
                Transaction."Aza Posting No." := cuNoSeries.GetNextNo(recStore."Cust. Order No. Series", Today, true);
                // Message('hi');
                exit;
            end;
        if Transaction."Sale Is Return Sale" then
            Transaction."Aza Posting No." := cuNoSeries.GetNextNo(recStore."Sales Ret. Posting No. Series", Today, true)
        else
            Transaction."Aza Posting No." := cuNoSeries.GetNextNo(recStore."Sales Posting No. Series", Today, true);

    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterInsertTransaction', '', false, false)]
    // local procedure OnAfterInsertTransaction(var POSTrans: Record "LSC POS Transaction"; var Transaction: Record "LSC Transaction Header");
    // begin
    //     Transaction.Reset();
    //     Transaction.SetRange("Store No.", POSTrans."Store No.");
    //     Transaction.SetRange("POS Terminal No.", POSTrans."POS Terminal No.");
    //     Transaction.SetRange("Receipt No.", POSTrans."Receipt No.");
    //     if Transaction.FindFirst() then
    //         if POSTrans.Isadvance = true then
    //             Transaction.Isadvance := true;
    // end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnAfterInsertItemLine', '', false, false)]
    local procedure MarkAdvanceTransactions(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line")
    var
        recItem: Record 27;//CITS_RS
                           //recHeader: Record "LSC POS Transaction";//CITS_RS
    begin
        POSTransLine.Reset();
        POSTransLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
        POSTransLine.SetRange("Entry Status", POSTransLine."Entry Status"::" ");//CITS_RTS
        POSTransLine.SetRange("Entry Type", POSTransLine."Entry Type"::Item);//CITS_RS
        if POSTransLine.FindFirst() then begin
            // if POSTransLine.Number = '69000' then//CITS_RS commented
            recItem.get(POSTransLine.Number);
            if recItem."Is Advance" then begin
                /* recHeader.get(POSTransaction."Receipt No.");
                recHeader.Isadvance := true;
                recHeader.Modify(); */
                POSTransaction.Isadvance := true;
                POSTransaction.Modify();//KKS POS Transaction Error
                // POSTransaction.Isadvance := true;//commented CITS_RS
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptHeader', '', false, false)]
    procedure InsertNoSeriesTransferReceiptHeader(var TransRcptHeader: Record "Transfer Receipt Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var Handled: Boolean)
    var
        recStore: Record 99001470;
        cuNoSeries: Codeunit NoSeriesManagement;
    begin
        recStore.Get(TransHeader."Transfer-from Code");
        TransRcptHeader."Aza Posting No." := cuNoSeries.GetNextNo(recStore."Transfer Order No. Series", today, true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    procedure InsertNoSeriesTransferShipHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    var
        recStore: Record 99001470;
        recInvSetup: Record "Inventory Setup";
        cuNoSeries: Codeunit NoSeriesManagement;
    begin

        if not recStore.Get(TransHeader."Transfer-from Code") then begin
            recInvSetup.Get();
            TransShptHeader."Aza Posting No." := cuNoSeries.GetNextNo(recInvSetup."Transfer Order Nos.", today, true);
        end else
            TransShptHeader."Aza Posting No." := TransHeader."No.";//cuNoSeries.GetNextNo(recStore."Transfer Order No. Series", today, true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeGenNextNo', '', false, false)]
    local procedure OnBeforeGenNextNo(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header");
    var
        lscStore: Record "LSC Store";
        RetailUser: Record "LSC Retail User";
        NoSeriMgmt: Codeunit NoSeriesManagement;
    begin
        RetailUser.Get(UserId);
        RetailUser.TestField(RetailUser."Store No.");
        if lscStore.Get(RetailUser."Store No.") then begin
            TransferShipmentHeader."No." := NoSeriMgmt.GetNextNo(lscStore."Transfer Shipment", Today, true);
            //  Message('TransShipHdr No: %1', TransferShipmentHeader."No.");
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnInsertTransRcptHeaderOnBeforeGetNextNo', '', false, false)]
    local procedure OnInsertTransRcptHeaderOnBeforeGetNextNo(var TransRcptHeader: Record "Transfer Receipt Header"; TransHeader: Record "Transfer Header");
    var
        lscStore: Record "LSC Store";
        RetailUser: Record "LSC Retail User";
        NoSeriMgmt: Codeunit NoSeriesManagement;
    begin
        RetailUser.Get(UserId);
        RetailUser.TestField(RetailUser."Store No.");
        if lscStore.Get(RetailUser."Store No.") then begin
            TransRcptHeader."No." := NoSeriMgmt.GetNextNo(lscStore."Transfer Recipt", Today, true);
            // Message('TransReceiptHdr No: %1', TransRcptHeader."No.");
        end;
    end;



    //210223 Initial testing done. CITS_RS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnBeforeInsertCustomerOrderLine', '', false, false)]
    procedure InsertSalesStaffCOLine(var PosTransLine: Record "LSC POS Trans. Line"; var CustomerOrderLineTemp: Record "LSC Customer Order Line" temporary)
    var
    begin
        CustomerOrderLineTemp."POS Comment" := PosTransLine."POS Comment";//050523 CITS_RS
        CustomerOrderLineTemp."POS Sales Associate" := PosTransLine."Sales Staff";
        // if recPosLine1."LSCIN GST Place of Supply" = recPosLine1."LSCIN GST Place of Supply"::" " then
        CustomerOrderLineTemp."LSCIN GST Place of Supply" := PosTransLine."LSCIN GST Place of Supply";
        CustomerOrderLineTemp."LSCIN GST Group Code" := PosTransLine."LSCIN GST Group Code";
        CustomerOrderLineTemp."LSCIN GST Group Type" := PosTransLine."LSCIN GST Group Type";
        CustomerOrderLineTemp."LSCIN HSN/SAC Code" := PosTransLine."LSCIN HSN/SAC Code";
        CustomerOrderLineTemp."LSCIN Exempted" := PosTransLine."LSCIN Exempted";
        CustomerOrderLineTemp."LSCIN Price Inclusive of Tax" := PosTransLine."LSCIN Price Inclusive of Tax";
        CustomerOrderLineTemp."LSCIN Unit Price Incl. of Tax" := PosTransLine."LSCIN Unit Price Incl. of Tax";
        CustomerOrderLineTemp."LSCIN GST Amount" := PosTransLine."LSCIN GST Amount";
    end;

    // local procedure OnAfterCreateLinesToRefund(var PosTransLine: Record "LSC POS Trans. Line")
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Refund Mgt.", 'OnAfterCreateLinesToRefund', '', false, false)]
    procedure StoreOriginalTransValues(var PosTransLine: Record "LSC POS Trans. Line")
    var
        recPosTransLine: Record 99008981;
    begin
        recPosTransLine.get(PosTransLine."Receipt No.", PosTransLine."Line No.");
        recPosTransLine."Original Store" := PosTransLine."Orig. Trans. Store";
        recPosTransLine."Original Pos" := PosTransLine."Orig. Trans. Pos";
        recPosTransLine."Original Trans No." := PosTransLine."Orig. Trans. No.";
        recPosTransLine."Original Trans Line No." := PosTransLine."Orig. Trans. Line No.";
        recPosTransLine.Modify(false);
    end;

    // local procedure OnProcessRefundSelection(OriginalTransaction: Record "LSC Transaction Header"; var POSTransaction: Record "LSC POS Transaction"; isPostVoid: Boolean)
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction", 'OnProcessRefundSelection', '', false, false)]
    procedure InitializeOriginalValuesinRefundTrans(OriginalTransaction: Record "LSC Transaction Header"; var POSTransaction: Record "LSC POS Transaction"; isPostVoid: Boolean)
    var
        recRefundLine: Record 99008981;
    begin
        recRefundLine.Reset();
        recRefundLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
        recRefundLine.SetRange("Entry Status", recRefundLine."Entry Status"::" ");
        recRefundLine.SetRange("Entry Type", recRefundLine."Entry Type"::Item);
        if recRefundLine.Find('-') then
            repeat
                recRefundLine."Orig. Trans. Store" := recRefundLine."Original Store";
                recRefundLine."Orig. Trans. Pos" := recRefundLine."Original Pos";
                recRefundLine."Orig. Trans. No." := recRefundLine."Original Trans No.";
                recRefundLine."Orig. Trans. Line No." := recRefundLine."Original Trans Line No.";
                recRefundLine.Modify(false);
            until recRefundLine.Next() = 0;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterPostTransaction', '', false, false)]
    procedure DeliveryDateandPmtTerms_CustAssigntoItem(var TransactionHeader_p: Record "LSC Transaction Header")
    // procedure COInserted(Rec: Record "LSC Posted Customer Order Line")
    var
        recItem: Record 27;
        recSalesEn: Record 99001473;
        recPosTransLine: Record 99008981;
        recPostedHeader: Record 99001472;
        recCustomOrderHeader: record 10016651;
        recPmtTerms: Record "Payment Terms";
        cuEInvoice: Codeunit E_Invoice_TaxInv;
        recCust: Record Customer;
        recRetailSet: Record "LSC Retail Setup";
        recVendor: Record 23;
        recTransSalesEn: Record 99001473;
        recCustOrderPmt: Record "LSC Customer Order Payment";
        recCustomerOrderLine: Record 10016652;
        recTransSaleEn: Record 99001473;
        arrLineNum: array[999] of Integer;
        recGenLedSetup: Record 98;
        i: Integer;
        decPmtAmt: Decimal;
        recPostedCustLine: record "LSC Posted Customer Order Line";
    begin
        if TransactionHeader_p."Entry Status" <> TransactionHeader_p."Entry Status"::" " then exit;
        if (TransactionHeader_p."Customer Order ID" <> '') and (not TransactionHeader_p."Sale Is Return Sale")
         and (TransactionHeader_p.Payment >= 0) then begin//customer order sale
            if TransactionHeader_p."Customer Order ID" <> '' then begin


                // recPostedHeader.Reset();
                // recPostedHeader.SetRange("Transaction No.", TransactionHeader_p."Transaction No.");
                // recPostedHeader.SetRange("Store No.", TransactionHeader_p."Store No.");
                // // recPostedHeader.SetRange("Customer Order ID", TransactionHeader_p."Document ID");
                // if recPostedHeader.Find('-') then
                recPostedCustLine.Reset();
                recPostedCustLine.SetRange("Document ID", TransactionHeader_p."Customer Order ID");
                recPostedCustLine.SetRange("Line Type", recPostedCustLine."Line Type"::Item);
                if recPostedCustLine.Find('-') then
                    repeat
                        recItem.get(recPostedCustLine.Number);
                        recItem."Item Delivery Date" := Today;

                        //270523
                        if not recItem."Is Advance" then
                            recItem.ItemSaleReserved := true;
                        recItem."Customer No." := TransactionHeader_p."Customer No.";
                        //270523
                        // recPostedHeader.Reset();
                        // recPostedHeader.SetFilter("Customer Order ID", TransactionHeader_p."Customer Order ID");
                        // recPostedHeader.SetFilter("Customer No.", '<>%1', '');
                        // if recPostedHeader.FindFirst() then
                        //     recCust.get(recPostedHeader."Customer No.");
                        recVendor.get(recItem."Vendor No.");
                        recPmtTerms.Get(recVendor."Payment Terms Code");
                        recItem."Payment Due Date" := CalcDate('+' + format(recPmtTerms."Due Date Calculation"), Today);
                        recItem.Modify();
                    until recPostedCustLine.Next() = 0;
            end else begin//normal sale
                if (TransactionHeader_p."Customer Order ID" = '') and
                 (not TransactionHeader_p."Sale Is Return Sale")
             and (TransactionHeader_p.Payment >= 0) then begin
                    recTransSaleEn.Reset();
                    recTransSaleEn.SetRange("Store No.", TransactionHeader_p."Store No.");
                    recTransSaleEn.SetRange("POS Terminal No.", TransactionHeader_p."POS Terminal No.");
                    recTransSaleEn.SetRange("Transaction No.", TransactionHeader_p."Transaction No.");
                    if recTransSaleEn.Find('-') then
                        repeat
                            recItem.get(recTransSaleEn."Item No.");

                            //270523
                            if not recItem."Is Advance" then begin
                                recItem.ItemSaleReserved := true;
                                if TransactionHeader_p."Customer Order" then
                                    recItem."Customer No." := TransactionHeader_p."Customer No.";

                                recItem."Item Booking Date" := Today;
                                //270523
                                recItem."Item Delivery Date" := Today;
                                recVendor.get(recItem."Vendor No.");
                                recPmtTerms.Get(recVendor."Payment Terms Code");
                                recItem."Payment Due Date" := CalcDate('+' + format(recPmtTerms."Due Date Calculation"), Today);
                                recItem.Modify();
                            end;
                        until recTransSaleEn.Next() = 0;
                end;
            end;
        end else//refund
            if TransactionHeader_p."Sale Is Return Sale" then begin
                recCustomOrderHeader.Reset();
                recCustomOrderHeader.SetRange("Document ID", TransactionHeader_p."Customer Order ID");
                if recCustomOrderHeader.Find('-') then begin
                    recCustomerOrderLine.Reset();
                    recCustomerOrderLine.SetRange("Document ID", recCustomOrderHeader."Document ID");
                    recCustomerOrderLine.SetRange("Line Type", recCustomerOrderLine."Line Type"::Item);
                    if recCustomerOrderLine.find('-') then
                        repeat
                            recItem.get(recCustomerOrderLine.Number);
                            recItem.ItemSaleReserved := false;
                            recItem."Customer No." := '';
                            recItem.Modify();
                        until recCustomerOrderLine.Next() = 0;
                end else begin
                    recTransSalesEn.Reset();
                    recTransSalesEn.SetRange("Store No.", TransactionHeader_p."Store No.");
                    recTransSalesEn.SetRange("POS Terminal No.", TransactionHeader_p."POS Terminal No.");
                    recTransSalesEn.SetRange("Transaction No.", TransactionHeader_p."Transaction No.");
                    if recTransSalesEn.Find('-') then
                        repeat
                            recItem.Get(recTransSalesEn."Item No.");
                            recItem.ItemSaleReserved := false;
                            recItem."Customer No." := '';
                            recItem.Modify();
                        until recTransSalesEn.Next() = 0;
                end;
            end;


        //merged 2 subs 280223 CITS_RS
        if TransactionHeader_p."Entry Status" <> TransactionHeader_p."Entry Status"::" " then exit;
        if TransactionHeader_p.Payment >= 0 then begin
            if (TransactionHeader_p."Customer No." <> '') or (TransactionHeader_p."Customer Order")
             or (TransactionHeader_p."Customer Order ID" <> '') then begin
                recSalesEn.Reset();
                recSalesEn.SetRange("Store No.", TransactionHeader_p."Store No.");
                recSalesEn.SetRange("POS Terminal No.", TransactionHeader_p."POS Terminal No.");
                recSalesEn.SetRange("Transaction No.", TransactionHeader_p."Transaction No.");
                if recSalesEn.Find('-') then
                    repeat
                        recItem.get(recSalesEn."Item No.");
                        if recItem."Is Advance" then exit;
                        recItem.Get(recSalesEn."Item No.");
                        recItem.ItemSaleReserved := true;
                        recItem."Customer No." := TransactionHeader_p."Customer No.";
                        recItem.Modify();
                    until recSalesEn.Next() = 0;
            end;
        end;

        //CITS_RS 290523
        recGenLedSetup.Get();
        if recGenLedSetup."Enable E-Invoice POS" then begin
            if (TransactionHeader_p."LSCIN GST Customer Type" <> TransactionHeader_p."LSCIN GST Customer Type"::" ") and (TransactionHeader_p."LSCIN GST Customer Type" <> TransactionHeader_p."LSCIN GST Customer Type"::Unregistered) then
                if (not TransactionHeader_p."Sale Is Return Sale") and (TransactionHeader_p.Payment >= 0)
                    and (TransactionHeader_p."Entry Status" = TransactionHeader_p."Entry Status"::" ") then
                    if (TransactionHeader_p."Customer Order ID" <> '') then begin
                        if CustomerOrderPosted(TransactionHeader_p) then//skipping customer roder creation transactions CITS_RS 280623
                            if not cuEInvoice.GenerateIRN_01(TransactionHeader_p) then
                                Message('Error %1 while generating E-Invoice', GetLastErrorText());
                    end else begin
                        if not cuEInvoice.GenerateIRN_01(TransactionHeader_p) then
                            Message('Error %1 while generating E-Invoice', GetLastErrorText());
                    end;
        end;

    end;

    procedure CustomerOrderPosted(PostedTransactionHeader: record 99001472): boolean
    var
        recPostedCustLine: record "LSC Posted Customer Order Line";
    begin
        recPostedCustLine.Reset();
        recPostedCustLine.SetRange("Document ID", PostedTransactionHeader."Customer Order ID");
        if recPostedCustLine.FindFirst() then
            exit(true)
        else
            exit(false);

    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Infocode Utility", 'OnBeforeIsInputOk', '', false, false)]
    procedure ValidatePhoneandOTP(InfoCodeRec: Record "LSC Infocode"; Input: Text; var ErrorTxt: Text; Line: Record "LSC POS Trans. Line"; var Canceled: Boolean; MgrKeyActive: Boolean; Training: Boolean; var TSError: Boolean; Quantity: Decimal; SerialNo: Code[50]; EntryVariantCode: Code[10]; SetPrice: Boolean; NewPrice: Decimal; LinkedLineInserted: Boolean; var EntryLineNo: Integer; var IsHandled: Boolean; var ReturnValue: Boolean)
    var
        cuPosTransLine: Codeunit 99001571;
        recPosLine: Record 99008981;
        POSTransaction: Record "LSC POS Transaction";
        recTransInfocodeEntry: Record "LSC Trans. Infocode Entry";
        recPosInfocodeEntry: Record "LSC POS Trans. Infocode Entry";
        recOtp: Record OTPEntries;
        CUFunctions: Codeunit Functions;
        recTransInfoEntry: record "LSC Trans. Infocode Entry";
        recCust: Record 18;
        recRetailSetup: Record "LSC Retail Setup";
        recCustOrderHeader: Record "LSC Customer Order Header";
        i: Integer;
        CUPOSTransaction: Codeunit "LSC POS Transaction";
        ErrorText: Text;
    begin
        recRetailSetup.Get();
        cuPosTransLine.GetCurrentLine(recPosLine);
        POSTransaction.Get(recPosLine."Receipt No.");
        case InfoCodeRec.Code of
            'GIFTCARDNO':
                begin
                    if POSTransaction."Customer No." = '' then begin
                        //error('Please assign a customer first!');//KKS Removed Hard Error
                        IsHandled := true;
                        ReturnValue := False;
                        CUPOSTransaction.PosMessage('Please assign a customer first!');
                        exit;
                    end;
                    recCust.get(POSTransaction."Customer No.");
                    // if Input <> recCust."Phone No." then
                    //     error('Please enter a valid Phone No. for Customer %1 %2', recCust."No.", recCust.Name);

                end;
            'GIFTCARDIN':
                begin
                    if not recRetailSetup."Enable SMS Integration" then exit;
                    if not POSTransaction."Customer Order" then begin
                        if POSTransaction."Customer No." = '' then begin
                            //error('Please assign a customer first!');//KKS Removed Hard Error
                            IsHandled := true;
                            ReturnValue := False;
                            CUPOSTransaction.PosMessage('Please assign a customer first!');
                            exit;
                        end;
                        recCust.get(POSTransaction."Customer No.");
                        if Input <> recCust."Phone No." then begin
                            //error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)//KKS Removed Hard Error
                            IsHandled := true;
                            ReturnValue := False;
                            CUPOSTransaction.PosMessage(StrSubstNo('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name));
                            exit;
                        end else
                            IF CUFunctions.CallSNSWCF(Input, POSTransaction, ErrorText) then begin
                                IsHandled := true;
                                ReturnValue := False;
                                CUPOSTransaction.PosMessage(ErrorText);
                                exit;
                            end;
                    end else
                        if POSTransaction."Customer Order" then begin
                            if recCustOrderHeader.Get(POSTransaction."Customer Order ID") then begin
                                recCust.get(recCustOrderHeader."Customer No.");
                                if Input <> recCust."Phone No." then begin
                                    //error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)//KKS Removed Hard Error
                                    IsHandled := true;
                                    ReturnValue := False;
                                    CUPOSTransaction.PosMessage(StrSubstNo('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name));
                                    exit;
                                end
                            end else begin
                                recCust.get(POSTransaction."Customer No.");
                                if Input <> recCust."Phone No." then begin
                                    //error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)//KKS Removed Hard Error
                                    IsHandled := true;
                                    ReturnValue := False;
                                    CUPOSTransaction.PosMessage(StrSubstNo('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name));
                                    exit;
                                end
                            end;
                            IF CUFunctions.CallSNSWCF(Input, POSTransaction, ErrorText) then begin
                                IsHandled := true;
                                ReturnValue := False;
                                CUPOSTransaction.PosMessage(ErrorText);
                                exit;
                            end;
                        end;
                end;
            'MOBOTP':
                begin
                    if not recRetailSetup."Enable SMS Integration" then exit;
                    recOtp.Reset();
                    recOtp.SetRange("Receipt No.", POSTransaction."Receipt No.");
                    if recOtp.FindLast() then
                        // if Input <> POSTransaction."Phone OTP" then

                        if Input <> recOtp.OTP then begin
                            // Error('Please enter a valid OTP');//KKS Removed Hard Error
                            IsHandled := true;
                            ReturnValue := False;
                            CUPOSTransaction.PosMessage('Please enter a valid OTP');
                            exit;
                        end
                end;
            'ADVANCENO':
                begin
                    if POSTransaction."Customer No." = '' then begin
                        //error('Please assign a customer first!');//KKS Removed Hard Error
                        IsHandled := true;
                        ReturnValue := False;
                        CUPOSTransaction.PosMessage('Please assign a customer first!');
                        exit;
                    end;
                    recCust.get(POSTransaction."Customer No.");
                    if Input <> recCust."Phone No." then begin
                        //error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)//KKS Removed Hard Error
                        IsHandled := true;
                        ReturnValue := False;
                        CUPOSTransaction.PosMessage(StrSubstNo('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name));
                        exit;
                    end

                end;
            'ADVANCEIN':
                begin
                    if not POSTransaction."Customer Order" then begin
                        if POSTransaction."Customer No." = '' then begin
                            //error('Please assign a customer first!');//KKS Removed Hard Error
                            IsHandled := true;
                            ReturnValue := False;
                            CUPOSTransaction.PosMessage('Please assign a customer first!');
                            exit;
                        end;
                        recCust.get(POSTransaction."Customer No.");
                        if Input <> recCust."Phone No." then begin
                            //error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)//KKS Removed Hard Error
                            IsHandled := true;
                            ReturnValue := False;
                            CUPOSTransaction.PosMessage(StrSubstNo('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name));
                            exit;
                        end
                    end else
                        if POSTransaction."Customer Order" then begin
                            if recCustOrderHeader.Get(POSTransaction."Customer Order ID") then begin
                                recCust.get(recCustOrderHeader."Customer No.");
                                if Input <> recCust."Phone No." then begin
                                    //error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)//KKS Removed Hard Error
                                    IsHandled := true;
                                    ReturnValue := False;
                                    CUPOSTransaction.PosMessage(StrSubstNo('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name));
                                    exit;
                                end
                            end else begin
                                recCust.get(POSTransaction."Customer No.");
                                if Input <> recCust."Phone No." then begin
                                    //error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)//KKS Removed Hard Error
                                    IsHandled := true;
                                    ReturnValue := False;
                                    CUPOSTransaction.PosMessage(StrSubstNo('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name));
                                    exit;
                                end
                            end;
                        end;
                    recTransInfocodeEntry.Reset();
                    recTransInfocodeEntry.SetFilter(Infocode, 'ADVANCENO');
                    recTransInfocodeEntry.SetFilter(Information, Input);
                    if recTransInfocodeEntry.FindLast() then
                        if POSTransaction."Store No." <> recTransInfocodeEntry."Store No." then begin
                            //Error('Advance was booked in store %1 and cannot be redeemed in a different store', recTransInfocodeEntry."Store No.");//KKS Removed Hard Error
                            IsHandled := true;
                            ReturnValue := False;
                            CUPOSTransaction.PosMessage(StrSubstNo('Advance was booked in store %1 and cannot be redeemed in a different store', recTransInfocodeEntry."Store No."));
                            exit;
                        end;
                end;
            'LINECOMMENT':
                begin
                    if (recPosLine."Entry Type" = recPosLine."Entry Type"::Item) or
                        (recPosLine."Entry Type" = recPosLine."Entry Type"::IncomeExpense) then begin
                        recPosLine."POS Comment" := Input;
                        recPosLine.Modify(false);
                    end;
                end;
        end;
        /*if InfoCodeRec.Code = 'GIFTCARDNO' then begin
            if POSTransaction."Customer No." = '' then error('Please assign a customer first!');
            recCust.get(POSTransaction."Customer No.");
            if Input <> recCust."Phone No." then
                error('Please enter a valid Phone No. for Customer %1 %2', recCust."No.", recCust.Name);
        end else
            if InfoCodeRec.Code = 'GIFTCARDIN' then begin
                recTransInfocodeEntry.Reset();
                recTransInfocodeEntry.SetFilter(Infocode, 'GIFTCARDNO');
                recTransInfocodeEntry.SetFilter(Information, Input);
                if recTransInfocodeEntry.FindLast() then
                    if POSTransaction."Store No." <> recTransInfocodeEntry."Store No." then
                        Error('Advance was booked in another store');

                if not recRetailSetup."Enable SMS Integration" then exit;
                if not POSTransaction."Customer Order" then begin
                    if POSTransaction."Customer No." = '' then error('Please assign a customer first!');
                    recCust.get(POSTransaction."Customer No.");
                    if Input <> recCust."Phone No." then
                        error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)
                    else
                        CUFunctions.CallSNSWCF(Input, POSTransaction);
                end else
                    if POSTransaction."Customer Order" then begin
                        if recCustOrderHeader.Get(POSTransaction."Customer Order ID") then begin
                            recCust.get(recCustOrderHeader."Customer No.");
                            if Input <> recCust."Phone No." then
                                error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name)
                        end else begin
                            recCust.get(POSTransaction."Customer No.");
                            if Input <> recCust."Phone No." then
                                error('Please enter a valid Phone No. for Customer %1 %2 ', recCust."No.", recCust.Name);
                        end;
                        CUFunctions.CallSNSWCF(Input, POSTransaction);//if no error found call WCF
                    end;
            end else
                if InfoCodeRec.Code = 'MOBOTP' then begin

                    if not recRetailSetup."Enable SMS Integration" then exit;
                    recOtp.Reset();
                    recOtp.SetRange("Receipt No.", POSTransaction."Receipt No.");
                    if recOtp.FindLast() then
                        // if Input <> POSTransaction."Phone OTP" then
                        if Input <> recOtp.OTP then
                            Error('Please enter a valid OTP');
                    // CUPosTransaction.ErrorBeep(StrSubstNo('Please enter a valid Infocode for Customer %1', POSTransaction."Customer No."));

                end;*/
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterPostTransaction', '', false, false)]
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnBeforeTransactionTendered', '', false, false)]

    // procedure OnBeforeTransactionTendered(var POSTransaction: Record "LSC POS Transaction"; var TenderType: Record "LSC Tender Type"; var VoidInProcess: Boolean; var Balance: Decimal)

    // [EventSubscriber(ObjectType::Table, Database::"LSC Posted Customer Order Line", 'OnAfterInsertEvent', '', false, false)]
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnAfterProcessTransForPostingByState', '', false, false)]
    // procedure OnAfterProcessTransForPostingByState(var POSTrans: Record "LSC POS Transaction")
    // POSTransactionEvents.OnAfterCommitPaymentLine(REC, LineRec, TenderType.Code);


    // POSTransactionEvents.OnBeforeInsertPaymentLine(REC, NewLine, CurrInput, TenderType.Code, Balance, PaymentAmount, STATE, isHandled);


    // OnBeforeTotalExecuted(var POSTransaction: Record "LSC POS Transaction"; var IsHandled: Boolean)
    /*//Commented 280223 CITS_RS(merged with another function)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeTotalExecuted', '', false, false)]
    procedure IsItemStaffAssigned(var POSTransaction: Record "LSC POS Transaction"; var IsHandled: Boolean)
    var
        recPosLine: Record 99008981;
    begin
        recPosLine.Reset();
        recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
        recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item);
        recPosLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
        // recPosLine.SetFilter("Sales Staff",'=%1','');
        if recPosLine.Find('-') then
            repeat
                if recPosLine."Sales Staff" = '' then
                    Error('Please assign sales staff on line %1', recPosLine."Line No." / 10000);
            until recPosLine.Next() = 0;
    end;*/

    // [EventSubscriber(ObjectType::Table, Database::"LSC Pos Trans. Line", 'OnAfterInsertEvent', '', false, false)]
    //****Not in use ****
    /*
    procedure ValidateStaffOnPosLineInserted(var Rec: Record 99008981)
    var
        recCustHeader: Record "LSC Customer Order Header";
        recHeader: Record "LSC POS Transaction";
        recCustLine: Record "LSC Customer Order Line";
    begin
        if Rec."Entry Status" <> Rec."Entry Status"::" " then exit;
        if rec."Entry Type" <> rec."Entry Type"::Item then exit;
        recHeader.Get(Rec."Receipt No.");

        if recHeader."Customer Order ID" <> '' then begin
            recCustHeader.Get(recHeader."Customer Order ID");
            recCustLine.Reset();
            recCustLine.SetRange("Document ID", recCustHeader."Document ID");
            recCustLine.SetFilter("POS Sales Associate", '<>%1', '');
            if recCustLine.Find('-') then begin
                repeat
                    Rec.validate("Sales Staff", recCustLine."POS Sales Associate");
                    Rec.Modify();
                until recCustLine.Next() = 0;
            end;
        end;
    end;*/


    /*commented CITS_RS 280223(Merged wth another function)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnBeforeCreatePosTrans', '', false, false)]//disabled 160223
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnAfterCreatePosTrans', '', false, false)]

    procedure UpdateCustomerStateinPOSHeader(var POSTransaction: Record "LSC POS Transaction"; var CustomerOrderHeaderTmp: Record "LSC Customer Order Header" temporary);
    // procedure UpdateCustomerStateinPOSHeader(var POSTransLine: Record "LSC POS Trans. Line")
    //     var POSTransaction: Record "LSC POS Transaction";
    //     var COHeaderTemp: Record "LSC Customer Order Header" temporary;
    //     var COLineTemp: Record "LSC Customer Order Line" temporary;
    //     var CODiscLineTemp: Record "LSC CO Discount Line" temporary;
    //     var ReceiptNo: Code[20];
    //     var ErrorCode: Code[30];
    //     var ErrorText: text;
    //     var COPaymentTemp: Record "LSC Customer Order Payment" temporary;
    //     var Returnvalue: Boolean;
    //     var Handled: Boolean)
    var
        recCustomer: Record 18;
        recCustomerOrderLine: Record "LSC Customer Order Line";
        recCustomerOrderHeader: Record "LSC Customer Order Header";
        recHeader: Record "LSC POS Transaction";
    begin
        // if recCustomerOrderHeader.Get(CustomerOrderHeaderTmp."Document ID") then begin
        //     recCustomerOrderHeader."Transfer Orders" := 1;
        //     recCustomerOrderHeader.Modify();
        //     recCustomerOrderLine.Reset();
        //     recCustomerOrderLine.SetRange("Document ID", recCustomerOrderHeader."Document ID");
        //     if recCustomerOrderLine.Find('-') then
        //         repeat
        //             recCustomerOrderLine."Inventory Transfer" := false;
        //             recCustomerOrderLine.Modify();
        //         until recCustomerOrderLine.Next() = 0;
        // end;
        recCustomer.get(CustomerOrderHeaderTmp."Customer No.");
        recHeader.Get(POSTransaction."Receipt No.");
        recHeader.validate("LSCIN State", recCustomer."State Code");
        recHeader.Validate("Customer No.", recCustomer."No.");
        POSTransaction.validate("LSCIN State", recCustomer."State Code");
        POSTransaction.validate("Customer No.", recCustomer."No.");
    end;*/

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnAfterCreatePosTrans', '', false, false)]
    //Not in use 
    /*
    procedure UpdateCustomerStateinPOSHeader_(var POSTransLine: Record "LSC POS Trans. Line";
        var POSTransaction: Record "LSC POS Transaction";
        var COHeaderTemp: Record "LSC Customer Order Header" temporary;
        var COLineTemp: Record "LSC Customer Order Line" temporary;
        var CODiscLineTemp: Record "LSC CO Discount Line" temporary;
        var ReceiptNo: Code[20];
        var ErrorCode: Code[30];
        var ErrorText: text;
        var COPaymentTemp: Record "LSC Customer Order Payment" temporary;
        var Returnvalue: Boolean;
        var Handled: Boolean)
    var
        recCustomer: Record 18;
        recCustomerOrderLine: Record "LSC Customer Order Line";
        recCustomerOrderHeader: Record "LSC Customer Order Header";
        recHeader: Record "LSC POS Transaction";
    begin
        if recCustomerOrderHeader.Get(COHeaderTemp."Document ID") then begin
            recCustomerOrderHeader."Transfer Orders" := 1;
            recCustomerOrderHeader.Modify();
            recCustomerOrderLine.Reset();
            recCustomerOrderLine.SetRange("Document ID", recCustomerOrderHeader."Document ID");
            if recCustomerOrderLine.Find('-') then
                repeat
                    recCustomerOrderLine."Inventory Transfer" := false;
                    recCustomerOrderLine.Modify();
                until recCustomerOrderLine.Next() = 0;
        end;
    end;*/

    // OnAfterCreatePosTrans(
    //     var POSTransLine: Record "LSC POS Trans. Line";
    //     var POSTransaction: Record "LSC POS Transaction";
    //     var COHeaderTemp: Record "LSC Customer Order Header" temporary;
    //     var COLineTemp: Record "LSC Customer Order Line" temporary;
    //     var CODiscLineTemp: Record "LSC CO Discount Line" temporary;
    //     var ReceiptNo: Code[20];
    //     var ErrorCode: Code[30];
    //     var ErrorText: text;
    //     var COPaymentTemp: Record "LSC Customer Order Payment" temporary;
    //     var Returnvalue: Boolean;
    //     var Handled: Boolean)

    // OnBeforeCreatePosTrans(var POSTransaction: Record "LSC POS Transaction"; var CustomerOrderHeaderTmp: Record "LSC Customer Order Header" temporary);
    // OnBeforeCreateCOPosTransLine

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnAfterInsertItemPosTransLine', '', false, false)]

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInsertEvent', '', false, false)]
    procedure PurchaseCreated()
    var
        i: Integer;
    begin
        i := 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnAfterCreatePosTrans', '', false, false)]
    // OnAfterCreatePosTrans
    // local procedure InsertGSTValuesinRetrievedCO(var POSTransLine: Record "LSC POS Trans. Line"; var POSTransaction: Record "LSC POS Transaction"; var COHeaderTemp: Record "LSC Customer Order Header"; var COLineTemp: Record "LSC Customer Order Line"; var CODiscLineTemp: Record "LSC CO Discount Line"; var ReceiptNo: Code[20]; var ErrorCode: Code[30]; var ErrorText: Text; var COPaymentTemp: Record "LSC Customer Order Payment"; var Returnvalue: Boolean; var Handled: Boolean);
    local procedure InsertGSTValuesinRetrievedCO(var POSTransLine: Record "LSC POS Trans. Line";
        var POSTransaction: Record "LSC POS Transaction";
        var COHeaderTemp: Record "LSC Customer Order Header" temporary;
        var COLineTemp: Record "LSC Customer Order Line" temporary;
        var CODiscLineTemp: Record "LSC CO Discount Line" temporary;
        var ReceiptNo: Code[20];
        var ErrorCode: Code[30];
        var ErrorText: text;
        var COPaymentTemp: Record "LSC Customer Order Payment" temporary;
        var Returnvalue: Boolean;
        var Handled: Boolean)
    var
        cuCalcTax: Codeunit 10044506;
        recTransactionHeader: Record 99001472;
        recCustOrderHeader: Record "LSC Customer Order Header";
        recCustOrderLine: Record "LSC Customer Order Line";
        recPosLine: Record 99008981;
        //recPosHeader: Record "LSC POS Transaction";
        recStore: Record 99001470;
        recCustomer: Record 18;
    begin
        recCustOrderHeader.Get(COHeaderTemp."Document ID");
        recCustOrderLine.Reset();
        recCustOrderLine.SetRange("Document ID", recCustOrderHeader."Document ID");
        if recCustOrderLine.find('-') then
            repeat
                recPosLine.Reset();
                recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
                recPosLine.SetFilter("Entry Type", '=%1|%2', recPosLine."Entry Type"::Item, recPosLine."Entry Type"::IncomeExpense);
                recPosLine.SetRange("Receipt No.", POSTransLine."Receipt No.");
                recPosLine.SetRange("Line No.", recCustOrderLine."Line No.");
                recPosLine.SetFilter("CO Prepayment Line", '=%1', false);
                if recPosLine.Find('-') then begin
                    // repeat
                    recPosLine.validate("Sales Staff", recCustOrderLine."POS Sales Associate");
                    recPosLine."POS Comment" := recCustOrderLine."POS Comment";//050523 CITS_RS
                    // recPosLine.validate("LSCIN GST Place of Supply", COLineTemp."LSCIN GST Place of Supply");
                    recPosLine.validate("LSCIN GST Group Code", recCustOrderLine."LSCIN GST Group Code");
                    recPosLine.validate("LSCIN GST Group Type", recCustOrderLine."LSCIN GST Group Type");
                    recPosLine.validate("LSCIN HSN/SAC Code", recCustOrderLine."LSCIN HSN/SAC Code");
                    recPosLine.validate("LSCIN Exempted", recCustOrderLine."LSCIN Exempted");
                    recPosLine.validate("LSCIN Price Inclusive of Tax", recCustOrderLine."LSCIN Price Inclusive of Tax");
                    recPosLine.validate("LSCIN Unit Price Incl. of Tax", recCustOrderLine."LSCIN Unit Price Incl. of Tax");
                    recPosLine.validate("LSCIN GST Amount", recCustOrderLine."LSCIN GST Amount");
                    recPosLine.Modify();
                    // Message('order found');
                    // until recPosLine.Next() = 0;
                end;
            until recCustOrderLine.Next() = 0;
        if COHeaderTemp."Partial Payment" then begin//160322 CITS_RS
            /* recPosHeader.Get(POSTransaction."Receipt No.");
            recPosHeader."Partial Payment" := true;
            // recPosHeader."LSCIN GST Customer Type" := COHeaderTemp."GST Customer Type";//200423
            recPosHeader.Modify(false); *///310523 added false as param
            POSTransaction."Partial Payment" := true;
            POSTransaction.Modify(false);//KKS POS Transaction Error
        end;// else begin//200423 marking customer type from previous posted Customer Order Transaction
        recTransactionHeader.Reset();
        recTransactionHeader.SetRange("Store No.", POSTransaction."Store No.");
        recTransactionHeader.SetRange("POS Terminal No.", POSTransaction."POS Terminal No.");
        recTransactionHeader.SetFilter("Customer Order ID", '=%1', COHeaderTemp."Document ID");
        if recTransactionHeader.FindFirst() then begin
            /* recPosHeader.Get(POSTransaction."Receipt No.");
            recPosHeader."LSCIN GST Customer Type" := recTransactionHeader."LSCIN GST Customer Type";//200423

            //140623
            recCustOrderHeader.Get(COHeaderTemp."Document ID");
            recCustomer.get(recCustOrderHeader."Customer No.");
            if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then
                recPosHeader."LSCIN State" := recTransactionHeader."LSCIN State";
            //140623
            recPosHeader.Modify(); */
            POSTransaction."LSCIN GST Customer Type" := recTransactionHeader."LSCIN GST Customer Type";//200423

            //140623
            recCustOrderHeader.Get(COHeaderTemp."Document ID");
            recCustomer.get(recCustOrderHeader."Customer No.");
            if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then
                POSTransaction."LSCIN State" := recTransactionHeader."LSCIN State";
            //140623
            POSTransaction.Modify();//KKS POS Transaction Error
        end;

        //140623
        // recCustOrderHeader.Get(POSTransaction."Customer Order ID");
        // recCustomer.get(recCustOrderHeader."Customer No.");
        // if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
        //     // POSTransaction.validate("LSCIN State", recStore."LSCIN State Code");
        //     recPosHeader.Get(POSTransaction."Receipt No.");
        //     recPosHeader.validate("LSCIN State", recStore."LSCIN State Code");
        //     // recPosHeader."LSCIN GST Customer Type" := COHeaderTemp."GST Customer Type";//200423
        //     recPosHeader.Modify(false);
        // end;

        // POSTransLine."Retail Charge Code" := 'A';
        //cuCalcTax.CalculateTaxOnSelectedLine(POSTransaction, POSTransLine, true);
        //cuCalcTax.RecalculateTaxForAllLines(POSTransaction, POSTransLine);
        //cuCalcTax.CalculatePOSTransLineAmount(POSTransLine);
        //POSTransLine.Validate(Number, POSTransLine.Number);
        //POSTransLine.Modify();
        // Message(GetLastErrorText());
        // Message('GST Amt: %1', POSTransaction."LSCIN GST Amount");
        // Message('Disc. Amt: %1', CODiscLineTemp."Discount Amount");
        // Message('Trans Line Gst Amt: %1', POSTransLine."LSCIN GST Amount");


    end;
    // OnAfterInsertPaymentLine(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var TenderTypeCode: Code[10])

    [EventSubscriber(ObjectType::Table, Database::SalesInvoice_Realtime, 'OnAfterInsertEvent', '', false, false)]
    procedure CallS3API_OnSalesInvoiceInsert(Rec: Record SalesInvoice_Realtime)
    var
        CU: Codeunit "Custom Events";
        cuFunctions: Codeunit Functions;
    begin
        if not CU.CallS3API_OnSalesInvoiceInsertforerrorlog(Rec) then begin
            //cuFunctions.CreateErrorLog(14, copystr(GetLastErrorText(), 1, 1000), Rec."Entry No.", '', '', Format(Rec.order_id));
            cuFunctions.CreateErrorLogSO(copystr(GetLastErrorText(), 1, 1000), Rec."Entry No.", '', '', Format(Rec.order_id));
            Rec."Record Status" := Rec."Record Status"::Error;
            Rec.Modify();
        end else begin
            Rec."Record Status" := Rec."Record Status"::Created;
            Rec.Modify();
        end;
    end;

    [TryFunction]
    procedure CallS3API_OnSalesInvoiceInsertforerrorlog(Rec: Record SalesInvoice_Realtime)
    var
        txtresult: Text;
        cuFunctions: codeunit Functions;
        SIHeader: Record 112;
        TotalId: Integer;
        DetailId: Text;
        IntDetailID: Integer;
        AllDetailID: Code[100];
        Strlenth: Integer;
        i: Integer;
        recRetailSet: Record "LSC Retail Setup";
        j: Integer;
        Chara: Text;
        Salhdr: Record 36;
        SalLine: Record 37;
        SLine: Record 37;
        SLine1: Record 37;
        SLine2: Record 37;
        SLineOP: Record 37;
        SLineMulStatus: Record 37;
        SLineClr: Record 37;
        salesheader1: Record 36;
        salesheader2: Record 36;
        salesheader3: Record 36;
        salesheader4: Record 36;
        SalHdrExpo: Record 36;
        SH1: Record 36;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        Cust: Record 18;
        Country: Record "Country/Region";
        StateTab: Record State;
        ShipToAdd: Record "Ship-to Address";
        Custstate: code[30];
        Shiptocodee: Code[40];
        CountryCode: Code[20];
        StateCode: Code[20];
        Locations: Record Location;
        FCint: Integer;
        recSalesINvoiceRT: Record SalesInvoice_Realtime;
        LineNo1: Integer;
        ItemChargeAssignment: Record "Item Charge Assignment (Sales)";
        ItemChargeAssignment1: Record "Item Charge Assignment (Sales)";
        SalesShpHdr: Record "Sales Shipment Header";
        salesshpLine: Record "Sales Shipment Line";
        SalesInvoiceHdr: Record "Sales Invoice Header";
        NOSeriesMgmt: Codeunit NoSeriesManagement;
        Store: Record "LSC Store";
        SalesReceiveblesetup: Record "Sales & Receivables Setup";
    begin
        //For Reopening of sales order>>>>>>>


        salesheader1.Reset();
        salesheader1.SetRange("Document Type", salesheader1."Document Type"::Order);
        salesheader1.SetRange("No.", Format(Rec.Order_ID));
        salesheader1.SetRange(Status, salesheader1.Status::Released);
        if salesheader1.FindFirst() then begin
            salesheader1.Validate(Status, salesheader1.Status::Open);
            salesheader1.Modify(true);
        end;

        //For clear qtytoship of sales line //>>>>>>>>
        SLineClr.Reset();
        SLineClr.SetRange("Document Type", SLineClr."Document Type"::Order);
        SLineClr.SetRange("Document No.", Format(Rec.Order_ID));
        SLineClr.SetFilter("Qty. to Ship", '<>%1', 0);
        if SLineClr.FindSet(true) then
            repeat
                SLineClr.Validate("Qty. to Ship", 0);
                SLineClr.Modify(true);
            until SLineClr.Next() = 0;
        //>>>>>>>>>>>>

        Clear(i);
        Clear(j);
        TotalId := 0;
        Strlenth := StrLen(Format(Rec.order_details_id));
        for i := 1 TO Strlenth do begin
            Chara := CopyStr(Format(Rec.order_details_id), i, 1);
            if Chara = ',' then
                TotalId += 1;
        end;
        Message('Total detailIDs :%1', TotalId + 1);

        if TotalId > 0 then begin
            For j := 1 TO TotalId + 1 do begin
                DetailId := SelectStr(j, Format(Rec.order_details_id));
                Evaluate(IntDetailID, DetailId);
                // Salhdr.Reset();
                // Salhdr.SetRange("Document Type", Salhdr."Document Type"::Order);
                // Salhdr.SetRange("No.", Format(Rec.Order_ID));
                // if Salhdr.FindFirst() then begin
                SalLine.Reset();
                SalLine.SetRange("Document Type", SalLine."Document Type"::Order);
                SalLine.SetRange("Document No.", Format(Rec.Order_ID));
                SalLine.SetRange("Line No.", IntDetailID);
                if SalLine.FindFirst() then begin
                    SalLine.Validate("Qty. to Ship", 1);
                    SalLine.Validate("Shipping Status", 'SHIP');

                    //Added110723>>>>>>>>>>>
                    if Rec.fc_id <> '' then begin
                        Evaluate(FCint, Rec.fc_id);
                        Locations.Reset();
                        Locations.SetRange("fc_location ID", FCint);
                        if Locations.FindFirst() then
                            SalLine.Validate("Location Code", Locations.Code);
                    end;
                    SalLine.Modify();
                end;
                // end;
            end;
        end else begin
            Evaluate(IntDetailID, Rec.order_details_id);
            // Salhdr.Reset();
            // Salhdr.SetRange("Document Type", Salhdr."Document Type"::Order);
            // Salhdr.SetRange("No.", Format(Rec.Order_ID));
            // if Salhdr.FindFirst() then begin
            SalLine.Reset();
            SalLine.SetRange("Document Type", SalLine."Document Type"::Order);
            SalLine.SetRange("Document No.", Format(Rec.Order_ID));
            SalLine.SetRange("Line No.", IntDetailID);
            if SalLine.FindFirst() then begin
                SalLine.Validate("Qty. to Ship", 1);
                SalLine.Validate("Shipping Status", 'SHIP');

                //Added110723>>>>>>>>>>>
                if Rec.fc_id <> '' then begin
                    Evaluate(FCint, Rec.fc_id);
                    Locations.Reset();
                    Locations.SetRange("fc_location ID", FCint);
                    if Locations.FindFirst() then
                        SalLine.Validate("Location Code", Locations.Code);
                end;

                SalLine.Modify();
            end;
            //  end;
        end;

        //ItemChargeassignment>>>>>>>>>>>>>>>>
        SLine1.Reset();
        SLine1.SetRange("Document Type", SLine1."Document Type"::Order);
        SLine1.SetRange("Document No.", Format(Rec.Order_ID));
        SLine1.SetFilter("Quantity Shipped", '>%1', 0);
        if not SLine1.FindFirst() then begin
            SLine2.Reset();
            SLine2.SetRange("Document Type", SLine1."Document Type"::Order);
            SLine2.SetRange("Document No.", Format(Rec.Order_ID));
            SLine2.SetFilter("Qty. to Ship", '>%1', 0);
            SLine2.SetFilter(Type, '<>%1', SLine2.Type::"Charge (Item)");
            if SLine2.FindFirst() then begin
                lineNo1 := SLine2."Line No.";
                SLine1.Reset();
                SLine1.SetRange("Document Type", SLine1."Document Type"::Order);
                SLine1.SetRange("Document No.", Format(Rec.Order_ID));
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
                            ItemChargeAssignment.Modify();
                            Message('Item Charge line inserted');
                        end;
                    until SLine1.Next() = 0; // end;
            end;
        end;

        //<<<<Posting>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        SLine.Reset();
        SLine.SetRange("Document Type", SLine."Document Type"::Order);
        SLine.SetRange("Document No.", Format(Rec.Order_ID));
        SLine.SetFilter("Qty. to Ship", '<>%1', 0);
        if SLine.FindFirst() then begin
            Clear(salesheader3);
            if salesheader3.Get(1, Format(Rec.Order_ID)) then begin
                //salesheader3.Validate(Status, salesheader3.Status::Released);
                //RealtimeCountryStateAddressUpdation>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                Clear(Shiptocodee);
                SalesReceiveblesetup.Get();
                Country.Reset();
                Country.SetRange(Name, Rec.Countryname);
                if Country.FindFirst() then
                    CountryCode := Country.Code;
                // StateTab.Reset();
                // StateTab.SetRange(Description, Rec.State);
                // if StateTab.FindFirst() then
                //     StateCode := StateTab.Code;
                StateCode := Rec.State;

                If Cust.Get(salesheader3."Sell-to Customer No.") then begin
                    Custstate := Cust."State Code";
                    if (CountryCode <> Cust."Country/Region Code") or (StateCode <> Cust."State Code")
                    or (Rec.PostCode <> cust."Post Code") or (Rec.City <> cust.City) then begin
                        Cust.Validate("Country/Region Code", CountryCode);
                        if CountryCode = 'IN' then begin
                            Cust."GST Customer Type" := Cust."GST Customer Type"::" ";
                            Cust.validate("State Code", StateCode);
                            Cust.Validate(Address, Rec.Address);
                            Cust.validate("Post Code", Rec.PostCode);
                            Cust.Validate(City, Rec.City);
                            if Rec."Gst Registration No." <> '' then begin
                                Cust.Validate("P.A.N. No.", Rec."PAN No.");
                                Cust.validate("GST Registration No.", Rec."Gst Registration No.");
                                //Cust.Validate("GST Customer Type", Cust."GST Customer Type"::Registered);
                                Cust."GST Customer Type" := Cust."GST Customer Type"::registered;
                            end else
                                Cust."GST Customer Type" := Cust."GST Customer Type"::Unregistered;
                            // Cust.Validate("GST Customer Type", Cust."GST Customer Type"::unRegistered);
                        end
                        else begin
                            Cust."GST Customer Type" := Cust."GST Customer Type"::" ";
                            // Cust.Validate("State Code", '');
                            Cust."State Code" := '';
                            Cust.Validate("GST Customer Type", cust."GST Customer Type"::Export);
                        end;
                        Cust.Modify();
                        // salesheader3.Validate("Sell-to Customer No.", Cust."No.");
                    end;
                    salesheader3.Validate("Sell-to Customer No.", Cust."No.");
                end;

                if (CountryCode = 'IN') AND (Rec.City <> salesheader3."Ship-to City") then begin
                    begin
                        ShipToAdd.Init();
                        ShiptoAdd."Customer No." := salesheader3."Sell-to Customer No.";
                        ShiptoAdd.Code := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Ship to Address no. Series", Today, true);
                        ShipToAdd.Validate(Name, Rec.Name);
                        ShipToAdd.Validate("Country/Region Code", 'IN');
                        ShipToAdd.validate(State, StateCode);
                        ShipToAdd.Validate("Post Code", Rec.PostCode);
                        ShipToAdd.Validate(City, rec.City);
                        ShipToAdd.validate(Address, Rec.Address);
                        if Rec."Gst Registration No." <> '' then
                            ShipToAdd.Validate("GST Registration No.", Rec."Gst Registration No.");
                        Shiptocodee := ShipToAdd.code;
                        ShipToAdd.insert();
                        Message('Shipto address(city) Updated');
                    end;
                end;
                if (CountryCode = 'IN') AND (StateCode = salesheader3.State) AND (Rec.City = salesheader3."Ship-to City") AND (Rec.PostCode <> salesheader3."Ship-to Post Code") then begin
                    ShipToAdd.Reset();
                    ShipToAdd.SetRange(code, salesheader3."Ship-to Code");
                    if ShipToAdd.FindFirst() then begin
                        ShipToAdd.Validate("Post Code", Rec.PostCode);
                        ShipToAdd.validate(Address, Rec.Address);
                        if Rec."Gst Registration No." <> '' then
                            ShipToAdd.Validate("GST Registration No.", Rec."Gst Registration No.");
                        Shiptocodee := ShipToAdd.code;
                        ShipToAdd.Modify();
                    end;
                end;

                if CountryCode <> 'IN' then begin
                    salesheader3.Validate("Bill-to Country/Region Code", CountryCode);
                    salesheader3.Validate(State, StateCode);
                    salesheader3.Validate("Bill-to Address", Rec.Address);
                    salesheader3.Validate("Bill-to City", Rec.City);
                    salesheader3.validate("Bill-to Post Code", Rec.PostCode);
                    salesheader3.Validate("Billing State", Rec.State);
                    salesheader3.Validate("Shipping State", Rec.State);
                    salesheader3."GST Without Payment of Duty" := Rec.GSTwithoutPaymentOfDuty;
                    salesheader3."GST Customer Type" := salesheader3."GST Customer Type"::Export;
                    if salesheader3."Gen. Bus. Posting Group" <> 'EXPORT' then
                        salesheader3."Gen. Bus. Posting Group" := 'EXPORT';
                end else begin
                    salesheader3.Validate("Bill-to Country/Region Code", CountryCode);
                    salesheader3.Validate(State, StateCode);
                    salesheader3.Validate("Bill-to Address", Rec.Address);
                    salesheader3.Validate("Bill-to City", Rec.City);
                    salesheader3.validate("Bill-to Post Code", Rec.PostCode);
                    salesheader3.Validate("Billing State", Rec.State);
                    salesheader3.Validate("Shipping State", Rec.State);
                    if salesheader3."Gen. Bus. Posting Group" <> 'DOMESTIC' then
                        salesheader3."Gen. Bus. Posting Group" := 'DOMESTIC';
                    if Rec."Gst Registration No." <> '' then
                        salesheader3."GST Customer Type" := salesheader3."GST Customer Type"::Registered;
                end;

                ShipToAdd.Reset();
                ShipToAdd.SetRange("Customer No.", salesheader3."Sell-to Customer No.");
                ShipToAdd.SetRange("Country/Region Code", CountryCode);
                ShipToAdd.SetRange(State, StateCode);
                ShipToAdd.SetRange(City, Rec.City);
                ShipToAdd.SetRange("Post Code", Rec.PostCode);
                if ShipToAdd.FindFirst() then
                    Shiptocodee := ShipToAdd.Code
                else begin
                    ShipToAdd.Init();
                    ShiptoAdd."Customer No." := salesheader3."Sell-to Customer No.";
                    ShiptoAdd.Code := NOSeriesMgmt.GetNextNo(SalesReceiveblesetup."Ship to Address no. Series", Today, true);
                    ShipToAdd.Validate(Name, Rec.Name);
                    ShipToAdd.Validate("Country/Region Code", CountryCode);
                    ShipToAdd.validate(State, StateCode);
                    ShipToAdd.Validate("Post Code", Rec.PostCode);
                    ShipToAdd.Validate(City, rec.City);
                    ShipToAdd.validate(Address, Rec.Address);
                    if Rec."Gst Registration No." <> '' then
                        ShipToAdd.Validate("GST Registration No.", Rec."Gst Registration No.");
                    Shiptocodee := ShipToAdd.code;
                    ShipToAdd.insert();
                    Message('Shipto address(export) created');
                end;
                //>>>>>>>>>>>>>
                if Shiptocodee <> '' then
                    salesheader3.Validate("Ship-to Code", Shiptocodee);
                //<<<<<<<<<<<<<<


                salesheader3.Validate(Status, salesheader3.Status::Released);
                salesheader3.Modify();
                salesheader3.PrepareOpeningDocumentStatistics();
                SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(salesheader3);
                salesheader3.Ship := true;
                salesheader3.Invoice := true;
                Commit();

                Rec.Processed := true;
                Rec.Modify();
                if Not postSalesOrderShipment(salesheader3) then begin
                    if GetLastErrorText() <> '' then begin
                        Message('%1', GetLastErrorText());
                        SalesShpHdr.Reset();
                        SalesShpHdr.SetRange("Order No.", Format(Rec.Order_ID));
                        if SalesShpHdr.FindLast() then begin
                            SalesShpHdr."No. Printed" := 1;
                            SalesShpHdr.Modify();
                            SalesShpHdr.Delete(true);
                        end;
                        SalesInvoiceHdr.Reset();
                        SalesInvoiceHdr.SetRange("Order No.", Format(Rec.Order_ID));
                        if SalesInvoiceHdr.FindLast() then begin
                            SalesInvoiceHdr."No. Printed" := 1;
                            SalesInvoiceHdr.Modify();
                            SalesInvoiceHdr.Delete(true);
                        end;

                        if salesheader4.Get(1, Format(Rec.Order_ID)) then begin
                            salesheader4.Validate(Status, salesheader4.Status::Open);
                            salesheader4.Modify();
                        end;
                        SLineOP.Reset();
                        SLineOP.SetRange("Document Type", SLineOP."Document Type"::Order);
                        SLineOP.SetRange("Document No.", Format(Rec.Order_ID));
                        //SLineOP.SetRange("Line No.", ActionStatus.SO_Detail_ID);
                        SLineOP.SetFilter("Quantity Shipped", '=%1', 0);
                        if SLineOP.FindFirst() then
                            repeat //begin
                                SLineOP.Validate("Qty. to Ship", 0);
                                SLineOP."Shipping Status" := 'OPEN';
                                //SLineOP.Modify(true);
                                SLineOP.Modify();
                            until SLineOP.Next() = 0; // end;
                        Message('%1', GetLastErrorText());
                    end;
                end else begin
                    Message('Sales order %1 posted', Format(Rec.Order_ID));
                end;
            end;

            //>>>>>>>>>>>>>>
            // if rec.Action_ID <> 12 then exit;

            recRetailSet.Get();
            recSalesINvoiceRT.Reset();
            recSalesINvoiceRT.SetRange(Order_ID, Rec.Order_ID);
            recSalesINvoiceRT.SetRange(Processed, false);
            if recSalesINvoiceRT.FindLast() then begin
                SIHeader.get(recSalesINvoiceRT.Invoice_Number);

                SIHeader.SetRecFilter();
                Report.SaveAsPdf(Report::"Sales Invoice", (recRetailSet."Sales Invoice Directory" + SIHeader."No." + '.pdf'), SIHeader);
                cuFunctions.UploadInvoicePDFtoS3Bucket(SIHeader);

            end;
        end;
    end;

    [TryFunction]
    procedure postSalesOrderShipment(Sh: Record "Sales Header")
    var
        myInt: Integer;
        SalesPost: Codeunit "Sales-Post";
        SH1: Record 36;
    begin
        Salespost.Run(Sh);
        // Message('Afterposting %1', GetLastErrorText());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeUpdateShipToCodeFromCust', '', false, false)]
    local procedure OnBeforeUpdateShipToCodeFromCust(var SalesHeader: Record "Sales Header"; var Customer: Record Customer; var IsHandled: Boolean);
    begin
        if SalesHeader."Location Code" = 'ONL' then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeRecreateSalesLinesHandler', '', false, false)]
    local procedure OnBeforeRecreateSalesLinesHandler(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; ChangedFieldName: Text[100]; var IsHandled: Boolean);
    begin
        if SalesHeader."Location Code" = 'ONL' then
            IsHandled := true;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc1(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean);
    var
        SInvRealTime: Record SalesInvoice_Realtime;
        Orderid: Integer;
    begin
        // Clear(glInvoiceNum);//Block by Naveen
        // Evaluate(Orderid, SalesHeader."No.");
        // SInvRealTime.Reset();
        // SInvRealTime.SetRange(Order_ID, Orderid);
        // SInvRealTime.SetRange(Processed, true);
        // if SInvRealTime.FindFirst() then begin
        //     SInvRealTime.Invoice_Number := SalesInvHdrNo;
        //     glInvoiceNum := SalesInvHdrNo;
        //     SInvRealTime.Processed := false;
        //     SInvRealTime.Modify();
        // end;//Block by Naveen

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnAfterCommitPaymentLine', '', false, false)]
    // OnAfterCommitPaymentLine(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; TenderType: Code[10])
    procedure DeleteDuplicateLine(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; TenderType: Code[10])
    var
        recPaymentLine: Record 99008981;
        arrAmt: array[999] of Decimal;
        arrLineNum: array[999] of integer;

        recDuplicate: Record 99008981;
        cuPosTrans: Codeunit 99001570;
        arrTender: array[999] of Code[10];
        i: Integer;
        j: Integer;
    begin
        if not POSTransaction."Customer Order" then exit;
        recPaymentLine.Reset();
        recPaymentLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
        recPaymentLine.SetRange("Entry Status", recPaymentLine."Entry Status"::" ");
        recPaymentLine.SetRange("Entry Type", recPaymentLine."Entry Type"::Payment);
        // recPaymentLine.SetRange("Customer Order Line", true);
        // recPaymentLine.SetRange("CO Prepayment Line", true);
        if recPaymentLine.Find('-') then
            repeat
                i += 1;
                arrTender[i] := recPaymentLine.Number;
                arrLineNum[i] := recPaymentLine."Line No.";
                arrAmt[i] := recPaymentLine.Amount;
            until recPaymentLine.Next() = 0;

        j += 1;
        if i > 1 then begin
            if arrTender[j] = arrTender[j + 1] then
                if arrAmt[j] = arrAmt[j + 1] then begin
                    // recDuplicate.Get(POSTransaction."Receipt No.", arrLineNum[j + 1]);
                    // recDuplicate.validate(Number, TenderType);
                    // recDuplicate.Modify();
                    recDuplicate.Get(POSTransaction."Receipt No.", arrLineNum[j]);
                    recDuplicate.VoidLine();
                    cuPosTrans.CalcTotals();
                end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"LSC POS Trans. Line", 'OnAfterInsertEvent', '', false, false)]
    procedure PmtLineInsrted(Rec: Record 99008981)
    var
        i: Integer;
    begin
        if Rec."Entry Status" = Rec."Entry Status"::" " then
            if Rec."Entry Type" = Rec."Entry Type"::Payment then
                i := 0;

    end;


    //Disabled 200223 CITS_RS  Issues in multiple lines
    // [EventSubscriber(ObjectType::Table, Database::"LSC Customer Order Line", 'OnBeforeInsertEvent', '', false, false)]
    /*  Not in use
    procedure InsertSalesStaffCOHeader(var Rec: Record "LSC Customer Order Line")
    var
        cuPosTransLine: codeunit "LSC Pos Trans. Lines";
        recPosLine: Record "LSC Pos Trans. Line";
        recPosLine1: Record "LSC Pos Trans. Line";
    begin
        cuPosTransLine.GetCurrentLine(recPosLine);
        //if recPosLine."Entry Status" <> recPosLine."Entry Status"::" " then exit;//?
        //if recPosLine."Entry Type" <> recPosLine."Entry Type"::Item then exit;//?
        recPosLine1.Reset();
        recPosLine1.SetRange("Receipt No.", recPosLine."Receipt No.");
        recPosLine1.SetRange("Entry Status", recPosLine1."Entry Status"::" ");
        // recPosLine1.setfilter("Entry Type",'=%1' ,recPosLine1."Entry Type"::Item);//
        recPosLine1.setfilter("Entry Type", '=%1|%2', recPosLine1."Entry Type"::Item, recPosLine1."Entry Type"::IncomeExpense); //170223
        recPosLine1.SetRange("Line No.", Rec."Line No.");
        if recPosLine1.Find('-') then begin
            // repeat
            Rec."POS Sales Associate" := recPosLine1."Sales Staff";
            // if recPosLine1."LSCIN GST Place of Supply" = recPosLine1."LSCIN GST Place of Supply"::" " then
            //  recPosLine
            Rec."LSCIN GST Place of Supply" := recPosLine1."LSCIN GST Place of Supply";
            Rec."LSCIN GST Group Code" := recPosLine1."LSCIN GST Group Code";
            Rec."LSCIN GST Group Type" := recPosLine1."LSCIN GST Group Type";
            Rec."LSCIN HSN/SAC Code" := recPosLine1."LSCIN HSN/SAC Code";
            Rec."LSCIN Exempted" := recPosLine1."LSCIN Exempted";
            Rec."LSCIN Price Inclusive of Tax" := recPosLine1."LSCIN Price Inclusive of Tax";
            Rec."LSCIN Unit Price Incl. of Tax" := recPosLine1."LSCIN Unit Price Incl. of Tax";
            Rec."LSCIN GST Amount" := recPosLine1."LSCIN GST Amount";
            // until recPosLine.Next() = 0;
        end;
    end;*/

    // OnBeforePrintCustomerOrder(var CustomerOrderHeaderTemp: Record "LSC Customer Order Header" temporary; var CustomerOrderLineTemp: Record "LSC Customer Order Line" temporary; var PrintBuffer: Record "LSC POS Print Buffer"; var PrintBufferIndex: Integer; var LinesPrinted: Integer; var DSTR1: Text[100]; var IsHandled: Boolean)

    //In testing phase 200223 disabled
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Print Utility", 'OnBeforePrintCustomerOrder', '', false, false)]
    /*  Not in use
    procedure InsertValuesCustomerOrder(var CustomerOrderHeaderTemp: Record "LSC Customer Order Header" temporary; var CustomerOrderLineTemp: Record "LSC Customer Order Line" temporary; var PrintBuffer: Record "LSC POS Print Buffer"; var PrintBufferIndex: Integer; var LinesPrinted: Integer; var DSTR1: Text[100]; var IsHandled: Boolean)
     var
         cuPosTransLines: Codeunit 99001571;
         recPosLine1: Record 99008981;
         recCustomerOrderLine: Record "LSC Customer Order Line";
         recCustomerOrderHeader: Record "LSC Customer Order Header";
         cuPostUtil: Codeunit "LSC Pos Post Utility";
         recPosHeader: Record "LSC POS Transaction";
         recPosLines: Record 99008981;
     begin
         cuPosTransLines.GetCurrentLine(recPosLine1);
         recPosLines.Reset();
         recPosLines.SetRange("Receipt No.", recPosLine1."Receipt No.");
         recPosLines.SetRange("Entry Status", recPosLines."Entry Status"::" ");
         // recPosLine1.setfilter("Entry Type",'=%1' ,recPosLine1."Entry Type"::Item);//
         recPosLines.setfilter("Entry Type", '=%1|%2', recPosLines."Entry Type"::Item, recPosLines."Entry Type"::IncomeExpense); //170223
         // recPosLines.SetRange("Line No.", Rec."Line No.");
         if recPosLines.Find('-') then
             repeat
                 recCustomerOrderLine.Reset();
                 recCustomerOrderLine.SetRange("Document ID", CustomerOrderHeaderTemp."Document ID");
                 recCustomerOrderLine.SetRange("Line No.", recPosLines."Line No.");
                 if recCustomerOrderLine.Find('-') then
                     repeat
                         recCustomerOrderLine."POS Sales Associate" := recPosLines."Sales Staff";
                         // if recPosLine1."LSCIN GST Place of Supply" = recPosLine1."LSCIN GST Place of Supply"::" " then
                         recCustomerOrderLine."LSCIN GST Place of Supply" := recPosLines."LSCIN GST Place of Supply";
                         recCustomerOrderLine."LSCIN GST Group Code" := recPosLines."LSCIN GST Group Code";
                         recCustomerOrderLine."LSCIN GST Group Type" := recPosLines."LSCIN GST Group Type";
                         recCustomerOrderLine."LSCIN HSN/SAC Code" := recPosLines."LSCIN HSN/SAC Code";
                         recCustomerOrderLine."LSCIN Exempted" := recPosLines."LSCIN Exempted";
                         recCustomerOrderLine."LSCIN Price Inclusive of Tax" := recPosLines."LSCIN Price Inclusive of Tax";
                         recCustomerOrderLine."LSCIN Unit Price Incl. of Tax" := recPosLines."LSCIN Unit Price Incl. of Tax";
                         recCustomerOrderLine."LSCIN GST Amount" := recPosLines."LSCIN GST Amount";
                         recCustomerOrderLine.Modify();
                     until recCustomerOrderLine.Next() = 0;
             until recPosLines.Next() = 0;
     end;*/

    // OnBeforeFinalizePaymentForCO(var CustomerOrderHeaderTemp: Record "LSC Customer Order Header" temporary; var CustomerOrderLineTemp: Record "LSC Customer Order Line" temporary; var CustomerOrderPaymentTemp: Record "LSC Customer Order Payment" temporary; var POSTransaction: Record "LSC POS Transaction"; var CustomerOrderDiscountLineTemp: Record "LSC CO Discount Line" temporary; CustomerOrderID: Code[20]; var Handled: Boolean)
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Print Utility", 'OnBeforeFinalizePaymentForCO', '', false, false)]
    // procedure InsertValuesCustomerOrderV2(var CustomerOrderHeaderTemp: Record "LSC Customer Order Header" temporary; var CustomerOrderLineTemp: Record "LSC Customer Order Line" temporary; var CustomerOrderPaymentTemp: Record "LSC Customer Order Payment" temporary; var POSTransaction: Record "LSC POS Transaction"; var CustomerOrderDiscountLineTemp: Record "LSC CO Discount Line" temporary; CustomerOrderID: Code[20]; var Handled: Boolean)
    // var
    // begin
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeInsertItemLine', '', false, false)]
    procedure RestrictItemPunch(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var CompressEntry: Boolean)
    var
        recitem: Record 27;
    begin
        //CITS_RS 220223++ Enforcing punching of alteration only after all items have been punched
        //KKS -4 Removed Hard Errors
        /*if not POSTransLine."Customer Order Line" then
            if IncExpLineExists(POSTransaction) then begin
                if POSTransLine."Entry Type" = POSTransLine."Entry Type"::Item then
                    Error('Please removed the alteration before punching items !');
            end;
        //CITS_RS 220223--

        recitem.Get(POSTransLine.Number);
        if recitem."Is Advance" then exit;
        
         if recitem.ItemSaleReserved then
            Error('Item %1 has already been sold in store %2', recitem.Description, POSTransaction."Store No.");

        if not recitem."Is Approved for Sale" then
            Error('Item %1 is not approved for sale. Please contact Finance Team', recitem.Description); */
        //KKS -4 
    end;

    procedure IncExpLineExists(RecHeader: Record "LSC POS Transaction"): Boolean
    var
        recPosLine: Record 99008981;
    begin
        recPosLine.Reset();
        recPosLine.SetRange("Receipt No.", RecHeader."Receipt No.");
        recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
        recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::IncomeExpense);
        if recPosLine.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    procedure SetActiveImage1(TableRecordID: RecordId)
    var
        RetailImage: Record "LSC Retail Image";
        RetailImageUtils: Codeunit "LSC Retail Image Utils";
        DisplayOrder:
                Integer;
        TenantMedia:
                Record "Tenant Media";
        CurrPage:
                Page "LSC Retail Image Link Factbox";
        Rec:
                Record "LSC Retail Image";
    begin
        Clear(TenantMedia);
        case CurrPage.Caption of
            'Store Logo', 'Retail Default Logo':
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::Logo, 0, TenantMedia);
            'QR Code for Direction', 'QR Code for Dining Table':
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::"QR Code", 0, TenantMedia);
            else
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::Image, 1, TenantMedia);
        end;
        if not TenantMedia.Content.HasValue then
            RetailImage.Init();

        Rec.DeleteAll;
        Rec.Init;
        Rec.Insert;
        CurrPage.Update(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'IGST Payment Status', false, false)]
    local procedure WithLUTnotcalculateGST(var Rec: Record "Sales Header")
    begin
        if Rec."IGST Payment Status" = Rec."IGST Payment Status"::"LUT or Export under Bond" then
            Rec."GST Without Payment of Duty" := true
        else
            Rec."GST Without Payment of Duty" := false;
        Rec.Modify(true);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    var
        recHeader: Record "LSC POS Transaction";
    begin
        BankAccountLedgerEntry."AZA Code" := GenJournalLine."AZA Code";
        BankAccountLedgerEntry.BarCode := GenJournalLine.BarCode;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order Subform", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure OnaftergetRecboolean(var Rec: Record "Purchase Line")
    begin
        if Rec."Short Close" = true then
            Rec.EditBool := false
        else
            Rec.EditBool := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"LSC Posted Customer Order Line", 'OnAfterInsertEvent', '', false, false)]
    procedure RevertCustomerOrderProduct(Rec: Record "LSC Posted Customer Order Line")
    var
        recitem: Record 27;
        recCustOrderPayment: Record "LSC Customer Order Payment";
    begin
        if (Rec.Status = Rec.Status::Canceled) and (rec."Line Type" = Rec."Line Type"::Item) then begin
            recitem.get(Rec.Number);
            recitem."Customer No." := '';
            // recitem."Customer Order ID" :=
            recitem.ItemSaleReserved := false;
            recitem."Cust. Phone No." := '';//30-01-23
            recitem."Blocked By User ID" := '';
            recitem."Blocked DateTime" := 0DT;
            recitem.Remarks := '';
            recitem.Modify();
            // CreateRefundLine();
        end;

    end;

    procedure CreateRefundLine_IncExp(POSTransaction: Record "LSC POS Transaction"; decAmttobeRefunded: Decimal)
    var
        recPosLine: Record 99008981;
        recStore: record 99001470;
        recCustOrderPayment: Record "LSC Customer Order Payment";
    begin
        /*recStore.Get(POSTransaction."Store No.");
        recPosLine.Init();
        if recPosLine.FindLast() then
            recPosLine."Line No." += 10000
        else
            // recPosLine."Line No." := 10000;
        recPosLine."Entry Status" := recPosLine."Entry Status"::" ";
        recPosLine."Entry Type" := recPosLine."Entry Type"::IncomeExpense;
        recPosLine.validate("Store No.", POSTransaction."Store No.");
        recPosLine.validate("POS Terminal No.", POSTransaction."POS Terminal No.");
        recPosLine.validate("Receipt No.", POSTransaction."Receipt No.");
        recPosLine.validate(Number, '8');
        recPosLine.Description := 'Customer Order Refund Line';
        recPosLine.validate(Price, -(decAmttobeRefunded));
        recPosLine.validate("Net Price", -(decAmttobeRefunded));
        recPosLine.validate(Amount, -(decAmttobeRefunded));
        recPosLine.validate(Quantity, 1);
        recPosLine.validate("VAT Code", 'A');
        recPosLine.validate("Net Amount", -(decAmttobeRefunded));
        recPosLine.validate("Vat Prod. Posting Group", 'ZERO');
        recPosLine.validate("Customer Order Line", true);
        recPosLine."CO Refund Line" := true;
        recPosLine.validate("CO Prepayment Line", true);
        recPosLine.Insert();*/
        recStore.get(POSTransaction."Store No.");
        recPosLine.Init;
        recPosLine."Receipt No." := POSTransaction."Receipt No.";
        recPosLine."Line No." := recPosLine."Line No." + 10000;
        recPosLine."Store No." := POSTransaction."Store No.";
        recPosLine."POS Terminal No." := POSTransaction."POS Terminal No.";
        recPosLine."Entry Type" := recPosLine."Entry Type"::IncomeExpense;
        recPosLine."Entry Status" := recPosLine."Entry Status"::" ";
        recPosLine.Validate(Number, recStore."Customer Order Inc/Expense Acc");
        recPosLine.Validate(Price, -(decAmttobeRefunded));
        recPosLine.Validate("Net Price", -(decAmttobeRefunded));
        recPosLine.Validate(Amount, -(decAmttobeRefunded));
        recPosLine.Validate("Net Amount", -(decAmttobeRefunded));
        recPosLine."Customer Order Line" := true;
        recPosLine."CO Prepayment Line" := true;
        // recPosLine.Marked := true;//080623
        recPosLine.Insert();

    end;

    // OnAfterSelectCustomer(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnAfterSelectCustomer', '', false, false)]
    procedure ChangeUnregCustState(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text)
    var
        recCustomer: Record 18;
        recStore: Record 99001470;
    //recPosHeader: Record "LSC POS Transaction";
    begin
        recStore.get(POSTransaction."Store No.");
        if recCustomer.get(POSTransaction."Customer No.") then begin
            if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
                POSTransaction.validate("LSCIN State", recStore."LSCIN State Code");
                // recPosHeader.Get(POSTransaction."Receipt No.");
                // recPosHeader.validate("LSCIN State", recStore."LSCIN State Code");
                // recPosHeader.Modify(false);//310523 added false as param
                // Commit();
            end;
            POSTransaction."Cust. Phone No." := recCustomer."Phone No.";
        end;
    end;



    // procedure OnBeforeTransactionTendered(var POSTransaction: Record "LSC POS Transaction"; var TenderType: Record "LSC Tender Type"; var VoidInProcess: Boolean; var Balance: Decimal)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnBeforeTransactionTendered', '', false, false)]
    procedure RecalcAlterationGST_Tendered(var POSTransaction: Record "LSC POS Transaction"; var TenderType: Record "LSC Tender Type"; var VoidInProcess: Boolean; var Balance: Decimal)
    var
        recGLAccount: Record 15;
        recStore: Record 99001470;
        cdGSTGroup: Code[10];
        decAmount: Decimal;
        cuPosTrans: codeunit 99001570;
        recCustomer: Record 18;
        decNewPrice: Decimal;
        decActualAmt: Decimal;
        //recPosHeader: Record "LSC POS Transaction";
        decGSTAmt: Decimal;
        recIncExpAccount: Record 99001476;
        Rec: Record 99008981;
        decGSTPer: Decimal;
    begin

        //CITS_RS 300523 If customer is unregistered then same state as store will be assigned as store location.
        recStore.get(POSTransaction."Store No.");

        if recCustomer.get(POSTransaction."Customer No.") then begin
            if recCustomer."GST Customer Type" = recCustomer."GST Customer Type"::Unregistered then begin
                POSTransaction.validate("LSCIN State", recStore."LSCIN State Code");
                /* recPosHeader.Get(POSTransaction."Receipt No.");
                recPosHeader.validate("LSCIN State", recStore."LSCIN State Code");
                recPosHeader.Modify(false); *///added false as param
                POSTransaction.validate("LSCIN State", recStore."LSCIN State Code");
                POSTransaction.Modify(false);//KKS POS Transaction Error
            end;
        end;//AS210823


        Clear(decGSTPer);
        Rec.Reset();
        Rec.SetRange("Receipt No.", POSTransaction."Receipt No.");
        Rec.SetRange("Entry Status", Rec."Entry Status"::" ");
        Rec.SetRange("Entry Type", Rec."Entry Type"::IncomeExpense);
        if Rec.FindFirst() then begin
            if rec."CO Prepayment Line" then exit;
            Clear(decGSTPer);
            // recStore.Get(POSTransaction."Store No.");
            if not recIncExpAccount.Get(Rec."Store No.", Rec.Number) then exit;
            if not recIncExpAccount."Alteration Account" then exit;//300323
            recGLAccount.Reset();
            recGLAccount.SetRange("No.", recIncExpAccount."G/L Account");
            if recGLAccount.FindFirst() then
                cdGSTGroup := recGLAccount."GST Group Code";

            case cdGSTGroup of
                'GST 12G':
                    begin
                        decGSTPer := 12
                    end;
                'GST 18G':
                    begin
                        decGSTPer := 18
                    end;
                'GST 28G':
                    begin
                        decGSTPer := 28
                    end;
                'GST 3G':
                    begin
                        decGSTPer := 3
                    end;
                'GST 5G':
                    begin
                        decGSTPer := 5
                    end;
            end;



            if (Rec."Entry Type" = Rec."Entry Type"::IncomeExpense) and
             (Rec."Entry Status" = Rec."Entry Status"::" ") and (Rec.Number = recIncExpAccount."No.") then begin
                decActualAmt := Rec.Price;

                // Original Cost – (Original Cost * (100 / (100 + GST% ) ) )
                // decGSTAmt := Rec.Price - (Rec.Price * (100 / (100 + decGSTPer)));
                decGSTAmt := Rec.Price - (Rec.Price * (100 / (100 + 12)));
                decGSTAmt := Round(decGSTAmt, 0.01, '=');
                // decAmount := Rec.Price;
                // decAmount := decAmount - ((decAmount * decGSTPer) / 100);
                decNewPrice := Rec.Price - decGSTAmt;
                decNewPrice := Round(decNewPrice, 0.01, '=');
                // if decActualAmt <= decNewPrice then begin
                //     Rec.Validate("Net Price", (decNewPrice + decGSTAmt));
                //     Rec.Validate(Amount, (decNewPrice + decGSTAmt));
                // end else begin
                // Rec.Validate("Net Price", decNewPrice);
                // Rec.Validate("Net Amount", decNewPrice);
                // Rec.Validate(Amount, Rec.Price);
                Rec."LSCIN Price Inclusive of Tax" := true;
                Rec.Price := Rec.Price;
                Rec."Net Price" := decNewPrice;
                Rec."Net Amount" := decNewPrice;
                Rec.Amount := decActualAmt;
                Rec.Quantity := 1;
                // Rec.Validate("LSCIN GST Group Type", Rec."LSCIN GST Group Type"::Service);
                // Rec.Validate("LSCIN GST Group Code", cdGSTGroup);
                // Rec.Validate("LSCIN GST Amount",decGSTAmt);
                Rec."LSCIN GST Group Type" := Rec."LSCIN GST Group Type"::Service;
                Rec."LSCIN GST Group Code" := 'GST 12G';
                Rec."LSCIN GST Amount" := decGSTAmt;
                Rec.Modify(false);
            end;
        end;

    end;

    // procedure OnAfterCalcTotals(var Rec: Record "LSC POS Transaction"; var Balance: Decimal; var RealBalance: Decimal)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnAfterCalcTotals', '', false, false)]
    procedure CalcAlterationGSTFinal(var Rec: Record "LSC POS Transaction"; var Balance: Decimal; var RealBalance: Decimal)
    var
        recGLAccount: Record 15;
        recStore: Record 99001470;
        cdGSTGroup: Code[10];
        decAmount: Decimal;
        cuPosTrans: codeunit 99001570;
        decNewPrice: Decimal;
        decActualAmt: Decimal;
        decGSTAmt: Decimal;
        recIncExpAccount: Record 99001476;
        RecLine: Record 99008981;
        decGSTPer: Decimal;
        alterationFOund: Boolean;
    begin
        Clear(alterationFOund);
        Clear(decGSTPer);
        RecLine.Reset();
        RecLine.SetRange("Receipt No.", Rec."Receipt No.");
        RecLine.SetRange("Entry Status", RecLine."Entry Status"::" ");
        RecLine.SetRange("Entry Type", RecLine."Entry Type"::IncomeExpense);
        if RecLine.FindFirst() then begin
            if RecLine."CO Prepayment Line" then exit;
            Clear(decGSTPer);
            // recStore.Get(POSTransaction."Store No.");
            if not recIncExpAccount.Get(RecLine."Store No.", RecLine.Number) then exit;
            if not recIncExpAccount."Alteration Account" then
                exit//300323
            else
                alterationFound := true;

            recGLAccount.Reset();
            recGLAccount.SetRange("No.", recIncExpAccount."G/L Account");
            if recGLAccount.FindFirst() then
                cdGSTGroup := recGLAccount."GST Group Code";

            case cdGSTGroup of
                'GST 12G':
                    begin
                        decGSTPer := 12
                    end;
                'GST 18G':
                    begin
                        decGSTPer := 18
                    end;
                'GST 28G':
                    begin
                        decGSTPer := 28
                    end;
                'GST 3G':
                    begin
                        decGSTPer := 3
                    end;
                'GST 5G':
                    begin
                        decGSTPer := 5
                    end;
            end;



            if (RecLine."Entry Type" = RecLine."Entry Type"::IncomeExpense) and
             (RecLine."Entry Status" = RecLine."Entry Status"::" ") and (RecLine.Number = recIncExpAccount."No.") then begin
                decActualAmt := RecLine.Price;

                // Original Cost – (Original Cost * (100 / (100 + GST% ) ) )
                // decGSTAmt := RecLine.Price - (RecLine.Price * (100 / (100 + decGSTPer)));
                decGSTAmt := RecLine.Price - (RecLine.Price * (100 / (100 + 12)));
                decGSTAmt := Round(decGSTAmt, 0.01, '=');
                // decAmount := RecLine.Price;
                // decAmount := decAmount - ((decAmount * decGSTPer) / 100);
                decNewPrice := RecLine.Price - decGSTAmt;
                decNewPrice := Round(decNewPrice, 0.01, '=');
                // if decActualAmt <= decNewPrice then begin
                //     RecLine.Validate("Net Price", (decNewPrice + decGSTAmt));
                //     RecLine.Validate(Amount, (decNewPrice + decGSTAmt));
                // end else begin
                // RecLine.Validate("Net Price", decNewPrice);
                // RecLine.Validate("Net Amount", decNewPrice);
                // RecLine.Validate(Amount, RecLine.Price);
                RecLine."LSCIN Price Inclusive of Tax" := true;
                RecLine.Price := RecLine.Price;
                RecLine."Net Price" := decNewPrice;
                RecLine."Net Amount" := decNewPrice;
                RecLine.Amount := decActualAmt;
                RecLine.Quantity := 1;
                // RecLine.Validate("LSCIN GST Group Type", RecLine."LSCIN GST Group Type"::Service);
                // RecLine.Validate("LSCIN GST Group Code", cdGSTGroup);
                // RecLine.Validate("LSCIN GST Amount",decGSTAmt);
                RecLine."LSCIN GST Group Type" := RecLine."LSCIN GST Group Type"::Service;
                RecLine."LSCIN GST Group Code" := 'GST 12G';
                RecLine."LSCIN GST Amount" := decGSTAmt;
                RecLine.Modify(false);
            end;
            if alterationFound then
                if Balance < 0 then
                    Balance := 0;
        end;


    end;



    // procedure OnAfterTenderKeyPressedEx(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var TenderTypeCode: Code[10]; var TenderAmountText: Text; var IsHandled: Boolean)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnAfterTenderKeyPressedEx', '', false, false)]
    procedure RecalcAlterationGST_TenderKey(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var TenderTypeCode: Code[10]; var TenderAmountText: Text; var IsHandled: Boolean)
    var
        recGLAccount: Record 15;
        recStore: Record 99001470;
        cdGSTGroup: Code[10];
        decAmount: Decimal;
        cuPosTrans: codeunit 99001570;
        decNewPrice: Decimal;
        decActualAmt: Decimal;
        decGSTAmt: Decimal;
        recIncExpAccount: Record 99001476;
        decItemAmt: Decimal;
        decCancelledAmt: Decimal;
        recILE: Record 32;
        decIncExpAmt: Decimal;
        decAdvanceAmt: Decimal;
        recCOHeader: Record "LSC Customer Order Header";
        decPreviousCollection: decimal;
        recCoPmtLine: Record "LSC Customer Order Payment";
        Rec: Record 99008981;
        decGSTPer: Decimal;
    begin
        Clear(decGSTPer);
        Rec.Reset();
        Rec.SetRange("Receipt No.", POSTransaction."Receipt No.");
        Rec.SetRange("Entry Status", Rec."Entry Status"::" ");
        Rec.SetRange("Entry Type", Rec."Entry Type"::IncomeExpense);
        Rec.SetRange("CO Prepayment Line", false);
        Rec.SetRange("CO Refund Line", false);
        if Rec.FindFirst() then begin
            if Rec."CO Prepayment Line" then exit;
            Clear(decGSTPer);
            // recStore.Get(POSTransaction."Store No.");
            if not recIncExpAccount.Get(Rec."Store No.", Rec.Number) then exit;
            if not recIncExpAccount."Alteration Account" then exit;//300323
            recGLAccount.Reset();
            recGLAccount.SetRange("No.", recIncExpAccount."G/L Account");
            if recGLAccount.FindFirst() then
                cdGSTGroup := recGLAccount."GST Group Code";

            case cdGSTGroup of
                'GST 12G':
                    begin
                        decGSTPer := 12
                    end;
                'GST 18G':
                    begin
                        decGSTPer := 18
                    end;
                'GST 28G':
                    begin
                        decGSTPer := 28
                    end;
                'GST 3G':
                    begin
                        decGSTPer := 3
                    end;
                'GST 5G':
                    begin
                        decGSTPer := 5
                    end;
            end;



            if (Rec."Entry Type" = Rec."Entry Type"::IncomeExpense) and
             (Rec."Entry Status" = Rec."Entry Status"::" ") and (Rec.Number = recIncExpAccount."No.") then begin
                decActualAmt := Rec.Price;

                // Original Cost – (Original Cost * (100 / (100 + GST% ) ) )
                // decGSTAmt := Rec.Price - (Rec.Price * (100 / (100 + decGSTPer)));
                decGSTAmt := Rec.Price - (Rec.Price * (100 / (100 + 12)));
                decGSTAmt := Round(decGSTAmt, 0.01, '=');
                // decAmount := Rec.Price;
                // decAmount := decAmount - ((decAmount * decGSTPer) / 100);
                decNewPrice := Rec.Price - decGSTAmt;
                decNewPrice := Round(decNewPrice, 0.01, '=');
                // if decActualAmt <= decNewPrice then begin
                //     Rec.Validate("Net Price", (decNewPrice + decGSTAmt));
                //     Rec.Validate(Amount, (decNewPrice + decGSTAmt));
                // end else begin
                // Rec.Validate("Net Price", decNewPrice);
                // Rec.Validate("Net Amount", decNewPrice);
                // Rec.Validate(Amount, Rec.Price);
                Rec."LSCIN Price Inclusive of Tax" := true;
                Rec.Price := Rec.Price;
                Rec."Net Price" := decNewPrice;
                Rec."Net Amount" := decNewPrice;
                Rec.Amount := decActualAmt;
                Rec.Quantity := 1;
                // Rec.Validate("LSCIN GST Group Type", Rec."LSCIN GST Group Type"::Service);
                // Rec.Validate("LSCIN GST Group Code", cdGSTGroup);
                // Rec.Validate("LSCIN GST Amount",decGSTAmt);
                Rec."LSCIN GST Group Type" := Rec."LSCIN GST Group Type"::Service;
                Rec."LSCIN GST Group Code" := 'GST 12G';
                Rec."LSCIN GST Amount" := decGSTAmt;
                Rec.Modify(false);
            end;
        end;

        if (POSTransaction."Customer Order ID" <> '') and POSTransaction."Partial Cancel Refund" then begin//220723 CITS_RS added new boolean and created CO payment line on tenderkey pressed instead of transaction initilalization
            recCOHeader.Get(POSTransaction."Customer Order ID");
            // if IsRefundEligible(recCOHeader, , decAdvanceAmt, decItemAmt, decCancelledAmt, decIncExpAmt, decPreviousCollection) then begin//CITS_RS 260423 //partial refund eligibility
            CalculateCOAmounts(recCOHeader, decAdvanceAmt, decItemAmt, decCancelledAmt, decIncExpAmt, decPreviousCollection);
            CreateCORefundLine(recCOHeader, CalculateAmtExclofGST(POSTransaction, (decAdvanceAmt - abs((decItemAmt + decIncExpAmt) - decCancelledAmt))), TenderTypeCode);//CITS_RS 260423
            // recCoPmtLine.Reset();
            // recCoPmtLine.SetRange("Document ID", POSTransaction."Customer Order ID");
            // recCoPmtLine.SetRange(Type, recCoPmtLine.Type::Payment);
            // recCoPmtLine.SetRange("Parital Cancel Refund", true);
            // // recCoPmtLine.SetRange("Line No.",POSTransLine."Line No.");
            // if recCoPmtLine.FindFirst() then begin
            //     recCoPmtLine.validate("Tender Type", TenderTypeCode);
            //     recCoPmtLine.Modify();
            // end;
        end;
    end;

    procedure CreateCORefundLine(recCOHeader: Record "LSC Customer Order Header"; decAmtRefunded: decimal; parmtenderType: Code[10])
    var
        recCoPmtLine: Record "LSC Customer Order Payment";
        LineNum: integer;
        recCoPmtLine1: Record "LSC Customer Order Payment";
        cuPosTrans: Codeunit 99001570;
        recStore: Record 99001470;
    begin
        // if recCOHeader."Total Amount" < decAmtRefunded then begin
        //     cuPosTrans.ErrorBeep('Refund Amt. cannot be greated than Total Customer Order Amt.');
        //     exit;
        //     recCOHeader.CalcFields("Pre Approved Amount");
        //     if recCOHeader."Pre Approved Amount" < decAmtRefunded then begin
        //         cuPosTrans.ErrorBeep('Refund Amt. cannot be greated than Initial deposit Amt.');
        //         exit;
        //     end;
        // end;


        Clear(LineNum);
        recCoPmtLine1.Reset();
        recCoPmtLine1.SetRange("Document ID", recCOHeader."Document ID");
        if recCoPmtLine1.FindLast() then
            LineNum := recCoPmtLine1."Line No.";


        recCoPmtLine.Init();
        recCoPmtLine.Validate("Store No.", recCOHeader."Created at Store");
        recCoPmtLine.validate("Document ID", recCOHeader."Document ID");
        recCoPmtLine."Line No." := LineNum + 10000;
        recCoPmtLine.Validate("Income/Expense Account No.", recStore."Customer Order Inc/Expense Acc");
        recCoPmtLine."Tender Type" := parmtenderType;
        recCoPmtLine."PosTrans Receipt No." := cuPosTrans.GetReceiptNo();
        recCoPmtLine.Created := CurrentDateTime;
        recCoPmtLine."Parital Cancel Refund" := true;
        recCoPmtLine.validate("Pre Approved Amount", -decAmtRefunded);
        recCoPmtLine.validate("Pre Approved Amount LCY", -decAmtRefunded);
        recCoPmtLine.validate(Type, recCoPmtLine.type::Payment);
        recCoPmtLine.Insert();
    end;

    // OnAfterCreatePosTrans(
    //     var Rec: Record "LSC POS Trans. Line";
    //     var POSTransaction: Record "LSC POS Transaction";
    //     var COHeaderTemp: Record "LSC Customer Order Header" temporary;
    //     var COLineTemp: Record "LSC Customer Order Line" temporary;
    //     var CODiscLineTemp: Record "LSC CO Discount Line" temporary;
    //     var ReceiptNo: Code[20];
    //     var ErrorCode: Code[30];
    //     var ErrorText: text;
    //     var COPaymentTemp: Record "LSC Customer Order Payment" temporary;
    //     var Returnvalue: Boolean;
    //     var Handled: Boolean)
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnAfterCreatePosTrans', '', false, false)]
    /*
    procedure CreateRefundLine01(var POSTransLine: Record "LSC POS Trans. Line";
        var POSTransaction: Record "LSC POS Transaction";
        var COHeaderTemp: Record "LSC Customer Order Header" temporary;
        var COLineTemp: Record "LSC Customer Order Line" temporary;
        var CODiscLineTemp: Record "LSC CO Discount Line" temporary;
        var ReceiptNo: Code[20];
        var ErrorCode: Code[30];
        var ErrorText: text;
        var COPaymentTemp: Record "LSC Customer Order Payment" temporary;
        var Returnvalue: Boolean;
        var Handled: Boolean)
    var
        recPosLine: Record 99008981;
        recPosHeader: Record "LSC POS Transaction";
        recStore: Record 99001470;
        cuPosTransaction: Codeunit 99001571;
        decAmttobeRefunded: Decimal;
        recCustOrderLine: Record "LSC Customer Order Line";
        recCustOrderHeader: Record "LSC Customer Order Header";
    begin
        recStore.Get(POSTransaction."Store No.");
        Clear(decAmttobeRefunded);
        recCustOrderHeader.Get(COHeaderTemp."Document ID");
        recCustOrderLine.Reset();
        recCustOrderLine.SetRange("Document ID", recCustOrderHeader."Document ID");
        if recCustOrderLine.find('-') then
            repeat
                if recCustOrderLine.Status = recCustOrderLine.Status::Canceled then
                    decAmttobeRefunded += recCustOrderLine.Amount;
            until recCustOrderLine.Next() = 0;
        decAmttobeRefunded := -(decAmttobeRefunded);

        if decAmttobeRefunded <> 0 then begin
            recPosLine.Init();
            if recPosLine.FindLast() then
                recPosLine."Line No." += 10000
            else
                recPosLine."Line No." := 10000;
            recPosLine."Entry Status" := recPosLine."Entry Status"::" ";
            recPosLine."Entry Type" := recPosLine."Entry Type"::IncomeExpense;
            recPosLine.validate("Store No.", POSTransaction."Store No.");
            recPosLine.validate("POS Terminal No.", POSTransaction."POS Terminal No.");
            recPosLine.validate("Receipt No.", POSTransaction."Receipt No.");
            recPosLine.validate(Number, recStore."Customer Order Inc/Expense Acc");
            recPosLine.Description := 'Customer Order Refund Line';
            recPosLine.validate(Price, decAmttobeRefunded);
            recPosLine.validate("Net Price", decAmttobeRefunded);
            recPosLine.validate(Amount, decAmttobeRefunded);
            recPosLine.validate(Quantity, 1);
            recPosLine.validate("VAT Code", 'A');
            recPosLine.validate("Net Amount", decAmttobeRefunded);
            recPosLine.validate("Vat Prod. Posting Group", 'ZERO');
            recPosLine.validate("Customer Order Line", true);
            recPosLine.validate("CO Prepayment Line", true);
            recPosLine.Insert();
        end;
        // cuPosTransaction.cu
    end;
    */

    [EventSubscriber(ObjectType::Table, Database::"LSC Customer Order Line", 'OnAfterModifyEvent', '', false, false)]
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Picking Panel", 'OnBeforeChangeStatusSelectedLine', '', false, false)]

    // local procedure OnBeforeChangeStatusSelectedLine(var GuiLineBuffer: Record "LSC Customer Order Line" temporary; var NewStatus_p: Enum "LSC CO Line Status")
    // procedure COLineModified(var GuiLineBuffer: Record "LSC Customer Order Line" temporary; var NewStatus_p: Enum "LSC CO Line Status")
    procedure COLineModified(var Rec: Record "LSC Customer Order Line")
    var
        i: Integer;
        cuPosTrans: Codeunit 99001570;
    begin
        i := 0;
        // cuPosTrans.NewSalePressed();

    end;

    // internal procedure OnPickingPanelClosedOK(var COHeaderTemp: Record "LSC Customer Order Header" temporary; var COLineTemp: Record "LSC Customer Order Line" temporary; var COPaymentTemp: Record "LSC Customer Order Payment" temporary; var CODiscountTemp: Record "LSC CO Discount Line" temporary; ReturnCloseCommand: Code[20]; Payload: Text; var SalesShipmentHeaderTemp: Record "Sales Shipment Header" temporary)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Picking Panel", 'OnPickingPanelClosedOK', '', false, false)]
    procedure InitiateRefundTrans(var COHeaderTemp: Record "LSC Customer Order Header" temporary; var COLineTemp: Record "LSC Customer Order Line" temporary; var COPaymentTemp: Record "LSC Customer Order Payment" temporary; var CODiscountTemp: Record "LSC CO Discount Line" temporary; ReturnCloseCommand: Code[20]; Payload: Text; var SalesShipmentHeaderTemp: Record "Sales Shipment Header" temporary)
    var
        cuPosTrans: Codeunit 99001570;
    begin
        // cuPosTrans.NewSalePressed();

    end;


    // local procedure OnBeforeUpdateCoLineMode(var COLine: Record "LSC Customer Order Line"; var COLineTemp: Record "LSC Customer Order Line" temporary; var LinesInPickMode: Boolean; var LinesInCollectmode: Boolean; var LinesShortagedOrCanceled: Boolean)
    //Inventory check or partial refund ..executes at time of pick up & collection both
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Web Service Functions", 'OnBeforeUpdateCoLineMode', '', false, false)]
    procedure InitiateRefundTransaction2(var COLine: Record "LSC Customer Order Line"; var COLineTemp: Record "LSC Customer Order Line" temporary; var LinesInPickMode: Boolean; var LinesInCollectmode: Boolean; var LinesShortagedOrCanceled: Boolean)
    VAR
        cuPosTrans: Codeunit 99001570;
        headerAlreadyCreated: Boolean;
        recPosHeader: Record "LSC POS Transaction";
        decAdvanceAmt: Decimal;
        recItem: Record 27;
        recCOLine: Record "LSC Customer Order Line";
        decItemAmt: Decimal;
        decCancelledAmt: Decimal;
        recILE: Record 32;
        decIncExpAmt: Decimal;
        recCOHeader: Record "LSC Customer Order Header";
        decPreviousCollection: decimal;
    begin
        Clear(headerAlreadyCreated);
        Clear(decPreviousCollection);
        Clear(decItemAmt);
        Clear(decAdvanceAmt);
        Clear(decCancelledAmt);
        recCOHeader.Get(COLine."Document ID");
        if COLine.Status = COLine.Status::Canceled then begin
            if IsRefundEligible(recCOHeader, COLine, decAdvanceAmt, decItemAmt, decCancelledAmt, decIncExpAmt, decPreviousCollection) then begin//CITS_RS 260423 //partial refund eligibility

                // if  recPosHeader.get(cuPosTrans.GetReceiptNo()) then begin
                //     recPosHeader.CalcFields("CO Refund Lines");
                //     headerAlreadyCreated := true;
                // end;

                cuPosTrans.NewSalePressed();
                recPosHeader.get(cuPosTrans.GetReceiptNo());
                recPosHeader.validate("Customer No.", recCOHeader."Customer No.");
                recPosHeader.validate("Customer Order ID", recCOHeader."Document ID");
                recPosHeader.validate("Customer Order", true);
                recPosHeader."Partial Cancel Refund" := true;
                recPosHeader.Modify();
                // CreateRefundLine_IncExp(recPosHeader, CalculateAmtExclofGST(recPosHeader, COLine."LSCIN Unit Price Incl. of Tax"));
                // CreateCORefundLine(recCOHeader, CalculateAmtExclofGST(recPosHeader, COLine."LSCIN Unit Price Incl. of Tax"));
                CreateRefundLine_IncExp(recPosHeader, CalculateAmtExclofGST(recPosHeader, (decAdvanceAmt - abs((decItemAmt + decIncExpAmt) - decCancelledAmt))));//CITS_RS 260423                                                                                               
                //CO payment line now being created on tender key pressed to map the proper tender 220723 CITS_RS
                // CreateCORefundLine(recCOHeader, CalculateAmtExclofGST(recPosHeader, (decAdvanceAmt - abs((decItemAmt + decIncExpAmt) - decCancelledAmt))));//CITS_RS 260423
                if COLine."Line Type" = COLine."Line Type"::Item then begin
                    if recItem.Get(COLine.Number) then begin
                        recItem.ItemSaleReserved := false;
                        recItem."Customer No." := '';
                        recItem.Modify();
                    end;
                end;
            end else begin //no refund just unblocking the item 170723 CITS_RS
                if COLine."Line Type" = COLine."Line Type"::Item then begin
                    if recItem.Get(COLine.Number) then begin
                        recItem.ItemSaleReserved := false;
                        recItem."Customer No." := '';
                        recItem.Modify();
                    end;
                end;
            end;
        end else begin
            recCOHeader.Get(COLine."Document ID");
            recCOLine.Reset();
            recCOLine.setrange("Document ID", COLine."Document ID");
            recCOLine.SetRange("Line Type", recCOLine."Line Type"::Item);
            // recCOLine.SetFilter(Status, '<>%1', recCOLine.Status::Canceled);
            recCOLine.SetFilter(Status, '=%1', recCOLine.Status::"To Collect");//CITS_RS 050623
            if recCOLine.Find('-') then
                repeat
                    recItem.Get(recCOLine.Number);
                    recILE.Reset();
                    recILE.SetRange("Item No.", recCOLine.Number);
                    recILE.SetRange("Location Code", recCOHeader."Created at Store");
                    recILE.SetFilter("Remaining Quantity", '>%1', 0);
                    recILE.CalcSums(Quantity);
                    if recILE.Quantity <= 0 then
                        Error('Item %1 doensn''t have sufficient inventory at the store!', recCOLine.Number);
                until recCOLine.Next() = 0;

        end;
    end;

    procedure CalculateCOAmounts(COHeader: Record "LSC Customer Order Header";
        var decAdvanceAmt: Decimal;
        var decItemAmt: Decimal;
        var decCancelledAmt: Decimal;
        var decIncExp: Decimal;
        var decPreviousCollection: Decimal): Boolean
    var
        recCOHeader: Record "LSC Customer Order Header";
        recCOLine: Record "LSC Customer Order Line";
        recItem: Record 27;
        recCOPaymentLine: Record "LSC Customer Order Payment";
    begin
        recCOLine.Reset();
        recCOLine.SetRange("Document ID", COHeader."Document ID");
        // recCOLine.SetRange(Status, recCOLine.Status::"To Pick");
        recCOLine.SetRange("Line Type", recCOLine."Line Type"::Item);
        if recCOLine.Find('-') then
            repeat
                recItem.Get(recCOLine.Number);
                decItemAmt += recItem."LSC Unit Price Incl. VAT";

                if recCOLine.Status = recCOLine.Status::Canceled then
                    decCancelledAmt += recItem."LSC Unit Price Incl. VAT";

                if recCOLine.Status = recCOLine.Status::Collected then
                    decPreviousCollection += recItem."LSC Unit Price Incl. VAT";
            until recCOLine.Next() = 0;

        recCOLine.SetRange("Line Type", recCOLine."Line Type"::IncomeExpense);
        if recCOLine.Find('-') then
            repeat
                decIncExp += recCOLine.Amount;
            until recCOLine.Next() = 0;

        recCOPaymentLine.Reset();
        recCOPaymentLine.SetRange("Document ID", COHeader."Document ID");
        // recCOPaymentLine.SetFilter(stat,'<>%1',recCOLine.Status::Canceled);
        recCOPaymentLine.SetRange(Type, recCOPaymentLine.Type::Payment);
        if recCOPaymentLine.Find('-') then
            repeat
                decAdvanceAmt += recCOPaymentLine."Pre Approved Amount LCY";
            until recCOPaymentLine.Next() = 0;

        // recCOLine.Reset();
        // recCOLine.SetRange("Document ID", COHeader."Document ID");
        // recCOLine.SetRange("Line Type", recCOLine."Line Type"::Item);
        // if recCOLine.Find('-') then
        //     repeat
        //         recItem.Get(recCOLine.Number);
        //         decCancelledAmt += recItem."LSC Unit Price Incl. VAT";
        //     until recCOLine.Next() = 0;

        // recItem.get(parmCOLine.Number);
        // decCancelledAmt := recItem."LSC Unit Price Incl. VAT";
        // decItemAmt := decItemAmt - decIncExp; //excluding the alteration amount in partial cancellations. CITS_RS

        exit(abs((decItemAmt + decIncExp) - decCancelledAmt) < decAdvanceAmt)

    end;

    procedure IsRefundEligible(COHeader: Record "LSC Customer Order Header";
        parmCOLine: Record "LSC Customer Order Line";
        var decAdvanceAmt: Decimal;
        var decItemAmt: Decimal;
        var decCancelledAmt: Decimal;
        var decIncExp: Decimal;
        var decPreviousCollection: Decimal): Boolean
    var
        recCOHeader: Record "LSC Customer Order Header";
        recCOLine: Record "LSC Customer Order Line";
        recItem: Record 27;
        recCOPaymentLine: Record "LSC Customer Order Payment";
    begin
        recCOLine.Reset();
        recCOLine.SetRange("Document ID", COHeader."Document ID");
        // recCOLine.SetRange(Status, recCOLine.Status::"To Pick");
        recCOLine.SetRange("Line Type", recCOLine."Line Type"::Item);
        if recCOLine.Find('-') then
            repeat
                recItem.Get(recCOLine.Number);
                decItemAmt += recItem."LSC Unit Price Incl. VAT";

                if recCOLine.Status = recCOLine.Status::Canceled then
                    decCancelledAmt += recItem."LSC Unit Price Incl. VAT";

                if recCOLine.Status = recCOLine.Status::Collected then
                    decPreviousCollection += recItem."LSC Unit Price Incl. VAT";
            until recCOLine.Next() = 0;

        recCOLine.SetRange("Line Type", recCOLine."Line Type"::IncomeExpense);
        if recCOLine.Find('-') then
            repeat
                decIncExp += recCOLine.Amount;
            until recCOLine.Next() = 0;

        recCOPaymentLine.Reset();
        recCOPaymentLine.SetRange("Document ID", COHeader."Document ID");
        // recCOPaymentLine.SetFilter(stat,'<>%1',recCOLine.Status::Canceled);
        recCOPaymentLine.SetRange(Type, recCOPaymentLine.Type::Payment);
        if recCOPaymentLine.Find('-') then
            repeat
                decAdvanceAmt += recCOPaymentLine."Pre Approved Amount LCY";
            until recCOPaymentLine.Next() = 0;

        recCOLine.Reset();
        recCOLine.SetRange("Document ID", COHeader."Document ID");
        recCOLine.SetRange("Line Type", recCOLine."Line Type"::Item);
        recCOLine.SetRange("Line No.", parmCOLine."Line No.");
        if recCOLine.Find('-') then
            repeat
                recItem.Get(recCOLine.Number);
                decCancelledAmt += recItem."LSC Unit Price Incl. VAT";
            until recCOLine.Next() = 0;

        // recItem.get(parmCOLine.Number);
        // decCancelledAmt := recItem."LSC Unit Price Incl. VAT";
        // decItemAmt := decItemAmt - decIncExp; //excluding the alteration amount in partial cancellations. CITS_RS

        exit(abs((decItemAmt + decIncExp) - decCancelledAmt) < decAdvanceAmt)
    end;

    procedure RefundEligibleAmt(COHeader: Record "LSC Customer Order Header"; parmCOLine: Record "LSC Customer Order Line"): Decimal
    var
        recCOHeader: Record "LSC Customer Order Header";
        recCOLine: Record "LSC Customer Order Line";
        decAdvanceAmt: Decimal;
        recItem: Record 27;
        recCOPaymentLine: Record "LSC Customer Order Payment";
        decItemAmt: Decimal;
        decCancelledAmt: Decimal;
    begin
        Clear(decItemAmt);
        Clear(decAdvanceAmt);
        recCOLine.Reset();
        recCOLine.SetRange("Document ID", COHeader."Document ID");
        recCOLine.SetRange(Status, recCOLine.Status::"To Pick");
        recCOLine.SetRange("Line Type", recCOLine."Line Type"::Item);
        if recCOLine.Find('-') then
            repeat
                recItem.Get(recCOLine.Number);
                if recCOLine.Status = recCOLine.Status::"To Pick" then
                    decItemAmt += recItem."LSC Unit Price Incl. VAT";

                if recCOLine.Status = recCOLine.Status::Canceled then
                    decCancelledAmt += recItem."LSC Unit Price Incl. VAT";

            until recCOLine.Next() = 0;

        recCOPaymentLine.Reset();
        recCOPaymentLine.SetRange("Document ID", COHeader."Document ID");
        recCOPaymentLine.SetRange(Type, recCOPaymentLine.Type::Payment);
        if recCOPaymentLine.Find('-') then
            repeat
                decAdvanceAmt += recCOPaymentLine."Pre Approved Amount LCY";
            until recCOPaymentLine.Next() = 0;

        // recItem.get(parmCOLine.Number);
        // decCancelledAmt := recItem."LSC Unit Price Incl. VAT";

        exit(decAdvanceAmt - abs(decItemAmt - decCancelledAmt))
    end;



    // procedure CreateCORefundIncExpLine()
    // var
    // begin

    // end;

    // local procedure OnBeforePostCustomerOrder(COHeader: Record "LSC Customer Order Header")
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Web Service Functions", 'OnBeforePostCustomerOrder', '', false, false)]
    // procedure InitiateRefundTransaction3()
    // var
    // begin

    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnBeforePostCustomerOrder', '', false, false)]
    // procedure InitiateRefundTransaction4()
    // var
    // begin

    // end;

    procedure CalculateAmtExclofGST(recPosHeader: Record "LSC POS Transaction"; PriceInclTax: Decimal): Decimal
    var
        recGLAccount: Record 15;
        recStore: Record 99001470;
        cdGSTGroup: Code[10];
        decAmount: Decimal;
        cuPosTrans: codeunit 99001570;
        decNewPrice: Decimal;
        decGSTAmt: Decimal;
        recIncExpAccount: Record 99001476;
        decGSTPer: Decimal;
    begin
        recStore.Get(recPosHeader."Store No.");
        Clear(decGSTPer);
        // recStore.Get(POSTransaction."Store No.");
        recIncExpAccount.Get(recPosHeader."Store No.", recStore."Customer Order Inc/Expense Acc");
        recGLAccount.Reset();
        recGLAccount.SetRange("No.", recIncExpAccount."G/L Account");
        if recGLAccount.FindFirst() then
            cdGSTGroup := recGLAccount."GST Group Code";

        case cdGSTGroup of
            'GST 12G':
                begin
                    decGSTPer := 12
                end;
            'GST 18G':
                begin
                    decGSTPer := 18
                end;
            'GST 28G':
                begin
                    decGSTPer := 28
                end;
            'GST 3G':
                begin
                    decGSTPer := 3
                end;
            'GST 5G':
                begin
                    decGSTPer := 5
                end;
        end;
        decGSTAmt := PriceInclTax - (PriceInclTax * (100 / (100 + decGSTPer)));
        decGSTAmt := Round(decGSTAmt, 0.01, '=');
        exit(round(PriceInclTax - decGSTAmt, 0.01, '='));

    end;

    // OnAfterIncExpLine(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Pos Transaction Events", 'OnAfterIncExpLine', '', false, false)]
    procedure updateAlterationAmount(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text)
    var
        recGLAccount: Record 15;
        recStore: Record 99001470;
        cdGSTGroup: Code[10];
        decAmount: Decimal;
        cuPosTrans: codeunit 99001570;
        decNewPrice: Decimal;
        decActualAmt: Decimal;
        decGSTAmt: Decimal;
        recIncExpAccount: Record 99001476;
        decGSTPer: Decimal;
    begin
        Clear(decGSTPer);
        // recStore.Get(POSTransaction."Store No.");
        if not recIncExpAccount.Get(POSTransLine."Store No.", POSTransLine.Number) then exit;
        if not recIncExpAccount."Alteration Account" then exit;//300323
        recGLAccount.Reset();
        recGLAccount.SetRange("No.", recIncExpAccount."G/L Account");
        if recGLAccount.FindFirst() then
            cdGSTGroup := recGLAccount."GST Group Code";

        case cdGSTGroup of
            'GST 12G':
                begin
                    decGSTPer := 12
                end;
            'GST 18G':
                begin
                    decGSTPer := 18
                end;
            'GST 28G':
                begin
                    decGSTPer := 28
                end;
            'GST 3G':
                begin
                    decGSTPer := 3
                end;
            'GST 5G':
                begin
                    decGSTPer := 5
                end;
        end;


        if POSTransLine."CO Prepayment Line" then exit;
        if (POSTransLine."Entry Type" = POSTransLine."Entry Type"::IncomeExpense) and
         (POSTransLine."Entry Status" = POSTransLine."Entry Status"::" ") and (POSTransLine.Number = recIncExpAccount."No.") then begin
            decActualAmt := POSTransLine.Price;

            // Original Cost – (Original Cost * (100 / (100 + GST% ) ) )
            // decGSTAmt := POSTransLine.Price - (POSTransLine.Price * (100 / (100 + decGSTPer)));
            decGSTAmt := POSTransLine.Price - (POSTransLine.Price * (100 / (100 + 12)));
            decGSTAmt := Round(decGSTAmt, 0.01, '=');
            // decAmount := POSTransLine.Price;
            // decAmount := decAmount - ((decAmount * decGSTPer) / 100);
            decNewPrice := POSTransLine.Price - decGSTAmt;
            decNewPrice := Round(decNewPrice, 0.01, '=');
            // if decActualAmt <= decNewPrice then begin
            //     POSTransLine.Validate("Net Price", (decNewPrice + decGSTAmt));
            //     POSTransLine.Validate(Amount, (decNewPrice + decGSTAmt));
            // end else begin
            // POSTransLine.Validate("Net Price", decNewPrice);
            // POSTransLine.Validate("Net Amount", decNewPrice);
            // POSTransLine.Validate(Amount, PosTransLine.Price);
            POSTransLine."LSCIN Price Inclusive of Tax" := true;
            POSTransLine.Price := PosTransLine.Price;
            POSTransLine."Net Price" := decNewPrice;
            POSTransLine."Net Amount" := decNewPrice;
            POSTransLine.Amount := decActualAmt;
            POSTransLine.Quantity := 1;
            // POSTransLine.Validate("LSCIN GST Group Type", POSTransLine."LSCIN GST Group Type"::Service);
            // POSTransLine.Validate("LSCIN GST Group Code", cdGSTGroup);
            // POSTransLine.Validate("LSCIN GST Amount",decGSTAmt);
            POSTransLine."LSCIN GST Group Type" := POSTransLine."LSCIN GST Group Type"::Service;
            POSTransLine."LSCIN GST Group Code" := 'GST 12G';
            POSTransLine."LSCIN GST Amount" := decGSTAmt;
            POSTransLine.Modify(false);
        end;
    end;

    // codeunit 10044506 "LSCIN Calculate Tax"
    // procedure OnAfterRunHandleEvents(Var POSTransLine: Record "LSC POS Trans. Line");

    //>>Added by KJ T002 120922 Start
    //<<Added by KJ T002 120922 End

    [EventSubscriber(ObjectType::Table, Database::"LSC Customer Order Payment", 'OnAfterInsertEvent', '', false, false)]
    local procedure insertdate(var Rec: Record "LSC Customer Order Payment")
    begin
        Rec.Date := Today;
        Rec.Modify();
        // Message('date inserted1');
    end;

    [EventSubscriber(ObjectType::Table, Database::"LSC Customer Order Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure insertdateNew(var Rec: Record "LSC Customer Order Header")
    begin
        Rec.Date := Today;
        Rec.Modify();
        // Message('date inserted1');
    end;

    [EventSubscriber(ObjectType::Table, Database::"LSC Customer Order Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure insertdateLine(var Rec: Record "LSC Customer Order Line")
    begin
        Rec.Date := Today;
        Rec.Modify();
        // Message('date inserted1');
    end;

    [EventSubscriber(ObjectType::Table, Database::"LSC Posted CO Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure insertPOCOdate(var Rec: Record "LSC Posted CO Header")
    begin
        Rec.Date := Today;
        Rec.Modify();
        // Message('date inserted1');
    end;

    /* Commented CITS_RS 280223 (merged with another function)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterPostTransaction', '', false, false)]
    procedure AssignCusttoItem(var TransactionHeader_p: Record "LSC Transaction Header")
    var
        recItem: Record 27;
        recSalesEn: Record 99001473;
    begin
        if TransactionHeader_p."Entry Status" <> TransactionHeader_p."Entry Status"::" " then exit;
        if TransactionHeader_p.Payment > 0 then begin
            if (TransactionHeader_p."Customer No." <> '') or (TransactionHeader_p."Customer Order")
             or (TransactionHeader_p."Customer Order ID" <> '') then begin
                recSalesEn.Reset();
                recSalesEn.SetRange("Store No.", TransactionHeader_p."Store No.");
                recSalesEn.SetRange("POS Terminal No.", TransactionHeader_p."POS Terminal No.");
                recSalesEn.SetRange("Transaction No.", TransactionHeader_p."Transaction No.");
                if recSalesEn.Find('-') then begin
                    recItem.get(recSalesEn."Item No.");
                    if recItem."Is Advance" then exit;
                    recItem.Get(recSalesEn."Item No.");
                    recItem."Customer No." := TransactionHeader_p."Customer No.";
                    recItem.Modify();
                end;
            end;
        end;
    end;*/
    // local procedure SalesEntryOnBeforeInsertV2(var pPOSTransLineTemp: Record "LSC POS Trans. Line" temporary; var pTransSalesEntry: Record "LSC Trans. Sales Entry")
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'SalesEntryOnBeforeInsertV2', '', false, false)]
    procedure PopulateSalesEntry(var pPOSTransLineTemp: Record "LSC POS Trans. Line" temporary; var pTransSalesEntry: Record "LSC Trans. Sales Entry")
    var
    begin
        pTransSalesEntry."CO Refund Line" := pPOSTransLineTemp."CO Refund Line";
        pTransSalesEntry."Designer Name" := pPOSTransLineTemp."Designer Name";
        pTransSalesEntry."POS Comment" := pPOSTransLineTemp."POS Comment";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterPostTransaction', '', false, false)]
    procedure CallInventoryReduceAPIorRestockAPI(TransactionHeader_p: Record "LSC Transaction Header")
    var
        CU_Functions: Codeunit Functions;
    begin
        if not CU_Functions.CallReduceStockAPI(TransactionHeader_p) then;
        CU_Functions.PostdataAPI(TransactionHeader_p);//merged 2 subs
    end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    // local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean);
    // begin
    //     PostdataAPI(SalesHeader);
    // end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeFinalizePosting', '', false, false)]
    // local procedure OnRunOnBeforeFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; GenJnlLineExtDocNo: Code[35]; var EverythingInvoiced: Boolean; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]);
    // begin
    //     PostdataAPI(SalesHeader);
    // end;
    /* merged 2 subs CITS_RS 280223
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterPostTransaction', '', false, false)]
    local procedure CallApiAfterpostSalesReturn(var TransactionHeader_p: Record "LSC Transaction Header");
    var
        CU_Functions: Codeunit Functions;
    begin
        
    end;*/

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure TransfromCode(var Rec: Record "Transfer Header")
    var
        Retailuser: Record "LSC Retail User";
    begin
        //  if Retailuser.Get(UserId) then
        //    Rec.Validate("Transfer-from Code", Retailuser."Location Code");//SK
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure DirectCostvalidation(var Rec: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        Rec.TestField("Vendor Order No.");
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."No.");
        if PurchLine.FindSet() then
            repeat
                PurchLine.TestField("Direct Unit Cost");
            until PurchLine.Next() = 0;
    end;
    // OnAfterPrintSalesSlip

    //AS>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Print Utility", 'OnBeforePrintSlips', '', false, false)]
    local procedure PrintSalesSlip(var Sender: Codeunit "LSC POS Print Utility"; var Transaction: Record "LSC Transaction Header"; var PrintBuffer: Record "LSC POS Print Buffer"; var PrintBufferIndex: Integer; var LinesPrinted: Integer; var MsgTxt: Text[50]; var IsHandled: Boolean; var ReturnValue: Boolean);
    var
        TransHed: Record 99001472;
        recCustOrderHeader: Record "LSC Customer Order Header";
        recCustOrderLine: Record "LSC Customer Order Line";
        recItem: Record 27;
        TransSalEntry: Record "LSC Trans. Sales Entry";
        COPayment: Record "LSC Customer Order Payment";
        PosCOHdr: Record "LSC Posted CO Header";
        IncExpEnt: Record "LSC Trans. Inc./Exp. Entry";
    begin
        TransHed.Reset();
        TransHed.SetRange("Transaction No.", Transaction."Transaction No.");
        TransHed.SetRange("Store No.", Transaction."Store No.");
        TransHed.SetRange("POS Terminal No.", Transaction."POS Terminal No.");
        TransHed.SetRange("Entry Status", TransHed."Entry Status"::" ");
        if not TransHed.FindFirst() then exit;

        if (TransHed."Customer Order") and (TransHed."Income/Exp. Amount" <= 0)//3105
            and (TransHed."Customer Order ID" <> '') then begin//customer order receipt
            recCustOrderHeader.Reset();
            recCustOrderHeader.SetRange("Document ID", TransHed."Customer Order ID");
            if recCustOrderHeader.FindFirst() then begin
                COPayment.Reset();
                COPayment.SetRange("Document ID", recCustOrderHeader."Document ID");
                COPayment.SetRange("Store No.", recCustOrderHeader."Created at Store");
                if COPayment.FindLast() then begin
                    if COPayment."Deposit Payment" then
                        Report.run(50117, false, false, TransHed)
                    else
                        Report.run(50115, false, true, recCustOrderHeader);
                end;
                // Report.run(50115, false, false, recCustOrderHeader);//Naveen
                //   Report.run(50115, false, true, recCustOrderHeader);//010623
                //Report.SaveAsExcel(50115, 'CustReport.Xlsx', recCustOrderHeader);//naveen
            end;
        end else
            if (TransHed."Customer Order") and (TransHed."Income/Exp. Amount" > 0) //"Customer No." = '')
       and (TransHed."Customer Order ID" <> '') and (not TransHed."Sale Is Return Sale") then begin//final customer tax invoice
                PosCOHdr.Reset();
                PosCOHdr.SetRange("Document ID", TransHed."Customer Order ID");
                PosCOHdr.SetRange("Processing Status", 'CLOSED');
                if PosCOHdr.FindFirst() then
                    Report.run(50123, false, true, PosCOHdr)
                else begin
                    recCustOrderHeader.Reset();                                                                                  //if (TransHed.Payment > 0) and (not TransHed."Sale Is Return Sale") then begin
                    recCustOrderHeader.SetRange("Document ID", TransHed."Customer Order ID");
                    if recCustOrderHeader.FindFirst() then// begin
                        recCustOrderLine.Reset();
                    recCustOrderLine.SetRange("Document ID", recCustOrderHeader."Document ID");
                    recCustOrderLine.SetRange(Status, recCustOrderLine.Status::Canceled);
                    if recCustOrderLine.FindFirst() then
                        Report.run(50119, false, true, recCustOrderHeader)
                    else
                        Report.run(50100, false, false, TransHed)//Naveen
                    // recCustOrderHeader.Reset();
                    // recCustOrderHeader.SetRange("Document ID", TransHed."Customer Order ID");
                    // if recCustOrderHeader.FindFirst() then
                    //     Report.run(50117, false, false, recCustOrderHeader);
                    //end;
                end;
            end else
                if not Transaction."Sale Is Return Sale" and not TransHed."Customer Order" then begin
                    TransHed.Reset();
                    TransHed.SetRange("Transaction No.", Transaction."Transaction No.");
                    TransHed.SetRange("Store No.", Transaction."Store No.");
                    TransHed.SetRange("POS Terminal No.", Transaction."POS Terminal No.");
                    if TransHed.FindFirst() then begin
                        TransSalEntry.Reset();
                        TransSalEntry.SetRange("Transaction No.", TransHed."Transaction No.");
                        TransSalEntry.SetRange("Store No.", TransHed."Store No.");
                        TransSalEntry.SetRange("POS Terminal No.", TransHed."POS Terminal No.");
                        if TransSalEntry.FindFirst() then begin
                            recItem.Get(TransSalEntry."Item No.");
                            if not recItem."Is Advance" then
                                Report.run(50100, false, false, TransHed);//Naveen
                            // IsHandled := true;
                        end else begin
                            IncExpEnt.Reset();
                            IncExpEnt.SetRange("Receipt  No.", TransHed."Receipt No.");
                            if IncExpEnt.FindFirst() then begin
                                Report.run(50176, false, false, TransHed);//AS
                            end;
                        end;
                    end;
                end;// else //cocoon
                    // begin
                    //     if (TransHed."Customer Order") and (TransHed."Income/Exp. Amount" <= 0) and
                    //     (TransHed."Customer Order ID" <> '') then begin
                    //         Report.run(50117, false, false, TransHed);
                    //     end;
                    // end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Print Utility", 'OnBeforePrintReturnsSlip', '', false, false)]
    local procedure PrintReturnSlip(var Sender: Codeunit "LSC POS Print Utility"; var Transaction: Record "LSC Transaction Header"; var PrintBuffer: Record "LSC POS Print Buffer"; var PrintBufferIndex: Integer; var LinesPrinted: Integer; var DSTR1: Text[100]; var IsHandled: Boolean; var ReturnValue: Boolean);
    var
        TransHed: Record "LSC Transaction Header";
    begin
        if Transaction."Sale Is Return Sale" then begin
            TransHed.Reset();
            TransHed.SetRange("Transaction No.", Transaction."Transaction No.");
            TransHed.SetRange("Store No.", Transaction."Store No.");
            TransHed.SetRange("POS Terminal No.", Transaction."POS Terminal No.");
            if TransHed.FindFirst() then
                Report.run(50112, false, false, TransHed);
            IsHandled := true;
        end;
    end;
    //AS>>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Print Utility", 'OnBeforePrintSlips', '', false, false)]
    local procedure PrintAdvanceReceipt(var Sender: Codeunit "LSC POS Print Utility"; var Transaction: Record "LSC Transaction Header"; var PrintBuffer: Record "LSC POS Print Buffer"; var PrintBufferIndex: Integer; var LinesPrinted: Integer; var MsgTxt: Text[50]; var IsHandled: Boolean; var ReturnValue: Boolean);
    var
        TransHed: Record "LSC Transaction Header";
        recItem: Record 27;
        TransSalEntry: Record "LSC Trans. Sales Entry";
    begin
        TransHed.Reset();
        TransHed.SetRange("Transaction No.", Transaction."Transaction No.");
        TransHed.SetRange("Store No.", Transaction."Store No.");
        TransHed.SetRange("POS Terminal No.", Transaction."POS Terminal No.");
        if TransHed.FindFirst() then begin
            TransSalEntry.Reset();
            TransSalEntry.SetRange("Transaction No.", TransHed."Transaction No.");
            TransSalEntry.SetRange("Store No.", TransHed."Store No.");
            TransSalEntry.SetRange("POS Terminal No.", TransHed."POS Terminal No.");
            // TransSalEntry.SetRange("Item No.", '69000');//CITS_RS commented
            if TransSalEntry.FindFirst() then begin
                recItem.Get(TransSalEntry."Item No.");//CITS_RS
                if recItem."Is Advance" then  //CITS_RS
                    Report.run(50117, false, false, TransHed);
            end;
        end;
    end;
    //SK++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Print Utility", 'OnBeforePrintCustomerSlip', '', false, false)]
    local procedure PrintCustomerSlip(var Sender: Codeunit "LSC POS Print Utility"; var Transaction: Record "LSC Transaction Header"; var PrintBuffer: Record "LSC POS Print Buffer"; var PrintBufferIndex: Integer; var LinesPrinted: Integer; var DSTR1: Text[100]; var IsHandled: Boolean; var ReturnValue: Boolean);
    var
        CustHed: Record "LSC Customer Order Header";
    begin
        if Transaction."Customer Order" then begin
            CustHed.Reset();
            CustHed.SetRange(CustHed."Document ID", Transaction."Customer Order ID");
            if CustHed.FindFirst() then
                // Report.run(50115, false, false, CustHed);//Naveen
                Report.run(50115, false, true, CustHed);//Naveen
                                                        //Report.SaveAsExcel(50115, 'ItemReport.Xlsx', CustHed);//naveen
            IsHandled := true;
        end;
    end;
    //SK--

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO POS Functions", 'OnFinalizeOrderDone', '', false, false)]
    // [EventSubscriber(ObjectType::Table, Database::"LSC Pos Trans. Line", 'OnAfterInsertEvent', '', false, false)]
    // procedure CalculateGSTAfterCOInsert(Rec: Record "LSC Pos Trans. Line")
    procedure CalculateGSTAfterCOInsert(var COHeaderTemp: Record "LSC Customer Order Header" temporary; var COLineTemp: Record "LSC Customer Order Line" temporary; var COPaymentTemp: Record "LSC Customer Order Payment" temporary; ReturnCloseCommand: Code[20]; Payload: Text)
    var
        cuCalcTax: Codeunit 10044506;
        CUPosTransLines: Codeunit 99001571;
        recposLine: Record 99008981;
        recHeader: Record "LSC POS Transaction";
    begin
        recHeader.Reset();
        recHeader.SetFilter("Customer Order ID", '=%1', COHeaderTemp."Document ID");
        if recHeader.Find('-') then;
        // if Rec."Receipt No." = '' then exit;
        // CUPosTransLines.GetCurrentLine(Rec);
        // recHeader.Get(Rec."Receipt No.");
        // cuCalcTax.CalculatePOSTransLineAmount(Rec);
        //cuCalcTax.CalculateTaxOnSelectedLine(recHeader, Rec, true);
        // cuCalcTax.RecalculateTaxForAllLines(recHeader, Rec);
    end;

    //AS<<
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC CO Utility", 'OnBeforeCreateCOPosTransLine', '', false, false)]
    local procedure OnBeforeCreateCOPosTransLine(var PosTrans: Record "LSC POS Transaction"; var COLineTemp: Record "LSC Customer Order Line"; var AmountToCollect: Decimal; var PosTransLine: Record "LSC POS Trans. Line"; var Receipt: Code[20]; var IsHandled: Boolean);
    begin
        //POSTransLine."Retail Charge Code" := 'A';
    end;

    // [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', false, false)]
    // local procedure onaftermodifyanyfield(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    // begin
    //     //Message('hi');
    //     if Rec."Is Approved for Sale" = true then
    //         Rec."Is Approved for Sale" := false;

    // end;

    //UnReserveItemSales++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransLineUpdateQtyReceived', '', false, false)]
    local procedure OnAfterTransLineUpdateQtyReceived(var TransferLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", TransferLine."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item.ItemSaleReserved = true then
                L_Item.Validate(ItemSaleReserved, false);
            L_Item."fc location" := TransferLine."Transfer-to Code";//CITS_RS 20223
            L_Item.Modify(true);
        end;
    end;
    //UnReserveItemSales--

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCode(var Sender: Record "Purchase Header"; PurchSetup: Record "Purchases & Payables Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header");
    var
        Retailuser: Record "LSC Retail User";
        Store: Record "LSC Store";
    begin
        if Sender."Document Type" = Sender."Document Type"::Order then begin
            if Retailuser.Get(UserId) then
                if Store.Get(Retailuser."Store No.") then begin
                    Store.TestField("Purchase Order No. Series");
                    NoSeriesCode := Store."Purchase Order No. Series";
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure OnAfterGetNoSeriesCode(var TransferHeader: Record "Transfer Header"; var NoSeriesCode: Code[20]);
    var
        Retailuser: Record "LSC Retail User";
        Store: Record "LSC Store";
    begin
        Clear(NoSeriesCode);
        if Retailuser.Get(UserId) then
            if Store.Get(Retailuser."Store No.") then begin
                Store.TestField("Transfer Order No. Series");
                NoSeriesCode := Store."Transfer Order No. Series";
                //IsHandled := true;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSCReturnOrd(var Sender: Record "Purchase Header"; PurchSetup: Record "Purchases & Payables Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header");
    var
        Retailuser: Record "LSC Retail User";
        Store: Record "LSC Store";
        recLocation: Record 14;
    begin
        if Sender."Document Type" = Sender."Document Type"::"Return Order" then begin
            PurchaseHeader.TestField("Location Code");
            recLocation.get(PurchaseHeader."Location Code");
            if Store.Get(recLocation.Code) then begin
                Store.TestField("Return Order No. Series");
                NoSeriesCode := Store."Return Order No. Series";
                IsHandled := true;
            end;
            // if Retailuser.Get(UserId) then//considering location on Document instead of Retail User location. 020223 CITS_RS
            //     if Store.Get(Retailuser."Store No.") then begin
            //         Store.TestField("Return Order No. Series");
            //         NoSeriesCode := Store."Return Order No. Series";
            //         IsHandled := true;
            //     end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInsertReceiptHeader', '', false, false)]
    local procedure OnBeforeInsertReceiptHeader(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var IsHandled: Boolean; CommitIsSuppressed: Boolean);
    var
        Retailuser: Record "LSC Retail User";
        Store: Record "LSC Store";
        recPurchLine: Record "Purchase Line";
        cuNoSeries: Codeunit NoSeriesManagement;
        recItem: Record 27;
        cdLocation: Code[10];
    begin
        //CITS_RS 240223
        recPurchLine.Reset();
        recPurchLine.SetRange("Document Type", PurchHeader."Document Type");
        recPurchLine.SetRange("Document No.", PurchHeader."No.");
        if recPurchLine.Find('-') then begin
            recItem.Get(recPurchLine."No.");
            cdLocation := recItem."fc location";
        end;

        // if Retailuser.Get(UserId) then//Block by naveen---210723
        //     if Store.Get(cdLocation) then begin//240223
        //         // if Store.Get(Retailuser."Store No.") then begin
        //         Store.TestField("Purchase Receipt No. Series");
        //         PurchHeader."Receiving No." := cuNoSeries.GetNextNo(Store."Purchase Receipt No. Series", Today, true);
        //     end;//Block by naveen---210723
    end;

    // OnBeforePurchRcptLineInsert(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean; PostedWhseRcptLine: Record "Posted Whse. Receipt Line"; var IsHandled: Boolean)
    // OnBeforeInsertReceiptLine(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; var CostBaseAmount: Decimal; var IsHandled: Boolean);
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptLineInsert', '', false, false)]
    procedure InsertQCActioninRecptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean; PostedWhseRcptLine: Record "Posted Whse. Receipt Line"; var IsHandled: Boolean)
    var
    begin
        PurchRcptLine."QC Action" := PurchLine."QC Action";
    end;

    // [EventSubscriber(ObjectType::Table, Database::"LSC POS Trans. Line", 'OnAfterModifyEvent', '', false, false)]
    /*
    local procedure Onaftergstgroupcode(var Rec: Record "LSC POS Trans. Line")
    var
        PosTransLine: Record "LSC POS Trans. Line";
        PosTransLine2: Record "LSC POS Trans. Line";
        GSTPerc: Decimal;
        MaxGST: Decimal;
        GSTgCode: Code[20];
        GSTGroupCode: Code[20];
        recIncExp: Record 99001476;
        recGLAccount: Record 15;
        recStore: Record 99001470;
        cdGSTGroup: Code[10];
        decAmount: Decimal;
        cuPosTrans: codeunit 99001570;
        decNewPrice: Decimal;
        decActualAmt: Decimal;
        decGSTAmt: Decimal;
        recIncExpAccount: Record 99001476;
        decGSTPer: Decimal;
        i: Integer;
    begin
        if Rec."Entry Type" = Rec."Entry Type"::IncomeExpense then begin
            if recIncExp.Get(Rec."Store No.", Rec.Number) then
                if recIncExp."Alteration Account" then begin
                    Clear(decGSTPer);
                    // recStore.Get(POSTransaction."Store No.");
                    if not recIncExpAccount.Get(Rec."Store No.", Rec.Number) then exit;
                    if not recIncExpAccount."Alteration Account" then exit;//300323
                    recGLAccount.Reset();
                    recGLAccount.SetRange("No.", recIncExpAccount."G/L Account");
                    if recGLAccount.FindFirst() then
                        cdGSTGroup := recGLAccount."GST Group Code";

                    case cdGSTGroup of
                        'GST 12G':
                            begin
                                decGSTPer := 12
                            end;
                        'GST 18G':
                            begin
                                decGSTPer := 18
                            end;
                        'GST 28G':
                            begin
                                decGSTPer := 28
                            end;
                        'GST 3G':
                            begin
                                decGSTPer := 3
                            end;
                        'GST 5G':
                            begin
                                decGSTPer := 5
                            end;
                    end;



                    if (Rec."Entry Type" = Rec."Entry Type"::IncomeExpense) and
                     (Rec."Entry Status" = Rec."Entry Status"::" ") and (Rec.Number = recIncExpAccount."No.") then begin
                        decActualAmt := Rec.Price;
                        // Original Cost – (Original Cost * (100 / (100 + GST% ) ) )
                        decGSTAmt := Rec.Price - (Rec.Price * (100 / (100 + decGSTPer)));
                        decGSTAmt := Round(decGSTAmt, 0.01, '=');
                        // decAmount := Rec.Price;
                        // decAmount := decAmount - ((decAmount * decGSTPer) / 100);
                        decNewPrice := Rec.Price - decGSTAmt;
                        decNewPrice := Round(decNewPrice, 0.01, '=');
                        Rec.Validate(Price, Rec.Price);
                        // if decActualAmt <= decNewPrice then begin
                        //     Rec.Validate("Net Price", (decNewPrice + decGSTAmt));
                        //     Rec.Validate(Amount, (decNewPrice + decGSTAmt));
                        // end else begin
                        Rec.Validate("Net Price", decNewPrice);
                        Rec.Validate("Net Amount", decNewPrice);
                        Rec.Validate(Amount, Rec.Price);
                        Rec.Validate(Quantity, 1);
                        Rec.Validate("LSCIN GST Group Type", Rec."LSCIN GST Group Type"::Service);
                        Rec.Validate("LSCIN GST Group Code", cdGSTGroup);
                        Rec.Validate("LSCIN GST Amount", decGSTAmt);
                        Rec.Modify();
                    end;
                end;
        end;
    end;
    */
    //     Commit();
    //     Clear(GSTGroupCode);
    //     PosTransLine.Reset();
    //     PosTransLine.SetRange("Receipt No.", Rec."Receipt No.");
    //     PosTransLine.SetRange("Entry Type", PosTransLine."Entry Type"::IncomeExpense);
    //     if PosTransLine.FindFirst() then begin
    //         PosTransLine2.Reset();
    //         PosTransLine2.SetRange("Receipt No.", Rec."Receipt No.");
    //         PosTransLine2.SetRange("Entry Type", Rec."Entry Type"::Item);
    //         if PosTransLine2.FindSet() then
    //             repeat
    //                 GSTPerc := 0;
    //                 Clear(GSTgCode);
    //                 if PosTransLine2."LSCIN GST Group Code" = 'GST 12G' then begin
    //                     GSTPerc := 12;
    //                     GSTgCode := PosTransLine2."LSCIN GST Group Code"
    //                 end;
    //                 if PosTransLine2."LSCIN GST Group Code" = 'GST 18G' then begin
    //                     GSTPerc := 18;
    //                     GSTgCode := PosTransLine2."LSCIN GST Group Code"
    //                 end;
    //                 if PosTransLine2."LSCIN GST Group Code" = 'GST 28G' then begin
    //                     GSTPerc := 28;
    //                     GSTgCode := PosTransLine2."LSCIN GST Group Code"
    //                 end;
    //                 if PosTransLine2."LSCIN GST Group Code" = 'GST 5G' then begin
    //                     GSTPerc := 5;
    //                     GSTgCode := PosTransLine2."LSCIN GST Group Code"
    //                 end;

    //                 if GSTPerc > MaxGST then begin
    //                     MaxGST := GSTPerc;
    //                     GSTGroupCode := GSTgCode;
    //                 end;

    //             until PosTransLine2.Next() = 0;
    //         if GSTGroupCode <> '' then
    //             PosTransLine.Validate("LSCIN GST Group Code", GSTGroupCode)
    //         else
    //             PosTransLine.Validate("LSCIN GST Group Code", 'GST 5G');
    //         PosTransLine.Modify();
    //     end;

    // end;
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure ValidateGSTMasteronQuantity(var Rec: Record "Purchase Line")
    var
        FnCodeunit: Codeunit Functions;
    begin
        Rec.TestField("No.");
        FnCodeunit.ValidateGSTMasterforLineAmount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Direct Unit Cost', false, false)]
    local procedure ValidateGSTMasterDirectUnitCost(var Rec: Record "Purchase Line")
    var
        FnCodeUnit: Codeunit Functions;
    begin
        Rec.TestField("No.");
        FnCodeUnit.ValidateGSTMasterforLineAmount(Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransferOrderPostReceipt', '', false, false)]
    local procedure OnAfterTransferOrderPostReceipt(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferReceiptHeader: Record "Transfer Receipt Header");
    var
        TransferLine: Record "Transfer Line";
        RecItem: Record Item;
        RecItem1: Record Item;
        RetailUser: Record "LSC Retail User";
        TransferLine1: Record "Transfer Line";
    begin
        TransferLine.Reset();
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindFirst() then begin
            if RecItem.Get(TransferLine."Item No.") then begin
                RetailUser.Get(UserId);
                if (RecItem."Store No." = RetailUser."Store No.") AND (RecItem."Blocked By User ID" = RetailUser.ID) then begin
                    RecItem.ItemSaleReserved := false;
                    RecItem."Store No." := '';
                    RecItem."Blocked By User ID" := '';
                    RecItem.Modify();
                end;
            end;
        end;

        // TransferLine1.Reset();
        // TransferLine1.SetRange("Document No.", TransferHeader."No.");
        // if TransferLine1.FindFirst() then
        //     repeat
        //         if RecItem1.Get(TransferLine1."Item No.") then begin
        //             RecItem1."Is Approved for Sale" := true;
        //             RecItem1.Modify();
        //         end;
        //     until TransferLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Mgt.", 'OnAfterCalculateShipToBillToOptions', '', false, false)]
    local procedure OnAfterCalculateShipToBillToOptions(var ShipToOptions: Option; var BillToOptions: Option; SalesHeader: Record "Sales Header");
    var
        ShipToOptionsVar: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
    begin
        ShipToOptions := ShipToOptionsVar::"Custom Address";
        // Message('%1', ShipToOptions);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reference Invoice No. Mgt.", 'OnBeforeCheckRefInvNoSalesHeader', '', false, false)]
    local procedure OnBeforeCheckRefInvNoSalesHeader(var SalesHeader: Record "Sales Header"; IsHandled: Boolean)

    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure OnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer; GlobalValueEntry: Record "Value Entry"; TransferItem: Boolean; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; var OldItemLedgerEntry: Record "Item Ledger Entry");
    var
        Item: Record Item;
    begin
        if ItemLedgerEntry.Description = '' then begin
            if Item.Get(ItemLedgerEntry."Item No.") then
                ItemLedgerEntry.Description := Item.Description;
            ItemLedgerEntry.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var Sender: Codeunit "Purch.-Post"; var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line");
    var
        purchLine1: Record "Purchase Line";
        PurchLine: Record "Purchase Line";
        PurchLinepo: Record "Purchase Line";
        LineNo: Integer;
        CU_Functions: Codeunit Functions;
        postData: Text[50];
        ApiError: Boolean;
        PurHeader1: Record "Purchase Header";
    begin
        purchLine1.Reset();
        purchLine1.SetRange("Document Type", PurchaseHeader."Document Type");
        purchLine1.SetRange("Document No.", PurchaseHeader."No.");
        if purchLine1.FindSet() then
            repeat
                if (purchLine1."Direct Unit Cost" = 0) or (purchLine1."Direct Unit Cost" = 1) then
                    Error('Direct Unit cost not equal to 0 or 1');
            until purchLine1.Next() = 0;
        // if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order") then
        //     if PurchaseHeader.Ship = true then begin
        //         if PurchaseHeader."RTV Reason" = PurchaseHeader."RTV Reason"::"For Alteration" then begin
        //             //for reopen purchase order and also insert new line
        //             PurHeader1.Reset();
        //             PurHeader1.SetRange("Document Type", PurHeader1."Document Type"::Order);
        //             PurHeader1.SetRange("No.", PurchaseHeader.PoNoForRTV);
        //             if PurHeader1.FindFirst() then begin
        //                 PurHeader1.Validate(Status, PurHeader1.Status::Open);
        //                 PurHeader1.Modify();

        //                 PurchLine.Reset();
        //                 PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        //                 PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        //                 PurchLine.SetFilter("Return Qty. to Ship", '<>%1', 0);
        //                 if PurchLine.FindFirst() then begin
        //                     LineNo := PurchLine."Line No." + 10010;
        //                     PurchLinepo.Init();
        //                     PurchLinepo.Validate("Document Type", PurchLinepo."Document Type"::Order);
        //                     PurchLinepo.Validate("Document No.", PurHeader1."No.");
        //                     PurchLinepo."Line No." := LineNo;
        //                     PurchLinepo.Type := PurchLine.Type;
        //                     PurchLinepo.Validate("No.", PurchLine."No.");
        //                     PurchLinepo.Validate("Unit of Measure", 'PCS');
        //                     PurchLinepo."Location Code" := PurchLine."Location Code";
        //                     PurchLinepo.Validate(Quantity, PurchLine.Quantity);
        //                     PurchLinepo.Validate("Direct Unit Cost", PurchLine."Direct Unit Cost");
        //                     if PurchLinepo.Insert() then
        //                         Message('New PO line inserted');
        //                 end;
        //             end;
        //         end;
        //     end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header");
    var
        purchLine1: Record "Purchase Line";
        PurchLine: Record "Purchase Line";
        PurchLinepo: Record "Purchase Line";
        LineNo: Integer;
        CU_Functions: Codeunit Functions;
        postData: Text[50];
        ApiError: Boolean;
        PurHeader1: Record "Purchase Header";
        PurchLine2: Record 39;
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order") then
            if PurchaseHeader.Ship = true then begin
                if PurchaseHeader."RTV Reason" = PurchaseHeader."RTV Reason"::"For Alteration" then begin
                    //for reopen purchase order and also insert new line
                    PurHeader1.Reset();
                    PurHeader1.SetRange("Document Type", PurHeader1."Document Type"::Order);
                    PurHeader1.SetRange("No.", PurchaseHeader.PoNoForRTV);
                    if PurHeader1.FindFirst() then begin
                        PurHeader1.Validate(Status, PurHeader1.Status::Open);
                        PurHeader1.Modify();

                        PurchLine.Reset();
                        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
                        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
                        //PurchLine.SetFilter("Return Qty. to Ship", '<>%1', 0);
                        PurchLine.SetFilter("Return Qty. Shipped", '<>%1', 0);
                        if PurchLine.FindFirst() then begin
                            // if PurchLine.Find('-') then begin
                            PurchLine2.Reset();
                            PurchLine2.SetRange("Document Type", PurHeader1."Document Type");
                            PurchLine2.SetRange("Document No.", PurHeader1."No.");
                            // if PurchLine2.FindLast() then begin
                            if PurchLine2.Find('+') then begin

                                LineNo := PurchLine2."Line No." + 10;
                            end;
                            PurchLinepo.Init();
                            PurchLinepo.Validate("Document Type", PurchLinepo."Document Type"::Order);
                            PurchLinepo.Validate("Document No.", PurHeader1."No.");
                            PurchLinepo."Line No." := LineNo;
                            PurchLinepo.Type := PurchLine.Type;
                            PurchLinepo.Validate("No.", PurchLine."No.");
                            PurchLinepo.Validate("Unit of Measure", 'PCS');
                            PurchLinepo."Location Code" := PurchLine."Location Code";
                            PurchLinepo.Validate(Quantity, PurchLine.Quantity);
                            PurchLinepo.Validate("Direct Unit Cost", PurchLine."Direct Unit Cost");
                            if PurchLinepo.Insert() then
                                Message('New PO line inserted');
                        end;
                    end;
                end;
            end;
    end;
    //For store po
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDocforstore(var PurchaseHeader: Record "Purchase Header"; PurchRcpHdrNo: Code[20]);
    var
        purchLine1: Record "Purchase Line";
        PurchLine: Record "Purchase Line";
        PurchLinepo: Record "Purchase Line";
        LineNo: Integer;
        CU_Functions: Codeunit Functions;
        PurHeader1: Record "Purchase Header";
        PurchLine2: Record 39;
        PLine: Record 39;
        PLine1: Record 39;
        Item: Record 27;
        Item1: Record 27;
        ItemNo: Code[20];
    begin
        //For Po No. Updation on item>>>>>>>>
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then begin
            PLine1.Reset();
            PLine1.SetRange("Document No.", PurchaseHeader."No.");
            if PLine1.FindSet() then
                repeat
                    if Item1.Get(PLine1."No.") then begin
                        Item1."PO No." := PurchaseHeader."No.";
                        Item1."1st GRN Date" := Today;
                        Item1."GRN No." := PurchRcpHdrNo;
                        Item1."fc location" := PurchaseHeader."Location Code";//AS061023
                        Item1.Modify();
                    end;
                until PLine1.Next() = 0;
        end;
        //for reopen purchase order and also insert new line
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order") then
            if PurchaseHeader.Ship = true then begin
                if PurchaseHeader."RTV Reason" = PurchaseHeader."RTV Reason"::"For Alteration" then begin

                    PLine.Reset();
                    PLine.SetRange("Document Type", PurchaseHeader."Document Type");
                    PLine.SetRange("Document No.", PurchaseHeader."No.");
                    if PLine.FindFirst() then begin
                        ItemNo := PLine."No.";
                    end;
                    Item.Get(ItemNo);
                    PurHeader1.Reset();
                    PurHeader1.SetRange("Document Type", PurHeader1."Document Type"::Order);
                    PurHeader1.SetRange("No.", Item."PO No.");
                    if PurHeader1.FindFirst() then begin
                        PurHeader1.Validate(Status, PurHeader1.Status::Open);
                        PurHeader1.Modify();

                        PurchLine.Reset();
                        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
                        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
                        //PurchLine.SetFilter("Return Qty. to Ship", '<>%1', 0);
                        PurchLine.SetFilter("Return Qty. Shipped", '<>%1', 0);
                        if PurchLine.FindFirst() then begin
                            PurchLine2.Reset();
                            PurchLine2.SetRange("Document Type", PurHeader1."Document Type");
                            PurchLine2.SetRange("Document No.", PurHeader1."No.");
                            // if PurchLine2.FindLast() then begin
                            if PurchLine2.Find('+') then begin

                                LineNo := PurchLine2."Line No." + 10;
                            end;
                            PurchLinepo.Init();
                            PurchLinepo.Validate("Document Type", PurchLinepo."Document Type"::Order);
                            PurchLinepo.Validate("Document No.", PurHeader1."No.");
                            PurchLinepo."Line No." := LineNo;
                            PurchLinepo.Type := PurchLine.Type;
                            PurchLinepo.Validate("No.", PurchLine."No.");
                            PurchLinepo.Validate("Unit of Measure", 'PCS');
                            PurchLinepo."Location Code" := PurchLine."Location Code";
                            PurchLinepo.Validate(Quantity, PurchLine.Quantity);
                            PurchLinepo.Validate("Direct Unit Cost", PurchLine."Direct Unit Cost");
                            if PurchLinepo.Insert() then
                                Message('New PO line inserted for store PO');
                        end;
                    end;
                end;
            end;
    end;

    [EventSubscriber(ObjectType::table, Database::"LSC Retail User", 'OnAfterValidateEvent', 'Adminstrator', false, false)]
    local procedure MyProcedure1(Rec: Record "LSC Retail User")
    var
        RetUser: Record "LSC Retail User";
        int: Integer;
    begin
        IF Rec.Adminstrator = false THEN BEGIN
            RetUser.Reset();
            RetUser.SetRange(Adminstrator, true);
            int := RetUser.Count;
            if int = 1 then
                // if not RetUser.FindFirst() then begin
                Error('Atleast one Administrator should be true');
            //   end;
        end;
    end;
    //AS++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    local procedure OnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean);
    begin
        TransShptHeader."Transfer Reason" := TransHeader."Transfer Reason";
        TransShptHeader.Merchandiser := TransHeader.Merchandiser;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', false, false)]
    local procedure OnBeforeTransRcptHeaderInsert(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header");
    begin
        TransferReceiptHeader."Transfer Reason" := TransferHeader."Transfer Reason";
        TransferReceiptHeader.Merchandiser := TransferHeader.Merchandiser;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean);
    begin

    end;

    //Nkp++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]
    procedure OnAfterTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferShipmentHeader: Record "Transfer Shipment Header")
    var
        transShipHdr: Record "Transfer Shipment Header";
        RecLocation: Record Location;
        REcState: Record State;
        LocationGSTNo: Code[30];
        cuTransferAPI: Codeunit 50156;//commented due to errors 180423
        UserIDState: Text;
        PasswordState: Text;
        AuthToken: text;

    begin
        IF NOT CONFIRM('Do you want to Generate IRN ?', FALSE)
                     THEN
            EXIT;

        UserIDState := '';
        PasswordState := '';
        LocationGSTNo := '';

        RecLocation.RESET;
        RecLocation.SETRANGE(RecLocation.Code, TransferShipmentHeader."Transfer-from Code");
        IF RecLocation.FINDFIRST THEN BEGIN
            LocationGSTNo := RecLocation."GST Registration No.";
        END;

        REcState.RESET;
        REcState.SETRANGE(REcState.Code, RecLocation."State Code");
        IF REcState.FINDFIRST THEN BEGIN
            UserIDState := REcState."User Id";
            PasswordState := REcState.Password;
        END;

        IF LocationGSTNo = '' THEN
            ERROR('GST Reg No must not be blank for state %1', RecLocation."State Code");

        IF UserIDState = '' THEN
            ERROR('User ID must not be blank for state %1', RecLocation."State Code");

        IF PasswordState = '' THEN
            ERROR('Password must not be blank for state %1', RecLocation."State Code");


        //commented due to errors 180423
        AuthToken := 'Bearer ' + cuTransferAPI.GenerateAuthToken('D9BA800FBB71466B9F74D954F914BF97', '2DF7F0D2G4E9FG4EEFGB4E6GF0955698EB73');
        cuTransferAPI.GenerateIRN(UserIDState, PasswordState, LocationGSTNo, AuthToken, TransferShipmentHeader);
        // cuTransferAPI.GenerateIRN('adqgspjkusr1', 'Gsp@1234', '01AMBPG7773M002', AuthToken, TransferShipmentHeader);
        //transShipHdr.Update(true);
        TransferShipmentHeader.Modify();
        // end;
    end;
    //Nkp--

    //commented due to error in API calling
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostpurchsedoc(var PurchaseHeader: Record "Purchase Header");
    var
        PurchLine: Record "Purchase Line";
        PurchLinepo: Record "Purchase Line";
        LineNo: Integer;
        CU_Functions: Codeunit Functions;
        postData: Text[50];
        ApiError: Boolean;
        PurHeader1: Record "Purchase Header";
        Jsobject: JsonObject;
        BOOl: Boolean;
        //  CU_Functions: Codeunit Functions;
        PurchaseHeader_new: Record "Purchase Header";
        PurchaseLine_l: Record "Purchase Line";
        cuPurchPost: Codeunit "Purch.-Post";
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) AND (PurchaseHeader."Location Code" <> 'ONL')
       AND (PurchaseHeader."Location Code" <> 'KWH') AND (PurchaseHeader."Location Code" <> 'AOD')
        AND (PurchaseHeader."Location Code" <> 'AOM') AND (PurchaseHeader."Location Code" <> 'AOM_15') then begin

            if PurchaseHeader.Receive = true then begin
                //Message('hi');
                PurchLine.Reset();
                PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchLine.SetRange("Document No.", PurchaseHeader."No.");
                //PurchLine.SetFilter("Qty. to Receive", '<>%1', 0);
                PurchLine.SetFilter("Quantity Received", '<>%1', 0);
                if PurchLine.FindSet() then;
                repeat//block by Naveen --220723
                    if not CU_Functions.StorePUTapi(PurchLine."No.") then
                        //ApiError := true;
                          Message('Store PUT API Error %1', GetLastErrorText());
                until PurchLine.Next() = 0;//block by Naveen --220723
            end;
            //>>>>>
            PurchaseLine_l.Reset();
            PurchaseLine_l.SetRange("Document No.", PurchaseHeader."No.");
            PurchaseLine_l.SetRange(Type, PurchaseLine_l.type::Item);
            PurchaseLine_l.SetFilter("Damaged Qty", '<>%1', 0);
            If PurchaseLine_l.FindSet() then begin
                repeat
                    if not PurchaseLine_l.RTVboo then begin
                        CU_Functions.CreatePurchaseReturnOrderHeader(PurchaseHeader, PurchaseHeader_new);
                        CU_Functions.CreatePurchaseReturnOrderLine(PurchaseLine_l, PurchaseHeader_new);
                        // until PurchaseLine_l.next = 0;
                        if CU_Functions.PostShipmentRTV(PurchaseHeader_new) then begin
                            Message('RTV Posted For damaged qty');
                            PurchaseLine_l.RTVboo := true;
                            PurchaseLine_l.Modify();
                        end else
                            Message('RTV  not Posted For damaged qty and error: %1', GetLastErrorText());
                    end;
                until PurchaseLine_l.next = 0;
            end;
            //<<<<<<<<<<<<<
        end;
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order") AND (PurchaseHeader."Location Code" <> 'ONL')
       AND (PurchaseHeader."Location Code" <> 'KWH') AND (PurchaseHeader."Location Code" <> 'AOD')
        AND (PurchaseHeader."Location Code" <> 'AOM') AND (PurchaseHeader."Location Code" <> 'AOM_15') then begin
            if PurchaseHeader.Ship = true then begin
                PurchLine.Reset();
                PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchLine.SetRange("Document No.", PurchaseHeader."No.");
                //PurchLine.SetFilter("Return Qty. to Ship", '<>%1', 0);
                PurchLine.SetFilter("Return Qty. Shipped", '<>%1', 0);
                if PurchLine.FindSet() then
                    repeat
                        if PurchaseHeader."RTV Reason" = PurchaseHeader."RTV Reason"::"For Alteration" then begin
                            // Jsobject.Add('action_id', 1);
                            // Jsobject.WriteTo(postData);
                            BOOl := true;
                        end else begin
                            // Jsobject.Add('action_id', 13);
                            // Jsobject.WriteTo(postData);
                            BOOl := false;
                        end;
                        if not CU_Functions.StorePUTapiforReturnorder(PurchLine."No.", BOOl) then //Block by Naveen --- 220723
                            Message('Store PUT API Error for Return order %1', GetLastErrorText());
                    // ApiError := true; //Block by Naveen --- 220723
                    until PurchLine.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure CreateReturnOrderForDamagedQty(PurchaseHeader: Record "Purchase Header"; PurchRcpHdrNo: Code[20])
    var
        CU_Functions: Codeunit Functions;
        PurchaseHeader_new: Record "Purchase Header";
        PurchaseLine_l: Record "Purchase Line";
        cuPurchPost: Codeunit "Purch.-Post";
    begin

        // PurchaseLine_l.Reset();
        // PurchaseLine_l.SetRange("Document No.", PurchaseHeader."No.");
        // PurchaseLine_l.SetRange(Type, PurchaseLine_l.type::Item);
        // PurchaseLine_l.SetFilter("Damaged Qty", '<>%1', 0);
        // If PurchaseLine_l.FindSet() then begin
        //     CU_Functions.CreatePurchaseReturnOrderHeader(PurchaseHeader, PurchaseHeader_new);
        //     repeat
        //         CU_Functions.CreatePurchaseReturnOrderLine(PurchaseLine_l, PurchaseHeader_new);
        //     until PurchaseLine_l.next = 0;
        //     if CU_Functions.PostShipmentRTV(PurchaseHeader_new) then
        //         Message('RTV Posted For damaged qty') else
        //         Message('RTV  not Posted For damaged qty and error: %1', GetLastErrorText());
        // end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterRejectSelectedApprovalRequest', '', false, false)]
    local procedure OnAfterRejectSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry");
    var
        RetailUser: Record "LSC Retail User";
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTP: Codeunit "SMTP Mail";
        VarSender: Text[80];
        VarRecipient: List of [Text];
        VarRecipient2: List of [Text];
        COmment: Text[100];
        PO_No: RecordId;
        PoNo: Code[50];
        POAmt: Code[30];
        Details: Text[100];
        VendorName: Text[100];
        UserSetup: Record "User Setup";
        ApprovalCommentLine: Record "Approval Comment Line";
        Position: Integer;
        PurNo: Code[50];
    begin
        RetailUser.Get(UserId);
        if RetailUser.ID <> ApprovalEntry."Sender ID" then begin
            PO_No := ApprovalEntry."Record ID to Approve";
            PoNo := Format(PO_No);
            Position := StrPos(PoNo, ',');
            PurNo := DelStr(PoNo, 1, Position);

            Details := ApprovalEntry.RecordDetails();
            ApprovalCommentLine.Reset();
            ApprovalCommentLine.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            if ApprovalCommentLine.FindFirst() then
                COmment := ApprovalCommentLine.Comment;

            SMTPMailSetup.Get();
            VarSender := SMTPMailSetup."User ID";
            if UserSetup.Get(ApprovalEntry."Sender ID") then
                VarRecipient.Add(UserSetup."E-Mail");
            ///>>>>>>
            SMTPMailSetup.GET;
            SMTP.CreateMessage('CCIT', VarSender, VarRecipient, 'Item Rejection Notification-AZA Admin', '');
            // SMTP.GetCC(VarRecipient2);
            // VarRecipient2.Add(Store2.Email2);
            // SMTP.AddCC(VarRecipient2);
            SMTP.AppendBody('Dear Sir/Madam');
            SMTP.AppendBody('<br><Br>');
            SMTP.AppendBody('Purchase Order-' + Format(PurNo) + ' Vendor Name-' + Format(Details) + ' is rejected');
            SMTP.AppendBody('<br>');
            SMTP.AppendBody('Comment- ' + Format(COmment));
            SMTP.AppendBody('<br><Br>');
            //SMTP.AppendBody('<br><Br>');
            SMTP.AppendBody('AZA Admin');
            if SMTP.Send then
                MESSAGE('Rejection Email Sent Successfully');
        end else
            Error('Retail user and approval sender Id is same');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure VendorvalidattionError(var Rec: Record "Purchase Line")
    var
        item: Record Item;
        PurchHdr: Record "Purchase Header";
    begin
        item.Get(Rec."No.");
        if PurchHdr.Get(PurchHdr."Document Type"::"Return Order", Rec."Document No.") then
            if PurchHdr."Buy-from Vendor No." <> item."Vendor No." then
                Error('This Item is related to another vendor');//else begin
                                                                // Rec.Validate(Quantity, 1);
                                                                // Rec.Validate("GST Group Code", '');
                                                                // Rec.Validate("HSN/SAC Code", '');
                                                                //Rec.Modify();
                                                                // end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header");
    var
        PurchLine: Record 39;
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if PurchaseHeader.Receive then begin
                PurchLine.Reset();
                PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchLine.SetRange("Document No.", PurchaseHeader."No.");
                PurchLine.SetFilter("Qty. to Receive", '>%1', 0);
                if not PurchLine.FindFirst() then
                    Error('There is nothing to post');
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Return Order", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure ProcedureforrtvReason(var Rec: Record "Purchase Header")
    begin
        if Rec."RTV Reason" = Rec."RTV Reason"::" " then
            Error('Please select RTV reason');

    end;

    [EventSubscriber(ObjectType::Page, page::"Purchase Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure MyProcedure(var Rec: Record "Purchase Line")
    var
        Item: Record Item;
    begin
        if Rec.Quantity <> 0 then
            if Item.Get(Rec."No.") then begin
                Item."PO No." := Rec."Document No.";
                Item.Modify();
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure MyProcedure11(var Rec: Record "Purchase Line")
    var
        LscBarcodes: Record "LSC Barcodes";
    begin
        LscBarcodes.Reset();
        LscBarcodes.SetRange("Barcode No.", Rec."No.");
        if LscBarcodes.FindFirst() then begin
            Rec.Validate("No.", LscBarcodes."Item No.");
            exit;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnBeforeValidateEvent', 'Item No.', false, false)]
    local procedure CheckInventory(var Rec: Record "Transfer Line")
    var
        TransHdr: Record "Transfer Header";
        ItemLedgEnrty: Record "Item Ledger Entry";
        Item: Record Item;
    begin
        TransHdr.Reset();
        TransHdr.SetRange("No.", Rec."Document No.");
        If TransHdr.FindFirst() then begin
            ItemLedgEnrty.Reset();
            ItemLedgEnrty.SetRange("Item No.", Rec."Item No.");
            ItemLedgEnrty.SetRange("Location Code", TransHdr."Transfer-from Code");
            if ItemLedgEnrty.FindLast() then begin
                if ItemLedgEnrty."Remaining Quantity" = 0 then
                    Error('Inventory for this item is not availabe');
            end else
                Error('Inventory for this item is not availabe');
        end;
        if Item.Get(Rec."Item No.") then
            if Item."Is Approved for Sale" = false then
                Error('Please approve item for sale');
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnBeforeInsertEvent', '', false, false)]
    // local procedure OnAfterAssignItemValues1(var Rec: Record "Transfer Line");
    // var
    //     RecItem: Record Item;
    //     myInt: Integer;
    // begin
    //     if RecItem.Get(Rec."Item No.") then begin
    //         Rec.validate(Quantity, 1);
    //         Rec.Validate("Transfer Price", RecItem."Unit Cost");
    //         //Message('hi');
    //     end;
    // end;
    [EventSubscriber(ObjectType::Page, Page::"Transfer Order Subform", 'OnInsertRecordEvent', '', false, false)]
    local procedure MyProcedure1111(var Rec: Record "Transfer Line")
    var
        RecItem: Record Item;
        myInt: Integer;
    begin
        if RecItem.Get(Rec."Item No.") then begin
            Rec.validate(Quantity, 1);
            Rec.Validate("Transfer Price", RecItem."Unit Cost");
            // Message('hi');
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure FCupdationonitem(var Rec: Record "Item Journal Line")
    var
        Item: Record Item;
    begin
        if Rec."Entry Type" = Rec."Entry Type"::"Positive Adjmt." then begin
            if Item.Get(Rec."Item No.") then begin
                Item."fc location" := Rec."Location Code";
                item.Modify();
                //  Message('hi codeunit');
            end;
        end;
    end;


    var
        myInt: Integer;
        glInvoiceNum: Code[30];

}

