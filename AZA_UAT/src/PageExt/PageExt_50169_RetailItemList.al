pageextension 50169 RetailItemlistext extends "LSC Retail Item List"
{
    layout
    {
        addafter("Division Code")
        {
            field("Tag Printed"; Rec."Tag Printed") { ApplicationArea = all; }
            field("fc location"; "fc location") { ApplicationArea = all; }
            field(Inventory; Inventory) { ApplicationArea = all; }
        }
        addafter("Vendor No.")
        {
            field("Vendor Name"; "Vendor Name") { ApplicationArea = All; }
            field(Old_aza_code; Old_aza_code) { ApplicationArea = All; }
            field("VendorItemNo."; "Vendor Item No.") { Caption = 'Vendor Item No.'; ApplicationArea = All; }
            field("First Payment Received Date"; "First Payment Received Date") { ApplicationArea = All; }
            field("Is Approved for Sale"; "Is Approved for Sale") { ApplicationArea = All; }
            field(product_desc; product_desc) { ApplicationArea = All; }
            field("Vendor Abbreviation"; "Vendor Abbreviation") { ApplicationArea = All; }
        }
        addafter("Search Description")
        {
            field("HSN/SAC Code"; "HSN/SAC Code")
            {
                ApplicationArea = All;
            }
            field("GST Credit"; "GST Credit")
            {
                ApplicationArea = All;
            }
            field("GST Group Code"; "GST Group Code")
            {
                ApplicationArea = All;
            }
            field(MRP; MRP) { ApplicationArea = All; }
            field(Exempted; Exempted)
            {
                ApplicationArea = All;
            }
            field(discountPercent; discountPercent)
            {
                ApplicationArea = All;
            }
            field(discountPercentByDesg; discountPercentByDesg)
            {
                ApplicationArea = All;
            }
            field("Disc Amt"; "Disc Amt")
            {
                ApplicationArea = All;
            }
            field(discountPercentByAza; discountPercentByAza)
            {
                ApplicationArea = All;
            }
            field(discountAmountbyAza; discountAmountbyAza)
            {
                ApplicationArea = All;
            }
            field("Customer Order ID"; "Customer Order ID")
            {
                ApplicationArea = All;
            }
            field("Customer No."; "Customer No.")
            {
                ApplicationArea = All;
            }
            field("PO No."; "PO No.")
            {
                ApplicationArea = All;
            }
            field("PO type"; "PO type")
            {
                ApplicationArea = All;
            }
            field("Division Description"; "Division Description")
            {
                ApplicationArea = All;
            }
            field("Retail product Description"; "Retail product Description")
            {
                ApplicationArea = All;
            }
            field("Item Cateogry Description"; "Item Cateogry Description")
            {
                ApplicationArea = All;
            }
            field(sizeName; sizeName)
            {
                ApplicationArea = All;
            }
            field(colorName; colorName)
            {
                ApplicationArea = All;
            }
            field("Original AZA Code"; "Original AZA Code")
            {
                ApplicationArea = All;
            }
        }

        // Add changes to page layout here
        addafter("Power BI Report FactBox")
        {
            part(Picture; "Picture")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
            }
            // part(Picture2; "Item Picture 2")
            // {
            //     SubPageLink = "No." = field("No.");
            //     ApplicationArea = all;
            // }
        }
        addafter("Vendor No.")
        {

        }
    }


    actions
    {
        addafter("&Find Barcode")
        {
            action(GenerateBarCode)
            {
                ApplicationArea = all;
                Caption = 'Generate Barcode';
                Promoted = true;
                PromotedCategory = Process;
                Image = BarCode;
                trigger OnAction()
                var
                    Item: Record Item;
                    ItemLedgEnrty: Record "Item Ledger Entry";
                begin
                    // Item.Reset();
                    // Item.SetRange("No.", rec."No.");
                    // Item.SetRange("Is Approved for Sale", true);
                    // if Item.FindSet() then begin
                    //     // if ((discountPercentByDesg > 0) And (discountPercentByAza > 0)) then begin
                    //     if (discountPercent <> 0) then //begin
                    //         Error('Generate Promotag')
                    //     //  end
                    //     else
                    //         Report.RunModal(50107, true, false, Item);
                    // end;
                    Item.Reset();
                    Item.SetRange("No.", Rec."No.");
                    Item.SetRange("Is Approved for Sale", true);
                    if Item.FindFirst() then begin
                        ItemLedgEnrty.Reset();
                        ItemLedgEnrty.SetRange("Item No.", Item."No.");
                        if ItemLedgEnrty.FindLast() then begin
                            if ItemLedgEnrty."Remaining Quantity" = 0 then
                                Error('Inventory for this item should not be equal to zero')
                            else begin
                                if (discountPercent <> 0) then //begin
                                    Error('Generate Promotag')
                                //  end
                                else
                                    Report.RunModal(50133, true, true, Item);
                            end;
                        end
                        else
                            Error('Inventory for this item should not be equal to zero');
                    end else
                        Message('You have to approve item for sale first');
                end;
                //  end;

            }
            action(GenerateBarCodeForAll)
            {
                ApplicationArea = all;
                Caption = 'Generate Barcode For All';
                Promoted = true;
                PromotedCategory = Process;
                Image = BarCode;
                trigger OnAction()
                var
                    PostedSalesInvocies: Page "LSC Retail Item List";
                    SalesInvHeader: Record Item;
                    ItemRec1: Record Item;
                    ItemRec: Record Item;
                    ItemNo: Text;
                    ItemLedgEnrty2: Record "Item Ledger Entry";
                    RecRef: RecordRef;
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                begin
                    //Clear();
                    // PostedSalesInvocies.SetTableView(SalesInvHeader);
                    // PostedSalesInvocies.LookupMode(true);
                    // if PostedSalesInvocies.RunModal = ACTION::LookupOK then begin
                    //     PostedSalesInvocies.SetSelectionFilter(SalesInvHeader);
                    //     RecRef.GetTable(SalesInvHeader);
                    //     PostedSIFilter := SelectionFilterManagement.GetSelectionFilter(RecRef, SalesInvHeader.FieldNo("No."));
                    // end;
                    // Message();
                    // ItemRec.Reset();
                    // ItemRec.SetRange("No.", Rec."No.");
                    // ItemRec.SetRange("Is Approved for Sale", true);
                    // if ItemRec.FindFirst() then begin
                    //     ItemLedgEnrty2.Reset();
                    //     ItemLedgEnrty2.SetRange("Item No.", ItemRec."No.");
                    //     if ItemLedgEnrty2.FindLast() then begin
                    //         if ItemLedgEnrty2."Remaining Quantity" = 0 then
                    //             Error('Inventory for this item should not be equal to zero')
                    //         else begin
                    //             if (discountPercent <> 0) then //begin
                    //                 Error('Generate Promotag')
                    //             //  end
                    //             else
                    //                 Report.RunModal(50136, true, true, ItemRec);
                    //         end;
                    //     end
                    //     else
                    //         Error('Inventory for this item should not be equal to zero');
                    // end else
                    //     Message('You have to approve item for sale first');

                    //>>>>>>>>>>>>>>>>>>>020923AS
                    Clear(ItemNo);
                    ItemRec.Reset();
                    ItemRec.CopyFilters(Rec);
                    if ItemRec.FindSet() then
                        repeat
                            if ItemNo = '' then
                                ItemNo := ItemRec."No." else
                                ItemNo := ItemNo + '|' + ItemRec."No.";
                        until ItemRec.Next() = 0;

                    ItemRec1.Reset();
                    ItemRec1.SetFilter("No.", ItemNo);
                    Report.RunModal(50136, true, false, ItemRec1);
                end;
            }
            action(GeneratePromoTagForAll)
            {
                ApplicationArea = all;
                Caption = 'Generate PromoTag For All';
                Promoted = true;
                PromotedCategory = Process;
                Image = BarCode;
                trigger OnAction()
                var
                    PostedSalesInvocies: Page "LSC Retail Item List";
                    SalesInvHeader: Record Item;
                    ItemRec1: Record Item;
                    ItemRec: Record Item;
                    ItemNo: Text;
                    ItemLedgEnrty2: Record "Item Ledger Entry";
                    RecRef: RecordRef;
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                begin
                    // Item.Reset();
                    // Item.SetRange("No.", rec."No.");
                    // Item.SetRange("Is Approved for Sale", true);
                    // if Item.FindSet() then begin
                    //     if ((discountPercentByDesg = 0) And (discountPercentByAza = 0)) then //begin
                    //         Error('Generate Barcode')
                    //     //end
                    //     else
                    //         Report.RunModal(50108, true, false, Item);
                    // end;

                    // RecItem.Reset();
                    // RecItem.CopyFilters(Rec);
                    // // RecItem.SetRange("No.", Rec."No.");
                    // RecItem.SetRange("Is Approved for Sale", true);
                    // if RecItem.FindFirst() then begin
                    //     ItemLedgEnrty1.Reset();
                    //     ItemLedgEnrty1.SetRange("Item No.", RecItem."No.");
                    //     if ItemLedgEnrty1.FindLast() then begin
                    //         if ItemLedgEnrty1."Remaining Quantity" = 0 then
                    //             Error('Inventory for this item should not be equal to zero')
                    //         else
                    //             if ((discountPercentByDesg = 0) And (discountPercentByAza = 0)) then //begin
                    //                 Error('Generate Barcode For All')
                    //             //end
                    //             else
                    //                 Report.RunModal(50137, true, true, RecItem);
                    //     end else
                    //         Error('Inventory for this item should not be equal to zero');
                    // end else
                    //     Message('You have to approve item for sale first');
                    // // els

                    //>>>>>>>>>>>>>>>>>>>>>>>>
                    Clear(ItemNo);
                    ItemRec.Reset();
                    ItemRec.CopyFilters(Rec);
                    if ItemRec.FindSet() then
                        repeat
                            if ItemNo = '' then
                                ItemNo := ItemRec."No." else
                                ItemNo := ItemNo + '|' + ItemRec."No.";
                        until ItemRec.Next() = 0;

                    ItemRec1.Reset();
                    ItemRec1.SetFilter("No.", ItemNo);
                    Report.RunModal(50137, true, false, ItemRec1);
                end;
            }
            action(GeneratePromoTag)
            {
                ApplicationArea = all;
                Caption = 'Generate PromoTag';
                Promoted = true;
                PromotedCategory = Process;
                Image = BarCode;
                trigger OnAction()
                var
                    Item: Record Item;
                    ItemLedgEnrty: Record "Item Ledger Entry";
                begin
                    // Item.Reset();
                    // Item.SetRange("No.", rec."No.");
                    // Item.SetRange("Is Approved for Sale", true);
                    // if Item.FindSet() then begin
                    //     if ((discountPercentByDesg = 0) And (discountPercentByAza = 0)) then //begin
                    //         Error('Generate Barcode')
                    //     //end
                    //     else
                    //         Report.RunModal(50108, true, false, Item);
                    // end;

                    Item.Reset();
                    Item.SetRange("No.", Rec."No.");
                    Item.SetRange("Is Approved for Sale", true);
                    if Item.FindFirst() then begin
                        ItemLedgEnrty.Reset();
                        ItemLedgEnrty.SetRange("Item No.", Item."No.");
                        if ItemLedgEnrty.FindLast() then begin
                            if ItemLedgEnrty."Remaining Quantity" = 0 then
                                Error('Inventory for this item should not be equal to zero')
                            else
                                if ((discountPercentByDesg = 0) And (discountPercentByAza = 0)) then //begin
                                    Error('Generate Barcode')
                                //end
                                else
                                    Report.RunModal(50134, true, true, Item);
                        end else
                            Error('Inventory for this item should not be equal to zero');
                    end else
                        Message('You have to approve item for sale first');
                    // els
                end;


            }

        }
        addafter("Item Journal")
        {
            action(ExportNew)
            {
                RunObject = XMLport ExportItemsXmlPort;
                Caption = 'Export Bulk Approval';
                ApplicationArea = All;
                Image = Export;
            }
            action(importNew)
            {
                // RunObject = XMLport ImportItemsXmlPort;
                Caption = 'Import Bulk Approval';
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    myInt: Integer;
                    Item: Record Item;
                    Retailuser: Record "LSC Retail User";
                begin
                    if Retailuser.Get(UserId) then
                        if Retailuser."Item Approve" = false then begin
                            Error('You Cannot Authorize to Approve the Item');
                        end;
                    Xmlport.Run(50158, false, true, Item);
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        Error('Please do not delete the Item');

    end;

    var
        myInt: Integer;
}