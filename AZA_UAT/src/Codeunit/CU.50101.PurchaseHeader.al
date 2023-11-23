codeunit 50101 PO_CU
{
    trigger OnRun()
    var
        recPosLine: Record "LSC POS Trans. Line";
        recTransSaleEntry: Record "LSC Trans. Sales Entry";
        decGST: Decimal;
        cu_PosTrans: Codeunit "LSC POS Transaction";
        cu_posTransEvents: Codeunit "LSC POS Transaction Events";
        Cu_posTransFunctions: Codeunit "LSC POS Transaction Functions";
    begin
        // decGST := recTransSaleEntry
        decGST := recPosLine."LSCIN GST Amount";
        // decGST := recPosLine.lsci
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnOpenPageEvent', '', false, false)]
    procedure MakePOEditable(Rec: Record "Purchase Header")
    var
    begin
        // globalRec.get(Rec."No.");
    end;

    procedure ShortClose()
    var
        recPurchLine: Record "Purchase Line";
        recPurchHeader: Record "Purchase Header";
        cu_printUtil: Codeunit "LSC Pos Print Utility";
        Cu_posTrans: Codeunit "LSC Pos Transaction";
        CU_HospPosCommands: Codeunit "LSC Hospitality POS Commands";
    begin
        isPageEditable := false;
        recPurchHeader.get(globalRec."No.");
        if recPurchHeader.Status = recPurchHeader.Status::Open then begin
            recPurchLine.Reset();
            recPurchLine.SetFilter("Document Type", '=%1|%2', recPurchLine."Document Type"::"Blanket Order", recPurchLine."Document Type"::Order);
            if recPurchLine.find('-') then begin
                repeat
                    // if ((recPurchLine."Qty. Invoiced (Base)" <> 0) or (recPurchLine."Qty. Received (Base)" <> 0))
                    //       and (recPurchLine.Quantity <> 0) then
                    isPageEditable := false;
                    recPurchLine."Short Close" := true;
                    recPurchLine.Modify();
                until recPurchLine.Next = 0;
                isPageEditable := false
            end;
            recPurchHeader."Short Close" := true;
            recPurchHeader.Modify();
        end else
            Error('PO Should be in released state');
    end;
    //KKS-
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeUpdatePostingNos', '', false, false)]
    local procedure OnBeforeUpdatePostingNos(var PurchHeader: Record "Purchase Header"; var ModifyHeader: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        StoreL: Record "LSC Store";
    begin
        PurchSetup.Get();
        IF not StoreL.Get(PurchHeader."LSC Store No.") then
            IF not StoreL.Get(PurchHeader."Location Code") then
                exit;
        if PurchHeader.Ship and (PurchHeader."Return Shipment No." = '') then begin
            if (PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order") or
               ((PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") and PurchSetup."Return Shipment on Credit Memo")
            then
                PurchHeader."Return Shipment No. Series" := StoreL."Posted Purchase Return Shipment";

        end;
        if PurchHeader.Receive and (PurchHeader."Receiving No." = '') then begin
            if (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) or
               ((PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) and PurchSetup."Receipt on Invoice")
            then
                PurchHeader."Receiving No. Series" := StoreL."Purchase Receipt No. Series";
        end;
    end;
    //KKS+







    var
        globalRec: Record "Purchase Header";
        isPageEditable: Boolean;

}