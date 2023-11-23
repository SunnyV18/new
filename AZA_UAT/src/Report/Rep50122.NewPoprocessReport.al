report 50122 "New Po process Report"
{
    ApplicationArea = All;
    Caption = 'New Po process Report';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = where("Document Type" = filter("Return Order"));
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                OpenPurchaseOrderStatistics;
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


    var
        RecPurc: Record "Purchase Header";
        purc: Page "Purchase Order List";


}
