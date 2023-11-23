pageextension 50126 LocationCardExt extends "Location List"
{
    layout
    {
        addafter(Code)
        {
            field("fc_location ID"; "fc_location ID") { ApplicationArea = all; }
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