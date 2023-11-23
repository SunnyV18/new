table 50101 Aza_Designer
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; parent_designer_id; Code[20]) { DataClassification = ToBeClassified; }
        field(2; id; Integer) { DataClassification = ToBeClassified; }
        field(3; name; Text[255]) { DataClassification = ToBeClassified; }
        field(4; parent_designer_name; Text[150]) { DataClassification = ToBeClassified; }
        field(5; merchandiser_name; Text[100]) { DataClassification = ToBeClassified; }
        field(6; order_merchandiser_name; Text[100]) { DataClassification = ToBeClassified; }
        field(7; type; Enum "Designer Type") { DataClassification = ToBeClassified; }
        field(8; address; Text[255]) { DataClassification = ToBeClassified; }
        field(9; address_line1; Text[255]) { DataClassification = ToBeClassified; }
        field(10; address_line2; Text[255]) { DataClassification = ToBeClassified; }
        field(11; city; Code[100]) { DataClassification = ToBeClassified; }
        field(12; state; Code[50]) { DataClassification = ToBeClassified; }
        field(13; country; Code[50]) { DataClassification = ToBeClassified; }
        field(14; pincode; Integer) { DataClassification = ToBeClassified; }
        field(15; email_to; Text[400]) { DataClassification = ToBeClassified; }
        field(16; email_cc; text[400]) { DataClassification = ToBeClassified; }
        field(17; contact_name_primary; text[100]) { DataClassification = ToBeClassified; }
        field(18; email_name_primary; Text[100]) { DataClassification = ToBeClassified; }
        field(19; phone_contact_primary; Code[20]) { DataClassification = ToBeClassified; }
        field(20; contact_primary_job_Title; Text[100]) { DataClassification = ToBeClassified; }

        field(21; contact_name_secondary; Text[100]) { DataClassification = ToBeClassified; }
        field(22; email_contact_secondary; Text[260]) { DataClassification = ToBeClassified; }
        field(23; phone_contact_secondary; Code[20]) { DataClassification = ToBeClassified; }
        field(24; contact_job_title_secondary; Text[100]) { DataClassification = ToBeClassified; }
        field(25; reg_address; Text[250]) { DataClassification = ToBeClassified; }
        field(26; reg_address_line1; text[150]) { DataClassification = ToBeClassified; }
        field(27; reg_address_line2; Text[150]) { DataClassification = ToBeClassified; }
        field(28; reg_city; Code[50]) { DataClassification = ToBeClassified; }
        field(29; reg_state; Code[20]) { DataClassification = ToBeClassified; }
        field(30; reg_country; Code[50]) { DataClassification = ToBeClassified; }
        field(31; reg_pincode; Code[15]) { DataClassification = ToBeClassified; }
        field(32; reg_phone; code[100]) { DataClassification = ToBeClassified; }
        field(33; reg_email_to; Text[250]) { DataClassification = ToBeClassified; }
        field(34; reg_email_cc; text[250]) { DataClassification = ToBeClassified; }
        field(35; reg_contact_name_primary; Text[100]) { DataClassification = ToBeClassified; }
        field(36; reg_email_contact_primary; Text[250]) { DataClassification = ToBeClassified; }

        field(37; reg_phone_contact_primary; Code[20]) { DataClassification = ToBeClassified; }
        field(38; reg_contact_primary_job_title; Text[50]) { DataClassification = ToBeClassified; }
        field(39; reg_contact_name_secondary; Text[100]) { DataClassification = ToBeClassified; }
        field(40; reg_phone_contact_secondary; Code[20]) { DataClassification = ToBeClassified; }
        field(41; reg_email_contact_secondary; Text[100]) { DataClassification = ToBeClassified; }
        field(42; reg_contact_job_title_secondary; Text[50])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'length was exceed 30 chr';
        }
        field(43; gst_registered; Boolean) { DataClassification = ToBeClassified; }
        field(44; gst_no; Code[50]) { DataClassification = ToBeClassified; }
        field(45; gst_attachment; Text[1000])
        {
            DataClassification = ToBeClassified;
            // ObsoleteState = Removed;
            // ObsoleteReason = 'Now being store in Record linkes';
        }
        field(46; gst_registration_date; Datetime) { DataClassification = ToBeClassified; }
        field(47; pan_number; Code[15]) { DataClassification = ToBeClassified; }
        field(48; pan_attachment; text[1000])
        {
            DataClassification = ToBeClassified;
            // ObsoleteState = Removed;
            // ObsoleteReason = 'Now being store in Record linkes';
        }

        field(49; bank_account_number; Code[50]) { DataClassification = ToBeClassified; }

        field(50; bank_name; Text[100]) { DataClassification = ToBeClassified; }
        field(51; branch_name; Text[100]) { DataClassification = ToBeClassified; }

        field(52; ifsc_code; Code[15]) { DataClassification = ToBeClassified; }
        field(53; cancelled_cheque_attachment; text[1000]) { DataClassification = ToBeClassified; }
        field(54; msme_registered; Boolean) { DataClassification = ToBeClassified; }
        field(55; msme_registration_no; Code[50]) { DataClassification = ToBeClassified; }

        field(56; msme_certificate; text[1000]) { DataClassification = ToBeClassified; }

        field(57; msme_registration_date; Datetime) { DataClassification = ToBeClassified; }
        field(58; additional_charge_type; Boolean) { DataClassification = ToBeClassified; }
        field(59; additional_charge; Decimal) { DataClassification = ToBeClassified; }
        field(60; po_price_type; Text[50]) { DataClassification = ToBeClassified; }//Nkp Change datatype integer to text suggest by sunny


        field(61; declaration_flag; Boolean) { DataClassification = ToBeClassified; }
        field(88; declaration; text[100]) { DataClassification = ToBeClassified; }
        field(62; signature_name; Text[50]) { DataClassification = ToBeClassified; }
        field(63; signature_place; Text[50]) { DataClassification = ToBeClassified; }
        field(64; signature_date; Datetime) { DataClassification = ToBeClassified; }
        field(65; designation; text[100]) { DataClassification = ToBeClassified; }
        field(66; date_added; DateTime) { DataClassification = ToBeClassified; }
        field(67; added_by; Text[80]) { DataClassification = ToBeClassified; }
        field(68; date_modified; DateTime) { DataClassification = ToBeClassified; }
        field(69; modified_by; Text[80]) { DataClassification = ToBeClassified; }
        field(70; status; Boolean) { DataClassification = ToBeClassified; }
        field(71; return_policy; Text[100]) { DataClassification = ToBeClassified; }
        field(72; is_deleted; boolean) { DataClassification = ToBeClassified; }
        field(73; classification_tag; Text[50]) { DataClassification = ToBeClassified; }
        field(74; is_show_sale; Boolean) { DataClassification = ToBeClassified; }
        field(75; seouri; Text[150]) { DataClassification = ToBeClassified; }
        field(76; show_cat_section; Integer) { DataClassification = ToBeClassified; }

        field(77; show_cat_section_data; Text[400]) { DataClassification = ToBeClassified; }
        field(78; seo_content; Text[100]) { DataClassification = ToBeClassified; }
        field(79; description; Text[260]) { DataClassification = ToBeClassified; }
        field(80; sale_text; Text[100]) { DataClassification = ToBeClassified; }
        field(81; banner_image; Text[100]) { DataClassification = ToBeClassified; }
        field(82; is_show_counter; Boolean) { DataClassification = ToBeClassified; }
        field(83; counter_start_date; Date) { DataClassification = ToBeClassified; }
        field(84; counter_end_date; Date) { DataClassification = ToBeClassified; }
        field(85; is_show_cod; Boolean) { DataClassification = ToBeClassified; }
        field(86; "Record Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Created,Error,Updated;

        }
        field(87; reg_contact_jobtitle_secondary; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(89; "No. of Errors"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(ErrorLogCustVend where("Process Type" = filter("Vendor Creation"), "Source Entry No." = field("Entry No.")));
        }
        field(90; "Error Text"; Text[1000])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(ErrorLogCustVend."Error Remarks" where("Process Type" = filter("Vendor Creation"), "Source Entry No." = field("Entry No.")));
        }
        field(91; "Entry No."; Integer) { DataClassification = ToBeClassified; AutoIncrement = true; }
        field(92; "Error Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(93; "merchant_status"; Code[20]) { DataClassification = ToBeClassified; }
        field(94; "merchant_approved_by"; Text[75]) { DataClassification = ToBeClassified; }
        field(95; "finance_status"; Code[20]) { DataClassification = ToBeClassified; }
        field(96; "finance_approved_by"; Text[75]) { DataClassification = ToBeClassified; }
        field(97; "final_approved_status"; Code[20]) { DataClassification = ToBeClassified; }
        field(98; "designer_code"; Code[50]) { DataClassification = ToBeClassified; }
        field(99; company_name; Code[250]) { DataClassification = ToBeClassified; }
        field(100; "name_2"; Text[250]) { DataClassification = ToBeClassified; }
    }

    keys
    {
        key(Key1; "Entry No.") { Clustered = true; }

        key(id; id)
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