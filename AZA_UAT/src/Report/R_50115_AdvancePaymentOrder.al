report 50115 "Advance Payment Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Customer Order Report ';
    RDLCLayout = 'Adavance.rdl';

    dataset
    {
        dataitem("LSC Customer Order Header"; "LSC Customer Order Header")
        {
            RequestFilterFields = "Document ID";
            column(Customer_No_; "Customer No.")
            {

            }
            column(Name; Name)
            {

            }
            column(Address; Address)
            {

            }

            column(Address_2; "Address 2")
            {

            }
            column(Ship_to_Name; "Ship-to Name")
            {

            }
            column(CustState; CustState)
            {

            }
            column(StoreState; StoreState)
            {

            }
            column(Country; Country)
            {

            }

            column(datetime1; today)
            {

            }
            column(Document_ID; "Document ID")
            {

            }
            column(Created_at_Store; "Created at Store")
            {

            }
            column(Createddate; DT2Date(Created))
            {

            }
            column(Createdtime; DT2Time(Created))
            {

            }

            column(Ship_to_Address; "Ship-to Address")
            {

            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {

            }
            column(pan; pan)
            {

            }
            column(aadhar; aadhar)
            {

            }
            column(gstnumber; gstnumber)
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
            column(compnyInfocountry; compnyInfo."Country/Region Code")
            {

            }
            column(compnyInfopostcode; compnyInfo."Post Code")
            {

            }
            column(compnyInfoCIN; compnyInfo."CIN No.")
            {

            }
            column(compnyInfohomepage; compnyInfo."Home Page")
            {

            }
            column(LSC_Trans__Add__Salesperson; '')
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
            column(Staffname; Staffname)
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

            column(AZApostingNo; AZApostingNo)
            {

            }
            column(CncldAmt; CncldAmt)
            {

            }
            dataitem("LSC Customer Order Line"; "LSC Customer Order Line")
            {
                DataItemLink = "Document ID" = field("Document ID");
                DataItemLinkReference = "LSC Customer Order Header";
                column(Item_Number; Number)
                {

                }
                column(Item_Description; "Item Description")
                {

                }
                column(Unit_Price; Price)
                {

                }
                column(UnitP; UnitP)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(vc; vc)
                {

                }

                column(des; des)
                {

                }
                column(HSN; HSN)
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
                column(SGSTBoo; SGSTBoo)
                {

                }
                column(CGSTBoo; CGSTBoo)
                {

                }
                column(IGSTBoo; IGSTBoo)
                {

                }
                column(Visboo; Visboo)
                {

                }
                column(DepositAmt; DepositAmt)
                {

                }
                column(SalesStaff; SalesStaff."First Name")
                {

                }
                column(Net_Amount; "Net Amount")
                {

                }
                column(Status; Status)
                {

                }
                trigger OnAfterGetRecord()
                var

                    TaxTransactionValue: Record "LSCIN Tax Transaction Value";
                    taxrecordId: RecordId;
                    RecItem: Record Item;
                    itemcard: Page "LSC Retail Item Card";
                    LSCCustomerOrdr: Record "LSC Customer Order Payment";
                    TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
                    ComponentAmt: Decimal;
                    decColumnAmt: Decimal;
                    IncomeExp: Record "LSC Income/Expense Account";
                    GstGroup: Record "GST Group";
                    Gstpercent: Decimal;
                begin
                    if item.get(Number) then begin
                        des := item.Description;
                        VC := item."Vendor No.";
                        HSN := Item."HSN/SAC Code";
                    end;
                    DepositAmt := 0;

                    LSCCustomerOrdr.SetRange("Document ID", "LSC Customer Order Line"."Document ID");
                    if LSCCustomerOrdr.FindSet() then
                        repeat
                            DepositAmt += LSCCustomerOrdr."Pre Approved Amount LCY";
                        until LSCCustomerOrdr.Next() = 0;
                    UnitP := 0;
                    SGSTpercent := 0;
                    SGST_Amt := 0;
                    cGSTpercent := 0;
                    CGST_Amt := 0;
                    ///As per 13-02-23
                    SGSTpercent := Round((("LSCIN GST Amount" * 100) / "Net Amount") / 2);
                    cGSTpercent := Round((("LSCIN GST Amount" * 100) / "Net Amount") / 2);
                    IGST := round(("LSCIN GST Amount" * 100) / "Net Amount");
                    SGST_Amt := "LSCIN GST Amount" / 2;
                    CGST_Amt := "LSCIN GST Amount" / 2;
                    IGSTAmount := "LSCIN GST Amount";


                    // if "LSC Customer Order Line"."Line Type" = "LSC Customer Order Line"."Line Type"::Item then begin
                    //     if RecItem.Get(Number) then begin

                    //         if RecItem."GST Group Code" = 'GST 12G' then begin
                    //             UnitP := RecItem."Unit Price" / (100 + 12) * 100;
                    //             SGSTpercent := 6;
                    //             SGST_Amt := (UnitP * 6) / 100;
                    //             cGSTpercent := 6;
                    //             CGST_Amt := (UnitP * 6) / 100;
                    //             // IGST := 12;
                    //             // IGSTAmount := (RecItem."Unit Price" * 12) / 100;
                    //         end;
                    //         if RecItem."GST Group Code" = 'GST 18G' then begin
                    //             UnitP := RecItem."Unit Price" / (100 + 18) * 100;
                    //             SGSTpercent := 9;
                    //             SGST_Amt := (UnitP * 9) / 100;
                    //             cGSTpercent := 9;
                    //             CGST_Amt := (UnitP * 9) / 100;
                    //             // IGST := 18;
                    //             // IGSTAmount := (RecItem."Unit Price" * 18) / 100;
                    //         end;
                    //         if RecItem."GST Group Code" = 'GST 28G' then begin
                    //             UnitP := RecItem."Unit Price" / (100 + 28) * 100;
                    //             SGSTpercent := 14;
                    //             SGST_Amt := (UnitP * 14) / 100;
                    //             cGSTpercent := 14;
                    //             CGST_Amt := (UnitP * 14) / 100;
                    //             // IGST := 28;
                    //             // IGSTAmount := (RecItem."Unit Price" * 28) / 100;
                    //         end;
                    //         if RecItem."GST Group Code" = 'GST 5G' then begin
                    //             UnitP := RecItem."Unit Price" / (100 + 5) * 100;
                    //             SGSTpercent := 5 / 2;
                    //             SGST_Amt := (UnitP * (5 / 2)) / 100;
                    //             cGSTpercent := 5 / 2;
                    //             CGST_Amt := (UnitP * (5 / 2)) / 100;
                    //             // IGST := 5;
                    //             // IGSTAmount := (RecItem."Unit Price" * 5) / 100;
                    //         end;
                    //     end;
                    // end;
                    if "LSC Customer Order Line"."Line Type" = "LSC Customer Order Line"."Line Type"::IncomeExpense then begin
                        /*  UnitP := "LSC Customer Order Line".Price / (100 + 12) * 100;
                          SGSTpercent := 6;
                          // SGST_Amt := (UnitP * 6) / 100;
                          SGST_Amt := ("Net Amount" * 6) / 100;
                          cGSTpercent := 6;
                          //CGST_Amt := (UnitP * 6) / 100;
                          CGST_Amt := ("Net Amount" * 6) / 100;*/ //commented on040723ps-Sunny
                        VC := '';
                        HSN := '';
                        Quantity := 0;

                        GstGroup.Reset();
                        GstGroup.SetRange(Code, "LSC Customer Order Line"."LSCIN GST Group Code");
                        if GstGroup.FindFirst() then
                            Gstpercent := GstGroup."GST %";
                        SGSTpercent := Gstpercent / 2;
                        cGSTpercent := Gstpercent / 2;
                        IGST := Gstpercent;
                        SGST_Amt := Abs("LSC Customer Order Line"."LSCIN GST Amount" / 2);
                        CGST_Amt := Abs("LSC Customer Order Line"."LSCIN GST Amount" / 2);
                        IGSTAmount := Abs("LSC Customer Order Line"."LSCIN GST Amount");
                    end;



                    /*  //    Message('ID %1', "LSC Trans. Sales Entry".RecordId);
                      TaxTransactionValue.Reset();
                      TaxTransactionValue.SetFilter("Tax Record ID", '%1', transactionSalesEntry.RecordId);
                      TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::COMPONENT);
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
                      TotalGSTAmount := abs(SGST_Amt) + abs(CGST_Amt) + abs(IGSTAmount) + abs("Net Amount");*/
                    //AS>>
                    // if SGSTpercent <> 0 then
                    //     SGSTBoo := true;
                    // if cGSTpercent <> 0 then
                    //     CGSTBoo := true;
                    // if IGST <> 0 then
                    //     IGSTBoo := true;
                    //AS<<



                    SalesStaff.Reset();
                    SalesStaff.SetRange(ID, "POS Sales Associate");
                    if SalesStaff.FindFirst() then
                        Staffname := SalesStaff."First Name";

                end;

            }
            trigger OnAfterGetRecord()
            var
                cust: Record Customer;
                Item: Record Item;
                CusOrdLine: Record "LSC Customer Order Line";
            begin
                if cust.GET("Customer No.") then// begin
                    pan := cust."P.A.N. No.";
                aadhar := cust."Adhaar No.";
                gstnumber := cust."GST Registration No.";
                CustState := cust."State Code";
                Country := cust."Country/Region Code";


                // end;
                if StoreInfo.get("Created at Store") then begin
                    storeName := StoreInfo.Name;
                    StoreAddress := StoreInfo.Address;
                    storeaddress2 := StoreInfo."Address 2";
                    storecountry := StoreInfo.County;
                    storePincode := StoreInfo."Post Code";
                    storePhoneNo := StoreInfo."Phone No.";
                    StoreGST := StoreInfo."LSCIN GST Registration No";
                    store_email := StoreInfo."email id";
                    StoreState := StoreInfo."LSCIN State Code";
                end;

                // if CustState = StoreState then
                //     SGSTBoo := true
                // else
                //     IGSTBoo := true;
                if cust."GST Customer Type" = cust."GST Customer Type"::Registered then begin
                    if CustState = StoreState then
                        SGSTBoo := true
                    else
                        IGSTBoo := true;
                end else
                    if cust."GST Customer Type" = cust."GST Customer Type"::unregistered then
                        SGSTBoo := true;

                transactionHeader.Reset();
                transactionHeader.SetRange("Customer Order ID", "LSC Customer Order Header"."Document ID");
                if transactionHeader.FindFirst() then begin
                    AZApostingNo := transactionHeader."Aza Posting No.";
                    Clear(Comment);
                    LSCTransInfoEntry.Reset();
                    LSCTransInfoEntry.SetRange("Store No.", transactionHeader."Store No.");
                    LSCTransInfoEntry.SetRange("Transaction No.", transactionHeader."Transaction No.");
                    LSCTransInfoEntry.SetRange("POS Terminal No.", transactionHeader."POS Terminal No.");
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


                    Clear(CncldAmt);
                    CusOrdLine.Reset();
                    CusOrdLine.SetRange("Document ID", "LSC Customer Order Header"."Document ID");
                    CusOrdLine.SetRange(Status, CusOrdLine.Status::Canceled);
                    if CusOrdLine.FindSet() then
                        repeat
                            CncldAmt += Abs(CusOrdLine."LSCIN Unit Price Incl. of Tax");
                        until CusOrdLine.Next() = 0;
                    // transactionSalesEntry.Reset();
                    // transactionSalesEntry.SetRange("Transaction No.", transactionHeader."Transaction No.");
                    // if transactionSalesEntry.FindFirst() then begin
                    //     SalesStaff.Reset();
                    //     SalesStaff.SetRange(ID, transactionSalesEntry."Staff ID");
                    //     if SalesStaff.FindFirst() then begin
                    //         Staffname := SalesStaff."First Name";
                    //     end;

                    // end;


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
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

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
    begin
        compnyInfo.GET;
    end;


    var

        SalesStaff: Record "LSC Staff";
        Staffname: text[20];
        AZApostingNo: Code[20];
        myInt: Integer;
        UnitP: Decimal;
        Visboo: Boolean;
        pan: Code[20];
        compnyInfo: Record 79;
        gstnumber: Code[30];
        aadhar: Code[20];
        StoreInfo: Record "LSC Store";
        storename: text;
        storeaddress: text;
        storeaddress2: text;
        store_email: text;
        currency: code[30];
        storecountry: text;
        storepincode: code[20];
        storePhoneNo: text[30];
        StoreGST: code[50];
        CustState: Text[50];
        StoreState: Text[50];
        Country: Text[20];
        transactionHeader: Record "LSC Transaction Header";
        transactionSalesEntry: Record "LSC Trans. Sales Entry";

        HSN: Code[20];

        vc: code[30];
        item: Record Item;
        ReportName: text;
        IGST: Decimal;
        IGSTAmount: Decimal;
        "GST Amount": Decimal;
        "GST Percentage": Decimal;
        // compnyInfo: Record "Company Information";
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
        Comment1: text[100];
        Comment2: text[100];
        HeaderComment: Text;
        LineComment: Text;
        HeaderCommentCounter: Integer;
        LineCommentCounter: Integer;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        SalesLineNo: Text[50];
        GetItem: Record Item;
        NoOfPrint: Integer;
        CopyText: Text;
        CncldAmt: Decimal;
        SalesPerson: Record "Salesperson/Purchaser";
        //IndianReportCheck: Report 18041;
        SGST_Amt: Decimal;
        SGSTpercent: Decimal;
        CGST_Amt: Decimal;
        cGSTpercent: Decimal;
        SGSTBoo: Boolean;
        CGSTBoo: Boolean;
        IGSTBoo: Boolean;
        des: text[100];
        FistName: Text;
        lastName: text;
        // State: text;
        pancard: code[30];
        // Country: text;
        add1: text[50];
        add2: text[50];

        cinNo: Code[30];
        LSCTransInfoEntry: Record "LSC Trans. Infocode Entry";
        Comment: Text[50];
        DepositAmt: Decimal;
}