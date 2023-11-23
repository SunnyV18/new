pageextension 50109 PostedTransferReceiptExt extends "Posted Transfer Receipt"
{
    layout
    {
        addlast(General)
        {
            field("Aza Posting No."; Rec."Aza Posting No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Transfer Reason"; Rec."Transfer Reason")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Merchandiser; Rec.Merchandiser)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Total Qty"; "Total Qty") { ApplicationArea = all; Editable = false; }
            field("Total Amt"; "Total Amt") { ApplicationArea = all; Editable = false; }
        }
        // Add changes to page layout here
    }

    actions
    {
        addafter("Co&mments")
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
                    TempItem: Record Item temporary;
                    Item: Record Item;
                    Rep50171: Report 50171;
                    TransRecLine: Record "Transfer Receipt Line";
                    ItemNo: Code[250];
                    Itm: Code[250];
                begin
                    tempItem.Reset();
                    tempItem.DeleteAll();
                    TransRecLine.Reset();
                    TransRecLine.SetRange("Document No.", Rec."No.");
                    if TransRecLine.FindSet() then
                        repeat
                            // item.Get(TransRecLine."Item No.");
                            // TempItem.Init();
                            // TempItem."No." := TransRecLine."Item No.";
                            // TempItem.Description := 'Rep';
                            // if TempItem.Insert() then
                            //     Message('%1', TempItem."No.");
                            // Report.RunModal(50171, true, false, Item);
                            if ItemNo = '' then
                                ItemNo := TransRecLine."Item No." else
                                ItemNo := ItemNo + '|' + TransRecLine."Item No.";
                        until TransRecLine.Next() = 0;

                    //Itm := CopyStr(ItemNo, 2, (StrLen(ItemNo) - 1));

                    Item.Reset();
                    Item.SetFilter("No.", ItemNo);
                    //  if Item.FindSet() then// begin
                    Report.RunModal(50171, true, false, Item);
                    // Item.Reset();
                    // Item.CopyFilters(TempItem);
                    //if item.FindSet() then

                    //  end;
                end;
            }
        }
    }


    var
        myInt: Integer;
}