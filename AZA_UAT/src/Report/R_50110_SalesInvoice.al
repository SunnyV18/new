report 50110 "Sales Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'SalesInvoice.rdl';


    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {

            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            column(Invoice_No; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Order_ID; "Order No.") { }
            column(storename; storename) { }
            column(storeaddress; storeaddress) { }
            column(storeaddress2; storeaddress2) { }
            column(storePhoneNo; storePhoneNo) { }
            column(store_email; store_email) { }
            column(storepincode; storepincode) { }
            column(StoreGST; StoreGST) { }
            column(storecountry; storecountry) { }
            column(Store_No_; "Store No.") { }
            column(cinNo; cinNo) { }
            column(compnyInfoName; compnyInfo.Name) { }
            column(compnyInfoadd; compnyInfo.Address) { }
            column(compnyInfoadd2; compnyInfo."Address 2") { }
            column(compnyInfocountry; compnyInfo.County) { }
            column(compnyInfopostcode; compnyInfo."Post Code") { }
            column(compnyCIN; compnyInfo."CIN No.") { }
            column(compnyInfohomepage; compnyInfo."Home Page") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Name_2; "Bill-to Name 2") { }
            column(BillToState; BillToState) { }
            column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
            column(BillToGST; BillToGST) { }
            column(BillToPan; BillToPan) { }
            Column(ShipToName; ShipToName) { }
            Column(ShipToAdd; ShipToAdd) { }
            Column(ShipToAdd2; ShipToAdd2) { }
            Column(ShipToState; ShipToState) { }
            Column(ShipToCountry; ShipToCountry) { }
            Column(CGSTBoo; CGSTBoo) { }
            Column(SGSTBoo; SGSTBoo) { }
            Column(IGSTBoo; IGSTBoo) { }
            column(LocatGstRegNo; LocatGstRegNo) { }
            column(LocatName; LocatName) { }
            column(LocatAddress; LocatAddress) { }
            column(LocatAddress2; LocatAddress2) { }
            column(LocatPostCode; LocatPostCode) { }
            column(LocatCountryName; LocatCountryName) { }
            column(LocatContact; LocatContact) { }
            column(LocatCity; LocatCity) { }


            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") where(Type = filter(<> " "));
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                column(Item_No; "No.") { }
                Column(Description; Description) { }
                Column(Quantity; Quantity) { }
                Column(Line_Amount; "Line Amount") { }
                Column(HSN; HSN) { }
                Column(vc; vc) { }
                Column(cGSTpercent; cGSTpercent) { }
                Column(CGST_Amt; CGST_Amt) { }
                Column(SGSTpercent; SGSTpercent) { }
                Column(SGST_Amt; SGST_Amt) { }
                Column(IGSTpercent; IGSTpercent) { }
                Column(IGSTAmount; IGSTAmount) { }
                Column(TotalGSTAmount; TotalGSTAmount) { }
                column(TotalLineAmount; TotalLineAmount) { }


                trigger OnAfterGetRecord()
                var
                    TaxTransactionValue: Record "LSCIN Tax Transaction Value";
                    DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
                begin
                    Clear(TotalGSTAmount);
                    Clear(IGSTAmount);
                    Clear(SGST_Amt);
                    Clear(CGST_Amt);
                    cGSTpercent := 0;
                    CGST_Amt := 0;
                    SGSTpercent := 0;
                    SGST_Amt := 0;
                    IGSTpercent := 0;
                    IGSTAmount := 0;
                    TotalGSTAmount := 0;
                    if "Sales Invoice Line".Quantity <> 0 then begin
                        if "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item then begin
                            if item.Get("Sales Invoice Line"."No.") then begin
                                HSN := item."HSN/SAC Code";
                                vc := item."Vendor No.";
                            end;

                            DetailedGSTLedgerEntry.RESET;
                            DetailedGSTLedgerEntry.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                            DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                            DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                            IF DetailedGSTLedgerEntry.FindSet() THEN
                                REPEAT
                                    IF DetailedGSTLedgerEntry."GST Component Code" = 'CGST' THEN BEGIN
                                        cGSTpercent := DetailedGSTLedgerEntry."GST %";
                                        CGST_Amt += DetailedGSTLedgerEntry."GST Amount" * -1;
                                        //TaxableAmt := DetailedGSTLedgerEntry."GST Base Amount" * -1;
                                    END;

                                    IF DetailedGSTLedgerEntry."GST Component Code" = 'SGST' THEN BEGIN
                                        SGSTpercent := DetailedGSTLedgerEntry."GST %";
                                        SGST_Amt += DetailedGSTLedgerEntry."GST Amount" * -1;
                                        //TaxableAmt := DetailedGSTLedgerEntry."GST Base Amount" * -1;
                                    END;

                                    IF DetailedGSTLedgerEntry."GST Component Code" = 'IGST' THEN BEGIN
                                        IGSTpercent := DetailedGSTLedgerEntry."GST %";
                                        IGSTAmount += DetailedGSTLedgerEntry."GST Amount" * -1;
                                        //TaxableAmt := DetailedGSTLedgerEntry."GST Base Amount" * -1;
                                    END;
                                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
                            TotalGSTAmount := Round(abs(SGST_Amt) + abs(CGST_Amt) + abs(IGSTAmount) + abs("Line Amount"));
                            TotalLineAmount := TotalLineAmount + "Sales Invoice Line"."Line Amount";
                        end;
                    end;
                    if "Sales Invoice Line".Type = "Sales Invoice Line".Type::"Charge (Item)" then begin
                        cGSTpercent := 0;
                        CGST_Amt := 0;
                        SGSTpercent := 0;
                        SGST_Amt := 0;
                        IGSTpercent := 0;
                        IGSTAmount := 0;
                        DetailedGSTLedgerEntry.RESET;
                        DetailedGSTLedgerEntry.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                        DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                        IF DetailedGSTLedgerEntry.FindSet() THEN
                            REPEAT
                                IF DetailedGSTLedgerEntry."GST Component Code" = 'CGST' THEN BEGIN
                                    cGSTpercent := DetailedGSTLedgerEntry."GST %";
                                    CGST_Amt += DetailedGSTLedgerEntry."GST Amount" * -1;
                                END;
                                IF DetailedGSTLedgerEntry."GST Component Code" = 'SGST' THEN BEGIN
                                    SGSTpercent := DetailedGSTLedgerEntry."GST %";
                                    SGST_Amt += DetailedGSTLedgerEntry."GST Amount" * -1;
                                END;
                                IF DetailedGSTLedgerEntry."GST Component Code" = 'IGST' THEN BEGIN
                                    IGSTpercent := DetailedGSTLedgerEntry."GST %";
                                    IGSTAmount += DetailedGSTLedgerEntry."GST Amount" * -1;
                                END;
                            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
                        TotalGSTAmount := Round(abs(SGST_Amt) + abs(CGST_Amt) + abs(IGSTAmount) + abs("Line Amount"));
                        Quantity := 0;
                        TotalLineAmount := TotalLineAmount + "Sales Invoice Line"."Line Amount";
                    end;
                    // end;
                    //lOCATION
                    RecLocation.Reset();
                    RecLocation.SetRange(Code, "Sales Invoice Line"."Location Code");
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

            trigger OnAfterGetRecord()
            begin
                if compnyInfo.get then;
                if StoreInfo.get("Sales Invoice Header"."Store No.") then begin
                    storeName := StoreInfo.Name;
                    StoreAddress := StoreInfo.Address;
                    storeaddress2 := StoreInfo."Address 2";
                    storecountry := StoreInfo.County;
                    storePincode := StoreInfo."Post Code";
                    storePhoneNo := StoreInfo."Phone No.";
                    StoreGST := StoreInfo."LSCIN GST Registration No";
                    store_email := StoreInfo."email id";
                end;
                if "Bill-to Customer No." <> '' then begin
                    Cust.Get("Sales Invoice Header"."Bill-to Customer No.");
                    BillToGST := Cust."GST Registration No.";
                    BillToPan := Cust."P.A.N. No.";
                    BillToState := Cust."State Code";
                end else begin
                    Cust.Get("Sales Invoice Header"."Sell-to Customer No.");
                    BillToGST := Cust."GST Registration No.";
                    BillToPan := Cust."P.A.N. No.";
                    BillToState := Cust."State Code";
                end;
                if "Sales Invoice Header"."Ship-to Code" <> '' then begin
                    if ShipToAddTab.Get("Sales Invoice Header"."Sell-to Customer No.", "Sales Invoice Header"."Ship-to Code") then begin
                        ShipToName := ShipToAddTab.Name;
                        ShipToAdd := ShipToAddTab.Address;
                        ShipToAdd2 := ShipToAddTab."Address 2";
                        ShipToCountry := ShipToAddTab."Country/Region Code";
                        ShipToState := ShipToAddTab.State;
                    end;
                end;
                // end else begin
                //     Cust1.Get("Sales Invoice Header"."Bill-to Customer No.");
                //     if Cust1."Ship-to Code" <> '' then begin
                //         ShipAddress.Get(Cust1."No.", Cust1."Ship-to Code");
                //         ShipToName := ShipAddress.Name;
                //         ShipToAdd := ShipAddress.Address;
                //         ShipToAdd2 := ShipAddress."Address 2";
                //         ShipToState := ShipAddress.State;
                //         ShipToCountry := ShipAddress."Country/Region Code";
                //     end else begin
                //         ShipToName := Cust1.Name;
                //         ShipToAdd := cust1.Address;
                //         ShipToAdd2 := Cust1."Address 2";
                //         ShipToState := Cust1."State Code";
                //         ShipToCountry := Cust1."Country/Region Code";
                //     end;
                // end;
                if SGSTpercent <> 0 then
                    SGSTBoo := true;
                if cGSTpercent <> 0 then
                    CGSTBoo := true;
                if IGSTpercent <> 0 then
                    IGSTBoo := true;
            end;
        }
    }



    //  }

    var
        myInt: Integer;
        storename: text;
        ShipToAddTab: Record "Ship-to Address";
        storeaddress: text;
        storeaddress2: text;
        store_email: text;
        currency: code[30];
        storecountry: text;
        storepincode: code[20];
        storePhoneNo: text[30];
        StoreGST: code[50];
        cinNo: Code[30];
        StoreInfo: Record "LSC Store";
        vc: code[30];
        HSN: Code[20];
        item: Record Item;
        compnyInfo: Record "Company Information";
        BillToGST: Code[30];
        BillToPan: Code[20];
        BillToState: Code[30];
        Cust: Record Customer;
        Cust1: Record Customer;
        Cust2: Record Customer;
        ShipToName: Text;
        ShipToAdd: Text;
        ShipToAdd2: Text;
        ShipToState: Code[20];
        ShipToCountry: Code[30];
        ShipAddress: Record "Ship-to Address";
        SGST_Amt: Decimal;
        SGSTpercent: Decimal;
        CGST_Amt: Decimal;
        cGSTpercent: Decimal;
        SGSTBoo: Boolean;
        CGSTBoo: Boolean;
        IGSTBoo: Boolean;
        TotalGSTAmount: Decimal;
        IGSTAmount: Decimal;
        IGSTpercent: Decimal;
        ItmNo: Code[20];
        dess: Code[30];
        incAmt: Decimal;
        incomePer: Integer;
        incpercentamt: Decimal;
        incAmtTotal: Decimal;
        IncBoo: Boolean;
        quan: Decimal;
        TotalLineAmount: Decimal;
        RecLocation: Record Location;
        LocatGstRegNo: Code[30];
        LocatName: Text;
        LocatAddress: Text;
        LocatAddress2: Text;
        LocatPostCode: Code[20];
        LocatCountryName: Text;
        LocatCity: Text;
        LocatContact: Text;

}