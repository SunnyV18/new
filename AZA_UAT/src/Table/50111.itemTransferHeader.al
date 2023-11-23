table 50111 "item transfer Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Documnet No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Transfer from loaction Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer from Location';
            TableRelation = Location.Code;
        }
        field(3; "Transfer to loaction Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer to Location';
            TableRelation = Location.Code;
        }
        field(4; Status; Enum Status_itemtransfer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Created By"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Created DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(pk; "Documnet No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;


    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created DateTime" := CurrentDateTime;
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