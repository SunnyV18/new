tableextension 50121 GenJournalLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "AZA Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; BarCode; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}