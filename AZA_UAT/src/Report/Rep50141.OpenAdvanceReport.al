report 50141 "Open Advance Report"
{
    ApplicationArea = All;
    Caption = 'Open Advance Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Open_Advance.rdl';
    dataset
    {
        dataitem(LSCVoucherEntries; "LSC Voucher Entries")
        {
            // RequestFilterFields = Date, "Store No.", "Entry Type";
            column(Amount; Amount)
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(CustomerPhoneNo; "Customer Phone No.")
            {
            }
            column(Date; "Date")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(RemainingAmountNow; "Remaining Amount Now")
            {
            }
            column(SalesStaff; "Sales Staff")
            {
            }
            column(StoreNo; "Store No.")
            {
            }
            column(VoucherNo; "Voucher No.")
            {
            }
            column(CreditNote; CreditNote) { }
            column(OpenAdvance; OpenAdvance) { }
            column(Cred; Cred) { }
            column(Voucher_Type; "Voucher Type") { }
            column(Comment1; Comment1) { }
            column(Comment2; Comment2) { }
            column(Comment3; Comment3) { }
            column(Receipt_Number; "Receipt Number") { }
            column(HdrBoo; HdrBoo) { }
            dataitem("Trans Customer Order Items"; "Trans Customer Order Items")
            {
                DataItemLink = "Receipt No." = field("Receipt Number");
                column(DesigName; "Designer Name") { }
                column(qty; Quantity) { }
                column(UnitPrice; Price) { }
                column(ItemNo; "Item No.") { }
                column(Designer_Abbreviation; "Designer Abbreviation") { }
                column(oldAzaCode; oldAzaCode) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(oldAzaCode);
                    RecItem.Reset();
                    RecItem.SetRange("No.", "Item No.");
                    if RecItem.FindFirst() then begin
                        oldAzaCode := RecItem.Old_aza_code;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                TransCusOrdItems: Record 50126;
            begin
                Clear(Comment1);
                Clear(Comment2);
                Clear(Comment3);
                LscInfocodeEntry.Reset();
                LscInfocodeEntry.SetRange("Transaction No.", "Transaction No.");
                LscInfocodeEntry.SetRange("Store No.", "Store No.");
                LscInfocodeEntry.SetRange("POS Terminal No.", "POS Terminal No.");
                LscInfocodeEntry.SetRange("Text Type", LscInfocodeEntry."Text Type"::"Freetext Input");
                if LscInfocodeEntry.FindSet() then
                    repeat
                        if Comment1 = '' then
                            Comment1 := LscInfocodeEntry.Information else
                            if Comment2 = '' then
                                Comment2 := LscInfocodeEntry.Information else
                                if Comment3 = '' then
                                    Comment3 := LscInfocodeEntry.Information;

                    until LscInfocodeEntry.Next() = 0;
                HdrBoo := false;
                TransCusOrdItems.Reset();
                TransCusOrdItems.SetRange("Receipt No.", LSCVoucherEntries."Receipt Number");
                if not TransCusOrdItems.FindFirst() then
                    HdrBoo := true;
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin

                LSCVoucherEntries.SetFilter("Store No.", storeNo);
                //LSCVoucherEntries.SetFilter("Voucher Type", VoucherType);
                if EndDate <> 0D then
                    LSCVoucherEntries.SetRange(Date, StartDate, EndDate) else
                    LSCVoucherEntries.SetRange(Date, StartDate);
                if RemaiVoucher = true then
                    LSCVoucherEntries.SetFilter("Remaining Amount Now", '<>%1', 0);
                // if Details = true then
                //     LSCVoucherEntries.SetFilter("Entry Type", '=%1|%2', LSCVoucherEntries."Entry Type"::Issued, LSCVoucherEntries."Entry Type"::Redemption);
                if OpenAdvance = true then
                    LSCVoucherEntries.SetFilter("Voucher Type", '=%1', 'ADVNO');
                if CreditNote = true then
                    LSCVoucherEntries.SetFilter("Voucher Type", '=%1', 'CREDITNOTE');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(CreditNote; CreditNote)
                    {
                        ApplicationArea = All;
                        Caption = 'Credit Note';
                        trigger OnValidate()
                        begin
                            OpenAdvance := false;
                        end;
                    }
                    field(OpenAdvance; OpenAdvance)
                    {
                        ApplicationArea = All;
                        Caption = 'Open Advance';
                        trigger OnValidate()
                        begin
                            CreditNote := false;
                        end;
                    }
                    field(RemaiVoucher; RemaiVoucher)
                    {
                        ApplicationArea = All;
                        Caption = 'Remaining Voucher';
                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            Details := false;
                        end;
                    }
                    field(storeNo; storeNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Store No.';
                        TableRelation = "LSC Store";
                        // Editable = false;

                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                    }

                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var

        storeNo: Text;
        HdrBoo: Boolean;
        StartDate: Date;
        EndDate: Date;
        Details: Boolean;
        RemaiVoucher: Boolean;
        Entr: Text;
        VoucherType: Label 'Voucher Type';
        Cred: Label 'Credit Note';
        OpenAdvance: Boolean;
        CreditNote: Boolean;
        LscInfocodeEntry: Record "LSC Trans. Infocode Entry";
        Comment1: Text[100];
        Comment2: text[100];
        Comment3: Text[100];
        POSCustomerOrderItem: Record "POS Customer Order Item";
        oldAzaCode: Code[30];
        RecItem: Record Item;
}
