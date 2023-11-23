codeunit 50114 ProcessItem_DesignerCreatItem
{
    TableNo = Aza_Item;
    trigger OnRun()
    begin
        CreateItem(Rec);
    end;

    var
        myInt: Integer;
        ColorVar: Code[20];
        ColorVar2: Code[20];

        glVendorCreated: Boolean;

        cuFunctions: Codeunit Functions;


    procedure CreateItem(recItemStage: Record Aza_Item)
    var
        recItem: Record Item;
        vendor: Record Vendor;
        Item: Record Item;
        recBarcodes: Record "LSC Barcodes";
        txtBarcode: text;
        recGeneralLedger: Record "General Ledger Setup";
        recItemCategory: Record "Item Category";
        recDivision: Record "LSC Division";
        recRetProdGr: Record "LSC Retail Product Group";
        recSizeColorMaster: Record ColorSizeMaster;
        CU_Functions: Codeunit Functions;
        Divisionrec: Record "LSC Division";
        ItemUOM: Record "Item Unit of Measure";
        L_Instream: InStream;
        ImageURL: Text;
        GSTMaster1: Record "GST Master";
        GSTGC: Code[20];
        GSThsn: Code[20];
        client: HttpClient;
        Response: HttpResponseMessage;
        errorFound: Boolean;
        L_Instream2: InStream;
        ImageURL2: Text;
        updateFlag: Boolean;
        client2: HttpClient;
        Response2: HttpResponseMessage;
        L_Item: Record Item;
        L_Item2: Record Item;
        recCustomer: Record 18;
        L_TenantMedia: Record "Tenant Media";
        SalPrice: Record "Sales Price";
        L_Vendor: Record Vendor;
        ErrorLog: Record ErrorCapture;
        L_EntryNo: Integer;
        TabLocation: Record Location;
        colorCSVFound: Boolean;
        subsubCSVFound: Boolean;
        FCLocation: Integer;
        retProdGrCSV: Text;
        GstGroup: Record "GST Group";
        Gstrate1: Decimal;
        LSCBarcodes: Record "LSC Barcodes";
        barCode20: text;//Nitish
        VendNotFound: Boolean;
    begin

        Clear(txtBarcode);
        if StrLen(recItemStage.bar_code) > 20 then
            txtBarcode := CopyStr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)
        else
            txtBarcode := recItemStage.bar_code;

        if txtBarcode = '' then error('Barcode is blank for Item Staging entry num %1', recItemStage."Entry No.");
        clear(subsubCSVFound);
        Clear(colorCSVFound);
        Clear(errorFound);
        Clear(updateFlag);

        if recItem.get(txtBarcode) then
            UpdateItem(recItemStage)
        else begin
            if StrPos(recItemStage.color_id, ',') > 0 then begin
                ColorVar := recItemStage.color_id;
                ColorVar2 := SelectStr(1, ColorVar);
                colorCSVFound := true;
            end;
            if StrPos(recItemStage.sub_sub_category_code, ',') > 0 then begin
                retProdGrCSV := recItemStage.sub_sub_category_code;
                retProdGrCSV := selectstr(1, recItemStage.sub_sub_category_code);
                subsubCSVFound := true;
            end;
            if recItemStage.category_code = '' then begin
                cuFunctions.CreateErrorLog(1, 'Main category code is missing', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                errorFound := true;
            end;
            if recItemStage.sub_category_code = '' then begin
                cuFunctions.CreateErrorLog(1, 'Subcategory code is missing', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                errorFound := true;
            end;
            if recItemStage.designer_id = '' then begin
                cuFunctions.CreateErrorLog(1, 'Child designer is missing', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                errorFound := true;
            end;
            if recItemStage.product_title = '' then begin
                cuFunctions.CreateErrorLog(1, 'Product title is missing', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                errorFound := true;
            end;
            // if recItemStage.components_no = 0 then begin
            //     cuFunctions.CreateErrorLog(1, 'Number of components is blank', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
            //     errorFound := true;
            // end;
            if recItemStage.color_id = '' then begin
                cuFunctions.CreateErrorLog(1, 'Colour name is blank', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                errorFound := true;
            end;
            if recItemStage.fc_location = '' then begin
                cuFunctions.CreateErrorLog(1, 'FC master is missing', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                errorFound := true;
            end;
            VendNotFound := false;
            if recItemStage.designer_id <> '' then begin
                L_Vendor.Reset();
                L_Vendor.SetRange("No.", recItemStage.designer_id);
                if NOT L_Vendor.FindFirst() then begin
                    cuFunctions.CreateErrorLog(1, StrSubstNo('Vendor %1 does not exist', recItemStage.designer_id), recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                    errorFound := true;
                    VendNotFound := true;
                end;
            end;
            if recItemStage.type_of_inventory = '' then begin
                cuFunctions.CreateErrorLog(1, 'Type of inventory is missing', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                errorFound := true;
            end;
            if errorFound then begin
                IF not VendNotFound then
                    recItemStage."Record Status" := recItemStage."Record Status"::Error;
                recItemStage.Modify();
                exit;
            end;


            if recItemStage."Record Status" = recItemStage."Record Status"::" " then begin
                recItem.Init();

                if not recItem.get(txtBarcode) then begin
                    // if not recItem.get(copystr(recItemStage.bar_code, 1, 20)) then begin
                    recItem.validate("No.", txtBarcode);//truncated according to system length 110223
                    if recItem.Insert() then begin
                        //Itembarcodes Insertion>>>>>>>>>>>>
                        // if recItemStage.Old_aza_code <> '' then begin//Naveen-- uncomment suggest by sunny 260923
                        //     barCode20 := copystr(recItemStage.Old_aza_code, 1, 20);
                        //     LSCBarcodes.Reset();
                        //     //LSCBarcodes.SetRange("Barcode No.", recItemStage.Old_aza_code);
                        //     LSCBarcodes.SetRange("Barcode No.", barCode20);
                        //     if not LSCBarcodes.FindFirst() then begin
                        //         LSCBarcodes.Init();
                        //         LSCBarcodes."Item No." := txtBarcode;
                        //         LSCBarcodes."Barcode No." := barCode20;
                        //         LSCBarcodes.Description := copystr(recItemStage.product_title, 1, 20);
                        //         LSCBarcodes."Unit of Measure Code" := 'PCS';
                        //         LSCBarcodes.Insert(true);
                        //     end;
                        // end;//1809//Naveen-- uncomment suggest by sunny 260923
                    end;
                end else
                    updateFlag := true;
                // if recItemStage.Old_aza_code <> '' then begin
                //     barCode20 := copystr(recItemStage.Old_aza_code, 1, 20);
                //     LSCBarcodes.Reset();
                //     //LSCBarcodes.SetRange("Item No.", txtBarcode);
                //     LSCBarcodes.SetRange("Barcode No.", barCode20);
                //     if not LSCBarcodes.FindFirst() then begin
                //         LSCBarcodes.Init();
                //         LSCBarcodes."Item No." := txtBarcode;
                //         LSCBarcodes."Barcode No." := barCode20;
                //         LSCBarcodes.Description := copystr(recItemStage.product_title, 1, 20);
                //         LSCBarcodes."Unit of Measure Code" := 'PCS';
                //         LSCBarcodes.Insert(true);
                //     end;
                // end;//030723//1809
                // recItem.validate("No.", txtBarcode);
                // recItem.Get(txtBarcode);
                recItem.tagCode := recItemStage.tag_code;
                // recItem.azaCode := recItemStage.aza_code;
                // recItem.Old_aza_code := recItemStage.Old_aza_code;//1809//Naveen-- uncomment suggest by sunny 260923
                recItem."Base Unit of Measure" := 'PCS';
                recItem."Sales Unit of Measure" := 'PCS';
                recItem.Validate(recItem.azaCode, recItemStage.aza_code);
                //In process commented for demo 010323 CITS_RS 
                // if recItemStage.aza_code <> '' then begin
                //     recBarcodes.Init();
                //     recBarcodes.validate("Item No.", copystr(recItemStage.bar_code, 1, 20));
                //     recBarcodes.validate("Barcode No.", copystr(recItemStage.aza_code, 1, 20));
                //     recBarcodes.Description := copystr(recItemStage.product_title, 1, 20);
                //     recBarcodes.Validate("Unit of Measure Code", 'PCS');
                //     recBarcodes.Insert();
                // end;
                recItem.Validate(Description, recItemStage.product_title);
                recItem.Validate(product_desc, recItemStage.product_desc);
                // recItem.azaCode := recItemStage.aza_code;
                recItem.Validate("PO type", recItemStage.po_type);
                //recItem.Validate("fc location", recItemStage.fc_location);
                Evaluate(FCLocation, recItemStage.fc_location);
                TabLocation.Reset();
                TabLocation.SetRange("fc_location ID", FCLocation);
                if TabLocation.FindFirst() then
                    recItem."fc location" := TabLocation.Code
                else
                    Error('FC location %1 not found in the system !', FCLocation);

                recItem."Gen. Prod. Posting Group" := 'RETAIL';
                recItem."Inventory Posting Group" := 'RETAIL';
                recItem.Modify();
                if not ItemUOM.Get(recItem."No.", 'PCS') then begin
                    ItemUOM.Init();
                    ItemUOM."Item No." := recItem."No.";
                    ItemUOM.Code := 'PCS';
                    ItemUOM.Insert();
                end;

                recDivision.Reset();
                recDivision.SetRange(Code, recItemStage.category_code);
                if recDivision.FindFirst() then
                    recItem."LSC Division Code" := recDivision.Code
                else begin
                    recDivision.Init();
                    recDivision.Code := recItemStage.category_code;
                    recDivision.Description := recItemStage.category_name;
                    recDivision.Insert();
                    recItem."LSC Division Code" := recDivision.Code;
                end;

                recItemCategory.Reset();
                recItemCategory.SetRange(Code, recItemStage.sub_category_code);
                recItemCategory.SetRange("LSC Division Code", recItemStage.category_code);
                if recItemCategory.FindFirst() then
                    recItem."Item Category Code" := recItemCategory.Code
                else begin
                    recItemCategory.SetRange("LSC Division Code");
                    if recItemCategory.FindFirst() then begin
                        recItemCategory."LSC Division Code" := recItemStage.category_code;
                        recItemCategory.Modify();
                        recItem.validate("Item Category Code", recItemCategory.Code);
                    end
                    else begin
                        recItemCategory.Init();
                        recItemCategory.Code := recItemStage.sub_category_code;
                        recItemCategory."LSC Division Code" := recItemStage.category_code;
                        recItemCategory.Description := recItemStage.sub_category_name;
                        recItemCategory.Insert();
                        recItem.validate("Item Category Code", recItemCategory.Code);
                    end;
                end;

                if subsubCSVFound then begin//CITS_RS 130223
                    recRetProdGr.Reset();
                    recRetProdGr.SetRange(Code, retProdGrCSV);
                    recRetProdGr.SetRange("Item Category Code", recItemStage.sub_category_code);
                    if recRetProdGr.FindFirst() then
                        if recRetProdGr.Code <> '' then
                            recItem."LSC Retail Product Code" := recRetProdGr.Code
                        else
                            if retProdGrCSV <> '' then begin
                                recRetProdGr.Init();
                                recRetProdGr.Code := retProdGrCSV;
                                recRetProdGr."Item Category Code" := recItemStage.sub_category_code;
                                recRetProdGr.Description := recItemStage.sub_sub_category_name;
                                recRetProdGr.Insert();
                                //recItem.validate("Item Category Code", recItemStage.category_code);
                                //recItem.Validate("LSC Retail Product Code", recItemStage.sub_sub_category_code);
                                recItem."LSC Retail Product Code" := recRetProdGr.Code;
                            end;
                end else begin
                    recRetProdGr.Reset();
                    recRetProdGr.SetRange(Code, recItemStage.sub_sub_category_code);
                    recRetProdGr.SetRange("Item Category Code", recItemStage.sub_category_code);
                    if recRetProdGr.FindFirst() then
                        if recRetProdGr.Code <> '' then
                            recItem."LSC Retail Product Code" := recRetProdGr.Code
                        else
                            if recItemStage.sub_sub_category_code <> '' then begin
                                recRetProdGr.Init();
                                recRetProdGr.Code := recItemStage.sub_sub_category_code;
                                recRetProdGr."Item Category Code" := recItemStage.sub_category_code;
                                recRetProdGr.Description := recItemStage.sub_sub_category_name;
                                recRetProdGr.Insert();
                                //recItem.validate("Item Category Code", recItemStage.category_code);
                                //recItem.Validate("LSC Retail Product Code", recItemStage.sub_sub_category_code);
                                recItem."LSC Retail Product Code" := recRetProdGr.Code;
                            end;
                end;
                recItem.designerID := recItemStage.designer_id;
                recItem."Vendor No." := recItemStage.designer_id;
                if vendor.Get(recItemStage.designer_id) then
                    recItem."Vendor Abbreviation" := vendor."Designer Abbreviation";
                recItem.componentsNo := recItemStage.components_no;
                recItem."Neckline Type" := recItemStage.neckline_type;
                recItem."Sleeve Length" := recItemStage.sleeve_length;
                //recItem.subSubCategoryCode := recItemStage.sub_sub_category_code;
                recItem."Closure Type" := recItemStage.closure_type;
                recItem."Fabric Type" := recItemStage.fabric_type;
                recItem."Type of Work" := recItemStage.type_of_work;
                recItem."Type of Pattern" := recItemStage.type_of_pattern;
                recItem."Vendor Item No." := recItemStage.designer_code;
                recItem."Designer Code" := recItemStage.designer_code;
                recItem."Product Title" := recItemStage.product_title;
                recItem."Sleeve Type" := recItemStage.sleeve_type;
                recItem."Sleeve Length" := recItemStage.sleeve_length;
                recItemStage.stylist_note := recItemStage.stylist_note;
                recItem.productThumbImg := recItemStage.product_thumbImg;
                recItem."Customer No." := recItemStage.customer_id;
                recItem.merchandiserName := copystr(recItemStage.merchandise_name, 1, 50);
                if recCustomer.get(recItemStage.Customer_id) then
                    recItem."Cust. Phone No." := recCustomer."Phone No.";
                recItem.addedBy := recItemStage.added_by;
                recItem."LSC Date Created" := recItemStage.date_added;
                recItem.modifiedBy := recItemStage.modified_by;
                recItem."Modified Date" := recItemStage.modified_date;
                recItem.status := recItemStage.status;
                if not recItemStage.status then //130223 CITS_RS
                    recItem.Blocked := true;

                //added310523AS
                recItem."Component description" := recItemStage.component_desc;
                recItem."sale associate" := recItemStage.sales_associate;
                recItem.Padded := recItemStage.is_padded;
                recItem."Attached can can" := recItemStage.is_attached_can_can;
                recItem."Query Confirmed By" := recItemStage.query_confirmed_by;
                recItem."Collection Type" := recItemStage.collection_type;
                recItem."Product Classication" := recItemStage.type_classification;
                recItem."extra charges Designer" := recItemStage.desg_extra_charges;
                recItem."extra charges aza" := recItemStage.aza_extra_charges;
                recItem."Order Delivery Date" := recItemStage.order_delivery_date;
                //<<
                //added120623
                recItem.Validate(measurements, recItemStage.measurements);
                recItem.Validate(ref_barcode, recItemStage.ref_barcode);
                //<<


                //>>>>>>>>>>>>>>>Image URLs 180723>>>>>>>>>>>>>>>>>
                recItem.Validate(image3, recItemStage.image3);
                recItem.Validate(image4, recItemStage.image4);
                recItem.Validate(image5, recItemStage.image5);
                recItem.Validate(image6, recItemStage.image6);
                recItem.Validate(image7, recItemStage.image7);
                recItem.Validate(image8, recItemStage.image8);
                recItem.Validate(image9, recItemStage.image9);
                recItem.Validate(image10, recItemStage.image10);

                //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                /* Clear(ImageURL); //commented CITS_RS 170223
                 Clear(client);
                 Clear(Response);

                 ImageURL := recItemStage.image1;
                 Clear(L_Instream);
                 if client.Get(ImageURL, Response) then
                     if Response.Content.ReadAs(L_Instream) then
                         if StrLen(recItemStage.bar_code) > 20 then begin
                             if recItem.get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then begin
                                 Clear(recItem.Picture);
                                 recItem.Picture.ImportStream(L_Instream, 'Image 1');
                                 // recItem.Modify();
                             end;
                         end else begin
                             if recItem.Get(copystr(recItemStage.bar_code, 1, 20)) then begin
                                 Clear(recItem.Picture);
                                 recItem.Picture.ImportStream(L_Instream, 'Image 1');
                                 // recItem.Modify();
                             end;
                         end;

                 Clear(ImageURL2);
                 Clear(client2);
                 Clear(Response2);
                 ImageURL2 := recItemStage.image2;
                 Clear(L_Instream2);
                 if client2.Get(ImageURL2, Response2) then
                     if Response2.Content.ReadAs(L_Instream2) then
                         if StrLen(recItemStage.bar_code) > 20 then begin
                             if recItem.Get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then begin
                                 Clear(recItem.Picture2);
                                 recItem.Picture2.ImportStream(L_Instream2, 'Image 2');
                                 // recItem.Modify();
                             end;
                         end else begin
                             if recItem.Get(copystr(recItemStage.bar_code, 1, 20)) then begin
                                 Clear(recItem.Picture2);
                                 recItem.Picture2.ImportStream(L_Instream2, 'Image 2');
                                 // recItem.Modify();
                             end;
                         end;*/

                recSizeColorMaster.Reset();
                recSizeColorMaster.SetRange(Type, recSizeColorMaster.Type::Size);
                recSizeColorMaster.SetRange(Code, recItemStage.size_id);
                if not recSizeColorMaster.FindFirst() then
                    Error('Size %1 not found in the master', recItemStage.size_id)
                else begin
                    recItem.sizeName := recSizeColorMaster.Description;
                    recItem."Size ID" := recSizeColorMaster.Code;
                end;

                if colorCSVFound then begin //CITS_RS 130223
                    recSizeColorMaster.Reset();
                    recSizeColorMaster.SetRange(Type, recSizeColorMaster.Type::Color);
                    recSizeColorMaster.SetRange(Code, ColorVar2);
                    if not recSizeColorMaster.FindFirst() then
                        Error('Color %1 not found in the master', ColorVar2)
                    else begin
                        recItem.colorName := recSizeColorMaster.Description;
                        recItem."Color ID" := recSizeColorMaster.Code;
                    end;
                end else begin
                    recSizeColorMaster.Reset();
                    recSizeColorMaster.SetRange(Type, recSizeColorMaster.Type::Color);
                    recSizeColorMaster.SetRange(Code, recItemStage.color_id);
                    if not recSizeColorMaster.FindFirst() then
                        Error('Color %1 not found in the master', recItemStage.color_id)
                    else begin
                        recItem.colorName := recSizeColorMaster.Description;
                        recItem."Color ID" := recSizeColorMaster.Code;
                    end;
                end;
                // recItem.colorName := recItemStage.color_id;
                //SK++
                recItem.Validate("Unit Cost", recItemStage.product_cost);
                recItem.Validate("Unit Price", recItemStage.product_price);
                recItem.Validate(MRP, recItemStage.product_price);//010323
                recItem.Validate("Inclusive of GST", recItemStage.product_cost);

                // recItem.Validate(discountPercent, recItemStage.discount_percent);
                // recItem.Validate(discountPercentByDesg, recItemStage.discount_percent_by_desg);
                // recItem.Validate(discountPercentByAza, recItemStage.discount_percent_by_aza);
                //SK--
                //recItem.Validate("LSCIN Price Inclusive of Tax", true);
                recItem."LSCIN Price Inclusive of Tax" := true;
                SalPrice.Reset();
                SalPrice.SetRange("Item No.", recItem."No.");
                SalPrice.SetRange("Sales Type", SalPrice."Sales Type"::"Customer Price Group");
                if SalPrice.FindFirst() then begin
                    SalPrice.Validate("Price Inclusive of Tax", true);
                    SalPrice.Modify();
                end;
                //recItem."Item Category Code" := recItemStage.category_code;



                recItem.Modify();//final insert

                if not errorFound then begin
                    if updateFlag then begin
                        recItemStage."Record Status" := recItemStage."Record Status"::Updated;
                        recItemStage.Modify();

                    end else begin
                        recItemStage."Record Status" := recItemStage."Record Status"::Created;
                        recItemStage.Modify();
                    end;
                end else begin
                    if StrLen(recItemStage.bar_code) > 20 then begin
                        if recItem.Get(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1) then
                            if ItemSanityCheck(recItem) then begin//200623 CITS_RS
                                recItem.Delete();
                                if LSCBarcodes.Get(copystr(recItemStage.Old_aza_code, 1, 20)) then
                                    LSCBarcodes.Delete();
                            end;

                    end else begin
                        if recItem.get(copystr(recItemStage.bar_code, 1, 20)) then
                            if ItemSanityCheck(recItem) then begin//200623 CITS_RS
                                recItem.Delete();
                                if LSCBarcodes.Get(copystr(recItemStage.Old_aza_code, 1, 20)) then
                                    LSCBarcodes.Delete();
                            end;
                    end;
                    recItemStage."Record Status" := recItemStage."Record Status"::Error;
                    recItemStage.Modify();
                end;
                //>>>>>>>>>>>>>>
                if Item.Get(txtBarcode) then begin
                    GSTMaster1.Reset();
                    GSTMaster1.SetRange(GSTMaster1.Category, Item."LSC Division Code");
                    GSTMaster1.SetRange(GSTMaster1."Subcategory 1", Item."Item Category Code");
                    GSTMaster1.SetRange(GSTMaster1."Subcategory 2", Item."LSC Retail Product Code");
                    GSTMaster1.SetRange(Fabric_Type, Item."Fabric Type");
                    GSTMaster1.SetFilter("From Amount", '<=%1', recItemStage.product_cost);
                    GSTMaster1.SetFilter("To Amount", '>=%1', recItemStage.product_cost);
                    if GSTMaster1.FindFirst() then begin
                        GSTGC := GSTMaster1."GST Group";
                    end;
                    GstGroup.Reset();
                    GstGroup.SetRange(Code, GSTGC);
                    if GstGroup.FindFirst() then
                        Gstrate1 := GstGroup."GST %";
                    Item."Unit Cost" := Round(recItemStage.product_cost - ((recItemStage.product_cost * Gstrate1) / (100 + gstrate1)), 0.01);
                    item.Modify();
                end;
            end;
            // if recItem.get(recItemStage.bar_code) then
            //     CU_Functions.UpdateGSTFields(recItem);
        end;
        // end;
    end;

    procedure UpdateItem(recItemStage: Record Aza_Item)
    var
        L_Instream: InStream;
        recItem: Record Item;
        vendor: Record Vendor;
        ImageURL: Text;
        GSTMaster1: Record "GST Master";
        GSTGC: Code[20];
        GSThsn: Code[20];
        GstGroup: Record "GST Group";
        Gstrate1: Decimal;
        Item: record item;
        recSizeColorMaster: Record ColorSizeMaster;
        client: HttpClient;
        SalPrice: Record "Sales Price";
        subsubCSVfound: Boolean;
        colorCSVFound: Boolean;
        boolModify: Boolean;
        retProdCSV: Text;
        Response: HttpResponseMessage;
        TabLocation: Record Location;
        FCLocation: Integer;
    begin
        Clear(subsubCSVfound);//CITS_RS 130223
        Clear(colorCSVFound);//CITS_RS 130223
        Clear(recItem);
        Clear(ImageURL);
        Clear(client);
        Clear(Response);
        if StrLen(recItemStage.bar_code) > 20 then
            recItem.Get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1))
        else
            recItem.get(recItemStage.bar_code);

        if recItem.tagCode <> recItemStage.tag_code then begin
            recItem.tagCode := recItemStage.tag_code;
            boolModify := true;
        end;
        //CITS_RS 130223++
        if StrPos(recItemStage.color_id, ',') > 0 then begin
            ColorVar := recItemStage.color_id;
            ColorVar2 := SelectStr(1, ColorVar);
            colorCSVFound := true;
        end;
        //CITS_RS 130223++
        if StrPos(recItemStage.sub_sub_category_code, ',') > 0 then begin
            retProdCSV := recItemStage.sub_sub_category_code;
            retProdCSV := SelectStr(1, recItemStage.sub_sub_category_code);
            subsubCSVfound := true;
        end;
        if recItem.azaCode <> recItemStage.aza_code then begin
            recItem.validate(azaCode, recItemStage.aza_code);
            boolModify := true;
        end;

        //CITS_RS 010323
        if recItem.MRP <> recItemStage.product_price then begin
            recItem.validate(MRP, recItemStage.product_price);
            boolModify := true;
        end;

        // if recItem.Old_aza_code <> recItemStage.Old_aza_code then begin
        //     recItem.validate(Old_aza_code, recItemStage.Old_aza_code);
        //     boolModify := true;
        // end;//1809//Naveen-- uncomment suggest by sunny 260923

        if recItem.designerID <> recItemStage.designer_code then begin
            recItem.validate(designerID, recItemStage.designer_id);
            boolModify := true;
        end;

        if recItem."Designer Code" <> recItemStage.designer_code then begin
            recItem.validate("Designer Code", recItemStage.designer_code);
            boolModify := true;
        end;

        if recItem."Vendor No." <> recItemStage.designer_id then begin
            recItem.validate("Vendor No.", recItemStage.designer_id);
            if vendor.Get(recItemStage.designer_id) then
                recItem."Vendor Abbreviation" := vendor."Designer Abbreviation";
            boolModify := true;
        end;

        if recItemStage.product_title <> recItem.Description then begin
            recItem.Validate(Description, recItemStage.product_title);
            boolModify := true;
        end;


        if recItemStage.category_code <> recItem."LSC Division Code" then begin
            recItem.Validate("LSC Division Code", recItemStage.category_code);
            boolModify := true;
        end;

        if recItemStage.sub_category_code <> recItem."Item Category Code" then begin
            recItem.Validate("Item Category Code", recItemStage.sub_category_code);
            boolModify := true;
        end;

        //CITS_RS 130223 ++
        if subsubCSVfound then begin
            if recItem."LSC Retail Product Code" <> retProdCSV then begin
                if retProdCSV <> '' then
                    recItem.Validate("LSC Retail Product Code", retProdCSV);
                boolModify := true;
            end
        end else begin
            if recItemStage.sub_sub_category_code <> recItem."LSC Retail Product Code" then begin
                if recItemStage.sub_sub_category_code <> '' then
                    recItem.Validate("LSC Retail Product Code", recItemStage.sub_sub_category_code);
                boolModify := true;
            end;
        end;

        if recItemStage.po_type <> recItem."PO type" then begin
            recItem.Validate("PO type", recItemStage.po_type);
            boolModify := true;
        end;

        if recItemStage.merchandise_name <> copystr(recItemStage.merchandise_name, 1, 50) then begin
            recItem.merchandiserName := copystr(recItemStage.merchandise_name, 1, 50);
            boolModify := true;
        end;



        if recItem.designerID <> recItemStage.designer_id then begin
            recItem.validate(designerID, recItemStage.designer_id);
            boolModify := true;
        end;

        if recItem.componentsNo <> recItemStage.components_no then begin
            recItem.componentsNo := recItemStage.components_no;
            boolModify := true;
        end;

        Evaluate(FCLocation, recItemStage.fc_location);
        TabLocation.Reset();
        TabLocation.SetRange("fc_location ID", FCLocation);
        if TabLocation.FindFirst() then begin
            if recItem."fc location" <> TabLocation.code then begin
                recItem."fc location" := TabLocation.Code;
                boolModify := true;
            end;
        end
        else
            Error('FC location %1 not found in the system !', FCLocation);


        if recItem."Neckline Type" <> recItemStage.neckline_type then begin
            recItem."Neckline Type" := recItemStage.neckline_type;
            boolModify := true;
        end;

        if recItem."Sleeve Length" <> recItemStage.sleeve_length then begin
            recItem."Sleeve Length" := recItemStage.sleeve_length;
            boolModify := true;
        end;

        if recItem."Closure Type" <> recItemStage.closure_type then begin
            recItem."Closure Type" := recItemStage.closure_type;
            boolModify := true;
        end;

        if recItem."Fabric Type" <> recItemStage.fabric_type then begin
            recItem."Fabric Type" := recItemStage.fabric_type;
            boolModify := true;
        end;

        if recItem."Type of Work" <> recItemStage.type_of_work then begin
            recItem."Type of Work" := recItemStage.type_of_work;
            boolModify := true;
        end;

        if recItem."Type of Pattern" <> recItemStage.type_of_pattern then begin
            recItem."Type of Pattern" := recItemStage.type_of_pattern;
            boolModify := true;
        end;

        if recItem."Vendor Item No." <> recItem."Designer Code" then begin
            recItem."Vendor Item No." := recItem."Designer Code";
            boolModify := true;
        end;

        if recItem."Designer Code" <> recItemStage.designer_code then begin
            recItem."Designer Code" := recItemStage.designer_code;
            boolModify := true;
        end;

        if recItem."Product Title" <> recItemStage.product_title then begin
            recItem."Product Title" := recItemStage.product_title;
            boolModify := true;
        end;

        if recItem."Sleeve Type" <> recItemStage.sleeve_length then begin
            recItem."Sleeve Type" := recItemStage.sleeve_length;
            boolModify := true;
        end;

        if recItem."Stylist Note" <> recItemStage.stylist_note then begin
            recItem."Stylist Note" := recItemStage.stylist_note;
            boolModify := true;
        end;

        if recItem.productThumbImg <> recItemStage.product_thumbImg then begin
            recItem.productThumbImg := recItemStage.product_thumbImg;
            boolModify := true;
        end;

        if recItem.addedBy <> recItemStage.added_by then begin
            recItem.addedBy := recItemStage.added_by;
            boolModify := true;
        end;

        if recItem."Customer No." <> recItemStage.customer_id then begin
            recItem.validate("Customer No.", recItemStage.customer_id);
            boolModify := true;
        end;

        if recItem."LSC Date Created" <> recItemStage.date_added then begin
            recItem."LSC Date Created" := recItemStage.date_added;
            boolModify := true;
        end;

        if recItem.modifiedBy <> recItemStage.modified_by then begin
            recItem.modifiedBy := recItemStage.modified_by;
            boolModify := true;
        end;

        if recItem."Modified Date" <> recItemStage.modified_date then begin
            recItem."Modified Date" := recItemStage.modified_date;
            boolModify := true;
        end;

        if recItem."Inclusive of GST" <> recItemStage.product_cost then begin
            recItem."Inclusive of GST" := recItemStage.product_cost;
            boolModify := true;
        end;

        if recItem.image3 <> recItemStage.image3 then begin
            recItem.image3 := recItemStage.image3;
            boolModify := true;
        end;

        if recItem.image4 <> recItemStage.image4 then begin
            recItem.image4 := recItemStage.image4;
            boolModify := true;
        end;

        if recItem.image5 <> recItemStage.image5 then begin
            recItem.image5 := recItemStage.image5;
            boolModify := true;
        end;

        if recItem.image6 <> recItemStage.image6 then begin
            recItem.image6 := recItemStage.image6;
            boolModify := true;
        end;

        if recItem.image7 <> recItemStage.image7 then begin
            recItem.image7 := recItemStage.image7;
            boolModify := true;
        end;

        if recItem.image8 <> recItemStage.image8 then begin
            recItem.image8 := recItemStage.image8;
            boolModify := true;
        end;

        if recItem.image9 <> recItemStage.image9 then begin
            recItem.image9 := recItemStage.image9;
            boolModify := true;
        end;

        if recItem.image10 <> recItemStage.image10 then begin
            recItem.image10 := recItemStage.image10;
            boolModify := true;
        end;


        if recItem."Unit Cost" <> recItemStage.product_cost then begin
            // recItem.validate("Unit Cost", recItemStage.product_cost);  //AS290623
            //   if Item.Get(recItem."No.") then begin
            GSTMaster1.Reset();
            GSTMaster1.SetRange(GSTMaster1.Category, recItem."LSC Division Code");
            GSTMaster1.SetRange(GSTMaster1."Subcategory 1", recItem."Item Category Code");
            GSTMaster1.SetRange(GSTMaster1."Subcategory 2", recItem."LSC Retail Product Code");
            GSTMaster1.SetRange(Fabric_Type, recItem."Fabric Type");
            GSTMaster1.SetFilter("From Amount", '<=%1', recItemStage.product_cost);
            GSTMaster1.SetFilter("To Amount", '>=%1', recItemStage.product_cost);
            if GSTMaster1.FindFirst() then begin
                GSTGC := GSTMaster1."GST Group";
            end;
            GstGroup.Reset();
            GstGroup.SetRange(Code, GSTGC);
            if GstGroup.FindFirst() then
                Gstrate1 := GstGroup."GST %";
            recItem."Unit Cost" := Round(recItemStage.product_cost - ((recItemStage.product_cost * Gstrate1) / (100 + gstrate1)), 0.01);
            // recItem.Modify();
            // end;
            boolModify := true;
        end;

        if recItem."Unit Price" <> recItemStage.product_price then begin
            recItem.validate("Unit Price", recItemStage.product_price);
            recItem."LSCIN Price Inclusive of Tax" := true;
            boolModify := true;

            SalPrice.Reset();
            SalPrice.SetRange("Item No.", recItem."No.");
            SalPrice.SetRange("Sales Type", SalPrice."Sales Type"::"Customer Price Group");
            if SalPrice.FindFirst() then
                repeat
                    SalPrice.Validate("Price Inclusive of Tax", true);
                    SalPrice.Modify();
                until SalPrice.Next() = 0;
        end;

        // if recItem.discountPercent <> recItemStage.discount_percent then begin
        //     recItem.validate(discountPercent, recItemStage.discount_percent);
        //     boolModify := true;
        // end;

        // if recItem.discountPercentByAza <> recItemStage.discount_percent_by_aza then begin
        //     recItem.validate(discountPercentByAza, recItemStage.discount_percent_by_aza);
        //     boolModify := true;
        // end;

        // if recItem.discountPercentByDesg <> recItemStage.discount_percent_by_desg then begin
        //     recItem.validate(discountPercentByDesg, recItemStage.discount_percent_by_desg);
        //     boolModify := true;
        // end;//Anshu--CCIt

        /*if recItemStage.image1 <> recItem.image1 then begin //commented CITS_RS 170223
            // recItem.Get(recItemStage.bar_code);
            ImageURL := recItemStage.image1;
            Clear(L_Instream);
            client.Get(ImageURL, Response);
            Response.Content.ReadAs(L_Instream);
            recItem.Picture.ImportStream(L_Instream, 'Image 1', 'image/jpeg');
            boolModify := true;
        end;

        if recItemStage.image2 <> recItem.image2 then begin
            // recItem.Get(recItemStage.bar_code);
            ImageURL := recItemStage.image2;
            Clear(L_Instream);
            client.Get(ImageURL, Response);
            Response.Content.ReadAs(L_Instream);
            recItem.Picture.ImportStream(L_Instream, 'Image 2', 'image/jpeg');
            boolModify := true;
        end;*/

        if recItem."Size ID" <> recItemStage.size_id then begin
            // if recItem.sizeName <> recItemStage.size_id then begin
            recSizeColorMaster.Reset();
            recSizeColorMaster.SetRange(Type, recSizeColorMaster.Type::Size);
            recSizeColorMaster.SetRange(Code, recItemStage.size_id);
            if not recSizeColorMaster.FindFirst() then
                Error('Size %1 not found in the master', recItemStage.size_id)
            else begin
                // recItem.sizeName := recItemStage.size_id;
                recItem.sizeName := recSizeColorMaster.Description;
                recItem."Size ID" := recSizeColorMaster.Code;
                // recItem.sizeName := recItemStage.size_id;
                boolModify := true;
            end;
        end;

        //CITS_RS 130223++
        if colorCSVFound then begin
            if recItem."Color ID" <> ColorVar2 then begin
                recSizeColorMaster.Reset();
                recSizeColorMaster.SetRange(Type, recSizeColorMaster.Type::Color);
                recSizeColorMaster.SetRange(Code, ColorVar2);
                if not recSizeColorMaster.FindFirst() then
                    Error('Color %1 not found in the master', ColorVar2)
                else begin
                    recItem.colorName := recSizeColorMaster.Description;
                    recItem."Color ID" := recSizeColorMaster.Code;
                    boolModify := true;
                end;
            end;
        end else begin
            if recItem."Color ID" <> recItemStage.color_id then begin
                recSizeColorMaster.Reset();
                recSizeColorMaster.SetRange(Type, recSizeColorMaster.Type::Color);
                recSizeColorMaster.SetRange(Code, recItemStage.color_id);
                if not recSizeColorMaster.FindFirst() then
                    Error('Color %1 not found in the master', recItemStage.color_id)
                else begin
                    recItem.colorName := recSizeColorMaster.Description;
                    recItem."Color ID" := recSizeColorMaster.Code;
                    boolModify := true;
                end;
            end;
        end;

        if recItem.status <> recItemStage.status then begin
            recItem.status := recItemStage.status;
            if not recItemStage.status then
                recItem.Blocked := true;
            boolModify := true;
        end;

        if boolModify = true then begin
            recItem.Modify();
            recItemStage."Record Status" := recItemStage."Record Status"::Updated;
            recItemStage.Modify();
        end;
    end;

    procedure ItemSanityCheck(recItemparm: Record 27): Boolean
    var
        recItemMaster: Record 27;
        recILE: record 32;
        boolDelete: Boolean;
    begin
        boolDelete := true;
        if recItemMaster.Get(recItemparm."No.") then
            if recItemMaster."Is Approved for Sale" then
                boolDelete := false;

        recILE.Reset();
        recILE.SetRange("Item No.", recItemparm."No.");
        if recILE.FindFirst() then
            boolDelete := false;

        exit(boolDelete);

    end;
}