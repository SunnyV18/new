codeunit 50104 ProcessItem_Designer
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        if Rec."Parameter String" = 'CreateVendor' then
            ProcessVendors();

        if Rec."Parameter String" = 'CreateItem' then
            ProcessItems();
    end;

    [TryFunction]
    procedure CreateItem(recItemStage: Record Aza_Item)
    var
        recItem: Record Item;
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
            if recItemStage.designer_id <> '' then begin
                L_Vendor.Reset();
                L_Vendor.SetRange("No.", recItemStage.designer_id);
                if NOT L_Vendor.FindFirst() then begin
                    cuFunctions.CreateErrorLog(1, StrSubstNo('Vendor %1 does not exist', recItemStage.designer_id), recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                    errorFound := true;
                end;
            end;
            if recItemStage.type_of_inventory = '' then begin
                cuFunctions.CreateErrorLog(1, 'Type of inventory is missing', recItemStage."Entry No.", recItemStage.designer_id, txtBarcode, '');
                errorFound := true;
            end;

            if recItemStage."Record Status" = recItemStage."Record Status"::" " then begin
                recItem.Reset();
                if not recItem.get(txtBarcode) then begin
                    recItem.Reset();
                    recItem.Init();
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
                        // end;//Naveen-- uncomment suggest by sunny 260923
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
                //  recItem.Old_aza_code := recItemStage.Old_aza_code;//1809//Naveen-- uncomment suggest by sunny 260923
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

    [TryFunction]

    procedure ProcessImages(parmBarcode: Code[100])
    var
        L_Instream: InStream;
        ImageURL: Text;
        client: HttpClient;
        Response: HttpResponseMessage;
        errorFound: Boolean;
        L_Instream2: InStream;
        ImageURL2: Text;
        updateFlag: Boolean;
        client2: HttpClient;
        recItemStage: Record Aza_Item;
        boolUpdated: Boolean;
        recItem: Record 27;
        Response2: HttpResponseMessage;
    begin
        Clear(ImageURL);
        Clear(client);
        Clear(boolUpdated);
        Clear(Response);
        recItemStage.Reset();
        recItemStage.SetRange(bar_code, parmBarcode);
        // recItemStage.SetFilter(image1, '<>%1|%2', ' ', '');
        if not recItemStage.FindLast() then;// Error('Item %1 not found in Aza staging during image processing', recItemStage.bar_code);

        if (recItemStage.image1 <> ' ') and (recItemStage.image1 <> '') then begin
            ImageURL := recItemStage.image1;
            Clear(L_Instream);
            if client.Get(ImageURL, Response) then
                if Response.Content.ReadAs(L_Instream) then
                    if StrLen(recItemStage.bar_code) > 20 then begin
                        if recItem.get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then begin
                            Clear(recItem.Picture);
                            recItem.Picture.ImportStream(L_Instream, 'Image 1');
                            recItem.Modify();
                        end;
                    end else begin
                        if recItem.Get(copystr(recItemStage.bar_code, 1, 20)) then begin
                            Clear(recItem.Picture);
                            recItem.Picture.ImportStream(L_Instream, 'Image 1');
                            recItem.Modify();
                        end;
                    end;
            boolUpdated := true;
        end;

        if (recItemStage.image2 <> ' ') and (recItemStage.image2 <> '') then begin

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
                            recItem.Modify();
                        end;
                    end else begin
                        if recItem.Get(copystr(recItemStage.bar_code, 1, 20)) then begin
                            Clear(recItem.Picture2);
                            recItem.Picture2.ImportStream(L_Instream2, 'Image 2');
                            recItem.Modify();
                        end;
                    end;
            boolUpdated := true;
        end;

        // if boolUpdated then
        //     if strlen(parmBarcode) > 20 then begin
        //         if recItem.Get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then
        //             recItem.Modify();
        //     end else begin
        //         if recItem.Get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then
        //             recItem.Modify();
        //     end;
    end;


    [TryFunction]
    procedure AssignCategories(CategorySizeStaging: Record CategorySizeStaging)
    var
        ItemCatagory: Record "Item Category";
        division: Record "LSC Division";
        RetailProductGroup: Record "LSC Retail Product Group";
        SubSubVar: code[50];
        subsubCSVFound: Boolean;
        SubSubVar2: code[50];
    begin
        Clear(subsubCSVFound);
        // CategorySizeStaging.Reset();
        // CategorySizeStaging.SetRange(RecProcessed, false);
        // if CategorySizeStaging.FindSet() then begin
        //     repeat

        CategorySizeStaging.TestField(Code);
        CategorySizeStaging.TestField("Sub Category Code");
        //CategorySizeStaging.TestField("Sub Sub Category Code");
        if not division.Get(CategorySizeStaging.Code) then begin
            division.Init();
            division.Code := CategorySizeStaging.Code;
            division.Description := CategorySizeStaging.Name;
            division.Insert(true);
        end else begin
            division.Description := CategorySizeStaging.Name;
            division.Modify();
        end;
        if not ItemCatagory.Get(CategorySizeStaging."Sub Category Code") then begin
            ItemCatagory.Init();
            ItemCatagory.Code := CategorySizeStaging."Sub Category Code";
            ItemCatagory.Description := CategorySizeStaging."Sub Category Name";
            ItemCatagory."LSC Division Code" := CategorySizeStaging.Code;
            ItemCatagory.Insert(true);
        end else begin
            iF ItemCatagory.Description <> CategorySizeStaging."Sub Category Name" then
                ItemCatagory.Description := CategorySizeStaging."Sub Category Name";
            if ItemCatagory."LSC Division Code" <> CategorySizeStaging.Code then
                ItemCatagory."LSC Division Code" := CategorySizeStaging.Code;
            ItemCatagory.Modify();
        end;
        if StrPos(CategorySizeStaging."Sub Sub Category Code", ',') > 0 then begin
            SubSubVar := CategorySizeStaging."Sub Sub Category Code";
            SubSubVar2 := SelectStr(1, SubSubVar);
            subsubCSVFound := true;
        end;
        if subsubCSVFound then begin
            if not RetailProductGroup.Get(CategorySizeStaging."Sub Category Code", SubSubVar2) then begin
                RetailProductGroup.Init();
                RetailProductGroup."Item Category Code" := CategorySizeStaging."Sub Category Code";
                RetailProductGroup.Code := SubSubVar2;
                RetailProductGroup.Description := CategorySizeStaging."Sub Sub Category Name";
                RetailProductGroup.Insert(true);
            end else begin
                if RetailProductGroup.Description <> CategorySizeStaging."Sub Sub Category Name" then begin
                    RetailProductGroup.Description := CategorySizeStaging."Sub Sub Category Name";
                    RetailProductGroup.Modify();
                end;
            end;
        end else begin
            if not RetailProductGroup.Get(CategorySizeStaging."Sub Category Code", CategorySizeStaging."Sub Sub Category Code") then begin
                RetailProductGroup.Init();
                RetailProductGroup."Item Category Code" := CategorySizeStaging."Sub Category Code";
                RetailProductGroup.Code := CategorySizeStaging."Sub Sub Category Code";
                RetailProductGroup.Description := CategorySizeStaging."Sub Sub Category Name";
                RetailProductGroup.Insert();
            end else begin
                if RetailProductGroup.Description <> CategorySizeStaging."Sub Sub Category Name" then begin
                    RetailProductGroup.Description := CategorySizeStaging."Sub Sub Category Name";
                    RetailProductGroup.modify();
                end;
            end;
        end;
        // CategorySizeStaging.RecProcessed := true;
        // CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Created;
        // CategorySizeStaging.Modify();
        // until CategorySizeStaging.Next() = 0;
        // Message('Categories Created Successfully');
        // end;
    end;

    procedure ProcessCategoryMaster()
    var
        CategorySizeStaging: Record CategorySizeStaging;
        recSizeColorMaster: Record ColorSizeMaster;
        recErrorLog: Record ErrorCapture;
    begin
        CategorySizeStaging.Reset();
        CategorySizeStaging.SetRange("Record Status", CategorySizeStaging."Record Status"::" ");
        CategorySizeStaging.SetRange(RecProcessed, false);
        CategorySizeStaging.SetRange(Type, 'Category');
        if CategorySizeStaging.Find('-') then
            repeat
                if not AssignCategories(CategorySizeStaging) then begin
                    cuFunctions.CreateErrorLog(8, '', CategorySizeStaging."Entry No", '', '', '');
                    CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Error;
                    CategorySizeStaging.RecProcessed := false;
                    CategorySizeStaging.Modify();
                end else begin
                    CategorySizeStaging.RecProcessed := true;
                    CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Created;
                    CategorySizeStaging.Modify();
                end;
            until CategorySizeStaging.Next() = 0;

        CategorySizeStaging.SetRange(Type, 'Size');
        if CategorySizeStaging.Find('-') then
            repeat
                if not recSizeColorMaster.Get(recSizeColorMaster.Type::Size, CategorySizeStaging.Code) then begin
                    recSizeColorMaster.Init();
                    recSizeColorMaster.Type := recSizeColorMaster.Type::Size;
                    recSizeColorMaster.Code := CategorySizeStaging.Code;
                    recSizeColorMaster.Description := CategorySizeStaging.Name;
                    if recSizeColorMaster.Insert() then begin
                        CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Created;
                        CategorySizeStaging.RecProcessed := true;
                        CategorySizeStaging.Modify();
                    end else begin
                        cuFunctions.CreateErrorLog(8, '', CategorySizeStaging."Entry No", '', '', '');
                        CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Error;
                        // CategorySizeStaging.RecProcessed := false;
                        CategorySizeStaging.Modify();
                    end;
                end else begin
                    recSizeColorMaster.reset();
                    // if recSizeColorMaster.Description <> CategorySizeStaging.Name then begin
                    recSizeColorMaster.Description := CategorySizeStaging.Name;
                    if recSizeColorMaster.Modify() then begin
                        CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Created;
                        CategorySizeStaging.RecProcessed := true;
                        CategorySizeStaging.Modify();
                    end else begin
                        cuFunctions.CreateErrorLog(8, '', CategorySizeStaging."Entry No", '', '', '');
                        CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Error;
                        //CategorySizeStaging.RecProcessed := false;
                        CategorySizeStaging.Modify();
                    end;
                    //  end;
                end;
            until CategorySizeStaging.Next() = 0;

        CategorySizeStaging.SetRange(Type, 'Color');
        if CategorySizeStaging.Find('-') then
            repeat
                if not recSizeColorMaster.Get(recSizeColorMaster.Type::Color, CategorySizeStaging.Code) then begin
                    recSizeColorMaster.Init();
                    recSizeColorMaster.Type := recSizeColorMaster.Type::Color;
                    recSizeColorMaster.Code := CategorySizeStaging.Code;
                    recSizeColorMaster.Description := CategorySizeStaging.Name;
                    if recSizeColorMaster.Insert() then begin
                        CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Created;
                        CategorySizeStaging.RecProcessed := true;
                        CategorySizeStaging.Modify();
                    end else begin
                        cuFunctions.CreateErrorLog(8, '', CategorySizeStaging."Entry No", '', '', '');
                        CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Error;
                        //CategorySizeStaging.RecProcessed := false;
                        CategorySizeStaging.Modify();
                    end;
                end else begin
                    recSizeColorMaster.reset();
                    //if recSizeColorMaster.Description <> CategorySizeStaging.Name then begin
                    recSizeColorMaster.Description := CategorySizeStaging.Name;
                    if recSizeColorMaster.modify() then begin
                        CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Created;
                        CategorySizeStaging.RecProcessed := true;
                        CategorySizeStaging.Modify();
                    end else begin
                        cuFunctions.CreateErrorLog(8, '', CategorySizeStaging."Entry No", '', '', '');
                        CategorySizeStaging."Record Status" := CategorySizeStaging."Record Status"::Error;
                        //CategorySizeStaging.RecProcessed := false;
                        CategorySizeStaging.Modify();
                    end;
                    // end;
                end;
            until CategorySizeStaging.Next() = 0;
    end;

    procedure ProcessVendors()
    var
        recDesignerStage: Record Aza_Designer;
        recErrorLog: Record ErrorCapture;
        errorFound: Boolean;
        CreateVendors: Codeunit CreateVendors;
    begin
        Clear(glVendorCreated);
        Clear(errorFound);
        recDesignerStage.Reset();
        recDesignerStage.SetRange("Record Status", recDesignerStage."Record Status"::" ");
        recDesignerStage.SetRange(final_approved_status, 'APPROVED'); //ADDED16052023
        if recDesignerStage.Find('-') then
            repeat
                Commit();
                if not CreateVendors.Run(recDesignerStage) then begin
                    // cuFunctions.CreateErrorLog(3, '', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
                    cuFunctions.CreateErrorLogCustVend(3, '', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
                    errorFound := true;
                    recDesignerStage."Record Status" := recDesignerStage."Record Status"::Error;
                    recDesignerStage.Modify();
                    // end ;//else begin
                    //     recDesignerStage."Record Status" := recDesignerStage."Record Status"::Created;
                    //     recDesignerStage.Modify(false);
                    //     // DeleteErrorLogs_Vendor(recDesignerStage);
                end;

            until recDesignerStage.Next() = 0;


        //For errors
        /*Clear(glVendorCreated);
        recDesignerStage.Reset();
        recDesignerStage.SetRange("Record Status", recDesignerStage."Record Status"::Error);
        recDesignerStage.SetRange("Error Date", Today - 2, Today);
        if recDesignerStage.Find('-') then
            repeat
                if not CreateVendors(recDesignerStage) then begin
                    cuFunctions.CreateErrorLog(3, '', recDesignerStage."Entry No.", format(recDesignerStage.id), '', '');
                    recDesignerStage."Record Status" := recDesignerStage."Record Status"::Error;
                    recDesignerStage."Error Date" := Today;
                    recDesignerStage.Modify();
                    // end ;//else begin
                    //     recDesignerStage."Record Status" := recDesignerStage."Record Status"::Created;
                    //  recDesignerStage.Modify(false);
                    //   DeleteErrorLogs_Vendor(recDesignerStage);//160223
                end else begin
                    recDesignerStage."Record Status" := recDesignerStage."Record Status"::Created;
                    glVendorCreated := true;
                    recDesignerStage.Modify(false);
                    DeleteErrorLogs_Vendor(recDesignerStage);
                    // recErrorLog.Reset();
                    // recErrorLog.SetRange("Vendor Code", Format(recDesignerStage.id));
                    // if recErrorLog.FindSet() then
                    //     recErrorLog.Delete();
                end;
            until recDesignerStage.Next() = 0;*/

        if glVendorCreated then
            Message('Vendors Created Successfully');
    end;

    procedure DeleteErrorLogs_Vendor(recDesignerStage: Record Aza_Designer)
    var
        recErrorLog: Record ErrorCapture;
    begin
        recErrorLog.Reset();
        // recErrorLog.SetRange("Vendor Code", format(recDesignerStage.id));
        recErrorLog.SetRange("Source Entry No.", recDesignerStage."Entry No."); //160223
        recErrorLog.setrange("Process Type", recErrorLog."Process Type"::"Vendor Creation");
        if recErrorLog.Find('-') then
            repeat
                recErrorLog.Delete();//using delete instead of delete all to avoid table locking;
            until recErrorLog.Next() = 0;
    end;

    procedure DeleteErrorLogs_Item(recItemStage: Record Aza_Item)
    var
        recErrorLog: Record ErrorCapture;
    begin
        recErrorLog.Reset();
        recErrorLog.SetRange("Source Entry No.", recItemStage."Entry No.");//link changed 160223 CITS_RS
        recErrorLog.setrange("Process Type", recErrorLog."Process Type"::"Item Creation");
        if recErrorLog.Find('-') then
            repeat
                recErrorLog.Delete();//using delete instead of delete all to avoid table locking;
            until recErrorLog.Next() = 0;
    end;

    [TryFunction]
    procedure CreateVendors(recDesignerStage: Record Aza_Designer)
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

    procedure UpdateItem(recItemStage: Record Aza_Item)
    var
        L_Instream: InStream;
        recItem: Record Item;
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
        // end;//Naveen-- uncomment suggest by sunny 260923

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

        if recItemStage.fc_location <> recItemStage.fc_location then begin
            recItemStage.fc_location := recItemStage.fc_location;
            boolModify := true;
        end;

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
        // end;//CCIT---100823

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

    procedure CapturError_VendorCreation(recVendorStage: Record Aza_Designer)
    var
        recVendorError: Record ErrorCapture;
    begin
        recVendorError.Init();
        if recVendorError.findlast then
            recVendorError."Sr. No" += 1
        else
            recVendorError."Sr. No" := 1;
        recVendorError.Item_code := recVendorStage.parent_designer_id;
        recVendorError."Error DateTime" := CurrentDateTime();
        recVendorError."Error Remarks" := copystr(GetLastErrorText(), 1, 1000);
        recVendorError."Process Type" := recVendorError."Process Type"::"Vendor Creation";
        recVendorError.Insert();

    end;

    //  procedure CapturError_ItemCreation(recItem: Record Aza_Item)
    // var
    //     recVendorError: Record ErrorCapture;
    // begin
    //     recVendorError.Init();
    //     if recVendorError.findlast then
    //         recVendorError."Sr. No" += 1
    //     else
    //         recVendorError."Sr. No" := 1;
    //     recVendorError.Item_code := recVendorStage.parent_designer_id;
    //     recVendorError."Error DateTime" := CurrentDateTime();
    //     recVendorError."Error Remarks" := copystr(GetLastErrorText(), 1, 1000);
    //     recVendorError."Process Type" := recVendorError."Process Type"::"Vendor Creation";
    //     recVendorError.Insert();

    // end;

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

    procedure ProcessItems()
    var
        recItemStage: Record Aza_Item;
        i: Integer;
        CU_Functions: Codeunit Functions;
        recItem: Record 27;
        errorFound: Boolean;
        recItemStage1: Record Aza_Item;
        Flag: Boolean;
        recErrorLog: Record ErrorCapture;
        txtBarcode: Code[20];
        LSCBarcodes: Record "LSC Barcodes";
        ErrorMsg: Text;
    begin
        Clear(errorFound);
        ProcessCategoryMaster();//020223 CITS_RS Always Division+ItemCat+RetPros have to be created before creating item.
        Flag := false;
        recItemStage.Reset();
        recItemStage.SetRange("Record Status", recItemStage."Record Status"::" ");
        recItemStage.SetRange("RTV Created", false);//020223
                                                    //recItemStage.SetRange("Entry No.", 250721, 276725);//Naveen---300623
                                                    // recItemStage.SetRange(Is_Outward, false);
        if recItemStage.Find('-') then
            repeat
                Clear(txtBarcode);
                if StrLen(recItemStage.bar_code) > 20 then
                    txtBarcode := CopyStr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)
                else
                    txtBarcode := recItemStage.bar_code;
                if not recItemStage.Is_Outward then begin//020223 CITS_RS
                    if CreateItem(recItemStage) then begin
                        Flag := true;

                        if recItem.get(txtBarcode) then
                            if not CU_Functions.UpdateGSTFields(recItem, ErrorMsg) then begin
                                cuFunctions.CreateErrorLog(1, '', recItemStage."Entry No.", format(recItemStage.designer_id), txtBarcode, '');
                                errorFound := true;
                                recItemStage1.Get(recItemStage."Entry No.");
                                recItemStage1."Record Status" := recItemStage."Record Status"::Error;
                                recItemStage1."Error date" := Today;
                                recItemStage1.Modify();
                                if recItem.get(txtBarcode) then
                                    if ItemSanityCheck(recItem) then begin//200623 CITS_RS
                                        recItem.Delete();//deletion in case GST related values are not assigned 250123
                                        if LSCBarcodes.Get(copystr(recItemStage.Old_aza_code, 1, 20)) then
                                            LSCBarcodes.Delete();
                                    end;
                            end;
                        if not ProcessImages(recItemStage.bar_code) then begin //170223 CITS_RS
                            cuFunctions.CreateErrorLog(1, '', recItemStage."Entry No.", format(recItemStage.designer_id), txtBarcode, '');
                            errorFound := true;
                            recItemStage1.Get(recItemStage."Entry No.");
                            recItemStage1."Record Status" := recItemStage."Record Status"::Error;
                            recItemStage1."Error date" := Today;
                            recItemStage1.Modify();
                            if recItem.get(txtBarcode) then
                                if ItemSanityCheck(recItem) then begin//200623 CITS_RS
                                    recItem.Delete();
                                    if LSCBarcodes.Get(copystr(recItemStage.Old_aza_code, 1, 20)) then
                                        LSCBarcodes.Delete();
                                end;
                        end;
                        // DeleteErrorLogs_Item(recItemStage);
                    end else begin
                        cuFunctions.CreateErrorLog(1, '', recItemStage."Entry No.", format(recItemStage.designer_id), txtBarcode, '');
                        errorFound := true;
                        recItemStage."Record Status" := recItemStage."Record Status"::Error;
                        recItemStage."Error date" := Today;
                        recItemStage.Modify();
                        if recItem.get(txtBarcode) then
                            if ItemSanityCheck(recItem) then begin//200623 CITS_RS
                                recItem.Delete();
                                if LSCBarcodes.Get(copystr(recItemStage.Old_aza_code, 1, 20)) then
                                    LSCBarcodes.Delete();
                            end;
                    end;
                    // if not CreateItem(recItemStage) then//commented CITS_RS 160223
                    //     CaptureError_itemCreation(recItemStage);
                end else begin//RTV creation for Is_Outward items in staging 020223 CITS_RS
                    if CreateRTVforIsoutwardItems(recItemStage) then begin
                        recItemStage."RTV Created" := true;
                        recItemStage."Record Status" := recItemStage."Record Status"::Updated;
                        recItemStage."RTV Created" := true;
                        recItemStage.Modify();
                    end else begin
                        cuFunctions.CreateErrorLog(1, '', recItemStage."Entry No.", format(recItemStage.designer_id), txtBarcode, '');
                        errorFound := true;
                        recItemStage."Record Status" := recItemStage."Record Status"::Error;
                        recItemStage1."Error date" := Today;
                        recItemStage.Modify();
                    end;
                end;
            until recItemStage.Next() = 0;

        //For errors 13-02-23
        /*recItemStage.Reset();
        recItemStage.SetRange("Record Status", recItemStage."Record Status"::Error);
        recItemStage.SetRange("Error date", Today - 2, Today);
        recItemStage.SetRange("RTV Created", false);
        if recItemStage.Find('-') then
            repeat
                Clear(txtBarcode);
                if StrLen(recItemStage.bar_code) > 20 then
                    txtBarcode := CopyStr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)
                else
                    txtBarcode := recItemStage.bar_code;

                if not recItemStage.Is_Outward then begin
                    if CreateItem(recItemStage) then begin
                        Flag := true;
                        if recItem.get(txtBarcode) then begin
                            if not CU_Functions.UpdateGSTFields(recItem) then begin
                                cuFunctions.CreateErrorLog(1, '', recItemStage."Entry No.", format(recItemStage.designer_id), txtBarcode, '');
                                recItemStage1.Get(recItemStage."Entry No.");
                                recItemStage1."Record Status" := recItemStage."Record Status"::Error;
                                recItemStage1."Error date" := Today;
                                recItemStage1.Modify();
                                if recItem.get(txtBarcode) then
                                    recItem.Delete();//deletion in case GST related values are not assigned 250123
                            end;
                        end;
                        recItemStage."Record Status" := recItemStage."Record Status"::Created;
                        recItemStage.Modify();
                        DeleteErrorLogs_Item(recItemStage);//160223
                        // if recItem.get(txtBarcode) then
                        //     recErrorLog.Reset();
                        // recErrorLog.SetRange(Item_code, recItem."No.");
                        // if recErrorLog.FindSet() then
                        //     recErrorLog.Delete();
                    end else begin
                        cuFunctions.CreateErrorLog(1, '', recItemStage."Entry No.", format(recItemStage.designer_id), txtBarcode, '');
                        recItemStage."Record Status" := recItemStage."Record Status"::Error;
                        recItemStage."Error date" := Today;
                        recItemStage.Modify();
                    end;
                    // if not CreateItem(recItemStage) then
                    //     CaptureError_itemCreation(recItemStage);
                end else begin//RTV creation for Is_Outward items in staging 020223 CITS_RS

                    if CreateRTVforIsoutwardItems(recItemStage) then begin
                        recItemStage."RTV Created" := true;
                        recItemStage."Record Status" := recItemStage."Record Status"::Updated;
                        recItemStage."RTV Created" := true;
                        recItemStage.Modify();
                        // DeleteErrorLogs_Item(recItemStage);//160223
                    end else begin
                        cuFunctions.CreateErrorLog(1, '', recItemStage."Entry No.", format(recItemStage.designer_id), txtBarcode, '');
                        recItemStage."Record Status" := recItemStage."Record Status"::Error;
                        recItemStage1."Error date" := Today;
                        recItemStage.Modify();
                    end;
                end;
            until recItemStage.Next() = 0;*/

        if Flag = true then
            Message('Item created successfully');
    end;

    [TryFunction]
    procedure CreateRTVforIsoutwardItems(recItemS: Record Aza_Item)
    var
        // recPurchaseHeader: Record 38;
        recPurchaseHeader_new: Record 38;
        recPurchaseLine: Record 39;
        recLocation: Record 14;
        CU_Functions: Codeunit Functions;
        intFCLocation: Integer;
        recItem: Record 27;
        txtBarcode: text;
    begin
        Clear(txtBarcode);
        if StrLen(recItemS.bar_code) > 20 then
            txtBarcode := CopyStr(recItemS.bar_code, StrLen(recItemS.bar_code) - 20 + 1)
        else
            txtBarcode := recItemS.bar_code;

        if recItemS.fc_location = '' then Error('FC Location is blank, Return order cannot be created for item %1', txtBarcode);
        if not Evaluate(intFCLocation, recItemS.fc_location) then Error('Value %1 cannot be evaluated into FC Location', recItemS.fc_location);
        recLocation.Reset();
        recLocation.SetRange("fc_location ID", intFCLocation);
        if not recLocation.FindFirst() then
            Error('FC Location %1 not found when creating return order for Item %2', recItemS.fc_location, txtBarcode);
        recItem.get(txtBarcode);
        recPurchaseHeader_new.Init();
        recPurchaseHeader_new."Document Type" := recPurchaseHeader_new."Document Type"::"Return Order";
        recPurchaseHeader_new."No." := '';
        recPurchaseHeader_new.Validate("Buy-from Vendor No.", recItemS.designer_id);
        recPurchaseHeader_new.Validate("Location Code", recLocation.Code);
        recPurchaseHeader_new.Validate("Order Date", Today);
        recPurchaseHeader_new.Validate("Posting Date", Today);
        recPurchaseHeader_new.Validate("Vendor Invoice No.", CopyStr('RTV' + '_' + recItemS.designer_code + '_' + txtBarcode, 1, 80));
        recPurchaseHeader_new.Validate("Vendor Cr. Memo No.", CopyStr('RTV' + '_' + recItemS.designer_code + '_' + txtBarcode, 1, 80));
        recPurchaseHeader_new.Validate("Vendor Order No.", CopyStr('RTV' + '_' + recItemS.designer_code + '_' + txtBarcode, 1, 80));
        recPurchaseHeader_new."PO Reference No" := CopyStr('RTV' + '_' + recItemS.designer_code + '_' + txtBarcode, 1, 80);
        recPurchaseHeader_new.Validate("PO No.", recItem."PO No.");//Flow PO No. in Return Order
        recPurchaseHeader_new.Insert(True);
        // recPurchaseHeader_new.Modify(true);
        // CU_Functions.CreatePurchaseReturnOrderHeader(recPurchaseHeader,recPurchaseHeader_new);
        CU_Functions.CreatePurchaseReturnOrderLine_RTV(recPurchaseLine, recPurchaseHeader_new, recItemS);
    end;

    /*procedure CaptureError_itemCreation(recItemStage: Record Aza_Item)
    var
        recItemError: Record ErrorCapture;
        txtBarcode: text;
    begin
        Clear(txtBarcode);
        if StrLen(recItemStage.bar_code) > 20 then
            txtBarcode := CopyStr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)
        else
            txtBarcode := recItemStage.bar_code;

        recItemError.Init();
        if recItemError.findlast then
            recItemError."Sr. No" += 1
        else
            recItemError."Sr. No" := 1;
        recItemError.Item_code := txtBarcode;
        recItemError."Error DateTime" := CurrentDateTime();
        recItemError."Error Remarks" := copystr(GetLastErrorText(), 1, 1000);
        recItemError."Process Type" := recItemError."Process Type"::"Item Creation";
        recItemError.Insert();
    end;*/



    var
        myInt: Integer;
        ColorVar: Code[20];
        ColorVar2: Code[20];

        glVendorCreated: Boolean;

        cuFunctions: Codeunit Functions;
}