tableextension 50105 CustomerExtAZA extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Adhaar No."; code[16])
        {
            DataClassification = CustomerContent;
        }
        field(50001; Register_Type; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Gender; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; DOB; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date Of Birth';
        }
        field(50004; Marriage_Ann_Date; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'marriage Anniversary Date';
        }
        field(50005; Loyalty_Points; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Loyalty Points';
        }
        field(50006; Wallet; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        // field(50007; Wallet_Credit_Reason; Text[256])
        // {
        //     DataClassification = ToBeClassified;
        // }
        field(50016; user_credit; Decimal)
        {
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = sum(CustomerStaging.user_credit where(site_user_id = field("No.")));


        }
        field(50017; user_wallet; Decimal)
        {
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = sum(CustomerStaging.user_wallet where(site_user_id = field("No.")));

        }
        field(50008; Credit_Admin_Remark; Decimal)
        {
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = sum(CustomerStaging.credit_admin_remark where(site_user_id = field("No.")));
        }
        field(50007; wallet_credit_reason; Code[260])//Nkp--Change Datattype Decimal to Code suggest by sunny
        {
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = lookup(CustomerStaging.wallet_credit_reason where(site_user_id = field("No.")));

        }
        field(50009; Status; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; Added_by; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; Modified_by; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; Is_Deleted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; Tier_Type; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; Total_Purchase_Amount; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Purchase Amount';
        }
        field(50015; "Passport No."; Code[25])
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "RPro Code"; Code[25])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Advance Available"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("LSC Voucher Entries".Amount where("Customer No." = field("No."), "Customer Advance Data Entry" = filter(true), Voided = filter(false)));
        }
        // modify("Phone No.")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         Cust: Record Customer;
        //     begin
        //         Cust.Reset();
        //         Cust.SetRange("Phone No.", "Phone No.");
        //         if Cust.FindFirst() then
        //             Error('Entered Phone Number Allready Exits');



        //     end;
        // }
        modify("Country/Region Code")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                cust: Record Customer;
            begin
                if "Country/Region Code" = 'IN' then begin

                    "Gen. Bus. Posting Group" := 'DOMESTIC';

                    "Customer Posting Group" := 'DOMESTIC';
                end
                else begin
                    "Gen. Bus. Posting Group" := 'EXPORT';
                    "Customer Posting Group" := 'EXPORT';
                end;
            end;
        }

    }
    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Country/Region Code" := 'IN';
        "Gen. Bus. Posting Group" := 'DOMESTIC';
        "Customer Posting Group" := 'DOMESTIC';

    end;



    var
        myInt: Integer;
}