table 50169 "Change Associate- Tendor HO"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction Type"; option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"Tax Invoice","Customer Order";
        }
        field(2; "Document Id"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Old Staff"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Staff";
        }
        field(4; "New Staff"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Staff";
        }
        field(5; "Old Tender"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Tender Type".Code;
        }
        field(6; "New Tender"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Tender Type".Code;
        }
    }

    keys
    {
        key(Key1; "Transaction Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}