table 50106 ColorSizeMaster
{
    DataClassification = ToBeClassified;
    Caption = 'Aza Color Size master';

    fields
    {
        field(1; Type; Option)
        {
            OptionMembers = Size,Color;
            OptionCaption = 'Size,Color';
            DataClassification = ToBeClassified;

        }
        field(2; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Type, Code)
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