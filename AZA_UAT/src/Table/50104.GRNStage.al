table 50104 GRN_Staging
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            DataClassification = ToBeClassified;
            //AutoIncrement = true;
        }
        field(2; po_number; Code[30]) { DataClassification = ToBeClassified; }
        field(3; date_added; text[40]) { DataClassification = ToBeClassified; }
        field(4; date_modified; Date) { DataClassification = ToBeClassified; }
        field(5; modified_by; code[100]) { DataClassification = ToBeClassified; }
        field(6; added_by; code[100]) { DataClassification = ToBeClassified; }
        field(7; fc_location; Code[10]) { DataClassification = ToBeClassified; }
        // field(8; po_detail_id; Integer) { DataClassification = ToBeClassified; }
        field(8; po_detail_id; Code[30]) { DataClassification = ToBeClassified; }
        field(9; quantity_received; Decimal) { dataclassification = tobeclassified; DecimalPlaces = 11; }
        field(11; qc_status; code[10]) { }
        field(12; action_status; Code[10]) { ObsoleteState = Removed; ObsoleteReason = 'Array to be used'; }
        field(13; "Record Status"; Option)
        {
            OptionMembers = " ","Processed","Error";
            DataClassification = ToBeClassified;
        }
        field(14; "No. of Errors"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(ErrorLogPO where("Source Entry No." = field("Entry No.")));
        }
        field(15; "Error Text"; Text[1000])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(ErrorLogPO."Error Remarks" where("Source Entry No." = field("Entry No.")));
        }
        field(16; "Entry No."; integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(17; barcode; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Error Date"; Date)
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
        key(Key2; id)
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