table 50109 SalesOrder_Staging
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; order_id; Code[20])
        // field(1; order_id; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; payment_id; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(3; transaction_id; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(4; payer_id; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(5; payment_method; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(6; site_user_id; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; site_user_name; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(8; site_user_email; text[255])
        {
            DataClassification = ToBeClassified;

        }

        field(9; billing_name; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(10; billing_address; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(11; billing_locality; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(12; billing_city; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(13; billing_state; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(14; billing_postal_code; text[10])
        {
            DataClassification = ToBeClassified;

        }
        field(15; billing_country; text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(16; billing_phone; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(17; billing_email; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(18; billing_landmark; text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(19; shipping_name; text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(20; shipping_address; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(21; shipping_locality; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(22; shipping_city; text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(23; shipping_state; text[150])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
                Recstate: Record State;
            begin
                Recstate.Reset();
                Recstate.SetRange(Description, shipping_state);
                if Recstate.FindFirst() then begin
                    shipping_state := Recstate.Code;
                end;

            end;

        }
        field(24; shipping_postal_code; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(25; shipping_country; text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(26; shipping_phone; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(27; shipping_email; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(28; shipping_landmark; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(29; promo_code; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(30; promo_discount; decimal) { DataClassification = ToBeClassified; }
        field(31; redeem_points; decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(32; redeem_points_credit; decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(33; shipping_amount; integer)
        {
            DataClassification = ToBeClassified;

        }
        field(34; duties_and_taxes; decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(35; total_price; text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if total_price = '' then begin
                    total_price := '0';
                end;

            end;

        }
        field(36; date_added; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(57; date_modified; DateTime)
        { DataClassification = ToBeClassified; }
        field(37; order_status; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(38; payment_status; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(39; currency; text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(40; currency_rate; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(41; state_tax_type; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(42; pan_number; text[10])
        {
            DataClassification = ToBeClassified;

        }
        field(43; gift_message; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(44; is_special_order; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(45; special_message; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(46; sale_person; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(47; cod_confirm; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(48; charge_back_remark; text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(49; charge_back_date; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(50; loyalty_points; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(58; loyalty_percent; Decimal) { DataClassification = ToBeClassified; }

        field(51; loyalty_unit; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(52; redeem_loyalty_points; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(54; new_shipping_address; text[255])
        {
            DataClassification = ToBeClassified;

        }
        field(55; is_loyalty_free_ship; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(56; current_loyalty_tier; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(50047; "SO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //>>
        field(50048; "No. of Errors"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(ErrorLogSO where("Source Entry No." = field("Entry No.")));
        }
        field(50049; "Error Text"; Text[1000])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(ErrorLogSO."Error Remarks" where("Source Entry No." = field("Entry No.")));
        }
        field(50050; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(50051; "Record Status"; Option)
        {
            OptionMembers = " ",Created,Error,Updated;
            DataClassification = ToBeClassified;
        }
        field(50052; "Error Date"; Date)
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
        key(Key2; order_id)
        {
            // Clustered = true;
        }
    }

    var
        myInt: Integer;
        ship: Record "Ship-to Address";

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