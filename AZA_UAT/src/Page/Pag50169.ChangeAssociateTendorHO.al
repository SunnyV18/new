page 50169 "Change Associate-Tendor HO"
{
    Caption = 'Change Associate-Tendor HO';
    PageType = Card;
    SourceTable = "Change Associate- Tendor HO";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }

                field("Old Staff"; Rec."Old Staff")
                {
                    ApplicationArea = All;
                }
                field("New Staff"; Rec."New Staff")
                {
                    ApplicationArea = All;
                }
                field("Document Id"; Rec."Document Id")
                {
                    ApplicationArea = All;
                }
                field("Old Tendor"; Rec."Old Tender")
                {
                    ApplicationArea = All;
                }
                field("New Tendor"; Rec."New Tender")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OK)
            {
                ApplicationArea = All;
                Caption = 'OK';
                Image = Completed;

                trigger OnAction();
                var
                    TransPaymentEnt: Record "LSC Trans. Payment Entry";
                    CustOrdLine: Record "LSC Customer Order Line";
                    LscTransSalEnt: Record "LSC Trans. Sales Entry";
                    TransHdr: Record "LSC Transaction Header";
                    CustOrdPaymentEnt: Record "LSC Customer Order Payment";
                begin
                    Rec.TestField("Document Id");
                    if (Rec."Old Staff" <> '') or (Rec."New Staff" <> '') then
                        if (Rec."Old Tender" <> '') or (Rec."New Tender" <> '') then
                            Error('You can update Only Staff Or Only Tendor at a time');
                    if (Rec."Old Staff" <> '') AND (Rec."New Staff" = '') then
                        Error('Please enter value in New Staff');
                    if (Rec."Old Staff" = '') AND (Rec."New Staff" <> '') then
                        Error('Please enter value in Old Staff');
                    if (Rec."Old Tender" <> '') AND (Rec."New Tender" = '') then
                        Error('Please enter value in New Staff');
                    if (Rec."Old Tender" = '') AND (Rec."New Tender" <> '') then
                        Error('Please enter value in Old Staff');


                    //>>>>>>>>>>
                    if Rec."Transaction Type" = Rec."Transaction Type"::"Tax Invoice" then begin
                        LscTransSalEnt.Reset();
                        LscTransSalEnt.SetRange("Receipt No.", Rec."Document Id");
                        if LscTransSalEnt.FindSet() then
                            repeat
                                if Rec."New Staff" <> '' then
                                    LscTransSalEnt."Sales Staff" := Rec."New Staff";
                                LscTransSalEnt.Modify();
                            until LscTransSalEnt.Next() = 0;
                        TransPaymentEnt.Reset();
                        TransPaymentEnt.SetRange("Receipt No.", Rec."Document Id");
                        if TransPaymentEnt.FindSet() then
                            repeat
                                if Rec."New Tender" <> '' then
                                    TransPaymentEnt."Tender Type" := Rec."New Tender";
                                TransPaymentEnt.Modify();
                            until TransPaymentEnt.Next() = 0;
                    end;

                    //For Customer Orders>>>>>>>>>>>>>>>
                    if Rec."Transaction Type" = Rec."Transaction Type"::"Customer Order" then begin
                        if Rec."New Staff" <> '' then begin
                            CustOrdLine.Reset();
                            CustOrdLine.SetRange("Document Id", Rec."Document Id");
                            if CustOrdLine.FindSet() then
                                repeat
                                    CustOrdLine."POS Sales Associate" := Rec."New Staff";
                                    CustOrdLine.Modify();
                                until CustOrdLine.Next() = 0;
                        end;
                        if Rec."New Tender" <> '' then begin
                            CustOrdPaymentEnt.Reset();
                            CustOrdPaymentEnt.SetRange("Document ID", Rec."Document Id");
                            if CustOrdPaymentEnt.FindLast() then begin
                                CustOrdPaymentEnt."Tender Type" := Rec."New Tender";
                                CustOrdPaymentEnt.Modify();
                            end;
                            TransHdr.Reset();
                            TransHdr.SetRange("Customer Order ID", Rec."Document Id");
                            if TransHdr.FindLast() then begin
                                TransPaymentEnt.Reset();
                                TransPaymentEnt.SetRange("Receipt No.", TransHdr."Receipt No.");
                                if TransPaymentEnt.FindFirst() then begin
                                    TransPaymentEnt."Tender Type" := Rec."New Tender";
                                    TransPaymentEnt.Modify();
                                end;
                            end;
                        end;
                    end;

                end;
            }
        }
    }
}
