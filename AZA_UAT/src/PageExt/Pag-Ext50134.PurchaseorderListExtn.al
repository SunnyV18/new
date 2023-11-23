pageextension 50134 PurchaseOrderListExtn extends "Purchase Order List"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("PostingDate"; "Posting Date") { ApplicationArea = All; Caption = 'Posting Date'; }
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

