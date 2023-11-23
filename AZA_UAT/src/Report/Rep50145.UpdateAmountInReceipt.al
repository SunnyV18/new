report 50145 "Update Amount In Receipt "
{
    ApplicationArea = All;
    Caption = 'Update Amount In Receipt ';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(TransferReceiptLine; "Transfer Receipt Line")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            var
                RecTrasferLine: record "Transfer Line";
                RecItem: Record Item;
                myInt: Integer;
            begin
                if RecItem.Get(TransferReceiptLine."Item No.") then begin
                    TransferReceiptLine.Amount := RecItem."Unit Cost";
                    TransferReceiptLine.Modify();
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
