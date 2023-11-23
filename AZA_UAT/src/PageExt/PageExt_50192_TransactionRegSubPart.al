pageextension 50192 TransactionRegisterSubpageExt extends "LSC Trans. Sales Entries subp"
{
    layout
    {
        // Add changes to page layout here
        addafter("Net Amount")
        {
            field("POS Comment"; Rec."POS Comment") { ApplicationArea = all; }

        }
    }


    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}