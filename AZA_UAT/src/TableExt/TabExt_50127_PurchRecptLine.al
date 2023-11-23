tableextension 50127 PostedPurchRecptLine extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50000; "Short Close"; Boolean) { DataClassification = ToBeClassified; }
        field(50001; "Damaged Qty"; Decimal) { DataClassification = ToBeClassified; }
        field(50002; "Fast Receive"; Boolean) { DataClassification = ToBeClassified; }
        field(50003; MRP; Decimal) { DataClassification = ToBeClassified; }
        field(50004; EditBool; Boolean) { DataClassification = ToBeClassified; }
        field(50005; "QC Action"; Enum "GRN Action Status Enum")
        {
            DataClassification = ToBeClassified;
            // ObsoleteReason = 'removed';
            // ObsoleteState = Removed;
        }
        // Add changes to table fields here
    }


    var
        myInt: Integer;
}