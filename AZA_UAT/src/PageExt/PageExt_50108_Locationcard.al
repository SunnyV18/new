pageextension 50108 "Location card" extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("LSC Electronic Doc. Addr. Code")
        {
            field("LUT Number"; Rec."LUT Number")
            {
                ApplicationArea = All;
            }
        }
        addafter(Adjustment)
        {
            field("fc_location ID"; "fc_location ID") { ApplicationArea = all; }
            field("Po Creation"; "Po Creation") { ApplicationArea = all; }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}