tableextension 50107 TransferReceiptHeaderExt extends "Transfer Receipt Header"
{
    fields
    {
        field(50000; "Aza Posting No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }

        field(50150; "Transfer Reason"; Text[100])
        {
            //  OptionMembers = " ","Transfer For Client Trail ( Home Shopping)",Others;
            Editable = false;
        }
        field(50151; "Merchandiser"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(50152; "Total Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Receipt Line".Quantity where("Document No." = field("No.")));

        }
        field(50153; "Total Amt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Receipt Line".Amount where("Document No." = field("No.")));

        }
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}