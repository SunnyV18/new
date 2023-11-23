report 50111 "NewCustomer Report"
{
    ApplicationArea = All;
    Caption = 'Closed Customer Order';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'CustRep.rdl';
    dataset
    {
        dataitem("LSC Posted CO Header"; "LSC Posted CO Header")
        {
            DataItemTableView = sorting("Document ID", "Created at Store");
            // RequestFilterFields = Created, "Created at Store";
            column(DocumentID; "Document ID")
            {
            }
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


            dataitem("LSC Posted Customer Order Line"; "LSC Posted Customer Order Line")
            {
                DataItemTableView = sorting("Document ID", "Line No.");
                DataItemLinkReference = "LSC Posted CO Header";
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
                        CollectionType := Item."Collection Type";
                        itemSize := Item.sizeName;
                        itemColor := Item.colorName;
                        Item.CalcFields("Division Description");
                        lscdiv := Item."Division Description";
                        Item.CalcFields("Item Cateogry Description");
                        itemcat := Item."Item Cateogry Description";
                        Item.CalcFields("Retail product Description");
                        retaildesc := Item."Retail product Description";
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
                    reccus.SetRange("Document ID", "LSC Posted Customer Order Line"."Document ID");
                    if reccus.FindFirst() then begin
                        reccus.CalcFields("Pre Approved Amount");
                        if OrderNo <> "LSC Posted Customer Order Line"."Document ID" then
                            PreAppAmt := reccus."Pre Approved Amount" else
                            PreAppAmt := 0;
                        OrderNo := "LSC Posted Customer Order Line"."Document ID";
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
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
                "LSC Posted CO Header".SetFilter("Created at Store", storeNo);
                if EndDate <> 0D then
                    "LSC Posted CO Header".SetRange(Date, StartDate, EndDate) else
                    "LSC Posted CO Header".SetRange(Date, StartDate);
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
        mrp: Decimal;
        poNo: Code[20];
        Disco: Decimal;
        size: Code[20];
        Recvendor: Record Vendor;
        StoreName: Text;
        Recstore: Record "LSC Store";
        reccus: Record "LSC Posted CO Header";
        vendorItem: Text;
        lscdiv: Text;
        itemcat: Text;
        retaildesc: Text;
        Division: Text;
        itemCategory: Text;
        itemSize: Code[20];
        itemColor: Code[20];
        Retailitem: Text;
        RecDivision: record "LSC Division";
        Recitemcat: Record "Item Category";
        RecRetail: Record "LSC Retail Product Group";
        CollectionType: Text;
        itemdesc: Text;
        itemdesc2: Text;
        itemdesc3: Text;
        itemdesc4: Text;
        RecLscCustordPay: Record "LSC Customer Order Payment";
        PreAppAmt: Decimal;
        OrderNo: code[20];
        storeno: Text;
        StartDate: Date;
        EndDate: Date;
    // RecPostCust: Record "LSC Posted CO Header"
    //  Vendcode: Code

}
