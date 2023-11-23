report 50109 "Open Customer Report"
{
    ApplicationArea = All;
    Caption = 'Open Customer Order';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'OpenCustRep.rdl';
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


            dataitem("LSC CustomerOrder Line"; "LSC Customer Order Line")
            {
                DataItemTableView = sorting("Document ID", "Line No.");
                DataItemLinkReference = LSCCustomerOrderHeader;
                DataItemLink = "Document ID" = field("Document ID");
                column(Quantity; Quantity) { }
                column(Quantity_Received; "Quantity Received") { }
                column(Net_Amount; "Net Amount") { }
                column(Number; Number) { }
                column(SalespersonCode; "POS Sales Associate") { }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    Item: Record Item;

                begin
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


                        // if RecDivision.Get(lscdiv) then begin
                        //     Division := RecDivision.Description;
                        //     //   Message(Division);
                        // end;
                        // if Recitemcat.Get(itemcat) then begin
                        //     itemCategory := Recitemcat.Description;
                        //     // Message(itemCategory);
                        // end;
                        // RecRetail.Reset();
                        // RecRetail.SetRange(RecRetail."Item Category Code", Item."Item Category Code");
                        // RecRetail.SetRange(RecRetail.Code, Item."LSC Retail Product Code");
                        // if RecRetail.FindLast() then begin
                        //     Retailitem := RecRetail.Description;
                        //     // Rec.Modify(true);
                        //     //Message('%1', "Retail product Description");
                        // end;
                        // Message('%1', potype);
                        if Recvendor.Get(Vendcode) then begin
                            vendorname := Recvendor.Name;
                            // parentdesName := Recvendor."Parent designer name";
                            // ChildDesName := Recvendor.Name;

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
        Vendcode: Code[20];
        VendorName: Text;
        itemSize: Code[20];
        itemColor: Code[20];
        mrp: Decimal;
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

}
