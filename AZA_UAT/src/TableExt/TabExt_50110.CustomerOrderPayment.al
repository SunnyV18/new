tableextension 50110 "Customer Order Payment" extends "LSC Customer Order Payment"
{
    fields
    {
        field(50100; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(50000; "Parital Cancel Refund"; Boolean)
         { DataClassification = ToBeClassified; }

    }
    trigger OnAfterInsert()
    begin
        Rec.Date := Today;
        // Message('Date updated');
    end;
}
