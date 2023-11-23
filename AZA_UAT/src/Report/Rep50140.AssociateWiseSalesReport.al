report 50140 "Associate Wise Sales Report"
{
    ApplicationArea = All;
    Caption = 'Associate Wise Sales Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Associate.rdl';
    dataset
    {
        dataitem(LSCCustomerOrderHeader; "LSC Customer Order Header")
        {
            DataItemTableView = sorting("Document ID", "Created at Store");
            // RequestFilterFields = Created, "Created at Store";
            //  RequestFilterHeading = 'posted Purchase Credit Memo';
            column(DocumentID; "Document ID")
            {
            }
            column(Customer_No_; "Customer No.") { }
            column(Pre_Approved_Amount; CalcFields("Pre Approved Amount")) { }
            column(Created; Created)
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(Name; Name)
            {
            }
            column(BalanceAmount; "Balance Amount")
            {
            }
            column(StoreName; StoreName) { }
            column(PreAppAmt; PreAppAmt) { }
            column(mrp; mrp) { }
            column(Disco; Disco) { }
            column(Vendcode; Vendcode) { }
            column(VendorName; VendorName)
            { }
            column(poNo; poNo) { }
            column(vendorItem; vendorItem) { }
            column(lscdiv; lscdiv) { }
            column(retaildesc; retaildesc) { }
            column(itemcat; itemcat) { }
            column(CollectionType; CollectionType) { }
            column(itemColor; itemColor) { }
            column(itemSize; itemSize) { }
            column(itemdesc; itemdesc) { }
            column(itemdesc2; itemdesc2) { }
            column(itemdesc3; itemdesc3) { }
            column(itemdesc4; itemdesc4) { }
            column(storeno; storeno) { }
            column(EndDate; EndDate) { }
            column(StartDate; StartDate) { }
            dataitem("LSC CustomerOrder Line"; "LSC Customer Order Line")
            {
                DataItemTableView = sorting("Document ID", "Line No.");
                DataItemLinkReference = LSCCustomerOrderHeader;
                DataItemLink = "Document ID" = field("Document ID"), Date = field(Date), "Store No." = field("Created at Store");
                column(Quantity; Quantity) { }
                column(Quantity_Received; "Quantity Received") { }
                column(Net_Amount; "Net Amount") { }
                column(Number; Number) { }
                column(DesigAbber1; DesigAbber1) { }
                column(SalespersonCode; "POS Sales Associate") { }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    Item: Record Item;

                begin
                    //  Clear(mrp);
                    Item.Reset();
                    Item.SetRange("No.", Number);
                    if Item.FindFirst() then begin
                        mrp := Item.MRP;
                        Disco := Item."Disc Amt";
                        Vendcode := Item."Vendor No.";
                        poNo := Item."PO No.";
                        vendorItem := Item."Vendor Item No.";
                        Item.CalcFields("Division Description");
                        lscdiv := Item."Division Description";
                        Item.CalcFields("Item Cateogry Description");
                        itemcat := Item."Item Cateogry Description";
                        Item.CalcFields("Retail product Description");
                        retaildesc := Item."Retail product Description";
                        CollectionType := Item."Collection Type";
                        itemSize := Item.sizeName;
                        itemColor := Item.colorName;
                        itemdesc := Item.Description;
                        itemdesc2 := Item."Description 2";
                        itemdesc3 := Item."Discription 3";
                        itemdesc4 := Item."Discription 4";

                        if Recvendor.Get(Vendcode) then begin
                            vendorname := Recvendor.Name;
                            DesigAbber1 := Recvendor."Designer Abbreviation";
                        end;
                    end;

                    reccus.reset();
                    reccus.SetRange("Document ID", "LSC CustomerOrder Line"."Document ID");
                    if reccus.FindFirst() then begin
                        reccus.CalcFields("Pre Approved Amount");
                        if OrderNo <> "LSC CustomerOrder Line"."Document ID" then
                            PreAppAmt := reccus."Pre Approved Amount" else
                            PreAppAmt := 0;
                        OrderNo := "LSC CustomerOrder Line"."Document ID";
                    end;

                end;
            }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                OrderNo: code[20];
            begin
                Recstore.Reset();
                Recstore.SetRange("No.", "Created at Store");
                if Recstore.FindFirst() then begin
                    StoreName := Recstore.Name;
                end;

            end;

            trigger OnPreDataItem()
            var
            begin
                LSCCustomerOrderHeader.SetFilter("Created at Store", storeNo);
                if EndDate <> 0D then
                    LSCCustomerOrderHeader.SetRange(Date, StartDate, EndDate) else
                    LSCCustomerOrderHeader.SetRange(Date, StartDate);
            end;

        }
        dataitem(LSCTransSalesEntry; "LSC Trans. Sales Entry")
        {
            // DataItemLinkReference = "LSC CustomerOrder Line";
            //DataItemLink = Date = field(Date), "Store No." = field("Store No.");
            column(Type01; Type01) { }
            column(StoreName1; StoreName1) { }
            column(Azaposting; Azaposting) { }
            column(TimeAZAa; TimeAZAa) { }
            column(Date; Date) { }
            column(potype; potype)
            {
                OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright","MTO";
                OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            }
            column(CustNo; CustNo) { }
            column(CustName; CustName) { }
            column(Sales_Staff; "Sales Staff") { }
            column(Item_No_; "Item No.") { }
            column(vendorname1; vendorname1) { }
            column(mrp1; mrp1) { }
            column(Quantity1; Quantity) { }
            column(lscdiv1; lscdiv1) { }
            column(retaildesc1; retaildesc1) { }
            column(itemcat1; itemcat1) { }
            column(vendorItem1; vendorItem1) { }
            column(desc; desc) { }
            column(desc2; desc2) { }
            column(desc3; desc3) { }
            column(desc4; desc4) { }
            column(CustorderNo; CustorderNo) { }
            column(CustDate; CustDate) { }
            column(DesigAbber; DesigAbber) { }
            column(Rep; Rep) { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                // if LastRecNo1 <> LSCTransSalesEntry."Transaction No." then begin
                if LSCTransSalesEntry."Item No." = '690000' then begin
                    CurrReport.Skip();
                end;
                if "Net Amount" < 0 then begin
                    Type01 := 'Sales'
                end
                else
                    Type01 := 'Return';

                Recstore1.Reset();
                Recstore1.SetRange("No.", "Store No.");
                if Recstore1.FindFirst() then begin
                    StoreName1 := Recstore1.Name;
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

                Clear(TimeAZAa);
                RecTransHeader3.Reset();
                RecTransHeader3.SetRange("Receipt No.", "Receipt No.");
                if RecTransHeader3.FindFirst() then begin
                    TimeAZAa := RecTransHeader3.Time;
                    Azaposting := RecTransHeader3."Aza Posting No.";
                end;
                Recitem.Reset();
                Recitem.SetRange("No.", "Item No.");
                if Recitem.FindFirst() then begin
                    CustorderNo := Recitem."Customer Order ID";
                    vendorItem1 := Recitem."Vendor Item No.";
                    mrp1 := Recitem.MRP;
                    Recitem.CalcFields("Division Description");
                    lscdiv1 := Recitem."Division Description";
                    Recitem.CalcFields("Item Cateogry Description");
                    itemcat1 := Recitem."Item Cateogry Description";
                    Recitem.CalcFields("Retail product Description");
                    retaildesc1 := Recitem."Retail product Description";
                    desc := Recitem.Description;
                    desc2 := Recitem."Description 2";
                    desc3 := Recitem."Discription 3";
                    desc4 := Recitem."Discription 4";
                    potype := Recitem."PO type";
                    Recvendor1.Reset();
                    Recvendor1.SetRange("No.", Recitem."Vendor No.");
                    if Recvendor1.FindFirst() then begin
                        vendorname1 := Recvendor1.Name;
                        DesigAbber := Recvendor1."Designer Abbreviation";
                    end;
                end;
                //   LastRecNo1 := LSCTransSalesEntry."Transaction No.";
            end;
            // end;
            trigger OnPreDataItem()
            var
                myInt: Integer;
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
        LastRecNo1: Integer;
        Vendcode: Code[20];
        VendorName: Text;
        itemSize: Code[20];
        itemColor: Code[20];
        mrp: Decimal;
        mrp1: Decimal;
        size: Code[20];
        poNo: Code[20];
        Disco: Decimal;
        OrderNo: code[20];
        Recvendor: Record Vendor;
        StoreName: Text;
        Recstore: Record "LSC Store";
        reccus: Record "LSC Customer Order Header";
        vendorItem: Text;
        lscdiv: Text;
        itemcat: Text;
        retaildesc: Text;
        Division: Text;
        itemCategory: Text;
        Retailitem: Text;
        RecDivision: record "LSC Division";
        Recitemcat: Record "Item Category";
        RecRetail: Record "LSC Retail Product Group";
        CollectionType: Text;
        //  Vendcode: Code
        itemdesc: Text;
        itemdesc2: Text;
        itemdesc3: Text;
        itemdesc4: Text;
        RecLscCustordPay: Record "LSC Customer Order Payment";
        PreAppAmt: Decimal;
        NewPreAppAmt: Decimal;
        storeno: Text;
        StartDate: Date;
        EndDate: Date;
        //Naveen
        Type01: Text;
        Recstore1: Record "LSC Store";
        StoreName1: Text;
        Azaposting: Code[50];
        TimeAZAa: Time;
        RecCust: Record Customer;
        CustPost: code[20];
        GSt: Code[20];
        CustNo: Code[20];
        CustName: Text;
        Country: Code[20];
        state: Text;
        RecTransHeader: Record "LSC Transaction Header";
        RecTransHeader1: Record "LSC Transaction Header";
        RecTransHeader2: Record "LSC Transaction Header";
        RecTransHeader3: Record "LSC Transaction Header";
        Recitem: Record Item;
        Recvendor1: Record Vendor;
        vendorname1: Text;
        vendorItem1: Text;
        lscdiv1: Text;
        itemcat1: Text;
        retaildesc1: Text;
        desc: Text;
        desc2: Text;
        desc3: Text;
        desc4: Text;
        potype: Option;
        CustorderNo: Code[50];
        RecCustHeader: Record "LSC Customer Order Header";
        RecCustHeader1: Record "LSC Posted CO Header";
        CustDate: DateTime;
        DesigAbber: Text;
        DesigAbber1: Text;
        Rep: Integer;
}
