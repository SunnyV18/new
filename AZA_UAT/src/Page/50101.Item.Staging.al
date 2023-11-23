page 50101 "Aza Item Staging"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Aza_Item;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = all; }
                field(bar_code; Rec.bar_code) { ApplicationArea = All; }
                field(tag_code; Rec.tag_code) { ApplicationArea = All; }
                field(Old_aza_code; Rec.Old_aza_code) { ApplicationArea = All; }
                field(aza_code; Rec.aza_code) { ApplicationArea = All; }
                field(category_name; Rec.category_name) { ApplicationArea = All; }
                field(category_code; Rec.category_code) { ApplicationArea = All; }
                field(sub_category_code; Rec.sub_category_code) { ApplicationArea = All; }
                field(sub_category_name; Rec.sub_category_name) { ApplicationArea = All; }
                field(sub_sub_category_name; Rec.sub_sub_category_name) { ApplicationArea = All; }
                field(sub_sub_category_code; Rec.sub_sub_category_code) { ApplicationArea = All; }
                field("po_type"; Rec.po_type)
                {


                }
                field(designer_id; Rec.designer_id) { ApplicationArea = All; }
                field(parent_designer_id; Rec.parent_designer_id) { ApplicationArea = All; }
                field(components_no; Rec.components_no) { ApplicationArea = All; }
                field(neckline_type; Rec.neckline_type) { ApplicationArea = All; }
                field(sleeve_length; Rec.sleeve_length) { ApplicationArea = All; }
                field(closure_type; Rec.closure_type) { ApplicationArea = All; }
                field(fabric_type; Rec.fabric_type) { ApplicationArea = All; }
                field(type_of_work; Rec.type_of_work) { ApplicationArea = All; }
                field(type_of_pattern; Rec.type_of_pattern) { ApplicationArea = All; }
                field(designer_code; Rec.designer_code) { ApplicationArea = All; }
                field(product_title; Rec.product_title) { ApplicationArea = All; }
                field(sleeve_type; Rec.sleeve_type) { ApplicationArea = All; }
                // field(stylist_note; Rec.stylistNote) { ApplicationArea = All; }
                field(product_thumbing; Rec.product_thumbImg) { ApplicationArea = All; }
                field(date_added; Rec.date_added) { ApplicationArea = All; }

                field(modified_date; Rec.modified_date) { ApplicationArea = All; }
                field(status; Rec.status) { ApplicationArea = All; }
                field(modified_by; Rec.modified_by) { ApplicationArea = All; }
                field(merchandise_name; Rec.merchandise_name) { ApplicationArea = All; }
                field(image1; Rec.image1) { ApplicationArea = All; }
                field(image2; Rec.image2) { ApplicationArea = All; }
                field(image3; Rec.image3) { ApplicationArea = All; }
                field(image4; Rec.image4) { ApplicationArea = All; }
                field(image5; Rec.image5) { ApplicationArea = All; }
                field(image6; Rec.image6) { ApplicationArea = All; }
                field(image7; Rec.image7) { ApplicationArea = All; }
                field(image8; Rec.image8) { ApplicationArea = All; }
                field(image9; Rec.image9) { ApplicationArea = All; }
                field(image10; Rec.image10) { ApplicationArea = All; }
                field(size_id; Rec.size_id) { ApplicationArea = All; }
                field(color_id; Rec.color_id) { ApplicationArea = All; }
                field(warehouse_stock; Rec.warehouse_stock) { ApplicationArea = All; }
                field(product_price; Rec.product_price) { ApplicationArea = All; }
                field(product_cost; Rec.product_cost) { ApplicationArea = All; }
                field(discount_percent; Rec.discount_percent) { ApplicationArea = All; }
                field(discount_percent_by_aza; Rec.discount_percent_by_aza) { ApplicationArea = All; }
                field(discount_price; Rec.discount_price) { ApplicationArea = All; }
                field(discount_percent_by_desg; Rec.discount_percent_by_desg) { ApplicationArea = all; }
                field(fc_location; Rec.fc_location) { applicationarea = all; }
                field(quantity_received; Rec.quantity_received) { ApplicationArea = all; }
                field(qc_status; Rec.qc_status) { ApplicationArea = all; }
                field(action_status; Rec.action_status) { ApplicationArea = all; }
                field(type_of_inventory; Rec.type_of_inventory) { ApplicationArea = all; }
                field("Record Status"; Rec."Record Status") { ApplicationArea = all; }
                field("PO Created"; Rec."PO Created") { ApplicationArea = all; }
                // field("Customer No."; Rec."Customer No.") { ApplicationArea = all; }
                field(Customer_ID; Rec.Customer_ID) { ApplicationArea = all; }

                field(waist; Rec.waist)
                {
                    ApplicationArea = all;
                }
                field(bust; Rec.bust) { ApplicationArea = all; }
                field(hip; Rec.hip) { ApplicationArea = all; }
                field(shoulder; Rec.shoulder) { ApplicationArea = all; }
                field(check; Rec.check) { ApplicationArea = all; }
                field("No. of Errors"; Rec."No. of Errors")
                {
                    ApplicationArea = all;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = all;
                }
                field("Error date"; Rec."Error date")
                {
                    ApplicationArea = all;
                }
                field(Is_Outward; Rec.Is_Outward) { ApplicationArea = all; }
                field("RTV Created"; Rec."RTV Created") { ApplicationArea = all; }
                field(product_desc; product_desc) { ApplicationArea = All; }
                // field(filterPrice; Rec.filterPrice) { ApplicationArea = All; }
                field(component_desc; Rec.component_desc) { ApplicationArea = All; }
                field(sales_associate; Rec.sales_associate) { ApplicationArea = All; }
                field(is_padded; Rec.is_padded) { ApplicationArea = All; }
                field(is_attached_can_can; Rec.is_attached_can_can) { ApplicationArea = All; }
                field(query_confirmed_by; Rec.query_confirmed_by) { ApplicationArea = All; }
                field(collection_type; Rec.collection_type) { ApplicationArea = All; }
                field(type_classification; Rec.type_classification) { ApplicationArea = All; }
                field(desg_extra_charges; Rec.desg_extra_charges) { ApplicationArea = All; }
                field(aza_extra_charges; Rec.aza_extra_charges) { ApplicationArea = All; }
                field(order_delivery_date; Rec.order_delivery_date) { ApplicationArea = All; }
                field(measurements; Rec.measurements) { ApplicationArea = All; }
                field(ref_barcode; Rec.ref_barcode) { ApplicationArea = All; }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateItem)
            {
                ApplicationArea = All;
                Promoted = true;
                Caption = 'Create Items';
                PromotedIsBig = true;
                Visible = Visible1;
                trigger OnAction();
                var
                    CU_ItemDesigner: Codeunit ProcessItem_Designer_New;
                begin
                    CU_ItemDesigner.ProcessItems();

                end;
            }
            action(CreatePO)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Create Purchase Orders';
                trigger OnAction();
                var
                    CU_POCreate: Codeunit PO_CreationfromStaging;
                    reCVendor: Record Vendor;
                    itemStag: Record Aza_Item;
                begin
                    //CU_POCreate.ProcessPurchaseOrders();
                    CU_POCreate.ProcessPOs();
                    //     if fc_location = '1' then begin
                    //         if (po_type= po_type::"C0-Customer Order") or (po_type = po_type::"CON-Consignment") or (po_type = po_type::MTO) then begin
                    //             CurrPage.Skip;
                    //         end;
                    //     end;
                    // end;
                end;

            }
            // action(CreatePO2)
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     Caption = 'Create Purchase Orders 2';
            //     trigger OnAction();
            //     var
            //         CU_POCreate: Codeunit PO_CreationfromStaging;
            //         reCVendor: Record Vendor;
            //         itemStag: Record Aza_Item;
            //     begin
            //         CU_POCreate.ProcessPOs2();
            //     end;

            // }
            action(PoNoUpdation)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'PoNoUpdation';
                trigger OnAction();
                var
                    Pheader: Record 38;
                    pline: Record 39;
                    itemStag: Record Aza_Item;
                    item: Record item;
                begin
                    itemStag.Reset();
                    itemStag.SetFilter(fc_location, '=%1|%2|%3', '355', '356', '357');
                    if itemStag.FindSet() then
                        repeat
                            pline.Reset();
                            pline.SetRange("No.", itemStag.bar_code);
                            if pline.FindFirst() then begin
                                if item.get(pline."No.") then begin
                                    item."PO No." := pline."Document No.";
                                    item.Modify();
                                end;
                            end;
                        until itemStag.Next() = 0;
                end;

            }
            action("Eliminate Errors")
            {
                ApplicationArea = All;
                Visible = false;//CITS_RS 250123
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    recItemStage: Record Aza_Item;
                    ErrorLog: Record ErrorCapture;
                    L_Vendor: Record Vendor;
                begin
                    recItemStage.Reset();
                    recItemStage.SetRange("Record Status", recItemStage."Record Status"::Error);
                    if recItemStage.FindSet() then
                        repeat
                            ErrorLog.Reset();
                            ErrorLog.SetRange("Process Type", ErrorLog."Process Type"::"Item Creation");
                            ErrorLog.SetRange(Item_code, recItemStage.bar_code);
                            if ErrorLog.FindSet() then begin
                                repeat
                                    if ErrorLog."Error Remarks" = 'Main category is missing' then begin
                                        if recItemStage.category_code <> '' then
                                            ErrorLog.Delete();
                                    end;
                                    if ErrorLog."Error Remarks" = 'sub category is missing' then begin
                                        if recItemStage.sub_category_code <> '' then
                                            ErrorLog.Delete();
                                    end;
                                    if ErrorLog."Error Remarks" = 'Child designer is missing' then begin
                                        if recItemStage.designer_id <> '' then
                                            ErrorLog.Delete();
                                    end;
                                    if ErrorLog."Error Remarks" = 'Product title is missing' then begin
                                        if recItemStage.product_title <> '' then
                                            ErrorLog.Delete();
                                    end;
                                    if ErrorLog."Error Remarks" = 'Number of components is blank' then begin
                                        if recItemStage.components_no <> 0 then
                                            ErrorLog.Delete();
                                    end;
                                    if ErrorLog."Error Remarks" = 'Color name is blank' then begin
                                        if recItemStage.color_id <> '' then
                                            ErrorLog.Delete();
                                    end;
                                    if ErrorLog."Error Remarks" = 'FC master is missing' then begin
                                        if recItemStage.fc_location <> '' then
                                            ErrorLog.Delete();
                                    end;
                                    if ErrorLog."Error Remarks" = 'Vendor does not exist' then begin
                                        if recItemStage.designer_id <> '' then begin
                                            L_Vendor.Reset();
                                            L_Vendor.SetRange("No.", recItemStage.designer_id);
                                            if L_Vendor.FindFirst() then begin
                                                ErrorLog.Delete();
                                            end;
                                        end;
                                    end;
                                until ErrorLog.Next() = 0;
                                recItemStage.CalcFields("No. of Errors");
                                if recItemStage."No. of Errors" = 0 then begin
                                    recItemStage."Record Status" := recItemStage."Record Status"::" ";
                                    recItemStage.Modify();
                                end;
                            end;
                        until recItemStage.Next() = 0;
                    Message('Process completed');
                end;

            }
        }
    }
    trigger OnOpenPage()
    var
        CI: Record "LSC Retail User";
    begin
        if usersetup.Get(UserId) then
            if usersetup."Edit Page" = false then
                Visible1 := false
            else
                Visible1 := true;
    end;

    var
        Visible1: Boolean;
        usersetup: Record "LSC Retail User";
}