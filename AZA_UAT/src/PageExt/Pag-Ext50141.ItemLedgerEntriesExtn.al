pageextension 50141 ItemLedgerEntriesExtn extends "Item Ledger Entries"
{
    layout
    {
        addafter(Quantity)
        {
            field("Item Category Code";"Item Category Code"){ApplicationArea=All;}
            field("LSC Retail Product Code";"LSC Retail Product Code"){ApplicationArea=All;}
            
        }
    }
}
