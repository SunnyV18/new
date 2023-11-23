table 50125 "POS Customer Order Item"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(11; "Store No."; Code[10])
        {
            Caption = 'Store No.';
            TableRelation = "LSC Store";
        }
        field(12; "POS Terminal No."; Code[10])
        {
            Caption = 'POS Terminal No.';
            TableRelation = "LSC POS Terminal"."No.";
            ValidateTableRelation = false;
        }
        field(13; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            TableRelation = "LSC Transaction Header"."Transaction No." where("Store No." = field("Store No."), "POS Terminal No." = field("POS Terminal No."));
        }

        field(14; "Barcode No."; Code[22])
        {
            Caption = 'Barcode No.';
            TableRelation = "LSC Barcodes"."Barcode No.";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                Barcodes: Record "LSC Barcodes";
                Item: Record Item;
                POSTransaction: Record "LSC POS Transaction";

            begin
                IF POSTransaction.Get("Receipt No.") then;
                IF "Barcode No." = '' then
                    exit;
                IF Barcodes.Get("Barcode No.") then begin
                    Item.Get(Barcodes."Item No.");
                end else begin
                    Item.Get("Barcode No.");
                end;
                "Item No." := Item."No.";
                Price := Item."Unit Price";
                "Designer Name" := Item."Vendor Name";
                "Designer Abbreviation" := Item."Vendor Abbreviation";
                Quantity := 1;
                "Unit of Measure" := Item."Base Unit of Measure";
                "Net Amount" := Quantity * Price;
                "Store No." := POSTransaction."Store No.";
                "POS Terminal No." := POSTransaction."POS Terminal No.";
            end;
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
        key(Key1; "Receipt No.", "Line No.")
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