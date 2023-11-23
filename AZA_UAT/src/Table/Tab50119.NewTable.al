table 50119 "New Table"
{
    Caption = 'New Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Caption = 'Document No';
        }
        field(2; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
    }
    keys
    {
        key(PK; "Document No")
        {
            Clustered = true;
        }
    }
}
