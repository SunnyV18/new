tableextension 50123 PostedCustOrderLineEx extends "LSC Posted Customer Order Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "POS Sales Associate"; Code[30]) { DataClassification = ToBeClassified; }
        // Add changes to table fields here

        field(50001; "LSCIN GST Place of Supply"; Enum "GST Dependency Type")
        {
            Caption = 'GST Place of Supply';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50002; "LSCIN GST Group Code"; Code[20])
        {
            Caption = 'GST Group Code';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "GST Group";
        }
        field(50003; "LSCIN GST Group Type"; Enum "GST Group Type")
        {
            Caption = 'GST Group Type';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(50004; "LSCIN HSN/SAC Code"; Code[10])
        {
            Caption = 'HSN/SAC Code';
            TableRelation = "HSN/SAC".Code WHERE("GST Group Code" = FIELD("LSCIN GST Group Code"));
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50005; "LSCIN Exempted"; Boolean)
        {
            Caption = 'Exempted';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50006; "LSCIN Price Inclusive of Tax"; boolean)
        {
            Caption = 'Price Inclusive of Tax';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50007; "LSCIN Unit Price Incl. of Tax"; Decimal)
        {
            Caption = 'Unit Price Incl. of Tax';
            DataClassification = EndUserIdentifiableInformation;
        }

        field(50008; "LSCIN GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50009; "POS Comment"; Text[100]) { DataClassification = ToBeClassified; }
    }

    var
        myInt: Integer;
}