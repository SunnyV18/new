page 50108 ErrorCapture
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Error Capture Staging Data';
    SourceTable = ErrorCapture;
    SourceTableView = sorting("Sr. No") order(descending);//130223 CITS_RS

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Item_code; Rec.Item_code)
                {
                    ApplicationArea = All;

                }
                field(DocumentNum; Rec.DocumentNum)
                {
                    ApplicationArea = All;

                }
                field("Error Remarks"; Rec."Error Remarks")
                {
                    ApplicationArea = All;

                }
                field("Error DateTime"; Rec."Error DateTime")
                {
                    ApplicationArea = All;

                }
                field("Process Type"; Rec."Process Type")
                {
                    ApplicationArea = All;

                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = all;
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