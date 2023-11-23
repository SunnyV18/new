table 50112 "Item Transfer Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "no"; code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(2; "Line No"; Integer)

        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; "Document No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "item transfer Header"."Documnet No.";
        }
        field(4; "Type of Item"; code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if item.get("Type of Item") then begin
                    Description := Item.Description;
                end;
            end;
        }
        field(5; Description; text[100])
        {
            DataClassification = ToBeClassified;
            //TableRelation = item.Description where("No." = field("Type of Item"));

        }
        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(pk; "Document No.", "Line No")
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