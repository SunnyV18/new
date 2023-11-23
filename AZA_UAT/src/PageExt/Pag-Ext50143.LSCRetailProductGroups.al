pageextension 50143 RetaProductGroupExtn extends "LSC Retail Product Groups"
{
    layout
    {
        addafter(Description)
        {
            field(Abbreviation; Abbreviation) { ApplicationArea = All; }
        }
    }
}
