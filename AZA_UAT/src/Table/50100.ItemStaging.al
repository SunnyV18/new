table 50100 Aza_Item
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; bar_code; Code[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if Format(Rec.order_delivery_date) = '' then begin
                    order_delivery_date := 19000101D;
                end;
                if not Evaluate(txtData, Rec.bar_code) then
                    Error('Please send string values for bar_code with length upto 50');
            end;
        }
        field(2; tag_code; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.tag_code) then
                    Error('Please send string values for tag_code with length upto 30');
            end;
        }
        field(3; aza_code; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.aza_code) then
                    Error('Please send string values for aza_code with length upto 30');
            end;
        }

        field(4; category_code; Code[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.category_code) then
                    Error('Please send string values for category_code with length upto 10');
            end;
        }

        field(5; category_name; Code[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.category_name) then
                    Error('Please send string values for category_name with length upto 100');
            end;
        }

        field(6; sub_category_code; Code[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.sub_category_code) then
                    Error('Please send string values for sub_category_code with length upto 10');
            end;
        }

        field(7; sub_category_name; Code[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.sub_category_name) then
                    Error('Please send string values for sub_category_name with length upto 100');
            end;
        }
        field(8; sub_sub_category_code; Code[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.sub_sub_category_code) then
                    Error('Please send string values for sub_sub_category_code with length upto 10');
            end;
        }

        field(9; sub_sub_category_name; Code[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.sub_sub_category_name) then
                    Error('Please send string values for sub_sub_category_code with length upto 100');
            end;
        }

        field(10; designer_id; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.designer_id) then
                    Error('Please send string values for designer_id with length upto 30');
            end;
        }

        field(11; parent_designer_id; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.parent_designer_id) then
                    Error('Please send string values for category_code with length upto 20');
            end;
        }

        field(12; components_no; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                // if not Evaluate(intBarcode, Rec.components_no) then
                //     Error('Please send integer values for components_no ');
            end;
        }

        field(13; neckline_type; Code[250])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.neckline_type) then
                    Error('Please send string values for neckline_type with length upto 100');
            end;
        }


        field(14; sleeve_length; Code[250])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.sleeve_length) then
                    Error('Please send string values for sleeve_length with length upto 100');
            end;
        }

        field(15; closure_type; Code[250])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.closure_type) then
                    Error('Please send string values for closure_type with length upto 100');
            end;
        }

        field(16; fabric_type; Code[150])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.fabric_type) then
                    Error('Please send string values for fabric_type with length upto 100');
            end;
        }

        field(17; type_of_work; Code[250])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.type_of_work) then
                    Error('Please send string values for type_of_work with length upto 100');
            end;
        }

        field(18; type_of_pattern; Code[250])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.type_of_pattern) then
                    Error('Please send string values for type_of_pattern with length upto 100');
            end;
        }

        field(19; designer_code; Code[150])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.designer_code) then
                    Error('Please send string values for designer_code with length upto 100');
            end;
        }

        field(20; product_title; Code[150])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.product_title) then
                    Error('Please send string values for product_title with length upto 100');
            end;
        }

        field(21; sleeve_type; Code[250])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.sleeve_type) then
                    Error('Please send string values for sleeve_type with length upto 100');
            end;
        }

        field(22; stylist_note; text[150])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.stylist_note) then
                    Error('Please send string values for stylist_note with length upto 100');
            end;
        }

        field(23; product_thumbImg; Code[150])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.product_thumbImg) then
                    Error('Please send string values for product_thumImg with length upto 100');
            end;
        }

        field(24; added_by; Code[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if not Evaluate(txtData, Rec.added_by) then
                    Error('Please send string values for added_by with length upto 100');
            end;
        }

        field(25; date_added; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                txtDate: text;
            begin
                txtDate := format(Rec.date_added);
                if not Evaluate(dtDate, txtDate) then
                    Error('Please send string values for date_added with length upto 100');
            end;
        }

        field(26; modified_date; DateTime) { DataClassification = ToBeClassified; }

        field(27; status; Boolean) { DataClassification = ToBeClassified; }

        field(28; modified_by; Code[20]) { DataClassification = ToBeClassified; }

        field(29; merchandise_name; Code[255]) { DataClassification = ToBeClassified; }

        field(30; image1; Text[250]) { DataClassification = ToBeClassified; }

        field(31; image2; Text[250]) { DataClassification = ToBeClassified; }

        field(32; image3; Text[250]) { DataClassification = ToBeClassified; }

        field(33; image4; Text[250]) { DataClassification = ToBeClassified; }

        field(34; image5; Text[250]) { DataClassification = ToBeClassified; }

        field(35; image6; Text[250]) { DataClassification = ToBeClassified; }

        field(36; image7; Text[250]) { DataClassification = ToBeClassified; }

        field(37; image8; Text[250]) { DataClassification = ToBeClassified; }

        field(38; image9; Text[250]) { DataClassification = ToBeClassified; }

        field(39; image10; Text[250]) { DataClassification = ToBeClassified; }

        field(40; size_id; Code[100]) { DataClassification = ToBeClassified; }

        field(41; color_id; Code[100]) { DataClassification = ToBeClassified; }

        field(42; warehouse_stock; Integer) { DataClassification = ToBeClassified; }

        field(43; product_price; Decimal) { DataClassification = ToBeClassified; }

        field(44; product_cost; Decimal) { DataClassification = ToBeClassified; }

        field(45; discount_percent; Decimal) { DataClassification = ToBeClassified; }

        field(46; discount_percent_by_desg; Decimal) { DataClassification = ToBeClassified; }

        field(47; discount_percent_by_aza; Decimal) { DataClassification = ToBeClassified; }

        field(48; discount_price; Decimal) { DataClassification = ToBeClassified; }

        field(49; "PO Created"; Boolean) { DataClassification = ToBeClassified; }

        field(50; "Record Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Created,Error,Updated;

        }
        field(51; fc_location; Text[50]) { DataClassification = ToBeClassified; }
        field(52; quantity_received; Decimal) { DataClassification = ToBeClassified; DecimalPlaces = 11; }
        field(53; qc_status; Integer) { DataClassification = ToBeClassified; }
        field(54; action_status; Code[10]) { DataClassification = tobeclassified; }

        field(55; type_of_inventory; Code[20]) { DataClassification = ToBeClassified; }

        field(56; "po_type"; Option)
        {
            OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright",MTO;
            OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            DataClassification = ToBeClassified;
        }
        field(57; "Customer No."; Code[30]) { DataClassification = ToBeClassified; Enabled = false; ObsoleteReason = 'removed'; ObsoleteState = Removed; }

        field(58; customer_id; text[250]) { DataClassification = ToBeClassified; }// ObsoleteReason = ''; ObsoleteState = Removed; }

        // field(64; Customer_ID; text[250]) { DataClassification = ToBeClassified; }
        field(59; waist; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 10;
        }
        field(60; bust; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 10;
        }
        field(61; hip; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 10;
        }
        field(62; shoulder; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 10;
        }
        field(63; check; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 10;
        }
        field(64; "No. of Errors"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(ErrorCapture where("Process Type" = filter("Item Creation" | "PO Creation" | "RTV Creation"), "Source Entry No." = field("Entry No.")));
        }
        field(65; "Error Text"; Text[1000])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(ErrorCapture."Error Remarks" where("Process Type" = filter("Item Creation" | "PO Creation" | "RTV Creation"), "Source Entry No." = field("Entry No.")));
        }
        field(70; "Error date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        // field(49; filter_price; Decimal) { DataClassification = ToBeClassified; }
        field(66; Old_aza_code; Code[30]) { DataClassification = ToBeClassified; }
        field(67; "Entry No."; Integer) { DataClassification = ToBeClassified; AutoIncrement = true; }
        field(68; Is_Outward; Boolean) { DataClassification = ToBeClassified; }
        field(69; "RTV Created"; Boolean) { DataClassification = ToBeClassified; }
        //  field(71; "Description"; Text[250]) { DataClassification = ToBeClassified; }
        field(72; "product_desc"; Text[1000]) { DataClassification = ToBeClassified; }
        field(73; "component_desc"; Code[250]) { DataClassification = ToBeClassified; }
        field(74; "sales_associate"; Code[30]) { DataClassification = ToBeClassified; }
        field(75; is_padded; Boolean) { DataClassification = ToBeClassified; }
        field(76; "is_attached_can_can"; Boolean) { DataClassification = ToBeClassified; }
        field(77; "query_confirmed_by"; Code[100]) { DataClassification = ToBeClassified; }
        field(78; "collection_type"; Code[50]) { DataClassification = ToBeClassified; }
        field(79; "type_classification"; text[50]) { DataClassification = ToBeClassified; }
        field(80; "desg_extra_charges"; Decimal) { DataClassification = ToBeClassified; }
        field(81; "aza_extra_charges"; Decimal) { DataClassification = ToBeClassified; }
        field(82; "order_delivery_date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(83; "measurements"; Text[1000]) { DataClassification = ToBeClassified; }
        field(84; "ref_barcode"; Code[50]) { DataClassification = ToBeClassified; }

    }

    keys
    {
        key(Key1; "Entry No.") { Clustered = true; }

        key(key3; designer_code, po_type, fc_location) { }
        key(key2; designer_id, po_type, product_desc) { }
        key(bar_code; bar_code)
        {
            // Clustered = true;
        }

    }

    var
        myInt: Integer;
        intBarcode: Integer;

        txtData: text;

        dtDate: Date;

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