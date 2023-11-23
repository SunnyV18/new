report 50101 AZAPurchaseOrder
{
    UsageCategory = Administration;
    EnableExternalImages = true;
    EnableHyperlinks = true;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Aza Purchase Order Report';
    RDLCLayout = 'AZA_PO.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'Posted Purchase invoice';

            column(Order_Date; "Order Date") { }
            column(No_; "No.") { }
            column(currency; currency) { }
            column(Comp_Name; Comp_Info.name) { }
            column(Comp_Pic; Comp_Info.Picture) { }
            column(Comp_Address; Comp_Info.Address) { }
            column(Comp_Address2; Comp_Info."Address 2") { }
            column(Comp_City; Comp_Info.City) { }
            column(Comp_postcode; Comp_Info."Post Code") { }
            column(Comp_InfoStateCode; Comp_Info."State Code") { }
            column(Comp_InfoCountrycode; Comp_Info."Country/Region Code") { }
            column(Comp_website; Comp_Info."Home Page") { }
            column(Comp_email; Comp_Info."E-Mail") { }
            column(Comp_CIN; Comp_Info."CIN No.") { }
            column(CompGST; Comp_Info."GST Registration No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Pay_to_Address_2; "Pay-to Address 2") { }
            column(Pay_to_City; "Pay-to City") { }
            column(Pay_to_Post_Code; "Pay-to Post Code") { }
            column(Pay_to_Contact; "Pay-to Contact") { }
            column(Vendor_Order_No_; "Vendor Order No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Vendor_Name_2; "Buy-from Vendor Name 2") { }
            column(Buy_from_Address; VendorAdd) { }
            column(Buy_from_Address_2; VendAdd2) { }
            column(Buy_from_City; vendorCity) { }
            column(Buy_from_Post_Code; VendPostCode) { }
            column(Buy_from_County; "Buy-from County") { }
            column(VendorGSTRegistrationNo; VendorGSTRegistrationNo) { }
            column(VendorPanNo; VendorPanNo) { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Name_2; "Ship-to Name 2") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(fc_location; "fc location") { }
            column(LocatGstRegNo; LocatGstRegNo) { }
            column(LocatName; LocatName) { }
            column(LocatAddress; LocatAddress) { }
            column(LocatAddress2; LocatAddress2) { }
            column(LocatPostCode; LocatPostCode) { }
            column(LocatCountryName; LocatCountryName) { }
            column(LocatContact; LocatContact) { }
            column(LocatCity; LocatCity) { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = FIELD("No.");
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(itemNo_; "No.") { }
                column(MRP; MRP) { }
                column(Unit_of_Measure; "Unit of Measure") { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(Amount; Amount) { }
                column(AmountToVendor; AmountToVendor) { }
                column(AmountinWords1; AmountinWords[2]) { }
                column(AmountinWords; AmountinWords[1]) { }
                column(Amtinwrds; Amtinwrds) { }
                column(SGSTtxt; SGSTtxt) { }
                column(CGSTtxt; CGSTtxt) { }
                column(IGSTtxt; IGSTtxt) { }
                column(SGST; SGST) { }
                column(CGST; CGST) { }
                column(IGST; IGST) { }
                column(itemazacode; item.azaCode) { }
                column(itemsize; item.sizeName) { }

                column(LineComment; LineComment) { }
                column(CGSTRate; ABS(GSTCompPercentLine[2])) { }
                column(SGSTRate; ABS(GSTCompPercentLine[2])) { }
                column(IGSTRate; ABS(GSTCompPercentLine[3])) { }
                column(CGSTAmt; ABS(GSTCompAmountLine[2])) { }//CCIT_TK
                column(SGSTAmt; ABS(GSTCompAmountLine[2])) { }
                column(IGSTAmt; ABS(GSTCompAmountLine[3])) { }
                column(recRetImage; recRetImage."Image Blob") { }
                column(Azacode; Azacode) { }
                column(Sizename; Sizename) { }
                column(prodDesc; prodDesc) { }
                column(recItempic; recItem.Picture) { }
                column(recPic2; recItem.Picture2)
                {
                }
                column(imgLoc; recImgLocation) { }
                column(ItemPic02; recTenantMedia1.Content) { }

                column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
                {

                }
                column(NewTotal; NewTotal) { }
                //Naveen
                //ONAfter Purchase Line
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    Index: Integer;
                    LSCImageLink: Record "LSC Retail Image Link";
                    LSCImage: Record "LSC Retail Image";
                    i: Integer;
                    TenantMedia: Record "Tenant Media";
                begin
                    //GST CCIT_Naveen
                    Clear(GSTComponentCodeLine);
                    clear(GSTCompPercentLine);
                    Clear(GSTCompAmountLine);
                    GetGSTAmountsLine("Purchase Line");
                    //GST CCIT_NKP


                    // PostedVoucher.InitTextVariable();
                    "Purchase Header".CalcFields(Amount);
                    // PostedVoucher.FormatNoText(AmountinWords, Round("Purchase Header".Amount), "Purchase Header"."Currency Code");
                    //  PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendor), "Purchase Header"."Currency Code");
                    Amtinwrds := AmountinWords[1] + AmountinWords[2];

                    //LINE COMMENT
                    salesComment.Reset();
                    salesComment.SetRange("No.", "Document No.");
                    // salesComment.SETRANGE("Document Type", salesComment."Document Type"::"Posted Invoice");
                    salesComment.SetRange("Document Line No.", "Line No.");
                    if salesComment.FindFirst() then begin
                        repeat
                        //   LineComment += ' ' + salesComment."Comment New" + '<br>';
                        until salesComment.Next = 0;
                        //  Message(LineComment);
                    end;
                    //recRetImage
                    recItem.Reset();
                    recItem.SetRange(recItem."No.", "Purchase Line"."No.");
                    if recItem.FindFirst() then begin
                        Azacode := recItem.azaCode;
                        Sizename := recItem.sizeName;
                        VENDRITEMNO := recItem."Vendor Item No.";
                        prodDesc := recItem.product_desc;
                        //  Message(Azacode, prodDesc);

                        // recItem.CalcFields(Picture);
                    end;


                    RecPurchaseLine.Reset();//Naveen
                    RecPurchaseLine.SetRange("Document Type", "Purchase Line"."Document Type");
                    RecPurchaseLine.SetRange("Document No.", "Purchase Line"."Document No.");
                    RecPurchaseLine.SetRange("Line No.", "Purchase Line"."Line No.");
                    RecPurchaseLine.SetRange(Type, RecPurchaseLine.Type::Item);
                    if RecPurchaseLine.FindFirst() then begin
                        recItem.GET(RecPurchaseLine."No.");

                        LSCImageLink.Reset();
                        LSCImageLink.setrange("Record Id", format(recItem.RecordId));
                        LSCImageLink.SetRange("Link Type", LSCImageLink."Link Type"::Image);
                        LSCImageLink.SetFilter("Display Order", '%1..%2', 0, 1);
                        if LSCImageLink.FindSet() then begin
                            repeat
                                recRetImage.Reset();
                                recRetImage.SetRange(Code, LSCImageLink."Image Id");
                                if recRetImage.FindFirst() then begin
                                    recRetImage.CalcFields("Image Blob");
                                end;
                            until LSCImageLink.Next() = 0;
                        end;
                    end;
                    if "Purchase Line".Type = "Purchase Line".Type::"Charge (Item)" then begin
                        Quantity := 0;
                    end;


                    if "Purchase Line".Type = "Purchase Line".Type::"Charge (Item)" then //begin
                        NewTotal := Abs(ABS(GSTCompAmountLine[2]) + ABS(GSTCompAmountLine[2]) + ABS(GSTCompAmountLine[3]) + Amount)
                    else
                        NewTotal := Abs(MRP * Quantity);

                    // end;

                end;


            }
            //Naveen
            // OnAfter Purchase Header 
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                recRetailImageLink: Record "LSC Retail Image Link";
                itemRecordID: RecordId;
                Index: Integer;
                i: Integer;
                recPurchLine: Record "Purchase Line";
            begin
                if "Purchase Header"."Currency Code" <> '' then
                    currency := "Purchase Header"."Currency Code"
                else
                    currency := 'INR';

                Vendor.Reset();
                Vendor.SetRange("No.", "Purchase Header"."Buy-from Vendor No.");
                if vendor.find('-') then begin
                    VendorPanNo := Vendor."P.A.N. No.";
                    VendorGSTRegistrationNo := Vendor."GST Registration No.";
                    VendorAdd := Vendor.Address;
                    VendAdd2 := Vendor."Address 2";
                    VendPostCode := Vendor."Post Code";
                    vendorCity := Vendor.City;
                end;
                RecLocation.Reset();
                RecLocation.SetRange(Code, "Purchase Header"."Location Code");
                if RecLocation.FindFirst() then begin
                    LocatGstRegNo := RecLocation."GST Registration No.";
                    LocatName := RecLocation.Name;
                    LocatAddress := RecLocation.Address;
                    LocatAddress2 := RecLocation."Address 2";
                    LocatPostCode := RecLocation."Post Code";
                    LocatCity := RecLocation.City;
                    LocatContact := RecLocation.Contact;
                end;


                /*recPurchLine.Reset();//Naveen
                recPurchLine.SetRange("Document Type", "Purchase Header"."Document Type");
                recPurchLine.SetRange("Document No.", "Purchase Header"."No.");
                if recPurchLine.find('-') then begin
                    recItem.GET(recPurchLine."No.");
                    recRetailImageLink.Reset();
                    recRetailImageLink.setrange("Record Id", format(recItem.RecordId));
                    if recRetailImageLink.find('-') then;
                    for i := 1 to recRetailImageLink.Count do begin

                        recRetImage.Reset();
                        recRetImage.SetRange(Code, recRetailImageLink."Image Id");
                        if recRetImage.Find('-') then begin

                            FOR Index := 1 to recRetImage."Image Mediaset".Count DO BEGIN
                                recRetImage.CalcFields("Image Blob")
                            end;

                            // FOR Index := 1 to recItem.Picture.COUNT DO BEGIN
                            //     IF recTenantMedia.GET(recItem.Picture.Item(Index)) THEN BEGIN
                            //         recTenantMedia.CALCFIELDS(Content);
                            //     END;
                            // END;
                        end;
                    end;
                end;*///khan++
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
                    // field(DocumentNum; DocNum)
                    // {
                    //     ApplicationArea = All;
                    //     TableRelation = "Purchase Header"."No.";

                    // }
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
    var
        Index: Integer;
    begin
        Comp_Info.get();
        Comp_Info.CalcFields(Picture);
        // recRetImage.Get('MENSTRAIGHTFULL');
        // recRetImage.CalcFields("Image Blob");
        // recImgLocation := recRetImage."Image Location";

        // recItem.GET('1896-S');
        // FOR Index := 1 to recItem.Picture.COUNT DO BEGIN
        //     IF recTenantMedia1.GET(recItem.Picture.Item(Index)) THEN BEGIN
        //         recTenantMedia1.CALCFIELDS(Content);
        //     END;
        // END;

        // recPurchHead.get(1, DocNum);
        // recPurchLine.Reset();
        // recPurchLine.SetRange("Document Type", recPurchHead."Document Type");
        // RecPurchaseLine.SetRange("Document No.", recPurchHead."No.");
        // if RecPurchaseLine.find('-') then begin
        //     recItem.GET(RecPurchaseLine."No.");
        //     FOR Index := 1 to recItem.Picture.COUNT DO BEGIN
        //         IF recTenantMedia.GET(recItem.Picture.Item(Index)) THEN BEGIN
        //             recTenantMedia.CALCFIELDS(Content);
        //         END;
        //     END;
        // end;
        //recRetImage.Get();
        //recRetImage.CalcFields("Image Location");

    end;

    local procedure GetGSTAmountsHeader(PurchaseHeader: Record "Purchase Header")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        PurchaseLine: record "Purchase Line";
    begin
        if not GSTSetup.Get() then
            exit;

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
                TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                if TaxTransactionValue.FindSet() then
                    repeat
                        case TaxTransactionValue."Value ID" of
                            6:
                                begin
                                    GSTCompAmountHeader[1] += TaxTransactionValue.Amount;
                                    if GSTComponentCodeHeader[1] = '' then
                                        GSTComponentCodeHeader[1] := 'SGST';
                                end;
                            2:
                                begin
                                    GSTCompAmountHeader[2] += TaxTransactionValue.Amount;
                                    if GSTComponentCodeHeader[2] = '' then
                                        GSTComponentCodeHeader[2] := 'CGST';
                                end;
                            3:
                                begin
                                    GSTCompAmountHeader[3] += TaxTransactionValue.Amount;
                                    if GSTComponentCodeHeader[3] = '' then
                                        GSTComponentCodeHeader[3] := 'IGST';
                                end;
                            4:
                                begin
                                    GSTCompAmountHeader[4] += TaxTransactionValue.Amount;
                                    if GSTComponentCodeHeader[4] = '' then
                                        GSTComponentCodeHeader[4] := 'CESS';
                                end;
                        end;
                    until TaxTransactionValue.Next() = 0;
            until PurchaseLine.Next() = 0;
    end;

    local procedure GetGSTAmountsLine(PurchLine: Record "Purchase Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        PurchaseLine: record "Purchase Line";
    begin
        if not GSTSetup.Get() then
            exit;

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchLine."Document Type");
        PurchaseLine.SetRange("Document No.", PurchLine."Document No.");
        PurchaseLine.SetRange("Line No.", PurchLine."Line No.");
        if PurchaseLine.FindSet() then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then begin
                case TaxTransactionValue."Value ID" of
                    6:
                        begin
                            GSTCompPercentLine[1] := TaxTransactionValue.Percent;
                            GSTCompAmountLine[1] := TaxTransactionValue.Amount;
                            if GSTComponentCodeLine[1] = '' then
                                GSTComponentCodeLine[1] := 'SGST';
                        end;
                    2:
                        begin
                            GSTCompPercentLine[2] := TaxTransactionValue.Percent;
                            GSTCompAmountLine[2] := TaxTransactionValue.Amount;
                            if GSTComponentCodeLine[2] = '' then
                                GSTComponentCodeLine[2] := 'CGST';
                        end;
                    3:
                        begin
                            GSTCompPercentLine[3] := TaxTransactionValue.Percent;
                            GSTCompAmountLine[3] := TaxTransactionValue.Amount;
                            if GSTComponentCodeLine[3] = '' then
                                GSTComponentCodeLine[3] := 'IGST';
                        end;
                    4:
                        begin
                            GSTCompPercentLine[4] := TaxTransactionValue.Percent;
                            GSTCompAmountLine[4] := TaxTransactionValue.Amount;
                            if GSTComponentCodeLine[4] = '' then
                                GSTComponentCodeLine[4] := 'CESS';
                        end;
                end;
            end;
        end;
    end;



    var
        myInt: Integer;
        Comp_Info: Record "Company Information";
        Vendor: Record Vendor;


        recTenantMedia: Record "Tenant Media";

        recTenantMedia1: Record "Tenant Media";
        VendorPanNo: Code[20];
        VendorGSTRegistrationNo: Code[20];
        VendorAdd: Text;
        VendAdd2: Text;
        VendPostCode: Code[20];
        vendorCity: Text;
        Amtinwrds: Text;
        AmountinWords: array[5] of Text;
        AmountToVendor: Decimal;
        //  PostedVoucher: Report "Posted Voucher";
        currency: code[20];
        CGSTAmt: Decimal;
        CGSTRate: Decimal;

        recPurchHead: Record "Purchase Header";

        recPurchLine: Record "Purchase Line";
        DocNum: Code[30];
        IGSTAmt: Decimal;
        IGSTRate: Decimal;
        recImgLocation: text;
        SGSTAmt: Decimal;
        SGSTRate: Decimal;
        Total: Decimal;
        GrandTotal: Decimal;
        T: Decimal;
        RecPurchaseLine: Record "Purchase Line";
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
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxRecordID: RecordId;
        compinfo: Record "Company Information";
        compinfoGstRegi: Code[30];
        cominfoPanNo: Code[20];
        salesComment: Record "Purch. Comment Line";
        LineComment: Text;
        No: Integer;
        headercommet: Page "Purch. Comment List";
        comments: Page "Purch. Comment Sheet";
        item: Record Item;
        recRetImage: Record "LSC Retail Image";

        recItem: Record Item;
        Azacode: Code[20];
        Sizename: Text;
        VENDRITEMNO: TEXT;
        TaxTrnasactionValue2: Record "Tax Transaction Value";//CCIT_Nkp
        GSTComponentCodeHeader: array[20] of Code[10];
        GSTCompAmountHeader: array[20] of Decimal;
        GSTComponentCodeLine: array[20] of Code[10];
        GSTCompAmountLine: array[20] of Decimal;
        GSTCompPercentLine: array[20] of Decimal;
        prodDesc: text;
        RecLocation: Record Location;
        LocatGstRegNo: Code[30];
        LocatName: Text;
        LocatAddress: Text;
        LocatAddress2: Text;
        LocatPostCode: Code[20];
        LocatCountryName: Text;
        LocatCity: Text;
        LocatContact: Text;
        NewTotal: Decimal;



    local procedure ClearData()
    var

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