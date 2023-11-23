pageextension 50195 "CC POS Data Entry Type Card" extends "LSC POS Data Entry Type Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Customer Advance Data Entry"; "Customer Advance Data Entry")
            { ApplicationArea = All; }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}