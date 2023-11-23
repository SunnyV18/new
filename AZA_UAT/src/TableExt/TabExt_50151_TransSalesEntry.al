tableextension 50151 TransSalesEnExt extends "LSC Trans. Sales Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "CO Refund Line"; Boolean) { DataClassification = ToBeClassified; }
        field(50002; "Designer Name"; Text[100]) { DataClassification = ToBeClassified; }
        field(50003; "POS Comment"; Text[100]) { DataClassification = ToBeClassified; }
    }

    var
        myInt: Integer;
}