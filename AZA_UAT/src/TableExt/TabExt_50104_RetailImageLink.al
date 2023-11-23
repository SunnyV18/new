tableextension 50104 RetailImage_Ext extends "LSC Retail Image"
{
    fields
    {
        field(50000; CustomImage2; Blob) { DataClassification = ToBeClassified; Subtype = Bitmap; }
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}