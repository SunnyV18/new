page 50159 "LSC Trans"
{
    Caption = 'LSC Trans. Sales Entry Store';
    PageType = Worksheet;
    SourceTable = "LSC Trans. Sales Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("BI Timestamp"; Rec."BI Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BI Timestamp field.';
                }
                field("Barcode No."; Rec."Barcode No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Barcode No. field.';
                }
                field("CO Refund Line"; Rec."CO Refund Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CO Refund Line field.';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Amount field.';
                }
                field(Counter; Rec.Counter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Counter field.';
                }
                field("Coupon Amt. For Printing"; Rec."Coupon Amt. For Printing")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Coupon Amt. For Printing field.';
                }
                field("Coupon Discount"; Rec."Coupon Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Coupon Discount field.';
                }
                field("Created by Staff ID"; Rec."Created by Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created by Staff ID field.';
                }
                field("Cust. Invoice Discount"; Rec."Cust. Invoice Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cust. Invoice Discount field.';
                }
                field("Customer Discount"; Rec."Customer Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Discount field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Deal Header Line No."; Rec."Deal Header Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deal Header Line No. field.';
                }
                field("Deal Line"; Rec."Deal Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deal Line field.';
                }
                field("Deal Line Added Amt."; Rec."Deal Line Added Amt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deal Line Added Amt. field.';
                }
                field("Deal Line No."; Rec."Deal Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deal Line No. field.';
                }
                field("Deal Modifier Added Amt."; Rec."Deal Modifier Added Amt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deal Modifier Added Amt. field.';
                }
                field("Deal Modifier Line No."; Rec."Deal Modifier Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deal Modifier Line No. field.';
                }
                field("Designer Name"; Rec."Designer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Designer Name field.';
                }
                field("Disc. Amount From Std. Price"; Rec."Disc. Amount From Std. Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disc. Amount From Std. Price field.';
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount % field.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amount field.';
                }
                field("Discount Amt. For Printing"; Rec."Discount Amt. For Printing")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amt. For Printing field.';
                }
                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Division Code field.';
                }
                field("Excluded BOM Line No."; Rec."Excluded BOM Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Excluded BOM Line No. field.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("Infocode Discount"; Rec."Infocode Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Infocode Discount field.';
                }
                field("Infocode Entry Line No."; Rec."Infocode Entry Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Infocode Entry Line No. field.';
                }
                field("Infocode Selected Qty."; Rec."Infocode Selected Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Infocode Selected Qty. field.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Category Code field.';
                }
                field("Item Corrected Line"; Rec."Item Corrected Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Corrected Line field.';
                }
                field("Item Disc. Group"; Rec."Item Disc. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Disc. Group field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Number Scanned"; Rec."Item Number Scanned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Number Scanned field.';
                }
                field("Item Posting Group"; Rec."Item Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Posting Group field.';
                }
                field("Keyboard Item Entry"; Rec."Keyboard Item Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Keyboard Item Entry field.';
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
                field("LSCIN GST Jurisdiction Type"; Rec."LSCIN GST Jurisdiction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Jurisdiction Type field.';
                }
                field("LSCIN HSN/SAC Code"; Rec."LSCIN HSN/SAC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSN/SAC Code field.';
                }
                field("LSCIN Net Price"; Rec."LSCIN Net Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Price field.';
                }
                field("LSCIN Price Inclusive of Tax"; Rec."LSCIN Price Inclusive of Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Inclusive of Tax field.';
                }
                field("LSCIN Total UPIT Amount"; Rec."LSCIN Total UPIT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total UPIT Amount field.';
                }
                field("LSCIN Unit Price Incl. of Tax"; Rec."LSCIN Unit Price Incl. of Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price Incl. of Tax field.';
                }
                field(Limitation; Rec.Limitation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Limitation field.';
                }
                field("Limitation Tax Exempted"; Rec."Limitation Tax Exempted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Limitation Tax Exempted field.';
                }
                field("Line Discount"; Rec."Line Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Discount field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Type Extension field.';
                }
                field("Line was Discounted"; Rec."Line was Discounted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line was Discounted field.';
                }
                field("Linked No. not Orig."; Rec."Linked No. not Orig.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Linked No. not Orig. field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field("Marked for Gift Receipt"; Rec."Marked for Gift Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Marked for Gift Receipt field.';
                }
                field("Member Points"; Rec."Member Points")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member Points field.';
                }
                field("Member Points Type"; Rec."Member Points Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member Points Type field.';
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
                field("Offer Blocked Points"; Rec."Offer Blocked Points")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Offer Blocked Points field.';
                }
                field("Orig Trans Line No."; Rec."Orig Trans Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orig. Trans. Line No. field.';
                }
                field("Orig Trans No."; Rec."Orig Trans No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orig. Trans. No. field.';
                }
                field("Orig Trans Pos"; Rec."Orig Trans Pos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orig. Trans. Pos field.';
                }
                field("Orig Trans Store"; Rec."Orig Trans Store")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orig. Trans. Store field.';
                }
                field("Orig. from Infocode"; Rec."Orig. from Infocode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orig. from Infocode field.';
                }
                field("Orig. from Subcode"; Rec."Orig. from Subcode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orig. from Subcode field.';
                }
                field("Orig. of a Linked Item List"; Rec."Orig. of a Linked Item List")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orig. of a Linked Item List field.';
                }
                field("PLB Item"; Rec."PLB Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PLB Item field.';
                }
                field("POS Comment"; Rec."POS Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Comment field.';
                }
                field("POS Terminal No."; Rec."POS Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Terminal No. field.';
                }
                field("Package Parent Line No."; Rec."Package Parent Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Package Parent Line No. field.';
                }
                field("Parent Item No."; Rec."Parent Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parent Item No. field.';
                }
                field("Parent Line No."; Rec."Parent Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parent Line No. field.';
                }
                field("Periodic Disc. Group"; Rec."Periodic Disc. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Periodic Disc. Group field.';
                }
                field("Periodic Disc. Type"; Rec."Periodic Disc. Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Periodic Disc. Type field.';
                }
                field("Periodic Discount"; Rec."Periodic Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Periodic Discount field.';
                }
                field("Posting Exception Key"; Rec."Posting Exception Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Exception Key field.';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price field.';
                }
                field("Price Change"; Rec."Price Change")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Change field.';
                }
                field("Price Group Code"; Rec."Price Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Group Code field.';
                }
                field("Price in Barcode"; Rec."Price in Barcode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price in Barcode field.';
                }
                field("Promotion No."; Rec."Promotion No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Promotion No. field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                }
                field("Recommended Item"; Rec."Recommended Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recommended Item field.';
                }
                field("Reduced Quantity"; Rec."Reduced Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reduced Quatity field.';
                }
                field("Refund Qty."; Rec."Refund Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refund Qty. field.';
                }
                field("Refunded Line No."; Rec."Refunded Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refunded Line No. field.';
                }
                field("Refunded POS No."; Rec."Refunded POS No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refunded POS No. field.';
                }
                field("Refunded Store No."; Rec."Refunded Store No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refunded Store No. field.';
                }
                field("Refunded Trans. No."; Rec."Refunded Trans. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refunded Trans. No. field.';
                }
                field(Replicated; Rec.Replicated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Replicated field.';
                }
                field("Replication Counter"; Rec."Replication Counter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Replication Counter field.';
                }
                field("Retail Product Code"; Rec."Retail Product Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Retail Product Code field.';
                }
                field("Return No Sale"; Rec."Return No Sale")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Return No Sale field.';
                }
                field("Sales Staff"; Rec."Sales Staff")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Staff field.';
                }
                field("Sales Tax Rounding"; Rec."Sales Tax Rounding")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Tax Rounding field.';
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Type field.';
                }
                field("Scale Item"; Rec."Scale Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Scale Item field.';
                }
                field(Section; Rec.Section)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Section field.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field("Serial/Lot No. Not Valid"; Rec."Serial/Lot No. Not Valid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial/Lot No. Not Valid field.';
                }
                field(Shelf; Rec.Shelf)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shelf field.';
                }
                field("Shift Date"; Rec."Shift Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift Date field.';
                }
                field("Shift No."; Rec."Shift No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift No. field.';
                }
                field("Staff ID"; Rec."Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff ID field.';
                }
                field("Standard Net Price"; Rec."Standard Net Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Standard Net Price field.';
                }
                field("Statement Code"; Rec."Statement Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Statement Code field.';
                }
                field("Store No."; Rec."Store No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store No. field.';
                }
                field("System-Exclude From Print"; Rec."System-Exclude From Print")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the System-Exclude From Print field.';
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
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Group Code field.';
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field("Tot. Disc Info Line No."; Rec."Tot. Disc Info Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tot. Disc Info Line No. field.';
                }
                field("Total Disc.%"; Rec."Total Disc.%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Disc.% field.';
                }
                field("Total Discount"; Rec."Total Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Discount field.';
                }
                field("Total Rounded Amt."; Rec."Total Rounded Amt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Rounded Amt. field.';
                }
                field("Trans. Date"; Rec."Trans. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Date field.';
                }
                field("Trans. Time"; Rec."Trans. Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Time field.';
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
                field("Type of Sale"; Rec."Type of Sale")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Sale field.';
                }
                field("UOM Price"; Rec."UOM Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UOM Price field.';
                }
                field("UOM Quantity"; Rec."UOM Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UOM Quantity field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Amount field.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Calculation Type field.';
                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Code field.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Weight Item"; Rec."Weight Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Weight Item field.';
                }
                field("Weight Manually Entered"; Rec."Weight Manually Entered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Weight Manually Entered field.';
                }
                field("xStatement No."; Rec."xStatement No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the xStatement No. field.';
                }
                field("xTransaction Status"; Rec."xTransaction Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the xTransaction Status field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if usersetup.Get(UserId) then
            if usersetup."Edit Page" = false then
                CurrPage.Editable := false
            ELSE
                CurrPage.Editable := true;
    end;

    var
        usersetup: Record "LSC Retail User";
}
