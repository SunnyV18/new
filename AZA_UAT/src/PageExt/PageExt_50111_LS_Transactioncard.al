pageextension 50111 POSTranstionPage_Ext extends "LSC Transaction Card"
{
    layout
    {
        addbefore(Details)
        {
            group("Aza E-Invoice")
            {
                field("IRN Hash"; Rec."IRN Hash") { ApplicationArea = all; }
                field("Acknowledgement No."; Rec."Acknowledgement No.") { ApplicationArea = all; }
                field("Acknowledgement Date"; Rec."Acknowledgement Date") { ApplicationArea = all; }
                field("QR Code"; Rec."QR Code") { ApplicationArea = all; }
                field("Cancel IRN Date"; Rec."Cancel IRN Date") { ApplicationArea = all; }
                field("Irn Cancelled"; "Irn Cancelled") { ApplicationArea = all; Editable = false; }

            }
        }
        addlast(General)
        {
            field("Aza Posting No."; Rec."Aza Posting No.") { ApplicationArea = all; }
        }
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Print")
        {
            action("E-Invoice")
            {
                Caption = 'Generate E-Invoice';
                ApplicationArea = all;
                Image = Print;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    cuSalesEInvoice: codeunit E_Invoice_TaxInv;
                begin
                    cuSalesEInvoice.GenerateIRN_01(Rec);
                end;
            }
            action("Cancel IRN")
            {
                Caption = 'Cancel E-Invoice';
                ApplicationArea = all;
                Image = Cancel;
                PromotedCategory = Process;
                // Visible = Rec."Sale Is Return Sale" <> true;
                Promoted = true;
                trigger OnAction()
                var
                    cuSalesEInvoice: codeunit E_Invoice_TaxInv;
                begin
                    cuSalesEInvoice.CancellIRN_01(Rec);
                end;

            }
            action("TaxInvoice")
            {
                Caption = 'Print';
                ApplicationArea = all;
                Image = Print;
                PromotedCategory = Process;
                Visible = Rec."Sale Is Return Sale" <> true;
                Promoted = true;
                trigger OnAction()
                var
                    LSCTransEntry: Record "LSC Trans. Sales Entry";
                    TaxTransactionValue: Record "LSCIN Tax Transaction Value";
                begin
                    TransHed.Reset();
                    TransHed.SetRange("Transaction No.", rec."Transaction No.");
                    if TransHed.FindFirst() then
                        /*  LSCTransEntry.SetRange("Transaction No.", TransHed."Transaction No.");
                      if LSCTransEntry.FindFirst() then begin
                          TaxTransactionValue.Reset();
                          TaxTransactionValue.SetFilter("Tax Record ID", '%1', LSCTransEntry.RecordId);
                          TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
                          TaxTransactionValue.SetRange("Visible on Interface", true);
                          TaxTransactionValue.SetFilter(Amount, '<>%1', 0);
                          if TaxTransactionValue.Find('-') then
                              repeat

                                  IF (TaxTransactionValue.GetAttributeColumName() <> 'GST Base Amount') AND (TaxTransactionValue.GetAttributeColumName() <> 'Total TDS Amount') THEN BEGIN
                                      IF (TaxTransactionValue.GetAttributeColumName() = 'CGST') Or (TaxTransactionValue.GetAttributeColumName() = 'SGST') then
                                          Report.run(50100, true, false, TransHed);

                                      if (TaxTransactionValue.GetAttributeColumName() = 'IGST') then
                                          Report.run(50111, true, false, TransHed);
                                  end;
                              until TaxTransactionValue.next() = 0;*/
                    Report.run(50100, true, false, TransHed);
                end;


            }
            action(TaxInvoice1)
            {
                Caption = 'Print';
                ApplicationArea = all;
                Image = Print;
                PromotedCategory = Process;
                Visible = Rec."Sale Is Return Sale" = true;
                Promoted = true;
                trigger OnAction()
                var
                    LSCTransEntry: Record "LSC Trans. Sales Entry";
                    TaxTransactionValue: Record "LSCIN Tax Transaction Value";
                begin
                    TransHed.Reset();
                    TransHed.SetRange("Transaction No.", rec."Transaction No.");
                    if TransHed.FindFirst() then
                        /* LSCTransEntry.SetRange("Transaction No.", TransHed."Transaction No.");
                     if LSCTransEntry.FindFirst() then begin
                         TaxTransactionValue.Reset();
                         TaxTransactionValue.SetFilter("Tax Record ID", '%1', LSCTransEntry.RecordId);
                         TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
                         TaxTransactionValue.SetRange("Visible on Interface", true);
                         TaxTransactionValue.SetFilter(Amount, '<>%1', 0);
                         if TaxTransactionValue.Find('-') then
                             repeat

                                 IF (TaxTransactionValue.GetAttributeColumName() <> 'GST Base Amount') AND (TaxTransactionValue.GetAttributeColumName() <> 'Total TDS Amount') THEN BEGIN
                                     IF (TaxTransactionValue.GetAttributeColumName() = 'CGST') Or (TaxTransactionValue.GetAttributeColumName() = 'SGST') then
                                         Report.run(50112, true, false, TransHed);

                                     if (TaxTransactionValue.GetAttributeColumName() = 'IGST') then
                                         Report.run(50113, true, false, TransHed);
                                 end;
                             until TaxTransactionValue.next() = 0;
                     end;*/
                   Report.run(50112, true, false, TransHed);

                end;

            }
        }
        modify("&Print")
        {
            Visible = false;
        }
    }

    var
        myInt: Integer;
        TransHed: Record "LSC Transaction Header";
}