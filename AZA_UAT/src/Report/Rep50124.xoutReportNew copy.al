report 50131 "xout Report Today"
{
    ApplicationArea = All;
    Caption = 'Xout Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'XoutReportToday.rdl';
    dataset
    {
        dataitem("LSC Transaction Header"; "LSC Transaction Header")
        {
            // RequestFilterFields = Date, "Store No.";
            //  DataItemTableView = sorting("Store No.", Date);// where(Date = filter('Today'));
            column(Store_No_; "Store No.") { }
            column(Transaction_No_; "Transaction No.") { }
            column(SODPAMt; SODPAMt) { }
            column(DepositUsed; DepositUsed) { }
            column(TransPayment; TransPayment) { }
            column(POS_Terminal_No_; "POS Terminal No.") { }
            column(ExpAmt; ExpAmt) { }
            column(No_; '') { }
            column(Name; '') { }
            column(Customer_Order_ID; "Customer Order ID") { }
            column(Receipt_No_; "Receipt No.") { }
            column(CountryName; CountryName) { }
            column(Comp_Name; Comp_Info.Name) { }
            column(SlNo; NewSl) { }
            column(Time1; format(Time1)) { }
            column(LocName; LocName) { }
            column(CompPic; Comp_Info.Picture) { }
            column(StartDate; StartDate) { }
            column(EndDate; EndDate) { }
            column(TotalCardAmt; TotalCardAmt) { }
            column(PayAmt; PayAmt) { }
            //column(PreApp; PreApp) { }
            //column(AdvanceCode; AdvanceCode) { }

            dataitem("LSC Trans. Sales Entry"; "LSC Trans. Sales Entry")
            {
                DataItemTableView = sorting("Store No.", "POS Terminal No.", "Transaction No.", "Line No.") where("LSCIN GST Amount" = filter(<> 0));
                DataItemLink = "Transaction No." = field("Transaction No."), "Store No." = FIELD("Store No."),
                                                                              "POS Terminal No." = FIELD("POS Terminal No.");
                DataItemLinkReference = "LSC Transaction Header";
                column(LSCIN_GST_Amount; AbsTRansGstAmt) { }
                column(Net_Amount; AbsTransNetAmt) { }
                column(TransNetAmt; TransNetAmt) { }
                column(TRansGstAmt; TRansGstAmt) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(TransNetAmt);
                    if "LSC Trans. Sales Entry"."Net Amount" > 0 then begin
                        TransNetAmt := "LSC Trans. Sales Entry"."Net Amount";
                    end;
                    Clear(TRansGstAmt);
                    if "LSC Trans. Sales Entry"."LSCIN GST Amount" > 0 then begin
                        TRansGstAmt := "LSC Trans. Sales Entry"."LSCIN GST Amount";
                    end;
                    Clear(AbsTransNetAmt);
                    if "LSC Trans. Sales Entry"."Net Amount" < 0 then begin
                        AbsTransNetAmt := Abs("LSC Trans. Sales Entry"."Net Amount");
                    end;
                    Clear(AbsTRansGstAmt);
                    if "LSC Trans. Sales Entry"."LSCIN GST Amount" < 0 then begin
                        AbsTRansGstAmt := Abs("LSC Trans. Sales Entry"."LSCIN GST Amount");
                    end;
                end;

            }
            dataitem("LSC Trans. Inc./Exp. Entry"; "LSC Trans. Inc./Exp. Entry")
            {
                DataItemLink = "Transaction No." = field("Transaction No."), "Store No." = FIELD("Store No."),
                         "POS Terminal No." = FIELD("POS Terminal No.");
                DataItemLinkReference = "LSC Transaction Header";
                //DataItemTableView = where()
                //  column(Amount; ExpAmt) { }
                column(NewAdvanceCode; NewAdvanceCode) { }
                column(Fee; Abs(Fee)) { }
                column(GSTAmt; Abs(GSTAmt)) { }
                column(INCExpGstAmt; INCExpGstAmt) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    // Clear(DepositUsed);
                    // RecTRansHeader4.Reset();
                    // RecTRansHeader4.SetRange("Receipt No.", "Receipt  No.");
                    // RecTRansHeader4.SetRange("Customer Order ID", '<>%1', '');
                    // RecTRansHeader4.SetFilter("No. of Items", '<>%1', 0);
                    // if RecTRansHeader4.FindFirst() then begin
                    //     LSCTransIncExpEntry3.Reset();
                    //     LSCTransIncExpEntry3.SetRange("Receipt  No.", "Receipt  No.");
                    //     LSCTransIncExpEntry3.SetFilter("No.", '8');
                    //     if LSCTransIncExpEntry3.FindFirst() then begin
                    //         DepositUsed := LSCTransIncExpEntry3.Amount;
                    //         Message('%1Deposir', DepositUsed);
                    //     end;
                    // end;
                    Clear(Fee);
                    // if ("LSC Trans. Inc./Exp. Entry"."No." = '10') or ("LSC Trans. Inc./Exp. Entry"."No." = '11') or ("LSC Trans. Inc./Exp. Entry"."No." = '12') then begin
                    if LastRecNo1 <> "LSC Transaction Header"."Receipt No." then begin
                        RecTRansHeader.Reset();
                        RecTRansHeader.SetRange("Receipt No.", "Receipt  No.");
                        // RecTRansHeader.SetRange("Customer Order ID", '');
                        // RecTRansHeader.SetFilter("No. of Items", '<>%1', 0);
                        if RecTRansHeader.FindFirst() then begin
                            LSCTransInfoEntry.Reset();
                            LSCTransInfoEntry.SetRange("Receipt  No.", "Receipt  No.");
                            LSCTransInfoEntry.SetFilter("No.", '=%1|%2|%3', '10', '11', '12');
                            if LSCTransInfoEntry.FindFirst() then begin
                                Fee := LSCTransInfoEntry."Net Amount";
                                GSTAmt := LSCTransInfoEntry."LSCIN GST Amount";
                            end;
                        end;
                        LastRecNo1 := "LSC Transaction Header"."Receipt No.";
                    end;

                    if LastRecNo2 <> "LSC Transaction Header"."Receipt No." then begin
                        Clear(NewAdvanceCode);
                        RecTRansHeader2.Reset();
                        RecTRansHeader2.SetRange("Receipt No.", "Receipt  No.");
                        RecTRansHeader2.SetFilter("No. of Items", '<>%1', 0);
                        if RecTRansHeader2.FindFirst() then begin
                            LSCTransIncExpEntry.Reset();
                            LSCTransIncExpEntry.SetRange("Store No.", "Store No.");
                            LSCTransIncExpEntry.SetRange(Date, Date);
                            LSCTransIncExpEntry.SetRange("Receipt  No.", "Receipt  No.");
                            LSCTransIncExpEntry.SetFilter("No.", '=%1', '18');
                            if LSCTransIncExpEntry.FindFirst() then begin
                                NewAdvanceCode := "LSC Trans. Inc./Exp. Entry"."Net Amount";
                            end;
                        end;
                        LastRecNo2 := "LSC Transaction Header"."Receipt No.";
                    end;
                    // Clear(INCExpGstAmt);
                    // if ("LSC Trans. Inc./Exp. Entry"."No." = '10') or ("LSC Trans. Inc./Exp. Entry"."No." = '11') or ("LSC Trans. Inc./Exp. Entry"."No." = '12') or ("LSC Trans. Inc./Exp. Entry"."No." = '18') then begin
                    //     INCExpGstAmt := "LSC Trans. Inc./Exp. Entry"."LSCIN GST Amount";
                    // end;
                    Clear(incExPGSTAmt);
                    if LastRecNo <> "LSC Transaction Header"."Receipt No." then begin
                        RecTRansHeader1.Reset();
                        RecTRansHeader1.SetRange("Receipt No.", "Receipt  No.");
                        RecTRansHeader1.SetFilter("No. of Items", '<>%1', 0);
                        if RecTRansHeader1.FindFirst() then begin
                            LSCTransIncExpEntry.Reset();
                            LSCTransIncExpEntry.SetRange("Store No.", "Store No.");
                            LSCTransIncExpEntry.SetRange(Date, Date);
                            LSCTransIncExpEntry.SetRange("Receipt  No.", "Receipt  No.");
                            LSCTransIncExpEntry.SetFilter("No.", '=%1|%2|%3|%4', '10', '11', '12', '18');
                            if LSCTransIncExpEntry.FindFirst() then begin
                                INCExpGstAmt := Abs(LSCTransIncExpEntry."LSCIN GST Amount");
                                //  Message('%1GST', INCExpGstAmt);
                            end;
                        end;
                        LastRecNo := "LSC Transaction Header"."Receipt No.";
                    end;
                end;
            }
            dataitem("LSC Trans. Payment Entry"; "LSC Trans. Payment Entry")
            {
                DataItemLink = "Transaction No." = field("Transaction No."), "Store No." = FIELD("Store No."),
                         "POS Terminal No." = FIELD("POS Terminal No.");
                DataItemLinkReference = "LSC Transaction Header";

                column(Document_ID; '') { }//"Document ID"
                column(PosTrans_Receipt_No_; '') { }//"PosTrans Receipt No."
                column(StoreNo_; "Store No.") { }
                column(Tender_Type; "Tender Type") { }
                column(Pre_Approved_Amount_LCY; "Amount Tendered") { }//"Pre Approved Amount LCY"
                column(preAppAmt; preAppAmt) { }
                column(TenderTypeRec; TenderTypeRec.Description) { }
                column(AmtTendered; AmtTendered) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(AmtTendered);
                    if ("LSC Trans. Payment Entry"."Tender Type" = '30') or ("LSC Trans. Payment Entry"."Tender Type" = '31')
                    or ("LSC Trans. Payment Entry"."Tender Type" = '32') or ("LSC Trans. Payment Entry"."Tender Type" = '33') then
                        AmtTendered := Abs("LSC Trans. Payment Entry"."Amount Tendered");

                    if not TenderTypeRec.Get("Store No.", "Tender Type") then
                        Clear(TenderTypeRec);


                end;

            }
            dataitem("LSC Trans. Infocode Entry"; "LSC Trans. Infocode Entry")
            {
                DataItemLink = "Transaction No." = field("Transaction No."), "Store No." = FIELD("Store No."),
                         "POS Terminal No." = FIELD("POS Terminal No.");
                DataItemLinkReference = "LSC Transaction Header";
                DataItemTableView = sorting("Store No.", "POS Terminal No.", "Transaction No.", "Transaction Type", "Line No.", Infocode, "Entry Line No.") where(Infocode = const('ADVANCECODE'));
                column(AdvanceCode; Amount) { }

            }
            dataitem("LSC Customer Order Payment"; "LSC Customer Order Payment")
            {
                DataItemLinkReference = "LSC Transaction Header";
                DataItemLink = "Document ID" = field("Customer Order ID"), "Store No." = FIELD("Store No."), "PosTrans Receipt No." = field("Receipt No."), Date = field(Date);//

                column(PreSodepAmt; PreSodepAmt) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(PreSodepAmt);
                    if (("LSC Customer Order Payment"."Tender Type" = '7') or ("LSC Customer Order Payment"."Tender Type" = '21') And ("LSC Customer Order Payment"."Pre Approved Amount LCY" < 0)) then begin
                        PreSodepAmt := Abs("LSC Customer Order Payment"."Pre Approved Amount LCY");
                        // Message('%1PrePay', PreSodepAmt);
                    end;
                end;
            }

            dataitem("LSC Customer Order Header"; "LSC Customer Order Header")
            {
                DataItemLinkReference = "LSC Transaction Header";
                DataItemLink = "Document ID" = field("Customer Order ID"), "Created at Store" = FIELD("Store No."), Date = field(Date);
                column(Total_Amount; CalcFields("Total Amount")) { }
                column(Pre_Approved_AmountLCY; CalcFields("Pre Approved Amount LCY")) { }
                column(Total_Remaining; "Total Remaining") { }
                column(Slno02; Slno02) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin

                    Slno02 += 1;


                end;
            }


            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(TransPayment);
                //  if LastRecNo7 <> "LSC Transaction Header"."Customer Order ID" then begin
                if (("LSC Transaction Header"."Customer Order ID" <> '') AND ("LSC Transaction Header"."No. of Payment Lines" <> 0)) then begin
                    // repeat
                    TransPayment1 += Abs("LSC Transaction Header".Payment);
                    //  until "LSC Transaction Header".Next() = 0;
                    //Message('%1Payment1', TransPayment1);
                end;
                //LastRecNo7 := "LSC Transaction Header"."Customer Order ID";
                //  end;
                if TransPayment1 <> 0 then
                    TransPayment += TransPayment1 else
                    TransPayment := TransPayment;
                // Message('%1pAYMENT', TransPayment);
                Clear(DepositUsed);
                if LastRecNo6 <> "LSC Transaction Header"."Receipt No." then begin
                    if ("LSC Transaction Header"."Customer Order ID" <> '') And ("LSC Transaction Header"."No. of Items" <> 0) then begin
                        LSCTransIncExpEntry3.Reset();
                        LSCTransIncExpEntry3.SetRange("Receipt  No.", "LSC Transaction Header"."Receipt No.");
                        LSCTransIncExpEntry3.SetFilter("No.", '8');
                        if LSCTransIncExpEntry3.FindFirst() then begin
                            repeat
                                DepositUsed1 += Abs(LSCTransIncExpEntry3.Amount);
                            until LSCTransIncExpEntry3.Next() = 0;
                            // Message('%1Deposit', DepositUsed1);
                        end;
                    end;
                    LastRecNo6 := "LSC Transaction Header"."Receipt No.";
                end;
                if DepositUsed1 <> 0 then
                    DepositUsed += DepositUsed1 else
                    DepositUsed := DepositUsed;
                // Message('%1Depositget', DepositUsed);
                Clear(SODPAMt1);
                //NKP
                if LastRecNo5 <> "LSC Transaction Header"."Customer Order ID" then begin
                    Clear(SODPAMt1);
                    RecCOHeader.Reset();
                    RecCOHeader.SetRange("Document ID", "LSC Transaction Header"."Customer Order ID");
                    RecCOHeader.SetFilter("Processing Status", 'CLOSED');
                    IF RecCOHeader.FindFirst() then begin
                        RecTRansHeader3.Reset();
                        RecTRansHeader3.SetRange("Customer Order ID", RecCOHeader."Document ID");
                        if RecTRansHeader3.FindLast() then begin
                            LSCTransIncExpEntry2.Reset();
                            LSCTransIncExpEntry2.SetRange("Store No.", RecTRansHeader3."Store No.");
                            LSCTransIncExpEntry2.SetRange("Transaction No.", RecTRansHeader3."Transaction No.");
                            LSCTransIncExpEntry2.SetRange("POS Terminal No.", RecTRansHeader3."POS Terminal No.");
                            LSCTransIncExpEntry2.SetRange(Date, RecTRansHeader3.Date);
                            //  LSCTransIncExpEntry2.SetFilter("No.", '=%1', '8');
                            if LSCTransIncExpEntry2.FindFirst() then begin
                                SODPAMt1 := Abs(LSCTransIncExpEntry2."Amount Tendered");
                                // Message('%1sodep', SODPAMt1);
                            end;
                        end;
                    end;
                    LastRecNo5 := "LSC Transaction Header"."Customer Order ID";
                end;
                if SODPAMt1 <> 0 then
                    SODPAMt += SODPAMt1 else
                    SODPAMt := SODPAMt;
                //  Message('%1get', SODPAMt);
                //NKP

                DateTime1 := CurrentDateTime;
                Time1 := DT2Time(DateTime1);

                Recstore.Reset();
                Recstore.SetRange("No.", "Store No.");
                if Recstore.FindFirst() then begin
                    StoreName := Recstore.Name;
                    //   Message(StoreName);
                    RecCountry.Reset();
                    RecCountry.SetRange(Code, Recstore."Country Code");
                    if RecCountry.FindFirst() then begin
                        CountryName := RecCountry.Name;
                    end;

                    RecLocation.Reset();
                    RecLocation.SetRange(Code, Recstore."Location Code");
                    if RecLocation.FindFirst() then begin
                        LocName := RecLocation.Name
                    end;
                    if ("LSC Transaction Header"."LSCIN GST Amount" <> 0) And ("LSC Transaction Header"."No. of Items" > 0) then begin
                        NewSl += 1;
                    end;

                end;

            end;

            trigger OnPreDataItem();
            begin
                SlNo := 0;
                Slno02 := 0;
                Slno03 := 0;
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
    trigger OnPreReport()
    var
        Index: Integer;
    begin
        Comp_Info.get();
        Comp_Info.CalcFields(Picture);
    end;

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
        LastDocID: Code[20];
        LastRecNo: Code[20];
        LastRecNo1: Code[20];
        LastRecNo2: Code[20];
        LastRecNo3: Code[20];
        LastRecNo4: Code[20];
        LastRecNo5: Code[20];
        LastRecNo6: Code[20];
        LastRecNo7: Code[20];
        LastRecNo8: Code[20];
        RecCustordPays: Record "LSC Customer Order Payment";
        Comp_Info: Record "Company Information";
        preAppAmt: Decimal;
        recpay: Page "LSC CO Payment Subpage";
        TenderTypeRec: Record "LSC Tender Type";
        SlNo: Integer;
        Slno02: Integer;
        Slno03: Integer;
        Recstore: Record "LSC Store";
        StoreName: Text;
        CountryName: Text;
        RecCountry: Record "Country/Region";
        RecLocation: Record Location;
        LocName: Text;
        RecCustorederHeader: Record "LSC Customer Order Header";
        RecCustorederHeader1: Record "LSC Customer Order Header";
        Date1: Date;
        DateTime1: DateTime;
        Time1: Time;
        LSCTransInfoEntry: Record "LSC Trans. Inc./Exp. Entry";
        LSCTransIncExpEntry: Record "LSC Trans. Inc./Exp. Entry";
        LSCTransIncExpEntry1: Record "LSC Trans. Inc./Exp. Entry";
        LSCTransIncExpEntry2: Record "LSC Trans. Payment Entry";
        LSCTransIncExpEntry3: Record "LSC Trans. Inc./Exp. Entry";
        AdvanceCode: Decimal;
        NewSl: Integer;
        NewAdvanceCode: Decimal;
        ExpAmt: Decimal;
        PreApp: Decimal;
        t1: Page "LSC CO Pricing FactBox";
        ExtraCharge: Decimal;
        RecLscCustorderLine: Record "LSC Customer Order Line";
        RecLscCustorderLine1: Record "LSC Customer Order Line";
        RecLscCustorderLine2: Record "LSC Customer Order Line";
        PreApproveAmt: Decimal;
        TotalAmt: Decimal;
        CancelAmt: Decimal;
        RemaAMt: Decimal;
        Fee: Decimal;
        RecTRansHeader: Record "LSC Transaction Header";
        RecTRansHeader1: Record "LSC Transaction Header";
        RecTRansHeader2: Record "LSC Transaction Header";
        RecTRansHeader3: Record "LSC Transaction Header";
        RecTRansHeader4: Record "LSC Transaction Header";
        RecTRansHeader5: Record "LSC Transaction Header";
        RecCOHeader: Record "LSC Posted CO Header";
        FilterDate: Date;
        Locationcode: Code[20];
        RecLscRetail: Record "LSC Retail User";
        INCExpGstAmt: Decimal;
        TRansGstAmt: Decimal;
        TransNetAmt: Decimal;
        AbsTRansGstAmt: Decimal;
        AbsTransNetAmt: Decimal;
        SODPAMt: Decimal;
        SODPAMt1: Decimal;
        PreSodepAmt: Decimal;
        DepositUsed: Decimal;
        DepositUsed1: Decimal;
        TransPayment: Decimal;
        TransPayment1: Decimal;
        GSTAmt: Decimal;
        storeno: Text;
        StartDate: Date;
        EndDate: Date;
        TotalCardAmt: Decimal;
        AmtTendered: Decimal;
        PayAmt: Decimal;

    local procedure ClearData()
    Begin
        RemaAMt := 0;
        TotalAmt := 0;
        Fee := 0;
        CancelAmt := 0;
        PreApproveAmt := 0;
        ExtraCharge := 0;
        PreApp := 0;
    End;

}
