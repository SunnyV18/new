page 50146 "Aza Voucher Entries"
{
    ApplicationArea = All;
    Caption = 'Aza Voucher Entries';
    PageType = List;
    SourceTable = "LSC Voucher Entries";
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
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("One Time Redemption"; Rec."One Time Redemption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the One Time Redemption field.';
                }
                field("POS Terminal No."; Rec."POS Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Terminal No. field.';
                }
                field("Receipt Number"; Rec."Receipt Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Number field.';
                }
                field("Remaining Amount Now"; Rec."Remaining Amount Now")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remaining Amount Now field.';
                }
                field("Replication Counter"; Rec."Replication Counter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Replication Counter field.';
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
                field(Unposted; Rec.Unposted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unposted field.';
                }
                field(Voided; Rec.Voided)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Voided field.';
                }
                field("Voucher No."; Rec."Voucher No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Voucher No. field.';
                }
                field("Voucher Type"; Rec."Voucher Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Voucher Type field.';
                }
                field("Write Off Amount"; Rec."Write Off Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Write Off Amount field.';
                }
                field("Customer No."; "Customer No.")
                { ApplicationArea = All; }//KKS- 07/08/2023
                field("Customer Name"; "Customer Name")
                { ApplicationArea = All; }//KKS- 07/08/2023
                field("Customer Phone No."; Rec."Customer Phone No.")
                { ApplicationArea = All; }
                field("Sales Staff"; "Sales Staff")
                { ApplicationArea = All; }
                field("Sales Staff Name"; "Sales Staff Name")
                { ApplicationArea = All; }

            }
        }
    }
    //KKS- 07/08/2023
    trigger OnOpenPage()
    var
        CustomerL: Record Customer;
        TransHeader: Record "LSC Transaction Header";
    begin
        TransHeader.Reset();
        TransHeader.SetFilter("Customer No.", '<>%1', '');
        TransHeader.SetFilter("Customer Name", '%1', '');
        IF TransHeader.FindSet() then
            repeat
                IF CustomerL.Get(TransHeader."Customer No.") then begin
                    TransHeader."Customer Name" := CustomerL.Name;
                    TransHeader.Modify();
                end;
            until TransHeader.Next() = 0;
    end;
    //KKS+ 07/08/2023
}