page 50141 "Trans. Infocode Entry"
{
    ApplicationArea = All;
    Caption = 'Trans. Infocode Entry';
    PageType = List;
    SourceTable = "LSC Trans. Infocode Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Amount; Rec.Amount)
                {
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Amount field.';
                }
                field(Counter; Rec.Counter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Counter field.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amount field.';
                }
                field("Entry Line No."; Rec."Entry Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Line No. field.';
                }
                field("Entry Trigger Code"; Rec."Entry Trigger Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Trigger Code field.';
                }
                field("Entry Trigger Function"; Rec."Entry Trigger Function")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Trigger Function field.';
                }
                field("Entry Variant Code"; Rec."Entry Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Variant Code field.';
                }
                field("Info. Amt."; Rec."Info. Amt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Info. Amt. field.';
                }
                field(Infocode; Rec.Infocode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Infocode field.';
                }
                field(Information; Rec.Information)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Information field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
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
                field("Parent Line"; Rec."Parent Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parent Line field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
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
                field("Selected Quantity"; Rec."Selected Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Selected Quantity field.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Code field.';
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
                field(Subcode; Rec.Subcode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Subcode field.';
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
                field("Text Type"; Rec."Text Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Text Type field.';
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field("Trans. Amount"; Rec."Trans. Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Amount field.';
                }
                field("Trans. Discount Amount"; Rec."Trans. Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Discount Amount field.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Type of Input"; Rec."Type of Input")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Input field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
            }
        }
    }
}
