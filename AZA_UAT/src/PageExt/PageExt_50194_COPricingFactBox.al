pageextension 50197 "LSC CO Pricing FactBox Ext" extends "LSC CO Pricing FactBox"
{
    layout
    {
        addafter("Total Amount")
        {
            field("Canceled Amount"; "Canceled Amount")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}