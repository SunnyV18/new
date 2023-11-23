pageextension 50123 PostedSalesReturnReceiptExt extends "Posted Return Receipt"
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
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        myInt: Integer;
}