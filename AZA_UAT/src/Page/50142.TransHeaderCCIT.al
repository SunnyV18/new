page 50142 "Trans. Header CCIT"
{
    ApplicationArea = All;
    Caption = 'LSC Transaction Header Store';
    PageType = Worksheet;
    SourceTable = "LSC Transaction Header";
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Acknowledgement Date"; Rec."Acknowledgement Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Acknowledgement Date field.';
                }
                field("Acknowledgement No."; Rec."Acknowledgement No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Acknowledgement No. field.';
                }
                field("Amount to Account"; Rec."Amount to Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount to Account field.';
                }
                field("Apply to Doc. No."; Rec."Apply to Doc. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Apply to Doc. No. field.';
                }
                field("Aza Posting No."; Rec."Aza Posting No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Aza Posting No. field.';
                }
                field("BI Timestamp"; Rec."BI Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BI Timestamp field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Contains Forecourt Items"; Rec."Contains Forecourt Items")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contains Forecourt Items field.';
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
                field("Created on POS Terminal"; Rec."Created on POS Terminal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created on POS Terminal field.';
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Disc. Group field.';
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
                field("Customer Order"; Rec."Customer Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Order field.';
                }
                field("Customer Order ID"; Rec."Customer Order ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Order ID field.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amount field.';
                }
                field("Entry Status"; Rec."Entry Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Status field.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field("Gift Registration No."; Rec."Gift Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gift Registration No. field.';
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gross Amount field.';
                }
                field("IRN Hash"; Rec."IRN Hash")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IRN Hash field.';
                }
                field("Included in Statistics"; Rec."Included in Statistics")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Included in Statistics field.';
                }
                field("Income/Exp. Amount"; Rec."Income/Exp. Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Income/Exp. Amount field.';
                }
                field("Infocode Disc. Group"; Rec."Infocode Disc. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Infocode Disc. Group field.';
                }
                field(Isadvance; Rec.Isadvance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Isadvance field.';
                }
                field("Items Posted"; Rec."Items Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Items Posted field.';
                }
                field("LSCIN Assessee Code"; Rec."LSCIN Assessee Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assessee Code field.';
                }
                field("LSCIN Currency Factor"; Rec."LSCIN Currency Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field("LSCIN Customer GST Reg. No."; Rec."LSCIN Customer GST Reg. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer GST Reg. No. field.';
                }
                field("LSCIN Exempted "; Rec."LSCIN Exempted ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exempted field.';
                }
                field("LSCIN GST Amount"; Rec."LSCIN GST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Amount field.';
                }
                field("LSCIN GST Customer Type"; Rec."LSCIN GST Customer Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Customer Type field.';
                }
                field("LSCIN Invoice Type"; Rec."LSCIN Invoice Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Type field.';
                }
                field("LSCIN Location GST Reg. No."; Rec."LSCIN Location GST Reg. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location GST Reg. No. field.';
                }
                field("LSCIN Location State Code"; Rec."LSCIN Location State Code")
                {
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location State Code field.';
                }
                field("LSCIN Nature of Supply"; Rec."LSCIN Nature of Supply")
                {
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nature of Supply field.';
                }
                field("LSCIN State"; Rec."LSCIN State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the State field.';
                }
                field("Manager ID"; Rec."Manager ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manager ID field.';
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
                field("Net Income/Exp. Amount"; Rec."Net Income/Exp. Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Income/Exp. Amount field.';
                }
                field("No. of Covers"; Rec."No. of Covers")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Covers field.';
                }
                field("No. of Invoices"; Rec."No. of Invoices")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Invoices field.';
                }
                field("No. of Item Lines"; Rec."No. of Item Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Item Lines field.';
                }
                field("No. of Items"; Rec."No. of Items")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Items field.';
                }
                field("No. of Payment Lines"; Rec."No. of Payment Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Payment Lines field.';
                }
                field("Open Drawer"; Rec."Open Drawer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Open Drawer field.';
                }
                field("Original Date"; Rec."Original Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Date field.';
                }
                field("Override Date Time"; Rec."Override Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Override Date Time field.';
                }
                field("Override PLB Item"; Rec."Override PLB Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Override PLB Item field.';
                }
                field("Override Staff ID"; Rec."Override Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Override Staff ID field.';
                }
                field("PLB Item"; Rec."PLB Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PLB Item field.';
                }
                field("POS Terminal No."; Rec."POS Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Terminal No. field.';
                }
                field(Payment; Rec.Payment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment field.';
                }
                field("Playback Entry No."; Rec."Playback Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Playback Entry No. field.';
                }
                field("Playback Recording ID"; Rec."Playback Recording ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Playback Recording ID field.';
                }
                field("Post as Shipment"; Rec."Post as Shipment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post as Shipment field.';
                }
                field("Posted Statement No."; Rec."Posted Statement No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Statement No. field.';
                }
                field("Posting Status"; Rec."Posting Status")
                {
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Status field.';
                }
                field("QR Code"; Rec."QR Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the QR Code field.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                }
                field("Refund Receipt No."; Rec."Refund Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refund Receipt No. field.';
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
                field(RestrictedFlag; Rec.RestrictedFlag)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Restricted Flag field.';
                }
                field("Retrieved from Receipt No."; Rec."Retrieved from Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Retrieved from Receipt No. field.';
                }
                field("Reverted Gross Amount"; Rec."Reverted Gross Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reverted Gross Amount field.';
                }
                field(Rounded; Rec.Rounded)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rounded field.';
                }
                field("Safe Code"; Rec."Safe Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Safe Code field.';
                }
                field("Safe Entry No."; Rec."Safe Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Safe Entry No. field.';
                }
                field("Sale Is Return Sale"; Rec."Sale Is Return Sale")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sale Is Return Sale field.';
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Type field.';
                }
                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to Contact No. field.';
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
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Type field.';
                }
                field("Split Number"; Rec."Split Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Split Number field.';
                }
                field("Staff ID"; Rec."Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff ID field.';
                }
                field("Starting Point Balance"; Rec."Starting Point Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Point Balance field.';
                }
                field("Statement Code"; Rec."Statement Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Statement Code field.';
                }
                field("Statement No."; Rec."Statement No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Statement No. field.';
                }
                field("Statement No. - NOT USED"; Rec."Statement No. - NOT USED")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Statement No. - NOT USED field.';
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
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Table No. field.';
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Area Code field.';
                }
                field("Tax Exemption No."; Rec."Tax Exemption No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Exemption No. field.';
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Liable field.';
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field("Time when Total Pressed"; Rec."Time when Total Pressed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time when Total Pressed field.';
                }
                field("Time when Trans. Closed"; Rec."Time when Trans. Closed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time when Trans. Closed field.';
                }
                field("To Account"; Rec."To Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Account field.';
                }
                field("Total Discount"; Rec."Total Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Discount field.';
                }
                field("Trans. Currency"; Rec."Trans. Currency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Currency field.';
                }
                field("Trans. Is Mixed Sale/Refund"; Rec."Trans. Is Mixed Sale/Refund")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Is Mixed Sale/Refund field.';
                }
                field("Trans. Sale/Pmt. Diff."; Rec."Trans. Sale/Pmt. Diff.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Sale/Pmt. Diff. field.';
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
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("VAT Bus.Posting Group"; Rec."VAT Bus.Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Bus.Posting Group field.';
                }
                field("WIC Transaction"; Rec."WIC Transaction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WIC Transaction field.';
                }
                field("Wrong Shift"; Rec."Wrong Shift")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Wrong Shift field.';
                }
                field("Y-Report ID"; Rec."Y-Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Y-Report ID field.';
                }
                field("Z-Report ID"; Rec."Z-Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Z-Report ID field.';
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
