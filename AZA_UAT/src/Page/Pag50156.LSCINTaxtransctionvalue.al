page 50164 "LSCIN Tax transction value"
{
    Caption = 'LSCIN Tax transction value';
    PageType = Worksheet;
    SourceTable = "LSCIN Tax Transaction Value";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                }
                field("Case ID"; Rec."Case ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case ID field.';
                }
                field("Column Name"; Rec."Column Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Column Name field.';
                }
                field("Column Value"; Rec."Column Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Column Value field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field("Option Index"; Rec."Option Index")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Option Index field.';
                }
                field("POS Terminal No."; Rec."POS Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Terminal No. field.';
                }
                field(Percent; Rec.Percent)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percent field.';
                }
                field("Sales Return"; Rec."Sales Return")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Return field.';
                }
                field("Store No."; Rec."Store No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store No. field.';
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
                field("Tax Record ID"; Rec."Tax Record ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Record ID field.';
                }
                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Type field.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
                field("Value ID"; Rec."Value ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value ID field.';
                }
                field("Value Type"; Rec."Value Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value Type field.';
                }
                field("Visible on Interface"; Rec."Visible on Interface")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Visible on Interface field.';
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
