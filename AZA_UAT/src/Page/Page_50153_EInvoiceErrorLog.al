page 50153 "E-Invoice Error Log"
{
    Editable = false;
    PageType = List;
    SourceTable = 50168;
    ApplicationArea = List;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Creation DateTime"; Rec."Creation DateTime")
                {
                    ApplicationArea = All;
                }
                field(Message; Rec.GetErrorMessage)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Get E-Invoice")
            {
                ApplicationArea = All;
                Image = "Action";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    //Einvoice: Codeunit 50048; //BCUpgrade_CodeComment
                    Invoice: Record 112;
                    Cmemo: Record 114;
                    Location: Record 14;
                begin

                    IF Rec."Document Type" = Rec."Document Type"::Invoice THEN BEGIN
                        IF Invoice.GET(Rec."Document No.") THEN
                            Location.GET(Invoice."Location Code");
                        //Einvoice.GetEInvoice(Rec."IRN No", Location."GST Registration No.", Location."Owner Id", Rec."Document No.", 0); //BCUpgrade_CodeComment
                    END ELSE
                        IF Rec."Document Type" = Rec."Document Type"::CrMemo THEN BEGIN
                            IF Cmemo.GET(Rec."Document No.") THEN
                                Location.GET(Invoice."Location Code");
                            //Einvoice.GetEInvoice(Rec."IRN No", Location."GST Registration No.", Location."Owner Id", Rec."Document No.", 1); //BCUpgrade_CodeComment
                        END;
                end;
            }
        }
    }
}

