report 50127 New_Sales_Order //5014
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'SALE_ORDER_NEW.rdl';
    Caption = 'Sales Order New';
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Sales Order';
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CmpName; CompanyInfo.Name) { }
            column(CmpName2; CompanyInfo."Name 2") { }
            column(CmpAddress; CompanyInfo.Address) { }
            column(ComAddress2; CompanyInfo."Address 2") { }
            column(cmpCity; CompanyInfo.City) { }
            column(CmpPostCode; CompanyInfo."Post Code") { }
            column(cmpGstReg; CompanyInfo."GST Registration No.") { }
            column(CmpCIN; CompanyInfo."CIN No.") { }
            column(CmpStateCode; CmpStateCode) { }
            column(CompStateName; CompStateName) { }
            column(cmpPAN; CompanyInfo."P.A.N. No.") { }
            column(cmpEmail; CompanyInfo."E-Mail") { }
            column(cmpBankName; CompanyInfo."Bank Name") { }
            column(cmpAccNo; CompanyInfo."Bank Account No.") { }
            column(BankBrach; BankBrach) { }
            column(SWIFTCode; SWIFTCode) { }
            column(No; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(sname; sname) { }
            column(Saddress; Saddress) { }
            column(Saddress2; Saddress2) { }
            column(Scity; Scity) { }
            column(SPostCode; SPostCode) { }
            column(SGSTNo; SGSTNo) { }
            column(SPAN; SPAN) { }
            column(SstateName; SstateName) { }
            column(SstateCode; SstateCode) { }
            column(SCountry; SCountry) { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_Post_Code; "Bill-to Post Code") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
            column(BillState; BillState) { }
            column(BillStateName; BillStateName) { }
            column(Bill_GSTNo; Bill_GSTNo) { }
            column(NoLbl; NoLbl) { }
            column(DesLbl; DesLbl) { }
            column(HSNLbl; HSNLbl) { }
            column(DueLbl; DueLbl) { }
            column(qtyLbl; qtyLbl) { }
            column(RateLbl; RateLbl) { }
            column(AmtLbl; AmtLbl) { }
            column(Curr_symbol; Curr_symbol) { }
            column(Shipping_Agent_Code; "Shipping Agent Code") { }
            column(Terms___Condition; '') { }//"Terms & Condition"
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = FIELD("No.");
                column(Description; Description) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Amount; Amount) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(CGSTRate; CGSTRate) { }
                column(TotalIGST; TotalIGST) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(GrandTotal; GrandTotal) { }
                column(AmountInWords; Notext[1]) { }
                column(Currency; Currency) { }
                column(TCSAmt; TCSAmt) { }
                column(TCSPer; TCSPer) { }

                //Sales line onAfterGet
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    ClearData;

                    if "Sales Header"."Currency Code" <> '' then begin
                        Currency := "Sales Header"."Currency Code";
                    end else begin
                        Currency := 'INR';
                    end;

                    RecSalesLine.Reset();
                    RecSalesLine.SetRange("Document Type", "Sales Header"."Document Type");
                    RecSalesLine.SetRange("Document No.", "Sales Header"."No.");
                    RecSalesLine.SetFilter("GST Group Code", '<>%1', '');
                    if RecSalesLine.FindSet() then
                        repeat
                            TaxRecordID := RecSalesLine.RecordId();

                            TaxTransactionValue.Reset();
                            TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);
                            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                            TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxTransactionValue.SetRange("Visible on Interface", true);
                            TaxTransactionValue.SetFilter("Value ID", '%1 | %2', 6, 2);
                            if TaxTransactionValue.FindSet() then begin
                                CGSTRate := TaxTransactionValue.Percent;  /// 2;
                                SGSTRate := TaxTransactionValue.Percent;   /// 2;
                                CGST := TaxTransactionValue.Amount;  /// 2;
                                SGST := TaxTransactionValue.Amount; // / 2;
                                TotalCGST += CGST;
                                TotalSGST += SGST;
                            END
                            ELSE begin
                                TaxTransactionValue.Reset();
                                TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);//tk
                                TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                                TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                                TaxTransactionValue.SetRange("Visible on Interface", true);
                                TaxTransactionValue.SetFilter("Value ID", '%1', 3);
                                if TaxTransactionValue.FindSet() then
                                    IGSTRate := TaxTransactionValue.Percent;
                                IGST := TaxTransactionValue.Amount;
                                TotalIGST += IGST;

                            end;

                            TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);
                            TaxTransactionValue.SetFilter("Tax Type", '=%1', 'TCS');
                            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxTransactionValue.SetFilter("Value ID", '%1', 1);
                            TaxTransactionValue.SetRange("Visible on Interface", true);
                            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                            if TaxTransactionValue.FindFirst() then begin
                                TCSAmt := TaxTransactionValue.Amount;
                                TCSPer := TaxTransactionValue.Percent;
                            end;

                        /*Total := Total + "Sales Line".Amount;
                        TaxTotal := TotalIGST + TotalCGST + TotalSGST;
                        GrandTotal := Total + TaxTotal;*/
                        until RecSalesLine.Next() = 0;

                    Total := Total + "Sales Line".Amount;
                    TaxTotal := TotalIGST + TotalCGST + TotalSGST;
                    GrandTotal := Total + TaxTotal + TCSAmt;

                    if "Sales Header"."Currency Code" <> '' then begin
                        PostedVoucher.InitTextVariable();
                        PostedVoucher.FormatNoText(Notext, ROUND(GrandTotal), Currency);
                    end
                    else begin
                        PostedVoucher.InitTextVariable;
                        PostedVoucher.FormatNoText(Notext, ROUND(GrandTotal), '');
                    end;
                end;
            }
            //Sales Header OnAfterGet
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin

                Rec_Cust.Reset();
                Rec_Cust.SetRange("No.", "Sales Header"."Sell-to Customer No.");
                if Rec_Cust.Find('-') Then begin
                    Ship_GST_No := Rec_Cust."GST Registration No.";
                end;

                if "Sales Header"."Ship-to Code" = '' then begin
                    SName := Rec_Cust.Name;
                    Saddress := Rec_Cust.Address;
                    Saddress2 := Rec_Cust."Address 2";
                    Scity := Rec_Cust.City;
                    SPostCode := Rec_Cust."Post Code";
                    //SCountry := Rec_Cust."Country/Region Code";
                    if RecCountry.Get(Rec_Cust."Country/Region Code") then begin
                        SCountry := RecCountry.Name;
                    end;
                    SGSTNo := Rec_Cust."GST Registration No.";
                    SPAN := Rec_Cust."P.A.N. No.";
                    if RecState.Get(Rec_Cust."State Code") then begin
                        SstateName := RecState.Description;
                        SstateCode := RecState."State Code (GST Reg. No.)";
                    end;
                end else begin
                    sname := "Ship-to Name";
                    Saddress := "Ship-to Address";
                    Saddress2 := "Ship-to Address 2";
                    Scity := "Ship-to City";
                    SPostCode := "Sell-to Post Code";
                    //SCountry := "Sell-to Country/Region Code";
                    if RecCountry.Get("Sales Header"."Ship-to Country/Region Code") then begin
                        SCountry := RecCountry.Name;
                    end;
                    SGSTNo := Rec_Cust."GST Registration No.";
                    SPAN := Rec_Cust."P.A.N. No.";
                    if RecState.Get("GST Ship-to State Code") then begin
                        SstateName := RecState.Description;
                        SstateCode := RecState."State Code (GST Reg. No.)";
                    end;
                end;
                IF RecState.GET(CompanyInfo."State Code") THEN BEGIN
                    CompStateName := RecState.Description;
                    CmpStateCode := RecState."State Code (GST Reg. No.)";
                END;

                if RecState.Get("GST Ship-to State Code") then begin
                    SstateName := RecState.Description;
                    SstateCode := RecState."State Code (GST Reg. No.)";
                end;

                if RecState.Get("GST Bill-to State Code") then begin
                    BillStateName := RecState.Description;
                    BillState := RecState."State Code (GST Reg. No.)";
                end;

                Rec_Cust.RESET;
                Rec_Cust.SETRANGE("No.", "Sales Header"."Bill-to Customer No.");
                IF Rec_Cust.FIND('-') THEN BEGIN
                    Bill_GSTNo := Rec_Cust."GST Registration No.";
                END;

                Rec_Cust.Reset();
                Rec_Cust.SetRange("No.", "Sales Header"."Sell-to Customer No.");
                if Rec_Cust.Find('-') Then begin
                    SGSTNo := Rec_Cust."GST Registration No.";
                end;

                RecCurrencies.Reset();
                RecCurrencies.SetRange(Code, "Sales Header"."Currency Code");
                if RecCurrencies.FindFirst() then begin
                    Curr_symbol := RecCurrencies.Symbol;
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
                { }
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

    trigger OnInitReport()
    begin
        CompanyInfo.get();
        //CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.CalcFields(Picture);
        if RecState.Get(CompanyInfo."State Code") then begin
            CmpStateName := RecState.Description;
            //CompStateCode := RecState."State Code (GST Reg. No.)";
        end;

        BankAcc.Reset();
        BankAcc.SetRange("Bank Account No.", CompanyInfo."Bank Account No.");
        if BankAcc.Find('-') then
            repeat
                BankBrach := BankAcc."Bank Branch No.";
                SWIFTCode := BankAcc."SWIFT Code";
            until BankAcc.Next = 0;
    end;
    /*
        procedure GetStatisticsAmount(
                  PurchaseHeader: Record "Purchase Header";
                  var TDSAmount: Decimal)
        var
            PurchaseLine: Record "Purchase Line";
            TDSEntityManagement: Codeunit "TDS Entity Management";
            i: Integer;
            RecordIDList: List of [RecordID];
        begin
            Clear(TDSAmount);

            PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SetRange("Document no.", PurchaseHeader."No.");
            if PurchaseLine.FindSet() then
                repeat
                    RecordIDList.Add(PurchaseLine.RecordId());
                until PurchaseLine.Next() = 0;

            for i := 1 to RecordIDList.Count() do
                TDSAmount += GetTDSAmount(RecordIDList.Get(i));

            TDSAmount := TDSEntityManagement.RoundTDSAmount(TDSAmount);
        end;

        local procedure GetTDSAmount(RecID: RecordID): Decimal
        var
            TaxTransactionValue: Record "Tax Transaction Value";
            TDSSetup: Record "TDS Setup";
        begin
            if not TDSSetup.Get() then
                exit;

            TaxTransactionValue.SetRange("Tax Record ID", RecID);
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if not TaxTransactionValue.IsEmpty() then
                TaxTransactionValue.CalcSums(Amount);

            exit(TaxTransactionValue.Amount);
        end;
    */

    var
        myInt: Integer;
        CompanyInfo: Record "Company Information";
        RecState: Record State;
        CmpStateName: Text;
        BankAcc: Record "Bank Account";
        BankBrach: Text;
        SWIFTCode: Code[20];
        NoLbl: Label 'No.';
        DesLbl: Label 'Product Description';
        HSNLbl: Label 'HSN Code';
        DueLbl: Label 'Due On';
        qtyLbl: Label 'Qty';
        RateLbl: Label 'Rate';
        AmtLbl: Label 'Amount';
        DisLbl: Label 'Discount';
        TaxValLbl: Label 'Taxable Value';
        TotLbl: Label 'Total';
        Total: Decimal;
        Notext: array[2] of Text;
        AmountInWords: Text;

        CGSTAmt: Decimal;
        CGSTRate: Decimal;
        IGSTAmt: Decimal;
        IGSTRate: Decimal;
        SGSTAmt: Decimal;
        SGSTRate: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        GrandTotal: Decimal;
        TaxTotal: Decimal;
        TotalGST: Decimal;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        AmountToVendor: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        SalesHeaderRecordID: Record "Sales Header";
        RecSalesLine: Record "Sales Line";
        PostedVoucher: Report "Posted Voucher";
        sname: Text;
        Saddress: Text;
        Saddress2: Text;
        SGSTNo: Code[20];
        SPAN: Code[20];
        Scity: Text;
        SCountry: Text;
        SPostCode: Code[20];
        SstateCode: Code[20];
        SstateName: Text;
        Rec_Cust: Record Customer;
        Bill_GSTNo: Code[20];
        Ship_GST_No: Code[20];
        CompStateName: Text[30];
        CmpStateCode: code[20];
        ShipGSTReg: Code[10];
        BillState: Code[10];
        BillStateName: Text;
        Currency: Code[20];
        TaxRecordID: RecordId;
        RecCountry: Record "Country/Region";
        RecCurrencies: Record Currency;
        Curr_symbol: Text;
        TCSAmt: Decimal;
        TCSPer: Decimal;
        BAnk: Record 288;

    local procedure ClearData()
    Begin
        IGSTRate := 0;
        SGSTRate := 0;
        CGSTRate := 0;

        TotalCGST := 0;
        TotalSGST := 0;
        TotalIGST := 0;

        IGST := 0;
        CGST := 0;
        SGST := 0;
        Clear(AmountinWords);
    End;


}