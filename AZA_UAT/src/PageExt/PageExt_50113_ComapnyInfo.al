pageextension 50113 ComapnyInfo extends "Company Information"
{
    layout
    {
        addafter("VAT Registration No.")
        {
            field("CIN No."; rec."CIN No.")
            {
                ApplicationArea = all;
            }
            field("IEC Number"; Rec."IEC Number")
            {
                ApplicationArea = all;
            }
            field("LUT Number"; Rec."LUT Number")
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