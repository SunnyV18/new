page 50117 SalesOrderDtlsStaging
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SalesOrderDtls_Staging;
    Caption = 'Aza SalesOrder Details Staging';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(order_detail_id; Rec.order_detail_id)
                {
                    ApplicationArea = All;

                }
                field(order_id; Rec.order_id)
                {
                    ApplicationArea = All;

                }

                // field(barcode; Rec.invoice_item_number) { ApplicationArea = all; }
                field(barcode; Rec.barcode) { ApplicationArea = all; }

                field(product_id; rec.product_id)
                {
                    ApplicationArea = All;

                }
                field(product_title; Rec.product_title)
                {
                    ApplicationArea = All;

                }
                field(aza_online_code; Rec.aza_online_code)
                {
                    ApplicationArea = All;

                }
                field(category_id; Rec.category_id)
                {
                    ApplicationArea = All;

                }
                field(size_name; Rec.size_name)
                {
                    ApplicationArea = All;

                }
                field(designer_id; Rec.designer_id)
                {
                    ApplicationArea = All;

                }
                field(colour_name; Rec.colour_name)
                {
                    ApplicationArea = All;

                }
                field(quantity; Rec.quantity)
                {
                    ApplicationArea = All;

                }
                field(actual_quantity; Rec.actual_quantity)
                {
                    ApplicationArea = All;

                }
                field(product_price; Rec.product_price)
                {
                    ApplicationArea = All;

                }
                field(product_cost; Rec.product_cost)
                {
                    ApplicationArea = All;

                }
                field(product_amount; Rec.product_amount)
                {
                    ApplicationArea = All;

                }
                field(actual_amount; Rec.actual_amount)
                {
                    ApplicationArea = All;

                }
                field(fc_location; Rec.fc_location) { ApplicationArea = all; }
                field(discount_percent; Rec.discount_percent)
                {
                    ApplicationArea = All;

                }
                field(discount_percent_by_aza; Rec.discount_percent_by_aza)
                {
                    ApplicationArea = All;

                }
                field(discount_percent_by_desg; Rec.discount_percent_by_desg)
                {
                    ApplicationArea = All;

                }
                field(alteration_charges; alteration_charges) { ApplicationArea = all; }
                field(promo_discount; Rec.promo_discount)
                {
                    ApplicationArea = All;

                }
                field(credit_by_product; Rec.credit_by_product)
                {
                    ApplicationArea = All;

                }
                field(loyalty_by_product; Rec.loyalty_by_product)
                {
                    ApplicationArea = All;

                }
                field(tax_by_product; Rec.tax_by_product)
                {
                    ApplicationArea = All;

                }
                field(shipping_status; Rec.shipping_status)
                {
                    ApplicationArea = All;

                }
                field(is_return_and_exchange; Rec.is_return_and_exchange)
                {
                    ApplicationArea = All;

                }
                field(shipping_company_name; Rec.shipping_company_name)
                {
                    ApplicationArea = All;

                }
                field(shipping_company_name_rtv; Rec.shipping_company_name_rtv)
                {
                    ApplicationArea = All;

                }
                field(tracking_id; Rec.tracking_id)
                {
                    ApplicationArea = All;

                }
                field(tracking_id_rtv; Rec.tracking_id_rtv)
                {
                    ApplicationArea = All;

                }
                field(delivery_date; Rec.delivery_date)
                {
                    ApplicationArea = All;

                }

                field(delivery_date_rtv; Rec.delivery_date_rtv)
                {
                    ApplicationArea = All;

                }
                field(track_date; Rec.track_date)
                {
                    ApplicationArea = All;

                }
                field(track_dater_tv; Rec.track_date_rtv)
                {
                    ApplicationArea = All;

                }
                field(invoice_number; Rec.invoice_number)
                {
                    ApplicationArea = All;

                }
                field(invoice_number_rtv; Rec.invoice_number_rtv)
                {
                    ApplicationArea = All;

                }
                field(dispatch_date; Rec.dispatch_date)
                {
                    ApplicationArea = All;

                }
                field(in_warehouse; Rec.in_warehouse)
                {
                    ApplicationArea = All;

                }
                field(ship_date; Rec.ship_date)
                {
                    ApplicationArea = All;

                }
                field(ship_date_rtv; Rec.ship_date_rtv)
                {
                    ApplicationArea = All;

                }

                field(weight; Rec.weight)
                {
                    ApplicationArea = All;

                }
                field(ship_mode; Rec.ship_mode)
                {
                    ApplicationArea = All;

                }
                field(order_confirm_date; Rec.order_confirm_date)
                {
                    ApplicationArea = All;

                }
                field(loyalty_points; Rec.loyalty_points)
                {
                    ApplicationArea = All;

                }

                field(estm_delivery_date; Rec.estm_delivery_date)
                {
                    ApplicationArea = All;

                }

                field(loyalty_flag; Rec.loyalty_flag) { ApplicationArea = all; }
                field(is_customization_received; Rec.is_customization_received)
                {
                    ApplicationArea = All;

                }
                field(is_blouse_customization_received; Rec.is_blouse_customization_received)
                {
                    ApplicationArea = All;

                }

                field("Line Created"; Rec."Line Created")
                {
                    ApplicationArea = all;
                }




            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}