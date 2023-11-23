page 50128 "LSC Customer order Line store"
{
    ApplicationArea = All;
    Caption = 'LSC Customer order Line store';
    PageType = List;
    SourceTable = "LSC Customer Order Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Box No."; Rec."Box No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Box No. field.';
                }
                field("Click and Collect Line"; Rec."Click and Collect Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Click and Collect Order field.';
                }
                field("Collect Shelf"; Rec."Collect Shelf")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Collect Shelf field.';
                }
                field("Collect Time Limit"; Rec."Collect Time Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Collect Time Limit field.';
                }
                field("Collection Reported to Omni"; Rec."Collection Reported to Omni")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Collection Reported to Omni field.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amount field.';
                }
                field("Discount Percent"; Rec."Discount Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Percent field.';
                }
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document ID field.';
                }
                field("External ID"; Rec."External ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External ID field.';
                }
                field("Internal Available Qty."; Rec."Internal Available Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Internal Available Qty. field.';
                }
                field("Internal Selection"; Rec."Internal Selection")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Internal Selection field.';
                }
                field("Inventory Transfer"; Rec."Inventory Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inventory Transfer field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field("LSCIN Exempted"; Rec."LSCIN Exempted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exempted field.';
                }
                field("LSCIN GST Amount"; Rec."LSCIN GST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Amount field.';
                }
                field("LSCIN GST Group Code"; Rec."LSCIN GST Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Group Code field.';
                }
                field("LSCIN GST Group Type"; Rec."LSCIN GST Group Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Group Type field.';
                }
                field("LSCIN GST Place of Supply"; Rec."LSCIN GST Place of Supply")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Place of Supply field.';
                }
                field("LSCIN HSN/SAC Code"; Rec."LSCIN HSN/SAC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSN/SAC Code field.';
                }
                field("LSCIN Price Inclusive of Tax"; Rec."LSCIN Price Inclusive of Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Inclusive of Tax field.';
                }
                field("LSCIN Unit Price Incl. of Tax"; Rec."LSCIN Unit Price Incl. of Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price Incl. of Tax field.';
                }
                field("Lead Time"; Rec."Lead Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Time field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Type field.';
                }
                field("Member Card No."; Rec."Member Card No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member Card No. field.';
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Amount field.';
                }
                field("Net Price"; Rec."Net Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Price field.';
                }
                field(Number; Rec.Number)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number field.';
                }
                field("Order Reference"; Rec."Order Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Reference field.';
                }
                field("Original Line No."; Rec."Original Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Line No. field.';
                }
                field("POS Comment"; Rec."POS Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Comment field.';
                }
                field("POS Sales Associate"; Rec."POS Sales Associate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Sales Associate field.';
                }
                field("Payment Registered (Internal)"; Rec."Payment Registered (Internal)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Registered field.';
                }
                field("Prepayment Amount"; Rec."Prepayment Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prepayment Amount field.';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price field.';
                }
                field("Processing Status"; Rec."Processing Status")
                {
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processing Status field.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Order No. field.';
                }
                field("Put Back Item (Internal)"; Rec."Put Back Item (Internal)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Put Back Item field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity (Base) field.';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity Received field.';
                }
                field("Report Collection to Omni"; Rec."Report Collection to Omni")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Report Collection to Omni field.';
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Delivery Date field.';
                }
                field("Retail Image ID"; Rec."Retail Image ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Retail Image ID field.';
                }
                field("Sales Tax Rounding"; Rec."Sales Tax Rounding")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Tax Rounding field.';
                }
                field("Ship Order"; Rec."Ship Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Order field.';
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipping Agent Code field.';
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipping Agent Service Code field.';
                }
                field("Sourcing Location"; Rec."Sourcing Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sourcing Location field.';
                }
                field("Sourcing Order Type"; Rec."Sourcing Order Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sourcing Order Type field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Store No."; Rec."Store No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store No. field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("Tax Base Amount"; Rec."Tax Base Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Base Amount field.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Group Code field.';
                }
                field("Terminal No."; Rec."Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Terminal No. field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field("UoM Description"; Rec."UoM Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UoM Description field.';
                }
                field("Validate Tax Parameter"; Rec."Validate Tax Parameter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Validate Tax Parameter field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Variant Description"; Rec."Variant Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variant Description field.';
                }
                field("Vat Amount"; Rec."Vat Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vat Amount field.';
                }
                field("Vat Prod. Posting Group"; Rec."Vat Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vat Prod. Posting Group field.';
                }
                field("Vendor Sourcing"; Rec."Vendor Sourcing")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Sourcing field.';
                }
            }
        }
    }
}
