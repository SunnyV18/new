pageextension 50139 VendorBankAccCardExtn extends "Vendor Bank Account Card"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field("Bank Account Name"; Rec."Bank Account Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
