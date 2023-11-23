report 50116 "Sales Register Report"
{
    ApplicationArea = All;
    Caption = 'Sales Register Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'SalesRegister.rdl';
    dataset
    {
        dataitem(LSCTransSalesEntry; "LSC Trans. Sales Entry")
        {
            //RequestFilterFields = Date, "Store No.";
            //  DataItemLinkReference = "LSC Transaction Header";
            // DataItemTableView = WHERE("Customer No." = FILTER());
            column(StoreName; StoreName) { }
            column(ReceiptNo; "Receipt No.")
            {
            }
            column(Date; "Date")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Price; Price)
            {
            }
            column(CostAmount; "Cost Amount")
            {
            }
            column(Sales_Staff; "Sales Staff") { }
            column(Item_No_; "Item No.") { }
            column(CustName; CustName) { }
            column(GSt; GSt) { }
            column(Country; Country) { }
            column(state; state) { }
            column(CustPost; CustPost) { }
            column(CustorderNo; CustorderNo) { }
            column(DesignCode; DesignCode) { }
            column(DesigName; DesigName) { }
            column(poNo; poNo) { }
            column(vendorItem; vendorItem) { }
            column(colour; colour) { }
            column(size; size) { }
            column(Hsn; Hsn) { }
            column(Disco; Disco) { }
            column(MRP; MRP) { }
            column(potype; potype)
            {
                OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright","MTO";
                OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            }
            column(vendorname; vendorname) { }
            column(TotalSGST; TotalSGST) { }
            column(IGSTAmt; IGSTAmt) { }
            column(CustNo; CustNo) { }
            column(CGSTAmt; CGSTAmt) { }
            column(SGSTAmt; SGSTAmt) { }
            column(Net_Amount; "Net Amount") { }
            column(Type01; Type01) { }
            column(lscdiv; lscdiv) { }
            column(retaildesc; retaildesc) { }
            column(itemcat; itemcat) { }
            column(LSCIN_GST_Amount; "LSCIN GST Amount") { }
            column(LSCIN_GST_Group_Code; "LSCIN GST Group Code") { }
            column(gstgroup; gstgroup) { }
            column(CollectionType; CollectionType) { }
            column(itemdesc; itemdesc) { }
            column(itemdesc2; itemdesc2) { }
            column(itemdesc3; itemdesc3) { }
            column(itemdesc4; itemdesc4) { }
            column(CustDate; CustDate) { }
            column(CompanyName; CompanyName) { }
            column(TenderNew; TenderNew) { }
            column(TenderTypeRec; TenderTypeRec.Description) { }
            column(TimeAZAa; format(TimeAZAa)) { }
            column(Azaposting; Azaposting) { }
            column(Comment1; Comment1) { }
            column(Comment2; Comment2) { }
            column(Comment3; Comment3) { }
            column(unitprice; unitprice) { }
            column(oldAzaa; oldAzaa) { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;

            begin

                if LSCTransSalesEntry."Item No." = '690000' then begin
                    CurrReport.Skip();
                end;
                Clear(CGSTAmt);
                Clear(SGSTAmt);
                Clear(IGSTAmt);
                CGSTRate := 0;
                SGSTRate := 0;
                IGSTRate := 0;
                CGSTTotal := 0;
                SGSTTotal := 0;
                IGSTTotal := 0;




                if "LSCIN GST Jurisdiction Type" = "LSCIN GST Jurisdiction Type"::Intrastate then begin
                    // CGSTRate := "GST %" / 2;
                    // SGSTRate := "Sales Invoice Line"."GST %" / 2;
                    CGSTAmt := "LSCIN GST Amount" / 2;
                    SGSTAmt := "LSCIN GST Amount" / 2;
                end
                else
                    if "LSCIN GST Jurisdiction Type" = "LSCIN GST Jurisdiction Type"::Interstate then begin
                        IGSTAmt := "LSCIN GST Amount";
                    end;
                // CGSTTotal += CGSTAmt;
                // SGSTTotal += SGSTAmt;
                // IGSTTotal += IGSTAmt;

                // TotalSGST := CGSTAmt + SGSTAmt;


                RecTransHeader.Reset();
                RecTransHeader.SetRange("Receipt No.", "Receipt No.");
                if RecTransHeader.FindFirst() then begin
                    CustNo := RecTransHeader."Customer No.";
                    if RecCust.Get(CustNo) then begin
                        CustName := RecCust.Name;
                        GSt := RecCust."GST Registration No.";
                        Country := RecCust."Country/Region Code";
                        state := RecCust."State Code";
                        CustPost := RecCust."Customer Posting Group";

                    end;
                end;
                Recitem.Reset();
                Recitem.SetRange("No.", "Item No.");
                if Recitem.FindFirst() then begin
                    CustorderNo := Recitem."Customer Order ID";
                    DesignCode := Recitem."Designer Code";
                    poNo := Recitem."PO No.";
                    vendorItem := Recitem."Vendor Item No.";
                    colour := Recitem.colorName;
                    size := Recitem.sizeName;
                    Hsn := Recitem."HSN/SAC Code";
                    oldAzaa := Recitem.Old_aza_code;
                    //unitprice := Recitem."Unit Price";
                    Disco := Recitem.discountAmountbyAza;
                    //MRP := Recitem.MRP;
                    potype := Recitem."PO type";
                    Recitem.CalcFields("Division Description");
                    lscdiv := Recitem."Division Description";
                    Recitem.CalcFields("Item Cateogry Description");
                    itemcat := Recitem."Item Cateogry Description";
                    Recitem.CalcFields("Retail product Description");
                    retaildesc := Recitem."Retail product Description";
                    CollectionType := Recitem."Collection Type";
                    itemdesc := Recitem.Description;
                    itemdesc2 := Recitem."Description 2";
                    itemdesc3 := Recitem."Discription 3";
                    itemdesc4 := Recitem."Discription 4";

                    Recvendor.Reset();
                    Recvendor.SetRange("No.", Recitem."Vendor No.");
                    if Recvendor.FindFirst() then begin
                        vendorname := Recvendor.Name;
                        CompanyName := Recvendor.companyName;
                    end;
                    Clear(CustDate);
                    RecCustHeader.Reset();
                    RecCustHeader.SetRange("Document ID", Recitem."Customer Order ID");
                    if RecCustHeader.FindFirst() then begin
                        CustDate := RecCustHeader.Created
                    end
                    else
                        RecCustHeader1.Reset();
                    RecCustHeader1.SetRange("Document ID", Recitem."Customer Order ID");
                    if RecCustHeader1.FindFirst() then begin
                        CustDate := RecCustHeader1.Created;
                    end;
                    //  end;
                end;
                Recstore.Reset();
                Recstore.SetRange("No.", "Store No.");
                if Recstore.FindFirst() then begin
                    StoreName := Recstore.Name;
                end;
                RecGstGroup.Reset();
                RecGstGroup.SetRange(Code, "LSCIN GST Group Code");
                if RecGstGroup.FindFirst() then begin
                    gstgroup := RecGstGroup.Description;
                    // Message('%1gst', gstgroup);
                end;
                Clear(TimeAZAa);
                RecTransHeader3.Reset();
                RecTransHeader3.SetRange("Receipt No.", "Receipt No.");
                if RecTransHeader3.FindFirst() then begin
                    TimeAZAa := RecTransHeader3.Time;
                    Azaposting := RecTransHeader3."Aza Posting No.";
                end;
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

                Clear(TenderNew);
                RecTransHeader2.Reset();
                RecTransHeader2.SetRange("Receipt No.", "Receipt No.");
                if RecTransHeader2.FindFirst() then begin
                    if RecTransHeader2."Customer Order ID" <> '' then begin
                        RecLSCPOCoPaym.Reset();
                        RecLSCPOCoPaym.SetRange("Document ID", RecTransHeader2."Customer Order ID");
                        RecLSCPOCoPaym.SetRange("PosTrans Receipt No.", RecTransHeader2."Receipt No.");
                        RecLSCPOCoPaym.SetRange(Type, RecLSCPOCoPaym.Type::Collected);
                        if RecLSCPOCoPaym.FindFirst() then
                            if RecLSCPOCoPaym.Count > 1 then
                                TenderNew := 'Split'
                            else begin
                                if RecLSCPOCoPaym.Count = 1 then begin
                                    LSCTender1.Reset();
                                    LSCTender1.SetRange(Code, RecLSCPOCoPaym."Tender Type");
                                    if LSCTender1.FindFirst() then begin
                                        TenderNew := LSCTender1.Description;
                                    end;
                                end;
                            end;
                    end;
                end;
                RecTransHeader1.Reset();
                RecTransHeader1.SetRange("Receipt No.", "Receipt No.");
                RecTransHeader1.SetRange("Customer Order ID", '');
                if RecTransHeader1.FindFirst() then begin
                    RecTransPay.Reset();
                    RecTransPay.SetRange("Receipt No.", RecTransHeader1."Receipt No.");
                    if RecTransPay.FindFirst() then
                        if RecTransPay.Count > 1 then
                            TenderNew := 'Split'
                        else begin
                            if RecTransPay.Count = 1 then begin
                                LSCTender.Reset();
                                LSCTender.SetRange(Code, RecTransPay."Tender Type");
                                if LSCTender.FindFirst() then begin
                                    TenderNew := LSCTender.Description;
                                end;
                            end;
                        end;
                end;

                if "Net Amount" < 0 then begin
                    Type01 := 'Sales';
                    if Recitem.Get(LSCTransSalesEntry."Item No.") then begin
                        unitprice := Recitem."Unit Price";
                        MRP := Recitem.MRP;
                    end;
                end
                else begin
                    Type01 := 'Return';
                    //Message(Type01);
                    if Recitem.Get(LSCTransSalesEntry."Item No.") then begin
                        unitprice := Recitem."Unit Price" * (-1);
                        MRP := Recitem.MRP * (-1);
                    end;
                end;
            end;

            // end;
            trigger OnPreDataItem()
            var
            begin
                LSCTransSalesEntry.SetFilter("Store No.", storeNo);
                if EndDate <> 0D then
                    LSCTransSalesEntry.SetRange(Date, StartDate, EndDate) else
                    LSCTransSalesEntry.SetRange(Date, StartDate);
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
        CustNo: Code[20];
        CustName: Text;
        RecCust: Record Customer;
        GSt: Code[20];
        Recitem: Record Item;
        CustorderNo: Code[50];
        Country: Code[20];
        state: Text;
        Vendcode: Code[20];
        Recstore: Record "LSC Store";
        StoreName: Text;
        Recvendor: Record Vendor;
        DesigName: Text;
        DesignCode: Code[150];
        vendorname: Text;
        vendorItem: Text;
        MRP: Decimal;
        poNo: Code[20];
        Disco: Decimal;
        potype: Option;
        Hsn: Code[20];
        colour: Code[20];
        size: Code[20];
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CGSTTotal: Decimal;
        SGSTTotal: Decimal;
        IGSTTotal: Decimal;
        TotalSGST: Decimal;
        TenderTypeRec: Record "LSC Tender Type";
        IGSTRate: Decimal;
        RecTran: Record "LSC Trans. Sales Entry";
        RecTransHeader: Record "LSC Transaction Header";
        RecTransHeader1: Record "LSC Transaction Header";
        RecTransHeader2: Record "LSC Transaction Header";
        RecTransHeader3: Record "LSC Transaction Header";
        RecLSCPOCoPaym: Record "LSC Posted CO Payment";
        RecLSCPOCoPaym1: Record "LSC Posted CO Payment";
        Type01: Text;
        CustPost: code[20];
        lscdiv: Text;
        itemcat: Text;
        retaildesc: Text;
        Division: Text;
        itemCategory: Text;
        Retailitem: Text;
        RecDivision: record "LSC Division";
        Recitemcat: Record "Item Category";
        RecRetail: Record "LSC Retail Product Group";
        gstgroup: Text;
        RecGstGroup: Record "GST Group";
        CollectionType: Text;
        itemdesc: Text;
        itemdesc2: Text;
        itemdesc3: Text;
        itemdesc4: Text;
        RecCustHeader: Record "LSC Customer Order Header";
        RecCustHeader1: Record "LSC Posted CO Header";
        CustDate: DateTime;
        CompanyName: Text;
        TenderNew: Text[50];
        RecTransPay: Record "LSC Trans. Payment Entry";
        RecTransPay1: Record "LSC Trans. Payment Entry";
        LSCTender: Record "LSC Tender Type";
        LSCTender1: Record "LSC Tender Type";
        Azaposting: Code[50];
        TimeAZAa: Time;
        storeno: Text;
        StartDate: Date;
        EndDate: Date;
        LscInfocodeEntry: Record "LSC Trans. Infocode Entry";
        Comment1: Text[100];
        Comment2: text[100];
        Comment3: Text[100];
        unitprice: Decimal;
        oldAzaa: Code[30];

}
