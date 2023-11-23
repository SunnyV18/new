tableextension 50150 "Purchase credit Memo Hed Ext" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50021; "RTV Reason"; Option)
        {
            OptionMembers = " ","For Alteration","Asked By Designer","For Sourcing","Consignment Return (RTV Permanent)","For Order Refernce",Others;
            Editable = false;
        }
        field(50023; Merchandiser; text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    var
        myInt: Integer;
}