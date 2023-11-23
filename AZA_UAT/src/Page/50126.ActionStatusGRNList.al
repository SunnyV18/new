page 50126 Action_Status_GRN
{
    PageType = List;
    caption = 'Aza Action Status GRN';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ActionStatus_GRN;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; "Entry No.") { ApplicationArea = all; }
                field("Action ID"; "Action ID") { ApplicationArea = all; }
                field(PO_ID; PO_ID) { ApplicationArea = all; }
                field("Date added"; "Date added") { ApplicationArea = all; }
                field(BarCode; BarCode) { ApplicationArea = all; }
                field(hash; hash) { ApplicationArea = All; }
                field(Processed; Processed) { ApplicationArea = all; }

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