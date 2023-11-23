tableextension 50144 IncExpExt extends "LSC Income/Expense Account"
{
    fields
    {
        field(50000; "Alteration Account"; Boolean) { DataClassification = ToBeClassified; }
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}