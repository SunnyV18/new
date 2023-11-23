codeunit 50122 CreateCustomer
{
    TableNo = CustomerStaging;
    trigger OnRun()
    begin
        CreateCustomer(Rec);
    end;

    var

        cuFunctions: Codeunit Functions;

    procedure CreateCustomer(Var Custstaging: Record CustomerStaging)  //Cocoon
    var
        Customer: Record Customer;
        // Custstaging: Record CustomerStaging;
        Int: Integer;
        LastDate: Date;
        errorFound: Boolean;
        state: Record State;
        recCust1: Record 18;
        errorLog: Record ErrorCapture;
        country: Record "Country/Region";
    begin
        Clear(errorFound);
        // Custstaging.Reset();
        // Custstaging.SetRange(Record_Status, Custstaging.Record_Status::" ");
        // if Custstaging.FindSet() then
        //     repeat
        /* if Custstaging.phone_no = '' then begin  //** as per 310123 Aza call
             errorLog.Init();
             if errorLog.FindLast() then
                 errorLog."Sr. No" += 1
             else
                 errorLog."Sr. No" := 1;
             errorLog."Process Type" := errorLog."Process Type"::"Customer Creation";
             errorLog."Source Entry No." := Custstaging."Entry No.";
             errorLog.DocumentNum := '';
             errorLog."Vendor Code" := format(Custstaging.site_user_id);
             errorLog."Error Remarks" := 'Phone No. is missing';
             errorLog."Error DateTime" := CurrentDateTime;
             errorLog.Item_code := '';
             errorLog.Insert();
             errorFound := true;
         end;*/
        // if Custstaging.country_name = '' then begin
        //     cuFunctions.CreateErrorLog(4, 'Country Name is missing', Custstaging."Entry No.", format(Custstaging.site_user_id), '', '');
        //     errorFound := true;
        // end;
        // if Custstaging.state = '' then begin
        //     cuFunctions.CreateErrorLog(4, 'State is missing', Custstaging."Entry No.", format(Custstaging.site_user_id), '', '');
        //     errorFound := true;
        // end;
        // if Custstaging.pin_code = '' then begin
        //     cuFunctions.CreateErrorLog(4, 'PINCODE is missing', Custstaging."Entry No.", format(Custstaging.site_user_id), '', '');
        //     errorFound := true;
        // end;
        if Custstaging.is_gst_registered then
            if Custstaging.gst_no = '' then begin
                cuFunctions.CreateErrorLog(4, 'GST Registration No. is missing', Custstaging."Entry No.", format(Custstaging.site_user_id), '', '');
                errorFound := true;
            end;
        // if Custstaging.user_f_name = '' then begin
        //     cuFunctions.CreateErrorLog(4, 'First name is missing', Custstaging."Entry No.", format(Custstaging.site_user_id), '', '');
        //     errorFound := true;
        // end;

        if Custstaging.country_name = '' then
            Custstaging.country_name := 'INDIA';
        if Custstaging.state = '' then
            Custstaging.state := 'MAHARASHTRA';
        if Custstaging.pin_code = '' then
            Custstaging.pin_code := '400013';
        if Custstaging.user_f_name = '' then
            Custstaging.user_f_name := 'Guest Customer' + Format(Random(9999));
        if Custstaging.address = '' then
            Custstaging.address := 'Test address ' + Format(random(999999999));

        if not Customer.get(Format(Custstaging.site_user_id)) then begin
            Customer.Init();
            Customer.Validate("No.", Format(Custstaging.site_user_id));
            if not errorFound then begin
                Customer.Insert();
                Custstaging.Record_Status := Custstaging.Record_Status::Created;
                Custstaging.Modify();
            end else begin
                Custstaging.Record_Status := Custstaging.Record_Status::Error;
                Custstaging.Modify();
                exit;
            end;
        end else begin
            Custstaging.Record_Status := Custstaging.Record_Status::Updated;
            Custstaging.Modify();
            // errorLog.Reset();
            // errorLog.SetRange("Vendor Code", Format(Custstaging.site_user_id));
            // if errorLog.FindSet() then begin
            //     errorLog."Sr. No" := 0;
            //     errorLog."Error Remarks" := '';
            //     errorLog.Modify();
            // end;
        end;

        Customer.Validate(Name, Custstaging.user_f_name);
        Customer.Validate("Name 2", Custstaging.user_l_name);
        Customer.Validate("E-Mail", Custstaging.user_email);
        Customer.Validate("Phone No.", Custstaging.phone_no);
        country.Reset();
        country.SetRange(Name, Custstaging.country_name);
        if country.FindFirst() then begin
            Customer.Validate("Country/Region Code", country.Code);
            if country.Code <> 'IN' then
                Customer."GST Customer Type" := Customer."GST Customer Type"::Export;
        end;
        Customer.Validate(Address, Custstaging.address);
        Customer.Validate("Address 2", Custstaging.landmark);//landmark --- change suggest by kapil sir and ketan
        state.Reset();
        state.SetRange(Description, Custstaging.state);
        if state.FindFirst() then
            if Customer."Country/Region Code" = 'IN' then
                Customer.Validate("State Code", state.Code);
        Customer.City := Custstaging.city;//15/09/23
        Customer."Post Code" := Custstaging.pin_code;//15/09/23
        Customer.Validate("Balance (LCY)", Custstaging.user_credit);
        Customer.Validate("Gen. Bus. Posting Group", 'DOMESTIC');
        Customer.Validate("Customer Posting Group", 'LOCAL');
        Customer.Validate("Payment Terms Code", 'COD');
        // Customer.Validate(SystemCreatedAt, Custstaging.date_added);
        // Evaluate(LastDate, Format(Custstaging.date_modified));
        // Customer.Validate("Last Date Modified", LastDate);
        Customer.Validate(Register_Type, Custstaging.register_type);
        Customer.Validate(Gender, Custstaging.user_gender);
        Customer.Validate(DOB, Custstaging.user_dob);
        Customer.Validate(Marriage_Ann_Date, Custstaging.user_marriage_ann_date);
        Customer.Validate(Loyalty_Points, Custstaging.loyalty_points);
        Customer.Validate(Wallet, Custstaging.user_wallet);
        Customer.Validate(user_wallet, Custstaging.user_wallet);
        Customer.Validate(user_credit, Custstaging.user_credit);
        Customer.Validate(Credit_Admin_Remark, Custstaging.credit_admin_remark);
        Customer.Validate(wallet_credit_reason, Custstaging.wallet_credit_reason);
        Customer.Validate(Credit_Admin_Remark, Custstaging.credit_admin_remark);
        Customer.Validate(Wallet_Credit_Reason, Custstaging.wallet_credit_reason);
        Customer.Validate(Status, Custstaging.status);
        Customer.Validate(Added_by, Custstaging.added_by);
        Customer.Validate(Modified_by, Custstaging.modified_by);
        Customer.Validate(Is_Deleted, Custstaging.is_deleted);
        if (Custstaging.is_deleted) or (Custstaging.status = 0) then
            Customer.Blocked := Customer.Blocked::All;

        Customer.Validate(Tier_Type, Custstaging.user_tier_type);
        Customer.Validate(Total_Purchase_Amount, Custstaging.total_purchase_amount);
        Customer.Validate("Adhaar No.", Custstaging.user_adhaar_no);

        if Custstaging.is_gst_registered then begin
            Customer.Validate("P.A.N. Status", Customer."P.A.N. Status"::" ");
            Customer.Validate("P.A.N. No.", Custstaging.user_pan_no);
            Customer.Validate("GST Registration No.", Custstaging.gst_no);
            Customer.Validate("GST Customer Type", Customer."GST Customer Type"::Registered);

        end else
            if Customer."Country/Region Code" = 'IN' then
                Customer.Validate("GST Customer Type", Customer."GST Customer Type"::Unregistered) else
                Customer.Validate("GST Customer Type", Customer."GST Customer Type"::Export);
        if Customer."Country/Region Code" = 'IN' then begin
            Customer.Validate("Gen. Bus. Posting Group", 'DOMESTIC');
            Customer.Validate("Customer Posting Group", 'LOCAL');
        end else begin
            Customer.Validate("Gen. Bus. Posting Group", 'EXPORT');
            Customer.Validate("Customer Posting Group", 'EXPORT');
        end;

        Customer.Modify();
        //020223 CITS_RS for Sales order price issue 
        recCust1.get(customer."No.");
        recCust1."Prices Including VAT" := false;
        recCust1.Modify();
        if errorFound then
            if Customer.get(Custstaging.site_user_id) then
                customer.Delete();
        // end;
        // until Custstaging.Next() = 0;
    end;
}