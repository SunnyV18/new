tableextension 50126 RetailSetupExt extends "LSC Retail Setup"
{
    fields
    {
        field(50000; "Sales API"; Text[100]) { DataClassification = ToBeClassified; }
        field(50001; "Sales Return API"; Text[100]) { DataClassification = ToBeClassified; }
        field(50002; "Transfer Order API"; Text[100]) { DataClassification = ToBeClassified; }
        field(50003; "Loyalty Points Add"; Text[100]) { DataClassification = ToBeClassified; }
        field(50004; "Loyalty Points Deduct"; Text[100]) { DataClassification = ToBeClassified; }

        field(50005; "Loyalty Points Get"; Text[100]) { DataClassification = ToBeClassified; }
        field(50006; "Enable SMS Integration"; Boolean) { DataClassification = ToBeClassified; }
        field(50007; "API Token"; Text[100]) { DataClassification = ToBeClassified; }

        // field(50006;"Sales API";Text[100]){DataClassification=ToBeClassified;}
        // Add changes to table fields here
        //SK++
        field(50008; "Allow Manual Blocking"; Boolean)
        {
            Caption = 'Allow Manual Inventory Blocking';
        }
        //SK--
        field(50009; "Enable Mail Setup"; Boolean) { DataClassification = ToBeClassified; }
        field(50010; "Invoice Reference API"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "S3 Bucket Name"; text[50]) { DataClassification = ToBeClassified; }
        field(50012; "Sales Invoice Directory"; Text[100]) { DataClassification = ToBeClassified; }
        field(50013; "Store PUT API"; text[100]) { dataclassification = tobeclassified; }
        field(50014; "Remove Misc. Pmt. Lines"; Boolean) { DataClassification = ToBeClassified; }
    }

    var
        myInt: Integer;
}