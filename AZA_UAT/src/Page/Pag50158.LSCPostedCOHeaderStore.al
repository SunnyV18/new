page 50158 "LSC Posted CO Payment Store"
{
    Caption = 'LSC Posted CO Payment Store';
    PageType = Worksheet;
    SourceTable = "LSC Posted CO Payment";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Authorization Code"; Rec."Authorization Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Authorization Code field.';
                }
                field("Authorization Expired"; Rec."Authorization Expired")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Authorization Expired field.';
                }
                field("Card Type"; Rec."Card Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card Type field.';
                }
                field("Card or Customer No."; Rec."Card or Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card or Customer No. field.';
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created field.';
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
                field("Deposit Payment"; Rec."Deposit Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deposit Payment field.';
                }
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document ID field.';
                }
                field("External Reference"; Rec."External Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Reference field.';
                }
                field("Finalized Amount"; Rec."Finalized Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finalized Amount field.';
                }
                field("Finalized Amount LCY"; Rec."Finalized Amount LCY")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finalized Amount LCY field.';
                }
                field("Income/Expense Account No."; Rec."Income/Expense Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Income/Expense Account No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Loyalty Point Payment"; Rec."Loyalty Point Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loyalty Point Payment field.';
                }
                field("Original Tender Type"; Rec."Original Tender Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Tender Type field.';
                }
                field("PosTrans Receipt No."; Rec."PosTrans Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PosTrans Receipt No. field.';
                }
                field("Pre Approved Amount"; Rec."Pre Approved Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pre Approved Payment Amount field.';
                }
                field("Pre Approved Amount LCY"; Rec."Pre Approved Amount LCY")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pre Approved Amount LCY field.';
                }
                field("Pre Approved Valid Date"; Rec."Pre Approved Valid Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pre Approval Valid Date field.';
                }
                field(Refunded; Rec.Refunded)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refunded field.';
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
                field("Tender Type"; Rec."Tender Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tender Type field.';
                }
                field("Token No."; Rec."Token No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Token No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
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

