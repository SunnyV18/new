report 50124 "Barcodes POR"
{
    ApplicationArea = All;
    Caption = 'Barcodes POR';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        // dataitem("LSC Barcodes"; "LSC Barcodes")
        {
            // RequestFilterFields = "No.";
            // dataitem("LSC Barcodes"; "LSC Barcodes")
            // {
            //     DataItemLinkReference = Item;
            //     DataItemLink = "Item No." = field("No.");
            //     trigger OnAfterGetRecord()
            //     var
            //         myInt: Integer;
            //     //  LSCBarcode: Record "LSC Barcodes";
            //     //RecItem: Record Item;
            //     begin

            //     end;
            // }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                Bar: Record "LSC Barcodes";
                Bar1: Record "LSC Barcodes";
            begin
                if StrLen(Item.Old_aza_code) <= 20 then begin
                    Bar.Reset();
                    Bar.SetRange("Barcode No.", Item.Old_aza_code);
                    If not Bar.FindFirst() then begin
                        Bar.Init();
                        Bar."Item No." := Item."No.";
                        Bar."Barcode No." := Item.Old_aza_code;
                        Bar.Insert();
                    end;
                end
                // else begin
                //     if StrLen(Item.Old_aza_code) <= 20 then begin
                //         Bar1.Init();
                //         Bar1."Item No." := Item."No.";
                //         Bar1."Barcode No." := Item.Old_aza_code;
                //         Bar1.Insert();
                //     end;
                // end;

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

}
