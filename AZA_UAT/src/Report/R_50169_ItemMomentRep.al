report 50169 ItemMovment
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ItemMovment.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Posting Date";
            column(Sno; Sno)
            {

            }
            column(Item_No_; "Item No.") { }
            column(Location_Code; "Location Code") { }
            column(Amount; itl."Cost Amount (Actual)") { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Sno := Sno + 1;

            end;

            trigger OnPreDataItem();
            begin
                Sno := 0;
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

    var
        Sno: Integer;
        itl: Record "Item Ledger Entry";
}