pageextension 50106 "Purch Recpt" extends "Posted Purchase Receipt"
{
    Caption = 'Goods Receipt Note';//010323 CITS_RS
    layout
    {
        // Add changes to page layout here



    }

    actions
    {
        addafter("&Print")
        {
            action("GRN Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'AZAGRNOrder';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category6;
                //PromotedCategory = Category10;
                //  Visible = Visible1;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PurchaHeader: Record "Purch. Rcpt. Header";
                begin
                    PurchaHeader := Rec;
                    PurchaHeader.SetRecFilter();
                    Report.RunModal(Report::"GRN Report", true, true, PurchaHeader);
                end;

            }
            action("GRN Report2")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'AZAGRN2';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category6;
                //PromotedCategory = Category10;
                //  Visible = Visible1;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PurchaHeader: Record "Purch. Rcpt. Header";
                begin
                    PurchaHeader := Rec;
                    PurchaHeader.SetRecFilter();
                    Report.RunModal(Report::"GRN Report2", true, true, PurchaHeader);
                end;

            }

            // Add changes to page actions here
        }
    }


    var
        myInt: Integer;

}