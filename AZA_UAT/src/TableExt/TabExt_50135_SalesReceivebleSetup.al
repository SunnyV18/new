tableextension 50135 SalesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Salesperson No. Series"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Ship to Address no. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}