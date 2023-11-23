page 50112 "Item Transfer Subform"
{
    PageType = ListPart;
 //   ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Item Transfer Line";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'No.';
                     Visible = false;
                }
                field("Type of Item"; rec."Type of Item")
                {
                    ApplicationArea = All;

                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;

                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = All;

                }
            }
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