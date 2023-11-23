pageextension 50110 LscStaffstaffcardExtn extends "LSC STAFF Staff Card"
{
    layout
    {
        addafter(Language)
        {
            field(Merchandiser; Merchandiser)
            {
                ApplicationArea = All;
            }
        }
    }
}
