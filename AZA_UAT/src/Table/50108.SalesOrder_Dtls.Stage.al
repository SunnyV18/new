table 50108 SalesOrderDtls_Staging
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; order_detail_id; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; order_id; integer) { DataClassification = ToBeClassified; }
        // field(2; order_id; Code[20]) { DataClassification = ToBeClassified; }
        field(3; product_id; Integer) { DataClassification = ToBeClassified; }
        field(4; product_title; text[255]) { DataClassification = ToBeClassified; }
        field(5; aza_online_code; text[100]) { DataClassification = ToBeClassified; }
        field(6; category_id; integer) { DataClassification = ToBeClassified; }

        // field(7; size_id; integer) { DataClassification = ToBeClassified; }//200123 changed to text
        field(7; size_name; Code[50]) { DataClassification = ToBeClassified; }
        field(8; designer_id; Integer) { DataClassification = ToBeClassified; }
        // field(9; color_id; Integer) { DataClassification = ToBeClassified; }//200123 changed to text
        field(9; colour_name; Code[50]) { DataClassification = ToBeClassified; }
        field(10; quantity; integer) { DataClassification = ToBeClassified; }
        field(11; actual_quantity; integer) { DataClassification = ToBeClassified; }
        field(12; product_price; Decimal) { DataClassification = ToBeClassified; }
        field(13; product_cost; decimal) { DataClassification = ToBeClassified; }
        field(14; product_amount; decimal) { DataClassification = ToBeClassified; }
        field(15; actual_amount; Decimal) { DataClassification = ToBeClassified; }
        field(16; discount_percent; Decimal) { DataClassification = ToBeClassified; }
        field(17; discount_percent_by_desg; Decimal) { DataClassification = ToBeClassified; }
        field(18; discount_percent_by_aza; Decimal) { DataClassification = ToBeClassified; }
        field(19; promo_discount; decimal) { DataClassification = ToBeClassified; }
        field(20; credit_by_product; decimal) { DataClassification = ToBeClassified; }
        field(21; loyalty_by_product; decimal) { DataClassification = ToBeClassified; }
        field(22; tax_by_product; decimal) { DataClassification = ToBeClassified; }
        field(23; shipping_status; code[50]) { DataClassification = ToBeClassified; }
        field(24; is_return_and_exchange; boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(25; shipping_company_name; text[255]) { DataClassification = ToBeClassified; }
        field(26; shipping_company_name_rtv; text[255]) { DataClassification = ToBeClassified; }

        field(27; tracking_id; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(28; tracking_id_rtv; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(29; delivery_date; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(30; delivery_date_rtv; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(31; track_date; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(32; track_date_rtv; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(33; invoice_number; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(34; invoice_number_rtv; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(35; dispatch_date; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(36; in_warehouse; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(37; ship_date; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(38; ship_date_rtv; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(39; weight; decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(40; ship_mode; text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(41; order_confirm_date; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(42; loyalty_points; integer)
        {
            DataClassification = ToBeClassified;

        }
        field(43; loyalty_flag; boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(44; estm_delivery_date; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(45; is_customization_received; boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(46; is_blouse_customization_received; boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(47; invoice_item_number; Code[50])
        {
            DataClassification = ToBeClassified;
            ObsoleteReason = 'Removed';
            ObsoleteState = Removed;
        }
        field(48; alteration_charges; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50; fc_location; Code[10]) { DataClassification = ToBeClassified; }
        field(49; "Line Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(52; barcode; Code[100])
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
        key(Key2; order_detail_id)
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