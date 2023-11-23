tableextension 50114 POLineTableExt extends "Purchase Line"
{
    fields
    {
        modify(Type)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                Purchasehead: Record "Purchase Header";
                RecPurcLine: Record "Purchase Line";
            begin
                RecPurcLine.Reset();
                RecPurcLine.SetRange("Document No.", "No.");
                if RecPurcLine.Type = Type then
                    if Purchasehead.Get("GST Vendor Type"::Unregistered) then begin
                        RecPurcLine."GST Reverse Charge" := true;
                        Rec.Validate("GST Credit", "GST Credit"::Availment);
                        Rec.Modify();
                        //RecPurcLine."GST Credit" := "GST Credit"::Availment;
                    end;

            end;
        }
        modify("HSN/SAC Code")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                IF Rec.Type = Type::"Charge (Item)" then begin
                    Rec."GST Reverse Charge" := true;
                end;

            end;
        }


        //SK++
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                L_Item: Record Item;
                recItem: Record 27;
                recvendor: Record 23;
                recHeader: Record 38;
                RecItemNew: Record Item;
                RecItem1: Record Item;
                RecItem2: Record Item;
                RecItem3: Record Item;
                Bool: Boolean;
                ItemLedgEnrty: Record "Item Ledger Entry";
                PurchHdr: Record "Purchase Header";
            begin
                RecItemNew.Reset();
                RecItemNew.SetRange("No.", "No.");
                RecItemNew.SetFilter("Is Approved for Sale", 'False');
                if RecItemNew.FindFirst() then begin
                    if (RecItemNew."fc location" = 'AOD') or (RecItemNew."fc location" = 'AOM') or (RecItemNew."fc location" = 'KWH') or
                    (RecItemNew."fc location" = 'ONL') or (RecItemNew."fc location" = 'AOU') or (RecItemNew."fc location" = 'AOM 15') then
                        Bool := true else
                        Error('Approve Item');
                end;
                L_Item.Reset();
                L_Item.SetRange("No.", Rec."No.");
                if L_Item.FindFirst() then begin
                    Validate(MRP, L_Item."Unit Price");
                    Validate("Direct Unit Cost", L_Item."Unit Cost");
                end;
                if Rec."Document Type" = Rec."Document Type"::"Return Order" then begin
                    PurchHdr.Get("Document Type"::"Return Order", Rec."Document No.");
                    ItemLedgEnrty.Reset();
                    ItemLedgEnrty.SetRange("Item No.", Rec."No.");
                    ItemLedgEnrty.SetRange("Location Code", PurchHdr."Location Code");
                    if ItemLedgEnrty.FindLast() then begin
                        if ItemLedgEnrty."Remaining Quantity" = 0 then
                            Error('Inventory for this item is not availabe');
                    end else
                        Error('Inventory for this item is not availabe');
                end;
                //290523 CITS_RS Items only allowed when Same designer in Return order as master.
                // if Rec."Document Type" = Rec."Document Type"::"Return Order" then begin
                //     recHeader.get(Rec."Document Type"::"Return Order", Rec."No.");
                //     if Rec.Type = Rec.Type::Item then begin
                //         recItem.get(Rec."No.");
                //         recvendor.Get(recItem.designerID);
                //         if (recHeader."No." = Rec."Document No.") and (recHeader."Document Type" = Rec."Document Type")
                //          and (recItem.designerID <> recHeader."Buy-from Vendor No.") then
                //             Error('Item %1 is not associated with Vendor %1', recItem.Description, recvendor.Name);
                //     end;
                //     //290523
                // end;
                //KKS- 07/08/2023
                if ("Document Type" = "Document Type"::"Return Order") AND (Type = Type::Item) then begin
                    Validate(Quantity, 1);
                    Validate("Direct Unit Cost");
                    Validate("GST Group Code", '');
                    Validate("GST Credit", "GST Credit"::" ");
                end;
                if RecItem1.Get(Rec."No.") then begin
                    "PO type" := RecItem1."PO type";
                    Old_aza_code := RecItem1.Old_aza_code;
                    //  RecItem1.CalcFields("Vendor Name");290923
                    "Vendor Name" := RecItem1."Vendor Name";
                end;
                //KKS- 07/08/2023
            end;
        }
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            var
                RemQty: Decimal;
            begin
                // if Quantity > 0 then begin
                //     RemQty := Rec.Quantity - Rec."Damaged Qty";
                //     if Rec."Damaged Qty" <> 0 then
                //         if Rec."Qty. to Receive" > RemQty then
                //             Error('You can not enter Qty to receive more than %1', RemQty);
                // end;
            end;
        }


        //SK--
        field(50000; "Short Close"; Boolean)
        {
            DataClassification = ToBeClassified;

        }

        field(50001; "Damaged Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RemQty: Decimal;
            begin
                // if Rec.Quantity > 0 then begin
                //     RemQty := Rec.Quantity - Rec."Qty. to Receive";
                //     if Rec."Qty. to Receive" <> 0 then
                //         if Rec."Damaged Qty" > RemQty then
                //             Error('You can not enter damaged qty more than %1', RemQty);
                // end;
            end;

        }//Added by KJ T002 120922
        field(50002; "Fast Receive"; Boolean) { DataClassification = ToBeClassified; }
        //Added by KJ T002 120922
        field(50003; MRP; Decimal) { DataClassification = ToBeClassified; }
        field(50004; EditBool; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "QC Action"; Enum "GRN Action Status Enum") { DataClassification = ToBeClassified; }
        // Add changes to table fields here

        field(5000; "product_desc"; Text[1000])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.product_desc where("No." = field("No.")));
            // trigger OnValidate()
            // var
            //     lscdivision: Record Aza_Item;
            // begin
            //     if lscdivision.Get(Rec."No.") then begin
            //         product_desc := lscdivision.product_desc;

            //     end;
            // end;
        }
        field(50007; RTVboo; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "PO type"; Option)
        {
            OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright","MTO";
            OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            DataClassification = ToBeClassified;
        }
        field(50010; Old_aza_code; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Total Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Quantity where("Document Type" = field("Document Type"), "Document No." = field("Document No.")));
        }
    }
    trigger OnBeforeDelete()
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then //begin
            //if Rec."Short Close" = xRec."Short Close" then
            Rec.TestField("Short Close", false);
        //     If rec."Short Close" = true then
        //         Error('You can not');
        // end;

    end;

    trigger OnBeforeModify()
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then //begin  
            if (Rec."Short Close" <> xRec."Short Close") then begin
                if (xRec."Short Close" = true) then
                    //Rec.TestField("Short Close", false);
                   Error('You can not Change Short Close value');
            end else
                Rec.TestField("Short Close", false);
        //     If rec."Short Close" = true then
        //         Error('You can not');
        // end;
        if Rec."QC Action" = Rec."QC Action"::"RTV Alteration" then
            Error('You can not edit this line');
    end;

    var
        myInt: Integer;
}