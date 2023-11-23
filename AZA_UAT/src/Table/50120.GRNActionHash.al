table 50120 "GRN Action Hash"
{
    Caption = 'GRN Action Hash';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "PO No."; Code[30])
        {
            Caption = 'Po Number';
            DataClassification = ToBeClassified;
        }
        field(2; "Action ID"; Integer)
        {
            Caption = 'Action ID';
            DataClassification = ToBeClassified;
        }
        field(3; Barcode; Code[30])
        {
            Caption = 'Barcode';
            DataClassification = ToBeClassified;
        }
        field(4; hash; Text[250])
        {
            Caption = 'hash';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; hash)
        {
            Clustered = true;
        }
    }
}
