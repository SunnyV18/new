tableextension 50106 TransactionHeaderExt extends "LSC Transaction Header"
{
    fields
    {
        field(50000; "Aza Posting No."; Code[30]) { DataClassification = ToBeClassified; }
        // Add changes to table fields here
        field(50001; Isadvance; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "IRN Hash"; Code[64]) { DataClassification = ToBeClassified; }
        field(50004; "Acknowledgement No."; Text[75]) { DataClassification = ToBeClassified; }
        field(50005; "Acknowledgement Date"; DateTime) { DataClassification = ToBeClassified; }
        field(50006; "QR Code"; blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
            Description = 'CITS_RS E-Invoice';

        }
        field(50007; "Cust. Phone No."; Code[12]) { DataClassification = ToBeClassified; }
        field(50008; "Customer Name"; Text[100])//KKS- 07/08/2023
        { }
        field(50009; "Cancel IRN Hash"; Code[64]) { DataClassification = ToBeClassified; }
        field(50010; "Cancel IRN Date"; DateTime) { DataClassification = ToBeClassified; }
        field(50013; "Irn Cancelled"; Boolean) { DataClassification = ToBeClassified; }
        field(50011; Information; Text[100])
        {
            Caption = 'Information';
            FieldClass = FlowField;
            CalcFormula = lookup("LSC Trans. Infocode Entry".Information where("Transaction No." = field("Transaction No."), "Store No." = field("Store No."), "POS Terminal No." = field("POS Terminal No."), "Text Type" = const("Freetext Input")));
        }
        field(50012; "ADV CODE"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("LSC Trans. Infocode Entry".Information where("Transaction No." = field("Transaction No."), "Store No." = field("Store No."), "POS Terminal No." = field("POS Terminal No."), Infocode = const('ADVANCECODE')));
        }

    }

    var
        myInt: Integer;


}