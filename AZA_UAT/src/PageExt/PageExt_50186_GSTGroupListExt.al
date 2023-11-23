pageextension 50186 "GST Group List Ext" extends "GST Group"
{
    layout
    {
        addbefore("Cess UOM")
        {
            field("GST %"; Rec."GST %")
            {
                ApplicationArea = all;
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