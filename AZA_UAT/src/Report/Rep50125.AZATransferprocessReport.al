report 50125 "AZA Transfer process Report"
{
    ApplicationArea = All;
    Caption = 'AZA Transfer process Report';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(TransferShipmentHeader; "Transfer Shipment Header")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                RecTransferHeader.Reset();
                RecTransferHeader.SetRange("No.", "No.");
                if RecTransferHeader.FindFirst() then begin
                    //repeat
                    // RecTransferLine."Document No." := '';
                    RecTransferHeader.Rename('164');
                    // Message('%1Header', Format(RecTransferHeader."No."));
                    // until RecTransferHeader.Next = 0;
                end;
                RecTransferLine.Reset();
                RecTransferLine.SetRange("Document No.", "No.");
                if RecTransferLine.FindFirst() then begin
                    repeat
                        // RecTransferLine."Document No." := '';
                        // RecTransferHeader.Rename('108169', '163');
                        RecTransferLine.Rename('164', RecTransferLine."Line No.");
                    //  Message('%1Line', Format(RecTransferLine."Document No."));
                    until RecTransferLine.Next = 0;
                end;

                recValueEntry.Reset();
                recValueEntry.SetRange("Document No.", "No.");
                recValueEntry.SetRange("Posting Date", RecTransferHeader."Posting Date");
                if recValueEntry.FindFirst() then begin
                    repeat
                        recValueEntry."Document No." := '164';
                        // recValueEntry.Rename('163');
                        recValueEntry.Modify();
                    //  Message('%1ValueEntry', Format(recValueEntry."Document No."));
                    until recValueEntry.Next = 0;
                end;
                RecGLEntry.Reset();
                RecGLEntry.SetRange("Document No.", "No.");
                RecGLEntry.SetRange("Posting Date", RecTransferHeader."Posting Date");
                if RecGLEntry.FindFirst() then begin
                    repeat
                        RecGLEntry."Document No." := '164';
                        //RecGLEntry.Rename('163');
                        RecGLEntry.Modify();
                    //  Message('%1GLENtry', Format(RecGLEntry."Document No."));
                    until RecGLEntry.Next = 0;

                end;
                RecILE.Reset();
                RecILE.SetRange("Document No.", "No.");
                RecILE.SetRange("Posting Date", RecTransferHeader."Posting Date");
                if RecILE.FindFirst() then begin
                    repeat
                        RecILE."Document No." := '164';
                        //  RecILE.Rename('163');
                        RecILE.Modify();
                    //  Message('%1ILE', Format(RecILE."Document No."));
                    until RecILE.Next = 0;

                end;


            end;
        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    // field(DocumentNo; DocumentNo)
                    // {
                    //     ApplicationArea = all;

                    // }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var

        RecTransferLine: Record "Transfer Shipment Line";
        RecTransferHeader: Record "Transfer Shipment Header";
        recValueEntry: Record "Value Entry";
        RecGLEntry: Record "G/L Entry";
        DocumentNo: Code[20];
        RecILE: Record "Item Ledger Entry";
}
