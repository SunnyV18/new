pageextension 50190 UnitOfMeasureList_Ext extends "Units Of Measure"
{
    layout
    {
        addafter(Description)
        {
            field("E-Inv UOM"; Rec."E-Inv UOM") { ApplicationArea = all; Caption = 'GST UOM'; }
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