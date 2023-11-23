table 50117 "GST Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Category; code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Division";
        }
        field(2; "Subcategory 1"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(3; "Subcategory 2"; Code[30])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "LSC Retail Product Group";
            TableRelation = IF ("Subcategory 1" = FILTER(<> '')) "LSC Retail Product Group".Code WHERE("Item Category Code" = FIELD("Subcategory 1"))
            ELSE
            "LSC Retail Product Group".Code;
            ValidateTableRelation = false;

        }
        field(4; "Material Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "GST Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "GST Group";
        }
        field(6; "HSN Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HSN/SAC".Code;
        }
        field(7; "From Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "To Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Entry No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Fabric_Type"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // key(Key1; "Entry No.")
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Category, "Subcategory 1", "Subcategory 2", Fabric_Type) { }
        key(Key3; Category, "Subcategory 1", Fabric_Type) { }
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