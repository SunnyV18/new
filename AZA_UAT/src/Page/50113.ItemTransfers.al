page 50113 "Items Transfers"
{
    Caption = 'Item Transfer List';

    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "item transfer Header";
    CardPageId = 50111;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Documnet No.";Rec."Documnet No.")
                {
                    ApplicationArea = All;

                }
                field("Posting Date";Rec."Posting Date")
                {
                    ApplicationArea = All;

                }
                field("Transfer from loaction Code";Rec."Transfer from loaction Code")
                {
                    ApplicationArea = All;

                }
                field("Transfer to loaction Code";Rec."Transfer to loaction Code")
                {
                    ApplicationArea = All;

                }
                field(Status;Rec.Status)
                {

                }
                field("Created By";Rec."Created By")
                {
                    
                }
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