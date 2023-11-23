page 50149 "LSC Customer Order Header"
{
    Caption = 'LSC Customer Order Header Store';
    PageType = Worksheet;
    SourceTable = "LSC Customer Order Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field("Balance Amount"; Rec."Balance Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance Amount field.';
                }
                field("CO Source Type"; Rec."CO Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Type field.';
                }
                field("Canceled Amount"; Rec."Canceled Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Canceled Amount field.';
                }
                field(CancelledOrder; Rec.CancelledOrder)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CancelledOrder field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field("Click and Collect Order"; Rec."Click and Collect Order")
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
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the County field.';
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created field.';
                }
                field("Created at Store"; Rec."Created at Store")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created at Store field.';
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
                field("Daytime Phone No."; Rec."Daytime Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Daytime Phone No. field.';
                }
                field("Deposit Payment"; Rec."Deposit Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deposit Payment field.';
                }
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document ID field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("External ID"; Rec."External ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External ID field.';
                }
                field("Finalised Amount"; Rec."Finalised Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finalised Amount field.';
                }
                field("Finalised Amount LCY"; Rec."Finalised Amount LCY")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finalised Amount LCY field.';
                }
                field("GST Customer Type"; Rec."GST Customer Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Customer Type field.';
                }
                field("House/Apartment No."; Rec."House/Apartment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the House/Apartment No. field.';
                }
                field("Inventory Transfer"; Rec."Inventory Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inventory Transfer field.';
                }
                field("Lines Collected"; Rec."Lines Collected")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lines Collected field.';
                }
                field("Lines Rejected"; Rec."Lines Rejected")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lines Rejected field.';
                }
                field("Lines Shortage"; Rec."Lines Shortage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lines Shortage field.';
                }
                field("Lines to Collect"; Rec."Lines to Collect")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lines to Collect field.';
                }
                field("Lines to Pick"; Rec."Lines to Pick")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lines to Pick field.';
                }
                field("Lines to Receive"; Rec."Lines to Receive")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Canceled field.';
                }
                field("Member Card No."; Rec."Member Card No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member Card No. field.';
                }
                field("Member Contact No."; Rec."Member Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member Contact No. field.';
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the On Hold field.';
                }
                field("Order Net Amount"; Rec."Order Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Net Amount field.';
                }
                field("Order VAT Amount"; Rec."Order VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order VAT Amount field.';
                }
                field("Original Document ID"; Rec."Original Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Document ID field.';
                }
                field("PO Posted Invoices"; Rec."PO Posted Invoices")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO Posted Invoices field.';
                }
                field("PO Posted Receipts"; Rec."PO Posted Receipts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO Posted Receipts field.';
                }
                field("Partial Payment"; Rec."Partial Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Partial Payment field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field("Pre Approved Amount"; Rec."Pre Approved Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pre Approved Amount field.';
                }
                field("Pre Approved Amount LCY"; Rec."Pre Approved Amount LCY")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pre Approved Amount LCY field.';
                }
                field("Processing Status"; Rec."Processing Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processing Status field.';
                }
                field("Purchase Orders"; Rec."Purchase Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Orders field.';
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Delivery Date field.';
                }
                field("Rounding Amount"; Rec."Rounding Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rounding Amount field.';
                }
                field("SO Posted Invoices"; Rec."SO Posted Invoices")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SO Posted Invoices field.';
                }
                field("SO Posted Shipments"; Rec."SO Posted Shipments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SO Posted Shipments field.';
                }
                field("Sales Orders"; Rec."Sales Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Orders field.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salesperson Code field.';
                }
                field("Scan Pay Go"; Rec."Scan Pay Go")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ScanPayGo Order field.';
                }
                field("Search Posted CO (Int)"; Rec."Search Posted CO (Int)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Search Posted CO (Int) field.';
                }
                field("Ship Order"; Rec."Ship Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Order field.';
                }
                field("Ship Order POS Flag"; Rec."Ship Order POS Flag")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Order POS Flag field.';
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Address field.';
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Address 2 field.';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to City field.';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Country/Region Code field.';
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to County field.';
                }
                field("Ship-to Email"; Rec."Ship-to Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Email field.';
                }
                field("Ship-to House/Apartment No."; Rec."Ship-to House/Apartment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to House/Apartment No. field.';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Name field.';
                }
                field("Ship-to Phone No."; Rec."Ship-to Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Phone No. field.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Post Code field.';
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
                field("Show as posted (Int)"; Rec."Show as posted (Int)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show as posted (Int) field.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Type field.';
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
                field("Status (Int)"; Rec."Status (Int)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status (Int) field.';
                }
                field("Status Info"; Rec."Status Info")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Info field.';
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
                field("TO Posted Receipts"; Rec."TO Posted Receipts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TO Posted Receipts field.';
                }
                field("TO Posted Shipments"; Rec."TO Posted Shipments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TO Posted Shipments field.';
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
                field("Terminal No."; Rec."Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Terminal No. field.';
                }
                field("Territory Code"; Rec."Territory Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Territory Code field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field("Total Amount (Int)"; Rec."Total Amount (Int)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount (Int) field.';
                }
                field("Total Delivered Amount"; Rec."Total Delivered Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Delivered Amount field.';
                }
                field("Total Delivered Net Amount"; Rec."Total Delivered Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Delivered Net Amount field.';
                }
                field("Total Discount"; Rec."Total Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Discount field.';
                }
                field("Total Discount (Int)"; Rec."Total Discount (Int)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Discount (Int) field.';
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field("Total Payment"; Rec."Total Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Payment field.';
                }
                field("Total Payment (Int)"; Rec."Total Payment (Int)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Payment (Int) field.';
                }
                field("Total Pre Authorization"; Rec."Total Pre Authorization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Pre Authorization field.';
                }
                field("Total Pre Authorization (Int)"; Rec."Total Pre Authorization (Int)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Pre Authorization (Int) field.';
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Quantity field.';
                }
                field("Total Refund"; Rec."Total Refund")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Refund field.';
                }
                field("Total Remaining"; Rec."Total Remaining")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Remaining field.';
                }
                field(Transactions; Rec.Transactions)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transactions field.';
                }
                field("Transfer Orders"; Rec."Transfer Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Orders field.';
                }
                field("Vendor Sourcing"; Rec."Vendor Sourcing")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Sourcing field.';
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
