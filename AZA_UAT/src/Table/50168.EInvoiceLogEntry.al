table 50168 "Log Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Invoice,CrMemo,TransferShipment,PurchCrMemo';
            OptionMembers = Invoice,CrMemo,TransferShipment,PurchCrMemo;
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Message; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Message1; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Message2; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Message3; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "IRN No"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Field Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Error Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure GetErrorMessage(): Text
    begin
        EXIT(Message + Message1 + Message2 + Message3);
    end;
}

