table 50114 CustomerStaging
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; site_user_id; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; register_type; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; user_f_name; text[256])
        {
            DataClassification = ToBeClassified;

        }
        field(4; user_l_name; text[256])
        {
            DataClassification = ToBeClassified;

        }
        field(5; user_email; text[256])
        {
            DataClassification = ToBeClassified;

        }
        field(6; user_gender; text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; user_dob; date)
        {
            DataClassification = ToBeClassified;

        }
        field(8; user_marriage_ann_date; date)
        {
            DataClassification = ToBeClassified;

        }
        field(9; phone_no; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(10; country_name; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(11; address; text[255])
        {
            DataClassification = ToBeClassified;

        }

        field(12; landmark; text[100])
        {
            DataClassification = ToBeClassified;

        }

        field(13; state; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(14; city; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(15; pin_code; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(16; date_added; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(17; date_modified; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(18; user_credit; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(19; user_wallet; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(20; credit_admin_remark; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(21; wallet_credit_reason; Code[260])//Nkp---Change datatype Decimal to Code suggest by sunny
        {
            DataClassification = ToBeClassified;

        }
        field(22; status; integer)
        {
            DataClassification = ToBeClassified;

        }
        field(23; added_by; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(24; modified_by; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(25; is_deleted; boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(26; loyalty_points; integer)
        {
            DataClassification = ToBeClassified;

        }
        field(27; user_tier_type; integer)
        {
            DataClassification = ToBeClassified;

        }
        field(28; total_purchase_amount; text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(29; user_adhaar_no; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(30; user_pan_no; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(31; is_gst_registered; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(32; gst_no; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(33; Record_Status; Option)
        {
            OptionMembers = " ","Created","Error","Updated";
            DataClassification = ToBeClassified;
        }
        field(46; "Entry No."; Integer) { DataClassification = ToBeClassified; AutoIncrement = true; }
        field(34; "No. of Errors"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(ErrorLogCustVend where("Process Type" = filter("Customer Creation"), "Source Entry No." = field("Entry No.")));
        }
        field(35; "Error Text"; Text[1000])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(ErrorLogCustVend."Error Remarks" where("Process Type" = filter("Customer Creation"), "Source Entry No." = field("Entry No.")));
        }
        field(36; "Error Date"; Date)
        {
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
        key(key1; "Entry No.") { Clustered = true; }
        key(Key2; site_user_id)
        {
            // Clustered = true;
        }
    }

    var
        myInt: Integer;
        custostagg: Record CustomerStaging;

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