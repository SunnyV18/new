table 50122 SalesInvoice_Realtime
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; order_id; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(3; order_details_id; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Action_ID; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(5; Invoice_Number; Code[20]) { DataClassification = ToBeClassified; }
        field(6; Processed; Boolean) { DataClassification = ToBeClassified; }
        field(7; Countryname; Code[30]) { DataClassification = ToBeClassified; }
        field(8; State; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
                Recstate: Record State;
            begin
                Recstate.Reset();
                Recstate.SetRange(Description, State);
                if Recstate.FindFirst() then begin
                    State := Recstate.Code;
                end;

            end;
        }
        field(9; Address; text[100]) { DataClassification = ToBeClassified; }
        field(10; GSTwithoutPaymentOfDuty; Boolean) { DataClassification = ToBeClassified; }
        field(11; po_number; code[20]) { DataClassification = ToBeClassified; }
        field(12; fc_id; Code[20]) { DataClassification = ToBeClassified; }
        field(13; "id"; Code[20]) { DataClassification = ToBeClassified; }
        field(14; Name; Code[50]) { DataClassification = ToBeClassified; }
        field(15; PostCode; Code[20]) { DataClassification = ToBeClassified; }
        field(16; City; Code[50]) { DataClassification = ToBeClassified; }
        field(17; "No. of Errors"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(ErrorLogSO where("Source Entry No." = field("Entry No.")));
        }
        field(18; "Error Text"; Text[1000])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(ErrorLogSO."Error Remarks" where("Source Entry No." = field("Entry No.")));
        }
        field(19; "Record Status"; option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Created","Error";
        }
        field(20; "Gst Registration No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "PAN No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.", Order_ID, order_details_id, Action_ID, Countryname, State, Address, GSTwithoutPaymentOfDuty, po_number, fc_id, id, Name, PostCode, City, "Gst Registration No.", "PAN No.")
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