tableextension 50132 Purchpayblesetupext extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; ALTNoseries; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    var
        myInt: Integer;
}