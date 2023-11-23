pageextension 50149 PExtpostePurchasereturn extends "Purchase Return Order"
{
    layout
    {

        addafter(Status)
        {
            field("PO No."; "PO No.")
            {
                Caption = 'Purchase Order No.';
                Editable = false;
                ApplicationArea = All;

            }
            field("RTV Reason"; Rec."RTV Reason")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor Cr. Memo No.")
        {
            field(Alteration; Rec.Alteration)
            {
                ApplicationArea = all;
            }
        }
        addafter(Alteration)
        {
            field("New Purchase Order No."; Rec."New Purchase Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Assigned User ID")
        {
            field(Merchandiser; Merchandiser)
            {
                ApplicationArea = All;

            }
            field("Return Shipment No."; "Return Shipment No.")
            {
                ApplicationArea = All;

            }
        }
        modify("No.")
        {
            Visible = true;
        }

    }

    actions
    {
        addafter(Dimensions)
        {
            action("RTV")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'RTV';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                //PromotedCategory = Category6;
                PromotedCategory = Category10;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader := Rec;
                    PurchaseHeader.SetRecFilter();
                    Report.RunModal(Report::"RTV Report", true, true, PurchaseHeader);
                end;
            }
        }
        modify(PostAndPrint)
        {
            Visible = false;
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        RetailUser: Record "LSC Retail User";
    begin
        RetailUser.Get(UserId);
        RetailUser.TestField("Location Code");
        Rec."Location Code" := RetailUser."Location Code";
    end;

    var
        myInt: Integer;
}