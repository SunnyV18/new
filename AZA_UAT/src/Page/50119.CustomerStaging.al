page 50119 CustomerStaging
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Aza Customer Staging';
    SourceTable = CustomerStaging;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(site_user_id; Rec.site_user_id)
                {
                    ApplicationArea = All;

                }
                field(register_type; Rec.register_type)
                {
                    ApplicationArea = All;

                }
                field(user_f_name; Rec.user_f_name)
                {
                    ApplicationArea = All;

                }
                field(user_l_name; Rec.user_l_name)
                {
                    ApplicationArea = All;

                }
                field(user_email; Rec.user_email)
                {
                    ApplicationArea = All;

                }
                field(user_gender; Rec.user_gender)
                {
                    ApplicationArea = All;

                }
                field(user_dob; Rec.user_dob)
                {
                    ApplicationArea = All;

                }
                field(user_marriage_ann_date; Rec.user_marriage_ann_date)
                {
                    ApplicationArea = All;

                }
                field(phone_no; Rec.phone_no)
                {
                    ApplicationArea = All;

                }

                field(country_name; Rec.country_name)
                {
                    ApplicationArea = All;

                }
                field(address; Rec.address)
                {
                    ApplicationArea = All;

                }
                field(landmark; Rec.landmark)
                {
                    ApplicationArea = All;

                }

                field(state; Rec.state)
                {
                    ApplicationArea = All;

                }
                field(city; Rec.city)
                {
                    ApplicationArea = All;

                }

                field(pin_code; Rec.pin_code)
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

                field(user_credit; Rec.user_credit)
                {
                    ApplicationArea = All;

                }
                field(user_wallet; Rec.user_wallet)
                {
                    ApplicationArea = All;

                }

                field(credit_admin_remark; Rec.credit_admin_remark)
                {
                    ApplicationArea = All;

                }
                field(wallet_credit_reason; Rec.wallet_credit_reason)
                {
                    ApplicationArea = All;

                }
                field(status; Rec.status)
                {
                    ApplicationArea = All;

                }

                field(added_by; Rec.added_by)
                {
                    ApplicationArea = All;

                }
                field(modified_by; Rec.modified_by)
                {
                    ApplicationArea = All;

                }
                field(is_deleted; Rec.is_deleted)
                {
                    ApplicationArea = All;

                }
                field(loyalty_points; Rec.loyalty_points)
                {
                    ApplicationArea = All;

                }
                field(user_tier_type; Rec.user_tier_type)
                {
                    ApplicationArea = All;

                }

                field(total_purchase_amount; Rec.total_purchase_amount)
                {
                    ApplicationArea = All;

                }
                field(user_adhaar_no; Rec.user_adhaar_no)
                {
                    ApplicationArea = All;

                }
                field(user_pan_no; Rec.user_pan_no)
                {
                    ApplicationArea = All;

                }
                field(is_gst_registered; Rec.is_gst_registered)
                {
                    ApplicationArea = All;

                }

                field(gst_no; Rec.gst_no)
                {
                    ApplicationArea = All;

                }
                field(Record_Status; Rec.Record_Status)
                {
                    ApplicationArea = all;
                }

                field("No. of Errors"; Rec."No. of Errors") { ApplicationArea = all; }
                field("Error Text"; Rec."Error Text") { ApplicationArea = all; }
                field("Error Date"; Rec."Error Date") { ApplicationArea = all; }

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
            action(CreateCustomer)
            {
                ApplicationArea = All;
                Caption = 'Create Customer';

                trigger OnAction();
                var
                    CU50106: Codeunit 50106;
                begin
                    CU50106.ProcessCustomers();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}