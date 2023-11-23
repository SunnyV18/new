pageextension 50147 VendorListExtn extends "Vendor List"
{
    layout
    {
        addafter(Name)
        {
            field("Designer Abbreviation"; "Designer Abbreviation") { ApplicationArea = All; }
        }
    }
}
