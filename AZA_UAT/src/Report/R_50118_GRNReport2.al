report 50118 "GRN Report2"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './GRNReport2.rdl';

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'posted Sales Invoice';
            column(No_; "No.")
            {

            }
            //column(Reference_Invoice_No_; "Reference Invoice No.") { }
            column(Your_Reference; "Your Reference") { }
            column(Posting_Date; Format("Posting Date")) { }
            column(HeaderComment; HeaderComment) { }
            column(AmountInWords; AmountInWords) { }
            column(Vendor_Order_No_; "Vendor Order No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Pay_to_Address_2; "Pay-to Address 2") { }
            column(VendorGstRegistrationNo; VendorGstRegistrationNo) { }
            column(VendorStateName; VendorStateName) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoPanNo; CompInfo."P.A.N. No.") { }
            column(CompInfoGstRegist; CompInfo."GST Registration No.") { }
            column(CompanyStateName; CompanyStateName) { }
            column(CompanyStateCode; CompanyStateCode) { }
            column(currency; currency) { }
            column(Total; Total) { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Buy_from_County; "Buy-from County") { }
            column(LocatGstRegNo; LocatGstRegNo) { }
            column(LocatName; LocatName) { }
            column(LocatAddress; LocatAddress) { }
            column(LocatAddress2; LocatAddress2) { }
            column(LocatPostCode; LocatPostCode) { }
            column(LocatCity; LocatCity) { }
            column(LocatCountryName; LocatCountryName) { }
            column(Order_No_; "Order No.") { }


            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemTableView = sorting("No.") order(descending);
                DataItemLinkReference = "Purch. Rcpt. Header";
                DataItemLink = "Document No." = FIELD("No.");
                column(Description; Description) { }
                column(NoITEM; "No.") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Quantity; Quantity) { }
                column(VENDRITEMNO; VENDRITEMNO) { }
                //column(de)
                column(mrp; mrp) { }
                column(DirectCost; DirectCost) { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(HSN; HSN) { }
                column(Potype; Potype) { }
                column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
                {

                }

                // column(Amount; Amount) { }
                //Sales Line onafter
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    if "Purch. Rcpt. Header"."Currency Code" <> '' then begin
                        currency := "Purch. Rcpt. Header"."Currency Code";
                    end else begin
                        currency := 'INR';

                    end;

                    Vendor.Reset();
                    // CIGStRegistrationNo := CompInfo.GetRegistrationNumber()
                    Vendor.SetRange("No.", "Purch. Rcpt. Header"."Buy-from Vendor No.");
                    if Vendor.Find('-') then begin
                        VendorGstRegistrationNo := Vendor."GST Registration No.";
                        if Recstate.Get(VendorStateCode) then begin
                            VendorStateName := Recstate.Description;
                        end;
                    end;
                    // Total += "Purch. Rcpt. Line".Amount;

                    //  PostedVoucher.InitTextVariable();
                    //  PostedVoucher.FormatNoText(Notext, Total, "Purch. Rcpt. Line"."Currency Code");
                    AmountInWords := Notext[1] + Notext[2];

                    //RecLocation

                    RecLocation.Reset();
                    RecLocation.SetRange(Code, "Purch. Rcpt. Line"."Location Code");
                    if RecLocation.FindFirst() then begin
                        LocatGstRegNo := RecLocation."GST Registration No.";
                        LocatName := RecLocation.Name;
                        LocatAddress := RecLocation.Address;
                        LocatAddress2 := RecLocation."Address 2";
                        LocatPostCode := RecLocation."Post Code";
                        LocatCity := RecLocation.City;
                    end;
                    recItem.Reset();
                    recItem.SetRange(recItem."No.", "Purch. Rcpt. Line"."No.");
                    if recItem.FindFirst() then begin
                        VENDRITEMNO := recItem."Vendor Item No.";
                        HSN := recItem."HSN/SAC Code";
                        // recItem.CalcFields(Picture);
                    end;
                    //NAVEEN+++++
                    ClearData;
                    // RecRef.OPEN(DATABASE::"Purchase Line");
                    // RecRef.SetTable(RecPurchaseLine);


                    RecPurchaseLine.Reset();
                    //RecPurchaseLine.SetRange("Document Type", "Purch. Rcpt. Header"."No.");
                    RecPurchaseLine.SetRange("Document No.", "Purch. Rcpt. Header"."Order No.");
                    RecPurchaseLine.SetFilter("GST Group Code", '<>%1', '');
                    if RecPurchaseLine.FindSet() then
                        repeat
                            TaxRecordID := RecPurchaseLine.RecordId();//Nkp
                                                                      // PurchaseHeaderRecordID := RecPurchaseLine.RecordId();
                                                                      //Message('%1', PurchHeaderRecordID);
                            TaxTransactionValue.Reset();
                            TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);//NKP
                            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                            TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxTransactionValue.SetRange("Visible on Interface", true);
                            TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
                            if TaxTransactionValue.FindSet() then begin
                                //repeat
                                //Message('%1  %2  %3', TaxTransval.ID, TaxTransval.Amount, TaxTransval.Percent);
                                // IF ("Purchase Line"."GST Jurisdiction Type" = "Purchase Line"."GST Jurisdiction Type"::Intrastate) THEN BEGIN
                                CGSTRate := TaxTransactionValue.Percent;
                                SGSTRate := TaxTransactionValue.Percent;
                                CGST += TaxTransactionValue.Amount;
                                SGST += TaxTransactionValue.Amount;
                                //Message('%1--', SGST);
                                SGSTtxt := 'SGST';
                                CGSTtxt := 'CGST';
                                TotalCGST += CGST;
                                TotalSGST += SGST;
                            end else begin
                                TaxTransactionValue.Reset();
                                TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);//NKP
                                TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                                TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                                TaxTransactionValue.SetRange("Visible on Interface", true);
                                TaxTransactionValue.SetFilter("Value ID", '%1', 3);
                                if TaxTransactionValue.FindSet() then
                                    IGSTRate := TaxTransactionValue.Percent;
                                IGST += TaxTransactionValue.Amount;
                                IGSTtxt := 'IGST';
                                TotalIGST += IGST;
                                /* END ELSE
                                     IF ("Purchase Line"."GST Jurisdiction Type" = "Purchase Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
                                         IGSTRate := TaxTransactionValue.Percent;
                                         IGST := TaxTransactionValue.Amount;
                                         IGSTtxt := 'IGST';
                                         //Message('%1--', IGST);*/
                            END;
                            // until TaxTransactionValue.Next() = 0;
                            //TotalCGST += CGST;
                            //TotalSGST += SGST;
                            //TotalIGST += IGST;
                            Total += RecPurchaseLine.Amount;
                        //TotalIGST + TotalCGST + TotalSGST;
                        until RecPurchaseLine.Next() = 0;
                    AmountToVendor := Total + CGST + SGST + IGST;
                    //Naveen--
                    // PostedVoucher.InitTextVariable();
                    // "Purchase Header".CalcFields(Amount);
                    // PostedVoucher.FormatNoText(AmountinWords, Round("Purchase Header".Amount), "Purchase Header"."Currency Code");
                    //PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendor), "Purchase Header"."Currency Code");
                    // Amtinwrds := AmountinWords[1] + AmountinWords[2];
                    //NAVEEN----

                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("No.", "Purch. Rcpt. Header"."Order No.");
                    PurchaseHeader.SetRange("Buy-from Vendor No.", "Purch. Rcpt. Header"."Buy-from Vendor No.");
                    PurchaseHeader.SetRange("Pay-to Vendor No.", "Purch. Rcpt. Header"."Pay-to Vendor No.");
                    if PurchaseHeader.FindSet() then
                        repeat
                            Potype := format(PurchaseHeader."PO type");
                        //Message('%1--', Potype);
                        until PurchaseHeader.Next() = 0;


                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document No.", "Purch. Rcpt. Line"."Order No.");
                    PurchaseLine.SetRange(Type, "Purch. Rcpt. Line".Type);
                    PurchaseLine.SetRange("No.", "Purch. Rcpt. Line"."No.");
                    if PurchaseLine.FindSet() then
                        repeat
                            mrp := PurchaseLine.MRP;
                            DirectCost := PurchaseLine."Direct Unit Cost";
                            HSN := PurchaseLine."HSN/SAC Code";
                        // GstAmount := PurchaseLine.gst a
                        //  Message('%1--', mrp, DirectCost);
                        until PurchaseLine.Next() = 0;

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

                PurchaseComment.Reset();
                PurchaseComment.SetRange("No.", "No.");
                // PurchaseComment.SetRange("Document Type", "Document Type");
                PurchaseComment.SetRange("Document Line No.", 0);
                PurchaseComment.SetFilter("Line No.", '=%1', 10000);
                if PurchaseComment.FindFirst() then begin
                    HeaderComment := PurchaseComment.Comment;
                    //Message(HeaderComment);
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
        PurchaseHeader: Record "Purchase Header";
        VendorGstRegistrationNo: Code[20];
        VendorStateName: Code[20];
        Vendor: Record Vendor;
        VendorStateCode: Code[20];
        Recstate: Record State;
        CompanyStateName: Code[20];
        CompanyStateCode: Code[20];
        currency: Code[20];
        PurchaseComment: Record "Purch. Comment Line";
        HeaderComment: Text;
        //  PostedVoucher: Report "Posted Voucher";
        AmountInWords: Text;
        Total: Decimal;
        Notext: array[2] of Text;
        RecLocation: Record Location;
        LocatGstRegNo: Code[30];
        LocatName: Text;
        LocatAddress: Text;
        LocatAddress2: Text;
        LocatPostCode: Code[20];
        LocatCity: Text;
        LocatCountryName: Text;
        recItem: Record Item;
        VENDRITEMNO: Text;
        PurchaseLine: Record "Purchase Line";
        mrp: Decimal;
        DirectCost: Decimal;
        HSN: Code[20];
        GstAmount: Decimal;
        RecPurchaseLine: Record "Purchase Line";
        CGSTAmt: Decimal;
        CGSTRate: Decimal;
        IGSTAmt: Decimal;
        IGSTRate: Decimal;
        SGSTAmt: Decimal;
        SGSTRate: Decimal;
        //Total: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        GrandTotal: Decimal;
        TotalGST: Decimal;
        IGSTtxt: text[10];
        CGSTtxt: text[10];
        SGSTtxt: text[10];
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        AmountToVendor: Decimal;
        TaxRecordID: RecordId;
        Amtinwrds: Text;
        PurchaseHeaderRecordID: Record "Purchase Header";
        Potype: Text;


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