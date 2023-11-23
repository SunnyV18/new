report 50136 "Generate Barcode For All"
{
    ApplicationArea = All;
    Caption = 'GenerateBarcodeforAll';
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
                        if (item.discountPercent <> 0) then begin
                            Error('Generate Promotag %1', Item."No.");
                            CurrReport.Quit();
                        end;
                    end;
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
    begin
        if Import = true then
            Report.Run(50171, true, true, Item);
        if Export = true then
            Report.Run(50135, true, true, Item);

    end;

    var
        Import: Boolean;
        Export: Boolean;
}
