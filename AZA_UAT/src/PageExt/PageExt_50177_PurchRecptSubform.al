pageextension 50177 PostedPurchRecptSubformExt extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("QC Action"; Rec."QC Action") { ApplicationArea = all; }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}