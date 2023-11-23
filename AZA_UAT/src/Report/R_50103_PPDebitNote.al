report 50103 "Debit Note"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Debit_Note.rdl';

    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'posted Purchase Credit Memo';
            column(No_; "No.")
            {

            }
            //column(Reference_Invoice_No_; "Reference Invoice No.") { }
            column(Your_Reference; "Your Reference") { }
            column(Posting_Date; "Posting Date") { }

            // column(AmountInWords; AmountInWords) { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Buy_from_Contact_No_; "Buy-from Contact No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Name_2; "Pay-to Name 2") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Pay_to_Address_2; "Pay-to Address 2") { }
            column(Pay_to_City; "Pay-to City") { }
            column(Pay_to_Post_Code; "Pay-to Post Code") { }
            column(Pay_to_Contact_No_; "Pay-to Contact No.") { }
            column(VendorGstRegistrationNo; VendorGstRegistrationNo) { }
            column(VendorStateName; VendorStateName) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoCin; CompInfo."CIN No.") { }
            column(CompInfoPanNo; CompInfo."P.A.N. No.") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoHomepage; CompInfo."Home Page") { }
            column(CompInfopostcode; CompInfo."Post Code") { }
            column(CompInfoGstRegist; CompInfo."GST Registration No.") { }
            column(CompanyStateName; CompanyStateName) { }
            column(CompanyStateCode; CompanyStateCode) { }
            column(currency; currency) { }
            column(Total; Total) { }
            column(LocatGstRegNo; LocatGstRegNo) { }
            column(LocatName; LocatName) { }
            column(LocatAddress; LocatAddress) { }
            column(LocatAddress2; LocatAddress2) { }
            column(LocatPostCode; LocatPostCode) { }
            column(LocatCountryName; LocatCountryName) { }
            column(LocatContact; LocatContact) { }
            column(LocatCity; LocatCity) { }
            column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
            column(VendorContact; VendorContact) { }

            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = "Purch. Cr. Memo Hdr.";
                DataItemLink = "Document No." = FIELD("No.");
                column(Description; Description) { }
                column(itemNo_; "No.") { }
                column(VENDRITEMNO; VENDRITEMNO) { }

                column(Amount; Amount) { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(HeaderComment; HeaderComment) { }
                column(Quantity; Quantity) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(CGSTAmt; CGSTAmt) { }
                column(SGSTAmt; SGSTAmt) { }
                column(IGSTAmt; IGSTAmt) { }
                column(GrandTotal; GrandTotal) { }
                column(GSTTotal; GSTTotal) { }
                //Sales Line onafter
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    IGSTAMT2: Decimal;
                begin
                    //Naveen+++

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
                    DetailedGSTLedgerEntry.SETFILTER("Transaction Type", '%1', DetailedGSTLedgerEntry."Transaction Type"::Purchase);
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
                    DetailedGSTLedgerEntry1.SETFILTER("Transaction Type", '%1', DetailedGSTLedgerEntry1."Transaction Type"::Purchase);
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
                    DetailedGSTLedgerEntry2.SETFILTER("Transaction Type", '%1', DetailedGSTLedgerEntry2."Transaction Type"::Purchase);
                    DetailedGSTLedgerEntry2.SETRANGE("GST Component Code", 'IGST');
                    IF DetailedGSTLedgerEntry2.FindSet() THEN
                        REPEAT
                            IGSTRate := DetailedGSTLedgerEntry2."GST %";
                            IGSTAMT2 := Abs(DetailedGSTLedgerEntry2."GST Amount");

                            if DetailedGSTLedgerEntry2."Currency Code" = '' then
                                IGSTAmt := Abs(DetailedGSTLedgerEntry2."GST Amount")
                            else
                                IGSTAmt := IGSTAMT2 * "Purch. Cr. Memo Hdr."."Currency Factor"
                        UNTIL DetailedGSTLedgerEntry2.NEXT() = 0;
                    //Totals

                    Total := Total + "Purch. Cr. Memo Line".Amount;    // Amt;
                    TaxTotal += Abs(CGSTAmt) + AbS(SGSTAmt) + Abs(IGSTAmt);
                    GrandTotal := Total + TaxTotal; //Abs(CGSTAmt) + Abs(SGSTAmt) + Abs(IGSTAmt);
                    GSTTotal := Total + Abs(CGSTAmt) + AbS(SGSTAmt) + Abs(IGSTAmt);

                    if "Purch. Cr. Memo Hdr."."Currency Code" <> '' then begin
                        // PostedVoucher.InitTextVariable();
                        //PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), Currency);

                        // PostedVoucher1.InitTextVariable();
                        // PostedVoucher1.FormatNoText(TaxNoText, Round(TaxTotal), Currency);

                    end else begin
                        // PostedVoucher.InitTextVariable;
                        // PostedVoucher.FormatNoText(AmountinWords, ROUND(GrandTotal), '');

                        // PostedVoucher1.InitTextVariable();
                        // PostedVoucher1.FormatNoText(TaxNoText, Round(TaxTotal), '');
                    end;


                    //Naveen---

                    PurchaseComment.Reset();
                    PurchaseComment.SetRange("No.", "Document No.");
                    //PurchaseComment.SETRANGE("Document Type", PurchaseComment."Document Type"::"Posted Invoice");
                    PurchaseComment.SetRange("Document Line No.", "Line No.");
                    if PurchaseComment.FindFirst() then begin
                        repeat
                            HeaderComment += ' ' + PurchaseComment.Comment + '<br>';
                        until PurchaseComment.Next = 0;
                        //Message(HeaderComment);
                    end;

                    //Vendor item No

                    recItem.Reset();
                    recItem.SetRange(recItem."No.", "Purch. Cr. Memo Line"."No.");
                    if recItem.FindFirst() then begin
                        VENDRITEMNO := recItem."Vendor No.";
                        // recItem.CalcFields(Picture);
                    end;
                    Vendor.Reset();
                    Vendor.SetRange("No.", "Purch. Cr. Memo Hdr."."Buy-from Vendor No.");
                    if vendor.find('-') then begin
                        VendorGSTRegistrationNo := Vendor."GST Registration No.";
                        VendorContact := Vendor."Phone No.";
                        // Message(VendorContact);
                        // VendorDated := Vendor."Date Filter";
                        IF Recstate.GET(VendorStateCode) then
                            VendorStateName := Recstate.Description;
                        // VendorCode := Recstate."State Code (GST Reg. No.)";
                    end;



                end;
            }
            //Sales HeaderOnafteer
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if Recstate.Get(CompInfo."State Code") then begin
                    CompanyStateCode := Recstate."State Code (GST Reg. No.)";
                    CompanyStateName := Recstate.Description;
                end;
                RecLocation.Reset();
                RecLocation.SetRange(Code, "Purch. Cr. Memo Hdr."."Location Code");
                if RecLocation.FindFirst() then begin
                    LocatGstRegNo := RecLocation."GST Registration No.";
                    LocatName := RecLocation.Name;
                    LocatAddress := RecLocation.Address;
                    LocatAddress2 := RecLocation."Address 2";
                    LocatPostCode := RecLocation."Post Code";
                    LocatCity := RecLocation.City;
                    LocatContact := RecLocation.Contact;
                end;


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
                    /*field(Name; SourceExpression)
                    {
                        ApplicationArea = All;
                        
                    }*/
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
    end;


    var
        myInt: Integer;
        CompInfo: Record "Company Information";
        VendorGstRegistrationNo: Code[20];
        VendorContact: Text;
        VendorStateName: Code[20];
        Vendor: Record Vendor;
        VendorStateCode: Code[20];
        Recstate: Record State;
        CompanyStateName: Code[20];
        CompanyStateCode: Code[20];
        currency: Code[20];
        PurchaseComment: Record "Purch. Comment Line";
        HeaderComment: Text;
        // PostedVoucher: Report "Posted Voucher";
        //AmountInWords: Text;
        Total: Decimal;
        Notext: array[2] of Text;
        RecLocation: Record Location;
        LocatGstRegNo: Code[30];
        LocatName: Text;
        LocatAddress: Text;
        LocatAddress2: Text;
        LocatPostCode: Code[20];
        LocatCountryName: Text;
        LocatCity: Text;
        LocatContact: Text;
        TaxTrnasactionValue2: Record "Tax Transaction Value";//CCIT_Naveen
        GSTComponentCodeHeader: array[20] of Code[10];//CCIT_Naveen-190922
        GSTCompAmountHeader: array[20] of Decimal;//CCIT_NKP-190922
        GSTComponentCodeLine: array[20] of Code[10];//CCIT_NKP-190922
        GSTCompAmountLine: array[20] of Decimal;//CCIT_NKP-190922
        GSTCompPercentLine: array[20] of Decimal;//CCIT_NAVEEN-190922
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
        DetailedGSTLedgerEntry2: Record "Detailed GST Ledger Entry";
        //PostedVoucher: Report "Posted Voucher";
        //  PostedVoucher1: Report "Posted Voucher";

        TaxTotal: Decimal;
        TaxNoText: array[2] of Text;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        AmountinWordsINR: array[5] of Text;
        ExchangeRate: Decimal;
        IGSTtxt: text[10];
        CGSTtxt: text[10];
        SGSTtxt: text[10];
        CGSTAmt: Decimal;
        CGSTRate: Decimal;
        IGSTAmt: Decimal;
        IGSTRate: Decimal;
        SGSTAmt: Decimal;
        SGSTRate: Decimal;
        GrandTotal: Decimal;
        GSTTotal: Decimal;
        TotalGST: Decimal;
        AmountToVendor: Decimal;
        AmountinWords: array[5] of Text;
        recItem: Record Item;
        VENDRITEMNO: Text;





    local procedure ClearData()
    Begin
        IGSTRate := 0;
        SGSTRate := 0;
        CGSTRate := 0;
        SGSTtxt := '';
        CGSTtxt := '';
        TotalCGST := 0;
        TotalSGST := 0;
        TotalIGST := 0;
        CGSTtxt := '';
        IGSTtxt := '';

        IGST := 0;
        CGST := 0;
        SGST := 0;
        Clear(AmountinWords);
        AmountToVendor := 0;

    End;







}