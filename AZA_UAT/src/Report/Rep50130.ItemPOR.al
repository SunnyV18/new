report 50130 Item_POR
{
    ApplicationArea = All;
    Caption = 'Item_POR';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                Recitem: Record Item;
            begin
                RecItem1.Reset();
                RecItem1.SetRange("No.", "No.");
                if RecItem1.FindFirst() then begin
                    repeat
                        RecItem1."Is Approved for Sale" := true;
                        RecItem1.Modify()
                     until RecItem1.Next = 0;
                end;
            end;

            //end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        RecItem1: Record item;
        Inve: Decimal;
}
