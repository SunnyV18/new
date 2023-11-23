table 50118 Action_Status_Sales
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }

        field(2; "Action ID"; Integer) { DataClassification = ToBeClassified; }
        field(3; "Date added"; DateTime) { DataClassification = ToBeClassified; }
        field(4; "SO_ID"; Integer)
        {
            DataClassification = ToBeClassified;
            // TableRelation = GRN_Staging.SystemId;
        }
        field(7; SO_Detail_ID; Integer) { DataClassification = ToBeClassified; }
        field(5; refID; Guid)
        {
            TableRelation = SalesOrderDtls_Staging.SystemId;
        }
        field(6; "Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "hash"; Text[250])
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
        key(Key2; SO_ID, SO_Detail_ID, "Action ID")
        {
            // Clustered = true;
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