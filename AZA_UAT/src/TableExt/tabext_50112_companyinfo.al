tableextension 50112 comapanyinfo extends "Company Information"
{
    fields
    {
        field(50000; "CIN No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "IEC Number"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "LUT Number"; code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}