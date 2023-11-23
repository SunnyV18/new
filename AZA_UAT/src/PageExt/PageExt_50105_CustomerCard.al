pageextension 50105 CustomerCardExtAZA extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("P.A.N. No.")
        {
            field("Adhaar No."; Rec."Adhaar No.")
            {
                ApplicationArea = all;
            }
            field("Passport No."; Rec."Passport No.") { ApplicationArea = all; }
            field("RPro Code"; "RPro Code") { ApplicationArea = All; }
        }
        addafter(Payments)
        {
            group("Aza Attributes")
            {
                field(user_credit; user_credit)
                {
                    ApplicationArea = All;
                }
                field(user_wallet; user_wallet)
                {
                    ApplicationArea = All;
                }
                field(Credit_Admin_Remark; Credit_Admin_Remark)
                {
                    ApplicationArea = All;
                }
                field(wallet_credit_reason; wallet_credit_reason)
                {
                    ApplicationArea = All;
                }
            }
        }
        modify("No.")
        {
            ShowMandatory = true;

        }
        modify(Name)
        {
            ShowMandatory = true;

        }

    }

    actions
    {
        addafter("Co&mments")
        {
            action(Advance)
            {
                ApplicationArea = all;
                Caption = 'Advance';
                Image = Open;
                trigger OnAction()
                var
                    AZAvoucherEnt: Record "LSC Voucher Entries";
                begin
                    AZAvoucherEnt.CalcFields("Customer No.");
                    AZAvoucherEnt.Reset();
                    AZAvoucherEnt.SetRange("Customer No.", Rec."No.");
                    Page.Run(Page::"Aza Voucher Entries", AZAvoucherEnt);
                end;
            }
        }
    }


    var
        myInt: Integer;
}