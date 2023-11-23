tableextension 50152 RetShipmentLineExt extends "Return Shipment Line"
{
    fields
    {
        field(50100; "Unit Price"; Decimal) { DataClassification = ToBeClassified; }
        field(50101; Amount; Decimal) { DataClassification = ToBeClassified; }
        // Add changes to table fields here\
       
    }

    var
        myInt: Integer;
}