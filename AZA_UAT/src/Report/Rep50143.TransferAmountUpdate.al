report 50143 "Transfer Amount Update"
{
    ApplicationArea = All;
    Caption = 'Transfer Amount Update';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            RequestFilterFields = "No.";
            dataitem(TransferLine; "Transfer Line")
            {
                DataItemLink = "Document No." = field("No.");
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    RecTrans: Record "Transfer Line";
                    RecTransShip: Record "Transfer Shipment Line";
                begin
                    RecTrans.Reset();
                    RecTrans.SetRange("Document No.", "Transfer Header"."No.");
                    if RecTrans.FindFirst() then begin
                        Amount := TransferLine."Transfer Price";
                        TransferLine.Modify();
                    end;
                end;
            }
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
