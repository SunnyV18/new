codeunit 50112 "POS Event Handlers"
{
    trigger OnRun()
    begin

    end;

    var
        POSGUI: Codeunit "LSC POS GUI";
        PosSession_g: Codeunit "LSC POS Session";
        PosCtrl_g: Codeunit "LSC POS Control Interface";


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeRunCommand', '', false, false)]
    local procedure OnBeforeRunCommand(var POSMenuLine: Record "LSC POS Menu Line"; var isHandled: Boolean; var POSTransaction: Record "LSC POS Transaction")
    var
        KeyValue: Code[20];
        CurrLookupID: Code[20];
        FormID_l: Code[20];
        DataEntry: Record "LSC POS Data Entry";
        TempDataEntry_l: Record "LSC POS Data Entry" temporary;
        Lookup_l: Record "LSC POS Lookup";
        Text001: Label 'POS Lookup ''%1'' not found.';
        TmpPOSTrLine_l: Record "LSC POS Trans. Line" temporary;
        FlowFieldBufferTEMP_l: Record "LSC FlowField Buffer" temporary;
        RecRef_l: RecordRef;
        CustomerOrderHeader: Record "LSC Customer Order Header";
        POSCOItem: Record "POS Customer Order Item";
        POSCOItemPage: Page "POS CO Items";
    begin
        case POSMenuLine.Command of
            'CUSTADVLOOOKUP':
                begin
                    isHandled := true;
                    CurrLookupID := POSGUI.GetActiveLookupID();
                    IF CurrLookupID <> 'CUSTOMER' then
                        exit;
                    FormID_l := POSMenuLine.Parameter;
                    if not PosSession_g.GetPosLookupRec(FormID_l, Lookup_l) then begin
                        PosCtrl_g.PosMessage(StrSubstNo(Text001, FormID_l));
                        exit;
                    end;
                    KeyValue := POSGUI.GetActiveLookupKeyValue();
                    TempDataEntry_l.DeleteAll();
                    DataEntry.Reset();
                    DataEntry.SetRange("Customer Advance Data Entry", true);
                    DataEntry.SetRange("Customer No.", KeyValue);
                    DataEntry.SetFilter("Voucher Remaining Amount", '<>%1', 0);
                    IF DataEntry.FindSet() then
                        repeat
                            DataEntry.CalcFields("Voucher Remaining Amount");
                            TempDataEntry_l := DataEntry;
                            TempDataEntry_l."Voucher Remaining Amount (Int)" := DataEntry."Voucher Remaining Amount";
                            TempDataEntry_l.Insert();
                        until DataEntry.Next() = 0;

                    RecRef_l.GetTable(TempDataEntry_l);
                    POSGUI.LookupEx(Lookup_l, '', TmpPOSTrLine_l, PosSession_g.MgrKey, '', RecRef_l, FlowFieldBufferTEMP_l);
                end;
            'CUSTOMER_ORDER_LIST':
                begin
                    CustomerOrderHeader.Reset();
                    IF CustomerOrderHeader.FindSet() then
                        repeat
                            CustomerOrderHeader.CalcFields("Total Amount", "Pre Approved Amount");
                            CustomerOrderHeader."Balance Amount" := CustomerOrderHeader."Total Amount" - CustomerOrderHeader."Pre Approved Amount";
                            CustomerOrderHeader.Modify();
                        until CustomerOrderHeader.Next() = 0;
                end;
            'CUSTOMERORDERITEMS':
                begin
                    Commit();
                    POSCOItem.Reset();
                    POSCOItem.SetRange("Receipt No.", POSTransaction."Receipt No.");
                    POSCOItemPage.SetTableView(POSCOItem);
                    POSCOItemPage.RunModal();
                end;

        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterInsertTransHeader', '', false, false)]
    local procedure OnAfterInsertTransHeader(var POSTrans: Record "LSC POS Transaction"; var Transaction: Record "LSC Transaction Header")
    Var
        Customer: Record Customer;
    begin
        IF POSTrans."Customer No." = '' then
            exit;
        IF Customer.Get(POSTrans."Customer No.") then
            Transaction."Customer Name" := Customer.Name;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Post Utility", 'OnAfterPostTransaction', '', false, false)]
    local procedure OnAfterPostTransaction(var TransactionHeader_p: Record "LSC Transaction Header")
    Var
        POSCOItem: Record "POS Customer Order Item";
        TransCOItem: Record "Trans Customer Order Items";
    begin
        POSCOItem.Reset();
        POSCOItem.SetRange("Receipt No.", TransactionHeader_p."Receipt No.");
        IF POSCOItem.FindSet() then
            repeat
                TransCOItem.Reset();
                TransCOItem."Store No." := TransactionHeader_p."Store No.";
                TransCOItem."POS Terminal No." := TransactionHeader_p."POS Terminal No.";
                TransCOItem."Transaction No." := TransactionHeader_p."Transaction No.";
                TransCOItem."Line No." := POSCOItem."Line No.";
                TransCOItem."Receipt No." := TransactionHeader_p."Receipt No.";
                TransCOItem."Barcode No." := POSCOItem."Barcode No.";
                TransCOItem."Item No." := POSCOItem."Item No.";
                TransCOItem."Unit of Measure" := POSCOItem."Unit of Measure";
                TransCOItem.Quantity := POSCOItem.Quantity;
                TransCOItem.Price := POSCOItem.Price;
                TransCOItem."Net Amount" := POSCOItem."Net Amount";
                TransCOItem."Designer Name" := POSCOItem."Designer Name";
                TransCOItem."Designer Abbreviation" := POSCOItem."Designer Abbreviation";
                TransCOItem.Insert();
            until POSCOItem.Next() = 0;

        POSCOItem.Reset();
        POSCOItem.SetRange("Receipt No.", TransactionHeader_p."Receipt No.");
        POSCOItem.DeleteAll();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Infocode Utility", 'OnAfterTypeCreateDataEntry', '', false, false)]
    local procedure OnAfterTypeCreateDataEntry(var DataEntry: Record "LSC POS Data Entry"; var Line: Record "LSC POS Trans. Line"; var Trans: Record "LSC POS Transaction"; var DataEntryType: Record "LSC POS Data Entry Type"; var VoucherEntries: Record "LSC Voucher Entries")
    Var
        Customer: Record Customer;
        Staff_L: Record "LSC Staff";
    begin
        DataEntry."Customer Advance Data Entry" := DataEntryType."Customer Advance Data Entry";
        DataEntry."Sales Staff" := Line."Sales Staff";
        IF Staff_L.Get(Line."Sales Staff") then
            DataEntry."Sales Staff Name" := Staff_L."First Name";
        IF Trans."Customer No." <> '' then begin
            DataEntry."Customer No." := Trans."Customer No.";
            IF Customer.Get(Trans."Customer No.") then begin
                DataEntry."Customer Name" := Customer.Name;
                DataEntry."Customer Phone No." := Customer."Phone No.";
            end;
        end;
        DataEntry.Modify();
        IF VoucherEntries."Voucher No." = '' then
            Exit;
        VoucherEntries."Customer No." := DataEntry."Customer No.";
        VoucherEntries."Customer Name" := DataEntry."Customer Name";
        VoucherEntries."Sales Staff" := DataEntry."Sales Staff";
        VoucherEntries."Customer Advance Data Entry" := DataEntry."Customer Advance Data Entry";
        VoucherEntries."Sales Staff Name" := DataEntry."Sales Staff Name";
        VoucherEntries."Customer Phone No." := DataEntry."Customer Phone No.";
        VoucherEntries.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Infocode Utility", 'OnAfterTypeApplyToEntry', '', false, false)]
    local procedure OnAfterTypeApplyToEntry(var InfoCodeRec: Record "LSC Infocode"; Input: Text)
    Var
        Customer: Record Customer;
        Staff_L: Record "LSC Staff";
        DataEntry_L: Record "LSC POS Data Entry";
        VoucherEntry_L: Record "LSC Voucher Entries";
    begin
        IF DataEntry_L.Get(InfoCodeRec."Data Entry Type", Input) then begin
            VoucherEntry_L.Reset();
            VoucherEntry_L.SetRange("Voucher Type", DataEntry_L."Entry Type");
            VoucherEntry_L.SetRange("Voucher No.", DataEntry_L."Entry Code");
            VoucherEntry_L.ModifyAll("Customer No.", DataEntry_L."Customer No.");
            VoucherEntry_L.ModifyAll("Customer Name", DataEntry_L."Customer Name");
            VoucherEntry_L.ModifyAll("Sales Staff", DataEntry_L."Sales Staff");
            VoucherEntry_L.ModifyAll("Customer Advance Data Entry", DataEntry_L."Customer Advance Data Entry");
            VoucherEntry_L.ModifyAll("Sales Staff Name", DataEntry_L."Sales Staff Name");
            VoucherEntry_L.ModifyAll("Customer Phone No.", DataEntry_L."Customer Phone No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Create New Customer", 'SaveCustomerInfo_OnBeforeModify', '', false, false)]
    local procedure SaveCustomerInfo_OnBeforeModify(var CustomerRec: Record Customer; var lCustomerRec: Record Customer)
    begin
        lCustomerRec."State Code" := CustomerRec."State Code";
        lCustomerRec."P.A.N. No." := CustomerRec."P.A.N. No.";
        lCustomerRec."Passport No." := CustomerRec."Passport No.";
        lCustomerRec."Adhaar No." := CustomerRec."Adhaar No.";
        lCustomerRec."GST Customer Type" := CustomerRec."GST Customer Type";
        lCustomerRec."GST Registration No." := CustomerRec."GST Registration No.";
        lCustomerRec."GST Registration Type" := CustomerRec."GST Registration Type";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnAfterValidateCustomer', '', false, false)]
    local procedure OnAfterValidateCustomer(var POSTransaction: Record "LSC POS Transaction"; var CurrInput: Text; var POSTransLine: Record "LSC POS Trans. Line")
    var
        POSTransLine2: Record "LSC POS Trans. Line";
        POSTransEvents: Codeunit "LSC POS Transaction Events";
    begin
        POSTransEvents.OnAfterSelectCustomer(POSTransaction, POSTransLine, CurrInput);
        if POSTransaction."Customer No." <> '' then begin
            POSTransLine2.Reset;
            POSTransLine2.SetRange("Receipt No.", POSTransaction."Receipt No.");
            POSTransLine2.SetRange("Entry Type", POSTransLine2."Entry Type"::FreeText);
            POSTransLine2.SetRange("Entry Status", 0);
            POSTransLine2.SetRange("Card/Customer/Coup.Item No", POSTransaction."Customer No.");
            POSTransLine2.SetRange("Text Type", POSTransLine2."Text Type"::"Cust. Text");
            if POSTransLine2.FindFirst then begin
                POSTransLine2."Sales Staff" := POSTransaction."Sales Staff";
                POSTransLine2.Modify();
            end;
        end;
    end;

}