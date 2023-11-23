pageextension 50194 StateExt extends States
{
    layout
    {
        addafter("State Code for eTDS/TCS")
        {
            field("User Id"; Rec."User Id")
            {
                ApplicationArea = All;
            }
            field(Password; Rec.Password)
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