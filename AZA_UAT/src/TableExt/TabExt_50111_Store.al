tableextension 50111 StoreTabelExt extends "LSC Store"
{
    fields
    {
        field(50000; "Email id"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Sales Posting No. Series"; Code[16])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50002; "Sales Ret. Posting No. Series"; Code[16])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50003; "Cust. Adv. Posting No. Series"; Code[16])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50004; "Cust. Order No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50005; "Transfer Order No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50006; "Purchase Order No. Series"; code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50007; "Return Order No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50008; "Purchase Receipt No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50009; "Dummy Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(50010; "Email2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Posted Purchase Return Shipment"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50012; "Transfer Shipment"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50013; "Transfer Recipt"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

    }

    var
        myInt: Integer;
}
