tableextension 50120 SalesCrMemoHdrExt extends "Sales Cr.Memo Header"
{
    fields
    {
        // Add changes to table fields here
        field(50001; Dimensions; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Gross Wt."; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Net Weight"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Country of Origin"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Country of Final Destination"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "IGST Payment Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Not Applicable","LUT or Export under Bond","Export Against Payment of IGST";
            OptionCaption = ' ,Not Applicable, LUT or Export under Bond, Export Against Payment of IGST';
        }
    }

    var
        myInt: Integer;
}