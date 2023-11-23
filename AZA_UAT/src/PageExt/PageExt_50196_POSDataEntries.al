pageextension 50196 "CC POS Data Entries" extends "LSC POS Data Entries"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Sales Staff"; Rec."Sales Staff")
            { ApplicationArea = All; }
            field("Sales Staff Name"; Rec."Sales Staff Name")
            { ApplicationArea = All; }
            field("Customer No."; Rec."Customer No.")
            { ApplicationArea = All; }
            field("Customer Name"; Rec."Customer Name")
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