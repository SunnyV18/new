report 50113 "CreditNote with IGST"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'CreditNote with IGST.rdl';

    dataset
    {
        dataitem("LSC Transaction Header"; "LSC Transaction Header")
        {
            RequestFilterFields = "Transaction No.";
            DataItemTableView = sorting("Transaction No.") where("Sale Is Return Sale" = const(true));
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
            { }
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

            trigger OnAfterGetRecord()
            var
                cust: Record Customer;

                Shipaddress: Record "Ship-to Address";


            begin
                if compnyInfo.get then;
                if cust.get("Customer No.") then begin
                    shipto_name := cust.Name;
                    FistName := cust.Name;
                    lastName := cust."Name 2";
                    State := cust.city;
                    Country := cust.County;
                    Add1 := cust.Address;
                    add2 := cust."Address 2";
                    pancard := cust."P.A.N. No.";
                    currency := cust."Currency Code";

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


            end;

        }
        dataitem("LSC Trans. Sales Entry"; "LSC Trans. Sales Entry")
        {
            DataItemTableView = sorting("Transaction No.");
            DataItemLink = "Transaction No." = field("Transaction No."); //"Store No." = FIELD("Store No.");
            // "POS Terminal No." = FIELD("POS Terminal No.");
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

            column(VAT_Code; "VAT Code")
            {

            }
            column(des; des)
            {

            }
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





            trigger OnAfterGetRecord()
            var
                item: Record Item;
                TaxTransactionValue: Record "LSCIN Tax Transaction Value";
                taxrecordId: RecordId;
                taxRate: Record "Tax Rate";
                taxppage: page "Tax Rates";
                // recLSCTaxTransVal:Record "LSCIN Tax Transaction Value";
                TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
                ComponentAmt: Decimal;
                decColumnAmt: Decimal;
            begin
                if item.get("Item No.") then
                    des := item.Description;

                //    Message('ID %1', "LSC Trans. Sales Entry".RecordId);
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetFilter("Tax Record ID", '%1', "LSC Trans. Sales Entry".RecordId);
                TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
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
            end;
            // end;
        }


    }

    var
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
        item: Record Item;
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
        v: record "LSC Transaction Header";
        v1: Record "LSC POS Trans. Line";
        v2: Record "LSC Trans. Sales Entry";
        LSCentral: Page "LSC Transaction Card";
        ShipToAddresss: Text;
        shiptoAddress2: text;

        Taxcomponet: Record "Tax Component";
        ScriptDatatypeMgmt: Codeunit "Script Data Type Mgmt.";
        Loaded: Boolean;
        hhhh: Page "LSCIN Tax Information Factbox";
        "LSC Trans. Add. Salesperson": Record "LSC Trans. Add. Salesperson";


}