table 50105 ErrorCapture
{
    DataClassification = ToBeClassified;
    DrillDownPageId = ErrorCapture;
    LookupPageId = ErrorCapture;
    fields
    {
        field(1; "Sr. No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; Item_code; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item Code';

        }
        field(3; DocumentNum; Code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Error Remarks"; Text[1000])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Error DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Process Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Item Creation","PO Creation","Vendor Creation","Customer Creation","GRN Processing","SO Updation","SO Creation","Category Creation","Item Updation","RTV Creation","Vendor Updation","Transfer Order Creation","Transfer Order Updation","Sales Invoice Realtime";

        }
        field(7; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor/Customer Code';
            DataClassification = ToBeClassified;
        }
        field(8; "Source Entry No."; Integer) { DataClassification = ToBeClassified; }
    }

    keys
    {
        key(Key1; "Sr. No")
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