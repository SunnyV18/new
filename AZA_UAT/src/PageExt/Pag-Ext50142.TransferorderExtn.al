pageextension 50142 TransferorderExtn extends "Transfer Orders"
{
    layout
    {
        addafter(Status)
        {
            field("Posting Date"; "Posting Date") { ApplicationArea = All; }
            field(SystemCreatedAt; SystemCreatedAt) { ApplicationArea = All; }
        }
    }
    actions
    {
        modify(PostAndPrint)
        {
            Visible = false;
        }
    }
}
