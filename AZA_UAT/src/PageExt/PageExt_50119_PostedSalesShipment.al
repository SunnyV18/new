pageextension 50119 PostedSalesShipmentExt extends "Posted Sales Shipment"
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
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}