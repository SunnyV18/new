pageextension 50174 VendorExt extends "Vendor Card"
{
    layout
    {
        addafter("E-Mail")
        {
            field("Email to"; Rec."Email to")
            {
                ApplicationArea = all;
            }
            field("Email cc"; Rec."Email cc")
            {
                ApplicationArea = all;
            }

        }
        addafter("Address 2")
        {
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = all;
            }
        }
        addafter("LSC ASN")
        {
            group(AzaAttributes)
            {
                field("Parent designer id"; "Parent designer id") { ApplicationArea = all; }
                field("Parent designer name"; "Parent designer name") { ApplicationArea = all; }
                field("Merchandiser name"; "Merchandiser name") { ApplicationArea = all; }
                field(Type; Type) { ApplicationArea = all; }
                field("Contact name primary"; "Contact name primary") { ApplicationArea = all; }
                field("Email name primary"; "Email name primary") { ApplicationArea = all; }
                field("Phone contact primary"; "Phone contact primary") { ApplicationArea = all; }
                field("Phone contact secondary"; "Phone contact secondary") { ApplicationArea = all; }
                field("Contact primary job Title"; "Contact primary job Title") { ApplicationArea = all; }
                field("Contact job title secondary"; "Contact job title secondary") { ApplicationArea = all; }
                field("Contact name secondary"; "Contact name secondary") { ApplicationArea = all; }
                field("email contact secondary"; "email contact secondary") { ApplicationArea = all; }
                field("Reg address"; "Reg address") { ApplicationArea = all; }
                field("Reg address line1"; "Reg address line1") { ApplicationArea = all; }
                field("Reg address line2"; "Reg address line2") { ApplicationArea = all; }
                field("Reg city"; "Reg city") { ApplicationArea = all; }
                field("Reg state"; "Reg state") { ApplicationArea = all; }
                field("Reg country"; "Reg country") { ApplicationArea = all; }
                field("Reg country1"; "Reg country1") { ApplicationArea = all; }
                field("Reg phone"; "Reg phone") { ApplicationArea = all; }
                field("Reg email to"; "Reg email to") { ApplicationArea = all; }
                field("Reg email cc"; "Reg email cc") { ApplicationArea = all; }
                field("Reg contact name primary"; "Reg contact name primary") { ApplicationArea = all; }
                field("Reg contact name secondary"; "Reg contact name secondary") { ApplicationArea = all; }
                field("Reg email contact primary"; "Reg email contact primary") { ApplicationArea = all; }
                field("Reg email contact secondary"; "Reg email contact secondary") { ApplicationArea = all; }
                field("Reg contact primary job title"; "Reg contact primary job title") { ApplicationArea = all; }
                field("Reg contact jobtitle secondary"; "Reg contact jobtitle secondary") { ApplicationArea = all; }
                field("Gst attachment"; "Gst attachment") { ApplicationArea = all; }
                field("Gst registration date"; "Gst registration date") { ApplicationArea = all; }
                field("Pan attachment"; "Pan attachment") { ApplicationArea = all; }
                field("Cancelled cheque attachment"; "Cancelled cheque attachment") { ApplicationArea = all; }
                field("msme registered"; "msme registered") { ApplicationArea = all; }
                field("msme certificate"; "msme certificate") { ApplicationArea = all; }
                field("msme registration no"; "msme registration no") { ApplicationArea = all; }
                field("msme registration date"; "msme registration date") { ApplicationArea = all; }
                field("Additional charge"; "Additional charge") { ApplicationArea = all; }
                field("Additional charge type"; "Additional charge type") { ApplicationArea = all; }
                field("Po price type"; "Po price type") { ApplicationArea = all; }
                field("Declaration flag"; "Declaration flag") { ApplicationArea = all; }
                field("Signature name"; "Signature name") { ApplicationArea = all; }
                field("Signature place"; "Signature place") { ApplicationArea = all; }
                field(Designation; Designation) { ApplicationArea = all; }
                field(Date_added; Date_added) { ApplicationArea = all; }
                field("Added by"; "Added by") { ApplicationArea = all; }
                field("Date modified"; "Date modified") { ApplicationArea = all; }
                field("Modified by"; "Modified by") { ApplicationArea = all; }
                field(Status; Status) { ApplicationArea = all; }
                field("Return policy"; "Return policy") { ApplicationArea = all; }
                field("Classification tag"; "Classification tag") { ApplicationArea = all; }
                field("Is deleted"; "Is deleted") { ApplicationArea = all; }
                field("Is show sale"; "Is show sale") { ApplicationArea = all; }
                field(Seouri; Seouri) { ApplicationArea = all; }
                field("Show cat section"; "Show cat section") { ApplicationArea = all; }
                field("Show cat section data"; "Show cat section data") { ApplicationArea = all; }
                field("Seo content"; "Seo content") { ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; }
                field("Sale text"; "Sale text") { ApplicationArea = all; }
                field("Banner image"; "Banner image") { ApplicationArea = all; }
                field("Is show counter"; "Is show counter") { ApplicationArea = all; }
                field("Counter start date"; "Counter start date") { ApplicationArea = all; }
                field("Counter end date"; "Counter end date") { ApplicationArea = all; }
                field("Is show cod"; "Is show cod") { ApplicationArea = all; }
                field(merchant_status; merchant_status) { ApplicationArea = all; }
                field(merchant_approved_by; merchant_approved_by) { ApplicationArea = all; }
                field(finance_status; finance_status) { ApplicationArea = all; }
                field(final_approved_status; final_approved_status) { ApplicationArea = all; }
                field(finance_approved_by; finance_approved_by) { ApplicationArea = all; }
                field("Designer code"; "Designer code") { ApplicationArea = all; }
                field("Vendor Company Name"; "Vendor Company Name") { ApplicationArea = All; }
                field(companyName; Rec.companyName) { ApplicationArea = all; }
            }
        }
        addafter(Transporter)
        {
            field("Designer Abbreviation"; "Designer Abbreviation") { ApplicationArea = all; }
        }
    }

    actions
    {
        addafter(PayVendor)
        {
            action("Approve Vendor")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                begin
                    if Confirm('Do you want to approve the vendor ?', false) then begin
                        Rec.validate(Blocked, Rec.Blocked::" ");
                        Rec.Modify();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}