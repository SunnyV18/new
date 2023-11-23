tableextension 50113 POTableExt extends "Purchase Header"
{
    fields
    {
        // modify("No.")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         Retailuser: Record "LSC Retail User";
        //         Store: Record "LSC Store";
        //         PurchSetup: Record "Purchases & Payables Setup";
        //         cuNoSeries: Codeunit NoSeriesManagement;
        //         Noseries: Record "No. Series";
        //     begin
        //         Clear(Rec."No.");
        //         if Retailuser.Get(UserId) then Begin
        //             PurchSetup.Get();
        //             IF Retailuser."Store No." = 'ALT' then
        //                 Rec."No." := cuNoSeries.GetNextNo(PurchSetup."Posted Invoice Nos.", Today, true);
        //             Rec.Modify();
        //         End;
        //     end;
        // }
        field(50000; "Short Close"; Boolean) { DataClassification = ToBeClassified; }
        field(50001; "PO Reference No"; Code[80]) { DataClassification = ToBeClassified; }//Added by KJ T002 120922
        field(50002; "PO type"; Option)
        {
            OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright",MTO;
            OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            DataClassification = ToBeClassified;
        }
        field(50003; "fc location"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        //SK++
        field(50004; "PO No."; Code[20])
        {

        }
        field(50005; Alteration; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                CU_NOSeriesMgmt: Codeunit NoSeriesManagement;
                recPurPayableSet: Record "Purchases & Payables Setup";
                PurchHeader: Record "Purchase Header";
                PurchLine: Record "Purchase Line";
                intLineNo: Integer;
                recPurLine: Record "Purchase Line";
            begin
                /*  if Alteration = true then begin
                     recPurPayableSet.Get();
                     PurchHeader.Init();
                     PurchHeader.validate("Document Type", PurchHeader."Document Type"::Order);
                     PurchHeader."No." := CU_NOSeriesMgmt.GetNextNo(recPurPayableSet."Order Nos.", Today, true);
                     PurchHeader."Gen. Bus. Posting Group" := 'DOMESTIC';
                     PurchHeader.validate("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                     PurchHeader.Validate("Buy-from Address", Rec."Buy-from Address");
                     PurchHeader.Validate("Buy-from Address 2", Rec."Buy-from Address 2");
                     PurchHeader.Validate("Buy-from City", Rec."Buy-from City");
                     PurchHeader.Validate("Buy-from Post Code", Rec."Buy-from Post Code");
                     PurchHeader.Validate("Buy-from Country/Region Code", Rec."Buy-from Country/Region Code");
                     PurchHeader.Validate("Posting Date", Rec."Posting Date");
                     PurchHeader.validate("Document Date", Rec."Document Date");
                     PurchHeader.validate("Order Date", Today);
                     PurchHeader.Validate("PO type", Rec."PO type");
                     PurchHeader.Validate("fc location", Rec."fc location");
                     PurchHeader.Validate("Location Code", Rec."fc location");
                     PurchHeader.Status := PurchHeader.Status::Open;
                     //PurchHeader."Vendor Invoice No." := Rec."Vendor Invoice No.";
                     PurchHeader.Insert();

                     intLineNo := 10000;
                     PurchLine.Reset();
                     PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                     PurchLine.SetRange("Document No.", PurchHeader."No.");
                     if PurchLine.FindSet() then
                         repeat
                             recPurLine.init();
                             recPurLine."Document Type" := PurchHeader."Document Type";
                             recPurLine."Document No." := PurchHeader."No.";
                             recPurLine."Line No." := intLineNo;
                             recPurLine.Type := PurchLine.Type;
                             recPurLine.Validate("No.", PurchLine."No.");
                             recPurLine.Validate("Location Code", PurchLine."Location Code");
                             recPurLine.Validate(MRP, PurchLine.MRP);
                             recPurLine.Validate(Quantity, PurchLine.Quantity);
                             recPurLine.Validate("Unit of Measure", PurchLine."Unit of Measure");
                             recPurLine.Validate("Direct Unit Cost", PurchLine."Direct Unit Cost");
                             recPurLine.Insert();
                             intLineNo += 10000;
                         until PurchLine.Next() = 0;
                 end else begin
                     Error('You can not deselect alteration button');
                 end; */
            end;
        }
        field(50006; "New Purchase Order No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Parent Designer Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "F Team Approval"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Po Excelsheet Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Is Email Sent"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Date Added"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Po Status"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Po Sent Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Modified by"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "F Team Approval date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "F Team Remark"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Is Alter Po"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50018; "Merchandiser Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Customer Order ID"; Code[50]) { DataClassification = ToBeClassified; }
        field(50020; "Partial Payment"; Boolean) { DataClassification = ToBeClassified; }
        field(50021; "RTV Reason"; Option) { OptionMembers = " ","For Alteration","Asked By Designer","For Sourcing","Consignment Return","For Order Refernce",Others; }

        field(50022; "Vendor order Date"; Date) { DataClassification = ToBeClassified; }
        field(50023; "Merchandiser"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Staff" where(Merchandiser = const(true));

        }
        field(50024; PoNoForRTV; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "PO Geography"; text[100])
        {
            DataClassification = ToBeClassified;

        }
    }
    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin

        RecLscRetail.Get(UserId);
        Validate("Location Code", RecLscRetail."Location Code");

    end;

    var
        myInt: Integer;
        RecLLoc: Record Location;
        RecLscRetail: Record "LSC Retail User";
}