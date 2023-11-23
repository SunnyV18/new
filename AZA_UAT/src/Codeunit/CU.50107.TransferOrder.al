codeunit 50107 TransferOrder
{
    TableNo = 472;
    trigger OnRun()
    begin
        if Rec."Parameter String" = 'CreateTransOrder' then
            ProcessTransferOrders();
    end;


    procedure ProcessTransferOrders()
    var
        cuFunctions: Codeunit Functions;
        TransOrderStaging: Record TransferOrderStage;
        errorlog: Record ErrorCapture;
    begin

        TransOrderStaging.Reset();
        TransOrderStaging.SetFilter(transfer_from_fc, '<>%1', '');
        TransOrderStaging.SetFilter(transfer_to_fc, '<>%1', '');
        TransOrderStaging.SetRange(Record_Status, TransOrderStaging.Record_Status::" ");
        if TransOrderStaging.Find('-') then
            repeat
                if not CreateTransferOrder(TransOrderStaging) then begin
                    cuFunctions.CreateErrorLog(13, '', TransOrderStaging."Entry No.", '', TransOrderStaging.barcode, format(TransOrderStaging.order_id));
                    TransOrderStaging.Record_Status := TransOrderStaging.Record_Status::Error;
                    TransOrderStaging."Error Date" := Today;
                    TransOrderStaging.Modify();
                end else begin
                    TransOrderStaging.Record_Status := TransOrderStaging.Record_Status::Created;
                    TransOrderStaging.Modify();
                end;
            until TransOrderStaging.Next() = 0;

        //For error records
        /*TransOrderStaging.Reset();
        TransOrderStaging.SetFilter(transfer_from_fc, '<>%1', '');
        TransOrderStaging.SetFilter(transfer_to_fc, '<>%1', '');
        TransOrderStaging.SetRange(Record_Status, TransOrderStaging.Record_Status::Error);
        TransOrderStaging.SetRange("Error Date", Today - 2, Today);
        if TransOrderStaging.Find('-') then
            repeat
                if not CreateTransferOrder(TransOrderStaging) then begin
                    cuFunctions.CreateErrorLog(13, '', TransOrderStaging."Entry No.", '', TransOrderStaging.barcode, format(TransOrderStaging.order_id));
                    TransOrderStaging.Record_Status := TransOrderStaging.Record_Status::Error;
                    TransOrderStaging."Error Date" := Today;
                    TransOrderStaging.Modify();

                end else begin
                    TransOrderStaging.Record_Status := TransOrderStaging.Record_Status::Created;
                    TransOrderStaging.Modify();
                    errorlog.Reset();
                    errorlog.SetRange("Source Entry No.", TransOrderStaging."Entry No.");
                    errorlog.SetRange(Item_code, TransOrderStaging.barcode);
                    if errorlog.FindSet() then
                        repeat
                            errorlog.Delete();
                        until errorlog.Next() = 0;

                end;
            until TransOrderStaging.Next() = 0;*/

        if boolCreated then
            Message('Transfer Order Created');
    end;

    [TryFunction]
    procedure CreateTransferOrder(TransOrderStaging: Record TransferOrderStage)
    var
        int: Integer;
        // TransOrderStaging: Record TransferOrderStage;
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        Line_No: Integer;
        TFO_No: Code[20];
        PostingDate: Date;
        StatusVar: Option Open,Released;
        FCLocation: Integer;
        recItem: Record 27;
        TabLocation: Record Location;
        FCLocationto: Integer;
        GSTMaster: Record "GST Master";
    begin
        Clear(boolCreated);
        // TransOrderStaging.Reset();
        // TransOrderStaging.SetFilter(transfer_from_fc, '<>%1', '');
        // TransOrderStaging.SetFilter(transfer_to_fc, '<>%1', '');
        // TransOrderStaging.SetRange(Record_Status, TransOrderStaging.Record_Status::" ");
        // if TransOrderStaging.FindSet() then
        //     repeat
        TFO_No := Format(TransOrderStaging.transfer_order_id);
        TransferHeader.Init();
        TransferHeader.Validate("No.", TFO_No);
        // TransferHeader.Validate("Transfer-from Code", Format(TransOrderStaging.transfer_from_fc));
        // TransferHeader.Validate("Transfer-to Code", Format(TransOrderStaging.transfer_to_fc));
        Evaluate(FCLocation, TransOrderStaging.transfer_from_fc);
        TabLocation.Reset();
        TabLocation.SetRange("fc_location ID", FCLocation);
        if TabLocation.FindFirst() then
            TransferHeader.Validate("Transfer-from Code", TabLocation.Code);
        Evaluate(FCLocationto, TransOrderStaging.transfer_to_fc);
        TabLocation.Reset();
        TabLocation.SetRange("fc_location ID", FCLocationto);
        if TabLocation.FindFirst() then
            TransferHeader.Validate("Transfer-to Code", TabLocation.Code);

        Evaluate(PostingDate, Format(TransOrderStaging.posting_date));
        TransferHeader.Validate("Posting Date", PostingDate);
        Evaluate(StatusVar, TransOrderStaging.transfer_order_status);
        TransferHeader.Validate(Status, StatusVar);
        TransferHeader."Shipment Date" := Today;
        TransferHeader."Receipt Date" := Today;
        TransferHeader."In-Transit Code" := 'OWN LOG.';
        if TransferHeader.Insert() then begin
            // TransOrderStaging.Record_Status := TransOrderStaging.Record_Status::Created;
            // TransOrderStaging.Modify();
        end;
        Line_No := 10000;
        TransferLine.Init();
        TransferLine."Document No." := TransferHeader."No.";
        TransferLine."Line No." := Line_No;
        if not recItem.Get(TransOrderStaging.barcode) then Error('Item %1 not found in the master', TransOrderStaging.barcode);
        TransferLine.Validate("Item No.", TransOrderStaging.barcode);
        TransferLine.Validate("Unit of Measure", recItem."Base Unit of Measure");
        TransferLine.Validate("Unit of Measure Code", recItem."Base Unit of Measure");
        TransferLine.Validate("Gen. Prod. Posting Group", recItem."Gen. Prod. Posting Group");
        TransferLine.Validate("Inventory Posting Group", recItem."Inventory Posting Group");

        TransferLine.Validate("In-Transit Code", 'OWN LOG.');
        GSTMaster.Reset();
        GSTMaster.SetRange(GSTMaster.Category, recItem."LSC Division Code");
        GSTMaster.SetRange(GSTMaster."Subcategory 1", recItem."Item Category Code");
        GSTMaster.SetRange(GSTMaster."Subcategory 2", recItem."LSC Retail Product Code");
        GSTMaster.SetRange(Fabric_Type, recItem."Fabric Type");
        GSTMaster.SetFilter("From Amount", '<=%1', recItem."Unit Cost");
        GSTMaster.SetFilter("To Amount", '>=%1', recItem."Unit Cost");
        if GSTMaster.FindFirst() then begin
            TransferLine.Validate("GST Group Code", GSTMaster."GST Group");
            TransferLine.Validate("HSN/SAC Code", GSTMaster."HSN Code");
        end;
        TransferLine.validate(Quantity, 1);
        if TransferLine.Insert() then
            boolCreated := true;
        // until TransOrderStaging.Next() = 0;
    end;


    [TryFunction]
    procedure PostTransferOrderAPI(JsonAsText: Text)
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
        cuTransferOrder: Codeunit TransferOrder;
        reshttpheader: HttpHeaders;
        ReqBodyInStream: InStream;
        content1: HttpContent;
        recRetailSetup: Record "LSC Retail Setup";
    begin
        recRetailSetup.Get();
        content.Clear();
        reshttpheader.Clear();
        reqhttpHeader.Clear();
        // // content.WriteFrom(CreateAuthPayload());
        // jobject.Add('order_id', parmOrderID);
        // jobject.Add('phone_number', parmPhoneNum);
        // jobject.Add('transaction_id', parmTransactionID);
        // jobject.Add('transaction_amount', parmTransactionAmount);
        // jobject.Add('transaction_date', parmTransDate);
        // jobject.WriteTo(JsonAsText);
        // Message(JsonAsText);
        content.WriteFrom(JsonAsText);
        httpreqMessage.SetRequestUri(recRetailSetup."Transfer Order API");

        content.GetHeaders(reqhttpHeader);
        reqhttpHeader.Remove('content-type');
        reqhttpHeader.Add('Content-Type', 'application/json; charset=utf-8');
        content.GetHeaders(reqhttpHeader);

        httpreqMessage.GetHeaders(reshttpheader);
        // reshttpheader.Remove('content-type');
        reshttpheader.Add('accept', 'application/json');
        reshttpheader.Add('x-ls-token', recRetailSetup."API Token");
        httpreqMessage.GetHeaders(reshttpheader);
        httpreqMessage.Content(content);
        httpreqMessage.Method := 'POST';

        // client.DefaultRequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
        // client.DefaultRequestHeaders.Add('User-Agent', 'Dynamics D365');
        // client.DefaultRequestHeaders.Add('accept', 'application/json');
        if not client.Send(httpreqMessage, respone) then
            Error('Error occurred while sending request to API');

        if not respone.IsSuccessStatusCode then begin
            Error('Web service returned error %1 %2', respone.HttpStatusCode, respone.ReasonPhrase);
        end;

        content1 := respone.Content();
        content1.ReadAs(responsetxt);
        Message('Transfer Order response is %1', responsetxt);
        jobject.ReadFrom(responsetxt);
        // Message(getresponsetext(jobject, 'message'));
        getresponsetext(jobject, 'message');

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptLine', '', false, false)]
    // [EventSubscriber(ObjectType::Page, Page::"Transfer Order", 'OnAfterActionEvent', 'Post', false, false)]
    // procedure CallStockUpdateAPI_Transfer(var Rec:Record "Transfer Header")
    procedure CallStockUpdateAPI_Transfer(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; TransShptHeader: Record "Transfer Shipment Header")
    var
        glStream: DotNet StreamWriter;
        glHTTPRequest: DotNet HttpWebRequest;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        gluriObj: DotNet Uri;
        glReader: dotnet StreamReader;
        glresponse: DotNet HttpWebResponse;
        responsetxt: Text;
        intOrderID: Code[50];
        JsonString: Text;
        JsonWriter: DotNet JsonTextWriter;
        JArray: JsonArray;
        cuFunctions: Codeunit Functions;
        recTransShipLine: Record "Transfer Shipment Line";
        JObject: JsonObject;
        pgTransferOrder: Page "Transfer Order";
        recRetailSetup: Record "LSC Retail Setup";
        recLocation: Record 14;
        boolCallAPI: Boolean;
        recItem: Record 27;
        recRetailUser: Record "LSC Retail User";
    begin
        recRetailUser.Reset();
        recRetailUser.SetRange(ID, UserId);
        if recRetailUser.FindFirst() then begin
            recLocation.Get(recRetailUser."Location Code");
        end;
        Clear(boolCallAPI);
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
        recTransShipLine.Reset();
        recTransShipLine.SetRange("Document No.", TransShptHeader."No.");
        if recTransShipLine.Find('-') then
            repeat
                if recItem.Get(recTransShipLine."Item No.") then begin
                    if recItem.ItemSaleReserved then
                        if recLocation.Code <> recItem."fc location" then
                            boolCallAPI := true;
                end;

                Clear(JObject);
                JObject.Add('barcode', recTransShipLine."Item No.");
                // Evaluate(intOrderID, recTransShipLine."Document No.");
                JObject.Add('order_id', recTransShipLine."Document No.");
                JArray.Add(JObject);
            until recTransShipLine.Next() = 0;


        if boolCallAPI then begin
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
                // Message(responsetxt);
                Message('Response from Stock Reduce API %1', responsetxt);

            end
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptLine', '', false, false)]
    // procedure CreateTransferOrderPayload(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; TransShptHeader: Record "Transfer Shipment Header")
    // OnAfterTransRcptLineModify(var TransferReceiptLine: Record "Transfer Receipt Line"; TransferLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    // OnAfterInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; TransShptHeader: Record "Transfer Shipment Header")
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransRcptLineModify', '', false, false)]
    procedure CreateTransferOrderPayloadReceipt(var TransferReceiptLine: Record "Transfer Receipt Line"; TransferLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    var
        JsonWriter: DotNet JsonTextWriter;
        JsonObj: DotNet JObject;
        payloadTxt: Text;
        intOrderID: Code[50];//change datatype integer to code 
        cuTransferOrder: Codeunit "TransferOrder-Post Shipment";
        cuTransferOrderReceipt: Codeunit "TransferOrder-Post Receipt";
        recTransferLine: Record "Transfer Line";
        recFromLocation: Record 14;
        cuCustomEvents: Codeunit "Custom Events";
        recTransferReceiptHeader: Record "Transfer Receipt Header";

        recToLocation: Record 14;
    begin
        recTransferReceiptHeader.Get(TransferReceiptLine."Document No.");
        recFromLocation.Get(recTransferReceiptHeader."Transfer-from Code");
        recToLocation.get(recTransferReceiptHeader."Transfer-to Code");

        // recTransferLine.Reset();
        // recTransferLine.SetRange("Document No.", TransShptHeader."No.");
        // if recTransferLine.Find('-') then
        //     repeat
        JsonObj := JsonObj.JObject();
        JsonWriter := JsonObj.CreateWriter();

        JsonWriter.WritePropertyName('from_fc');
        JsonWriter.WriteValue(recFromLocation."fc_location ID");

        JsonWriter.WritePropertyName('to_fc');
        JsonWriter.WriteValue(recToLocation."fc_location ID");

        JsonWriter.WritePropertyName('barcode');
        JsonWriter.WriteValue(TransferReceiptLine."Item No.");

        JsonWriter.WritePropertyName('order_id');
        Evaluate(intOrderID, recTransferReceiptHeader."No.");
        JsonWriter.WriteValue(intOrderID);

        JsonWriter.WritePropertyName('order_detail_id');
        JsonWriter.WriteValue(TransferReceiptLine."Line No.");

        JsonWriter.WritePropertyName('action_id');
        JsonWriter.WriteValue(2);// to be discussed

        payloadTxt := JsonObj.ToString();
        //  Message(payloadTxt);

        if not PostTransferOrderAPI(payloadTxt) then;
        //   Message(GetLastErrorText());
        // until recTransferLine.Next() = 0;
    end;

    procedure getresponsetext(j: JsonObject; Member: text): Text
    var
        result: JsonToken;
    begin

        if j.Get(Member, result) then
            if (result.IsValue()) then
                exit(result.AsValue().AsText())
            else
                EXIT('');
    end;


    var
        myInt: Integer;

        boolCreated: Boolean;
}