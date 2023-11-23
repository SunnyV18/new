pageextension 50135 PurchasereturorderExtn extends "Purchase Return Order List"
{
    actions
    {
        modify(PostAndPrint)
        {
            Visible = false;
        }
    }
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
