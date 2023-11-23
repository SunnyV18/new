pageextension 50118 SalesOrderExt extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field(Dimensions; Rec.Dimensions)
            {
                ApplicationArea = all;
            }
            field("Gross Wt."; Rec."Gross Wt.")
            {
                ApplicationArea = all;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = all;
            }
            field("Country of Origin"; Rec."Country of Origin")
            {
                ApplicationArea = all;
            }
            field("Country of Final Destination"; Rec."Country of Final Destination")
            {
                ApplicationArea = all;
            }
            field("IGST Payment Status"; Rec."IGST Payment Status")
            {
                ApplicationArea = all;
            }
            field("Store No."; Rec."Store No.") { ApplicationArea = all; }
            field("Shipping No."; "Shipping No.") { ApplicationArea = all; }
            field("Posting No."; "Posting No.") { ApplicationArea = all; }
        }
        addafter("Applies-to Doc. No.")
        {
            field("Promo Code"; Rec."Promo Code")
            {
                ApplicationArea = all;
            }
            field("Promo Discount"; Rec."Promo Discount")
            {
                ApplicationArea = all;
            }
        }
        addafter("Bill-to City")
        {
            field("Billing Locality"; Rec."Billing Locality") { ApplicationArea = all; }
            field("Billing State"; Rec."Billing State") { ApplicationArea = all; }
            field("Billing Email"; Rec."Billing Email") { ApplicationArea = all; }
            field("Billing Landmark"; Rec."Billing Landmark") { ApplicationArea = all; }

        }
        addafter("Ship-to City")
        {
            field("Shipping Locality"; Rec."Shipping Locality") { ApplicationArea = all; }
            field("Shipping State"; Rec."Shipping State") { ApplicationArea = all; }
            field("Shipping Landmark"; Rec."Shipping Landmark") { ApplicationArea = all; }
        }
        addafter("Invoice Details")
        {
            group(AzaAttributes)
            {
                field("Payment Id"; Rec."Payment Id") { ApplicationArea = all; }
                field("Transaction Id"; Rec."Transaction Id") { ApplicationArea = all; }
                field("Payer Id"; Rec."Payer Id") { ApplicationArea = all; }
                field("Payment Method"; Rec."Payment Method") { ApplicationArea = all; }
                field("Redeem Points"; Rec."Redeem Points") { ApplicationArea = all; }
                field("Redeem Points Credit"; Rec."Redeem Points Credit") { ApplicationArea = all; }
                field("Shipping Amount"; Rec."Shipping Amount") { ApplicationArea = all; }
                field("Duties & Taxes"; Rec."Duties & Taxes") { ApplicationArea = all; }
                field("Total Price"; Rec."Total Price") { ApplicationArea = all; }
                field("Date Added"; Rec."Date Added") { ApplicationArea = all; }
                field("Date Modified"; Rec."Date Modified") { ApplicationArea = all; }
                field("Order Status"; Rec."Order Status") { ApplicationArea = all; }
                field("Payment Status"; Rec."Payment Status") { ApplicationArea = all; }
                field(Currency; Rec.Currency) { ApplicationArea = all; }
                field("Currency Rate"; Rec."Currency Rate") { ApplicationArea = all; }
                field("State Tax Type"; Rec."State Tax Type") { ApplicationArea = all; }
                field("Pan Number"; rec."Pan Number") { ApplicationArea = all; }
                // field("Gift Message"; Rec."Gift Message") { ApplicationArea = all; }
                // field("Is Special Order"; Rec."Is Special Order") { ApplicationArea = all; }
                // field("Special Message"; Rec."Special Message") { ApplicationArea = all; }
                // field("COD Confirm"; Rec."COD Confirm") { ApplicationArea = all; }
                field("Charge Back Remark"; rec."Charge Back Remark") { ApplicationArea = all; }
                field("Charge Back Date"; Rec."Charge Back Date") { ApplicationArea = all; }
                field("Loyalty Point"; Rec."Loyalty Point") { ApplicationArea = all; }
                field("Loyalty Percent"; Rec."Loyalty Percent") { ApplicationArea = all; }
                field("Loyalty Unit"; Rec."Loyalty Unit") { ApplicationArea = all; }
                field("Redeem Loyalty points"; Rec."Redeem Loyalty points") { ApplicationArea = all; }
                field("New Shipping Address"; Rec."New Shipping Address") { ApplicationArea = all; }
                field("Is Loyalty Free Ship"; Rec."Is Loyalty Free Ship") { ApplicationArea = all; }
                field("Current loyalty Tier"; Rec."Current loyalty Tier") { ApplicationArea = all; }

            }
        }
        addfirst(factboxes)
        {
            part(Picture; "Item Picture")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
                Provider = SalesLines;

            }
            part(Picture2; "Item Picture 2")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
                Provider = SalesLines;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(AttachAsPDF)
        {
            action(New_Sales_Order)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Order New';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                //PromotedCategory = Category6;
                PromotedCategory = Category11;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PurchaseHeader: Record "Sales Header";
                begin
                    PurchaseHeader := Rec;
                    PurchaseHeader.SetRecFilter();
                    Report.RunModal(Report::New_Sales_Order, true, true, PurchaseHeader);

                end;
            }
        }
    }

    var
        myInt: Integer;
}