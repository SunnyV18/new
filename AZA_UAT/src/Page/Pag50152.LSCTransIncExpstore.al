page 50152 "LSC Trans. Inc./Exp. store"
{
    Caption = 'LSC Trans. Inc./Exp. store';
    PageType = Worksheet;
    SourceTable = "LSC Trans. Inc./Exp. Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount in Currency"; Rec."Amount in Currency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount in Currency field.';
                }
                field(Counter; Rec.Counter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Counter field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                }
                field("LSCIN Exempted"; Rec."LSCIN Exempted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exempted field.';
                }
                field("LSCIN GST Amount"; Rec."LSCIN GST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Amount field.';
                }
                field("LSCIN GST Group Code"; Rec."LSCIN GST Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Group Code field.';
                }
                field("LSCIN GST Group Type"; Rec."LSCIN GST Group Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Group Type field.';
                }
                field("LSCIN GST Jurisdiction Type"; Rec."LSCIN GST Jurisdiction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Jurisdiction Type field.';
                }
                field("LSCIN HSN/SAC Code"; Rec."LSCIN HSN/SAC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSN/SAC Code field.';
                }
                field("LSCIN Net Price"; Rec."LSCIN Net Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Price field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Amount field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("POS Terminal No."; Rec."POS Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Terminal No. field.';
                }
                field("Package Parent Line No."; Rec."Package Parent Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Package Parent Line No. field.';
                }
                field("Receipt  No."; Rec."Receipt  No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt  No. field.';
                }
                field(Replicated; Rec.Replicated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Replicated field.';
                }
                field("Replication Counter"; Rec."Replication Counter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Replication Counter field.';
                }
                field("Retail Charge Code"; Rec."Retail Charge Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Retail Charge Code field.';
                }
                field("Sales Tax Rounding"; Rec."Sales Tax Rounding")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Tax Rounding field.';
                }
                field("Shift Date"; Rec."Shift Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift Date field.';
                }
                field("Shift No."; Rec."Shift No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift No. field.';
                }
                field("Staff ID"; Rec."Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff ID field.';
                }
                field("Statement Code"; Rec."Statement Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Statement Code field.';
                }
                field("Statement No."; Rec."Statement No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Statement No. field.';
                }
                field("Store No."; Rec."Store No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store No. field.';
                }
                field("System-Exclude From Print"; Rec."System-Exclude From Print")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the System-Exclude From Print field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Group Code field.';
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
                field("Transaction Status"; Rec."Transaction Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Status field.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Amount field.';
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Calculation Type field.';
                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Code field.';
                }
                field("Y-Report ID"; Rec."Y-Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Y-Report ID field.';
                }
                field("Z-Report ID"; Rec."Z-Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Z-Report ID field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if usersetup.Get(UserId) then
            if usersetup."Edit Page" = false then
                CurrPage.Editable := false
            ELSE
                CurrPage.Editable := true;
    end;

    var
        usersetup: Record "LSC Retail User";
}
