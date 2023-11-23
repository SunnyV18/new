pageextension 50127 StaffListExtn extends "LSC Staff List"
{
    layout
    {
        addafter("Manager Privileges")
        {
            field(Merchandiser; Merchandiser)
            {
                ApplicationArea = All;
            }
        }
    }
}
