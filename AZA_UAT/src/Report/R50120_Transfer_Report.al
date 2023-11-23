report 50120 TransferReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'TransferReport.rdl';

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Posting Date", "Transfer-from Code", "Transfer-to Code";
            column(No_TSH; "No.") { }
            column(Posting_Date_TSH; "Posting Date") { }
            column(Merchandiser; merch) { }
            //  column(Cost; CostAct) { }

            dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
            {
                //DataItemTableView = sorting("No.");
                //RequestFilterFields = "No.";
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemLink = "Transfer Order No." = FIELD("Transfer Order No.");

                column(No_TR; "No.") { }
                column(Transfer_Order_No_; "Transfer Order No.") { }
                column(Posting_Date_TR; "Posting Date") { }
                column(Transfer_from_Name_TR; "Transfer-from Name") { }
                column(Transfer_to_Name_TR; "Transfer-to Name") { }
                // column(Merchandiser; merch) { }

                dataitem("Transfer Receipt Line"; "Transfer Receipt Line")
                {
                    DataItemLinkReference = "Transfer Receipt Header";
                    DataItemLink = "Document No." = FIELD("No.");

                    column(Document_No_; "Document No.") { }
                    column(Item_No_; "Item No.") { }
                    column(Description; Description) { }
                    column(Quantity; Quantity) { }
                    column(itemSize; itemSize) { }
                    column(itemColor; itemColor) { }
                    column(HSNCode; HSNCode) { }
                    column(MRP; MRP) { }

                    column(gstgroup; gstgroup) { }
                    column(GST_Group_Code; "GST Group Code") { }
                    column(vendorItem; vendorItem) { }
                    column(potype; potype)
                    {
                        OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright","MTO";
                        OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
                    }
                    column(lscdiv; lscdiv) { }
                    column(retaildesc; retaildesc) { }
                    column(itemcat; itemcat) { }
                    column(CollectionType; CollectionType) { }
                    column(itemdesc; itemdesc) { }
                    column(itemdesc2; itemdesc2) { }
                    column(itemdesc3; itemdesc3) { }
                    column(itemdesc4; itemdesc4) { }
                    column(PoNo; PoNo) { }
                    column(VendorName; VendorName) { }
                    column(Cost; Amount) { }

                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                    begin
                        IF Item.Get("Item No.") then begin
                            itemSize := Item.sizeName;
                            itemColor := Item.colorName;
                            HSNCode := Item."HSN/SAC Code";
                            Vendcode := Item."Vendor No.";
                            MRP := Item.MRP;
                            // Cost := Item."Unit Cost";
                            potype := Item."PO type";
                            vendorItem := Item."Vendor Item No.";
                            Item.CalcFields("Division Description");
                            lscdiv := Item."Division Description";
                            Item.CalcFields("Item Cateogry Description");
                            itemcat := Item."Item Cateogry Description";
                            Item.CalcFields("Retail product Description");
                            retaildesc := Item."Retail product Description";
                            CollectionType := Item."Collection Type";
                            itemdesc := Item.Description;
                            itemdesc2 := Item."Description 2";
                            itemdesc3 := Item."Discription 3";
                            itemdesc4 := Item."Discription 4";
                            PoNo := item."PO No.";

                            if Recvendor.Get(Vendcode) then begin
                                vendorname := Recvendor.Name;
                                // parentdesName := Recvendor."Parent designer name";
                                // ChildDesName := Recvendor.Name;

                            end;

                            RecGstGroup.Reset();
                            RecGstGroup.SetRange(Code, "GST Group Code");
                            if RecGstGroup.FindFirst() then begin
                                gstgroup := RecGstGroup.Description;
                                // Message('%1gst', gstgroup);
                            end;

                        end;

                    end;

                }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    // RecILE.Reset();
                    // RecILE.SetRange("Document No.", "Transfer Shipment Header"."No.");
                    // if RecILE.FindFirst() then begin
                    //     RecILE.CalcFields("Cost Amount (Actual)");
                    //     CostAct := RecILE."Cost Amount (Actual)";
                    // end;
                    RecLscStaff.Reset();
                    RecLscStaff.SetRange(ID, "Transfer Receipt Header".Merchandiser);
                    if RecLscStaff.FindFirst() then //begin
                        merch := RecLscStaff."First Name";
                    //  Message(merch);
                    // end;
                end;

            }

        }


    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                /* group(GroupName)
                 {
                     field(Name; SourceExpression)
                     {
                         ApplicationArea = All;

                     }
                 }*/
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

    var
        myInt: Integer;
        Vendcode: Code[20];
        VendorName: Text;
        Item: Record Item;
        PoNo: Code[20];
        itemSize: Code[20];
        itemColor: Code[20];
        HSNCode: Code[20];
        MRP: Decimal;
        Cost: Decimal;
        potype: Option;
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
        RecLscStaff: Record "LSC Staff";
        RecReciptHeader: Record "Transfer Receipt Header";
        merch: Text;
        RecReciptLine: Record "Transfer Receipt Line";
        gstgroup: Text;
        RecGstGroup: Record "GST Group";
        CollectionType: Text;
        itemdesc: Text;
        itemdesc2: Text;
        itemdesc3: Text;
        itemdesc4: Text;
        Recvendor: Record Vendor;
        RecILE: Record "Item Ledger Entry";
        CostAct: Decimal;

}