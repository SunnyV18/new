pageextension 50121 PostedSalesInvoiceExt extends "Posted Sales Invoice"
{
    layout
    {

        addlast(General)
        {
            field(Dimensions; Rec.Dimensions)
            {
                ApplicationArea = all;
            }
            field("Gross Wt."; Rec."Gross Wt.")
            {
                ApplicationArea = all;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = all;
            }
            field("Country of Origin"; Rec."Country of Origin")
            {
                ApplicationArea = all;
            }
            field("Country of Final Destination"; Rec."Country of Final Destination")
            {
                ApplicationArea = all;
            }
            field("IGST Payment Status"; Rec."IGST Payment Status")
            {
                ApplicationArea = all;
            }
            field("Store No."; Rec."Store No.") { ApplicationArea = all; }

            field("PDF Sent"; Rec."PDF Sent") { ApplicationArea = all; Editable = false; }
        }
    }

    actions
    {
        addafter(Dimensions)
        {
            action("Commercial Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Commercial Invoice';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category6;
                //PromotedCategory = Category10;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PurchaseHeader: Record "Sales Invoice Header";
                begin
                    PurchaseHeader := Rec;
                    PurchaseHeader.SetRecFilter();
                    Report.RunModal(Report::"Commercial Invoice", true, true, PurchaseHeader);
                end;
            }
        }
        addbefore("Generate E-Invoice")
        {
            action("Send PDF Attachment")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Download;
                trigger OnAction()
                var
                    cuFunctions: Codeunit Functions;
                begin
                    if not Rec."PDF Sent" then;
                    cuFunctions.UploadInvoicePDFtoS3Bucket(Rec);
                    // Rec."PDF Sent" := true;
                    // rec.Modify();
                    CurrPage.Update(false);
                    // end else
                    //     Message(GetLastErrorText());
                end;
            }
        }
        addafter("Commercial Invoice")
        {
            action("Export Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export Invoice';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category6;
                //PromotedCategory = Category10;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PurchaseHeader: Record "Sales Invoice Header";
                begin
                    PurchaseHeader := Rec;
                    PurchaseHeader.SetRecFilter();
                    Report.RunModal(Report::"Export Invoice", true, true, PurchaseHeader);

                end;
            }
        }
        addafter(AttachAsPDF)
        {
            action("Tax Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Tax Invoice';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    recRetailSet: Record "LSC Retail Setup";
                    cuFunctions: Codeunit Functions;
                    salesinvheader: Record "Sales Invoice Header";
                begin
                    recRetailSet.Get();
                    salesinvheader := Rec;
                    salesinvheader.SetRecFilter();
                    Report.Run(50110, true, true, salesinvheader);
                    Report.SaveAsPdf(50110, (recRetailSet."Sales Invoice Directory" + Rec."No." + '.pdf'), salesinvheader);
                    cuFunctions.UploadInvoicePDFtoS3Bucket(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Generate IRN ")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Generate IRN';
                Ellipsis = true;
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                // CUGenerateIRN: codeunit 50171;
                begin
                    // message('hi');
                    // if Rec."Invoice Type" = Rec."Invoice Type"::"Non-GST" then
                    //     exit;

                    // if Rec."GST Customer Type" in [Rec."gst customer type"::Unregistered, Rec."gst customer type"::" "] then
                    //     exit;

                    // CUGenerateIRN.SetSalesInvHeader(Rec);
                    // CUGenerateIRN.Run;
                end;
            }
            action("Cancel IRN")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel IRN';
                Ellipsis = true;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    // CUIRN: codeunit 50171;
                    EInvLog: Record 50166;
                begin
                    // EInvLog.Reset();
                    // EInvLog.SetRange("Document No.", Rec."No.");
                    // if EInvLog.FindFirst() then begin
                    //     CUIRN.CancelIRN(EInvLog."Invoice Reference Number", EInvLog."GST No.");
                    // end else
                    //     Message('IRN not available for cancel');
                end;
            }
            action("E-Invoice Error Log")
            {
                RunObject = Page 50153;
                RunPageLink = "Document Type" = CONST(Invoice), "Document No." = FIELD("No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = Log;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            action("E-Invoice Log")
            {
                RunObject = Page 50154;
                RunPageLink = "Document Type" = CONST(Invoice), "Document No." = FIELD("No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = Log;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}