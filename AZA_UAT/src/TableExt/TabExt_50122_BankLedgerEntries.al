tableextension 50122 BankLedgerEntriesext extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "AZA Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; BarCode; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
        myInt: Integer;
}