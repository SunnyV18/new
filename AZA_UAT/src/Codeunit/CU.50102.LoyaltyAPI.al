codeunit 50102 "Loyalty API"
{
    trigger OnRun()
    begin

    end;

    // procedure OnBeforeRunCommand(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var POSMenuLine: Record "LSC POS Menu Line"; var isHandled: Boolean)
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeRunCommand', '', false, false)]
    procedure GetLoy(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var POSMenuLine: Record "LSC POS Menu Line"; var isHandled: Boolean)
    var
    begin
        if POSMenuLine.Command = 'GETLOY' then
            GetLoyPoints('9560969196')
        else
            if POSMenuLine.Command = 'ADDLOY' then
                AddLoyPoints(12, '9560969196', '122115', 512, '2022-08-24');

    end;

    // OnBeforeInsertPayment_TenderKeyExecutedEx(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var TenderTypeCode: Code[10]; var TenderAmountText: Text)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeInsertPayment_TenderKeyExecutedEx', '', false, false)]
    procedure DedeuctLoy(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var TenderTypeCode: Code[10]; var TenderAmountText: Text)
    var
    begin

    end;

    procedure DeductLoyaltyPoints(parmOrderID: Integer; parmPhoneNum: Code[10]; parmLoyPoints: Decimal): Text
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
        recRetailSetup: Record "LSC Retail Setup";
        ReqBodyInStream: InStream;
        content1: HttpContent;
        JsonAsText: text;
    begin
        recRetailSetup.Get();
        content.Clear();
        reshttpheader.Clear();
        reqhttpHeader.Clear();

        // content.WriteFrom(CreateAuthPayload());
        jobject.Add('order_id', parmOrderID);
        jobject.Add('phone_number', parmPhoneNum);
        jobject.Add('loyalty_point', parmLoyPoints);
        jobject.WriteTo(JsonAsText);
        Message(JsonAsText);

        content.WriteFrom(JsonAsText);
        httpreqMessage.SetRequestUri(recRetailSetup."Loyalty Points Deduct");
        // httpreqMessage.SetRequestUri('https://devapi.azaonline.in/api/v1/account/loyalty-points/update');

        content.GetHeaders(reqhttpHeader);
        reqhttpHeader.Remove('content-type');
        reqhttpHeader.Add('Content-Type', 'application/json; charset=utf-8');
        content.GetHeaders(reqhttpHeader);

        httpreqMessage.GetHeaders(reshttpheader);
        // reshttpheader.Remove('content-type');
        reshttpheader.Add('accept', 'application/json');
        httpreqMessage.GetHeaders(reshttpheader);
        httpreqMessage.Content(content);
        httpreqMessage.Method := 'PUT';

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
        Message('Deduct point response is %1', responsetxt);
        jobject.ReadFrom(responsetxt);
        // Message(getresponsetext(jobject, 'message'));
        exit(getresponsetext(jobject, 'message'));

    end;

    procedure AddLoyPoints(parmOrderID: Integer; parmPhoneNum: Code[10]; parmTransactionID: Code[20];
        parmTransactionAmount: Decimal; parmTransDate: Text[20]): Text
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
        JsonAsText: text;
    begin
        recRetailSetup.Get();
        content.Clear();
        reshttpheader.Clear();
        reqhttpHeader.Clear();

        // content.WriteFrom(CreateAuthPayload());
        jobject.Add('order_id', parmOrderID);
        jobject.Add('phone_number', parmPhoneNum);
        jobject.Add('transaction_id', parmTransactionID);
        jobject.Add('transaction_amount', parmTransactionAmount);
        jobject.Add('transaction_date', parmTransDate);
        jobject.WriteTo(JsonAsText);
        Message(JsonAsText);

        content.WriteFrom(JsonAsText);
        httpreqMessage.SetRequestUri(recRetailSetup."Loyalty Points Add");
        // httpreqMessage.SetRequestUri('https://devapi.azaonline.in/api/v1/account/loyalty-points/add');

        content.GetHeaders(reqhttpHeader);
        reqhttpHeader.Remove('content-type');
        reqhttpHeader.Add('Content-Type', 'application/json; charset=utf-8');
        content.GetHeaders(reqhttpHeader);

        httpreqMessage.GetHeaders(reshttpheader);
        // reshttpheader.Remove('content-type');
        reshttpheader.Add('accept', 'application/json');
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
        Message('Add points response is %1', responsetxt);
        jobject.ReadFrom(responsetxt);
        // Message(getresponsetext(jobject, 'message'));
        exit(getresponsetext(jobject, 'message'));

    end;

    procedure GetLoyPoints(parmPhoneNum: Code[10]): Text
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
        JsonAsText: text;
    begin
        recRetailSetup.Get();
        content.Clear();
        reshttpheader.Clear();
        reqhttpHeader.Clear();

        content.WriteFrom(JsonAsText);
        // httpreqMessage.SetRequestUri('https://devapi.azaonline.in/api/v1/account/loyalty-points/view?phone_number=' + parmPhoneNum);
        httpreqMessage.SetRequestUri(recRetailSetup."Loyalty Points Get" + parmPhoneNum);
        content.GetHeaders(reqhttpHeader);
        reqhttpHeader.Remove('content-type');
        reqhttpHeader.Add('Content-Type', 'application/json; charset=utf-8');
        content.GetHeaders(reqhttpHeader);

        httpreqMessage.GetHeaders(reshttpheader);
        // reshttpheader.Remove('content-type');
        reshttpheader.Add('accept', 'application/json');
        httpreqMessage.GetHeaders(reshttpheader);
        // httpreqMessage.Content(content);
        httpreqMessage.Method := 'GET';

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
        Message('Get points response is %1', responsetxt);
        jobject.ReadFrom(responsetxt);
        // Message(getresponsetext(jobject, 'message'));
        exit(getresponsetext(jobject, 'message'));

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



    procedure GeLoyaltyPoints()
    var
    begin

    end;

    var
        myInt: Integer;
        CU_PosTrans: Codeunit "LSC POS Transaction";

        recRetailSetup: Record "LSC Retail Setup";
        CU_PosTransEvents: Codeunit "LSC POS Transaction Events";
        CU_PosTransFun: Codeunit "LSC POS Transaction Functions";

        cuTransferReceipt: Codeunit "TransferOrder-Post Receipt";
        cuTransferShip: Codeunit "TransferOrder-Post Shipment";

        CU_StatementPost: Codeunit "LSC Statement-Post";
        CU_GSTPost: Codeunit "LSCIN Statement GST Post";

        // AsserCU:Codeunit Assert;

        CU_PostUtil: Codeunit "LSC POS Post Utility";
}