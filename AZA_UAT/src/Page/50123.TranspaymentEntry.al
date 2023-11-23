page 50123 "Trans. payment Entry store"
{
    ApplicationArea = All;
    Caption = 'Trans. payment Entry store';
    PageType = List;
    SourceTable = "LSC Trans. Payment Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Card No."; Rec."Card No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card No. field.';
                }
                field("Card or Account"; Rec."Card or Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card or Account field.';
                }
                field("Change Line"; Rec."Change Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Change Line field.';
                }
                field(Counter; Rec.Counter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Counter field.';
                }
                field("Created by Staff ID"; Rec."Created by Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created by Staff ID field.';
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
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Managers Key Live"; Rec."Managers Key Live")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Managers Key Live field.';
                }
                field("Message No."; Rec."Message No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Message No. field.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order No. field.';
                }
                field("POS Terminal No."; Rec."POS Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Terminal No. field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
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
                field("Safe type"; Rec."Safe type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Safe type field.';
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
                field("Tender Decl. ID"; Rec."Tender Decl. ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tender Decl. ID field.';
                }
                field("Tender Type"; Rec."Tender Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tender Type field.';
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field("Trans. Date"; Rec."Trans. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Date field.';
                }
                field("Trans. Time"; Rec."Trans. Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Time field.';
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
                field("Amount Tendered"; Rec."Amount Tendered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Tendered field.';
                }
                field("Amount in Currency"; Rec."Amount in Currency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount in Currency field.';
                }
            }
        }
    }
}
