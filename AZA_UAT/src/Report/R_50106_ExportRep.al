report 50106 "Export Invoice"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Export_Invoice.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(compinfoCountryName; compinfoCountryName) { }
            column(CompInfoIEC; CompInfo."IEC Number") { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoPanNo; CompInfo."P.A.N. No.") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoHomepage; CompInfo."Home Page") { }
            column(CompInfopostcode; CompInfo."Post Code") { }
            column(CompInfoGstRegist; CompInfo."GST Registration No.") { }
            column(CompInfocin; CompInfo."CIN No.") { }
            column(CompInfoPhone; CompInfo."Phone No.") { }
            column(CompanyStateName; CompanyStateName) { }
            column(CompanyStateCode; CompanyStateCode) { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Bill_to_Post_Code; "Bill-to Post Code") { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Bill_to_County; "Bill-to County") { }
            column(CustomerContact; CustomerContact) { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_County; "Ship-to County") { }
            column(LocatGstRegNo; LocatGstRegNo) { }
            column(LocatName; LocatName) { }
            column(LocatAddress; LocatAddress) { }
            column(LocatAddress2; LocatAddress2) { }
            column(LocatPostCode; LocatPostCode) { }
            column(LocatCountryName; LocatCountryName) { }
            column(LocatContact; LocatContact) { }
            column(LocatCity; LocatCity) { }
            column(LocLUTNUMber; LocLUTNUMber) { }
            column(LocCustomerStateCode; LocCustomerStateCode) { }
            column(LocStateName; LocStateName) { }
            column(Transport_Method; "Transport Method") { }
            column(Package_Tracking_No_; "Package Tracking No.") { }
            column(Shipping_Agent_Code; "Shipping Agent Code") { }
            column(BAccNo; BAccNo) { }
            column(SwiftCode; SwiftCode) { }
            column(BankName; BankName) { }
            column(BankAD; BankAD) { }
            column(GSTreg; GSTreg) { }
            column(CustomerGSTRegistrationNo; CustomerGSTRegistrationNo) { }
            column(CustomerPanNo; CustomerPanNo) { }
            column(CustomerStateName; CustomerStateName) { }
            column(CustomerCode; CustomerCode) { }
            column(CustomerServiceZone; CustomerServiceZone) { }
            column(StateDescription; StateDescription) { }
            column(Shipment_Date; "Shipment Date") { }
            column(Text000; Text000) { }
            column(RecDescription; RecDescription) { }
            column(IGST_Payment_Status; "IGST Payment Status") { }
            column(CountName; CountName) { }
            column(Shipment_Method_Code; "Shipment Method Code") { }


            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = FIELD("No.");
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Amount; Amount) { }
                column(SlNo; SlNo) { }
                column(Unit_Price; "Unit Price") { }
                column(Line_Discount_Amount; "Line Discount Amount") { }
                column(GST_Assessable_Value__LCY_; "GST Assessable Value (LCY)") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(CGSTAmt; CGSTAmt) { }
                column(SGSTAmt; SGSTAmt) { }
                column(IGSTAmt; IGSTAmt) { }
                column(GrandTotal; GrandTotal) { }
                column(AmountinWords; AmountinWords[1]) { }
                column(TaxAmountInWords; TaxNoText[1]) { }
                column(TaxTotal; TaxTotal) { }
                column(Total; Total) { }
                column(Currency; Currency) { }
                trigger OnAfterGetRecord()
                var
                    IGSTAMT2: Decimal;
                begin
                    SlNo += 1;
                    if "Sales Invoice Header"."Currency Code" <> '' then begin
                        Currency := "Sales Invoice Header"."Currency Code";
                    end else begin
                        Currency := 'INR';
                    end;

                    /*If "Sales Invoice Header"."Currency Code" = 'USD' then begin
                        Amt := ("Sales Invoice Line".Amount / "Sales Invoice Header"."Currency Factor")
                    end
                    else begin
                        Amt := "Sales Invoice Line".Amount;
                    end;*/

                    DetailedGSTLedgerEntry.RESET;
                    DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SETRANGE("GST Group Code", "GST Group Code");
                    DetailedGSTLedgerEntry.SETFILTER("Transaction Type", '%1', DetailedGSTLedgerEntry."Transaction Type"::Sales);
                    DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
                    IF DetailedGSTLedgerEntry.FIND('-') THEN
                        REPEAT
                            CGSTAmt := Abs(DetailedGSTLedgerEntry."GST Amount");
                            CGSTRate := DetailedGSTLedgerEntry."GST %";
                        UNTIL DetailedGSTLedgerEntry.NEXT() = 0;
                    //SGST
                    DetailedGSTLedgerEntry1.RESET;
                    DetailedGSTLedgerEntry1.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry1.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry1.SETRANGE("GST Group Code", "GST Group Code");
                    DetailedGSTLedgerEntry1.SETFILTER("Transaction Type", '%1', DetailedGSTLedgerEntry1."Transaction Type"::Sales);
                    DetailedGSTLedgerEntry1.SETRANGE("GST Component Code", 'SGST');
                    IF DetailedGSTLedgerEntry1.FIND('-') THEN
                        REPEAT
                            SGSTAmt := Abs(DetailedGSTLedgerEntry1."GST Amount");
                            SGSTRate := DetailedGSTLedgerEntry1."GST %";
                        UNTIL DetailedGSTLedgerEntry1.NEXT() = 0;
                    //IGST
                    DetailedGSTLedgerEntry2.RESET;
                    DetailedGSTLedgerEntry2.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry2.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry2.SETRANGE("GST Group Code", "GST Group Code");
                    DetailedGSTLedgerEntry2.SETFILTER("Transaction Type", '%1', DetailedGSTLedgerEntry2."Transaction Type"::Sales);
                    DetailedGSTLedgerEntry2.SETRANGE("GST Component Code", 'IGST');
                    IF DetailedGSTLedgerEntry2.FindSet() THEN
                        REPEAT
                            IGSTRate := DetailedGSTLedgerEntry2."GST %";
                            IGSTAMT2 := Abs(DetailedGSTLedgerEntry2."GST Amount");

                            if DetailedGSTLedgerEntry2."Currency Code" = '' then
                                IGSTAmt := Abs(DetailedGSTLedgerEntry2."GST Amount")
                            else
                                IGSTAmt := IGSTAMT2 * "Sales Invoice Header"."Currency Factor"
                        UNTIL DetailedGSTLedgerEntry2.NEXT() = 0;
                    //Totals

                    Total := Total + "Sales Invoice Line".Amount;    // Amt;
                    TaxTotal += Abs(CGSTAmt) + AbS(SGSTAmt) + Abs(IGSTAmt);
                    GrandTotal := Total + TaxTotal; //Abs(CGSTAmt) + Abs(SGSTAmt) + Abs(IGSTAmt);

                    if "Sales Invoice Header"."Currency Code" <> '' then begin
                        PostedVoucher.InitTextVariable();
                        PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), Currency);

                        PostedVoucher1.InitTextVariable();
                        PostedVoucher1.FormatNoText(TaxNoText, Round(TaxTotal), Currency);

                    end else begin
                        PostedVoucher.InitTextVariable;
                        PostedVoucher.FormatNoText(AmountinWords, ROUND(GrandTotal), '');

                        PostedVoucher1.InitTextVariable();
                        PostedVoucher1.FormatNoText(TaxNoText, Round(TaxTotal), '');
                    end;
                    //Naveen
                    RecCountry.Reset();
                    RecCountry.SetRange(Code, "Sales Invoice Header"."VAT Country/Region Code");
                    if RecCountry.FindFirst() then begin
                        CountName := RecCountry.Name;
                    end;


                end;
            }

            trigger OnPreDataItem();
            begin
                //NoOfRecords := "Sales Invoice Line".COUNT;
                SlNo := 0;
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Customer.Reset();
                Customer.SetRange("No.", "Sell-to Customer No.");
                if Customer.Find('-') then begin
                    CustomerGSTRegistrationNo := Customer."GST Registration No.";
                    CustomerPanNo := Customer."P.A.N. No.";
                    CustomerServiceZone := Customer."Service Zone Code";
                    CustomerContact := Customer."Phone No.";
                end;
                //salespersonName := salesperson.Name;
                IF Recstate.GET(Customer."State Code") then
                    CustomerStateName := Recstate.Description;
                CustomerCode := Recstate."State Code (GST Reg. No.)";
                if Recstate.Get(CompInfo."State Code") then begin
                    CompanyStateCode := Recstate."State Code (GST Reg. No.)";
                    CompanyStateName := Recstate.Description;
                end;
                if Recstate.Get(CompInfo."State Code") then begin
                    StateDescription := Recstate.Description;
                    //stategstreg := Recstate."State Code (GST Reg. No.)";
                end;
                Reccountry.Reset();
                Reccountry.SetRange(Code, CompInfo."Country/Region Code");
                if Reccountry.FindFirst() then begin
                    compinfoCountryName := Reccountry.Name;
                end;
                RecLocation.Reset();
                RecLocation.SetRange(Code, "Sales Invoice Header"."Location Code");
                if RecLocation.FindFirst() then begin
                    LocatGstRegNo := RecLocation."GST Registration No.";
                    LocatName := RecLocation.Name;
                    LocatAddress := RecLocation.Address;
                    LocatAddress2 := RecLocation."Address 2";
                    LocatPostCode := RecLocation."Post Code";
                    LocatCity := RecLocation.City;
                    LocatContact := RecLocation.Contact;
                    LocLUTNUMber := RecLocation."LUT Number";
                    IF Recstate.GET(RecLocation."State Code") then
                        LocStateName := Recstate.Description;
                    LocCustomerStateCode := Recstate."State Code (GST Reg. No.)";
                end;
                recItem.Reset();
                recItem.SetRange(recItem."No.", "Sales Invoice Line"."Item Category Code");
                if recItem.FindFirst() then begin
                    //ittem := recItem.Description;
                    IF RecitemCat.GET(recItem."Item Category Code") then
                        RecDescription := RecitemCat.Description;
                    //Message(RecDescription);
                end;
                PurchaseComment.Reset();
                PurchaseComment.SetRange("No.", "No.");
                //  PurchaseComment.SETRANGE("Document Type", PurchaseComment."Document Type"::"Posted Invoice");
                PurchaseComment.SetRange("Document Line No.", 0);
                if PurchaseComment.FindFirst() then begin
                    repeat
                        HeaderComment += ' ' + PurchaseComment.Comment + '<br>';
                    until PurchaseComment.Next = 0;
                    //Message(HeaderComment);
                end;
                //Naveen---
            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(BankDetail; BankDetail)
                    {
                        ApplicationArea = All;
                        TableRelation = "Bank Account"."No.";

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.get();
        CompInfo.CalcFields(Picture);
        CompInfo.GetRegistrationNumber();

        // if BankDetail = '' then
        //     Error('please select  the Bank Details');

        recbank.Reset();
        recbank.SetRange("No.", BankDetail);
        if recbank.FindSet() then begin
            BankName := recbank.Name;
            BAccNo := recbank."Bank Account No.";
            SwiftCode := recbank."Transit No.";
            GSTreg := recbank."GST Registration No.";
            BankAD := recbank."Bank Clearing Code";
            // Message(BAccNo);
            // Message(SwiftCode);
        end;

    end;

    var
        myInt: Integer;
        Text000: label 'N';
        SlNo: Integer;
        recbank: Record "Bank Account";
        BAccNo: Text;
        BankAD: Text;
        SwiftCode: Code[20];
        GSTreg: Code[20];
        BankName: Text;
        CompInfo: Record "Company Information";
        compinfoCountryName: text;
        Reccountry: Record "Country/Region";
        CountName: Text;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
        DetailedGSTLedgerEntry2: Record "Detailed GST Ledger Entry";
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        Total: Decimal;
        CGSTTotal: Decimal;
        SGSTTotal: Decimal;
        IGSTTotal: Decimal;
        GrandTotal: Decimal;
        TaxTotal: Decimal;
        PostedVoucher: Report "Posted Voucher";
        PostedVoucher1: Report "Posted Voucher";
        Notext: array[2] of Text;
        TaxNoText: array[2] of Text;
        AmountinWords: array[5] of Text;
        Currency: Code[20];
        RecLocation: Record Location;
        LocatGstRegNo: Code[30];
        LocatName: Text;
        LocatAddress: Text;
        LocatAddress2: Text;
        LocatPostCode: Code[20];
        LocatCountryName: Text;
        LocatCity: Text;
        LocatContact: Text;
        LocLUTNUMber: Code[20];
        LocStateName: Code[20];
        LocCustomerStateCode: code[20];
        PurchaseComment: Record "Purch. Comment Line";
        HeaderComment: Text;
        Recstate: Record State;
        CompanyStateName: Code[20];
        CompanyStateCode: Code[20];
        BankDetail: Code[20];
        Customer: Record Customer;
        CustomerStateCode: Code[20];
        CustomerStateName: Code[20];
        CustomerCode: Code[20];
        CustomerContact: Text;
        CustomerServiceZone: Code[20];
        CustomerGSTRegistrationNo: Code[20];
        CustomerPanNo: Code[20];
        StateDescription: text;
        recItem: Record Item;
        RecitemCat: Record "Item Category";
        VENDRITEMNO: Text;
        RecDescription: Text;

    local procedure ClearData()
    Begin
        IGSTRate := 0;
        SGSTRate := 0;
        CGSTRate := 0;
        CGSTAmt := 0;
        SGSTAmt := 0;
        IGSTAmt := 0;

        Clear(AmountinWords);
        // Clear(TaxAmountInWords);
        Clear(GrandTotal);
        Clear(TaxTotal);
        Clear(Total);

    End;
}