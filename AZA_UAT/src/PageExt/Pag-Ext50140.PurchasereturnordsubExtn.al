pageextension 50140 PurchasereturnordsubExtn extends "Purchase Return Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field(Old_aza_code; Old_aza_code) { ApplicationArea = All; Editable = false; }
        }
        addafter("GST Assessable Value")
        {
            field("UOM"; "Unit of Measure") { ApplicationArea = All; Editable = false; }
            field("UOM Code"; "Unit of Measure Code") { ApplicationArea = All; Editable = false; }
        }
        addafter(Description)
        {
            field("Vendor Name"; "Vendor Name") { ApplicationArea = All; Editable = false; }
            field("PO type"; "PO type") { ApplicationArea = All; Editable = false; }

        }
        addbefore(AmountBeforeDiscount)
        {
            field("Total Qty"; "Total Qty") { ApplicationArea = All; Editable = false; }

        }
        // modify("No.")
        // {
        //     trigger OnBeforeValidate()
        //     var
        //         Item: Record Item;
        //         LscBarcodes: Record "LSC Barcodes";
        //     begin
        //         LscBarcodes.Reset();
        //         LscBarcodes.SetRange("Barcode No.", Rec."No.");
        //         if LscBarcodes.FindFirst() then begin
        //             Rec.Validate("No.", LscBarcodes."Item No.");
        //             exit;
        //         end;
        //     end;
        // }
        modify(Type)
        {
            Editable = false;
        }
        modify("Item Reference No.")
        {
            Editable = false;
        }
        modify(Description)
        {
            Editable = false;
        }
        modify("Return Reason Code")
        {
            Editable = false;
        }
        modify("Location Code")
        {
            Editable = false;
        }
        modify(Quantity)
        {
            Editable = false;
        }
        modify("Direct Unit Cost")
        {
            Editable = false;
        }
        modify("Tax Group Code")
        {
            Editable = false;
        }
        modify("Tax Liable")
        {
            Editable = false;
        }
        modify("Tax Area Code")
        {
            Editable = false;
        }
        modify("Use Tax")
        {
            Editable = false;
        }
        modify("Line Discount %")
        {
            Editable = false;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
        modify("Return Qty. to Ship")
        {
            Editable = false;
        }
        modify("GST Group Code")
        {
            Editable = false;
        }
        modify("Qty. to Invoice")
        {
            Editable = false;
        }
        modify("Qty. to Assign")
        {
            Editable = false;
        }
        modify("HSN/SAC Code")
        {
            Editable = false;
        }
        modify("GST Group Type")
        {
            Editable = false;
        }
        modify(Exempted)
        {
            Editable = false;
            Visible = false;
        }
        modify("GST Jurisdiction Type")
        {
            Editable = false;
        }
        modify("GST Credit")
        {
            Editable = false;
        }
        modify("GST Assessable Value")
        {
            Editable = false;
        }
        modify("Unit Price (LCY)")
        {
            Editable = false;
        }
        modify("Unit of Measure")
        {
            Editable = false;
        }
        modify("Unit of Measure Code")
        {
            Editable = false;
        }
        modify("Custom Duty Amount")
        {
            Editable = false;
        }
        modify("Qty. Assigned")
        {
            Editable = false;
        }
        modify("Total VAT Amount")
        {
            Editable = false;
        }
        // modify()
        // {
        //     Editable = false;
        // }



    }
}
