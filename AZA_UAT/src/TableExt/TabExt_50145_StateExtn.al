tableextension 50145 StateExtn extends State
{
    fields
    {
        field(50100; "User Id"; Text[50])
        {
            Caption = 'User Id';
            DataClassification = ToBeClassified;
        }
        field(50101; Password; Text[30])
        {
            Caption = 'Password';
            DataClassification = ToBeClassified;
        }
    }
}
