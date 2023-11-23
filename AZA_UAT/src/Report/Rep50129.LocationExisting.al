report 50129 LocationExisting
{
    ApplicationArea = All;
    Caption = 'LocationExisting';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("New Table"; "New Table")
        {
            RequestFilterFields = "Document No";
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                RecPH.Reset();
                RecPH.SetRange(RecPH."No.", "New Table"."Document No");
                if RecPH.FindFirst() then begin
                    repeat
                        RecPH."Location Code" := "New Table"."Location Code";
                        RecPH.Modify();
                    until RecPH.Next = 0;
                end;


                RecPL.Reset();
                RecPL.SetRange(RecPL."Document No.", "New Table"."Document No");
                if RecPL.FindFirst() then begin
                    repeat
                        RecPL."Location Code" := "New Table"."Location Code";
                        RecPL.Modify();
                    until RecPL.Next = 0;
                end;
                RecPurcRct.Reset();
                RecPurcRct.SetRange(RecPurcRct."No.", "New Table"."Document No");
                if RecPurcRct.FindFirst() then begin
                    repeat
                        RecPurcRct."Location Code" := "New Table"."Location Code";
                        RecPurcRct.Modify();
                    until RecPurcRct.Next = 0;

                end;
                RecPurcRctLine.Reset();
                RecPurcRctLine.SetRange(RecPurcRctLine."Document No.", "New Table"."Document No");
                if RecPurcRctLine.FindFirst() then begin
                    repeat
                        RecPurcRctLine."Location Code" := "New Table"."Location Code";
                        RecPurcRctLine.Modify();
                    until RecPurcRctLine.Next = 0;

                end;

                ILE.Reset();
                ILE.SetRange(ILE."Document No.", "New Table"."Document No");
                if ILE.FindFirst() then begin
                    repeat
                        ILE."Location Code" := "New Table"."Location Code";
                        ILE.Modify();
                    until ILE.Next = 0;
                end;
                ValueEntry.Reset();
                ValueEntry.SetRange(ValueEntry."Document No.", "New Table"."Document No");
                if ValueEntry.FindFirst() then begin
                    repeat
                        ValueEntry."Location Code" := "New Table"."Location Code";
                        ValueEntry.Modify();
                    until ValueEntry.Next = 0;
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
                group(GroupName)
                {
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
        RecPH: Record "Purchase Header";
        RecPL: Record "Purchase Line";
        RecPurcRct: Record "Purch. Rcpt. Header";
        RecPurcRctLine: Record "Purch. Rcpt. Line";
        ILE: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
}
