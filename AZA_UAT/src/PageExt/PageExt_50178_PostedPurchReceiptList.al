pageextension 50178 PostedPurchRecptList extends "Posted Purchase Receipts"
{
    Caption = 'Goods Receipt Notes';
    // CaptionML = 'Goods Receipt Notes';

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        RecLscRetail.Get(UserId);
        if not RecLscRetail.Adminstrator then begin
            if RecLscRetail."Location Code" <> '' then begin
                FilterGroup(2);
                SetRange("Location Code", RecLscRetail."Location Code");
                FilterGroup(0);
            end;
        end;
    end;

    //end;

    var
        RecLscRetail: Record "LSC Retail User";
}