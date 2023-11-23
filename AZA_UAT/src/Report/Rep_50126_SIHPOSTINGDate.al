report 50126 SIH
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                RecSIH.Reset();
                RecSIH.SetRange("No.", "No.");
                if RecSIH.FindFirst() then begin
                    RecSIH."Posting Date" := 20230716D;
                    RecSIH."Document Date" := 20230716D;
                    RecSIH."Order Date" := 20230716D;
                    RecSIH."Shipment Date" := 20230716D;
                    RecSIH.Modify();
                end;
                RecSalesShipHeader.Reset();
                RecSalesShipHeader.SetRange("No.", "No.");
                if RecSalesShipHeader.FindFirst() then begin
                    RecSalesShipHeader."Posting Date" := 20230716D;
                    RecSalesShipHeader."Document Date" := 20230716D;
                    RecSalesShipHeader."Order Date" := 20230716D;
                    RecSalesShipHeader."Shipment Date" := 20230716D;
                    RecSalesShipHeader.Modify();
                end;
                RecGL.Reset();
                RecGL.SetRange("Document No.", "No.");
                RecGL.SetRange("Posting Date", "Posting Date");
                if RecGL.FindFirst() then begin
                    repeat
                        RecGL."Posting Date" := 20230716D;
                        RecGL."Document Date" := 20230716D;
                        // RecGL."Order Date" := 20230625D;
                        // RecGL."Shipment Date" := 20230625D;
                        RecGL.Modify();
                    until RecGL.Next = 0;
                end;
                RecCust.Reset();
                RecCust.SetRange("Document No.", "No.");
                RecCust.SetRange("Posting Date", "Posting Date");
                if RecCust.FindFirst() then begin
                    repeat
                        RecCust."Posting Date" := 20230716D;
                        RecCust."Document Date" := 20230716D;
                        // RecCust."Order Date" := 20230625D;
                        // RecCust."Shipment Date" := 20230625D;
                        RecCust.Modify();
                    until RecCust.Next = 0;
                end;
                RecDetCustLed.Reset();
                RecDetCustLed.SetRange("Document No.", "No.");
                RecDetCustLed.SetRange("Posting Date", "Posting Date");
                if RecDetCustLed.FindFirst() then begin
                    repeat
                        RecDetCustLed."Posting Date" := 20230716D;
                        // RecDetCustLed."Document Date" := 20230625D;
                        // RecDetCustLed."Order Date" := 20230625D;
                        // RecDetCustLed."Shipment Date" := 20230625D;
                        RecDetCustLed.Modify();
                    until RecDetCustLed.Next = 0;
                end;
                ILE.Reset();
                ILE.SetRange("Document No.", "No.");
                ILE.SetRange("Posting Date", "Posting Date");
                if ILE.FindFirst() then begin
                    repeat
                        ILE."Posting Date" := 20230716D;
                        ILE."Document Date" := 20230716D;
                        // ILE."Order Date" := 20230625D;
                        // ILE."Shipment Date" := 20230625D;
                        ILE.Modify();
                    until ILE.Next = 0;
                end;
                valEntry.Reset();
                valEntry.SetRange("Document No.", "No.");
                valEntry.SetRange("Posting Date", "Posting Date");
                if valEntry.FindFirst() then begin
                    repeat
                        valEntry."Posting Date" := 20230716D;
                        valEntry."Document Date" := 20230716D;
                        // valEntry."Order Date" := 20230625D;
                        // valEntry."Shipment Date" := 20230625D;
                        valEntry.Modify();
                    until valEntry.Next = 0;
                end;
                GLE.Reset();
                GLE.SetRange("Document No.", "No.");
                GLE.SetRange("Posting Date", "Posting Date");
                if GLE.FindFirst() then begin
                    repeat
                        GLE."Posting Date" := 20230716D;
                        // GLE."Document Date" := 20230625D;
                        // GLE."Order Date" := 20230625D;
                        // GLE."Shipment Date" := 20230625D;
                        GLE.Modify();
                    until GLE.Next = 0;
                end;
                DetaiGstLedEntry.Reset();
                DetaiGstLedEntry.SetRange("Document No.", "No.");
                DetaiGstLedEntry.SetRange("Posting Date", "Posting Date");
                if DetaiGstLedEntry.FindFirst() then begin
                    repeat
                        DetaiGstLedEntry."Posting Date" := 20230716D;
                        // DetaiGstLedEntry."Document Date" := 20230625D;
                        // DetaiGstLedEntry."Order Date" := 20230625D;
                        // DetaiGstLedEntry."Shipment Date" := 20230625D;
                        DetaiGstLedEntry.Modify();
                    until DetaiGstLedEntry.Next = 0;
                end;


            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        myInt: Integer;
        RecSalesShipHeader: Record "Sales Shipment Header";
        RecSIH: Record "Sales Invoice Header";
        RecGL: Record "G/L Entry";
        RecCust: Record "Cust. Ledger Entry";
        RecDetCustLed: Record "Detailed Cust. Ledg. Entry";
        ILE: Record "Item Ledger Entry";
        valEntry: Record "Value Entry";
        GLE: Record "GST Ledger Entry";
        DetaiGstLedEntry: Record "Detailed GST Ledger Entry";
}