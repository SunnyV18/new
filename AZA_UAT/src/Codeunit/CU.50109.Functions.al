codeunit 50109 Functions
{
    trigger OnRun()
    begin

    end;

    procedure MarkAllAsCustomerOrder(Rec: Record 99008980)
    var
        cuPosFunctions: Codeunit "LSC Pos Functions";
        errCode: Code[30];
        errtext: text;
        recPosLine: Record 99008981;
        recPosLine1: Record 99008981;
        recPosLineTmp: Record 99008981 temporary;
        POSTransLineCU: Codeunit "LSC POS Trans. Lines";
        pErrorCode: Code[20];
        pErrorText: Text;
    begin

        recPosLine.Reset();
        recPosLine.SetRange("Receipt No.", Rec."Receipt No.");
        recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
        recPosLine.SetFilter("Entry Type", '%1|%2', recPosLine."Entry Type"::Item, recPosLine."Entry Type"::IncomeExpense);
        //recPosLine.SetFilter("Line No.", '<>%1', POSTransLineCU.GetCurrentLineNo());
        if recPosLine.Find('-') then
            repeat
                recPosLine1.Get(recPosLine."Receipt No.", recPosLine."Line No.");
                cuPosFunctions.MarkLine(recPosLine1);
                cuPosFunctions.SetCustomerOrder(Rec, recPosLine1, pErrorCode, pErrorText);

            /* recPosLineTmp := recPosLine1;
            recPosLineTmp.Insert();
            cuPosFunctions.SetCustomerOrder(Rec, recPosLineTmp, errCode, errtext); */
            until recPosLine.Next() = 0;
    end;

    procedure CallSNSWCF(phoneNum: Code[15]; recPosHeader: Record 99008980; ErrorMsg: Text): Boolean
    var
        headers: HttpHeaders;
        httpreqMessage: HttpRequestMessage;
        client: httpclient;
        // JsonTextWriter:DotNet JsonTextWriter;
        respone: HttpResponseMessage;
        jobject: jsonobject;
        GetAccessTokenNo: text;
        content: HttpContent;
        responsetxt: text;
        HttpWebRequestMgt: codeunit "Http Web Request Mgt.";
        tempblob2: Codeunit "Temp Blob";
        ReqBodyOutStream: OutStream;
        reqhttpHeader: HttpHeaders;
        reshttpheader: HttpHeaders;
        ReqBodyInStream: InStream;
        content1: HttpContent;
        recSalesEn: Record 99001473;
        intOTP: Integer;
        CULoy: Codeunit "Loyalty API";
        recOTPTable: Record OTPEntries;
        JsonAsText: text;
        recHeader: Record 99008980;
    begin
        content.Clear();
        reshttpheader.Clear();
        reqhttpHeader.Clear();
        content.WriteFrom(JsonAsText);
        intOTP := Random(999999);

        /*recHeader.Get(recPosHeader."Receipt No.");
        recHeader."Phone OTP" := format(intOTP);
        recHeader.Modify(true);
        Commit();*/

        recOTPTable.Init();
        if recOTPTable.FindLast() then
            recOTPTable."Entry No." += 1
        else
            recOTPTable."Entry No." := 1;
        recOTPTable."Receipt No." := recPosHeader."Receipt No.";
        recOTPTable.OTP := format(intOTP);
        recOTPTable.Insert();
        Commit();

        httpreqMessage.SetRequestUri('http://localhost:9045/Service1.svc/SendSMS?phoneNumber=+91' + phoneNum + '&message=Your AZA verification OTP is ' + Format(intOTP) + '&accessKey="testkey"&secretKey="testkey2"');
        content.GetHeaders(reqhttpHeader);
        content.GetHeaders(reqhttpHeader);
        httpreqMessage.GetHeaders(reshttpheader);
        // reshttpheader.Remove('content-type');
        // reshttpheader.Add('accept', 'application/json');
        httpreqMessage.GetHeaders(reshttpheader);
        // httpreqMessage.Content(content);
        httpreqMessage.Method := 'POST';

        // client.DefaultRequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
        // client.DefaultRequestHeaders.Add('User-Agent', 'Dynamics D365');
        // client.DefaultRequestHeaders.Add('accept', 'application/json');
        if not client.Send(httpreqMessage, respone) then begin
            //Error('Error occurred while sending request to API');//KKS Removed Hard Error
            ErrorMsg := 'Error occurred while sending request to API';
            exit(false)
        end;

        if not respone.IsSuccessStatusCode then begin
            //Error('Web service returned error %1 %2', respone.HttpStatusCode, respone.ReasonPhrase);
            ErrorMsg := StrSubstNo('Web service returned error %1 %2', respone.HttpStatusCode, respone.ReasonPhrase);
            exit(false)
        end;

        content1 := respone.Content();
        content1.ReadAs(responsetxt);
        // Message(responsetxt);
        exit(true);

        // jobject.ReadFrom(responsetxt);
        // Message('Response from Stock Reduce API %1', CULoy.getresponsetext(jobject, 'message'));
    end;


    procedure UploadInvoicePDFtoS3Bucket(recSIHeader: Record "Sales Invoice Header")
    var
        headers: HttpHeaders;
        httpreqMessage: HttpRequestMessage;
        client: httpclient;
        // JsonTextWriter:DotNet JsonTextWriter;
        docAttach: Record "Document Attachment";
        salesCommentline: Record "Sales Comment Line";
        docAttach1: Record "Document Attachment";
        respone: HttpResponseMessage;
        jobject: jsonobject;
        GetAccessTokenNo: text;
        filePath: text;
        content: HttpContent;
        responsetxt: text;
        HttpWebRequestMgt: codeunit "Http Web Request Mgt.";
        tempblob2: Codeunit "Temp Blob";
        ReqBodyOutStream: OutStream;
        reqhttpHeader: HttpHeaders;
        reshttpheader: HttpHeaders;
        ReqBodyInStream: InStream;
        content1: HttpContent;
        recSalesEn: Record 99001473;
        intOTP: Integer;
        CULoy: Codeunit "Loyalty API";
        pgSalesInvoice: Page "Posted Sales Invoice";
        recOTPTable: Record OTPEntries;
        JsonAsText: text;
        RecordLink1: Record "Record Link";
        recHeader: Record 99008980;
        intLineNum: Integer;
        retailSetup: Record "LSC Retail Setup";
        fileName: Text;
    begin
        retailSetup.Get();
        httpreqMessage.SetRequestUri('http://localhost:9046/Service1.svc/S3Upload?localFilePath=' + retailSetup."Sales Invoice Directory" + recSIHeader."No." + '.pdf' + '&bucketName=' + retailSetup."S3 Bucket Name" +
         '&subDirectoryInBucket=&fileNameInS3=' + recSIHeader."No.");
        content.GetHeaders(reqhttpHeader);
        content.GetHeaders(reqhttpHeader);
        httpreqMessage.GetHeaders(reshttpheader);
        // reshttpheader.Remove('content-type');
        // reshttpheader.Add('accept', 'application/json');
        httpreqMessage.GetHeaders(reshttpheader);
        // httpreqMessage.Content(content);
        httpreqMessage.Method := 'POST';
        if not client.Send(httpreqMessage, respone) then
            Error('Error occurred while sending request to API');
        if not respone.IsSuccessStatusCode then begin
            Error('Web service returned error %1 %2', respone.HttpStatusCode, respone.ReasonPhrase);
        end;
        content1 := respone.Content();
        content1.ReadAs(responsetxt);
        responsetxt := DelChr(responsetxt, '=', '\');
        responsetxt := DelChr(responsetxt, '=', '"');
        if respone.HttpStatusCode = 200 then begin

            // docAttach.Init();            
            // docAttach1.Reset();
            // docAttach1.SetRange("No.",recSIHeader."No.");
            // if docAttach1.FindLast() then
            //  docAttach.ID +=1
            //  else
            //  docAttach.ID :=1;
            // docAttach."No." := recSIHeader."No.";
            // docAttach."File Type" := docAttach."File Type"::Other;
            salesCommentline.Reset();
            salesCommentline.SetRange("Document Type", salesCommentline."Document Type"::Invoice);
            salesCommentline.SetRange("No.", recSIHeader."No.");
            if not salesCommentline.FindFirst() then
                intLineNum := 1
            else
                intLineNum += 1;


            Message(responsetxt);

            // salesCommentline.Init();
            // salesCommentline."Document Type" := salesCommentline."Document Type"::Invoice;
            // salesCommentline."No." := recSIHeader."No.";
            // salesCommentline."Document Line No." := intLineNum;
            // salesCommentline."Line No." := intLineNum;
            // salesCommentline.Date := Today;
            // salesCommentline.Code := copystr(recSIHeader."No.", 1, 10);
            // salesCommentline.Comment := responsetxt;
            // salesCommentline.Insert(true);


            RecordLink1.Init();
            if RecordLink1.FindLast() then
                RecordLink1."Link ID" += 1
            else
                //RecordLink1.TransferFields(RecordLink);
                RecordLink1."Link ID" := 1;
            RecordLink1."Record ID" := recSIHeader.RecordId;
            RecordLink1.URL1 := responsetxt;
            RecordLink1.Description := StrSubstNo('Sales Invoice %1, AWS S3 attachment', recSIHeader."No.");
            RecordLink1.Type := RecordLink1.Type::Link;
            RecordLink1.Created := CurrentDateTime;
            RecordLink1."User ID" := UserId;
            RecordLink1.Insert();



            CallS3ReferenceAzaAPI(recSIHeader, responsetxt)
            // // Message(GetLastErrorText());
            // // Error(GetLastErrorText());
        end;
    end;


    [TryFunction]
    procedure CallS3ReferenceAzaAPI(recSIHeader: Record "Sales Invoice Header"; s3URIText: Text)
    var
        glStream: DotNet StreamWriter;
        glHTTPRequest: DotNet HttpWebRequest;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        gluriObj: DotNet Uri;
        glReader: dotnet StreamReader;
        glresponse: DotNet HttpWebResponse;
        responsetxt: Text;
        JsonString: Text;
        JsonWriter: DotNet JsonTextWriter;
        JsonObj: DotNet JObject;
        recPosLine: Record 99008981;
        JArray: JsonArray;
        cuFunctions: Codeunit Functions;
        recItem: Record 27;
        recSalesInvoiceLine: Record "Sales Invoice Line";
        JObject: JsonObject;
        recRetailSetup: Record "LSC Retail Setup";
        intPONumber: Integer;
        intInvoiceNumber: Integer;
        TransSalesEntry: Record 99001473;
        TaxTransactionValue: Record "Tax Transaction Value";
        Locations: Record Location;
        FcID: Integer;
        taxableValue: Decimal;
        TaxAmount: Decimal;
        TotalAmount: Decimal;
        intOrderID: Integer;
    begin
        recRetailSetup.Get();
        CLEAR(glHTTPRequest);
        servicepointmanager.SecurityProtocol := securityprotocol.Tls12;
        // gluriObj := gluriObj.Uri('https://devapi.azaonline.in/api/v1/account/inventory/updatestock');
        gluriObj := gluriObj.Uri(recRetailSetup."Invoice Reference API");
        glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
        glHTTPRequest.Timeout(10000);
        glHTTPRequest.Method := 'POST';
        glHTTPRequest.ContentType := 'application/json; charset=utf-8';
        glHTTPRequest.Headers.Add('x-ls-token', recRetailSetup."API Token");
        glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());


        JsonObj := JsonObj.JObject();
        JsonWriter := JsonObj.CreateWriter();


        // if not Evaluate(intInvoiceNumber, recSIHeader."No.") then Error('Value %1  for Invoice No. cannot be evaluated to integer', recSIHeader."No.");
        // JsonWriter.WriteValue(intInvoiceNumber);
        JsonWriter.WritePropertyName('invoice_number');

        JsonWriter.WriteValue(recSIHeader."No.");

        JsonWriter.WritePropertyName('invoice_file_url');
        JsonWriter.WriteValue(s3URIText);

        JsonWriter.WritePropertyName('details');
        JsonWriter.WriteStartArray();


        recSalesInvoiceLine.Reset();
        recSalesInvoiceLine.SetRange("Document No.", recSIHeader."No.");
        recSalesInvoiceLine.SetRange(Type, recSalesInvoiceLine.Type::Item);
        recSalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
        if recSalesInvoiceLine.Find('-') then
            repeat
                JsonWriter.WriteStartObject();
                recItem.Get(recSalesInvoiceLine."No.");
                JsonWriter.WritePropertyName('po_number');
                if recItem."PO No." = '' then
                    JsonWriter.WriteValue(0)
                else begin
                    //   if not Evaluate(intPONumber, recItem."PO No.") then Error('Value %1 for PO NO. cannot be evaluated to integer', recItem."PO No.");
                    //   JsonWriter.WriteValue(intPONumber);//Naveen
                    JsonWriter.WriteValue(recItem."PO No.");//Naveen
                end;

                if Locations.Get(recSalesInvoiceLine."Location Code") then
                    FcID := Locations."fc_location ID";

                TaxTransactionValue.Reset();
                TaxTransactionValue.SetFilter("Tax Record ID", '%1', recSalesInvoiceLine.RecordId);
                TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::COMPONENT);
                TaxTransactionValue.SetRange("Visible on Interface", true);
                TaxTransactionValue.SetFilter(Amount, '<>%1', 0);
                TaxTransactionValue.SetRange("Tax Type", 'GST');
                if TaxTransactionValue.Find('-') then begin
                    if (TaxTransactionValue.GetAttributeColumName() = 'IGST') THEN BEGIN
                        TaxAmount := TaxTransactionValue.Amount;
                    end else begin
                        TaxAmount := (TaxTransactionValue.Amount) * 2;
                    end;
                    taxableValue := recSalesInvoiceLine."Line Amount";
                    TotalAmount := recSalesInvoiceLine."Line Amount" + TaxAmount;
                end;

                JsonWriter.WritePropertyName('aza_code');
                JsonWriter.WriteValue(recItem."No.");

                JsonWriter.WritePropertyName('order_id');
                //JsonWriter.WriteValue(intInvoiceNumber);
                if not Evaluate(intOrderID, recSIHeader."Order No.") then error('Order No %1 cant be evaluated into integer');
                JsonWriter.WriteValue(intOrderID);//Naveen--300623

                JsonWriter.WritePropertyName('order_detail_id');
                JsonWriter.WriteValue(recSalesInvoiceLine."Line No.");
                Message('%1', recSalesInvoiceLine."Line No.");

                JsonWriter.WritePropertyName('date_print');
                JsonWriter.WriteValue(CurrentDateTime);

                JsonWriter.WritePropertyName('shipping_charges');
                JsonWriter.WriteValue(0);//need to discuss

                JsonWriter.WritePropertyName('fc_id');
                JsonWriter.WriteValue(FcID);

                JsonWriter.WritePropertyName('hsn_code');
                JsonWriter.WriteValue(recSalesInvoiceLine."HSN/SAC Code");

                JsonWriter.WritePropertyName('Invoice_value_total');
                JsonWriter.WriteValue(0);

                JsonWriter.WritePropertyName('taxable_value');
                JsonWriter.WriteValue(taxableValue);

                JsonWriter.WritePropertyName('tax_amount');
                JsonWriter.WriteValue(TaxAmount);

                JsonWriter.WritePropertyName('total_amount');
                JsonWriter.WriteValue(TotalAmount);

                JsonWriter.WriteEndObject();

            until recSalesInvoiceLine.Next() = 0;


        JsonWriter.WriteEndArray();
        // glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019
        // Message(responsetxt);            // Message(responsetxt);

        JsonString := JsonObj.ToString();
        glstream.Write(JsonString);
        Message(JsonString);
        glstream.Close();
        glHTTPRequest.Timeout(10000);
        glResponse := glHTTPRequest.GetResponse();
        glHTTPRequest.Timeout(10000);
        glreader := glreader.StreamReader(glResponse.GetResponseStream());
        //  txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019
        IF glResponse.StatusCode = 201 THEN BEGIN
            recSIHeader."PDF Sent" := true;
            recSIHeader.Modify();
            responsetxt := glReader.ReadToEnd();
            // Message(responsetxt);
            Message('Response from Invoice Reference API %1', responsetxt);
        end

    end;


    procedure SetActiveImage1(TableRecordID: RecordId)
    var
        RetailImage: Record "LSC Retail Image";
        RetailImageUtils: Codeunit "LSC Retail Image Utils";
        DisplayOrder: Integer;
        TenantMedia: Record "Tenant Media";
        CurrPage: Page "LSC Retail Image Link Factbox";
        Rec: Record "LSC Retail Image";
    begin
        Clear(TenantMedia);
        case CurrPage.Caption of
            'Store Logo', 'Retail Default Logo':
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::Logo, 0, TenantMedia);
            'QR Code for Direction', 'QR Code for Dining Table':
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::"QR Code", 0, TenantMedia);
            else
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::Image, 1, TenantMedia);
        end;
        if not TenantMedia.Content.HasValue then
            RetailImage.Init();

        Rec.DeleteAll;
        Rec.Init;
        Rec.Insert;
        CurrPage.Update(false);
    end;

    procedure GetRetailUserLoc(): Code[10]
    var
        recRetailUser: Record "LSC Retail User";
    begin
        recRetailUser.Reset();
        recRetailUser.SetRange(ID, UserId);
        if recRetailUser.FindFirst() then
            exit(recRetailUser."Location Code")
    end;

    //[TryFunction]
    procedure UpdateGSTFields(Rec: Record Item; var ErrorMsg: Text): Boolean
    var
        Item: Record 27;
        recFound: Boolean;
        cuItemJnlLine: Codeunit 22;
        GSTMaster: Record "GST Master";
        GSTMaster1: Record "GST Master";
        errorLog: Record ErrorCapture;
        GstGroup: Record "GST Group";
    begin
        /*  Rec.TestField("LSC Division Code");
         Rec.TestField("Item Category Code");
         // Rec.TestField("LSC Retail Product Code");
         Rec.TestField("Unit Cost"); */
        ErrorMsg := '';
        IF (Rec."LSC Division Code" = '') OR (Rec."Item Category Code" = '') OR (Rec."Unit Cost" = 0) then begin
            ErrorMsg := StrSubstNo('Division Code/Item Category/Unit Cost Missinig for Item %1', Rec."No.");
            exit(false);
        end;
        Clear(recFound);
        if Item.Get(Rec."No.") then begin
            if (Item."LSC Retail Product Code" <> '') and (Item."Fabric Type" <> '') then begin//DIPF
                GSTMaster.Reset();
                GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
                GSTMaster.SetRange(GSTMaster."Subcategory 1", Item."Item Category Code");
                GSTMaster.SetRange(GSTMaster."Subcategory 2", Item."LSC Retail Product Code");
                GSTMaster.SetRange(Fabric_Type, Item."Fabric Type");
                GSTMaster.SetFilter("From Amount", '<=%1', Item."Unit Price");
                GSTMaster.SetFilter("To Amount", '>=%1', Item."Unit Price");
                if GSTMaster.FindFirst() then begin
                    // Item.Validate(Item."GST Group Code", GSTMaster."GST Group");
                    // Item.Validate(Item."HSN/SAC Code", GSTMaster."HSN Code");
                    GstGroup.Reset();
                    GstGroup.SetRange(Code, GSTMaster."GST Group");
                    if GstGroup.FindFirst() then begin
                        Item."Taxable Value" := (Item."Unit Price" * 100) / (100 + Gstgroup."GST %");
                    end;
                    GSTMaster1.Reset();
                    GSTMaster1.SetRange(GSTMaster1.Category, Item."LSC Division Code");
                    GSTMaster1.SetRange(GSTMaster1."Subcategory 1", Item."Item Category Code");
                    GSTMaster1.SetRange(GSTMaster1."Subcategory 2", Item."LSC Retail Product Code");
                    GSTMaster1.SetRange(Fabric_Type, Item."Fabric Type");
                    GSTMaster1.SetFilter("From Amount", '<=%1', Item."Taxable Value");
                    GSTMaster1.SetFilter("To Amount", '>=%1', Item."Taxable Value");
                    if GSTMaster1.FindFirst() then begin
                        Item.Validate(Item."GST Group Code", GSTMaster1."GST Group");
                        Item.Validate(Item."HSN/SAC Code", GSTMaster1."HSN Code");
                    end;
                    recFound := true;
                end;
                Item.Validate("GST Credit", Item."GST Credit"::Availment);
                Item.Modify();
            end else
                if (Item."LSC Retail Product Code" <> '') and (Item."Fabric Type" = '') then begin//DIP_
                    GSTMaster.Reset();
                    GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
                    GSTMaster.SetRange(GSTMaster."Subcategory 1", Item."Item Category Code");
                    GSTMaster.SetRange(GSTMaster."Subcategory 2", Item."LSC Retail Product Code");
                    GSTMaster.SetRange(Fabric_Type, '');
                    GSTMaster.SetFilter("From Amount", '<=%1', Item."Unit Price");
                    GSTMaster.SetFilter("To Amount", '>=%1', Item."Unit Price");
                    if GSTMaster.FindFirst() then begin
                        // Item.Validate(Item."GST Group Code", GSTMaster."GST Group");
                        // Item.Validate(Item."HSN/SAC Code", GSTMaster."HSN Code");
                        GstGroup.Reset();
                        GstGroup.SetRange(Code, GSTMaster."GST Group");
                        if GstGroup.FindFirst() then begin
                            Item."Taxable Value" := (Item."Unit Price" * 100) / (100 + Gstgroup."GST %");
                        end;
                        GSTMaster1.Reset();
                        GSTMaster1.SetRange(GSTMaster1.Category, Item."LSC Division Code");
                        GSTMaster1.SetRange(GSTMaster1."Subcategory 1", Item."Item Category Code");
                        GSTMaster1.SetRange(GSTMaster1."Subcategory 2", Item."LSC Retail Product Code");
                        GSTMaster1.SetRange(Fabric_Type, '');//uncomment230823
                        GSTMaster1.SetFilter("From Amount", '<=%1', Item."Taxable Value");
                        GSTMaster1.SetFilter("To Amount", '>=%1', Item."Taxable Value");
                        if GSTMaster1.FindFirst() then begin
                            Item.Validate(Item."GST Group Code", GSTMaster1."GST Group");
                            Item.Validate(Item."HSN/SAC Code", GSTMaster1."HSN Code");
                        end;
                        recFound := true;
                    end;
                    Item.Validate("GST Credit", Item."GST Credit"::Availment);
                    Item.Modify();
                end else
                    if (Item."LSC Retail Product Code" = '') and (Item."Fabric Type" = '') then begin//DI_ _
                        GSTMaster.Reset();
                        GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
                        GSTMaster.SetRange(GSTMaster."Subcategory 1", Item."Item Category Code");
                        GSTMaster.SetRange(GSTMaster."Subcategory 2", '');
                        GSTMaster.SetRange(Fabric_Type, '');
                        GSTMaster.SetFilter("From Amount", '<=%1', Item."Unit Price");
                        GSTMaster.SetFilter("To Amount", '>=%1', Item."Unit Price");
                        if GSTMaster.FindFirst() then begin
                            // Item.Validate(Item."GST Group Code", GSTMaster."GST Group");
                            // Item.Validate(Item."HSN/SAC Code", GSTMaster."HSN Code");
                            GstGroup.Reset();
                            GstGroup.SetRange(Code, GSTMaster."GST Group");
                            if GstGroup.FindFirst() then begin
                                Item."Taxable Value" := (Item."Unit Price" * 100) / (100 + Gstgroup."GST %");
                            end;
                            GSTMaster1.Reset();
                            GSTMaster1.SetRange(GSTMaster1.Category, Item."LSC Division Code");
                            GSTMaster1.SetRange(GSTMaster1."Subcategory 1", Item."Item Category Code");
                            // GSTMaster1.SetRange(GSTMaster1."Subcategory 2", Item."LSC Retail Product Code");////uncomment230823
                            // GSTMaster1.SetRange(Fabric_Type, Item."Fabric Type");//uncomment230823
                            GSTMaster1.SetRange(GSTMaster1."Subcategory 2", '');////uncomment230823
                            GSTMaster1.SetRange(Fabric_Type, '');//uncomment230823
                            GSTMaster1.SetFilter("From Amount", '<=%1', Item."Taxable Value");
                            GSTMaster1.SetFilter("To Amount", '>=%1', Item."Taxable Value");
                            if GSTMaster1.FindFirst() then begin
                                Item.Validate(Item."GST Group Code", GSTMaster1."GST Group");
                                Item.Validate(Item."HSN/SAC Code", GSTMaster1."HSN Code");
                            end;
                            recFound := true;
                        end;
                        Item.Validate("GST Credit", Item."GST Credit"::Availment);
                        Item.Modify();
                    end else
                        if (Item."LSC Retail Product Code" = '') and (Item."Fabric Type" <> '') then begin//DI_P
                            GSTMaster.Reset();
                            GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
                            GSTMaster.SetRange(GSTMaster."Subcategory 1", Item."Item Category Code");
                            GSTMaster.SetRange(Fabric_Type, Item."Fabric Type");
                            GSTMaster.SetRange(GSTMaster."Subcategory 2", '');
                            GSTMaster.SetFilter("From Amount", '<=%1', Item."Unit Price");
                            GSTMaster.SetFilter("To Amount", '>=%1', Item."Unit Price");
                            if GSTMaster.FindFirst() then begin
                                // Item.Validate(Item."GST Group Code", GSTMaster."GST Group");
                                // Item.Validate(Item."HSN/SAC Code", GSTMaster."HSN Code");
                                GstGroup.Reset();
                                GstGroup.SetRange(Code, GSTMaster."GST Group");
                                if GstGroup.FindFirst() then begin
                                    Item."Taxable Value" := (Item."Unit Price" * 100) / (100 + Gstgroup."GST %");
                                end;
                                GSTMaster1.Reset();
                                GSTMaster1.SetRange(GSTMaster1.Category, Item."LSC Division Code");
                                GSTMaster1.SetRange(GSTMaster1."Subcategory 1", Item."Item Category Code");
                                // GSTMaster1.SetRange(GSTMaster1."Subcategory 2", Item."LSC Retail Product Code");//uncomment230823
                                GSTMaster1.SetRange(GSTMaster1."Subcategory 2", '');//uncomment230823
                                GSTMaster1.SetRange(Fabric_Type, Item."Fabric Type");
                                GSTMaster1.SetFilter("From Amount", '<=%1', Item."Taxable Value");
                                GSTMaster1.SetFilter("To Amount", '>=%1', Item."Taxable Value");
                                if GSTMaster1.FindFirst() then begin
                                    Item.Validate(Item."GST Group Code", GSTMaster1."GST Group");
                                    Item.Validate(Item."HSN/SAC Code", GSTMaster1."HSN Code");
                                end;
                                recFound := true;
                            end;
                            Item.Validate("GST Credit", Item."GST Credit"::Availment);
                            Item.Modify();
                        end;
            if not recFound then begin
                //Error('No combination in GST master exists for the Item %1', Rec."No.");  Naveen--30062023
                // errorLog.Init();
                // if errorLog.findlast then
                //     errorLog."Sr. No" += 1
                // else
                //     errorLog."Sr. No" := 1;
                // errorLog.Item_code := Item."No.";
                // errorLog."Process Type" := errorLog."Process Type"::"Item Creation";
                // errorLog."Source Entry No." := GetSourceEntryNum(Item);
                // errorLog.DocumentNum := '';
                // errorLog."Vendor Code" := Item."Designer Code";
                // errorLog."Error Remarks" := StrSubstNo('No combination in GST master exist for the Item %1', Rec."No.");
                // errorLog."Error DateTime" := CurrentDateTime;
                // errorLog.Insert();
            end;
            Exit(true);
        end;
    end;

    procedure CreateErrorLog(processType: Integer; LastError: text; SourceEntryNum: Integer; VendorNum: code[50]; ItemNum: Code[50]; DocumentNum: Code[50])
    var
        recErrorLog: Record ErrorCapture;
    begin
        recErrorLog.Init();
        if recErrorLog.FindLast() then
            recErrorLog."Sr. No" += 1
        else
            recErrorLog."Sr. No" := 1;
        recErrorLog."Process Type" := processType;
        if LastError = '' then
            recErrorLog."Error Remarks" := copystr(GetLastErrorText(), 1, 1000)
        else
            recErrorLog."Error Remarks" := LastError;
        recErrorLog."Error DateTime" := CurrentDateTime;
        if ItemNum = '' then
            recErrorLog.Item_code := ''
        else
            recErrorLog.Item_code := ItemNum;

        if DocumentNum = '' then
            recErrorLog.DocumentNum := ''
        else
            recErrorLog.DocumentNum := DocumentNum;

        if VendorNum <> '' then
            recErrorLog."Vendor Code" := VendorNum
        else
            recErrorLog."Vendor Code" := '';
        recErrorLog."Source Entry No." := SourceEntryNum;
        recErrorLog.Insert();

    end;

    procedure CreateErrorLogSO(LastError: text; SourceEntryNum: Integer; VendorNum: code[50]; ItemNum: Code[50]; DocumentNum: Code[50])
    var
        ErrorLogSO: Record ErrorLogSO;
    begin
        ErrorLogSO.Init();
        if ErrorLogSO.FindLast() then
            ErrorLogSO."Sr. No" += 1
        else
            ErrorLogSO."Sr. No" := 1;
        // ErrorLogSO."Process Type" := processType;
        if LastError = '' then
            ErrorLogSO."Error Remarks" := copystr(GetLastErrorText(), 1, 1000)
        else
            ErrorLogSO."Error Remarks" := LastError;
        ErrorLogSO."Error DateTime" := CurrentDateTime;
        if ItemNum = '' then
            ErrorLogSO.Item_code := ''
        else
            ErrorLogSO.Item_code := ItemNum;

        if DocumentNum = '' then
            ErrorLogSO.DocumentNum := ''
        else
            ErrorLogSO.DocumentNum := DocumentNum;

        if VendorNum <> '' then
            ErrorLogSO."Vendor Code" := VendorNum
        else
            ErrorLogSO."Vendor Code" := '';
        ErrorLogSO."Source Entry No." := SourceEntryNum;
        ErrorLogSO.Insert();

    end;

    procedure CreateErrorLogPO(LastError: text; SourceEntryNum: Integer; VendorNum: code[50]; ItemNum: Code[50]; DocumentNum: Code[50])
    var
        ErrorLogPO: Record ErrorLogPO;
    begin
        ErrorLogPO.Init();
        if ErrorLogPO.FindLast() then
            ErrorLogPO."Sr. No" += 1
        else
            ErrorLogPO."Sr. No" := 1;
        // ErrorLogPO."Process Type" := processType;
        if LastError = '' then
            ErrorLogPO."Error Remarks" := copystr(GetLastErrorText(), 1, 1000)
        else
            ErrorLogPO."Error Remarks" := LastError;
        ErrorLogPO."Error DateTime" := CurrentDateTime;
        if ItemNum = '' then
            ErrorLogPO.Item_code := ''
        else
            ErrorLogPO.Item_code := ItemNum;

        if DocumentNum = '' then
            ErrorLogPO.DocumentNum := ''
        else
            ErrorLogPO.DocumentNum := DocumentNum;

        if VendorNum <> '' then
            ErrorLogPO."Vendor Code" := VendorNum
        else
            ErrorLogPO."Vendor Code" := '';
        ErrorLogPO."Source Entry No." := SourceEntryNum;
        ErrorLogPO.Insert();

    end;

    procedure CreateErrorLogCustVend(processType: Integer; LastError: text; SourceEntryNum: Integer; VendorNum: code[50]; ItemNum: Code[50]; DocumentNum: Code[50])
    var
        recErrorLog: Record ErrorLogCustVend;
    begin
        recErrorLog.Init();
        if recErrorLog.FindLast() then
            recErrorLog."Sr. No" += 1
        else
            recErrorLog."Sr. No" := 1;
        recErrorLog."Process Type" := processType;
        if LastError <> '' then
            recErrorLog."Error Remarks" := LastError
        else
            recErrorLog."Error Remarks" := copystr(GetLastErrorText(), 1, 1000);
        recErrorLog."Error DateTime" := CurrentDateTime;
        if ItemNum = '' then
            recErrorLog.Item_code := ''
        else
            recErrorLog.Item_code := ItemNum;

        if DocumentNum = '' then
            recErrorLog.DocumentNum := ''
        else
            recErrorLog.DocumentNum := DocumentNum;

        if VendorNum <> '' then
            recErrorLog."Vendor Code" := VendorNum
        else
            recErrorLog."Vendor Code" := '';
        recErrorLog."Source Entry No." := SourceEntryNum;
        recErrorLog.Insert();

    end;



    procedure GetSourceEntryNum(recItem: Record 27): Integer
    var
        recItemStage: Record Aza_Item;
    begin
        recItemStage.Reset();
        recItemStage.SetCurrentKey("Entry No.");
        recItemStage.SetFilter(bar_code, recItem."No.");
        if recItemStage.FindLast() then
            exit(recItemStage."Entry No.");

    end;

    procedure FindSalesEntry(TransactionHeader: Record 99001472): Record 99001473
    var
        recSalesEn: Record 99001473;
    begin
        recSalesEn.Reset();
        recSalesEn.SetRange("Store No.", TransactionHeader."Store No.");
        recSalesEn.SetRange("POS Terminal No.", TransactionHeader."POS Terminal No.");
        recSalesEn.SetRange("Transaction No.", TransactionHeader."Transaction No.");
        if recSalesEn.Find('-') then
            exit(recSalesEn);
    end;

    procedure FindFirstItemorPaymLinePosTransLine(PosHeader: Record 99008980; IsItem: Boolean; IsPmt: Boolean; var recPosLine: Record 99008981)
    var
    // recPosLine: Record 99008981;
    begin
        recPosLine.Reset();
        recPosLine.SetRange("Receipt No.", PosHeader."Receipt No.");
        recPosLine.SetRange("Entry Status", recPosLine."Entry Status"::" ");
        if IsItem then
            recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Item)
        else
            if IsPmt then
                recPosLine.SetRange("Entry Type", recPosLine."Entry Type"::Payment);
        if recPosLine.Find('-') then;
        // exit(recPosLine);

    end;

    procedure PostdataAPI(TransHdr: Record "LSC Transaction Header")
    var
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        ResponseHeader: HttpResponseMessage;
        MailContentHeaders: HttpHeaders;
        Content: HttpContent;
        HttpHeadersContent: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        JObject: JsonObject;
        ResponseStream: InStream;
        APICallResponseMessage: Text;
        StatusCode: Text;
        IsSuccessful: Boolean;
        postData: Text;
        SalesLine: Record "Sales Line";
        // TransHdr: Record "LSC Transaction Header";
        recRetailSetup: Record "LSC Retail Setup";
        TransSalesEntry: Record "LSC Trans. Sales Entry";
        JArray: JsonArray;
    begin
        recRetailSetup.Get();
        Clear(postData);
        // if SalesHdr."Document Type" = SalesHdr."Document Type"::"Return Order" then begin
        //     Clear(RequestMessage);
        //     Clear(RequestHeaders);
        //     Clear(Content);
        //     //BODY
        //     SalesLine.Reset();
        //     SalesLine.SetRange("Document Type", SalesHdr."Document Type");
        //     SalesLine.SetRange("Document No.", SalesHdr."No.");
        //     SalesLine.SetRange(Type, SalesLine.Type::Item);
        //     SalesLine.SetRange("No.", '<>%1', '');
        //     if SalesLine.FindFirst() then
        if TransHdr."Entry Status" <> TransHdr."Entry Status"::" " then exit; //CITS_RS 200223
        if TransHdr."Sale Is Return Sale" = true then begin
            TransSalesEntry.Reset();
            TransSalesEntry.SetRange("Transaction No.", TransHdr."Transaction No.");
            TransSalesEntry.SetRange("POS Terminal No.", TransHdr."POS Terminal No.");
            TransSalesEntry.SetRange("Store No.", TransHdr."Store No.");
            // TransSalesEntry.SetRange("Receipt No.", TransHdr."Receipt No.");//redundant
            //TransSalesEntry.SetRange("Item No.", '<>%1', '');
            if TransSalesEntry.FindSet() then
                repeat
                    Clear(JObject);
                    JObject.Add('barcode', TransSalesEntry."Item No.");
                    JObject.Add('order_id', format(TransHdr."Transaction No."));
                    JArray.Add(JObject);
                //postData := StrSubstNo('{"barcode": "%1","order_id": %2}', TransSalesEntry."Item No.", TransHdr."Transaction No.");
                until TransSalesEntry.Next() = 0;
            JArray.WriteTo(postData);
            //postData := '{"barcode": "35495","order_id": 102}';
            Message(postData);
            RequestMessage.GetHeaders(RequestHeaders);
            RequestHeaders.Clear();
            //RequestHeaders.Add('Content-Type', 'application/json');
            //RequestHeaders.Add('Accept', 'application/json');
            // RequestHeaders.Add('x-ls-token', '9906d219373f6c8f80acb5bf55d16a60');
            RequestHeaders.Add('x-ls-token', recRetailSetup."API Token");//CITS_RS
            Content.WriteFrom(postData);
            // //GET HEADERS
            Content.GetHeaders(HttpHeadersContent);
            HttpHeadersContent.Clear();
            HttpHeadersContent.Add('Content-Type', 'application/json');
            //POST METHOD
            RequestMessage.Content := Content;
            // RequestMessage.SetRequestUri('https://devapi.azaonline.in/api/v1/account/inventory/restock');
            RequestMessage.SetRequestUri(recRetailSetup."Sales Return API");//CITS_RS
            RequestMessage.Method := 'POST';

            Clear(APICallResponseMessage);
            Clear(TempBlob);
            TempBlob.CreateInStream(ResponseStream);
            IsSuccessful := Client.Send(RequestMessage, ResponseMessage);
            // if not IsSuccessful then Error('An API call with the provided header has failed.');
            // if not ResponseMessage.IsSuccessStatusCode() then begin
            //     StatusCode := Format(ResponseMessage.HttpStatusCode()) + ' - ' + ResponseMessage.ReasonPhrase;
            //     Error('The request has failed with status code ' + StatusCode);
            // end;

            // if not ResponseMessage.Content().ReadAs(ResponseStream) then Error('The response message cannot be processed.');
            // if not JObject.ReadFrom(ResponseStream) then error('Cannot read JSON response.');

            // //API response
            // JObject.WriteTo(APICallResponseMessage);
            // Message(APICallResponseMessage);

            if IsSuccessful then
                Message('Data posted to AZA Online successfully')
            else
                Message('')
        end
    end;

    [TryFunction]
    procedure CallReduceStockAPI(TransactionHeader_p: Record "LSC Transaction Header")
    // procedure CallReduceStockAPI(POSTransaction: Record 99008980)
    var
        glStream: DotNet StreamWriter;
        glHTTPRequest: DotNet HttpWebRequest;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        gluriObj: DotNet Uri;
        glReader: dotnet StreamReader;
        glresponse: DotNet HttpWebResponse;
        responsetxt: Text;
        JsonString: Text;
        recSalesEn: Record 99001473;
        recLocation: Record Location;
        JsonWriter: DotNet JsonTextWriter;
        recPosLine: Record 99008981;
        JArray: JsonArray;
        cuFunctions: Codeunit Functions;
        JObject: JsonObject;
        recRetailSetup: Record "LSC Retail Setup";
        TransSalesEntry: Record 99001473;
    begin
        // cuFunctions.FindFirstItemorPaymLinePosTransLine(POSTransaction,true,false,recPosLine);
        recRetailSetup.Get();
        if TransactionHeader_p."Entry Status" <> TransactionHeader_p."Entry Status"::" " then exit;
        if TransactionHeader_p.Payment < 0 then exit;
        if TransactionHeader_p."Sale Is Return Sale" then exit;

        CLEAR(glHTTPRequest);
        servicepointmanager.SecurityProtocol := securityprotocol.Tls12;
        // gluriObj := gluriObj.Uri('https://devapi.azaonline.in/api/v1/account/inventory/updatestock');
        gluriObj := gluriObj.Uri(recRetailSetup."Sales API");
        glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);

        glHTTPRequest.Timeout(10000);
        glHTTPRequest.Method := 'POST';
        glHTTPRequest.ContentType := 'application/json; charset=utf-8';
        glHTTPRequest.Headers.Add('x-ls-token', recRetailSetup."API Token");
        glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());

        TransSalesEntry.Reset();
        TransSalesEntry.SetRange("Transaction No.", TransactionHeader_p."Transaction No.");
        TransSalesEntry.SetRange("POS Terminal No.", TransactionHeader_p."POS Terminal No.");
        TransSalesEntry.SetRange("Store No.", TransactionHeader_p."Store No.");
        if TransSalesEntry.FindSet() then
            repeat
                Clear(JObject);
                JObject.Add('barcode', TransSalesEntry."Item No.");
                JObject.Add('order_id', format(TransactionHeader_p."Transaction No."));
                JArray.Add(JObject);
            until TransSalesEntry.Next() = 0;

        JArray.WriteTo(JsonString);
        // Message(JsonString);
        glstream.Write(JsonString);
        glstream.Close();
        glHTTPRequest.Timeout(10000);
        glResponse := glHTTPRequest.GetResponse();
        glHTTPRequest.Timeout(10000);
        glreader := glreader.StreamReader(glResponse.GetResponseStream());
        //  txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019
        IF glResponse.StatusCode = 200 THEN BEGIN
            responsetxt := glReader.ReadToEnd();
            // Message(responsetxt);
            Message('Response from Stock Reduce API %1', responsetxt);
        end
    end;

    procedure SendMailNotification_CustomerOrder(customerOrderHeader: Record "LSC Customer Order Header")
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        whseEntr: Record "Warehouse Entry";
        SMTP: Codeunit "SMTP Mail";
        Store: Record "LSC Store";
        Store2: Record "LSC Store";
        VarSender: Text[80];
        cuFunctions: Codeunit Functions;
        retailUser: Record "LSC Retail User";
        VarRecipient: List of [Text];
        BUserId: Code[60];
        BDateT: DateTime;
        userName: Text;
        VarStoreNo: Code[20];
        txtStoreName: Text;
        recStore: Record 99001470;
        collectLocName: Text;
    begin

        recStore.Get(customerOrderHeader."Created at Store");
        if recStore.Name <> '' then
            txtStoreName := recStore.Name
        else
            txtStoreName := recStore."No.";
        retailUser.Reset();
        retailUser.SetRange(ID, UserId);
        if retailUser.FindFirst() then begin
            if retailUser.Name <> '' then
                userName := retailUser.Name
            else
                userName := retailUser.ID;
        end;
        recStore.Get(GetRetailUserLoc());
        if recStore.Name <> '' then
            collectLocName := recStore.Name
        else
            collectLocName := recStore."No.";

        SMTPMailSetup.Get();
        VarSender := SMTPMailSetup."User ID";


        if Store2.Get(customerOrderHeader."Created at Store") then;
        VarRecipient.Add(Store2."Email id");

        ///>>>>>>
        SMTPMailSetup.GET;
        SMTP.CreateMessage('CCIT', VarSender, VarRecipient, 'Customer Order Collection Notification-AZA Admin', '');//CITS_RS 180223
        SMTP.AppendBody('Dear Sir/Madam');
        SMTP.AppendBody('<br><Br>');
        SMTP.AppendBody(StrSubstNo('Customer Order %1 created at store %2 is being', customerOrderHeader."Document ID", txtStoreName));
        SMTP.AppendBody('<br>');
        SMTP.AppendBody(StrSubstNo('collected at %1 store, by user %2', collectLocName, userName));
        SMTP.AppendBody('<br><Br>');
        SMTP.AppendBody('AZA Admin');
        // SMTP.AppendBody('<br><Br>');
        if not SMTP.Send then
            Message(GetLastErrorText());
        // MESSAGE('Email Sent Successfully');

    end;

    [TryFunction]
    procedure ManualBlockBridgeInventory(recItem: Record Item)
    // procedure CallReduceStockAPI(POSTransaction: Record 99008980)
    var
        glStream: DotNet StreamWriter;
        glHTTPRequest: DotNet HttpWebRequest;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        gluriObj: DotNet Uri;
        glReader: dotnet StreamReader;
        glresponse: DotNet HttpWebResponse;
        responsetxt: Text;
        JsonString: Text;
        recSalesEn: Record 99001473;
        recLocation: Record Location;
        intOrderNum: Integer;
        JsonWriter: DotNet JsonTextWriter;
        cuPosTrans: Codeunit 99001570;
        recPosLine: Record 99008981;
        JArray: JsonArray;
        cuFunctions: Codeunit Functions;
        JObject: JsonObject;
        recRetailSetup: Record "LSC Retail Setup";
        TransSalesEntry: Record 99001473;
    begin
        // cuFunctions.FindFirstItemorPaymLinePosTransLine(POSTransaction,true,false,recPosLine);
        recRetailSetup.Get();
        CLEAR(glHTTPRequest);
        servicepointmanager.SecurityProtocol := securityprotocol.Tls12;
        gluriObj := gluriObj.Uri(recRetailSetup."Sales API");
        glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
        glHTTPRequest.Timeout(10000);
        glHTTPRequest.Method := 'POST';
        glHTTPRequest.ContentType := 'application/json; charset=utf-8';
        glHTTPRequest.Headers.Add('x-ls-token', recRetailSetup."API Token");
        glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());
        Clear(JObject);
        JObject.Add('barcode', recItem."No.");
        // if not Evaluate(intOrderNum, recItem."PO No.") then Error('Value %1 cannot be evaluated to Order ID', recItem."PO No.");
        JObject.Add('order_id', recItem."PO No.");
        JArray.Add(JObject);
        JArray.WriteTo(JsonString);
        Message(JsonString);
        glstream.Write(JsonString);
        glstream.Close();
        glHTTPRequest.Timeout(10000);
        glResponse := glHTTPRequest.GetResponse();
        glHTTPRequest.Timeout(10000);
        glreader := glreader.StreamReader(glResponse.GetResponseStream());
        //  txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019
        IF glResponse.StatusCode = 200 THEN BEGIN
            responsetxt := glReader.ReadToEnd();
            Message(responsetxt);
            //Message('Response from Stock Reduce API %1', responsetxt);
        end
    end;

    [TryFunction]
    procedure ManualUnBlockBridgeInventory(recItem: Record Item)
    // procedure CallReduceStockAPI(POSTransaction: Record 99008980)
    var
        glStream: DotNet StreamWriter;
        glHTTPRequest: DotNet HttpWebRequest;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        gluriObj: DotNet Uri;
        glReader: dotnet StreamReader;
        glresponse: DotNet HttpWebResponse;
        responsetxt: Text;
        JsonString: Text;
        recSalesEn: Record 99001473;
        recLocation: Record Location;
        JsonWriter: DotNet JsonTextWriter;
        recPosLine: Record 99008981;
        JArray: JsonArray;
        cuFunctions: Codeunit Functions;
        JObject: JsonObject;
        recRetailSetup: Record "LSC Retail Setup";
        intOrderNum: Integer;
        TransSalesEntry: Record 99001473;
    begin
        // cuFunctions.FindFirstItemorPaymLinePosTransLine(POSTransaction,true,false,recPosLine);
        recRetailSetup.Get();
        CLEAR(glHTTPRequest);
        servicepointmanager.SecurityProtocol := securityprotocol.Tls12;
        gluriObj := gluriObj.Uri(recRetailSetup."Sales Return API");
        glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
        glHTTPRequest.Timeout(10000);
        glHTTPRequest.Method := 'POST';
        glHTTPRequest.ContentType := 'application/json; charset=utf-8';
        glHTTPRequest.Headers.Add('x-ls-token', recRetailSetup."API Token");
        glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());
        Clear(JObject);
        JObject.Add('barcode', recItem."No.");
        // if not Evaluate(intOrderNum, recItem."PO No.") then Error('Value %1 cannot be evaluated to Order ID', recItem."PO No.");
        JObject.Add('order_id', recItem."PO No.");
        JArray.Add(JObject);
        JArray.WriteTo(JsonString);
        Message(JsonString);
        glstream.Write(JsonString);
        glstream.Close();
        glHTTPRequest.Timeout(10000);
        glResponse := glHTTPRequest.GetResponse();
        glHTTPRequest.Timeout(10000);
        glreader := glreader.StreamReader(glResponse.GetResponseStream());
        //  txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019
        IF glResponse.StatusCode = 200 THEN BEGIN
            responsetxt := glReader.ReadToEnd();
            Message(responsetxt);
            Message('Response from Stock Reduce API %1', responsetxt);
        end
    end;


    procedure IsAdvanceTransaction(recHeader: Record 99001472): Boolean
    var
        recSalesEntry: Record 99001473;
        recItem: Record 27;
        cuFunctions: Codeunit Functions;
    begin
        recSalesEntry.Reset();
        recSalesEntry := cuFunctions.FindSalesEntry(recHeader);
        recItem.get(recSalesEntry."Item No.");
        if recItem."Is Advance" then
            exit(true)
        else
            exit(false);

    end;

    //>>Added by KJ T002 120922 Start
    procedure CreatePurchaseReturnOrderHeader(PurchaseHeader: Record "Purchase Header"; var PurchaseHeader_new: Record "Purchase Header")
    var
    begin
        PurchaseHeader_new.Init();
        PurchaseHeader_new."Document Type" := PurchaseHeader_new."Document Type"::"Return Order";
        PurchaseHeader_new."Location Code" := PurchaseHeader."Location Code";//CITS_RS avoiding location error when initializing the no series 
        PurchaseHeader_new."No." := '';
        PurchaseHeader_new.Insert(True);
        PurchaseHeader_new.Validate("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PurchaseHeader_new.Validate("Order Date", PurchaseHeader."Posting Date");
        PurchaseHeader_new.Validate("Document Date", PurchaseHeader."Document Date");
        PurchaseHeader_new.Validate("Posting Date", PurchaseHeader."Posting Date");
        PurchaseHeader_new."PO Reference No" := PurchaseHeader."No.";
        PurchaseHeader_new.Validate("PO No.", PurchaseHeader."No.");//Flow PO No. in Return Order
        PurchaseHeader_new.Validate(PoNoForRTV, PurchaseHeader."No.");
        PurchaseHeader_new."Location Code" := PurchaseHeader."Location Code";
        PurchaseHeader_new.Modify(true);
    end;//<<Added by KJ T002 120922 End

    procedure CreatePurchaseReturnOrderLine_RTV(PurchaseLine: Record "Purchase Line"; PurchaseHeader_new: Record "Purchase Header"; recItemStage: Record Aza_Item)
    var
        PurchaseLine_new: Record "Purchase Line";
        recItem: Record Item;
        PurchaseLine_l: Record "Purchase Line";
        LineNo: Integer;
    begin
        PurchaseLine_l.Reset();
        PurchaseLine_l.SetRange("Document Type", PurchaseLine_l."Document Type"::"Return Order");
        PurchaseLine_l.SetRange("Document No.", PurchaseHeader_new."No.");
        IF PurchaseLine_l.FindLast() then
            LineNo += 10000
        Else
            LineNo := 10000;

        PurchaseLine_new.Init();
        PurchaseLine_new.validate("Document Type", PurchaseHeader_new."Document Type");
        PurchaseLine_new.Validate("Document No.", PurchaseHeader_new."No.");
        PurchaseLine_new.Validate("Order Date", PurchaseHeader_new."Order Date");
        // PurchaseLine_new.Validate("Posting Date", PurchaseHeader_new."Posting Date");
        PurchaseLine_new.Validate("Line No.", LineNo);
        PurchaseLine_new.Validate(Type, PurchaseLine_new.Type::Item);
        PurchaseLine_new.validate("No.", copystr(recItemStage.bar_code, 1, 20));
        PurchaseLine_new.Validate("Unit of Measure", 'PCS');
        if not recItem.get(recItemStage.bar_code) then Error('Item %1 not found in the master', recItemStage.bar_code);
        PurchaseLine_new.Validate(Quantity, 1);//will always be 1(to be discussed for multiple quantities)
        PurchaseLine_new.Validate("Location Code", PurchaseHeader_new."Location Code");
        PurchaseLine_new.Validate("GST Group Type", PurchaseLine_new."GST Group Type"::Goods);
        // recItem."GST Group Code");
        // PurchaseLine_new.Validate("HSN/SAC Code", recItem."HSN/SAC Code");
        //PurchaseLine_new.Validate("GST Credit", recItem."GST Credit");
        PurchaseLine_new.Validate("Unit Price (LCY)", recItem."Unit Price");
        PurchaseLine_new.Validate("Direct Unit Cost", recItem."Unit Cost");
        PurchaseLine_new.Validate("GST Group Code", '');
        // PurchaseLine_new.Validate("Amount Including VAT");
        if PurchaseLine_new.Insert(true) then
            Message('RTV %1 for damaged qty created', PurchaseLine_new."Document No.");
    end;

    [TryFunction]
    procedure PostShipmentRTV(PurchaseHeader: Record "Purchase Header")
    var
        cuPurchPost: Codeunit "Purch.-Post";
        pLine: Record "Purchase Line";
    begin
        PurchaseHeader.validate(Ship, true);
        if PurchaseHeader."Vendor Order No." = '' then
            PurchaseHeader."Vendor Order No." := PurchaseHeader."No.";
        if PurchaseHeader."Vendor Invoice No." = '' then
            PurchaseHeader."Vendor Invoice No." := PurchaseHeader."No.";
        PurchaseHeader.Modify();
        // pLine.Reset();
        // pLine.SetRange("Document Type", PurchaseHeader."Document Type");
        // pline.SetRange("Document No.", PurchaseHeader."No.");
        // if pLine.FindFirst() then
        //     pLine.Validate(Quantity, 1);
        // pLine.Modify();
        Commit();

        Clear(cuPurchPost);
        cuPurchPost.Run(PurchaseHeader);

    end;

    //<<Added by KJ T002 120922 Start
    procedure CreatePurchaseReturnOrderLine(PurchaseLine: Record "Purchase Line"; PurchaseHeader_new: Record "Purchase Header")
    var
        PurchaseLine_new: Record "Purchase Line";
        PurchaseLine_l: Record "Purchase Line";
        LineNo: Integer;
        recitem: Record 27;
        recOrigLine: Record 39;
    begin
        PurchaseLine_l.Reset();
        PurchaseLine_l.SetRange("Document Type", PurchaseLine_l."Document Type"::"Return Order");
        PurchaseLine_l.SetRange("Document No.", PurchaseHeader_new."No.");
        IF PurchaseLine_l.FindLast() then
            LineNo += 10000
        Else
            LineNo := 10000;

        PurchaseLine_new.Init();
        PurchaseLine_new.validate("Document Type", PurchaseHeader_new."Document Type");
        PurchaseLine_new.Validate("Document No.", PurchaseHeader_new."No.");
        PurchaseLine_new.Validate("Line No.", LineNo);
        PurchaseLine_new.Validate(Type, PurchaseLine_new.Type::Item);
        recitem.get(PurchaseLine."No.");
        PurchaseLine_new.validate("No.", PurchaseLine."No.");
        PurchaseLine_new."Location Code" := PurchaseLine."Location Code";
        PurchaseLine_new.Validate(Quantity, 1);//will always be 1
        PurchaseLine_new.Validate("GST Group Code", '');//as1206
        PurchaseLine_new.Validate("GST Credit", PurchaseLine_new."GST Credit"::" ");
        PurchaseLine_new.validate("Unit Cost (LCY)", recitem."Unit Cost");
        PurchaseLine_new.validate("Direct Unit Cost", recitem."Unit Cost");
        PurchaseLine_new.validate("Unit Cost", recitem."Unit Cost");
        //PurchaseLine_new.Validate(Quantity, 1);
        if PurchaseLine_new.Insert() then
            Message('RTV %1 for damaged qty created', PurchaseLine_new."Document No.");

        PurchaseLine_new.Validate(Quantity, 1);
        PurchaseLine_new.modify();
    end;//<<Added by KJ T002 120922 End

    procedure GetTaxComponentsInJson(TaxRecordID: RecordId; var JObject: JsonObject)
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
        DocNo: Code[20];
        Rec: Record 99008981;
        LineNo: Integer;
        ScriptDatatypeMgmt: Codeunit "Script Data Type Mgmt.";
        taxFound: Boolean;//CITS_RS
    begin
        //  if not GuiAllowed then
        //     exit;
        clear(taxFound);

        Clear(DocNo);
        Clear(LineNo);
        // TaxTransactionValue.SetCurrentKey("Tax Record ID", "Tax Type");//CITS_RS
        // TaxTransactionValue.SetAscending("Tax Record ID", false);//CITS_RS
        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        if TaxTransactionValue.FindSet() then
            // if TaxTransactionValue.Find('+') then//COmmented CITS_RS
            repeat
                Clear(ComponentJObject);
                ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
                ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
                ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
                ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));

                IF (TaxTransactionValue.GetAttributeColumName() <> 'GST Base Amount') AND (TaxTransactionValue.GetAttributeColumName() <> 'Total TDS Amount') THEN BEGIN
                    IF (TaxTransactionValue.GetAttributeColumName() = 'CGST') OR (TaxTransactionValue.GetAttributeColumName() = 'SGST') then begin
                        rec."LSCIN GST Amount" += ComponentAmt;//ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER);
                        // Rec."LSCIN GST Percentage" += TaxTransactionValue.Percent;
                        taxFound := true;
                    end else //CITS_RS
                        if (TaxTransactionValue.GetAttributeColumName() = 'IGST') THEN BEGIN
                            Rec."LSCIN GST Amount" := ComponentAmt;
                            // rec."GST Percentage" := TaxTransactionValue.Percent;
                            taxFound := true;//CITS_RS
                            // Rec."Amount to Vendor" += Rec."GST Amount" + Rec.GetLineAmountInclVAT();
                            // Modify(false);//Commnted CITS_RS 110922
                            //CurrPage.Update(false);
                        END;
                END;
                // else //CITS_RS 100922 TDS Value added in Purchase Line
                // Message(TaxTransactionValue.GetAttributeColumName());
                // Message('%1', ComponentAmt);
                // if (TaxTransactionValue.GetAttributeColumName() = 'TDS') then begin
                //     //Message('TDS %1', ComponentAmt);
                //     IF ComponentAmt <> 0 THEN BEGIN
                //         Rec."TDS Amount" := ComponentAmt;
                //         taxFound := true;//CITS_RS
                //     END;
                //     // Modify(false);//Commnted CITS_RS 110922
                // end;
                //END;

                //CITS_RS++
                // if taxFound = true then begin
                //     rec."Amount to Vendor" := rec."Amount Including VAT" + rec."GST Amount" - rec."TDS Amount";//CITS_RS 110922
                //     Modify(false);//CITS_RS 110922
                // end;
                //CITS_RS--

                JArray.Add(ComponentJObject);
            until TaxTransactionValue.Next() = 0;

        JObject.Add('TaxInformation', JArray);
    end;


    procedure ValidateGSTMasterforLineAmount(Var PurchaseLine: Record "Purchase Line")
    var
        myInt: Integer;
        GSTMaster: Record "GST Master";
        Item: Record Item;
        recPurchHeader: Record "Purchase Header";
        recVendor: Record 23;
    begin
        //CITS_RS 300123 ++ Not inserting GST related values in case of unregistered vendors
        if recPurchHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.") then begin
            if recVendor.get(recPurchHeader."Buy-from Vendor No.") then;
            if recVendor."GST Vendor Type" = recVendor."GST Vendor Type"::Unregistered then exit;
        end;
        //CITS_RS --
        if Item.Get(PurchaseLine."No.") then begin
            GSTMaster.Reset();
            GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
            GSTMaster.SetRange(GSTMaster."Subcategory 1", Item."Item Category Code");
            GSTMaster.SetRange(GSTMaster."Subcategory 2", Item."LSC Retail Product Code");
            GSTMaster.SetFilter("From Amount", '<=%1', PurchaseLine."Line Amount");
            GSTMaster.SetFilter("To Amount", '>=%1', PurchaseLine."Line Amount");
            if GSTMaster.FindFirst() then begin
                PurchaseLine.Validate(PurchaseLine."GST Group Code", GSTMaster."GST Group");
                PurchaseLine.Validate(PurchaseLine."HSN/SAC Code", GSTMaster."HSN Code");
            end else begin
                Item.TestField("GST Group Code");
                Item.TestField("HSN/SAC Code");
                PurchaseLine.Validate(PurchaseLine."GST Group Code", Item."GST Group Code");
                PurchaseLine.Validate(PurchaseLine."HSN/SAC Code", Item."HSN/SAC Code");
            end;
        end;
        PurchaseLine.Validate("GST Credit", PurchaseLine."GST Credit"::Availment);
    end;

    [TryFunction]
    procedure StorePUTapi(AZAcode: Code[20])
    var
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        MailContentHeaders: HttpHeaders;
        MailContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        JObject: JsonObject;
        ResponseStream: InStream;
        APICallResponseMessage: Text;
        recRetailSetup: Record "LSC Retail Setup";
        StatusCode: Text;
        IsSuccessful: Boolean;
        RequestUrl: Text;
        Content: HttpContent;
        HttpHeadersContent: HttpHeaders;
        postData: Text;
        Jsobject: JsonObject;
    begin
        Jsobject.Add('action_id', 1);
        Jsobject.WriteTo(postData);

        clear(APICallResponseMessage);
        Clear(RequestMessage);
        Clear(RequestHeaders);
        Clear(ResponseMessage);
        recRetailSetup.get;
        //RequestUrl += recRetailSetup."Store PUT API" + '?id=' + Format(AZAcode);
        RequestUrl += recRetailSetup."Store PUT API" + Format(AZAcode);
        // RequestUrl := 'https://stageapi.azaonline.in/api/v1/account/add_ci_action_log?id=' + Format(AZAcode);
        //RequestUrl := 'http://teststageapi.azaonline.in/swagger-ui/api-docs?id=' + Format(AZAcode);
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('x-ls-token', '9906d219373f6c8f80acb5bf55d16a60');

        Content.WriteFrom(postData);
        //GET HEADERS
        Content.GetHeaders(HttpHeadersContent);
        HttpHeadersContent.Clear();
        HttpHeadersContent.Remove('Content-Type');
        HttpHeadersContent.Add('Content-Type', 'application/json');
        RequestMessage.Content := Content;
        //<<
        RequestMessage.SetRequestUri(RequestUrl);
        RequestMessage.Method('PUT');

        Clear(TempBlob);
        TempBlob.CreateInStream(ResponseStream);
        IsSuccessful := Client.Send(RequestMessage, ResponseMessage);

        if not IsSuccessful then error('An API call with the provided header has failed.');// else Message('PO Api Calling Successful');block by Naveen

        if not ResponseMessage.IsSuccessStatusCode() then begin
            StatusCode := Format(ResponseMessage.HttpStatusCode()) + ' - ' + ResponseMessage.ReasonPhrase;
            // Error('The request has failed with status code ' + StatusCode);
        end;

        if not ResponseMessage.Content().ReadAs(ResponseStream) then
            Error('The response message cannot be processed.');
        ResponseStream.Read(APICallResponseMessage);
        // Message('Response:' + APICallResponseMessage);
    end;


    [TryFunction]
    procedure StorePUTapiforReturnorder(AZAcode: Code[20]; BOOl: Boolean)
    var
        TempBlob: Codeunit "Temp Blob";
        recRetailSetup: record "LSC Retail Setup";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        MailContentHeaders: HttpHeaders;
        MailContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        JObject: JsonObject;
        ResponseStream: InStream;
        APICallResponseMessage: Text;
        StatusCode: Text;
        IsSuccessful: Boolean;
        RequestUrl: Text;
        Content: HttpContent;
        HttpHeadersContent: HttpHeaders;
        postData: Text;
        Jsobject: JsonObject;
    begin
        clear(APICallResponseMessage);
        Clear(RequestMessage);
        Clear(RequestHeaders);
        Clear(ResponseMessage);
        if BOOl then begin
            Jsobject.Add('action_id', 1);
            Jsobject.WriteTo(postData);
        end else begin
            Jsobject.Add('action_id', 13);
            Jsobject.WriteTo(postData);
        end;
        recRetailSetup.get;
        //RequestUrl += recRetailSetup."Store PUT API" + '?id=' + Format(AZAcode);
        RequestUrl += recRetailSetup."Store PUT API" + Format(AZAcode);
        // RequestUrl := 'https://stageapi.azaonline.in/api/v1/account/add_ci_action_log?id=' + Format(AZAcode);
        // RequestUrl := 'https://stageapi.azaonline.in/api/v1/account/add_ci_action_log?id=' + Format(AZAcode);
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('x-ls-token', '9906d219373f6c8f80acb5bf55d16a60');
        //>>
        // postData := '{"action_id": 13}';
        Content.WriteFrom(postData);
        //GET HEADERS
        Content.GetHeaders(HttpHeadersContent);
        HttpHeadersContent.Clear();
        HttpHeadersContent.Remove('Content-Type');
        HttpHeadersContent.Add('Content-Type', 'application/json');
        RequestMessage.Content := Content;
        //<<
        RequestMessage.SetRequestUri(RequestUrl);
        RequestMessage.Method('PUT');

        Clear(TempBlob);
        TempBlob.CreateInStream(ResponseStream);
        IsSuccessful := Client.Send(RequestMessage, ResponseMessage);

        if not IsSuccessful then error('An API call with the provided header has failed.');// else Message('RTV Api Calling Successful');

        if not ResponseMessage.IsSuccessStatusCode() then begin
            StatusCode := Format(ResponseMessage.HttpStatusCode()) + ' - ' + ResponseMessage.ReasonPhrase;
            // Error('The request has failed with status code ' + StatusCode);
        end;

        if not ResponseMessage.Content().ReadAs(ResponseStream) then
            Error('The response message cannot be processed.');
        ResponseStream.Read(APICallResponseMessage);
        // Message('Response:' + APICallResponseMessage);
    end;

}


