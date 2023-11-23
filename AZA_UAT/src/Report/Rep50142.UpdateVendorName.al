report 50142 "Update Vendor Name"
{
    ApplicationArea = All;
    Caption = 'Update Vendor Name';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.get(Item."Vendor No.") then begin
                    Item."Vendor Name" := Vendor.Name;
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
