pageextension 50131 IncExpListExt extends "LSC Income/Expense Acc. List"
{
    layout
    {
        addafter("G/L Account Name")
        {
            field("Alteration Account"; Rec."Alteration Account") { ApplicationArea = all; }
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