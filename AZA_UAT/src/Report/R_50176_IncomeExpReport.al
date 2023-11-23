report 50176 "Income Exp. Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'IncomeExpReport.rdl';

    dataset
    {
        dataitem(CopyLoop; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(OutputNo; OutputNo)
            {

            }
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

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
                    column(CustNo; CustNo)
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
                    column(Shiptostate1; Shiptostate1)
                    {

                    }
                    column(ShiptoCountry1; ShiptoCountry1)
                    {

                    }
                    column(GSTno; GSTno)//custGST
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
                    column(Customer_Order; "Customer Order")
                    {

                    }
                    column(Customer_Order_ID; "Customer Order ID")
                    {

                    }
                    column(IRN_Hash; "IRN Hash")
                    {

                    }
                    column(QR_Code; "QR Code")
                    {

                    }
                    dataitem("LSC Trans. Inc./Exp. Entry"; "LSC Trans. Inc./Exp. Entry")
                    {
                        DataItemLink = "Transaction No." = field("Transaction No."), "Store No." = FIELD("Store No."),
                         "POS Terminal No." = FIELD("POS Terminal No.");
                        DataItemLinkReference = "LSC Transaction Header";
                        column(ItmNo; ItmNo)
                        {

                        }
                        column(dess; dess)
                        {

                        }
                        column(Net_Amount; "Net Amount")
                        {

                        }
                        column(Amount; Amount)
                        {

                        }
                        column(IGSTper; IGSTper)
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
                        column(SGSTBoo; SGSTBoo)
                        {

                        }
                        column(IGSTBoo; IGSTBoo)
                        {

                        }

                        trigger OnAfterGetRecord()
                        var
                            IncomeExpAcc: Record "LSC Income/Expense Account";
                            GstGroup: Record "GST Group";
                            Gstpercent: Decimal;
                        begin
                            SGST_Amt := 0;
                            SGSTpercent := 0;
                            cGSTpercent := 0;
                            CGST_Amt := 0;
                            IGSTAmount := 0;
                            IGSTper := 0;
                            // if "LSC Trans. Inc./Exp. Entry"."No." <> '8' then begin
                            if IncomeExpAcc.Get("LSC Trans. Inc./Exp. Entry"."Store No.", "LSC Trans. Inc./Exp. Entry"."No.") then begin
                                ItmNo := IncomeExpAcc."No.";
                                dess := IncomeExpAcc.Description;
                            end;

                            if "LSC Trans. Inc./Exp. Entry"."LSCIN GST Jurisdiction Type" = "LSC Trans. Inc./Exp. Entry"."LSCIN GST Jurisdiction Type"::Interstate then begin
                                //IGST case>>>>>>>>>>>>>>>>>>>>>
                                GstGroup.Reset();
                                GstGroup.SetRange(Code, "LSC Trans. Inc./Exp. Entry"."LSCIN GST Group Code");
                                if GstGroup.FindFirst() then
                                    Gstpercent := GstGroup."GST %";
                                IGSTper := Gstpercent;
                                IGSTAmount := Abs("LSC Trans. Inc./Exp. Entry"."LSCIN GST Amount");
                                // IGSTBoo := true;

                            end else begin
                                //SGST case>>>>>>>>>>>>>>>>>>
                                GstGroup.Reset();
                                GstGroup.SetRange(Code, "LSC Trans. Inc./Exp. Entry"."LSCIN GST Group Code");
                                if GstGroup.FindFirst() then
                                    Gstpercent := GstGroup."GST %";
                                SGSTpercent := Gstpercent / 2;
                                cGSTpercent := Gstpercent / 2;
                                SGST_Amt := Abs("LSC Trans. Inc./Exp. Entry"."LSCIN GST Amount" / 2);
                                CGST_Amt := Abs("LSC Trans. Inc./Exp. Entry"."LSCIN GST Amount" / 2);
                                // SGSTBoo := true;

                            end;
                            //  end;
                            if SGSTpercent <> 0 then
                                SGSTBoo := true;
                            if cGSTpercent <> 0 then
                                CGSTBoo := true;
                            if IGSTper <> 0 then
                                IGSTBoo := true;
                        end;
                    }
                    trigger OnAfterGetRecord()
                    var
                        cust: Record Customer;
                        Cust1: Record 18;
                        CustOrderHed: Record "LSC Posted CO Header";
                        Shipaddress: Record "Ship-to Address";
                        TransAddSalesperson: Record "LSC Trans. Add. Salesperson";
                        TransAddSalespersonPage: Page "LSC Trans. Add. Salesperson";
                    begin
                        if compnyInfo.get then;

                        if "Customer No." <> '' then begin
                            cust.get("Customer No.");
                            if cust."Bill-to Customer No." = '' then begin
                                CustNo := cust."No.";
                                FistName := cust.Name;
                                lastName := cust."Name 2";
                                State := cust."State Code";
                                Country := cust."Country/Region Code";
                                pancard := cust."P.A.N. No.";
                                currency := cust."Currency Code";
                                GSTno := cust."GST Registration No.";
                            end else begin
                                Cust1.get(cust."Bill-to Customer No.");
                                CustNo := Cust1."No.";
                                FistName := Cust1.Name;
                                lastName := Cust1."Name 2";
                                State := Cust1."State Code";
                                Country := Cust1."Country/Region Code";
                                pancard := Cust1."P.A.N. No.";
                                currency := Cust1."Currency Code";
                                GSTno := Cust1."GST Registration No.";
                            end;
                            if cust."Ship-to Code" <> '' then begin
                                if Shipaddress.Get(cust."No.", cust."Ship-to Code") then begin
                                    shipto_name := Shipaddress.Name;
                                    Add1 := Shipaddress.Address;
                                    add2 := Shipaddress."Address 2";
                                    Shiptostate1 := Shipaddress.State;
                                    ShiptoCountry1 := Shipaddress."Country/Region Code";
                                end;
                            end else begin
                                shipto_name := cust.Name;
                                Add1 := cust.Address;
                                add2 := cust."Address 2";
                                Shiptostate1 := cust."State Code";
                                ShiptoCountry1 := cust."Country/Region Code";
                            end;
                        end else begin
                            if CustOrderHed.Get("LSC Transaction Header"."Customer Order ID") then begin
                                if cust.get(CustOrderHed."Customer No.") then begin
                                    if cust."Bill-to Customer No." = '' then begin
                                        CustNo := cust."No.";
                                        FistName := cust.Name;
                                        lastName := cust."Name 2";
                                        State := cust."State Code";
                                        Country := cust.County;
                                        pancard := cust."P.A.N. No.";
                                        currency := cust."Currency Code";
                                        GSTno := cust."GST Registration No.";
                                    end else begin
                                        Cust1.get(cust."Bill-to Customer No.");
                                        CustNo := Cust1."No.";
                                        FistName := Cust1.Name;
                                        lastName := Cust1."Name 2";
                                        State := Cust1."State Code";
                                        Country := Cust1.County;
                                        pancard := Cust1."P.A.N. No.";
                                        currency := Cust1."Currency Code";
                                        GSTno := Cust1."GST Registration No.";
                                    end;
                                    if cust."Ship-to Code" <> '' then begin
                                        if Shipaddress.Get(cust."No.", cust."Ship-to Code") then begin
                                            shipto_name := Shipaddress.Name;
                                            Add1 := Shipaddress.Address;
                                            add2 := Shipaddress."Address 2";
                                            Shiptostate1 := Shipaddress.State;
                                            ShiptoCountry1 := Shipaddress."Country/Region Code";
                                        end;
                                    end else begin
                                        shipto_name := cust.Name;
                                        Add1 := cust.Address;
                                        add2 := cust."Address 2";
                                        Shiptostate1 := cust."State Code";
                                        ShiptoCountry1 := cust."Country/Region Code";
                                    end;
                                end;
                            end;
                        end;
                        if StoreInfo.get("Store No.") then begin
                            storeName := StoreInfo.Name;
                            StoreAddress := StoreInfo.Address;
                            storeaddress2 := StoreInfo."Address 2";
                            storecountry := StoreInfo.County;
                            storePincode := StoreInfo."Post Code";
                            storePhoneNo := StoreInfo."Phone No.";
                            StoreGST := StoreInfo."LSCIN GST Registration No";
                            store_email := StoreInfo."email id";
                        end;

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
                    end;
                }
            }
            trigger OnPreDataItem()
            begin
                NoOfCopies := 1;
                NoOfLoops := Abs(NoOfCopies) + 1;
                CopyText := '';
                SetRange(Number, 1, NoOfLoops);
                OutputNo := 1;
            end;

            trigger OnAfterGetRecord()
            begin
                if Number > 1 then
                    OutputNo += 1;
            end;
        }

    }

    var
        SalesStaff: Record "LSC Staff";
        ItmNo: Code[20];
        dess: Code[30];
        incAmt: Decimal;
        incomePer: Integer;
        incpercentamt: Decimal;
        incAmtTotal: Decimal;
        IncBoo: Boolean;
        Shiptostate1: code[20];
        ShiptoCountry1: Code[20];
        CustNo: Code[20];
        GSTno: Code[30];
        Staffname: Text[20];
        vc: code[30];
        HSN: Code[20];
        item: Record Item;
        ReportName: text;
        IGSTper: Decimal;
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
        ZeroBoo: Boolean;
        des: text;
        shipto_name: text;
        Add1: text;
        add2: text;
        Comment1: text[100];
        Comment2: text[100];
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










}