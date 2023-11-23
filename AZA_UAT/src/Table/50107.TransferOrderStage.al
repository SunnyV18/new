table 50107 TransferOrderStage
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; transfer_order_id; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; transfer_from_fc; Code[100]) { DataClassification = ToBeClassified; }
        field(3; transfer_to_fc; Code[100]) { DataClassification = ToBeClassified; }
        field(4; posting_date; DateTime) { DataClassification = ToBeClassified; }
        field(5; barcode; Code[50]) { DataClassification = ToBeClassified; }
        field(6; order_id; Integer) { DataClassification = ToBeClassified; }
        field(7; order_detail_id; Integer) { DataClassification = ToBeClassified; }
        field(8; transfer_order_status; Text[35]) { DataClassification = ToBeClassified; }
        field(9; date_added; DateTime) { DataClassification = ToBeClassified; }
        field(10; added_by; Code[50]) { DataClassification = ToBeClassified; }
        field(11; date_modified; DateTime) { DataClassification = ToBeClassified; }
        field(12; modified_by; Code[50]) { DataClassification = ToBeClassified; }
        field(13; Record_Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Created,Updated,Error;
        }
        field(14; "No. of Errors"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(ErrorCapture where("Process Type" = filter("Transfer Order Creation" | "Transfer Order Updation"), "Source Entry No." = field("Entry No.")));
        }
        field(15; "Error Text"; Text[1000])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(ErrorCapture."Error Remarks" where("Process Type" = filter("Transfer Order Creation" | "Transfer Order Updation"), "Source Entry No." = field("Entry No.")));
        }
        field(16; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(17; "Error Date"; Date)
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
        key(Key2; transfer_order_id)
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