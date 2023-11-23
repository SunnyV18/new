report 50133 "Generate Barcode"
{
    ApplicationArea = All;
    Caption = 'GenerateBarcode';
    UsageCategory = Administration;
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
                    field(Accessories; Accessories)
                    {
                        Caption = 'Accessories';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin

                            Jewellery := false;
                        end;
                    }
                    field(Jewellery; Jewellery)
                    {
                        Caption = 'Apparel';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin

                            Accessories := false;
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
        if Jewellery = true then
            Report.Run(50107, true, true, Item);
        if Accessories = true then
            Report.Run(50132, true, true, Item);

    end;
    // trigger OnPostReport()
    // var
    //     recref: RecordRef;
    // begin
    //     recref.Get(Item.RecordId);
    //     if Accessories then
    //         //Report.RunModal(50107, true, false, Item);
    //         Report.Execute(50107, '', recref);

    //     if Jewellery then
    //         //Report.RunModal(50132, true, false, Item);
    //         Report.Execute(50132, '', recref);

    // end;


    var
        Jewellery: Boolean;
        Accessories: Boolean;
}
