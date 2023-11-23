report 50144 "Update Amout IN Transfer"
{
    ApplicationArea = All;
    Caption = 'Update Amout IN Transfer';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            var
                RecTrasferLine: record "Transfer Line";
                RecItem: Record Item;
                myInt: Integer;
            begin
                if RecItem.Get("Transfer Shipment Line"."Item No.") then begin
                    "Transfer Shipment Line".Amount := RecItem."Unit Cost";
                    "Transfer Shipment Line".Modify();
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
