pageextension 50102 PurchLine_ext extends "Purchase Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(MRP; rec.MRP)
            {
                ApplicationArea = all;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Short Close"; Rec."Short Close")
            {
                ApplicationArea = all;

                trigger OnValidate()
                var
                    PurchLine: Record "Purchase Line";
                    RecpurchLine: Record "Purchase Line";
                    PurchHeader: Record "Purchase Header";

                begin
                    if Rec."Outstanding Quantity" = 0 then
                        Error('Outstanding Qty should not equal to Zero');

                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."Document No.");
                    PurchLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
                    if PurchLine.FindSet(true) then
                        repeat
                            if PurchLine.Quantity = PurchLine."Quantity Received" then begin
                                PurchLine."Short Close" := true;
                                PurchLine.Modify();
                            end;
                        until PurchLine.Next() = 0;

                    RecpurchLine.Reset();
                    RecpurchLine.SetRange("Document Type", Rec."Document Type");
                    RecpurchLine.SetRange("Document No.", Rec."Document No.");
                    RecpurchLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
                    RecpurchLine.SetRange("Short Close", false);
                    if not RecpurchLine.FindFirst() then begin
                        PurchHeader.Get(Rec."Document Type", Rec."Document No.");
                        PurchHeader."Short Close" := true;
                        PurchHeader.Modify();
                    end;

                end;

            }
        }
        addafter("Quantity Invoiced")
        {
            field("Damaged Qty"; Rec."Damaged Qty") { ApplicationArea = all; }//Added by KJ T002 120922
        }
        addafter("Quantity Invoiced")
        {
            field("Fast Receive"; Rec."Fast Receive") { ApplicationArea = all; }//Added by KJ T002 120922
        }
        addafter("GST Credit")
        {
            field("GST Reverse Charge"; "GST Reverse Charge")
            {
                ApplicationArea = All;
                Editable = true;

            }
            field("QC Action"; Rec."QC Action")
            {
                ApplicationArea = all;
            }
        }

        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            var
                GSTMaster: Record "GST Master";
                item1: Record Item;
                recVendor: Record Vendor;
                recPurLine: Record "Purchase Line";
            begin
                if item1.Get(Rec."No.") then begin
                    GSTMaster.Reset();
                    GSTMaster.SetRange(GSTMaster.Category, item1."LSC Division Code");
                    GSTMaster.SetRange(GSTMaster."Subcategory 1", item1."Item Category Code");
                    GSTMaster.SetRange(GSTMaster."Subcategory 2", item1."LSC Retail Product Code");
                    GSTMaster.SetRange(Fabric_Type, item1."Fabric Type");
                    GSTMaster.SetFilter("From Amount", '<=%1', Rec."Direct Unit Cost");
                    GSTMaster.SetFilter("To Amount", '>=%1', Rec."Direct Unit Cost");
                    if GSTMaster.FindFirst() then begin
                        Rec.Validate("GST Group Code", GSTMaster."GST Group");
                        //Naveen
                        if recVendor.Get(item1.designerID) then
                            if recVendor."GST Vendor Type" = recVendor."GST Vendor Type"::Unregistered then
                                if recPurLine."GST Reverse Charge" = true then
                                    recPurLine.Validate("GST Reverse Charge", true);//Naveen
                        Rec.Validate("GST Reverse Charge", true);//Naveen
                        Rec.Validate("HSN/SAC Code", GSTMaster."HSN Code");

                    end;
                    Rec.Modify();
                end;
            end;
        }
        // modify("No.")
        // {
        //     trigger OnLookup(var Text: Text): Boolean
        //     var
        //         ItemRec: Record Item;
        //     begin
        //         ItemRec.Reset();
        //         if Page.RunModal(Page::"Item List", ItemRec) = Action::LookupOK then
        //             No := ItemRec."No.";
        //     end;
        // }
        // addafter(Description)
        // {
        //     field(product_desc; product_desc)
        //     {
        //         ApplicationArea = All;
        //     }
        // }

        // Add changes to page layout here
        //modify(Control1) { Editable = (not Rec."Short Close"); }//cocoon

    }
    var
        No: Code[20];

}