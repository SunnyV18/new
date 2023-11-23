table 50102 CategorySizeStaging
{
    DataClassification = ToBeClassified;
    Caption = 'Aza category size staging';

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; Type; Text[15])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Name; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Sub Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Sub Category Name"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Sub Sub Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(8; "Sub Sub Category Name"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(9; RecProcessed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Record Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Created","Error";
        }
        field(11; "No. of Errors"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(ErrorCapture where("Process Type" = filter("Category Creation"), "Source Entry No." = field("Entry No")));
        }
        field(12; "Error Text"; Text[1000])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(ErrorCapture."Error Remarks" where("Process Type" = filter("Category Creation"), "Source Entry No." = field("Entry No")));
        }
    }

    keys
    {
        key(Key1; "Entry No", Type, Code, "Sub Category Code", "Sub Sub Category Code")
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