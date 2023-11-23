tableextension 50133 VendorExtention extends Vendor
{
    fields
    {
        field(50000; "Email to"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Email cc"; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Parent designer id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Parent designer name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Merchandiser name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Order merchandiser name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Contact name primary"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Email name primary"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Phone contact primary"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Contact primary job Title"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Contact name secondary"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "email contact secondary"; Text[260])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Phone contact secondary"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Contact job title secondary"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Reg address"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Reg address line1"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Reg address line2"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Reg city"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Reg state"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Reg country"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Reg country1"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Reg phone"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Reg email to"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Reg email cc"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Reg contact name primary"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Reg email contact primary"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Reg phone contact primary"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Reg contact primary job title"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Reg contact name secondary"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Reg phone contact secondary"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Reg email contact secondary"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Reg contact jobtitle secondary"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "Gst attachment"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "Gst registration date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Pan attachment"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "Cancelled cheque attachment"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "msme registered"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50037; "msme registration no"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50038; "msme certificate"; Code[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "msme registration date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Additional charge type"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Additional charge"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Po price type"; Text[50])//Nkp Change datatype integer to text suggest by sunny
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Declaration flag"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Signature name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Signature place"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Designation"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50047; "Date_added"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50048; "Added by"; text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50049; "Date modified"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Modified by"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50051; "Status"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "Return policy"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50053; "Is deleted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50054; "Classification tag"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50055; "Is show sale"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50056; "Seouri"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50057; "Show cat section"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50058; "Show cat section data"; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(50059; "Seo content"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50060; Description; Text[260])
        {
            DataClassification = ToBeClassified;
        }
        field(50061; "Sale text"; Text[100]) { DataClassification = ToBeClassified; }
        field(50062; "Banner image"; Text[100]) { DataClassification = ToBeClassified; }
        field(50063; "Is show counter"; Boolean) { DataClassification = ToBeClassified; }
        field(50064; "Counter start date"; Date) { DataClassification = ToBeClassified; }
        field(50065; "Counter end date"; Date) { DataClassification = ToBeClassified; }
        field(50066; "Is show cod"; Boolean) { DataClassification = ToBeClassified; }
        field(50067; "Address 3"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50068; Type; Enum "Designer Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50069; "merchant_status"; Code[20]) { DataClassification = ToBeClassified; }
        field(50070; "merchant_approved_by"; Text[75]) { DataClassification = ToBeClassified; }
        field(50071; "finance_status"; Code[20]) { DataClassification = ToBeClassified; }
        field(50072; "finance_approved_by"; Text[75]) { DataClassification = ToBeClassified; }
        field(50073; "final_approved_status"; Code[20]) { DataClassification = ToBeClassified; }
        field(50074; "Designer code"; Code[50]) { DataClassification = ToBeClassified; }
        field(50075; companyName; Code[250]) { DataClassification = ToBeClassified; }
        field(50100; "Designer Abbreviation"; Text[10])
        {
            Caption = 'Designer Abbreviation';
            DataClassification = ToBeClassified;
        }
        field(50102; "Vendor Company Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}