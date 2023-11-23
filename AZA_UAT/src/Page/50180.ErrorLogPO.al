page 50180 ErrorLogpO
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Error Log Purchase Order';
    SourceTable = ErrorLogPO;
    SourceTableView = sorting("Sr. No") order(descending);

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item Code"; Rec.Item_code)
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
field("Vendor Code";"Vendor Code")
{
    ApplicationArea=all;
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