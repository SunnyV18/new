report 50117 "Advance Receipt"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'AdvanceReceipt.rdl';

    dataset
    {

        dataitem("LSC Transaction Header"; "LSC Transaction Header")
        {

            RequestFilterFields = "Transaction No.";
            DataItemTableView = sorting("Transaction No.");

            //column("LSC Transaction Header";"LSC Transaction Header".)
            column(FistName; FistName)
            {

            }

            column(lastName; lastName)
            {

            }
            column(Customer_No_; "Customer No.")
            {

            }
            column(State; State)
            {

            }
            column(Country; Country)
            {

            }

            column(Store_No_; "Store No.")
            {
            }
            column(No__of_Invoices; "No. of Invoices")
            {

            }
            column(Receipt_No_; "Receipt No.")
            {

            }
            column(Date; Date)
            {

            }
            column(Time; Time)
            {

            }

            column(Transaction_Type; "Transaction Type")
            {

            }
            column(LSCIN_Customer_GST_Reg__No_; "LSCIN Customer GST Reg. No.")
            {

            }
            column(pancard; pancard)
            {

            }
            column(storename; storename)
            {

            }
            column(storeaddress; storeaddress)
            {

            }
            column(storeaddress2; storeaddress2)
            {

            }
            column(storepincode; storepincode)
            {

            }
            column(storePhoneNo; storePhoneNo)
            {

            }
            column(store_email; store_email)
            {

            }
            column(StoreGST; StoreGST)
            {

            }
            column(add2; add2)
            {

            }
            column(Add1; Add1)
            {

            }
            column(shipto_name; shipto_name)
            {

            }

            column(storecountry; storecountry)
            {

            }

            column(Trans__Currency; "Trans. Currency")
            {
            }
            column(currency; currency)
            {

            }
            column(Comment; Comment)
            {

            }
            column(Comment1; Comment1)
            {

            }
            column(Comment2; Comment2)
            {

            }
            column(compnyInfoName; compnyInfo.Name)
            {

            }
            column(compnyInfoadd; compnyInfo.Address)
            {

            }
            column(compnyInfoadd2; compnyInfo."Address 2")
            {

            }
            column(compnyInfocountry; compnyInfo.County)
            {

            }
            column(compnyInfopostcode; compnyInfo."Post Code")
            {

            }
            column(compnyInfo; compnyInfo."CIN No.")
            {

            }
            column(compnyInfohomepage; compnyInfo."Home Page")
            {

            }
            column(LSC_Trans__Add__Salesperson; "LSC Trans. Add. Salesperson"."First Name")
            {

            }
            column(Aza_Posting_No_; "Aza Posting No.")
            {

            }
            column(TendAmt; TendAmt)
            {

            }
            column(des; des)
            {

            }
            column(Customer_Order; "Customer Order")
            {

            }
            column(ANBoo; ANBoo)
            {

            }
            column(Customer_Order_ID; "Customer Order ID")
            {

            }
            Column(AdvanceCode; AdvanceCode)
            {

            }
            column(CustNo; CustNo)
            {

            }
            dataitem("LSC Trans. Sales Entry"; "LSC Trans. Sales Entry")
            {
                DataItemTableView = sorting("Store No.", "POS Terminal No.", "Transaction No.", "Line No.");
                DataItemLink = "Transaction No." = field("Transaction No."), "Store No." = FIELD("Store No."),
                                                                              "POS Terminal No." = FIELD("POS Terminal No.");
                DataItemLinkReference = "LSC Transaction Header";
                column(LSCIN_HSN_SAC_Code; "LSCIN HSN/SAC Code")
                {

                }
                column(Item_No_; "Item No.")
                {

                }

                column(Customer_No_2; "Customer No.")
                {

                }
                column(vc; vc)
                {

                }
                column(VAT_Code; "VAT Code")
                {

                }
                // column(des; des)
                // {

                // }
                column(Price; Price)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(VAT_Amount; "VAT Amount")
                {

                }
                column(LSCIN_GST_Amount; "LSCIN GST Amount")
                {

                }
                column(Amount; "Net Amount")
                {

                }
                column(GST_Amount; "GST Amount")
                {

                }
                column(GST_Percentage; "GST Percentage")
                { }
                column(IGST; IGST)
                {

                }
                column(IGSTAmount; IGSTAmount)
                {

                }
                column(SGST_Amt; SGST_Amt)
                {

                }
                column(SGSTpercent; SGSTpercent)
                {

                }
                column(CGST_Amt; CGST_Amt)
                {

                }
                column(cGSTpercent; cGSTpercent)
                {

                }
                column(TotalGSTAmount; TotalGSTAmount)
                {

                }
                column(item_vc; item.azaCode)
                {

                }
                column(SGSTBoo; SGSTBoo)
                {

                }
                column(CGSTBoo; CGSTBoo)
                {

                }
                column(IGSTBoo; IGSTBoo)
                {

                }
                // column(TendAmt; TendAmt)
                // {

                // }

                column(Staffname; Staffname)
                {

                }
                trigger OnAfterGetRecord()
                var

                    TaxTransactionValue: Record "LSCIN Tax Transaction Value";
                    taxrecordId: RecordId;
                    itemcard: Page "LSC Retail Item Card";

                    TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
                    ComponentAmt: Decimal;
                    decColumnAmt: Decimal;
                    Payment: Record "LSC Customer Order Payment";
                begin
                    if item.get("Item No.") then
                        des := item.Description;
                    VC := item."Vendor No.";

                    //    Message('ID %1', "LSC Trans. Sales Entry".RecordId);
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetFilter("Tax Record ID", '%1', "LSC Trans. Sales Entry".RecordId);
                    TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Visible on Interface", true);
                    TaxTransactionValue.SetFilter(Amount, '<>%1', 0);

                    // TaxTransactionValue.SetRange("Tax Type", 'GST');

                    // if TaxTransactionValue.FindSet() then begin
                    if TaxTransactionValue.Find('-') then
                        repeat

                            IF (TaxTransactionValue.GetAttributeColumName() <> 'GST Base Amount') AND (TaxTransactionValue.GetAttributeColumName() <> 'Total TDS Amount') THEN BEGIN
                                IF (TaxTransactionValue.GetAttributeColumName() = 'CGST') then begin
                                    // if TaxTransactionValue.Amount < "LSC Trans. Sales Entry"."Net Amount" then begin
                                    CGST_Amt := TaxTransactionValue.Amount;//ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER);
                                    cGSTpercent := TaxTransactionValue.Percent;
                                    // Message('Cgst:=%1', CGST_Amt);
                                    // end;
                                end;
                                if (TaxTransactionValue.GetAttributeColumName() = 'SGST') then begin
                                    // ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
                                    // Evaluate(decColumnAmt, TaxTransactionValue."Column Value");
                                    // taxFound := true;
                                    SGST_Amt := TaxTransactionValue.Amount;
                                    SGSTpercent := TaxTransactionValue.Percent;
                                    // Message('Sgst:=%1', SGST_Amt);
                                end;  //CITS_RS
                                if (TaxTransactionValue.GetAttributeColumName() = 'IGST') THEN BEGIN
                                    IGSTAmount := TaxTransactionValue.Amount;
                                    IGST := TaxTransactionValue.Percent;

                                    // taxFound := true;//CITS_RS

                                end;

                            end;
                        until TaxTransactionValue.next() = 0;
                    TotalGSTAmount := abs(SGST_Amt) + abs(CGST_Amt) + abs(IGSTAmount) + abs("Net Amount");
                    //AS>>
                    if SGSTpercent <> 0 then
                        SGSTBoo := true;
                    if cGSTpercent <> 0 then
                        CGSTBoo := true;
                    if IGST <> 0 then
                        IGSTBoo := true;
                    //AS<<
                    SalesStaff.Reset();
                    //SalesStaff.SetRange("Store No.","LSC Transaction Header"."Store No.");
                    SalesStaff.SetRange(ID, "LSC Trans. Sales Entry"."Sales Staff");
                    if SalesStaff.FindFirst() then begin
                        Staffname := SalesStaff."First Name";
                    end;

                    if item.Get("Item No.") then
                        des := item.Description;
                    PaymentEnt.Reset();
                    PaymentEnt.SetRange("Store No.", "LSC Trans. Sales Entry"."Store No.");
                    PaymentEnt.SetRange("POS Terminal No.", "LSC Trans. Sales Entry"."POS Terminal No.");
                    PaymentEnt.SetRange("Transaction No.", "LSC Trans. Sales Entry"."Transaction No.");
                    if PaymentEnt.FindFirst() then
                        repeat //begin
                            TendAmt += PaymentEnt."Amount Tendered";
                        until PaymentEnt.Next() = 0;
                    // end;
                    ANBoo := false;
                    //  Message('%1', TendAmt);
                end;


            }
            trigger OnAfterGetRecord()
            var
                cust: Record Customer;

                Shipaddress: Record "Ship-to Address";
                TransAddSalesperson: Record "LSC Trans. Add. Salesperson";
                TransAddSalespersonPage: Page "LSC Trans. Add. Salesperson";
                PosCOHdr: Record "LSC Posted CO Header";
                custorder: Record "LSC Customer Order Header";
            // AdvanceCode: Code[50];
            begin
                if compnyInfo.get then;
                if "Customer No." = '' then begin
                    if PosCOHdr.Get("LSC Transaction Header"."Customer Order ID") then begin
                        if cust.get(PosCOHdr."Customer No.") then begin
                            shipto_name := cust.Name;
                            FistName := cust.Name;
                            lastName := cust."Name 2";
                            State := cust."State Code";
                            Country := cust."Country/Region Code";
                            Add1 := cust.Address;
                            add2 := cust."Address 2";
                            pancard := cust."P.A.N. No.";
                            currency := cust."Currency Code";

                        end;
                    end else begin
                        if custorder.Get("LSC Transaction Header"."Customer Order ID") then begin
                            if cust.get(custorder."Customer No.") then begin
                                shipto_name := cust.Name;
                                FistName := cust.Name;
                                lastName := cust."Name 2";
                                State := cust."State Code";
                                Country := cust."Country/Region Code";
                                Add1 := cust.Address;
                                add2 := cust."Address 2";
                                pancard := cust."P.A.N. No.";
                                currency := cust."Currency Code";

                            end;
                        end;
                    end;
                end else begin
                    if cust.get("Customer No.") then begin
                        shipto_name := cust.Name;
                        FistName := cust.Name;
                        lastName := cust."Name 2";
                        State := cust."State Code";
                        Country := cust."Country/Region Code";
                        Add1 := cust.Address;
                        add2 := cust."Address 2";
                        pancard := cust."P.A.N. No.";
                        currency := cust."Currency Code";

                    end;
                end;



                if StoreInfo.get("Store No.") then begin
                    storeName := StoreInfo.Name;
                    StoreAddress := StoreInfo.Address;
                    storeaddress2 := StoreInfo."Address 2";
                    storecountry := StoreInfo."Country Code";
                    storePincode := StoreInfo."Post Code";
                    storePhoneNo := StoreInfo."Phone No.";
                    StoreGST := StoreInfo."LSCIN GST Registration No";
                    store_email := StoreInfo."email id";
                end;
                "LSC Trans. Add. Salesperson".Reset();
                "LSC Trans. Add. Salesperson".SetRange("Transaction No.", "LSC Transaction Header"."Transaction No.");
                if "LSC Trans. Add. Salesperson".FindFirst() then begin
                    "LSC Trans. Add. Salesperson".CalcFields("LSC Trans. Add. Salesperson"."First Name");

                end;


                SGSTBoo := false;
                IGSTBoo := false;

                Clear(Comment);
                Clear(Comment1);
                Clear(Comment2);
                LSCTransInfoEntry.Reset();
                LSCTransInfoEntry.SetRange("Store No.", "LSC Transaction Header"."Store No.");
                LSCTransInfoEntry.SetRange("Transaction No.", "LSC Transaction Header"."Transaction No.");
                LSCTransInfoEntry.SetRange("POS Terminal No.", "LSC Transaction Header"."POS Terminal No.");
                LSCTransInfoEntry.SetRange("Text Type", LSCTransInfoEntry."Text Type"::"Freetext Input");
                if LSCTransInfoEntry.FindFirst() then
                    repeat
                        if Comment = '' then
                            Comment := LSCTransInfoEntry.Information
                        else
                            if Comment1 = '' then
                                Comment1 := LSCTransInfoEntry.Information
                            else
                                if Comment2 = '' then
                                    Comment2 := LSCTransInfoEntry.Information;
                    until LSCTransInfoEntry.Next() = 0;

                Clear(AdvanceCode);
                LSCTransInfoEntry.Reset();
                LSCTransInfoEntry.SetRange("Store No.", "LSC Transaction Header"."Store No.");
                LSCTransInfoEntry.SetRange("Transaction No.", "LSC Transaction Header"."Transaction No.");
                LSCTransInfoEntry.SetRange("POS Terminal No.", "LSC Transaction Header"."POS Terminal No.");
                //LSCTransInfoEntry.SetRange("Type of Input", LSCTransInfoEntry."Type of Input"::"Create Data Entry");
                LSCTransInfoEntry.SetRange(Infocode, 'ADVANCECODE');
                if LSCTransInfoEntry.FindFirst() then
                    AdvanceCode := LSCTransInfoEntry.Information;


                TendAmt := 0;
                PaymentEnt.Reset();
                PaymentEnt.SetRange("Store No.", "LSC Transaction Header"."Store No.");
                PaymentEnt.SetRange("POS Terminal No.", "LSC Transaction Header"."POS Terminal No.");
                PaymentEnt.SetRange("Transaction No.", "LSC Transaction Header"."Transaction No.");
                PaymentEnt.SetRange("Receipt No.", "LSC Transaction Header"."Receipt No.");
                if PaymentEnt.FindSet() then
                    repeat//begin
                        if "LSC Transaction Header"."Customer Order" then begin
                            TendAmt += PaymentEnt."Amount Tendered";
                            des := 'Customer Order Prepayment';
                            ANBoo := true;
                        end;
                    until PaymentEnt.Next() = 0;
                //  end;

                //For Customer no. on header>>>>
                if "LSC Transaction Header"."Customer No." = '' then begin
                    if custorder.Get("LSC Transaction Header"."Customer Order ID") then
                        CustNo := custorder."Customer No.";
                end
                else
                    CustNo := "LSC Transaction Header"."Customer No.";
                //<<<<<<<<<<<<<<<<
            end;

        }

    }

    var
        vc: code[30];
        CustNo: Code[30];
        AdvanceCode: Code[20];
        SalesStaff: Record "LSC Staff";

        ANBoo: Boolean;
        Staffname: Text[20];
        item: Record Item;
        ReportName: text;
        IGST: Decimal;
        IGSTAmount: Decimal;
        "GST Amount": Decimal;
        "GST Percentage": Decimal;
        compnyInfo: Record "Company Information";
        ShipToAddress: Record "Ship-to Address";
        ShipToAddressInfo: Array[10] of Text;
        GetStateBillTo: Record State;
        GetStateShipTo: Record State;
        BillToStateNo: Code[10];
        ReportCheck: Report Check;
        AmountinWords: array[2] of Text[80];
        // TaxTransactionValue: Record "Tax Transaction Value";
        CGSTTotalAmount: Decimal;
        SGSTTotalAmount: Decimal;
        IGSTTotalAmount: Decimal;
        TotalGSTLinePercemntage: Decimal;
        Counter: Integer;
        TotalGSTAmount: Decimal;
        //SalesInvLine: record “Sales Invoice Line”;
        TotalInvoiceValue: decimal;
        RoundOff: Decimal;
        SrNo: Integer;

        HeaderComment: Text;
        LineComment: Text;
        HeaderCommentCounter: Integer;
        LineCommentCounter: Integer;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        SalesLineNo: Text[50];
        GetItem: Record Item;
        Comment1: text[100];
        Comment2: text[100];
        NoOfPrint: Integer;
        CopyText: Text;
        SalesPerson: Record "Salesperson/Purchaser";
        //IndianReportCheck: Report 18041;
        SGST_Amt: Decimal;
        SGSTpercent: Decimal;
        CGST_Amt: Decimal;
        cGSTpercent: Decimal;
        SGSTBoo: Boolean;
        CGSTBoo: Boolean;
        IGSTBoo: Boolean;
        des: text;
        shipto_name: text;
        Add1: text;
        add2: text;
        ShiptoState: text;
        ShipToCountry: text;
        storename: text;
        storeaddress: text;
        storeaddress2: text;
        store_email: text;
        currency: code[30];
        storecountry: text;
        storepincode: code[20];
        storePhoneNo: text[30];
        StoreGST: code[50];
        myInt: Integer;
        FistName: Text;
        lastName: text;
        State: text;
        pancard: code[30];
        Country: text;
        cinNo: Code[30];
        StoreInfo: Record "LSC Store";
        LSCentral: Page "LSC Transaction Card";
        ScriptDatatypeMgmt: Codeunit "Script Data Type Mgmt.";
        Loaded: Boolean;
        "LSC Trans. Add. Salesperson": Record "LSC Trans. Add. Salesperson";
        Page1: page "LSC Transaction Factbox";

        LSCTransInfoEntry: Record "LSC Trans. Infocode Entry";
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        PaymentEnt: Record "LSC Trans. Payment Entry";
        TendAmt: Decimal;










}