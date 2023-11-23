pageextension 50107 PExtpostePurchaseCreditmemo extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter("Order Address Code")
        {
            field("RTV Reason"; Rec."RTV Reason")
            {
                ApplicationArea = all;
            }
            field(Merchandiser; Rec.Merchandiser)
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        addafter(Dimensions)
        {
            action("Debit Note")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Debit Note';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PurchaseHeader: Record "Purch. Cr. Memo Hdr.";
                begin
                    PurchaseHeader := Rec;
                    PurchaseHeader.SetRecFilter();
                    Report.RunModal(Report::"Debit Note", true, true, PurchaseHeader);
                end;
            }
        }
    }

    var
        myInt: Integer;
}