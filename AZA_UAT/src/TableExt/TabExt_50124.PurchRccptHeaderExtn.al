tableextension 50124 PurchrcptheaderExtn extends "Purch. Rcpt. Header"
{
    fields
    {

    }
    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin
        RecLscRetail.Get(UserId);
        Validate("Location Code", RecLscRetail."Location Code");

    end;

    var
        myInt: Integer;
        RecLLoc: Record Location;
        RecLscRetail: Record "LSC Retail User";
}
