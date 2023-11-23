report 50138 "Aza Process Report new"
{
    ApplicationArea = All;
    Caption = 'Aza_Item POR';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Aza_Item; Aza_Item)
        {
            RequestFilterFields = "Entry No.", bar_code;
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                RecCustomer: Record Aza_Item;
            begin
                RecCustomer.Reset();
                RecCustomer.SetRange(RecCustomer.bar_code, bar_code);
                RecCustomer.SetFilter(RecCustomer."Record Status", 'Error');
                if RecCustomer.FindFirst() then
                    repeat
                        RecCustomer."Record Status" := 0;
                        RecCustomer.Modify();
                    until RecCustomer.Next = 0;

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
