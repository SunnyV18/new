table 50121 "Shipment Action Hash"
{
    Caption = 'Shipment Action Hash';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "So No."; Code[30])
        {
            Caption = 'So No.';
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
        field(5; "SO Detail ID"; Integer)
        {
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
