pageextension 50144 LSCRetailItemPExtn extends "LSC Retail Item Categories"
{
    layout
    {
        addafter(Description)
        {
            field(Abbreviation; Abbreviation) { ApplicationArea = All; }
        }
    }
}
