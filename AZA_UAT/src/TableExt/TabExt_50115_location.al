tableextension 50115 "Location" extends Location
{
    fields
    {
        // Add changes to table fields here
        field(50000; "LUT Number"; Code[20]) { DataClassification = ToBeClassified; }
        field(50001; "fc_location ID"; integer) { DataClassification = TobeClassified; }
        field(50002; "Po Creation"; Boolean) { DataClassification = TobeClassified; }
    }

    var
        myInt: Integer;
}