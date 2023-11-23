pageextension 50189 GSTRegNos_Ext extends "GST Registration Nos."
{
    layout
    {
        addafter(Description)
        {
            field("E-Invoice UserName"; Rec."E-Invoice UserName") { ApplicationArea = all; }
            field("E-Invoice Password"; Rec."E-Invoice Password") { ApplicationArea = all; }
            field("E-Invoice Client ID"; Rec."E-Invoice Client ID") { ApplicationArea = all; }
            field("E-Invoice Client Secret"; Rec."E-Invoice Client Secret") { ApplicationArea = all; }


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