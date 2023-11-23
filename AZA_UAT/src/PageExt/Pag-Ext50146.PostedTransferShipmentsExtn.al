pageextension 50146 PostedTransferShipmentsExtn extends "Posted Transfer Shipments"
{
    actions
    {
        addafter("&Print")
        {
            action(TaxInvoice)
            {
                Caption = 'Tax Invoice';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    transShipHdr: Record "Transfer Shipment Header";
                begin
                    transShipHdr.Reset();
                    transShipHdr.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::TaxInvoiceTransfer, true, false, transShipHdr);
                end;
            }
        }
    }
}
