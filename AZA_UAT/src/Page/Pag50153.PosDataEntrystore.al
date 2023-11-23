page 50156 "Pos Data Entry store "
{
    Caption = 'Pos Data Entry store ';
    PageType = Worksheet;
    SourceTable = "LSC POS Data Entry";
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
                    ToolTip = 'Specifies the amount assigned to the data entry. For example, the field can contain the value of an issued gift card.';
                }
                field(Applied; Rec.Applied)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this data entry has already been applied, and is therefore no longer open.';
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Applied Amount field.';
                }
                field("Applied by Line No."; Rec."Applied by Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the line on the Applied by Receipt No. the data entry was applied in.';
                }
                field("Applied by Receipt No."; Rec."Applied by Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the receipt on which the data entry code was applied.';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact No. field.';
                }
                field("Created by Line No."; Rec."Created by Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the line on the Created by Receipt No. that the data entry was created in.';
                }
                field("Created by Receipt No."; Rec."Created by Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the receipt on which the data entry code created was printed.';
                }
                field("Created in Store No."; Rec."Created in Store No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the store in which the data entry was created.';
                }
                field("Data Entry Balance"; Rec."Data Entry Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Data Entry Balance field.';
                }
                field("Data Entry Expiring Date"; Rec."Data Entry Expiring Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Data Entry Expiring Date field.';
                }
                field("Date Applied"; Rec."Date Applied")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the application date of the data entry. The system inserts this date automatically.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creation date of the data entry. The system inserts this date automatically.';
                }
                field("Entry Code"; Rec."Entry Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry code for this data entry.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field("Expiring Date"; Rec."Expiring Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the information on when the Gift Registration/Voucher expires.';
                }
                field("Replication Counter"; Rec."Replication Counter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Replication Counter field.';
                }
                field("Reserverd By POS No."; Rec."Reserverd By POS No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reserverd By POS No. field.';
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
                field("Voucher Remaining Amount"; Rec."Voucher Remaining Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount remaining of the original voucher value in an open entry.';
                }
                field("Voucher Remaining Amount (Int)"; Rec."Voucher Remaining Amount (Int)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Voucher Remaining Amount (Int) field.';
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
