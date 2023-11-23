pageextension 50114 TransactionRegisterExt extends "LSC Transaction Register"
{

    layout
    {
        addafter("Customer Order ID")
        {
            field("Aza Posting No."; Rec."Aza Posting No.") { ApplicationArea = all; }
            field("LSCIN GST Amount"; "LSCIN GST Amount") { ApplicationArea = aLL; }
            field(Information; Information) { ApplicationArea = all; }
            field("ADV CODE"; "ADV CODE") { ApplicationArea = all; }
        }
        addafter("Customer No.")
        {
            field("Customer Name"; "Customer Name")
            { ApplicationArea = All; }//KKS- 07/08/2023
        }
    }

    actions
    {
        addafter("&Print")
        {
            action("E-Invoice")
            {
                Caption = 'Generate E-Invoice';
                ApplicationArea = all;
                Image = Print;
                PromotedCategory = Process;
                // Visible = Rec."Sale Is Return Sale" <> true;
                Promoted = true;
                trigger OnAction()
                var
                    cuSalesEInvoice: codeunit E_Invoice_TaxInv;
                begin
                    cuSalesEInvoice.GenerateIRN_01(Rec);
                end;
            }
            action("E-Invoice Cancel")
            {
                Caption = 'Cancel E-Invoice';
                ApplicationArea = all;
                Image = Cancel;
                PromotedCategory = Process;
                // Visible = Rec."Sale Is Return Sale" <> true;
                Promoted = true;
                trigger OnAction()
                var
                    cuSalesEInvoice: codeunit E_Invoice_TaxInv;
                begin
                    cuSalesEInvoice.CancellIRN_01(Rec);
                end;
            }
            action(UpdateDataEntry)
            {
                ApplicationArea = All;
                Caption = 'Update Data Entry';
                Image = UpdateDescription;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                begin
                    UpdateDataEntries();
                end;
            }

            // Add changes to page actions here
        }

    }

    var
        myInt: Integer;
    // RecLscRetail: Record "LSC Retail User";
    //KKS- 07/08/2023
    local procedure UpdateDataEntries()
    var
        CustomerL: Record Customer;
        TransHeader: Record "LSC Transaction Header";
        DataEntryType: Record "LSC POS Data Entry Type";
        DataEntry: Record "LSC POS Data Entry";
        VoucherEntry: Record "LSC Voucher Entries";
        TransSalesEntry: Record "LSC Trans. Sales Entry";
        Staff: Record "LSC Staff";
    begin
        TransHeader.Reset();
        TransHeader.SetFilter("Customer No.", '<>%1', '');
        IF TransHeader.FindSet() then
            repeat
                IF CustomerL.Get(TransHeader."Customer No.") then begin
                    TransHeader."Customer Name" := CustomerL.Name;
                    TransHeader.Modify();
                    DataEntry.SetRange("Created in Store No.", TransHeader."Store No.");
                    DataEntry.SetRange("Created by Receipt No.", TransHeader."Receipt No.");
                    IF DataEntry.FindSet() then
                        repeat
                            IF DataEntryType.Get(DataEntry."Entry Type") then;
                            IF TransSalesEntry.Get(TransHeader."Store No.", TransHeader."POS Terminal No.", TransHeader."Transaction No.", DataEntry."Created by Line No.") then;
                            IF Staff.Get(TransSalesEntry."Sales Staff") then;
                            DataEntry."Customer Advance Data Entry" := DataEntryType."Customer Advance Data Entry";
                            DataEntry."Customer No." := TransHeader."Customer No.";
                            DataEntry."Customer Name" := CustomerL.Name;
                            DataEntry."Customer Phone No." := CustomerL."Phone No.";
                            DataEntry."Sales Staff" := Staff.ID;
                            DataEntry."Sales Staff Name" := Staff."First Name";
                            DataEntry.Modify();
                            VoucherEntry.Reset();
                            VoucherEntry.SetRange("Voucher Type", DataEntry."Entry Type");
                            VoucherEntry.SetRange("Voucher No.", DataEntry."Entry Code");
                            VoucherEntry.ModifyAll("Customer No.", DataEntry."Customer No.");
                            VoucherEntry.ModifyAll("Customer Name", DataEntry."Customer Name");
                            VoucherEntry.ModifyAll("Sales Staff", DataEntry."Sales Staff");
                            VoucherEntry.ModifyAll("Customer Advance Data Entry", DataEntry."Customer Advance Data Entry");
                            VoucherEntry.ModifyAll("Sales Staff Name", DataEntry."Sales Staff Name");
                            VoucherEntry.ModifyAll("Customer Phone No.", DataEntry."Customer Phone No.");
                        until DataEntry.Next() = 0
                end;
            until TransHeader.Next() = 0;
    end;
    //KKS+ 07/08/2023
}