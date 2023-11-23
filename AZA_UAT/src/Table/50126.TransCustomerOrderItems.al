table 50126 "Trans Customer Order Items"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Store No."; Code[10])
        {
            Caption = 'Store No.';
            TableRelation = "LSC Store";
        }
        field(2; "POS Terminal No."; Code[10])
        {
            Caption = 'POS Terminal No.';
            TableRelation = "LSC POS Terminal"."No.";
            ValidateTableRelation = false;
        }
        field(3; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            TableRelation = "LSC Transaction Header"."Transaction No." where("Store No." = field("Store No."), "POS Terminal No." = field("POS Terminal No."));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(11; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
        }
        field(14; "Barcode No."; Code[22])
        {
            Caption = 'Barcode No.';
            TableRelation = "LSC Barcodes"."Barcode No.";
            ValidateTableRelation = false;
        }
        field(15; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ValidateTableRelation = false;
        }

        field(16; Price; Decimal)
        {
            Caption = 'Price';
            DecimalPlaces = 2 : 2;
        }
        field(17; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(18; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure".Code;
        }
        field(19; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Designer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Designer Abbreviation"; Text[10])
        {
            Caption = 'Designer Abbreviation';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Store No.", "POS Terminal No.", "Transaction No.", "Line No.")
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