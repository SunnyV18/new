report 50134 "Generate Promo Tag"
{
    ApplicationArea = All;
    Caption = 'GeneratePromoTag';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Export/Import")
                {
                    field(Export; Export)
                    {
                        Caption = 'Accessories';
                        ApplicationArea = All;
                        trigger OnValidate()
                        var
                            RecItem1: Record Item;
                        begin
                            Import := false;
                        end;
                    }
                    field(Import; Import)
                    {
                        Caption = 'Apparel';
                        ApplicationArea = All;
                        trigger OnValidate()
                        var
                            RecItem: Record Item;
                        begin
                            Export := false;
                        end;

                    }
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
    trigger OnPreReport()
    var
        RecItem: Record Item;
        RecItem1: Record Item;
    begin
        if Import = true then
            Report.Run(50108, true, true, Item);
        if Export = true then
            Report.Run(50132, true, true, Item);

    end;

    var
        Import: Boolean;
        Export: Boolean;
}
