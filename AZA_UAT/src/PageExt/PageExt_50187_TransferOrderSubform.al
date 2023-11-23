pageextension 50187 "Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {
        modify("Transfer Price")
        {
            Editable = false;
            trigger OnAfterValidate()
            var
                GSTMaster: Record "GST Master";
                item1: Record Item;
            begin
                if item1.Get(Rec."Item No.") then begin
                    GSTMaster.Reset();
                    GSTMaster.SetRange(GSTMaster.Category, item1."LSC Division Code");
                    GSTMaster.SetRange(GSTMaster."Subcategory 1", item1."Item Category Code");
                    GSTMaster.SetRange(GSTMaster."Subcategory 2", item1."LSC Retail Product Code");
                    //GSTMaster.SetRange(Fabric_Type, item1."Fabric Type");
                    GSTMaster.SetFilter("From Amount", '<=%1', Rec."Transfer Price");
                    GSTMaster.SetFilter("To Amount", '>=%1', Rec."Transfer Price");
                    if GSTMaster.FindFirst() then begin
                        Rec.Validate("GST Group Code", GSTMaster."GST Group");
                        Rec.Validate("HSN/SAC Code", GSTMaster."HSN Code");
                    end;
                    Rec.Modify();
                end;
            end;
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //commented CITSRS 290523
                // if Rec."Item No." <> '' then
                //     Rec.Validate(Quantity, 1);
                // Rec.Modify();

            end;
        }
        addafter("HSN/SAC Code")
        {
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group") { ApplicationArea = All; Editable = false; }
            field("Inventory Posting Group"; "Inventory Posting Group") { ApplicationArea = All; Editable = false; }
        }
        addafter(Description)
        {
            field("Vendor Name"; "Vendor Name") { ApplicationArea = All; Editable = false; }
            field("PO type"; "PO type") { ApplicationArea = All; Editable = false; }
            field(Old_aza_code; Old_aza_code) { ApplicationArea = All; Editable = false; }
        }
        modify(Description)
        {
            Editable = false;
        }
        modify(Quantity)
        {
            Editable = false;
        }
        modify(Amount)
        {
            Editable = false;
        }
        modify("GST Credit")
        {
            Editable = false;
        }
        modify("Reserved Quantity Inbnd.")
        {
            Editable = false;
        }
        modify("Reserved Quantity Outbnd.")
        {
            Editable = false;
        }
        modify("Reserved Quantity Shipped")
        {
            Editable = false;
        }
        modify("Unit of Measure Code")
        {
            Editable = false;
        }
        modify("Qty. to Ship")
        {
            Editable = false;
        }
        modify("Qty. to Receive")
        {
            Editable = false;
        }
        modify("Shipment Date")
        {
            Editable = false;
        }
        modify("Receipt Date")
        {
            Editable = false;
        }
        modify("Custom Duty Amount")
        {
            Editable = false;
        }
        modify("GST Assessable Value")
        {
            Editable = false;
        }
        modify("GST Group Code")
        {
            Editable = false;
        }
        modify("HSN/SAC Code")
        {
            Editable = false;
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}