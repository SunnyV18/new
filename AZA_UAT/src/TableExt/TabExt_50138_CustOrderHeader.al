tableextension 50138 CustOrderHeaderExt extends "LSC Customer Order Header"
{
    fields
    {
        field(50000; "Partial Payment"; Boolean) { DataClassification = ToBeClassified; }
        field(50001; "GST Customer Type"; Enum "GST Customer Type") { DataClassification = ToBeClassified; }
        field(50002; "Balance Amount"; Decimal) { DataClassification = ToBeClassified; }
        field(50003; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(50004; "Canceled Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("LSC Customer Order Line"."LSCIN Unit Price Incl. of Tax" where("Document ID" = field("Document ID"), Status = const(Canceled)));
        }
        field(5005; "Total Remaining"; Decimal) { DataClassification = ToBeClassified; }

        // Add changes to table fields here
    }
    // trigger OnAfterInsert()
    // begin
    //     Rec.Date := Today;
    //     // Message('Date updated');
    // end;

    var
        myInt: Integer;
}