pageextension 50185 CustomerListExt extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Responsibility Center")
        {
            field("RPro Code"; "RPro Code") { ApplicationArea = All; }
        }
    }

    actions
    {
        addafter("Sent Emails")
        {
            action("Create POS Customer")
            {
                Promoted = true;
                PromotedIsBig = true;
                image = Customer;
                PromotedCategory = Process;
                // Caption = 'Get Customer From API';
                // Image = CreateDocument;
                trigger OnAction()
                var
                    pgCustPOS: Page CreateCustomerPOS;
                    recCust: Record 18;
                    pgCustTem: page 1380;
                    cuNoSeries: Codeunit 396;
                    salesReceiveSetup: Record "Sales & Receivables Setup";
                    Retailuser: Record "LSC Retail User";
                    Store: Record "LSC Store";
                begin
                    salesReceiveSetup.Get();
                    // recCust.Reset();
                    recCust.Init();
                    recCust."No." := cuNoSeries.GetNextNo(salesReceiveSetup."Customer Nos.", Today, true);
                    Retailuser.Get(UserId);
                    if Store.Get(Retailuser."Store No.") then
                        recCust."State Code" := Store."LSCIN State Code";
                    recCust."GST Customer Type" := recCust."GST Customer Type"::Unregistered;
                    recCust.Address := 'q';
                    recCust.Insert();
                    pgCustPOS.SetTableView(recCust);
                    Run(50132, recCust);
                end;

            }

            action(GetCustomerFromAPI)
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Get Customer From API';
                Image = CreateDocument;
                trigger OnAction()
                var
                begin
                end;
            }
            action(DeleteILEValueEnt)
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Delele ILE Value Ent';
                Image = Delete;
                trigger OnAction()
                var
                    ILE: Record "Item Ledger Entry";
                    ValueEnt: Record "Value Entry";
                begin
                    // ILE.Reset();
                    // ILE.SetFilter("Entry No.", '=%1|%2', 26905, 26906);
                    // if ILE.FindSet() then
                    //     ILE.DeleteAll();

                    // ValueEnt.Reset();
                    // ValueEnt.SetFilter("Item Ledger Entry No.", '=%1|%2', 26905, 26906);
                    // if ValueEnt.FindSet() then
                    //     ValueEnt.DeleteAll();

                    //>>>>>>>>>>
                    ILE.Reset();
                    ILE.SetRange("Entry No.", 26905);
                    if ILE.FindFirst() then
                        ILE.DeleteAll();

                    ILE.Reset();
                    ILE.SetRange("Entry No.", 26906);
                    if ILE.FindFirst() then
                        ILE.DeleteAll();

                    ValueEnt.Reset();
                    ValueEnt.SetRange("Item Ledger Entry No.", 26905);
                    if ValueEnt.FindFirst() then
                        ValueEnt.DeleteAll();

                    ValueEnt.Reset();
                    ValueEnt.SetRange("Item Ledger Entry No.", 26906);
                    if ValueEnt.FindFirst() then
                        ValueEnt.DeleteAll();

                end;
            }
        }

    }

    var
        myInt: Integer;
}