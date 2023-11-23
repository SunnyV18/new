pageextension 50101 PO_ShortClose extends "Purchase Order"
{
    layout
    {

        modify("Vendor Invoice No.")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }

        modify("Vendor Order No.")
        {
            Caption = 'Vendor invoice/Challan No.';
            Importance = Promoted;
            ShowMandatory = true;
        }
        addfirst(factboxes)
        {
            part(Picture; "Item Picture")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
                Provider = PurchLines;

            }
            part(Picture2; "Item Picture 2")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
                Provider = PurchLines;

            }
        }
        addbefore(Status)
        {
            field("PO type"; rec."PO type")
            {
                ApplicationArea = all;
            }
        }
        addafter("PO type")
        {
            field("fc location"; Rec."fc location")
            {
                ApplicationArea = all;
            }
        }

        addafter("Buy-from Vendor No.")
        {
            field("Short Close"; Rec."Short Close") { ApplicationArea = all; Editable = false; }
        }
        addafter("Shipping and Payment")
        {
            group(AzaAttributes)
            {
                field("Parent Designer Id"; Rec."Parent Designer Id") { ApplicationArea = all; }
                field("F Team Approval"; Rec."F Team Approval") { ApplicationArea = all; }
                field("F Team Approval date"; Rec."F Team Approval date") { ApplicationArea = all; }
                field("F Team Remark"; Rec."F Team Remark") { ApplicationArea = all; }
                field("Po Excelsheet Name"; Rec."Po Excelsheet Name") { ApplicationArea = all; }
                field("Is Email Sent"; Rec."Is Email Sent") { ApplicationArea = all; }
                field("Is Alter Po"; Rec."Is Alter Po") { ApplicationArea = all; }
                field("Date Added"; Rec."Date Added") { ApplicationArea = all; }
                field("Modified by"; Rec."Modified by") { ApplicationArea = all; }
                field("Po Sent Date"; Rec."Po Sent Date") { ApplicationArea = all; }
                field("Po Status"; Rec."Po Status") { ApplicationArea = all; }
                field("Merchandiser Name"; Rec."Merchandiser Name") { ApplicationArea = all; }
                field("Customer Order ID"; Rec."Customer Order ID") { ApplicationArea = all; Editable = false; }
                field("Partial Payment"; Rec."Partial Payment") { ApplicationArea = all; Editable = false; }
                field("PO Geography"; "PO Geography") { ApplicationArea = all; }


            }
        }
        addafter("Vendor Order No.")
        {
            field("Vendor order Date"; "Vendor order Date")
            {
                Caption = 'Vendor Invoice/Challan Date';
                ApplicationArea = All;
            }
            field(SystemModifiedBy; SystemModifiedBy) { ApplicationArea = All; }
            field(SystemCreatedBy; SystemCreatedBy) { ApplicationArea = All; }
            field("Receiving No."; "Receiving No.") { ApplicationArea = All; }
            field("Receiving No. Series"; "Receiving No. Series") { ApplicationArea = All; }
            field("Last Receiving No."; "Last Receiving No.") { ApplicationArea = All; }

        }

        modify(General) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify("Buy-from") { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        //modify(PurchLines) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify("Invoice Details") { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify("Shipping and Payment") { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify("Foreign Trade") { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Prepayment) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Application) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Control101) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Control122) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Control123) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Control124) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Control71) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Control95) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Control99) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }
        modify(Control98) { Editable = (not isPageShortClosed) or (not Rec."Short Close"); }

        // Add changes to page layout here
    }


    actions
    {
        addafter("Update Reference Invoice No.")
        {
            action("Open Customer Order")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    pgCustomerOrder: page "LSC Customer Order";
                    recCustomerOrder: Record "LSC Customer Order Header";
                begin
                    if Rec."Customer Order ID" = '' then
                        Error('Customer order not created ')
                    else
                        if not recCustomerOrder.Get(Rec."Customer Order ID") then Error('Customer order  %1 doesn''t exist!');

                    recCustomerOrder.Get(Rec."Customer Order ID");
                    // pgCustomerOrder.SetTableView(recCustomerOrder);
                    Run(10016651, recCustomerOrder);
                end;

            }
            action(ShortClosePO)
            {
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Short Close PO';
                Description = 'Short Close';

                trigger OnAction()
                var
                    recPurchLine: Record "Purchase Line";
                    recPurchHeader: Record "Purchase Header";
                begin
                    isPageShortClosed := false;
                    recPurchHeader.get(Rec."Document Type", Rec."No.");
                    if recPurchHeader.Status = recPurchHeader.Status::Open then begin
                        recPurchLine.Reset();
                        recPurchLine.SetRange("Document No.", recPurchHeader."No.");
                        recPurchLine.SetRange("Document Type", recPurchHeader."Document Type");
                        //recPurchLine.SetFilter("Document Type", '=%1|%2', recPurchHeader."Document Type"::"Blanket Order", recPurchHeader."Document Type"::Order);
                        if recPurchLine.FindSet(true) then begin
                            //if recPurchLine.find('-') then begin
                            repeat
                                // if ((recPurchLine."Qty. Invoiced (Base)" <> 0) or (recPurchLine."Qty. Received (Base)" <> 0))
                                //       and (recPurchLine.Quantity <> 0) then
                                // isPageShortClosed := true;

                                recPurchLine."Outstanding Quantity" := 0;//cocoon
                                //recPurchLine."Qty. Received (Base)" := 0;
                                //recPurchLine."Qty. Invoiced (Base)" := 0;
                                recPurchLine."Short Close" := true;
                                recPurchLine.Modify();
                            until recPurchLine.Next = 0;
                            // isPageShortClosed := false
                        end;
                        recPurchHeader."Short Close" := true;
                        recPurchHeader.Modify();
                        isPageShortClosed := true;
                    end else
                        Error('PO should be in Released state!');
                    CurrPage.Update(false);
                end;
            }
        }
        addafter(AttachAsPDF)
        {
            action(AZAPurchaseOrder)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'AZAPurchaseOrder';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                //PromotedCategory = Category6;
                PromotedCategory = Category10;
                // Visible = Visible1;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PurchaHeader: Record "Purchase Header";
                begin
                    IF Status = Status::Open then begin
                        Error('PO must be Released');
                    end;
                    PurchaHeader := Rec;
                    PurchaHeader.SetRecFilter();
                    if PurchaHeader."PO type" <> PurchaHeader."PO type"::"CON-Consignment" then
                        Report.RunModal(Report::AZAPurchaseOrder, true, true, PurchaHeader)
                    else
                        Message('Report can not be generated because po type is consignment');
                end;

            }

            // Add changes to page actions here
        }
    }
    // trigger OnAfterGetCurrRecord()
    // var
    //     myInt: Integer;
    //     purchhead: Record "Purchase Header";
    //     purchaseLine: Record "Purchase Line";
    // begin
    //     EditField := false;
    //     if purchhead.Get("GST Vendor Type"::Unregistered) then
    //         if purchaseLine."GST Reverse Charge" = true then
    //             EditField := true;

    // end;


    trigger OnOpenPage()
    var
        recRetailUser: Record "LSC Retail User";
        // recRetailUser: Record "LSC Retail User";
        purchhead: Record "Purchase Header";
        purchaseLine: Record "Purchase Line";
    begin
        recRetailUser.Reset();
        recRetailUser.SetRange(ID, UserId);

        recRetailUser.Reset();
        recRetailUser.SetRange(ID, UserId);
        if purchhead.Get("GST Vendor Type"::Unregistered) then
            purchaseLine."GST Reverse Charge" := true
        else
            purchaseLine."GST Reverse Charge" := false;
        // if recRetailUser.FindFirst() then begin
        //     Rec.FilterGroup(0);
        //     Rec.SetRange("Location Code", recRetailUser."Location Code");
        //     Rec.FilterGroup(3);
        // end;
    end;

    var
        myInt: Integer;
        isPageShortClosed: Boolean;
        recTransHeader: Record "LSC Transaction Header";
        EditField: Boolean;
}

