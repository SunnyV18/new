tableextension 50130 PosTransactionExt extends "LSC POS Transaction"
{
    fields
    {
        field(50001; Isadvance; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Partial Payment"; Boolean) { DataClassification = CustomerContent; }
        field(50003; "CO Refund Lines"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("LSC POS Trans. Line"."CO Refund Line" where("Receipt No." = Field("Receipt No.")));
        }
        field(50004; "Cust. Phone No."; Code[12]) { DataClassification = ToBeClassified; }
        field(50005; "Partial Cancel Refund"; Boolean) { DataClassification = ToBeClassified; }
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}