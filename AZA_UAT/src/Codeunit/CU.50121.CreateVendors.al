codeunit 50121 "CreateVendors"
{
    TableNo = Aza_Designer;
    trigger OnRun()
    begin
        CreateVendors(Rec);
    end;

    var
        cuFunctions: Codeunit Functions;
        glVendorCreated: Boolean;

    procedure CreateVendors(Var recDesignerStage: Record Aza_Designer)
    var
        // recDesignerStage: Record Aza_Designer;
        CU_NoSeries: Codeunit NoSeriesManagement;
        recPurchPayable: Record "Purchases & Payables Setup";
        recVendor: Record Vendor;
        vendorbankacc: Record "Vendor Bank Account";
        RegOrderAdd: Record "Order Address";
        RecordLink1: Record "Record Link";
        addressCount: Integer;
        LinkNo: Integer;
        recorderAdd: Record "Order Address";
        recVendor1: Record 23;
        StateC: Record State;
        recErrorLog: Record ErrorCapture;
        gstAttachmentInserted: Boolean;
        errorFound: Boolean;
        CountryC: Record "Country/Region";
    begin
        Clear(errorFound);
        Clear(glVendorCreated);
        // recDesignerStage.Reset();
        // recDesignerStage.SetRange("Record Status", recDesignerStage."Record Status"::" ");
        // if recDesignerStage.Find('-') then
        //     repeat
        if recVendor.get(recDesignerStage.id) then begin
            //Error('Vendor %1 already exists', recDesignerStage.id);//240123
            updateVendors(recDesignerStage);
            exit;
        end;

        if (recDesignerStage.parent_designer_id = '0') or (recDesignerStage.parent_designer_id = '') then begin
            cuFunctions.CreateErrorLog(3, 'Parent designer ID is missing', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
            errorFound := true;
            // exit;
        end;

        if (recDesignerStage.id = 0) then begin
            cuFunctions.CreateErrorLog(3, 'Designer ID is missing', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
            errorFound := true;
            // exit;
        end;

        if (recDesignerStage.state = '') then begin
            cuFunctions.CreateErrorLog(3, 'State is missing', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
            errorFound := true;
            // exit;
        end;

        if (recDesignerStage.country = '') then begin
            cuFunctions.CreateErrorLog(3, 'Country is missing', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
            errorFound := true;
            // exit;
        end;

        if (recDesignerStage.pincode = 0) then begin
            cuFunctions.CreateErrorLog(3, 'PINCODE is missing', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
            errorFound := true;
            // exit;
        end;
        if recDesignerStage.gst_registered then begin
            if (recDesignerStage.gst_no = '') then begin
                cuFunctions.CreateErrorLog(3, 'GST Registration Number is missing', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
                errorFound := true;
                // exit;
            end;

            if (recDesignerStage.pan_number = '') then begin
                cuFunctions.CreateErrorLog(3, 'PAN Number is missing', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
                errorFound := true;
                // exit;
            end;
        end;

        Clear(gstAttachmentInserted);
        // if recDesignerStage.parent_designer_id = '' then
        //     Error('Please enter parent designer id');
        recVendor.Init();
        //recVendor."No." := recDesignerStage.parent_designer_id;
        recVendor."No." := Format(recDesignerStage.id);
        //recVendor.Name := recDesignerStage.parent_designer_name;
        recVendor.Name := recDesignerStage.name;
        recVendor."Search Name" := recDesignerStage.name_2;
        recVendor.Type := recDesignerStage.type;
        if (recDesignerStage.address_line1 = '') and (recDesignerStage.address_line2 = '') and
         (recDesignerStage.address <> '') then begin
            recVendor.Address := CopyStr(recDesignerStage.address, 1, 49);
            recVendor."Address 2" := CopyStr(recDesignerStage.address, 49, 50);
            recVendor."Address 3" := recDesignerStage.address_line2;
        end else begin
            if recDesignerStage.address <> '' then
                recVendor.Address := CopyStr(recDesignerStage.address, 1, 99);
            if recDesignerStage.address_line1 <> '' then
                recVendor."Address 2" := copystr(recDesignerStage.address_line1, 1, 49);
            if recDesignerStage.address_line2 <> '' then
                recVendor."Address 3" := CopyStr(recDesignerStage.address_line2, 1, 99);
        end;

        recVendor.City := recDesignerStage.city;
        if CountryC.Get(recDesignerStage.country) then
            recVendor.validate("Country/Region Code", CountryC.Code);
        CountryC.Reset();
        CountryC.SetRange(Name, recDesignerStage.country);
        if CountryC.FindFirst() then
            recVendor.validate("Country/Region Code", CountryC.Code)
        else
            Error('Country %1 not found in the master', recDesignerStage.country);

        StateC.Reset();
        StateC.SetRange(Description, recDesignerStage.state);
        if StateC.FindFirst() then
            // recVendor."State Code" := StateC.Code //recDesignerStage.state;
            recVendor.validate("State Code", StateC.Code)//recDesignerStage.state;
        else
            Error('State %1 not found in the master', recDesignerStage.state);
        recVendor.validate("Post Code", format(recDesignerStage.pincode));
        // addressCount :=1;
        // recorderAdd.Reset();
        // recorderAdd.SetRange("Vendor No.",format(recDesignerStage.id));
        // if recorderAdd.find('-') then repeat
        //     addressCount+=1
        // until recorderAdd.Next()=0;
        //Nkp++
        // if recDesignerStage
        //Nkp--
        if recDesignerStage.gst_registered then begin
            recVendor."P.A.N. Status" := recVendor."P.A.N. Status"::" ";
            recVendor."P.A.N. No." := recDesignerStage.pan_number;
            recVendor.validate("GST Registration No.", recDesignerStage.gst_no);
            recVendor.validate("GST Vendor Type", recVendor."GST Vendor Type"::Registered);
        end else begin
            recVendor."P.A.N. No." := recDesignerStage.pan_number;
            recVendor.validate("GST Vendor Type", recVendor."GST Vendor Type"::Unregistered);
        end;
        recVendor.validate("Phone No.", Format(recDesignerStage.reg_phone_contact_primary));
        recVendor.Validate("Payment Terms Code", '0 Days'); //100223k
        //recVendor."E-Mail" := recDesignerStage.email_to;
        recVendor."Email to" := recDesignerStage.email_to;
        recVendor."Email cc" := recDesignerStage.email_cc;
        recVendor.Contact := recDesignerStage.contact_name_primary;
        recVendor."Mobile Phone No." := Format(recDesignerStage.phone_contact_primary);

        recVendor."Gen. Bus. Posting Group" := 'Domestic';
        recVendor."Vendor Posting Group" := 'Domestic';

        //Attributes>>
        recVendor."Parent designer id" := recDesignerStage.parent_designer_id;
        recVendor."Parent designer name" := recDesignerStage.parent_designer_name;
        recVendor."Merchandiser name" := recDesignerStage.merchandiser_name;
        recVendor."Order merchandiser name" := recDesignerStage.order_merchandiser_name;
        recVendor."Contact name primary" := recDesignerStage.contact_name_primary;
        recVendor."Email name primary" := recDesignerStage.email_name_primary;
        recVendor."Phone contact primary" := Format(recDesignerStage.phone_contact_primary);
        recVendor."Mobile Phone No." := Format(recDesignerStage.phone_contact_primary);
        recVendor."Contact primary job Title" := recDesignerStage.contact_primary_job_Title;
        recVendor."Contact job title secondary" := recDesignerStage.contact_job_title_secondary;
        recVendor."Contact name secondary" := recDesignerStage.contact_name_secondary;
        recVendor."email contact secondary" := recDesignerStage.email_contact_secondary;
        recVendor."Phone contact secondary" := Format(recDesignerStage.phone_contact_secondary);
        recVendor."Reg address" := recDesignerStage.reg_address;
        recVendor."Reg address line1" := recDesignerStage.reg_address_line1;
        recVendor."Reg address line2" := recDesignerStage.reg_address_line2;
        recVendor."Reg city" := recDesignerStage.reg_city;
        recVendor."Reg state" := recDesignerStage.reg_state;
        recVendor."Reg country" := recDesignerStage.reg_country;
        //recVendor."Reg country1":=recDesignerStage.reg
        recVendor."Reg phone" := recDesignerStage.reg_phone;
        recVendor."Reg email to" := recDesignerStage.reg_email_to;
        recVendor."Reg email cc" := recDesignerStage.reg_email_cc;
        recVendor."Reg contact name primary" := recDesignerStage.reg_contact_name_primary;
        recVendor."Reg email contact primary" := recDesignerStage.reg_email_contact_primary;
        recVendor."Reg contact primary job title" := recDesignerStage.reg_contact_primary_job_title;
        recVendor."Reg contact jobtitle secondary" := recDesignerStage.reg_contact_jobtitle_secondary;
        recVendor."Reg contact name secondary" := recDesignerStage.reg_contact_name_secondary;
        recVendor."Reg phone contact secondary" := format(recDesignerStage.reg_phone_contact_secondary);
        recVendor."Reg email contact secondary" := recDesignerStage.reg_email_contact_secondary;
        recVendor."Designer code" := recDesignerStage.designer_code;
        //inserted in record links
        // if recDesignerStage.gst_registered then
        //     recVendor."Gst attachment" := recDesignerStage.gst_attachment;
        if recDesignerStage.gst_registered then
            recVendor."Gst registration date" := recDesignerStage.gst_registration_date;
        //inserted in record links
        // if recDesignerStage.gst_registered then
        //     recVendor."Pan attachment" := recDesignerStage.pan_attachment;
        // recVendor."Cancelled cheque attachment" := recDesignerStage.cancelled_cheque_attachment;
        recVendor."msme registered" := recDesignerStage.msme_registered;
        recVendor."msme registration no" := recDesignerStage.msme_registration_no;
        recVendor."msme registration date" := recDesignerStage.msme_registration_date;
        recVendor."Additional charge type" := recDesignerStage.additional_charge_type;
        recVendor."Additional charge" := recDesignerStage.additional_charge;
        recVendor."Po price type" := recDesignerStage.po_price_type;
        recVendor."Declaration flag" := recDesignerStage.declaration_flag;
        recVendor."Signature name" := recDesignerStage.signature_name;
        recVendor."Signature place" := recDesignerStage.signature_place;
        recVendor.Designation := recDesignerStage.designation;
        recVendor.Date_added := recDesignerStage.date_added;
        recVendor."Added by" := recDesignerStage.added_by;
        recVendor."Date modified" := recDesignerStage.date_modified;
        recVendor."Modified by" := recDesignerStage.modified_by;
        recVendor.Status := recDesignerStage.status;
        // if not recDesignerStage.status then //CITS_RS 130223
        //     recVendor.Blocked := recVendor.Blocked::All;
        // if recDesignerStage.is_deleted then
        //     recVendor.Blocked := recVendor.Blocked::All;
        recVendor."Return policy" := recDesignerStage.return_policy;
        recVendor."Is deleted" := recDesignerStage.is_deleted;
        recVendor."Classification tag" := recDesignerStage.classification_tag;
        recVendor."Is show sale" := recDesignerStage.is_show_sale;
        recVendor.Seouri := recDesignerStage.seouri;
        recVendor."Show cat section" := recDesignerStage.show_cat_section;
        recVendor."Show cat section data" := recDesignerStage.show_cat_section_data;
        recVendor."Seo content" := recDesignerStage.seo_content;
        recVendor.Description := recDesignerStage.description;
        recVendor."Sale text" := recDesignerStage.sale_text;
        recVendor."Banner image" := recDesignerStage.banner_image;
        recVendor."Is show counter" := recDesignerStage.is_show_counter;
        recVendor."Counter start date" := recDesignerStage.counter_start_date;
        recVendor."Counter end date" := recDesignerStage.counter_end_date;
        recVendor."Is show cod" := recDesignerStage.is_show_cod;
        recVendor.merchant_status := recDesignerStage.merchant_status;//Np
        recVendor.merchant_approved_by := recDesignerStage.merchant_approved_by;
        recVendor.finance_status := recDesignerStage.finance_status;
        recVendor.final_approved_status := recDesignerStage.final_approved_status;
        recVendor.finance_approved_by := recDesignerStage.finance_approved_by;//Np
        //Attributes<<
        if not errorFound then begin
            // if not recVendor.Get(recDesignerStage.id) then begin
            // recVendor.Blocked := recVendor.Blocked::All;
            recVendor.Insert();
            Commit();
            glVendorCreated := true;
            recorderAdd.Reset();
            recorderAdd.SetRange("Vendor No.", recVendor."No.");
            recorderAdd.SetRange(Code, (recVendor."No." + '01'));
            if not recorderAdd.find('-') then begin
                RegOrderAdd.Init();
                RegOrderAdd."Vendor No." := recVendor."No.";
                RegOrderAdd.Code := recVendor."No." + '01';    //cocoon-vik
                RegOrderAdd.Address := recDesignerStage.reg_address;
                RegOrderAdd."Address 2" := recDesignerStage.reg_address_line1;
                RegOrderAdd."Phone No." := recDesignerStage.reg_phone;
                RegOrderAdd.City := recDesignerStage.reg_city;
                RegOrderAdd."Country/Region Code" := recDesignerStage.reg_country;
                RegOrderAdd."Post Code" := Format(recDesignerStage.reg_pincode);
                recorderAdd.State := recVendor."State Code";
                RegOrderAdd."E-Mail" := recDesignerStage.reg_email_contact_secondary;
                RegOrderAdd.Contact := recDesignerStage.reg_contact_name_secondary;
                RegOrderAdd."Phone No." := Format(recDesignerStage.reg_phone_contact_secondary);
                RegOrderAdd.Insert();
            end;
            if recDesignerStage.bank_name <> '' then begin
                vendorbankacc.Init();
                vendorbankacc."Vendor No." := recVendor."No.";
                vendorbankacc.Code := CopyStr(recDesignerStage.bank_name, 1, 10);
                //vendorbankacc.validate(Code, recDesignerStage.bank_name);
                vendorbankacc.validate("Bank Account No.", recDesignerStage.bank_account_number);
                vendorbankacc.validate(Name, recDesignerStage.bank_name);
                //vendorbankacc."Bank Branch No." := recDesignerStage.branch_name;
                vendorbankacc."Bank Account Name" := recDesignerStage.branch_name;
                vendorbankacc."SWIFT Code" := recDesignerStage.ifsc_code;
                vendorbankacc.Insert();
            end;

            /*  Message('Vendor Created Successfully'); */
            // if not errorFound then begin
            if recDesignerStage.gst_registered then begin
                RecordLink1.Reset();
                if RecordLink1.FindLast() then
                    LinkNo := RecordLink1."Link ID" + 1
                else
                    LinkNo := 1;

                if recDesignerStage.gst_attachment <> '' then begin
                    RecordLink1.Init();
                    //RecordLink1.TransferFields(RecordLink);
                    RecordLink1."Link ID" := LinkNo;
                    RecordLink1."Record ID" := recVendor.RecordId;
                    RecordLink1.URL1 := recDesignerStage.gst_attachment;
                    RecordLink1.Description := StrSubstNo('Vendor %1 GST attachment', recDesignerStage.id);
                    RecordLink1.Type := RecordLink1.Type::Link;
                    RecordLink1.Created := CurrentDateTime;
                    RecordLink1."User ID" := UserId;
                    RecordLink1.Insert();
                    gstAttachmentInserted := true;
                end;


                if recDesignerStage.pan_attachment <> '' then begin
                    if gstAttachmentInserted then
                        LinkNo += 1;
                    RecordLink1.Init();
                    //RecordLink1.TransferFields(RecordLink);
                    RecordLink1."Link ID" := LinkNo;
                    RecordLink1."Record ID" := recVendor.RecordId;
                    RecordLink1.URL1 := recDesignerStage.pan_attachment;
                    RecordLink1.Description := StrSubstNo('Vendor %1 PAN attachment', recDesignerStage.id);
                    RecordLink1.Type := RecordLink1.Type::Link;
                    RecordLink1.Created := CurrentDateTime;
                    RecordLink1."User ID" := UserId;
                    RecordLink1.Insert();
                end;
            end;
            if recDesignerStage.cancelled_cheque_attachment <> '' then begin
                LinkNo += 1;
                RecordLink1.Init();
                //RecordLink1.TransferFields(RecordLink);
                RecordLink1."Link ID" := LinkNo;
                RecordLink1."Record ID" := recVendor.RecordId;
                RecordLink1.URL1 := recDesignerStage.cancelled_cheque_attachment;
                RecordLink1.Description := StrSubstNo('Vendor %1 cancelled cheque attachment', recDesignerStage.id);
                RecordLink1.Type := RecordLink1.Type::Link;
                RecordLink1.Created := CurrentDateTime;
                RecordLink1."User ID" := UserId;
                RecordLink1.Insert();
            end;
            if recDesignerStage.msme_certificate <> '' then begin
                LinkNo += 1;
                RecordLink1.Init();
                //RecordLink1.TransferFields(RecordLink);
                RecordLink1."Link ID" := LinkNo;
                RecordLink1."Record ID" := recVendor.RecordId;
                RecordLink1.URL1 := recDesignerStage.msme_certificate;
                RecordLink1.Description := StrSubstNo('Vendor %1 msme certificate', recDesignerStage.id);
                RecordLink1.Type := RecordLink1.Type::Link;
                RecordLink1.Created := CurrentDateTime;
                RecordLink1."User ID" := UserId;
                RecordLink1.Insert();
            end;
            // end;
            // if not errorFound then begin
            recDesignerStage."Record Status" := recDesignerStage."Record Status"::Created;
            recDesignerStage.Modify();
            // end;else begin
            //     recVendor.Modify(true);
            //     recDesignerStage."Record Status" := recDesignerStage."Record Status"::Updated;
            //     recDesignerStage.Modify();
            // end;
        end else begin
            recDesignerStage."Record Status" := recDesignerStage."Record Status"::Error;
            recDesignerStage.Modify();
        end;
        // until recDesignerStage.Next() = 0;
    end;

    procedure updateVendors(recDesignerStage: Record Aza_Designer)
    var
        recVendor: Record 23;
        recUpdated: Boolean;
        vendorRegistered: Boolean;
        StateC: Record State;
        vendorbankacc: Record "Vendor Bank Account";
    begin
        recUpdated := true;
        recVendor.get(recDesignerStage.id);

        if recVendor.Name <> recDesignerStage.name then begin
            recVendor.Name := recDesignerStage.name;
            recUpdated := true;
        end;

        if recVendor."Search Name" <> recDesignerStage.name_2 then begin
            recVendor."Search Name" := recDesignerStage.name_2;
            recUpdated := true;
        end;


        if recVendor."Email to" <> recDesignerStage.email_to then begin
            recVendor."Email to" := recDesignerStage.email_to;
            recUpdated := true;
        end;

        if recVendor.Type <> recDesignerStage.type then begin
            recVendor.Type := recDesignerStage.type;
            recUpdated := true;
        end;

        if recVendor."Address" <> recDesignerStage.address then begin
            if recDesignerStage.address <> '' then begin
                recVendor."Address" := copystr(recDesignerStage.address, 1, 100);
                recUpdated := true;
            end;
        end;

        if recVendor."Address 2" <> recDesignerStage.address_line1 then begin
            if recDesignerStage.address_line1 <> '' then begin
                recVendor."Address 2" := copystr(recDesignerStage.address_line1, 1, 50);
                recUpdated := true;
            end;
        end;

        if recVendor."Address 3" <> recDesignerStage.address_line2 then begin
            if recDesignerStage.address_line2 <> '' then begin
                recVendor."Address 3" := copystr(recDesignerStage.address_line2, 1, 100);
                recUpdated := true;
            end
        end;

        if recVendor.City <> recDesignerStage.city then begin
            recVendor.validate(City, recDesignerStage.city);
            recUpdated := true;
        end;
        // if recVendor."State Code" <> recDesignerStage.state then begin
        // if not StateC.Get(recVendor."State Code") then Error('State %1 does not exist', recDesignerStage.state);
        // if lowercase(StateC.Description) <> lowercase(recDesignerStage.state) then begin
        //     StateC.Reset();
        //     StateC.SetRange(Description, recDesignerStage.state);
        //     if StateC.FindFirst() then
        //         // recVendor."State Code" := StateC.Code //recDesignerStage.state;
        //         recVendor.validate("State Code", StateC.Code)//recDesignerStage.state;
        //     else
        //         Error('State %1 not found in the master', recDesignerStage.state);
        //     //recVendor.validate("State Code", recDesignerStage.state);
        //     recUpdated := true;
        // end;

        // if recVendor."Country/Region Code" <> 

        if recVendor."Post Code" <> format(recDesignerStage.pincode) then begin
            recVendor.validate("Post Code", format(recDesignerStage.pincode));
            recUpdated := true;
        end;

        // if recVendor."P.A.N. No." <> format(recDesignerStage.pan_number) then begin
        //     recVendor.validate("P.A.N. No.", format(recDesignerStage.pan_number));
        //     recUpdated := true;
        // end;

        // if recVendor."Pan attachment" <> recDesignerStage.pan_attachment then begin
        //     // recVendor."Pan attachment" := recDesignerStage.pan_attachment;
        //     recUpdated := true;
        // end;

        // if recVendor."GST Vendor Type" = recVendor."GST Vendor Type"::Registered then
        //  vendorRegistered := true;
        //  if recDesignerStage.gst_registered <> vendorRegistered then begin


        //  end;

        if recVendor."Gst registration date" <> recDesignerStage.gst_registration_date then begin
            recVendor."Gst registration date" := recDesignerStage.gst_registration_date;
            recUpdated := true;
        end;

        if recVendor."Phone No." <> recDesignerStage.phone_contact_primary then begin
            recVendor."Phone contact primary" := recDesignerStage.phone_contact_primary;
            recUpdated := true;
        end;

        if recVendor."Email to" <> recDesignerStage.email_to then begin
            recVendor."Email to" := recDesignerStage.email_to;
            recUpdated := true;
        end;

        if recVendor."Email cc" <> recDesignerStage.email_cc then begin
            recVendor."Email cc" := recDesignerStage.email_cc;
            recUpdated := true;
        end;

        if recVendor."Parent designer id" <> recDesignerStage.parent_designer_id then begin
            recVendor."Parent designer id" := recDesignerStage.parent_designer_id;
            recUpdated := true;
        end;

        if recVendor."Parent designer name" <> recDesignerStage.parent_designer_name then begin
            recVendor."Parent designer name" := recDesignerStage.parent_designer_name;
            recUpdated := true;
        end;

        if recVendor."Merchandiser name" <> recDesignerStage.merchandiser_name then begin
            recVendor."Merchandiser name" := recDesignerStage.merchandiser_name;
            recUpdated := true;
        end;

        if recVendor."Order merchandiser name" <> recDesignerStage.order_merchandiser_name then begin
            recVendor."Order merchandiser name" := recDesignerStage.order_merchandiser_name;
            recUpdated := true;
        end;

        if recVendor."Contact name primary" <> recDesignerStage.contact_name_primary then begin
            recVendor."Contact name primary" := recDesignerStage.contact_name_primary;
            recUpdated := true;
        end;

        if recVendor."Return policy" <> recDesignerStage.return_policy then begin
            recVendor."Return policy" := recDesignerStage.return_policy;
            recUpdated := true;
        end;

        if recVendor."Email name primary" <> recDesignerStage.email_name_primary then begin
            recVendor."Email name primary" := recDesignerStage.email_name_primary;
            recUpdated := true;
        end;

        if recVendor."Is show cod" <> recDesignerStage.is_show_cod then begin
            recVendor."Is show cod" := recDesignerStage.is_show_cod;
            recUpdated := true;
        end;

        if recVendor.Seouri <> recDesignerStage.seouri then begin
            recVendor.Seouri := recDesignerStage.seouri;
            recUpdated := true;
        end;

        if recVendor."Seo content" <> recDesignerStage.seo_content then begin
            recVendor."Seo content" := recDesignerStage.seo_content;
            recUpdated := true;
        end;

        if recVendor."Show cat section" <> recDesignerStage.show_cat_section then begin
            recVendor."Show cat section" := recDesignerStage.show_cat_section;
            recUpdated := true;
        end;

        if recVendor."Show cat section data" <> recDesignerStage.show_cat_section_data then begin
            recVendor."Show cat section data" := recDesignerStage.show_cat_section_data;
            recUpdated := true;
        end;


        if recVendor."Sale text" <> recDesignerStage.sale_text then begin
            recVendor."Sale text" := recDesignerStage.sale_text;
            recUpdated := true;
        end;
        if recVendor."Is show counter" <> recDesignerStage.is_show_counter then begin
            recVendor."Is show counter" := recDesignerStage.is_show_counter;
            recUpdated := true;
        end;


        if recVendor."Post Code" <> format(recDesignerStage.pincode) then begin
            recVendor."Post Code" := format(recDesignerStage.pincode);
            recUpdated := true;
        end;
        if recVendor.Contact <> recDesignerStage.contact_name_primary then begin
            recVendor.Contact := recDesignerStage.contact_name_primary;
            recUpdated := true;
        end;
        if recVendor."Mobile Phone No." <> recDesignerStage.phone_contact_primary then begin
            recVendor."Mobile Phone No." := recDesignerStage.phone_contact_primary;
            recUpdated := true;
        end;
        if recVendor."Parent designer name" <> recDesignerStage.parent_designer_name then begin
            recVendor."Parent designer name" := recDesignerStage.parent_designer_name;
            recUpdated := true;
        end;

        if recVendor."Parent designer id" <> recDesignerStage.parent_designer_id then begin
            recVendor."Parent designer id" := recDesignerStage.parent_designer_id;
            recUpdated := true;
        end;


        if recVendor."Phone contact primary" <> recDesignerStage.phone_contact_primary then begin
            recVendor."Phone contact primary" := recDesignerStage.phone_contact_primary;
            recUpdated := true;
        end;

        if recVendor."Counter end date" <> recDesignerStage.counter_end_date then begin
            recVendor."Counter end date" := recDesignerStage.counter_end_date;
            recUpdated := true;
        end;

        if recVendor."Counter start date" <> recDesignerStage.counter_start_date then begin
            recVendor."Counter start date" := recDesignerStage.counter_start_date;
            recUpdated := true;
        end;
        if recVendor."Banner image" <> recDesignerStage.banner_image then begin
            recVendor."Banner image" := recDesignerStage.banner_image;
            recUpdated := true;
        end;
        if recVendor.Description <> recDesignerStage.description then begin
            recVendor.Description := recDesignerStage.description;
            recUpdated := true;
        end;
        if recVendor."Signature name" <> recDesignerStage.signature_name then begin
            recVendor."Signature name" := recDesignerStage.signature_name;
            recUpdated := true;
        end;

        if recVendor."Po price type" <> recDesignerStage.po_price_type then begin
            recVendor."Po price type" := recDesignerStage.po_price_type;
            recUpdated := true;
        end;
        if recVendor."Additional charge" <> recDesignerStage.additional_charge then begin
            recVendor."Additional charge" := recDesignerStage.additional_charge;
            recUpdated := true;
        end;
        if recVendor."Additional charge type" <> recDesignerStage.additional_charge_type then begin
            recVendor."Additional charge type" := recDesignerStage.additional_charge_type;
            recUpdated := true;
        end;
        if recVendor."Contact primary job Title" <> recDesignerStage.contact_primary_job_Title then begin
            recVendor."Contact primary job Title" := recDesignerStage.contact_primary_job_Title;
            recUpdated := true;
        end;


        if recVendor."Contact name secondary" <> recDesignerStage.contact_name_secondary then begin
            recVendor."Contact name secondary" := recDesignerStage.contact_name_secondary;
            recUpdated := true;
        end;

        if recVendor."email contact secondary" <> recDesignerStage.email_contact_secondary then begin
            recVendor."email contact secondary" := recDesignerStage.email_contact_secondary;
            recUpdated := true;
        end;
        if recVendor."Phone contact secondary" <> recDesignerStage.phone_contact_secondary then begin
            recVendor."Phone contact secondary" := recDesignerStage.phone_contact_secondary;
            recUpdated := true;
        end;
        if recVendor."Reg address" <> recDesignerStage.reg_address then begin
            recVendor."Reg address" := recDesignerStage.reg_address;
            recUpdated := true;
        end;
        if recVendor."Reg address line1" <> recDesignerStage.reg_address_line1 then begin
            recVendor."Reg address line1" := recDesignerStage.reg_address_line1;
            recUpdated := true;
        end;
        if recVendor."Reg address line2" <> recDesignerStage.reg_address_line2 then begin
            recVendor."Reg address line2" := recDesignerStage.reg_address_line2;
            recUpdated := true;
        end;
        if recVendor."Reg contact name primary" <> recDesignerStage.reg_contact_name_primary then begin
            recVendor."Reg contact name primary" := recDesignerStage.reg_contact_name_primary;
            recUpdated := true;
        end;
        if recVendor."Reg contact name secondary" <> recDesignerStage.reg_contact_name_secondary then begin
            recVendor."Reg contact name secondary" := recDesignerStage.reg_contact_name_secondary;
            recUpdated := true;
        end;
        if recVendor."Reg email to" <> recDesignerStage.reg_email_to then begin
            recVendor."Reg email to" := recDesignerStage.reg_email_to;
            recUpdated := true;
        end;
        if recVendor."Reg email cc" <> recDesignerStage.reg_email_cc then begin
            recVendor."Reg email cc" := recDesignerStage.reg_email_cc;
            recUpdated := true;
        end;
        if recVendor."Reg contact name primary" <> recDesignerStage.reg_email_contact_secondary then begin
            recVendor."Reg email contact primary" := recDesignerStage.reg_email_contact_primary;
            recUpdated := true;
        end;
        if recVendor."Reg email contact secondary" <> recDesignerStage.reg_email_contact_secondary then begin
            recVendor."Reg phone contact secondary" := recDesignerStage.reg_email_contact_secondary;
            recUpdated := true;
        end;
        if recVendor."Reg city" <> recDesignerStage.reg_city then begin
            recVendor."Reg city" := recDesignerStage.reg_city;
            recUpdated := true;
        end;
        if recVendor."Reg state" <> recDesignerStage.reg_state then begin
            recVendor."Reg state" := recDesignerStage.reg_state;
            recUpdated := true;
        end;
        if recVendor."Reg country" <> recDesignerStage.reg_country then begin
            recVendor."Reg country" := recDesignerStage.reg_country;
            recUpdated := true;
        end;

        if recVendor."Reg phone" <> recDesignerStage.reg_phone then begin
            recVendor."Reg phone" := recDesignerStage.reg_phone;
            recUpdated := true;
        end;

        if recVendor."Reg contact primary job title" <> recDesignerStage.reg_contact_primary_job_title then begin
            recVendor."Reg contact primary job title" := recDesignerStage.reg_contact_primary_job_title;
            recUpdated := true;
        end;
        if recVendor."Contact job title secondary" <> recDesignerStage.contact_job_title_secondary then begin
            recVendor."Contact job title secondary" := recDesignerStage.contact_job_title_secondary;
            recUpdated := true;
        end;

        if recVendor."Reg contact name secondary" <> recDesignerStage.reg_contact_name_secondary then begin
            recVendor."Reg contact name secondary" := recDesignerStage.reg_contact_name_secondary;
            recUpdated := true;
        end;
        if recVendor."Reg phone contact secondary" <> recDesignerStage.reg_phone_contact_secondary then begin
            recVendor."Reg phone contact secondary" := recDesignerStage.reg_phone_contact_secondary;
            recUpdated := true;
        end;


        if recVendor."Date modified" <> recDesignerStage.date_modified then begin
            recVendor."Date modified" := recDesignerStage.date_added;
            recUpdated := true;
        end;
        if recVendor.Date_added <> recDesignerStage.date_added then begin
            recVendor.Date_added := recDesignerStage.date_added;
            recUpdated := true;
        end;
        if recVendor."Modified by" <> recDesignerStage.modified_by then begin
            recVendor."Modified by" := recDesignerStage.modified_by;
            recUpdated := true;
        end;
        if recVendor."Signature name" <> recDesignerStage.signature_name then begin
            recVendor."Reg phone contact secondary" := recDesignerStage.reg_phone_contact_secondary;
            recUpdated := true;
        end;
        if recVendor."Signature place" <> recDesignerStage.signature_place then begin
            recVendor."Signature place" := recDesignerStage.signature_place;
            recUpdated := true;
        end;
        // if recVendor."Cancelled cheque attachment" <> recDesignerStage.cancelled_cheque_attachment then begin
        //     recVendor."Cancelled cheque attachment" := recDesignerStage.cancelled_cheque_attachment;
        //     recUpdated := true;
        // end;

        if recVendor."msme registered" <> recDesignerStage.msme_registered then begin
            recVendor."msme registered" := recDesignerStage.msme_registered;
            recUpdated := true;
        end;

        if recVendor."msme registration date" <> recDesignerStage.msme_registration_date then begin
            recVendor."msme registration date" := recDesignerStage.msme_registration_date;
            recUpdated := true;
        end;

        if recVendor."msme registration no" <> recDesignerStage.msme_registration_no then begin
            recVendor."msme registration no" := recDesignerStage.msme_registration_no;
            recUpdated := true;
        end;

        if recVendor."Additional charge" <> recDesignerStage.additional_charge then begin
            recVendor."Additional charge" := recDesignerStage.additional_charge;
            recUpdated := true;
        end;

        if recVendor."Additional charge type" <> recDesignerStage.additional_charge_type then begin
            recVendor."Additional charge type" := recDesignerStage.additional_charge_type;
            recUpdated := true;
        end;

        if recVendor."Po price type" <> recDesignerStage.po_price_type then begin
            recVendor."Po price type" := recDesignerStage.po_price_type;
            recUpdated := true;
        end;

        if recVendor."Declaration flag" <> recDesignerStage.declaration_flag then begin
            recVendor."Declaration flag" := recDesignerStage.declaration_flag;
            recUpdated := true;
        end;

        if recVendor.Designation <> recDesignerStage.designation then begin
            recVendor.Designation := recDesignerStage.designation;
            recUpdated := true;
        end;

        if recVendor."Added by" <> recDesignerStage.added_by then begin
            recVendor."Added by" := recDesignerStage.added_by;
            recUpdated := true;
        end;

        if recVendor."Modified by" <> recDesignerStage.modified_by then begin
            recVendor."Modified by" := recDesignerStage.modified_by;
            recUpdated := true;
        end;

        if recVendor.Status <> recDesignerStage.status then begin
            recVendor.Status := recDesignerStage.status;
            // if not recDesignerStage.status then
            //     recVendor.Blocked := recVendor.Blocked::All;
            recUpdated := true;
        end;

        if recVendor."Is deleted" <> recDesignerStage.is_deleted then begin
            recVendor."Is deleted" := recDesignerStage.is_deleted;
            // if recDesignerStage.is_deleted then
            //     recVendor.Blocked := recVendor.Blocked::All;
            recUpdated := true;
        end;

        if recVendor."Return policy" <> recDesignerStage.return_policy then begin
            recVendor."Return policy" := recDesignerStage.return_policy;
            recUpdated := true;
        end;

        // if recVendor."Is deleted" <> recDesignerStage.is_deleted then begin
        //     recVendor."Is deleted" := recDesignerStage.is_deleted;
        //     recUpdated := true;
        // end;

        if recVendor."Classification tag" <> recDesignerStage.classification_tag then begin
            recVendor."Classification tag" := recDesignerStage.classification_tag;
            recUpdated := true;
        end;
        if recVendor."Is show sale" <> recDesignerStage.is_show_sale then begin
            recVendor."Is show sale" := recDesignerStage.is_show_sale;
            recUpdated := true;
        end;

        if recVendor."Banner image" <> recDesignerStage.banner_image then begin
            recVendor."Banner image" := recDesignerStage.banner_image;
            recUpdated := true;
        end;

        if recVendor."Signature place" <> recDesignerStage.signature_place then begin
            recVendor."Signature place" := recDesignerStage.signature_place;
            recUpdated := true;
        end;

        if recDesignerStage.bank_name <> '' then begin
            if vendorbankacc.Get(recVendor."No.", CopyStr(recDesignerStage.bank_name, 1, 10)) then begin
                if vendorbankacc."Bank Account No." <> recDesignerStage.bank_account_number then begin
                    vendorbankacc."Bank Account No." := recDesignerStage.bank_account_number;
                    recUpdated := true;
                end;

                if vendorbankacc.Name <> recDesignerStage.bank_name then begin
                    vendorbankacc.Name := recDesignerStage.bank_name;
                    recUpdated := true;
                end;
                if vendorbankacc."Bank Account Name" <> recDesignerStage.branch_name then begin
                    vendorbankacc."Bank Account Name" := recDesignerStage.branch_name;
                    recUpdated := true;
                end;
                if vendorbankacc."SWIFT Code" <> recDesignerStage.ifsc_code then begin
                    vendorbankacc."SWIFT Code" := recDesignerStage.ifsc_code;
                    recUpdated := true;
                end;
                vendorbankacc.Modify();
            end;

        end;

        recVendor.Validate("Payment Terms Code", '0 Days');//100223k

        if recUpdated then begin
            // recVendor.Blocked := recVendor.Blocked::All; //270623
            recVendor.Modify();
            recDesignerStage."Record Status" := recDesignerStage."Record Status"::Updated;
            recDesignerStage.Modify();
        end;
    end;

}