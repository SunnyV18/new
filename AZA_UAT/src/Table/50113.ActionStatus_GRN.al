table 50113 ActionStatus_GRN
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
        // field(4; "PO_ID"; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     // TableRelation = GRN_Staging.SystemId;
        // }
        field(4; PO_ID; Code[30]) { DataClassification = ToBeClassified; }
        field(5; refID; Guid)
        {
            TableRelation = GRN_Staging.SystemId;
        }
        field(6; "Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; BarCode; Code[20])//Naveen
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
        // key(Key1; PO_ID, "Action ID", BarCode, "Entry No.")
        // {
        //     Clustered = true;
        // }

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