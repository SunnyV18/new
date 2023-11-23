pageextension 50171 MyExtension extends "LSC Retail Setup"
{
    layout
    {
        modify(General)
        {
            Editable = Editfield;
        }
        modify(Posting)
        {
            Editable = Editfield;

        }
        modify(Labels)
        {
            Editable = Editfield;

        }
        modify(Other)
        {

            Editable = Editfield;
        }
        modify(Discounts)
        {
            Editable = Editfield;

        }
        modify(Version)
        {
            Editable = Editfield;

        }
        modify("Sales History")
        {
            Editable = Editfield;
        }
        //SK++
        addafter("Suppress Search Index. Build.")
        {
            field("Allow Manual Blocking"; Rec."Allow Manual Blocking")
            {
                ApplicationArea = All;
            }
        }
        //SK--
        addafter(General)
        {
            group("API Setup")
            {
                field("Sales API"; Rec."Sales API") { ApplicationArea = all; Editable = Editfield; }
                field("Sales Return API"; Rec."Sales Return API") { ApplicationArea = all; Editable = Editfield; }
                field("Transfer Order API"; Rec."Transfer Order API") { ApplicationArea = all; Editable = Editfield; }
                field("Loyalty Points Add"; Rec."Loyalty Points Add") { ApplicationArea = all; Editable = Editfield; }
                field("Loyalty Points Deduct"; Rec."Loyalty Points Deduct") { ApplicationArea = all; Editable = Editfield; }
                field("Loyalty Points Get"; Rec."Loyalty Points Get") { ApplicationArea = all; Editable = Editfield; }
                field("Enable SMS Integration"; Rec."Enable SMS Integration") { ApplicationArea = all; Editable = Editfield; }
                field("API Token"; Rec."API Token") { ApplicationArea = all; Editable = Editfield; }
                field("Enable Mail Setup"; Rec."Enable Mail Setup") { ApplicationArea = all; Editable = Editfield; }
                field("Invoice Reference API"; Rec."Invoice Reference API") { ApplicationArea = all; Editable = Editfield; }
                field("S3 Bucket Name"; Rec."S3 Bucket Name") { ApplicationArea = all; Editable = Editfield; }
                field("Sales Invoice Directory"; Rec."Sales Invoice Directory") { ApplicationArea = all; Editable = Editfield; }
                field("Store PUT API"; "Store PUT API") { ApplicationArea = all; }

            }

        }

        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
        retailuser: Record "LSC Retail User";

    begin
        Editfield := false;
        if retailuser.Get(UserId) then begin
            if retailuser.Adminstrator = true then
                Editfield := true;

        end;
    end;

    var
        myInt: Integer;
        Editfield: Boolean;

}