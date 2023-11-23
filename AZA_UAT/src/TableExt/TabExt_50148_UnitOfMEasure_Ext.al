tableextension 50148 AddGSTUOM_EInv extends "Unit of Measure"
{
    fields
    {
        field(50111; "E-Inv UOM"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "GST Reporting UQC"; code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}