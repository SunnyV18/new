tableextension 50143 "GST Group Ext" extends "GST Group"
{
    fields
    {
        field(50001; "GST %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}