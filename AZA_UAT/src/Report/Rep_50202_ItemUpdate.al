report 50202 InventoryPostingGroupUpdation
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    //DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") where("Inventory Posting Group" = const('RESALE'));
            // column(ColumnName; SourceFieldName)
            // {

            // }
            trigger OnAfterGetRecord()
            var
                Item_Rec: Record Item;
            begin
                IF Item_Rec.get(Item."No.") then begin
                    if Item_Rec."Inventory Posting Group" = 'RESALE' then Begin
                        Item_Rec."Inventory Posting Group" := 'RETAIL';
                        Item_Rec.Modify();
                    End
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    var
        myInt: Integer;
}