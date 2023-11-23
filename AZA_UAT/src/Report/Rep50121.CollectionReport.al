report 50121 "Collection Report"
{
    ApplicationArea = All;
    Caption = 'Collection Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'CollectionReport.rdl';
    dataset
    {
        dataitem("LSC Transaction Header"; "LSC Transaction Header")
        {
            // RequestFilterFields = Date, "Store No.";
            DataItemTableView = where("Entry Status" = filter(<> 'Voided'));
            column(ReceiptNo; "Receipt No.")
            {
            }
            column(Date; "Date")
            {
            }
            column(Aza_Posting_No_; "Aza Posting No.") { }
            column(Time; Format(Time)) { }
            column(StoreName; StoreName) { }
            column(CustNameHdr; CustNameHdr) { }
            column(RcptAmtHdr1; RcptAmtHdr1) { }
            column(DepositAmtHdr1; DepositAmtHdr1) { }
            column(CustOrdID; CustOrdID) { }
            column(TenderNew; TenderNew) { }
            column(LineCount; LSCPAyments.Count) { }
            column(RcptAmtHdr; RcptAmtHdr) { }
            column(VisBool; VisBool) { }
            column(Comment1; Comment1) { }
            column(Comment2; Comment2) { }
            column(Comment3; Comment3) { }
            column(TotalAmt; TotalAmt) { }
            dataitem(LSCTransPaymentEntry; "LSC Trans. Payment Entry")
            {
                DataItemLinkReference = "LSC Transaction Header";
                DataItemLink = "Transaction No." = field("Transaction No."), "Store No." = FIELD("Store No."),
                         "POS Terminal No." = FIELD("POS Terminal No.");
                // RequestFilterFields = Date, "Store No.";
                // DataItemTableView = sorting("Order No.");
                // column(ReceiptNo; "Receipt No.")
                // {
                // }
                column(OrderNo; "Order No.")
                {
                }
                column(AmountinCurrency; "Amount in Currency")
                {
                }
                // column(Date; "Date")
                // {
                // }
                column(ExtraCharge; ExtraCharge) { }
                column(PreApprovedAmt; PreApprovedAmt) { }
                // column(StoreName; StoreName) { }
                column(CashAmt; CashAmt) { }
                column(BankCheqAmt; BankCheqAmt) { }
                column(VisaAmt; VisaAmt) { }
                column(MasterAmt; MasterAmt) { }
                column(RupayAmt; RupayAmt) { }
                column(AmexAmt; AmexAmt) { }
                // column(TotalAmt; TotalAmt) { }
                // column(Deposit; Deposit) { }
                column(DepositUsed; DepositUsed) { }
                column(AdvanceUsed; AdvanceUsed) { }
                column(ShippingCharges; ShippingCharges) { }
                column(CustName; CustName) { }
                column(QrAmt; QrAmt) { }
                column(SmsAmt; SmsAmt) { }
                column(PaypalAmt; PaypalAmt) { }
                column(CreditNote; CreditNote) { }
                column(BankTranfer; BankTranfer) { }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    Cust: Record 18;
                    LscIncomeExpEnt: Record "LSC Trans. Inc./Exp. Entry";
                    PosCusOrdHdr: Record "LSC Posted CO Header";
                    i: Integer;
                begin

                    Clear(TotalAmt);
                    Clear(DepositUsed);
                    Clear(CustName);
                    Clear(CashAmt);
                    Clear(BankCheqAmt);
                    Clear(QrAmt);
                    Clear(SmsAmt);
                    Clear(PaypalAmt);
                    Clear(VisaAmt);
                    Clear(MasterAmt);
                    Clear(RupayAmt);
                    Clear(AmexAmt);
                    Clear(ExtraCharge);
                    Clear(AdvanceUsed);
                    Clear(CreditNote);
                    Clear(BankTranfer);
                    LscTransHdr.Reset();
                    LscTransHdr.SetRange("Transaction No.", "Transaction No.");
                    LscTransHdr.SetRange("POS Terminal No.", "POS Terminal No.");
                    LscTransHdr.SetRange("Store No.", "Store No.");
                    if LscTransHdr.FindFirst() then begin
                        //For Rcpt Total>>>
                        // if LscTransHdr."No. of Items" = 0 then
                        //     TotalAmt := LSCTransPaymentEntry."Amount Tendered" else
                        //     TotalAmt := LscTransHdr."Gross Amount";//1408
                        if (LscTransHdr."No. of Items" = 0) AND (LscTransHdr."Customer Order ID" <> '') then
                            // TotalAmt := Format(Abs(LscTransHdr.Payment)) else begin
                            TotalAmt := LscTransHdr.Payment else begin
                            if (LscTransHdr."No. of Items" <> 0) AND (LscTransHdr."Customer Order ID" <> '') then begin
                                // if PosCusOrdHdr.Get(LscTransHdr."Customer Order ID") then begin
                                //     PosCusOrdHdr.CalcFields("Total Amount");
                                //     //  TotalAmt := Format(Abs(PosCusOrdHdr."Total Amount"));
                                //     TotalAmt := Abs(PosCusOrdHdr."Total Amount");
                                // end;
                                TotalAmt := Abs(LscTransHdr."Gross Amount");
                            end else
                                // TotalAmt := Format(Abs(LscTransHdr."Gross Amount"));
                                TotalAmt := Abs(LscTransHdr."Gross Amount");
                        end;
                        // TotalAmt := LscTransHdr."Gross Amount";//140823//po cuss order hdr
                        //For Customer Name>>
                        if Cust.Get(LscTransHdr."Customer No.") then
                            CustName := Cust.Name;
                        //For Advance Used>>>>
                        if (LscTransHdr."Customer Order ID" <> '') AND (LscTransHdr."No. of Items" = 0) or (LscTransHdr."No. of Items" <> 0) then begin
                            if LSCTransPaymentEntry."Tender Type" = '21' then
                                AdvanceUsed := Abs(LSCTransPaymentEntry."Amount Tendered");
                            //  DepositUsed := Abs(LSCTransPaymentEntry."Amount Tendered");
                        end;
                        //For Deposit Used>>>>
                        if (LscTransHdr."Customer Order ID" <> '') AND (LscTransHdr."No. of Items" > 0) then begin
                            LscIncomeExpEnt.Reset();
                            LscIncomeExpEnt.SetRange("Receipt  No.", LSCTransPaymentEntry."Receipt No.");
                            LscIncomeExpEnt.SetFilter("No.", '8');
                            if LscIncomeExpEnt.FindFirst() then
                                DepositUsed := LscIncomeExpEnt.Amount;//added140823
                        end;

                        //For ExtraCharge>>>>>
                        LscIncomeExpEnt.Reset();//added140823
                        LscIncomeExpEnt.SetRange("Receipt  No.", LSCTransPaymentEntry."Receipt No.");
                        LscIncomeExpEnt.SetFilter("No.", '=%1|%2|%3', '10', '11', '12');
                        if LscIncomeExpEnt.FindSet() then
                            repeat
                                ExtraCharge += Abs(LscIncomeExpEnt.Amount);
                            until LscIncomeExpEnt.Next() = 0;

                        //For Shipping>>>>>>
                        Clear(ShippingCharges);
                        LscIncomeExpEnt.Reset();//added140823
                        LscIncomeExpEnt.SetRange("Receipt  No.", LSCTransPaymentEntry."Receipt No.");
                        LscIncomeExpEnt.SetRange("No.", '18');
                        if LscIncomeExpEnt.FindFirst() then
                            ShippingCharges := Abs(LscIncomeExpEnt.Amount);

                        if ExtraCharge > 0 then
                            TotalAmt := TotalAmt + ExtraCharge;
                        if ShippingCharges > 0 then
                            TotalAmt := TotalAmt + ShippingCharges;

                        //For CreditNote>>>>>>
                        if LSCTransPaymentEntry."Tender Type" = '7' then
                            CreditNote := Abs(LSCTransPaymentEntry."Amount Tendered");

                        //<<<<<<<<<<<<<<<<<<<
                        case
                            LSCTransPaymentEntry."Tender Type" of
                            '1': //For cash
                                begin
                                    CashAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '26'://For Bank Cheque
                                begin
                                    BankCheqAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '27': //For QrPay
                                begin
                                    QrAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '28'://For SMS Pay
                                begin
                                    SmsAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '29'://For Paypal
                                begin
                                    PaypalAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '30'://For visa
                                begin
                                    VisaAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '31'://For Master
                                begin
                                    MasterAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '32'://For Rupay
                                begin
                                    RupayAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '33'://For Amex
                                begin
                                    AmexAmt := LSCTransPaymentEntry."Amount Tendered";
                                end;
                            '13'://bank Transfer
                                begin
                                    BankTranfer := LSCTransPaymentEntry."Amount Tendered";
                                end;
                        end;
                    end;

                    Clear(i);

                    if not (LSCPAyments.count > 1) then begin
                        //i=0;
                        if CashAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'CASH';
                        end;
                        if MasterAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Master';
                        end;
                        if AmexAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Amex';
                        end;
                        if VisaAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Visa';
                        end;
                        if BankCheqAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Cheque';
                        end;
                        if BankTranfer <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Bank Transfer';
                        end;
                        if RupayAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Rupay';
                        end;
                        if PaypalAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Paypal';
                        end;
                        if SmsAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Sms Pay';
                        end;
                        if QrAmt <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Qr Pay';
                        end;
                        if CreditNote <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Credit Note';
                        end;
                        if AdvanceUsed <> 0 then begin
                            i := i + 1;
                            TenderNew := 'Advance';
                        end;
                        // if i > 1 then
                        //     TenderNew := 'Split';
                    end;
                    if DepositUsed <> 0 then
                        TenderNew := 'Deposit';

                    if "LSC Transaction Header"."Sale Is Return Sale" then
                        TotalAmt := TotalAmt * (-1);
                end;
            }
            trigger OnAfterGetRecord()
            var
                LscTransPayEnt: Record "LSC Trans. Payment Entry";
                LscIncomeExpEnt: Record "LSC Trans. Inc./Exp. Entry";
                Cust: Record 18;
                LscInfocodeEntry: Record "LSC Trans. Infocode Entry";
            begin
                Recstore.Reset();
                Recstore.SetRange("No.", "Store No.");
                if Recstore.FindFirst() then begin
                    StoreName := Recstore.Name;
                end;
                Clear(DepositAmtHdr);
                Clear(DepositAmtHdr1);
                Clear(RcptAmtHdr);
                Clear(RcptAmtHdr1);
                Clear(CustNameHdr);
                Clear(CustOrdID);
                Clear(AdvanceUsed);
                Clear(ExtraCharge);
                Clear(TotalAmt);
                LscTransPayEnt.Reset();
                LscTransPayEnt.SetRange("Transaction No.", "Transaction No.");
                LscTransPayEnt.SetRange("POS Terminal No.", "POS Terminal No.");
                LscTransPayEnt.SetRange("Store No.", "Store No.");
                if not LscTransPayEnt.FindFirst() then begin
                    // Clear(DepositAmtHdr);
                    // Clear(DepositAmtHdr1);
                    // Clear(RcptAmtHdr);
                    // Clear(RcptAmtHdr1);
                    // Clear(CustNameHdr);
                    // Clear(CustOrdID);
                    //For Customer Name
                    if Cust.Get(LscTransHdr."Customer No.") then
                        CustNameHdr := Cust.Name;

                    LscIncomeExpEnt.Reset();
                    LscIncomeExpEnt.SetRange("Receipt  No.", "LSC Transaction Header"."Receipt No.");
                    LscIncomeExpEnt.SetRange("No.", '8');
                    if LscIncomeExpEnt.FindFirst() then
                        DepositAmtHdr := Abs(LscIncomeExpEnt.Amount);
                    if DepositAmtHdr = 0 then
                        Clear(DepositAmtHdr1) else
                        DepositAmtHdr1 := Format(Abs(DepositAmtHdr));
                    RcptAmtHdr := "LSC Transaction Header"."Gross Amount";
                    // RcptAmtHdr := Abs("LSC Transaction Header".Payment);
                    if RcptAmtHdr = 0 then
                        Clear(RcptAmtHdr1) else
                        // RcptAmtHdr1 := Format(Abs(RcptAmtHdr));
                        //RcptAmtHdr1 := Abs(RcptAmtHdr);
                        TotalAmt := Abs(RcptAmtHdr);
                    CustOrdID := "LSC Transaction Header"."Customer Order ID";
                end;
                if DepositAmtHdr1 <> '' then
                    TenderNew := 'Deposit';
                Clear(LSCPAyments);
                Clear(TenderNew);
                LSCPAyments.reset;
                LSCPAyments.SetRange("Transaction No.", "Transaction No.");
                LSCPAyments.SetRange("Store No.", "Store No.");
                LSCPAyments.SetRange("POS Terminal No.", "POS Terminal No.");
                if LSCPAyments.FindFirst() then
                    if LSCPAyments.count > 1 then
                        TenderNew := 'Split';


                Clear(Comment1);
                Clear(Comment2);
                Clear(Comment3);
                LscInfocodeEntry.Reset();
                LscInfocodeEntry.SetRange("Transaction No.", "Transaction No.");
                LscInfocodeEntry.SetRange("Store No.", "Store No.");
                LscInfocodeEntry.SetRange("POS Terminal No.", "POS Terminal No.");
                LscInfocodeEntry.SetRange("Text Type", LscInfocodeEntry."Text Type"::"Freetext Input");
                if LscInfocodeEntry.FindSet() then
                    repeat
                        if Comment1 = '' then
                            Comment1 := LscInfocodeEntry.Information else
                            if Comment2 = '' then
                                Comment2 := LscInfocodeEntry.Information else
                                if Comment3 = '' then
                                    Comment3 := LscInfocodeEntry.Information;

                    until LscInfocodeEntry.Next() = 0;
                VisBool := false;
                //For TransVisiblity>>>>>>>>>
                if ("LSC Transaction Header"."Gross Amount" = 0) and ("LSC Transaction Header"."Net Amount" = 0) and
                ("LSC Transaction Header"."LSCIN GST Amount" = 0) and ("LSC Transaction Header".Payment = 0) and
                ("LSC Transaction Header"."Cost Amount" = 0) then
                    VisBool := true;
                if "LSC Transaction Header"."Sale Is Return Sale" then
                    TotalAmt := TotalAmt * (-1);

            end;


            trigger OnPreDataItem()
            var
            begin
                "LSC Transaction Header".SetFilter("Store No.", storeNo);
                if EndDate <> 0D then
                    "LSC Transaction Header".SetRange(Date, StartDate, EndDate) else
                    "LSC Transaction Header".SetRange(Date, StartDate);
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(storeNo; storeNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Store No.';
                        TableRelation = "LSC Store";
                        // Editable = false;
                        trigger OnValidate()
                        var
                            RetailUser: Record "LSC Retail User";
                        begin
                            RetailUser.Get(UserId);
                            if RetailUser.Adminstrator = false then begin
                                Error('Change in store No. Is not possible');
                            end

                        end;
                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    var
        RetailUser: Record "LSC Retail User";
    begin
        RetailUser.Get(UserId);
        if RetailUser.Adminstrator = false then begin
            storeNo := RetailUser."Store No.";
        end;
    end;

    var
        Recstore: Record "LSC Store";
        StoreName: Text;
        lscdiv: Text;
        VisBool: Boolean;
        itemcat: Text;
        retaildesc: Text;
        Deposit: Decimal;
        Charges: decimal;
        QrAmt: Decimal;
        SmsAmt: Decimal;
        PaypalAmt: Decimal;
        RcptAmtHdr: Decimal;
        //RcptAmtHdr1: Code[20];
        RcptAmtHdr1: Decimal;
        DepositAmtHdr: Decimal;
        DepositAmtHdr1: Code[20];
        CustNameHdr: Text[100];
        CustOrdID: Code[20];
        ShippingCharges: decimal;
        RecLscCustHeader: Record "LSC Customer Order Line";
        RecLscCustorderLine: Record "LSC Customer Order Line";
        ExtraCharge: Decimal;
        DepositUsed: Decimal;
        AdvanceUsed: Decimal;
        CreditNote: Decimal;
        RecLscCustOrdPay: Record "LSC Customer Order Payment";
        RecLscCustOrdPay1: Record "LSC Customer Order Payment";
        RecLscCustOrdPay2: Record "LSC Customer Order Payment";
        RecLscCustOrdPay3: Record "LSC Customer Order Payment";
        RecLscCustOrdPay4: Record "LSC Customer Order Payment";
        RecLscCustOrdPay5: Record "LSC Customer Order Payment";
        RecLscCustOrdPay6: Record "LSC Customer Order Payment";
        LscTransHdr: Record "LSC Transaction Header";
        PreApprovedAmt: Decimal;
        CashAmt: Decimal;
        BankCheqAmt: Decimal;
        MasterAmt: Decimal;
        RupayAmt: Decimal;
        AmexAmt: Decimal;
        VisaAmt: Decimal;
        BankTranfer: Decimal;
        CustName: Text[100];
        sorecar: Page "LSC CO Payment Subpage";
        TenderType: Record "LSC Tender Type";
        TenderTypeRec: Record "LSC Tender Type";
        RecTransSale: Record "LSC Trans. Payment Entry";
        TotalAmt: Decimal;
        // TotalAmt: Text[100];
        RecLscTransHeader: Record "LSC Transaction Header";
        RecTransPaym2: Record "LSC Trans. Payment Entry";
        TenderNew: Text[50];
        LSCPAyments: Record "LSC Trans. Payment Entry";
        storeno: Text;
        StartDate: Date;
        EndDate: Date;
        Comment1: Text[100];
        Comment2: text[100];
        Comment3: Text[100];

}
