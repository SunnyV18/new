pageextension 50148 ItemJournalTemplatePExtn extends "Item Journal"
{
    trigger OnOpenPage()
    var
        myInt: Integer;
        usersetup: Record "LSC Retail User";
    begin
        usersetup.Get(UserId);
        if usersetup."POS Super User" = false then
            Error('This user is not authorized to access this Page');
    end;
}
