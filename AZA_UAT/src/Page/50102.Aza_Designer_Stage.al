page 50102 Aza_Designer_Stage
{
    PageType = List;
    Caption = 'Aza Desginer Staging';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Aza_Designer;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(parent_designer_id; Rec.parent_designer_id) { ApplicationArea = All; }
                field(id; Rec.id) { ApplicationArea = All; }
                field(name; Rec.name) { ApplicationArea = All; }
                field(name_2; name_2) { ApplicationArea = All; }
                field(parent_designer_name; Rec.parent_designer_name) { ApplicationArea = All; }
                field(merchandiser_name; Rec.merchandiser_name) { ApplicationArea = All; }
                field(order_merchandiser_name; Rec.order_merchandiser_name) { ApplicationArea = All; }
                // field(PO_Type; Rec.type) { ApplicationArea = All; }//commented CITS_RS
                field(address; Rec.address) { ApplicationArea = All; }
                field(address_line1; Rec.address_line1) { ApplicationArea = All; }
                field(address_line2; Rec.address_line2) { ApplicationArea = All; }
                field(city; Rec.city) { ApplicationArea = All; }
                field(state; Rec.state)
                {
                    ApplicationArea = All;

                }
                field(country; Rec.country) { ApplicationArea = All; }
                field(pincode; Rec.pincode) { ApplicationArea = All; }
                field(email_to; Rec.email_to) { ApplicationArea = All; }
                field(email_cc; Rec.email_cc) { ApplicationArea = All; }
                field(contact_name_primary; Rec.contact_name_primary) { ApplicationArea = All; }
                field(email_name_primary; Rec.email_name_primary) { ApplicationArea = All; }
                field(phone_contact_primary; Rec.phone_contact_primary) { ApplicationArea = All; }
                field(contact_primary_job_Title; Rec.contact_primary_job_Title) { ApplicationArea = All; }
                field(contact_name_secondary; Rec.contact_name_secondary) { ApplicationArea = All; }
                field(email_contact_secondary; Rec.email_contact_secondary) { ApplicationArea = All; }
                field(phone_contact_secondary; Rec.phone_contact_secondary) { ApplicationArea = All; }
                field(contact_job_title_secondary; Rec.contact_job_title_secondary) { ApplicationArea = All; }
                field(reg_address; Rec.reg_address) { ApplicationArea = All; }
                field(reg_address_line1; Rec.reg_address_line1) { ApplicationArea = All; }
                field(reg_address_line2; Rec.reg_address_line2) { ApplicationArea = All; }
                field(reg_city; Rec.reg_city) { ApplicationArea = All; }
                field(reg_state; Rec.reg_state) { ApplicationArea = All; }
                field(reg_country; Rec.reg_country) { ApplicationArea = All; }
                field(reg_pincode; Rec.reg_country) { ApplicationArea = All; }
                field(reg_phone; Rec.reg_phone) { ApplicationArea = All; }
                field(reg_email_to; Rec.reg_email_to) { ApplicationArea = All; }
                field(reg_email_cc; Rec.reg_email_cc) { ApplicationArea = All; }
                field(reg_contact_name_primary; Rec.reg_contact_name_primary) { ApplicationArea = All; }
                field(reg_email_contact_primary; Rec.reg_email_contact_primary) { ApplicationArea = All; }
                field(reg_phone_contact_primary; Rec.reg_phone_contact_primary) { ApplicationArea = All; }
                field(reg_contact_primary_job_title; Rec.reg_contact_primary_job_title) { ApplicationArea = All; }
                field(reg_contact_name_secondary; Rec.reg_contact_name_secondary) { ApplicationArea = All; }

                field(reg_phone_contact_secondary; Rec.reg_phone_contact_secondary) { ApplicationArea = All; }
                field(reg_email_contact_secondary; Rec.reg_email_contact_secondary) { ApplicationArea = All; }
                field(reg_contact_job_title_secondary; Rec.reg_contact_jobtitle_secondary) { ApplicationArea = All; }
                field(gst_registered; Rec.gst_registered) { ApplicationArea = All; }
                field(gst_no; Rec.gst_no) { ApplicationArea = All; }
                field(gst_attachment; Rec.gst_attachment) { ApplicationArea = All; }
                field(gst_registration_date; Rec.gst_registration_date) { ApplicationArea = All; }
                field(pan_number; Rec.pan_number) { ApplicationArea = All; }
                field(pan_attachment; Rec.pan_attachment) { ApplicationArea = All; }
                field(bank_account_number; Rec.bank_account_number) { ApplicationArea = All; }
                field(bank_name; Rec.bank_name) { ApplicationArea = All; }
                field(branch_name; Rec.branch_name) { ApplicationArea = All; }
                field(ifsc_code; Rec.ifsc_code) { ApplicationArea = All; }
                field(cancelled_cheque_attachment; Rec.cancelled_cheque_attachment) { ApplicationArea = All; }
                field(msme_registered; Rec.msme_registered) { ApplicationArea = All; }
                field(msme_registration_no; Rec.msme_registration_no) { ApplicationArea = All; }
                field(msme_certificate; Rec.msme_certificate) { ApplicationArea = All; }
                field(msme_registration_date; Rec.msme_registration_date) { ApplicationArea = All; }
                field(additional_charge_type; Rec.additional_charge_type) { ApplicationArea = All; }
                field(additional_charge; Rec.additional_charge) { ApplicationArea = All; }
                field(po_price_type; Rec.po_price_type) { ApplicationArea = All; }
                field(declaration_flag; Rec.declaration_flag) { ApplicationArea = All; }
                field(signature_name; Rec.signature_name) { ApplicationArea = All; }
                field(signature_place; Rec.signature_place) { ApplicationArea = All; }
                field(designation; Rec.designation) { ApplicationArea = All; }
                field(date_added; Rec.date_added) { ApplicationArea = All; }
                field(added_by; Rec.added_by) { ApplicationArea = All; }
                field(date_modified; Rec.date_modified) { ApplicationArea = All; }
                field(modified_by; Rec.modified_by) { ApplicationArea = All; }
                field(status; Rec.status) { ApplicationArea = All; }
                field(return_policy; Rec.return_policy) { ApplicationArea = All; }
                field(is_deleted; Rec.is_deleted) { ApplicationArea = All; }
                field(classification_tag; Rec.classification_tag) { ApplicationArea = All; }
                field(is_show_sale; Rec.is_show_sale) { ApplicationArea = All; }
                field(seouri; Rec.seouri) { ApplicationArea = All; }
                field(show_cat_section; Rec.show_cat_section) { ApplicationArea = All; }
                field(show_cat_section_data; Rec.show_cat_section_data) { ApplicationArea = All; }
                field(seo_content; Rec.seo_content) { ApplicationArea = All; }
                field(description; Rec.description) { ApplicationArea = All; }
                field(sale_text; Rec.sale_text) { ApplicationArea = All; }
                field(banner_image; Rec.banner_image) { ApplicationArea = All; }
                field(is_show_counter; Rec.is_show_counter) { ApplicationArea = All; }
                field(counter_start_date; Rec.counter_start_date) { ApplicationArea = All; }
                field(counter_end_date; Rec.counter_end_date) { ApplicationArea = All; }
                field(is_show_cod; Rec.is_show_cod) { ApplicationArea = All; }
                field("Record Status"; Rec."Record Status") { ApplicationArea = all; }

                field("No. of Errors"; Rec."No. of Errors") { ApplicationArea = all; }
                field("Error Text"; Rec."Error Text") { ApplicationArea = all; }
                field(merchant_status; merchant_status) { ApplicationArea = all; }
                field(merchant_approved_by; merchant_approved_by) { ApplicationArea = all; }
                field(finance_status; finance_status) { ApplicationArea = all; }
                field(final_approved_status; final_approved_status) { ApplicationArea = all; }
                field(finance_approved_by; finance_approved_by) { ApplicationArea = all; }
                field(designer_code; designer_code) { ApplicationArea = all; }
                field(company_name; company_name) { ApplicationArea = all; }
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
            action(CreateVendor)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Create Designers';


                trigger OnAction();
                var
                    CU_ItemDesigner: Codeunit 50104;//50113;// ProcessItem_Designer;
                    recErrorLog: Record ErrorCapture;
                begin

                    CU_ItemDesigner.ProcessVendors();
                end;
            }
            action("Rectify Errors")
            {
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;//CITS_RS 250123
                trigger OnAction();
                var
                    CU_ItemDesigner: Codeunit ProcessItem_Designer;
                    recDesignerStage: Record Aza_Designer;
                    recDesignerStage1: Record Aza_Designer;
                    ErrorLog: Record ErrorCapture;
                    CreateVendors: Codeunit CreateVendors;
                begin
                    recDesignerStage.Reset();
                    recDesignerStage.SetRange("Record Status", recDesignerStage."Record Status"::Error);
                    if recDesignerStage.FindSet() then
                        repeat
                            ErrorLog.Reset();
                            ErrorLog.SetRange("Process Type", ErrorLog."Process Type"::"Vendor Creation");
                            ErrorLog.SetRange("Vendor Code", format(recDesignerStage.id));
                            if ErrorLog.FindSet() then begin
                                repeat

                                    if ErrorLog."Error Remarks" = 'Parent designer ID is missing' then
                                        if (recDesignerStage.parent_designer_id <> '0') or
                                            (recDesignerStage.parent_designer_id <> '') then
                                            ErrorLog.Delete();

                                    if ErrorLog."Error Remarks" = 'Designer ID is missing' then
                                        if recDesignerStage.id <> 0 then
                                            ErrorLog.Delete();

                                    if ErrorLog."Error Remarks" = 'State is missing' then
                                        if recDesignerStage.state <> '' then
                                            ErrorLog.Delete();

                                    if ErrorLog."Error Remarks" = 'Country is missing' then
                                        if recDesignerStage.country <> '' then
                                            ErrorLog.Delete();

                                    if ErrorLog."Error Remarks" = 'PINCODE is missing' then
                                        if recDesignerStage.pincode <> 0 then
                                            ErrorLog.Delete();

                                    if ErrorLog."Error Remarks" = 'GST Registration Number is missing' then
                                        if recDesignerStage.pincode <> 0 then
                                            ErrorLog.Delete();

                                    if ErrorLog."Error Remarks" = 'PAN Number is missing' then
                                        if recDesignerStage.pincode <> 0 then
                                            ErrorLog.Delete();
                                    Commit();
                                    ;
                                until ErrorLog.Next() = 0;
                            end;

                            recDesignerStage.CalcFields("No. of Errors");
                            if recDesignerStage."No. of Errors" = 0 then begin
                                recDesignerStage."Record Status" := recDesignerStage."Record Status"::" ";
                                recDesignerStage.Modify();
                            end;
                            Commit();
                            if not CreateVendors.Run(recDesignerStage) then begin
                                recDesignerStage1.Reset();
                                recDesignerStage1.SetRange(id, recDesignerStage.id);
                                if recDesignerStage1.FindFirst() then;
                                ErrorLog.Init();
                                if ErrorLog.FindLast() then
                                    ErrorLog."Sr. No" += 1
                                else
                                    ErrorLog."Sr. No" := 1;
                                ErrorLog."Error Remarks" := GetLastErrorText();
                                ErrorLog."Error DateTime" := CurrentDateTime;
                                ErrorLog.Insert();
                                recDesignerStage1."Record Status" := recDesignerStage1."Record Status"::Error;
                                recDesignerStage1.Modify();
                            end;//else
                                // CU_ItemDesigner.DeleteErrorLogs_Vendor(recDesignerStage);
                        until recDesignerStage.Next() = 0;
                    Message('Errors corrected');
                end;

            }
        }
    }
}