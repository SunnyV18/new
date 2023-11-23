report 50137 "Generate Promo Tag for All"
{
    ApplicationArea = All;
    Caption = 'GeneratePromoTagForAll';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            var
                ItemLedgEnrty: Record "Item Ledger Entry";
            begin
                if Item."Is Approved for Sale" = false then begin
                    Error('You have to approve item %1 for sale first', Item."No.");
                    CurrReport.Quit();
                end;
                ItemLedgEnrty.Reset();
                ItemLedgEnrty.SetRange("Item No.", Item."No.");
                if ItemLedgEnrty.FindLast() then begin
                    if ItemLedgEnrty."Remaining Quantity" = 0 then begin
                        Error('Inventory for this item %1 should not be equal to zero', Item."No.");
                        CurrReport.Quit();
                    end
                    else begin
                        if ((discountPercentByDesg = 0) And (discountPercentByAza = 0)) then begin
                            Error('Generate Barcode For All');
                            CurrReport.Quit();
                        end;
                    end;
                    // end;
                end else begin
                    Error('Inventory for this item %1 should not be equal to zero', Item."No.");
                    CurrReport.Quit();
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
    trigger OnPostReport()
    var
        RecItem: Record Item;
        RecItem1: Record Item;
    begin
        if Import = true then
            Report.Run(50172, true, true, Item);
        if Export = true then
            Report.Run(50135, true, true, Item);

    end;

    var
        Import: Boolean;
        Export: Boolean;
}
