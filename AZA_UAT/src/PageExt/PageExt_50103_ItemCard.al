pageextension 50103 Item_Attributes_Aza extends "Item Card"
{
    layout
    {
        addafter(ItemPicture)
        {
            part(Picture2; "Item Picture 2")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
            }
        }
        addafter(GTIN)
        {
            field("PO type"; rec."PO type")
            {
                ApplicationArea = all;
            }
            field("Inclusive of GST"; "Inclusive of GST")
            {
                ApplicationArea = all;
            }
        }

        addafter(ItemTracking)
        {
            group(AzaAttributes)
            {
                field(tagCode; Rec.tagCode) { ApplicationArea = all; }
                field("PO Created"; Rec."PO Created") { ApplicationArea = all; }
                field(azaCode; Rec.azaCode) { ApplicationArea = all; }
                field(subSubCategoryCode; Rec.subSubCategoryCode) { ApplicationArea = all; }
                field(designerID; Rec.designerID) { ApplicationArea = all; }
                field(componentsNo; Rec.tagCode) { ApplicationArea = all; }
                field(productThumbImg; Rec.tagCode) { ApplicationArea = all; }
                field(addedBy; Rec.tagCode) { ApplicationArea = all; }
                field(dateAdded; Rec.dateAdded) { ApplicationArea = all; }
                field(status; Rec.status) { ApplicationArea = all; }
                field(modifiedBy; Rec.modifiedBy) { ApplicationArea = all; }
                field(merchandiserName; Rec.merchandiserName) { ApplicationArea = all; }
                field(image2; Rec.tagCode) { ApplicationArea = all; }
                field(image3; Rec.image3) { ApplicationArea = all; }
                field(image4; Rec.image4) { ApplicationArea = all; }
                field(image5; Rec.image5) { ApplicationArea = all; }
                field(image6; Rec.image6) { ApplicationArea = all; }
                field(image7; Rec.image7) { ApplicationArea = all; }
                field(image8; Rec.image8) { ApplicationArea = all; }
                field(image9; Rec.image9) { ApplicationArea = all; }
                field(image10; Rec.image10) { ApplicationArea = all; }
                field(sizeName; Rec.sizeName) { ApplicationArea = all; }
                field(colorName; Rec.colorName) { ApplicationArea = all; }
                field(discountPercent; Rec.discountPercent) { ApplicationArea = all; }
                field(discountPercentByDesg; Rec.discountPercentByDesg) { ApplicationArea = all; }
                field(discountPercentByAza; Rec.discountPercentByAza) { ApplicationArea = all; }
                field(filterPrice; Rec.filterPrice) { ApplicationArea = all; }
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        addfirst(Approval)
        {
            action(OnLoyCall)
            {
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Call Loyalty Deduct API';
                trigger OnAction()
                var
                    recItem: Record Item;
                    CULoyAPI: Codeunit "Loyalty API";
                begin
                    CULoyAPI.DeductLoyaltyPoints(13, '9560969196', 25);

                end;
            }
            action(OnLoyAdd)
            {
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Call Loyalty Add API';
                trigger OnAction()
                var
                    CULoyAPI: Codeunit "Loyalty API";
                begin
                    CULoyAPI.AddLoyPoints(12, '9560969196', '122115', 512, '2022-08-24');

                end;
            }
            action(OnLoyGet)
            {
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Call Loyalty GET API';
                trigger OnAction()
                var
                    CULoyAPI: Codeunit "Loyalty API";
                begin
                    CULoyAPI.GetLoyPoints('9560969196');

                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}