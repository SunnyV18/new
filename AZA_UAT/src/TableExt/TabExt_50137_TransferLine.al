tableextension 50137 TransferLineTabExt extends "Transfer Line"
{
    fields
    {
        // modify("Item No.")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         recTransferLine: Record "Transfer Line";
        //         recItem: Record 27;
        //         recItem1: Record 27;
        //     begin
        //         if recItem.get(Rec."Item No.") then;
        //         if recItem.ItemSaleReserved then begin
        //             recTransferLine.reset;
        //             recTransferLine.SetRange("Document No.", Rec."Document No.");
        //             recTransferLine.SetFilter("Item No.", '<>%1', recItem."No.");
        //             if recTransferLine.find('-') then
        //                 repeat
        //                     if recItem1.Get(recTransferLine."Item No.") then
        //                         if not recItem1.ItemSaleReserved then
        //                             Error('This transfer document can only contain manually blocked items! Please create a different document for this item %1', recItem.Description);
        //                 until recTransferLine.Next() = 0;
        //         end else begin
        //             recTransferLine.reset;
        //             recTransferLine.SetRange("Document No.", Rec."Document No.");
        //             recTransferLine.SetFilter("Item No.", '<>%1', recItem."No.");
        //             if recTransferLine.find('-') then
        //                 repeat
        //                     if recItem1.Get(recTransferLine."Item No.") then
        //                         if recItem1.ItemSaleReserved then
        //                             Error('This transfer document can only contain un-blocked items! Please create a different document for this item %1', recItem.Description);
        //                 until recTransferLine.Next() = 0;
        //         end;


        //     end;
        // }
        // Add changes to table fields here
        field(50001; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            // trigger OnValidate()
            // begin
            //     Rec.Validate(Quantity, 1);
            // end;
        }
        field(50002; "PO type"; Option)
        {
            OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright","MTO";
            OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            DataClassification = ToBeClassified;
        }
        field(50003; Old_aza_code; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                RecItem: Record Item;
                RecItem2: Record Item;
                RecItem3: Record Item;
            begin
                if RecItem.Get(Rec."Item No.") then begin
                    "PO type" := RecItem."PO type";
                    Old_aza_code := RecItem.Old_aza_code;
                    "Vendor Name" := RecItem."Vendor Name";
                    Amount := RecItem."Unit Cost";
                    // RecItem.CalcFields("Vendor Name");
                    // Rec.Validate("Vendor Name", RecItem."Vendor Name");
                end;
            end;
        }
        // modify("Unit of Measure Code")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         myInt: Integer;
        //     begin
        //         Rec.Validate(Quantity, 1);
        //     end;
        // }
    }

    var
        myInt: Integer;
}//Naveen