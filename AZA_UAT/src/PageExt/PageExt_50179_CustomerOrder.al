pageextension 50179 CustomerOrderExt extends "LSC Customer Order"
{
    layout
    {
        addlast(General)
        {
            field("Partial Payment"; Rec."Partial Payment") { ApplicationArea = all; Editable = false; }
        }
        // Add changes to page layout here
    }

    actions
    {
        addafter("Cancel Order")
        {
            action("Change Sourcing Location")
            {
                Promoted = true;
                // PromotedIsBig = true;
                // PromotedCategory = 
                trigger OnAction()

                var
                    recCustOrderLine: Record "LSC Customer Order Line";
                    recRetailUser: Record "LSC Retail User";
                    cuFunctions: Codeunit Functions;
                begin
                    recCustOrderLine.Reset();
                    recCustOrderLine.SetRange("Document ID", Rec."Document ID");
                    if recCustOrderLine.Find('-') then
                        repeat
                            recCustOrderLine."Store No." := cuFunctions.GetRetailUserLoc();
                            recCustOrderLine."Sourcing Location" := cuFunctions.GetRetailUserLoc();
                            recCustOrderLine.Modify();
                            CurrPage.Update(false);
                        until recCustOrderLine.Next() = 0;
                    cuFunctions.SendMailNotification_CustomerOrder(Rec);//030323 CITS_RS
                end;
            }

        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}