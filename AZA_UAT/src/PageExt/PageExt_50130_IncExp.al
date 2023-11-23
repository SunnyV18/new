pageextension 50130 IncExpPageExt extends "LSC Income/Expense Acc. Card"
{
    layout
    {

        addafter("Allow on Customer Order")
        {
            field("Alteration Account"; Rec."Alteration Account") { ApplicationArea = all; }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}