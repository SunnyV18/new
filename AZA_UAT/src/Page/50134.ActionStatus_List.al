page 50134 ActionStatus_Sales_List
{
    PageType = List;
    Caption = 'Aza Action Status Sales';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Action_Status_Sales;

    layout
    {
        area(Content)
        {
            repeater(groupName)
            {
                field(SO_ID; Rec.SO_ID) { ApplicationArea = all; }
                field("Date added"; Rec."Date added") { ApplicationArea = all; }
                field("Action ID"; Rec."Action ID") { ApplicationArea = all; }
                field(SO_Detail_ID; SO_Detail_ID) { ApplicationArea = all; }
                field(Processed; Processed) { ApplicationArea = all; }
                field(hash; hash) { ApplicationArea = All; }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}