pageextension 50112 StorePageExt extends "LSC Store Card"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Email id"; Rec."Email id")
            {
                ApplicationArea = all;
            }
            field(Email2; Rec.Email2)
            {
                ApplicationArea = all;
            }
            field("Dummy Location"; Rec."Dummy Location") { ApplicationArea = all; }
        }
        addafter("Item Nos.")
        {
            group("Aza No. Series")
            {
                field("Sales Posting No. Series"; Rec."Sales Posting No. Series") { ApplicationArea = all; }
                field("Sales Ret. Posting No. Series"; Rec."Sales Ret. Posting No. Series") { ApplicationArea = all; }
                field("Cust. Adv. Posting No. Series"; Rec."Cust. Adv. Posting No. Series") { ApplicationArea = all; }
                field("Cust. Order No. Series"; Rec."Cust. Order No. Series") { ApplicationArea = all; }
                field("Transfer Order No. Series"; Rec."Transfer Order No. Series") { ApplicationArea = all; }
                field("Purchase Order No. Series"; Rec."Purchase Order No. Series") { ApplicationArea = all; }
                field("Return Order No. Series"; Rec."Return Order No. Series") { ApplicationArea = all; }
                field("Posted Purchase Return Shipment"; Rec."Posted Purchase Return Shipment") { ApplicationArea = All; }
                field("Purchase Receipt No. Series"; Rec."Purchase Receipt No. Series") { ApplicationArea = all; }
                field("Transfer Shipment"; "Transfer Shipment") { ApplicationArea = all; }
                field("Transfer Recipt"; "Transfer Recipt") { ApplicationArea = all; }

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