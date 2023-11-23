tableextension 50146 GenLedSetup_Ext extends "General Ledger Setup"
{
    fields
    {
        field(50000; "E-Invoice IRN Generation URL"; Text[75]) { DataClassification = ToBeClassified; }
        field(50001; "E_Way Bill URL"; Text[75]) { DataClassification = ToBeClassified; }
        field(50002; "Cancel E-Invoice URL"; Text[75]) { DataClassification = ToBeClassified; }
        field(50003; "Cancel E-Way Bill"; Text[75]) { DataClassification = ToBeClassified; }
        field(50004; "E-Invoice Auth URL"; Text[75]) { DataClassification = ToBeClassified; }
        field(50005; "Enable E-Invoice POS"; Boolean) { DataClassification = ToBeClassified; }

    }

    var
        myInt: Integer;
}