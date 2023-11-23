report 50146 "Update Location in ILE"
{
    ApplicationArea = All;
    Caption = 'Update Location in ILE';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            var
                ILE: Record "Item Ledger Entry";
            begin
                ILE.Reset();
                ILE.SetRange("Item No.", "No.");
                ILE.SetRange("Remaining Quantity", 1);
                if ILE.FindFirst() then begin
                    Item."fc location" := ILE."Location Code";
                    Item.Modify();
                end;
            end;
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
}
