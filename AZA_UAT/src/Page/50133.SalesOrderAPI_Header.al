page 50133 SalesOrderAPI_Header
{
    PageType = API;
    Caption = 'SalesOrderAPI_Header';
    APIPublisher = 'CCIT';
    APIGroup = 'SalesOrderAPIs';
    APIVersion = 'v1.0';
    EntityName = 'SO_Staging';
    EntitySetName = 'SO_Staging';
    SourceTable = SalesOrder_Staging;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(order_id; Rec.order_id)
                {
                    ApplicationArea = All;

                }
                field(payment_id; Rec.payment_id)
                {
                    ApplicationArea = All;

                }
                field(transaction_id; Rec.transaction_id)
                {
                    ApplicationArea = All;

                }
                field(payer_id; Rec.payer_id)
                {
                    ApplicationArea = All;

                }
                field(payment_method; Rec.payment_method)
                {
                    ApplicationArea = All;

                }
                field(site_user_id; Rec.site_user_id)
                {
                    ApplicationArea = All;

                }
                field(site_user_name; Rec.site_user_name)
                {
                    ApplicationArea = All;

                }
                field(site_user_email; Rec.site_user_email)
                {
                    ApplicationArea = All;

                }
                field(billing_name; Rec.billing_name)
                {
                    ApplicationArea = All;

                }
                field(billing_address; Rec.billing_address)
                {
                    ApplicationArea = All;

                }
                field(billing_locality; Rec.billing_locality)
                {
                    ApplicationArea = All;

                }
                field(billing_city; Rec.billing_city)
                {
                    ApplicationArea = All;

                }
                field(billing_state; Rec.billing_state)
                {
                    ApplicationArea = All;

                }
                field(billing_postal_code; Rec.billing_postal_code)
                {
                    ApplicationArea = All;

                }
                field(billing_country; Rec.billing_country)
                {
                    ApplicationArea = All;

                }
                field(billing_phone; Rec.billing_phone)
                {
                    ApplicationArea = All;

                }
                field(billing_email; Rec.billing_email)
                {
                    ApplicationArea = All;

                }
                field(billing_landmark; Rec.billing_landmark)
                {
                    ApplicationArea = All;

                }
                field(shipping_name; Rec.shipping_name)
                {
                    ApplicationArea = All;

                }
                field(shipping_address; Rec.shipping_address)
                {
                    ApplicationArea = All;

                }
                field(shipping_locality; Rec.shipping_locality)
                {
                    ApplicationArea = All;

                }
                field(shipping_city; Rec.shipping_city)
                {
                    ApplicationArea = All;

                }
                field(shipping_state; Rec.shipping_state)
                {
                    ApplicationArea = All;

                }
                field(shipping_postal_code; Rec.shipping_postal_code)
                {
                    ApplicationArea = All;

                }
                field(shipping_country; Rec.shipping_country)
                {
                    ApplicationArea = All;

                }
                field(shipping_phone; Rec.shipping_phone)
                {
                    ApplicationArea = All;

                }
                field(shipping_email; Rec.shipping_email)
                {
                    ApplicationArea = All;

                }
                field(shipping_landmark; Rec.shipping_landmark)
                {
                    ApplicationArea = All;

                }
                field(promo_code; Rec.promo_code)
                {
                    ApplicationArea = All;

                }
                field(promo_discount; Rec.promo_discount)
                {
                    ApplicationArea = All;

                }
                field(redeem_points; Rec.redeem_points)
                {
                    ApplicationArea = All;

                }

                field(redeem_points_credit; Rec.redeem_points_credit)
                {
                    ApplicationArea = All;

                }
                field(shipping_amount; Rec.shipping_amount)
                {
                    ApplicationArea = All;

                }
                field(duties_and_taxes; Rec.duties_and_taxes)
                {
                    ApplicationArea = All;

                }
                field(total_price; Rec.total_price)
                {
                    ApplicationArea = All;

                }
                field(date_added; Rec.date_added)
                {
                    ApplicationArea = All;

                }
                field(date_modified; Rec.date_modified)
                {
                    ApplicationArea = All;

                }
                field(order_status; Rec.order_status)
                {
                    ApplicationArea = All;

                }
                field(payment_status; Rec.payment_status)
                {
                    ApplicationArea = All;

                }
                field(currency; Rec.currency)
                {
                    ApplicationArea = All;

                }
                field(currency_rate; Rec.currency_rate)
                {
                    ApplicationArea = All;

                }
                field(state_tax_type; Rec.state_tax_type)
                {
                    ApplicationArea = All;

                }
                field(pan_number; Rec.pan_number)
                {
                    ApplicationArea = All;

                }
                field(gift_message; Rec.gift_message)
                {
                    ApplicationArea = All;

                }
                field(is_special_order; Rec.is_special_order)
                {
                    ApplicationArea = All;

                }
                field(special_message; Rec.special_message)
                {
                    ApplicationArea = All;

                }
                field(sale_person; Rec.sale_person)
                {
                    ApplicationArea = All;

                }
                field(cod_confirm; Rec.cod_confirm)
                {
                    ApplicationArea = All;

                }
                field(charge_back_date; Rec.charge_back_date)
                {
                    ApplicationArea = All;

                }
                field(charge_back_remark; Rec.charge_back_remark)
                {
                    ApplicationArea = All;

                }
                field(loyalty_points; Rec.loyalty_points)
                {
                    ApplicationArea = All;

                }

                field(loyalty_percent; Rec.loyalty_percent)
                {
                    ApplicationArea = all;
                }
                field(loyalty_unit; Rec.loyalty_unit)
                {
                    ApplicationArea = All;

                }
                field(redeem_loyalty_points; Rec.redeem_loyalty_points)
                {
                    ApplicationArea = All;

                }
                field(new_shipping_address; Rec.new_shipping_address)
                {
                    ApplicationArea = All;

                }
                field(is_loyalty_free_ship; Rec.is_loyalty_free_ship)
                {
                    ApplicationArea = All;

                }
                field(current_loyalty_tier; Rec.current_loyalty_tier)
                {
                    ApplicationArea = All;

                }
                // part(so_details; SalesLinePage_API)
                // {
                //     ApplicationArea = all;
                //     Caption = 'Lines', Locked = true;
                //     EntityName = 'SOLine_Staging';
                //     EntitySetName = 'SOLine_Staging_API';
                //     SubPageLink = order_id = field(order_id);
                // }
            }
        }
    }
}