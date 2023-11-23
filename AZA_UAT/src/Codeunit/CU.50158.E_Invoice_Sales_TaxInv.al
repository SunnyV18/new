//Line 772 Exp with payment and without payment to be discussed
//Line 1928 to discuss how to map payment of duty..currently hardcoded to no
//Json params to be discussed in export details json
//ShipmentBillNo 
//ShipmentBillDate
//ExitPort 

codeunit 50158 E_Invoice_TaxInv
{
    trigger OnRun()
    begin

    end;

    [TryFunction]
    procedure GenerateIRN_01(recTransactionHeader: Record "LSC Transaction Header")
    var
        txtDecryptedSek: text;
        jsonwriter1: DotNet JsonTextWriter;
        jsonObjectlinq: DotNet JObject;
        eInvoiceJsonHandler: Codeunit "e-Invoice Json Handler";
        encryptedIRNPayload: text;
        finalPayload: text;
        JObject: JsonObject;
        GSTManagement: Codeunit "e-Invoice Management";
        CU_Base64: Codeunit "Base64 Convert";
        base64IRN: text;
        recCustomer: Record 18;
        CurrExRate: Integer;
        AesManaged: DotNet "Cryptography.SymmetricAlgorithm";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        clear(GlobalNULL);
        // IsInvoice := true;
        // JObject.WriteTo(JsonText);
        // Message(JsonText);
        // message(format(SalesHead.FieldNo("Acknowledgement Date")));
        // message(format(SalesHead.FieldNo("Acknowledgement No.")));
        // message(format(SalesHead.FieldNo("QR Code")));
        // message(format(SalesHead.FieldNo("IRN Hash")));
        JsonLObj := JsonLObj.JObject();
        JsonWriter := JsonLObj.CreateWriter;
        DocumentNo := recTransactionHeader."Receipt No.";
        recCustomer.get(recTransactionHeader."Customer No.");
        // if recCustomer."GST Registration Type" <> recCustomer."GST Registration Type"::GSTIN then
        //     ERROR('E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.');

        IF recTransactionHeader."LSCIN GST Customer Type" IN
               [recTransactionHeader."LSCIN GST Customer Type"::Unregistered,
               recTransactionHeader."LSCIN GST Customer Type"::" "] THEN
            ERROR('E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.');

        // IF SalesHead.FIND('-') THEN
        // IF GSTManagement.IsGSTApplicable(SalesHead."No.", 36) THEN BEGIN
        //     IF SalesHead."GST Customer Type" IN
        //         [SalesHead."GST Customer Type"::Unregistered,
        //         SalesHead."GST Customer Type"::" "] THEN
        //         ERROR('E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.');

        // end;
        // IF recTransactionHeader."Currency Factor" <> 0 THEN
        //     CurrExRate := 1 / SalesHead."Currency Factor"
        // ELSE
        CurrExRate := recTransactionHeader."LSCIN Currency Factor";
        // CurrExRate := 1;
        JsonWriter.WritePropertyName('Version');//NIC API Version
        JsonWriter.WriteValue('1.1');//Later to be provided as setup.

        WriteTransDtls(JsonLObj, recTransactionHeader, JsonWriter);
        WriteDocDtls(JsonLObj, recTransactionHeader, JsonWriter);
        WriteSellerDtls(JsonLObj, recTransactionHeader, JsonWriter);
        WriteBuyerDtls(JsonLObj, recTransactionHeader, JsonWriter, gl_BillToPh, gl_BillToEm);
        WriteItemDtls(JsonLObj, recTransactionHeader, JsonWriter, CurrExRate);
        WriteValDtls(JsonLObj, recTransactionHeader, JsonWriter);
        WriteExpDtls(JsonLObj, recTransactionHeader, JsonWriter);

        JsonText := JsonLObj.ToString();
        Message(JsonText);


        Call_IRN_API(JsonText, false, recTransactionHeader, false, false);


        if DocumentNo = '' then
            Error(DocumentNoBlankErr);

    end;


    [TryFunction]
    procedure CancellIRN_01(recTransactionHeader: Record "LSC Transaction Header")
    var
        txtDecryptedSek: text;
        jsonwriter1: DotNet JsonTextWriter;
        jsonObjectlinq: DotNet JObject;
        eInvoiceJsonHandler: Codeunit "e-Invoice Json Handler";
        encryptedIRNPayload: text;
        finalPayload: text;
        JObject: JsonObject;
        GSTManagement: Codeunit "e-Invoice Management";
        CU_Base64: Codeunit "Base64 Convert";
        base64IRN: text;
        recCustomer: Record 18;
        CurrExRate: Integer;
        AesManaged: DotNet "Cryptography.SymmetricAlgorithm";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if recTransactionHeader."IRN Hash" = '' then
            Error('IRN not available for cancellation');

        WriteCancelPayload(recTransactionHeader."IRN Hash");

        JsonText := WriteCancelPayload(recTransactionHeader."IRN Hash");

        Call_IRN_API(JsonText, true, recTransactionHeader, false, false);

        // if DocumentNo = '' then
        //     Error(DocumentNoBlankErr);//Nkp--101023

    end;


    local procedure WriteCancelPayload(IRN: Text): Text
    var
        JCancelPayload: JsonObject;
        JsTExt: Text;
    begin
        //Header : Json Body
        JCancelPayload.Add('irn', irn);
        JCancelPayload.Add('CnlRsn', '1');
        JCancelPayload.Add('CnlRem', 'Wrong');
        JCancelPayload.WriteTo(JsTExt);
        Message(JsTExt);
        exit(JsTExt);

    end;

    /*procedure GenerateAuthToken(RecSalesHeader: Record "Sales Invoice Header"): text;
    var
        JsonWriter: DotNet JsonTextWriter;
        JsonWriter1: DotNet JsonTextWriter;
        plainAppkey: text;
        jsonString: text;
        JsonLinq: DotNet JObject;
        Myfile: File;
        encryptedPayload: text;
        Instream1: InStream;
        encoding: DotNet Encoding;
        GenLedSet: Record "General Ledger Setup";
        keyTxt: text;
        finPayload: text;
        
        JsonLinq1: DotNet JObject;
        encryptedPass: text;
        base64Payload: text;
        rec_GSTRegNos: Record "GST Registration Nos.";
        // pass: label 'Barbeque@123';
        encryptedAppKey: text;
        bytearr: DotNet Array;
        recCustomer: Record Customer;
        GSTRegNos: Record "GST Registration Nos.";
        CU_base64: Codeunit "Base64 Convert";
        recLocation: Record Location;

    begin

        GenLedSet.Get();
        recLocation.Get(RecSalesHeader."Location Code");
        GSTRegNos.Reset();
        GSTRegNos.SetRange(Code, recLocation."GST Registration No.");
        if GSTRegNos.FindFirst() then;
        JsonLinq := JsonLinq.JObject();
        jsonWriter := JsonLinq.CreateWriter();

        // Myfile.OPEN('C:\BBQ Project Extensions\CITS_RS\einv_sandbox1.pem');
        Myfile.OPEN(GenLedSet."GST Public Key Directory Path");
        Myfile.CREATEINSTREAM(Instream1);
        Instream1.READTEXT(keyTxt);

        GSTEncr_Decr := GSTEncr_Decr.RSA_AES();
        // encryptedPass := GSTEncr_Decr.EncryptAsymmetric(pass, keyTxt);//uat
        encryptedPass := GSTEncr_Decr.EncryptAsymmetric(GSTRegNos."E-Invoice Password", keyTxt);//live

        JsonWriter.WritePropertyName('userName');
        JsonWriter.WriteValue(GSTRegNos."E-Invoice UserName");

        JsonWriter.WritePropertyName('password');
        JsonWriter.WriteValue(GSTRegNos."E-Invoice Password");

        plainAppkey := GSTEncr_Decr.RandomString(32, FALSE);

        JsonWriter.WritePropertyName('AppKey');
        // plainAppkey := 'VAVKXCHOHPMPTYEYKYQEKJOKECAVLNVP';
        bytearr := encoding.UTF8.GetBytes(plainAppkey);
        JsonWriter.WriteValue(bytearr);

        JsonWriter.WritePropertyName('ForceRefreshAuthToken');
        JsonWriter.WriteValue('true');

        jsonString := JsonLinq.ToString();
        // MESSAGE(jsonString);

        //Convert to base 64 string first and then encrypt with the GST Public Key then populate the Final Json payload
        base64Payload := CU_base64.ToBase64(jsonString);
        // Message(base64Payload);

        // Message('Key text %1', keyTxt);
        encryptedPayload := GSTEncr_Decr.EncryptAsymmetric(base64Payload, keyTxt);


        JsonLinq1 := JsonLinq1.JObject();
        JsonWriter1 := JsonLinq1.CreateWriter();

        JsonWriter1.WritePropertyName('Data');
        JsonWriter1.WriteValue(encryptedPayload);

        finPayload := JsonLinq1.ToString();
        getAuthfromNIC(finPayload, plainAppkey, RecSalesHeader);
        // Message(finPayload);
        exit(finPayload);
        // exit(jsonString);
    end;

    procedure getAuthfromNIC(JsonString: text; PlainKey: Text; SalesHeader: Record "Sales Invoice Header")
    var
        genledSetup: Record "General Ledger Setup";
        responsetxt: text;

        glStream: DotNet StreamWriter;
        glHTTPRequest: DotNet HttpWebRequest;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        gluriObj: DotNet Uri;
        glReader: dotnet StreamReader;
        glresponse: DotNet HttpWebResponse;
        recGSTREgNos: Record "GST Registration Nos.";
        recLocation: Record Location;
    begin
        genledSetup.GET;
        recLocation.Get(SalesHeader."Location Code");
        recGSTREgNos.Reset();
        recGSTREgNos.SetRange(Code, recLocation."GST Registration No.");
        if recGSTREgNos.FindFirst() then;
        CLEAR(glHTTPRequest);
        servicepointmanager.SecurityProtocol := securityprotocol.Tls12;
        //  gluriObj := gluriObj.Uri('https://einv-apisandbox.nic.in/eivital/v1.03/auth');
        // gluriObj := gluriObj.Uri('https://einv-apisandbox.nic.in/eivital/v1.04/auth');
        gluriObj := gluriObj.Uri(genledSetup."GST Authorization URL");
        glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
        glHTTPRequest.Headers.Add('client_id', recGSTREgNos."E-Invoice Client ID");
        glHTTPRequest.Headers.Add('client_secret', recGSTREgNos."E-Invoice Client Secret");
        glHTTPRequest.Headers.Add('GSTIN', recGSTREgNos.Code);
        // glHTTPRequest.Headers.Add('client_id', recGSTREgNos."E-Invoice Client ID");
        // glHTTPRequest.Headers.Add('client_secret', recGSTREgNos."E-Invoice Client Secret");
        // glHTTPRequest.Headers.Add('GSTIN', recGSTREgNos.Code);
        glHTTPRequest.Timeout(10000);
        glHTTPRequest.Method := 'POST';
        glHTTPRequest.ContentType := 'application/json; charset=utf-8';
        glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());
        glstream.Write(JsonString);
        glstream.Close();
        glHTTPRequest.Timeout(10000);
        glResponse := glHTTPRequest.GetResponse();
        glHTTPRequest.Timeout(10000);
        glreader := glreader.StreamReader(glResponse.GetResponseStream());
        //  txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019
        IF glResponse.StatusCode = 200 THEN BEGIN
            //    encryptedSEK := ParseResponse_Auth(glreader.ReadToEnd,appKey,SIHeader);
            // Myfile.OPEN(genledSetup."GST Public Key Directory Path");
            // Myfile.CREATEINSTREAM(Instream);
            // Instream.READTEXT(keyTxt);
            responsetxt := glReader.ReadToEnd();
            // Message(responsetxt);
            ParseAuthResponse(responsetxt, PlainKey, SalesHeader);


            // Encoding := Encoding.UTF8Encoding();
            // Bytes := Encoding.GetBytes(appKey);

            // BouncyThat1 := BouncyThat1.Class1();
            // decyptSEK := BouncyThat1.DecryptBySymmetricKey(encryptedSEK,Bytes);

            // GSTEnc_Decr := GSTEnc_Decr.RSA_AES();
            // decyptSEK   := GSTEnc_Decr.DecryptBySymmetricKey(encryptedSEK,Bytes);

            /*recAuthData.RESET;
            recAuthData.SETCURRENTKEY("Sr No.");
            recAuthData.SETFILTER(DocumentNum,'=%1',SIHeader."No.");
            IF recAuthData.FINDLAST THEN BEGIN
             recAuthData.DecryptedSEK := decyptSEK;
             recAuthData.MODIFY;
            END;

           glreader.Close();
           glreader.Dispose();

          END ELSE
           IF glResponse.StatusCode <> 200 THEN BEGIN
            MESSAGE(FORMAT(glResponse.StatusCode));
            ERROR(glResponse.StatusDescription);
           END;
        END;
    END;*/

    procedure ParseAuthResponse(TextResponse: text; PlainKey: text; SIHeader: Record "Sales Invoice Header"): text;
    var
        message1: text;
        CurrentObject: text;
        CurrentElement: text;
        ValuePair: text;
        PlainSEK: text;
        FormatChar: label '{}';
        CurrentValue: text;
        txtStatus: text;
        p: Integer;
        x: Integer;
        txtAuthT: text;
        l: Integer;
        txtError: text;
        txtEncSEK: text;
        errPOS: Integer;
        encoding: DotNet Encoding;
        txtExpiry: text;
        bytearr: DotNet Array;
        txtExpireTime: text;
    begin
        // Message(TextResponse);

        CLEAR(message1);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;

        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        // MESSAGE(TextResponse);
        errPOS := STRPOS(TextResponse, '"Status":0');
        IF errPOS > 0 THEN
            ERROR('Error in Auth Token generation : %1', TextResponse);
        //no response

        // CurrentObject := COPYSTR(TextResponse,STRPOS(TextResponse,'{')+1,STRPOS(TextResponse,':'));
        // TextResponse := COPYSTR(TextResponse,STRLEN(CurrentObject)+1);

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);

        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');

                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');

                CASE CurrentElement OF
                    'Status':
                        BEGIN
                            txtStatus := CurrentValue;
                        END;
                    'ErrorDetails':
                        BEGIN
                            txtError := CurrentValue;
                        END;
                    'AuthToken':
                        BEGIN
                            txtAuthT := CurrentValue;
                            // Message('AuthToke %1', txtAuthT);
                        END;
                    'Sek':
                        BEGIN
                            txtEncSEK := CurrentValue;
                            // Message('EncryptedSEK %1', txtEncSEK);
                        END;
                    'TokenExpiry':
                        BEGIN
                            txtExpiry := CurrentValue;
                        END;
                END;
            END;
            x := x + 1;
        END;

        EXIT(txtEncSEK);
    end;

    procedure Call_IRN_API(JsonString: text; IsIRNCancel: Boolean; recTransactionHedaer: record 99001472; IsEWayBill: Boolean; IsEWayCancel: Boolean)
    var
        genledSetup: Record "General Ledger Setup";
        glHTTPRequest: DotNet HttpWebRequest;
        gluriObj: DotNet Uri;
        glResponse: DotNet HttpWebResponse;
        txtResponse: text;
        glstream: DotNet StreamWriter;
        cuTransferEInvoice: codeunit "E-Invoice Creation";
        glreader: DotNet StreamReader;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        decryptedIRNResponse: text;
        recLocation: Record Location;
        recGSTRegNos: Record "GST Registration Nos.";
        authToken: Text;
    begin
        genledSetup.GET;
        recLocation.get(recTransactionHedaer."Store No.");
        recGSTRegNos.Reset();
        recGSTRegNos.SetRange(Code, recLocation."GST Registration No.");
        if recGSTRegNos.FindFirst() then;
        CLEAR(glHTTPRequest);
        servicepointmanager.SecurityProtocol := securityprotocol.Tls12;
        if IsEWayBill then
            gluriObj := gluriObj.Uri(genledSetup."E_Way Bill URL")
        else
            if IsIRNCancel then
                gluriObj := gluriObj.Uri(genledSetup."Cancel E-Invoice URL")
            else
                if IsEWayCancel then
                    gluriObj := gluriObj.Uri(genledSetup."Cancel E-Way Bill")
                else
                    gluriObj := gluriObj.Uri(genledSetup."E-Invoice IRN Generation URL");
        // gluriObj := gluriObj.Uri('https://einv-apisandbox.nic.in/eicore/v1.03/Invoice');
        glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
        glHTTPRequest.Headers.Add('gstin', recGSTRegNos.Code);//live
        // glHTTPRequest.Headers.Add('gstin', '01AMBPG7773M002');//uat
        // glHTTPRequest.Headers.Add('client_id', recGSTRegNos."E-Invoice Client ID");
        // glHTTPRequest.Headers.Add('client_secret', recGSTRegNos."E-Invoice Client Secret");
        // if not IsEWayCancel then
        Clear(cuTransferEInvoice);
        glHTTPRequest.Headers.Add('requestid', cuTransferEInvoice.GenerateReqId());
        glHTTPRequest.Headers.Add('user_name', recGSTRegNos."E-Invoice UserName");

        glHTTPRequest.Headers.Add('password', recGSTRegNos."E-Invoice Password");
        authToken := cuTransFerEInvoice.GenerateAuthToken(recGSTRegNos."E-Invoice Client ID", recGSTRegNos."E-Invoice Client Secret");
        if authToken = '' then exit;
        glHTTPRequest.Headers.Add('Authorization', 'Bearer ' + authToken);

        glHTTPRequest.Timeout(10000);
        glHTTPRequest.Method := 'POST';
        glHTTPRequest.ContentType := 'application/json; charset=utf-8';
        glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());
        glstream.Write(JsonString);
        glstream.Close();
        glHTTPRequest.Timeout(10000);
        glResponse := glHTTPRequest.GetResponse();
        glHTTPRequest.Timeout(10000);
        glreader := glreader.StreamReader(glResponse.GetResponseStream());
        txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019

        IF glResponse.StatusCode = 200 THEN BEGIN
            // signedData := ParseResponse_IRN_ENCRYPT(glreader.ReadToEnd, IsEWayBill, IsEWayCancel, IsIRNCancel);
            Message(txtResponse);//230922

            /*path := 'E:\GST_invoice\file_'+DELCHR(FORMAT(TODAY),'=',char)+'_'+DELCHR(FORMAT(TIME),'=',char)+'.txt';//+FORMAT(TODAY)+FORMAT(TIME)+'.txt';
            File.CREATE(path);
            File.CREATEOUTSTREAM(Outstr);
            Outstr.WRITETEXT(decryptedIRNResponse);*/
            ParseResponse_IRN_DECRYPT(txtResponse, IsEWayBill, IsEWayCancel, IsIRNCancel, recTransactionHedaer);

            glreader.Close();
            glreader.Dispose();
        END
        ELSE
            IF (glResponse.StatusCode <> 200) THEN BEGIN
                MESSAGE(FORMAT(glResponse.StatusCode));
                ERROR(glResponse.StatusDescription);
            END;

    end;



    /* Not in Use
    procedure ParseResponse_IRN_ENCRYPT(TextResponse: text; IsEwayBill: boolean; IsEwayCancel: Boolean; ISIRNCancel: Boolean): Text;
    var
        message1: Text;
        CurrentObject: Text;
        FormatChar: label '{}';
        p: Integer;
        l: Integer;
        errPOS: Integer;
        x: Integer;
        CurrentElement: Text;
        ValuePair: Text;
        txtEWBNum: Text;
        txtStatus: Text;
        CurrentValue: Text;
        txtError: text;
        txtSignedData: text;
        txtInfodDtls: text;
    begin
        //Get value from Json Response >>

        CLEAR(message1);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;

        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;
        //no response

        // CurrentObject := COPYSTR(TextResponse,STRPOS(TextResponse,'{')+1,STRPOS(TextResponse,':'));
        // TextResponse := COPYSTR(TextResponse,STRLEN(CurrentObject)+1);

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        // MESSAGE(TextResponse);
        errPOS := STRPOS(TextResponse, '"Status":0');
        if errPOS = 0 then
            errPOS := StrPos(TextResponse, '"status":"0"');
        if errPOS = 0 then
            errPOS := StrPos(TextResponse, '"Status":"0"');

        IF errPOS > 0 THEN
            if IsEwayBill then
                ERROR('Error in E-Way Bill generation : %1', TextResponse)
            else
                if IsEwayCancel then
                    ERROR('Error in E-Way Bill cancellation : %1', TextResponse)
                else
                    if ISIRNCancel then
                        ERROR('Error in IRN cancellation : %1', TextResponse)
                    else
                        ERROR('Error in IRN generation : %1', TextResponse);



        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');


                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');

                CASE CurrentElement OF
                    'Status':
                        BEGIN
                            txtStatus := CurrentValue;
                        END;
                    'status':    //for E-way cancel and E-Invoice cancel
                        txtStatus := CurrentValue;
                    'ErrorDetails':
                        BEGIN
                            txtError := CurrentValue;
                        END;
                    'Data':
                        BEGIN
                            txtSignedData := CurrentValue;
                        END;
                    'data':        //for E-way cancel and E-Invoice cancel
                        txtSignedData := CurrentValue;
                    'InfoDtls':
                        BEGIN
                            txtInfodDtls := CurrentValue;
                        END;
                END;
            END;
            x := x + 1;
        END;

        EXIT(txtSignedData);

    end;
    */
    procedure ParseResponse_IRN_DECRYPT(TextResponse: text; IsEWayBill: Boolean; IsEwayCancel: Boolean; ISIRNCancel: Boolean; recTransactionHeader: record 99001472): Text;
    var
        message1: Text;
        CurrentObject: Text;
        FormatChar: label '{}';
        p: Integer;
        l: Integer;
        x: Integer;
        CurrentElement: Text;
        ValuePair: Text;
        txtEWBNum: Text;
        CurrentValue: Text;
        txtAckNum: Text;
        txtIRN: Text;
        recPostedHeader: Record 99001472;
        txtAckDate: Text;
        txtSignedInvoice: Text;
        txtCancelIRNDate: text;
        IrnCancelled: Boolean;
        txtSignedQR: Text;
        txtEWBDt: text;
        recSIHead: Record "Sales Invoice Header";
        txtEWBValid: Text;
        txtRemarks: Text;
        txtCancelEwayNum: Text;
        txtCancelEWayDt: text;
    begin
        //Get value from Json Response >>

        CLEAR(message1);
        // message(TextResponse);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;

        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;
        //no response

        // CurrentObject := COPYSTR(TextResponse,STRPOS(TextResponse,'{')+1,STRPOS(TextResponse,':'));
        // TextResponse := COPYSTR(TextResponse,STRLEN(CurrentObject)+1);
        if StrPos(TextResponse, '"success":false') > 0 then begin
            Error('Error occurred while generating E-Invoice %1', TextResponse);
            exit;
        end;

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);

        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');

                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');

                CASE CurrentElement OF
                    'result':
                        begin
                            txtAckNum := copystr(CurrentValue, 6);
                        end;
                    // 'AckNo':
                    //     BEGIN
                    //         txtAckNum := CurrentValue;
                    //     END;
                    'AckDt':
                        BEGIN
                            txtAckDate := CurrentValue;
                        END;
                    'Irn':
                        BEGIN
                            txtIRN := CurrentValue;
                        END;
                    'SignedInvoice':
                        BEGIN
                            txtSignedInvoice := CurrentValue;
                        END;
                    'SignedQRCode':
                        BEGIN
                            txtSignedQR := CurrentValue;
                        END;
                    'EwbNo':
                        BEGIN
                            txtEWBNum := CurrentValue;
                        END;
                    'EwbDt':
                        BEGIN
                            txtEWBDt := CurrentValue;
                        END;
                    'EwbValidTill':
                        BEGIN
                            txtEWBValid := CurrentValue;
                        END;
                    'Remarks':
                        BEGIN
                            txtRemarks := CurrentValue;
                        END;
                    'CancelDate':
                        begin
                            txtCancelIRNDate := CurrentValue;
                        end;
                    'ewayBillNo':
                        begin
                            txtCancelEwayNum := CurrentValue;
                        end;
                    'cancelDate':
                        begin
                            txtCancelEWayDt := CurrentValue;
                        end;

                END;
            END;
            x := x + 1;
        END;


        recPostedHeader.RESET;
        recPostedHeader.SETFILTER("Store No.", '=%1', recTransactionHeader."Store No.");
        recPostedHeader.SetRange("POS Terminal No.", recTransactionHeader."POS Terminal No.");
        recPostedHeader.SetRange("Transaction No.", recTransactionHeader."Transaction No.");
        if recPostedHeader.FindFirst() then begin

            // if IsEWayBill then
            //     CU_EWaybill.UpdateHeaderIRN(txtEWBDt, txtEWBNum, txtEWBValid, SalesHead)//230622
            // else
            if ISIRNCancel then
                UpdateCancelDetails(txtIRN, txtCancelIRNDate, recPostedHeader)//150722
            else
                // if IsEwayCancel then
                //     CU_EWaybill.UpdateEWayCancelHeader(txtCancelEwayNum, txtCancelEWayDt, SalesHead)//160722
                //else
                UpdateHeaderIRN(txtSignedQR, txtIRN, txtAckDate, txtAckNum, recPostedHeader);//23102020
        END;

        EXIT(txtIRN);

    end;


    procedure updateHeader()
    var
        cu_jsonhandler: Codeunit "e-Invoice Json Handler";
    begin
        //  cu_jsonhandler.GetEInvoiceResponse();

    end;

    procedure UpdateHeaderIRN(QRCodeInput: Text; IRNTxt: Text; AckDt: text; AckNum: Text; recTransactionHeader: record 99001472)
    var
        FieldRef1: FieldRef;
        QRCodeFileName: Text;
        // TempBlob1: Record TempBlob;
        QRGenerator: Codeunit "QR Generator";
        RecRef1: RecordRef;
        dtText: text;
        inStr: InStream;
        // recSIHeade:record 112;
        acknwoledgeDate: DateTime;
        cu_jsonhandler: Codeunit "e-Invoice Json Handler";
        blobCU: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
    begin
        //GET HEADER REC AND SAVE QR INTO BLOB FIELD
        RecRef1.OPEN(99001472);
        FieldRef1 := RecRef1.FIELD(15);
        FieldRef1.SETRANGE(recTransactionHeader."Receipt No.");//Parameter
        IF RecRef1.FINDFIRST THEN BEGIN
            QRGenerator.GenerateQRCodeImage(QRCodeInput, blobCU);

            FieldRef1 := RecRef1.FIELD(recTransactionHeader.FieldNo("QR Code"));//QR
            blobCU.ToRecordRef(RecRef1, recTransactionHeader.FieldNo("QR Code"));
            // blobCU.ToRecordRef(RecRef1, 18173);
            // FieldRef1.VALUE := blobCU;// TempBlob1.Blob;
            // FieldRef1 := RecRef1.FIELD(18172);//IRN Num
            FieldRef1 := RecRef1.Field(recTransactionHeader.FieldNo("IRN Hash"));
            FieldRef1.VALUE := IRNTxt;
            // FieldRef1 := RecRef1.FIELD(18171);//AckNum
            FieldRef1 := RecRef1.Field(recTransactionHeader.FieldNo("Acknowledgement No."));
            FieldRef1.VALUE := AckNum;
            // FieldRef1 := RecRef1.FIELD(18174);//AckDate
            dtText := ConvertAckDt(AckDt);
            FieldRef1 := RecRef1.Field(recTransactionHeader.FieldNo("Acknowledgement Date"));
            EVALUATE(acknwoledgeDate, dtText);
            FieldRef1.VALUE := acknwoledgeDate;
            RecRef1.MODIFY;
        END;
    end;

    procedure ConvertAckDt(DtText: text): text;
    var
        DateTime_Fin: text;
        YYYY: text;
        DD: text;
        MM: text;
    begin
        YYYY := COPYSTR(DtText, 1, 4);
        MM := COPYSTR(DtText, 6, 2);
        DD := COPYSTR(DtText, 9, 2);
        DateTime_Fin := DD + '/' + MM + '/' + YYYY + ' ' + COPYSTR(DtText, 12, 8);
        // DateTime_Fin := MM + '/' + DD + '/' + YYYY + ' ' + COPYSTR(DtText, 12, 8);
        exit(DateTime_Fin);
    end;

    procedure WriteTransDtls(VAR JsonObj: DotNet JObject; recTransactionHeader: Record "LSC Transaction Header";

    VAR
        JsonWriter: DotNet JsonTextWriter)
    var
        category: Code[30];
        recCustomer: Record 18;
        E_InvoiceHandler: Codeunit "e-Invoice Management";
        E_InvoiceHandler1: codeunit "e-Invoice Json Handler";
    begin
        //***Trans Detail Start
        JsonWriter.WritePropertyName('TranDtls');
        JsonWriter.WriteStartObject();

        JsonWriter.WritePropertyName('TaxSch');
        JsonWriter.WriteValue('GST');



        IF (recTransactionHeader."LSCIN GST Customer Type" = recTransactionHeader."LSCIN GST Customer Type"::Registered)
            OR (recTransactionHeader."LSCIN GST Customer Type" = recTransactionHeader."LSCIN GST Customer Type"::Exempted) THEN
            category := 'B2B'
        ELSE
            IF (recTransactionHeader."LSCIN GST Customer Type" = recTransactionHeader."LSCIN GST Customer Type"::Export) THEN
                //to be discussed
                // IF recTransactionHeader.gst  ."GST Without Payment of Duty" THEN
                //     category := 'EXPWOP'
                // ELSE
                category := 'EXPWOP'
            ELSE
                IF
             (recTransactionHeader."LSCIN GST Customer Type" = recTransactionHeader."LSCIN GST Customer Type"::"Deemed Export") THEN
                    category := 'DEXP'
                else
                    if (recTransactionHeader."LSCIN GST Customer Type" = recTransactionHeader."LSCIN GST Customer Type"::"SEZ Development") or
                   (recTransactionHeader."LSCIN GST Customer Type" = recTransactionHeader."LSCIN GST Customer Type"::"SEZ Unit") then
                        category := 'SEZ';


        JsonWriter.WritePropertyName('SupTyp');
        JsonWriter.WriteValue(category);

        JsonWriter.WritePropertyName('RegRev');
        JsonWriter.WriteValue('N');

        // JsonWriter.WritePropertyName('EcmGstin');
        // JsonWriter.WriteValue(BBQ_GSTIN);

        JsonWriter.WritePropertyName('IgstOnIntra');
        JsonWriter.WriteValue('N');

        JsonWriter.WriteEndObject();
        //***Trans Detail End--

    end;

    procedure WriteDocDtls(VAR JsonObj: DotNet JObject; recTransactionHeader: Record "LSC Transaction Header"; var JsonWriter: DotNet JsonTextWriter)
    var
        txtDocDate: Text[20];
        cuPosTransaction: Codeunit 99001570;
        Typ: Code[20];
    begin
        // IF SalesInHeader."Invoice Type" = SalesInHeader."Invoice Type"::Taxable THEN
        //     Typ := 'INV'
        // ELSE
        //     IF (SalesInHeader."Invoice Type" = SalesInHeader."Invoice Type"::"Debit Note") OR
        //     (SalesInHeader."Invoice Type" = SalesInHeader."Invoice Type"::Supplementary)
        //     THEN
        //         Typ := 'DBN'
        //     ELSE
        if recTransactionHeader."Sale Is Return Sale" then
            Typ := 'CRN'
        else
            Typ := 'INV';//Hardcoding as Invoice


        //***Doc Details Start
        JsonWriter.WritePropertyName('DocDtls');
        JsonWriter.WriteStartObject();

        //DocType
        JsonWriter.WritePropertyName('Typ');
        JsonWriter.WriteValue(Typ);

        //Doc Num
        JsonWriter.WritePropertyName('No');
        // JsonWriter.WriteValue(COPYSTR(recTransactionHeader."Receipt No.", 2));
        // JsonWriter.WriteValue(CopyStr(recTransactionHeader."Receipt No.", StrLen(recTransactionHeader."Receipt No.") - 15 + 1));
        JsonWriter.WriteValue(format(recTransactionHeader."Transaction No.") + recTransactionHeader."POS Terminal No.");

        /*dtDay := FORMAT(DATE2DMY(TODAY,1));
        dtMonth := FORMAT(DATE2DMY(TODAY,2));
        dtYear := FORMAT(DATE2DMY(TODAY,3));
        txtDocDate := dtDay+'/'+dtMonth+'/'+dtYear;
        MESSAGE(txtDocDate);*/
        txtDocDate := FORMAT(recTransactionHeader.Date, 0, '<Day,2>/<Month,2>/<Year4>');
        JsonWriter.WritePropertyName('Dt');
        JsonWriter.WriteValue(txtDocDate);

        JsonWriter.WriteEndObject();
        //***Doc Details End--


    end;

    procedure WriteSellerDtls(VAR JsonObj: DotNet JObject; recTransactionHeader: Record "LSC Transaction Header"; var JsonWriter: DotNet JsonTextWriter)
    var
        // loc: code[20];
        loc: code[30];
        Pin: Integer;
        Stcd: Code[15];
        Ph: Code[20];
        LocationBuff: Record Location;
        Location: Record Location;
        Em: Text[100];
        CompanyInformationBuff: Record "Company Information";
        TrdNm: Text;
        LglNm: text;
        Addr1: text;
        Addr2: text;
        StateBuff: Record State;
        Gstin: text;
    begin
        CLEAR(Loc);
        CLEAR(Pin);
        CLEAR(Stcd);
        CLEAR(Ph);
        CLEAR(Em);
        WITH recTransactionHeader DO BEGIN
            Location.GET(recTransactionHeader."Store No.");
            //    Gstin := "Location GST Reg. No.";
            Gstin := Location."GST Registration No.";
            CompanyInformationBuff.GET;
            TrdNm := CompanyInformationBuff.Name;
            LocationBuff.GET("Store No.");
            LglNm := LocationBuff.Name;
            Addr1 := LocationBuff.Address;
            Addr2 := LocationBuff."Address 2";
            IF LocationBuff.GET("Store No.") THEN BEGIN
                Loc := LocationBuff.City;
                EVALUATE(Pin, COPYSTR(LocationBuff."Post Code", 1, 6));
                StateBuff.GET(LocationBuff."State Code");
                //      Stcd := StateBuff.Description;
                Stcd := StateBuff."State Code (GST Reg. No.)";
                Ph := COPYSTR(LocationBuff."Phone No.", 1, 12);
                gl_BilltoPh := COPYSTR(LocationBuff."Phone No.", 1, 12);
                gl_BilltoEm := COPYSTR(LocationBuff."E-Mail", 1, 100);
                Em := COPYSTR(LocationBuff."E-Mail", 1, 100);
            END;
        END;

        //***Seller Details start
        JsonWriter.WritePropertyName('SellerDtls');
        JsonWriter.WriteStartObject();

        JsonWriter.WritePropertyName('Gstin');
        JsonWriter.WriteValue(Gstin);//live
        // JsonWriter.WriteValue('01AMBPG7773M002');//uat
        // JsonWriter.WriteValue('03AMBPG7773M002');//UAT
        // JsonWriter.WriteValue(BBQ_GSTIN);//UAT

        //Seller Legal Name
        JsonWriter.WritePropertyName('LglNm');
        JsonWriter.WriteValue(LglNm);

        //Seller Trading Name
        JsonWriter.WritePropertyName('TrdNm');
        JsonWriter.WriteValue(LglNm);

        JsonWriter.WritePropertyName('Addr1');
        JsonWriter.WriteValue(Addr1);

        JsonWriter.WritePropertyName('Addr2');
        JsonWriter.WriteValue(Addr2);

        //City e.g., GANDHINAGAR
        JsonWriter.WritePropertyName('Loc');
        JsonWriter.WriteValue(UPPERCASE(Loc));//Live
        // JsonWriter.WriteValue('Jammu');//uat

        JsonWriter.WritePropertyName('Pin');
        JsonWriter.WriteValue(Pin);//Live
        // JsonWriter.WriteValue(141104);//uat
        // JsonWriter.WriteValue(180001);//uat

        JsonWriter.WritePropertyName('Stcd');
        JsonWriter.WriteValue(Stcd);//Live
        // JsonWriter.WriteValue('01');//Uat

        //Phone
        JsonWriter.WritePropertyName('Ph');
        JsonWriter.WriteValue(Ph);

        //Email
        JsonWriter.WritePropertyName('Em');
        JsonWriter.WriteValue(Em);

        JsonWriter.WriteEndObject();
        //***Seller Details End--

    end;

    procedure WriteBuyerDtls(VAR JsonObj: DotNet JObject; recTransactionHeader: Record "LSC Transaction Header"; var JsonWriter: DotNet JsonTextWriter;
        BilltoPh: Code[20];
        BillToEm: Text[100])
    var
        POS: text;
        Stcd: text;
        Ph: text;
        Em: Text;
        Gstin: text;
        customerrec: Record Customer;
        Lglnm: text;
        Trdnm: text;
        Addr1: text;
        recCustomer1: Record 18;
        // Loc: Code[10];
        Loc: Code[30];
        recLocation: Record 14;
        Addr2: text;
        Pin: integer;
        ShipToAddr: Record "Ship-to Address";
        SalesInvoiceLine: Record "Sales Invoice Line";
        StateBuff: Record State;
        Contact: Record Contact;
        RecState: Record State;
    begin
        WITH recTransactionHeader DO BEGIN
            IF "LSCIN GST Customer Type" = "LSCIN GST Customer Type"::Export THEN
                Gstin := 'URP'
            ELSE BEGIN
                customerrec.GET(recTransactionHeader."Customer No.");
                Gstin := customerrec."GST Registration No.";
            END;

            recCustomer1.get("Customer No.");
            LglNm := recCustomer1."No.";
            TrdNm := recCustomer1.Name;
            Addr1 := recCustomer1.Address;
            Addr2 := recCustomer1."Address 2";
            Loc := recCustomer1.City;
            IF "LSCIN GST Customer Type" <> "LSCIN GST Customer Type"::Export THEN begin
                if recCustomer1."Post Code" <> '' then
                    EVALUATE(Pin, COPYSTR(recCustomer1."Post Code", 1, 6))
            end;


            // SalesInvoiceLine.SETRANGE("Document No.", );
            // SalesInvoiceLine.SETFILTER("GST Place of Supply", '<>%1', SalesInvoiceLine."GST Place of Supply"::" ");
            // IF SalesInvoiceLine.FINDFIRST THEN
            //     IF SalesInvoiceLine."GST Place of Supply" = SalesInvoiceLine."GST Place of Supply"::"Bill-to Address" THEN BEGIN
            IF "LSCIN GST Customer Type" IN
             ["LSCIN GST Customer Type"::Export]//,"GST Customer Type"::"SEZ Development","GST Customer Type"::"SEZ Unit"]
              THEN
                POS := '96'
            ELSE BEGIN
                // if recCustomer1."Location Code" = '' then Error('Customer location code should not be blank, Customer = %1', recCustomer1.Name);//Nkp--091023
                // recLocation.Get(recCustomer1."Location Code");
                // // recTransactionHeader."Store No.");
                // // StateBuff.RESET;
                // StateBuff.GET(recLocation."State Code");
                // POS := FORMAT(StateBuff."State Code (GST Reg. No.)");
                // //          Stcd := StateBuff.Description;
                // Stcd := StateBuff."State Code (GST Reg. No.)";//Nkp--091023
                if recCustomer1."State Code" = '' then Error('Customer State code should not be blank, Customer = %1', recCustomer1.Name);
                RecState.Get(recCustomer1."State Code");
                POS := Format(RecState."State Code (GST Reg. No.)");
                Stcd := RecState."State Code (GST Reg. No.)";
            END;

            IF Contact.GET(recCustomer1.Contact) THEN BEGIN
                Ph := COPYSTR(Contact."Phone No.", 1, 12);
                Em := COPYSTR(Contact."E-Mail", 1, 100);
            END;
            //         END ELSE
            //             IF SalesInvoiceLine."GST Place of Supply" = SalesInvoiceLine."GST Place of Supply"::"Ship-to Address" THEN BEGIN
            //                 IF "GST Customer Type" IN
            //                     ["GST Customer Type"::Export]//,"GST Customer Type"::"SEZ Development","GST Customer Type"::"SEZ Unit"]
            //                 THEN
            //                     POS := '96'
            //                 ELSE BEGIN
            //                     StateBuff.RESET;
            //                     StateBuff.GET("GST Ship-to State Code");
            //                     POS := FORMAT(StateBuff."State Code (GST Reg. No.)");
            //                     Stcd := StateBuff.Description;
            //                 END;

            //                 IF ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code") THEN BEGIN
            //                     Ph := COPYSTR(ShipToAddr."Phone No.", 1, 12);
            //                     Em := COPYSTR(ShipToAddr."E-Mail", 1, 100);
            //                 END;
            //             END;
            // END;

            //***Buyer Details start
            JsonWriter.WritePropertyName('BuyerDtls');
            JsonWriter.WriteStartObject();

            JsonWriter.WritePropertyName('Gstin');
            JsonWriter.WriteValue(Gstin);

            //Legal Name
            JsonWriter.WritePropertyName('LglNm');
            JsonWriter.WriteValue(LglNm);

            //Trading Name
            JsonWriter.WritePropertyName('TrdNm');
            JsonWriter.WriteValue(TrdNm);

            //What is this e.g., 12
            JsonWriter.WritePropertyName('Pos');
            JsonWriter.WriteValue(POS);

            JsonWriter.WritePropertyName('Addr1');
            JsonWriter.WriteValue(Addr1);

            JsonWriter.WritePropertyName('Addr2');
            JsonWriter.WriteValue(Addr2);

            JsonWriter.WritePropertyName('Loc');
            JsonWriter.WriteValue(Loc);

            JsonWriter.WritePropertyName('Pin');
            JsonWriter.WriteValue(Pin);

            //What is this e.g., 29
            JsonWriter.WritePropertyName('Stcd');
            JsonWriter.WriteValue(Stcd);

            //Phone
            JsonWriter.WritePropertyName('Ph');
            IF Ph <> '' THEN
                JsonWriter.WriteValue(Ph)
            ELSE
                JsonWriter.WriteValue(GlobalNULL);

            //Email
            JsonWriter.WritePropertyName('Em');
            IF Em <> '' THEN
                JsonWriter.WriteValue(Em)
            ELSE
                JsonWriter.WriteValue(GlobalNULL);

            JsonWriter.WriteEndObject();
            //**Buyer Details End--
        end;
    end;

    procedure Calculate_TaxTrans_Header(recTransactionHeader: record 99001472;
        var CGST_percent: Decimal;
        var SGST_percent: Decimal;
        var IGST_percent: Decimal;
        var CessRate: decimal;
        var CesNonAdval: decimal;
        var StateCess: decimal;
        var GSTRt: decimal;
        var CGST_Amt: Decimal;
        var SGST_Amt: Decimal;
        var IGST_Amt: Decimal;
        var DiscountAmount: Decimal;
        var AssessableAmount: decimal;
        var TotGSTAmt: decimal;
        var CessAmount: decimal;
        var StateCessValue: Decimal;
        var TotInvoiceVal: decimal
        )
    var
        TaxTransactionValue: Record "LSCIN Tax Transaction Value";
        taxrecordId: RecordId;
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        decColumnAmt: Decimal;
        recTransSalesEn: Record 99001473;
        IncomeExpEnt: Record "LSC Trans. Inc./Exp. Entry";
        IncomeExpAcc: Record "LSC Income/Expense Account";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        CessRate := 0;
        CesNonAdval := 0;
        StateCess := 0;
        Clear(IGST_Amt);
        Clear(IGST_percent);
        Clear(SGST_Amt);
        Clear(SGST_percent);
        Clear(CGST_Amt);
        Clear(GSTRt);
        clear(AssessableAmount);
        Clear(DiscountAmount);
        Clear(SGST_percent);

        recTransSalesEn.Reset();
        recTransSalesEn.SetRange("Store No.", recTransactionHeader."Store No.");
        recTransSalesEn.SetRange("POS Terminal No.", recTransactionHeader."POS Terminal No.");
        recTransSalesEn.SetRange("Transaction No.", recTransactionHeader."Transaction No.");
        if recTransSalesEn.Find('-') then
            repeat
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetFilter("Tax Record ID", '%1', recTransSalesEn.RecordId);
                TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::COMPONENT);
                TaxTransactionValue.SetRange("Visible on Interface", true);
                TaxTransactionValue.SetFilter(Amount, '<>%1', 0);
                if TaxTransactionValue.Find('-') then
                    repeat

                        IF (TaxTransactionValue.GetAttributeColumName() <> 'GST Base Amount') AND (TaxTransactionValue.GetAttributeColumName() <> 'Total TDS Amount') THEN BEGIN
                            IF (TaxTransactionValue.GetAttributeColumName() = 'CGST') then begin
                                // if TaxTransactionValue.Amount < "LSC Trans. Sales Entry"."Net Amount" then begin
                                CGST_Amt += TaxTransactionValue.Amount;//ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER);
                                CGST_percent := TaxTransactionValue.Percent;
                            end;
                            if (TaxTransactionValue.GetAttributeColumName() = 'SGST') then begin
                                // ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
                                // Evaluate(decColumnAmt, TaxTransactionValue."Column Value");
                                // taxFound := true;
                                SGST_Amt += TaxTransactionValue.Amount;
                                SGST_percent := TaxTransactionValue.Percent;
                                // Message('Sgst:=%1', SGST_Amt);
                            end;  //CITS_RS
                            if (TaxTransactionValue.GetAttributeColumName() = 'IGST') THEN BEGIN
                                IGST_Amt += TaxTransactionValue.Amount;
                                IGST_percent := TaxTransactionValue.Percent;
                                // taxFound := true;//CITS_RS
                            end;

                            if Cgst_Amt <> 0 then
                                GSTRt := 2 * CGST_percent
                            else
                                GSTRt := IGST_percent;

                        end;
                    until TaxTransactionValue.next() = 0;
                AssessableAmount += recTransSalesEn."Net Amount";
                DiscountAmount += recTransSalesEn."Discount Amount";
            until recTransSalesEn.Next() = 0;


        TotGSTAmt := CGST_Amt + SGST_Amt + IGST_Amt + CessAmount + StateCessValue;
        TotInvoiceVal := ABS(AssessableAmount) + ABS(TotGSTAmt);

        AssessableAmount := Round(
            CurrencyExchangeRate.ExchangeAmtFCYToLCY(
              WorkDate(), recTransactionHeader."Trans. Currency", AssessableAmount, recTransactionHeader."LSCIN Currency Factor"), 0.01, '=');
        TotGSTAmt := Round(
            CurrencyExchangeRate.ExchangeAmtFCYToLCY(
              WorkDate(), recTransactionHeader."Trans. Currency", TotGSTAmt, recTransactionHeader."LSCIN Currency Factor"), 0.01, '=');
        DiscountAmount := Round(
            CurrencyExchangeRate.ExchangeAmtFCYToLCY(
              WorkDate(), recTransactionHeader."Trans. Currency", DiscountAmount, recTransactionHeader."LSCIN Currency Factor"), 0.01, '=');
    end;

    procedure Calculate_TaxTrans_Line(recTransSalesEn: Record 99001473;
        var CGST_percent: Decimal;
        var SGST_percent: Decimal;
        var IGST_percent: Decimal;
        var CessRate: decimal;
        var CesNonAdval: decimal;
        var StateCess: decimal;
        var GSTRt: decimal;
        var CGST_Amt: Decimal;
        var SGST_Amt: Decimal;
        var IGST_Amt: Decimal)
    // var AssAmt:Decimal)
    var
        TaxTransactionValue: Record "LSCIN Tax Transaction Value";
        taxrecordId: RecordId;
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        decColumnAmt: Decimal;
        IncomeExpEnt: Record "LSC Trans. Inc./Exp. Entry";
        IncomeExpAcc: Record "LSC Income/Expense Account";

    begin
        CessRate := 0;
        CesNonAdval := 0;
        StateCess := 0;
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetFilter("Tax Record ID", '%1', recTransSalesEn.RecordId);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetFilter(Amount, '<>%1', 0);
        if TaxTransactionValue.Find('-') then
            repeat

                IF (TaxTransactionValue.GetAttributeColumName() <> 'GST Base Amount') AND (TaxTransactionValue.GetAttributeColumName() <> 'Total TDS Amount') THEN BEGIN
                    IF (TaxTransactionValue.GetAttributeColumName() = 'CGST') then begin
                        // if TaxTransactionValue.Amount < "LSC Trans. Sales Entry"."Net Amount" then begin
                        CGST_Amt := TaxTransactionValue.Amount;//ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER);
                        CGST_percent := TaxTransactionValue.Percent;
                    end;
                    if (TaxTransactionValue.GetAttributeColumName() = 'SGST') then begin
                        // ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
                        // Evaluate(decColumnAmt, TaxTransactionValue."Column Value");
                        // taxFound := true;
                        SGST_Amt := TaxTransactionValue.Amount;
                        SGST_percent := TaxTransactionValue.Percent;
                        // Message('Sgst:=%1', SGST_Amt);
                    end;  //CITS_RS
                    if (TaxTransactionValue.GetAttributeColumName() = 'IGST') THEN BEGIN
                        IGST_Amt := TaxTransactionValue.Amount;
                        IGST_percent := TaxTransactionValue.Percent;
                        // taxFound := true;//CITS_RS
                    end;

                    if Cgst_Amt <> 0 then
                        GSTRt := 2 * CGST_percent
                    else
                        GSTRt := IGST_percent;

                end;
            until TaxTransactionValue.next() = 0;
    end;

    procedure WriteItemDtls(VAR JsonObj: DotNet JObject; var recTransactionHeader: Record 99001472; var JsonWriter: DotNet JsonTextWriter; CurrExchRt: Decimal)
    var
        AssAmt: Decimal;
        SlNo: integer;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CessRate: Decimal;
        FreeQty: Decimal;
        CesNonAdval: Decimal;
        IsServc: text;
        GSTTr: Decimal;
        StateCess: Decimal;
        UOM: Code[10];
        GSTRt: Decimal;
        CgstAmt: Decimal;
        recItem: Record 27;
        SgstAmt: Decimal;
        IgstAmt: Decimal;
        CesRt: Decimal;
        CesAmt: Decimal;
        StateCesRt: Decimal;
        StateCesAmt: Decimal;
        StateCesNonAdvlAmt: Decimal;
        CGSTValue: Decimal;
        SGSTValue: Decimal;
        IGSTValue: Decimal;
        // SalesInvoiceLine: Record "Sales Invoice Line";
        recTransSalesEn: Record 99001473;
    begin
        CLEAR(SlNo);
        recTransSalesEn.Reset();
        recTransSalesEn.SetRange("Store No.", recTransactionHeader."Store No.");
        recTransSalesEn.SetRange("POS Terminal No.", recTransactionHeader."POS Terminal No.");
        recTransSalesEn.SetRange("Transaction No.", recTransactionHeader."Transaction No.");
        IF recTransSalesEn.FINDSET THEN BEGIN
            if recTransSalesEn.Count > 100 then
                ERROR(SalesLineErr, recTransSalesEn.COUNT);

            // SalesInvoiceLine.SETRANGE("Document No.", SalesInHeader."No.");
            // SalesInvoiceLine.SetFilter(Amount, '>%1', 0.5);//excluding rounding lines 240922
            // //  SalesInvoiceLine.SETRANGE("Non-GST Line",FALSE);
            // SalesInvoiceLine.SETFILTER(Type, '<>%1', SalesInvoiceLine.Type::" ");
            // IF SalesInvoiceLine.FINDSET THEN BEGIN
            //     IF SalesInvoiceLine.COUNT > 100 THEN
            //         ERROR(SalesLineErr, SalesInvoiceLine.COUNT);
            JsonWriter.WritePropertyName('ItemList');
            JsonWriter.WriteStartArray;
            REPEAT
                Clear(CGSTRate);
                Clear(SGSTRate);
                Clear(IGSTRate);
                Clear(CessRate);
                Clear(CesNonAdval);
                Clear(StateCesAmt);
                Clear(GSTRt);
                SlNo += 1;
                //   {IF SalesInvoiceLine."GST On Assessable Value" THEN
                //     AssAmt := SalesInvoiceLine."GST Assessable Value (LCY)"
                //   ELSE}
                // if recTransSalesEn."Net Price" <> 0 then
                //     // SalesInvoiceLine."GST Assessable Value (LCY)" <> 0 then
                //     // AssAmt := SalesInvoiceLine."GST Assessable Value (LCY)"
                //     AssAmt := recTransSalesEn."Net Amount"
                // else
                // AssAmt := SalesInvoiceLine.Amount;
                AssAmt := abs(recTransSalesEn."Net Amount");
                // AssAmt := SalesInvoiceLine."GST Assessable Value (LCY)";

                //   IF SalesInvoiceLine."Free Supply" THEN
                //     FreeQty := SalesInvoiceLine.Quantity
                //   ELSE
                //     FreeQty := 0;

                //   GetGSTCompRate(
                //     SalesInvoiceLine."Document No.",
                //     SalesInvoiceLine."Line No.",
                //     GSTRt,
                //     CgstAmt,
                //     SgstAmt,
                //     IgstAmt,
                //     CesRt,
                //     CesAmt,
                //     CesNonAdval,
                //     StateCesRt,
                //     StateCesAmt,
                //     StateCesNonAdvlAmt);
                // GetGSTComponentRate(
                //     recTransSalesEn."Receipt No.",
                //     // SalesInvoiceLine."Document No.",
                //     // SalesInvoiceLine."Line No.",
                //     recTransSalesEn."Line No.",
                //     CGSTRate,
                //     SGSTRate,
                //     IGSTRate,
                //     CessRate,
                //     CesNonAdval,
                //     StateCess, GSTRt
                // );
                Calculate_TaxTrans_Line(
                        recTransSalesEn,
                        CGSTRate,
                        SGSTRate,
                        IGSTRate,
                        CessRate,
                        CesNonAdval,
                        StateCess,
                        GSTRt,
                        CGSTValue,
                        SGSTValue,
                        IGSTValue
                        );
                CLEAR(UOM);
                IF recTransSalesEn."Unit of Measure" <> '' THEN
                    UOM := COPYSTR(recTransSalesEn."Unit of Measure", 1, 8)
                ELSE
                    UOM := 'PCS';//hardcoded

                IF recTransSalesEn."LSCIN GST Group Type" = recTransSalesEn."LSCIN GST Group Type"::Service THEN
                    IsServc := 'Y'
                ELSE
                    IsServc := 'N';
                /*WriteItem(
                  SalesInvoiceLine.Description + SalesInvoiceLine."Description 2",
                  SalesInvoiceLine."HSN/SAC Code",
                  SalesInvoiceLine.Quantity,
                  FreeQty,
                  UOM,
                  SalesInvoiceLine."Unit Price",
                  SalesInvoiceLine."Line Amount" + SalesInvoiceLine."Line Discount Amount",
                  SalesInvoiceLine."Line Discount Amount",
                  SalesInvoiceLine."Line Amount",
                  AssAmt,
                  CGSTRate,
                  IGSTRate,
                  IgstAmt,
                  StateCesRt,
                  CesAmt,
                  CesNonAdval,
                  StateCesRt,
                  StateCesAmt,
                  StateCesNonAdvlAmt,
                  0,
                  SalesInvoiceLine."Amount Including Tax" + SalesInvoiceLine."Total GST Amount",
                  SalesInvoiceLine."Line No.",
                  SlNo,
                  IsServc, JsonWriter, CurrExchRt, GSTRt);*/

                // GetGSTValueForLine(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.", CGSTValue, SGSTValue, IGSTValue);


                recItem.get(recTransSalesEn."Item No.");
                WriteItem(
                        recItem.Description + recItem."Description 2",//name
                        '',//description
                           // SalesInvoiceLine.Description + SalesInvoiceLine."Description 2", '',
                        recTransSalesEn."LSCIN HSN/SAC Code",//hsn
                        recItem."No.",//barcode
                                      // SalesInvoiceLine."HSN/SAC Code", '',
                        recTransSalesEn.Quantity,
                        0,//freeQty
                          // SalesInvoiceLine.Quantity, 0,
                        UOM,
                        // CopyStr(SalesInvoiceLine."Unit of Measure Code", 1, 10),
                        recTransSalesEn.Price,
                        // SalesInvoiceLine."Unit Price",
                        recTransSalesEn."Net Amount" + recTransSalesEn."Discount Amount",//total amount
                                                                                         // SalesInvoiceLine."Line Amount" + SalesInvoiceLine."Line Discount Amount",
                        recTransSalesEn."Discount Amount",
                        0,//other charges
                          // SalesInvoiceLine."Line Discount Amount", 0,
                        AssAmt, CGSTRate, SGSTRate, IGSTRate, CessRate, CesNonAdval, StateCess,
                        (AssAmt + CGSTValue + SGSTValue + IGSTValue),//totalItemAmtValue
                        SlNo,
                        IsServc,
                        CurrExchRt,
                        GSTRt, CGSTValue, SGSTValue, IGSTValue);

            UNTIL recTransSalesEn.Next() = 0;
            JsonWriter.WriteEndArray;
        END;
    end;


    // procedure WriteItem(PrdDesc: Text; HsnCd: Text; Qty: Decimal; FreeQty: Decimal; Unit: Text; UnitPrice: Decimal; TotAmt: Decimal; Discount: Decimal; PreTaxVal: Decimal; AssAmt: Decimal; CgstAmt: Decimal; SgstAmt: Decimal; IgstAmt: Decimal; CesRt: Decimal; CesAmt: Decimal; CesNonAdval: Decimal; StateCes: Decimal; StateCesAmt: Decimal; StateCesNonAdvlAmt: Decimal; OthChrg: Decimal; TotItemVal: Decimal; SILineNo: Decimal; SlNo: Integer; IsServc: Text; VAR JsonTextWriter: DotNet JsonTextWriter; CurrExRate: Decimal; GSTRt: Decimal)
    // var
    // begin

    // end;
    local procedure WriteItem(
        ProductName: Text;
        ProductDescription: Text;
        HSNCode: Text[10];
        BarCode: Text[30];
        Quantity: Decimal;
        FreeQuantity: Decimal;
        Unit: Code[10];
        UnitPrice: Decimal;
        TotAmount: Decimal;
        Discount: Decimal;
        OtherCharges: Decimal;
        AssessableAmount: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CESSRate: Decimal;
        CessNonAdvanceAmount: Decimal;
        StateCess: Decimal;
        TotalItemValue: Decimal;
        SlNo: Integer;
        IsServc: Code[2];
        CurrExRate: Decimal;
        GSTRt: Decimal;
        CGSTValue: Decimal;
        SGSTValue: Decimal;
        IGSTValue: Decimal)
    var
        recUOM: Record "Unit of Measure";
    begin
        recUOM.Get(Unit);

        JsonWriter.WriteStartObject;

        JsonWriter.WritePropertyName('SlNo');
        JsonWriter.WriteValue(FORMAT(SlNo));

        JsonWriter.WritePropertyName('PrdDesc');
        IF ProductName <> '' THEN
            JsonWriter.WriteValue(ProductName)
        ELSE
            JsonWriter.WriteValue(GlobalNULL);


        JsonWriter.WritePropertyName('IsServc');
        IF IsServc <> '' THEN
            JsonWriter.WriteValue(IsServc)
        ELSE
            JsonWriter.WriteValue(GlobalNULL);

        JsonWriter.WritePropertyName('HsnCd');
        IF HSNCode <> '' THEN
            JsonWriter.WriteValue(HSNCode)
        ELSE
            JsonWriter.WriteValue(GlobalNULL);

        /*IF IsInvoice THEN
        InvoiceRowID := ItemTrackingManagement.ComposeRowID(DATABASE::"Sales Invoice Line",0,DocumentNo,'',0,SILineNo)
        ELSE
        InvoiceRowID := ItemTrackingManagement.ComposeRowID(DATABASE::"Sales Cr.Memo Line",0,DocumentNo,'',0,SILineNo);
        ValueEntryRelation.SETCURRENTKEY("Source RowId");
        ValueEntryRelation.SETRANGE("Source RowId",InvoiceRowID);
        IF ValueEntryRelation.FINDSET THEN BEGIN
        xLotNo := '';
        JsonTextWriter.WritePropertyName('BchDtls');
        JsonTextWriter.WriteStartObject;
        REPEAT
            ValueEntry.GET(ValueEntryRelation."Value Entry No.");
            ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Lot No.","Serial No.");
            ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.");
            IF xLotNo <> ItemLedgerEntry."Lot No." THEN BEGIN
            WriteBchDtls(
                COPYSTR(ItemLedgerEntry."Lot No.",1,20),
                FORMAT(ItemLedgerEntry."Expiration Date",0,'<Day,2>/<Month,2>/<Year4>'),
                FORMAT(ItemLedgerEntry."Warranty Date",0,'<Day,2>/<Month,2>/<Year4>'));
            xLotNo := ItemLedgerEntry."Lot No.";
            END;
        UNTIL ValueEntryRelation.NEXT = 0;
        JsonTextWriter.WriteEndObject;
        END;
        */

        JsonWriter.WritePropertyName('Barcde');
        JsonWriter.WriteValue('null');

        JsonWriter.WritePropertyName('Qty');
        JsonWriter.WriteValue(ABS(Quantity));
        JsonWriter.WritePropertyName('FreeQty');
        JsonWriter.WriteValue(FreeQuantity);

        if recUOM."E-Inv UOM" = '' then Error('Please map E-Invoice UOM in UOM master !');
        JsonWriter.WritePropertyName('Unit');
        JsonWriter.WriteValue('PCS');//hardcoded
        // JsonWriter.WriteValue(recUOM."E-Inv UOM");
        // IF Unit = '' THEN
        //     JsonWriter.WriteValue(GlobalNULL);

        /*IF Unit <> '' THEN BEGIN
            IF Unit = 'KG' THEN
                Unit := 'KGS';
            JsonWriter.WriteValue(Unit)
        END ELSE*/


        JsonWriter.WritePropertyName('UnitPrice');
        JsonWriter.WriteValue(UnitPrice);// * CurrExRate);

        JsonWriter.WritePropertyName('TotAmt');
        JsonWriter.WriteValue(ABS(TotAmount));// * CurrExRate);

        JsonWriter.WritePropertyName('Discount');
        JsonWriter.WriteValue(Discount);// * CurrExRate);

        // JsonWriter.WritePropertyName('PreTaxVal');
        // JsonWriter.WriteValue(PreTaxVal * CurrExRate);

        JsonWriter.WritePropertyName('AssAmt');
        JsonWriter.WriteValue(Round(AssessableAmount, 0.01, '='));// * CurrExRate);

        JsonWriter.WritePropertyName('GstRt');
        if GSTRt < 5 then GSTRt := GSTRt * 2;
        JsonWriter.WriteValue(GSTRt);

        JsonWriter.WritePropertyName('IgstAmt');
        JsonWriter.WriteValue(IGSTValue);

        JsonWriter.WritePropertyName('CgstAmt');
        JsonWriter.WriteValue(CGSTValue);

        JsonWriter.WritePropertyName('SgstAmt');
        JsonWriter.WriteValue(SGSTValue);

        JsonWriter.WritePropertyName('CesRt');
        JsonWriter.WriteValue(CESSRate);

        // JsonWriter.WritePropertyName('CesAmt');
        // JsonWriter.WriteValue(CesAmt);

        // JsonWriter.WritePropertyName('CesNonAdvlAmt');
        // JsonWriter.WriteValue(CessNonAdvanceAmount);

        JsonWriter.WritePropertyName('CesNonAdvl');
        JsonWriter.WriteValue(CessNonAdvanceAmount);

        // JsonWriter.WritePropertyName('StateCesRt');
        // JsonWriter.WriteValue(StateCes);

        JsonWriter.WritePropertyName('StateCes');
        JsonWriter.WriteValue(StateCess);

        // JsonWriter.WritePropertyName('StateCesAmt');
        // JsonWriter.WriteValue(StateCesAmt);

        // JsonWriter.WritePropertyName('StateCesNonAdvlAmt');
        // JsonWriter.WriteValue(CessNonAdvanceAmount);

        JsonWriter.WritePropertyName('TotItemVal');
        JsonWriter.WriteValue(TotalItemValue);// * CurrExRate);

        /*JsonTextWriter.WritePropertyName('OthChrg');
        JsonTextWriter.WriteValue(OthChrg);

        JsonTextWriter.WritePropertyName('OrdLineRef');
        JsonTextWriter.WriteValue(GlobalNULL);

        JsonTextWriter.WritePropertyName('OrgCntry');
        JsonTextWriter.WriteValue('IN');

        JsonTextWriter.WritePropertyName('PrdSlNo');
        JsonTextWriter.WriteValue(GlobalNULL);*/

        JsonWriter.WriteEndObject;

    end;




    procedure GetGSTComponentRate(
      DocumentNo: Code[20];
      LineNo: Integer;
      var CGSTRate: Decimal;
      var SGSTRate: Decimal;
      var IGSTRate: Decimal;
      var CessRate: Decimal;
      var CessNonAdvanceAmount: Decimal;
      var StateCess: Decimal;
      var GSTRate: Decimal)
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("Document Line No.", LineNo);

        DetailedGSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then begin
            CGSTRate := DetailedGSTLedgerEntry."GST %";
            // GSTRate := DetailedGSTLedgerEntry."GST %"
        end else
            CGSTRate := 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then begin
            SGSTRate := DetailedGSTLedgerEntry."GST %";
            GSTRate := 2 * (DetailedGSTLedgerEntry."GST %");
        end else
            SGSTRate := 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then begin
            IGSTRate := DetailedGSTLedgerEntry."GST %";
            GSTRate := DetailedGSTLedgerEntry."GST %"
        end else
            IGSTRate := 0;

        CessRate := 0;
        CessNonAdvanceAmount := 0;
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CESSLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            if DetailedGSTLedgerEntry."GST %" > 0 then
                CessRate := DetailedGSTLedgerEntry."GST %"
            else
                CessNonAdvanceAmount := Abs(DetailedGSTLedgerEntry."GST Amount");

        StateCess := 0;
        DetailedGSTLedgerEntry.SetRange("GST Component Code");
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                if not (DetailedGSTLedgerEntry."GST Component Code" in [CGSTLbl, SGSTLbl, IGSTLbl, CESSLbl])
                then
                    StateCess := DetailedGSTLedgerEntry."GST %";
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    procedure GetGSTValue(
       var AssessableAmount: Decimal;
       var CGSTAmount: Decimal;
       var SGSTAmount: Decimal;
       var IGSTAmount: Decimal;
       var CessAmount: Decimal;
       var StateCessValue: Decimal;
       var CessNonAdvanceAmount: Decimal;
       var DiscountAmount: Decimal;
       var OtherCharges: Decimal;
       var TotalInvoiceValue: Decimal;
       var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        GSTLedgerEntry: Record "GST Ledger Entry";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TotGSTAmt: Decimal;
    begin
        GSTLedgerEntry.SetRange("Document No.", DocumentNo);

        GSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                CGSTAmount += Abs(GSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0
        else
            CGSTAmount := 0;

        GSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                SGSTAmount += Abs(GSTLedgerEntry."GST Amount")
            until GSTLedgerEntry.Next() = 0
        else
            SGSTAmount := 0;

        GSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                IGSTAmount += Abs(GSTLedgerEntry."GST Amount")
            until GSTLedgerEntry.Next() = 0
        else
            IGSTAmount := 0;

        CessAmount := 0;
        CessNonAdvanceAmount := 0;

        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CESSLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            repeat
                if DetailedGSTLedgerEntry."GST %" > 0 then
                    CessAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
                else
                    CessNonAdvanceAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0;


        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
        // GSTLedgerEntry.SetFilter("GST Component Code", '<>%1|<>%2|<>%3|<>%4', 'CGST', 'SGST', 'IGST', 'CESS');
        if GSTLedgerEntry.Find('-') then
            repeat
                if (GSTLedgerEntry."GST Component Code") in ['CGST', 'SGST', 'IGST', 'CESS'] then
                    StateCessValue := 0
                else
                    StateCessValue += Abs(GSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0;

        // if IsInvoice then begin
        SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        if SalesInvoiceLine.Find('-') then
            repeat
                AssessableAmount += SalesInvoiceLine.Amount;
                DiscountAmount += SalesInvoiceLine."Inv. Discount Amount";
            until SalesInvoiceLine.Next() = 0;
        TotGSTAmt := CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + CessNonAdvanceAmount + StateCessValue;

        AssessableAmount := Round(
            CurrencyExchangeRate.ExchangeAmtFCYToLCY(
              WorkDate(), SalesInvoiceHeader."Currency Code", AssessableAmount, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
        TotGSTAmt := Round(
            CurrencyExchangeRate.ExchangeAmtFCYToLCY(
              WorkDate(), SalesInvoiceHeader."Currency Code", TotGSTAmt, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
        DiscountAmount := Round(
            CurrencyExchangeRate.ExchangeAmtFCYToLCY(
              WorkDate(), SalesInvoiceHeader."Currency Code", DiscountAmount, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
        // end;
        /* else begin
            SalesCrMemoLine.SetRange("Document No.", DocumentNo);
            if SalesCrMemoLine.FindSet() then begin
                repeat
                    AssessableAmount += SalesCrMemoLine.Amount;
                    DiscountAmount += SalesCrMemoLine."Inv. Discount Amount";
                until SalesCrMemoLine.Next() = 0;
                TotGSTAmt := CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + CessNonAdvanceAmount + StateCessValue;
            end;

            AssessableAmount := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    WorkDate(),
                    SalesCrMemoHeader."Currency Code",
                    AssessableAmount,
                    SalesCrMemoHeader."Currency Factor"),
                    0.01,
                    '=');

            TotGSTAmt := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    WorkDate(),
                    SalesCrMemoHeader."Currency Code",
                    TotGSTAmt,
                    SalesCrMemoHeader."Currency Factor"),
                    0.01,
                    '=');

            DiscountAmount := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    WorkDate(),
                    SalesCrMemoHeader."Currency Code",
                    DiscountAmount,
                    SalesCrMemoHeader."Currency Factor"),
                    0.01,
                    '=');
        end;*/

        CustLedgerEntry.SetCurrentKey("Document No.");
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        // if IsInvoice then begin
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange("Customer No.", SalesInvoiceHeader."Bill-to Customer No.");
        if CustLedgerEntry.FindFirst() then begin
            CustLedgerEntry.CalcFields("Amount (LCY)");
            TotalInvoiceValue := Abs(CustLedgerEntry."Amount (LCY)");
        end;
        // end;
        /* else begin
            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
            CustLedgerEntry.SetRange("Customer No.", SalesCrMemoHeader."Bill-to Customer No.");
        end;*/



        OtherCharges := 0;
    end;

    procedure GetGSTValueForLine(
       DocumentNo: Code[80];
       DocumentLineNo: Integer;
       var CGSTLineAmount: Decimal;
       var SGSTLineAmount: Decimal;
       var IGSTLineAmount: Decimal)
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        CGSTLineAmount := 0;
        SGSTLineAmount := 0;
        IGSTLineAmount := 0;

        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("Document Line No.", DocumentLineNo);
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if DetailedGSTLedgerEntry.Find('-') then
            repeat
                CGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
            until DetailedGSTLedgerEntry.Next() = 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if DetailedGSTLedgerEntry.Find('-') then
            repeat
                SGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
            until DetailedGSTLedgerEntry.Next() = 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if DetailedGSTLedgerEntry.Find('-') then
            repeat
                IGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    procedure WriteValDtls(JsonObj1: DotNet JObject; recTransactionHeader: Record 99001472; JsonWriter1: DotNet JsonTextWriter)
    var
        AssessableAmount: Decimal;
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        CessAmount: Decimal;
        StateCessAmount: Decimal;
        CESSNonAvailmentAmount: Decimal;
        DiscountAmount: Decimal;
        OtherCharges: Decimal;
        TotalInvoiceValue: Decimal;
        CGST_percent: Decimal;
        SGST_percent: Decimal;
        IGST_percent: Decimal;
        CessRate: decimal;
        CesNonAdval: decimal;
        StateCess: decimal;
        TotalGSTVal: Decimal;
        GSTRt: decimal;
    begin
        // GetGSTValue(AssessableAmount, CGSTAmount, SGSTAmount, IGSTAmount, CessAmount, StateCessAmount, CESSNonAvailmentAmount, DiscountAmount, OtherCharges, TotalInvoiceValue, SIHeader);
        Calculate_TaxTrans_Header(recTransactionHeader, CGST_percent, SGST_percent, IGST_percent, CessRate, CesNonAdval, StateCess, GSTRt, CGSTAmount, SGSTAmount, IGSTAmount, DiscountAmount, AssessableAmount, TotalGSTVal, CessAmount, StateCessAmount, TotalInvoiceValue);

        JsonWriter.WritePropertyName('ValDtls');
        JsonWriter.WriteStartObject();
        JsonWriter.WritePropertyName('Assval');
        JsonWriter.WriteValue(ABS(AssessableAmount));

        JsonWriter.WritePropertyName('CgstVal');
        JsonWriter.WriteValue(CGSTAmount);

        JsonWriter.WritePropertyName('SgstVAl');
        JsonWriter.WriteValue(SGSTAmount);

        JsonWriter.WritePropertyName('IgstVal');
        JsonWriter.WriteValue(IGSTAmount);

        JsonWriter.WritePropertyName('CesVal');
        JsonWriter.WriteValue(CessAmount);

        JsonWriter.WritePropertyName('StCesVal');
        // JsonWriter.WriteValue(StateCessAmount);
        JsonWriter.WriteValue(0.0);

        JsonWriter.WritePropertyName('CesNonAdVal');
        JsonWriter.WriteValue(CESSNonAvailmentAmount);

        JsonWriter.WritePropertyName('OthChrg');
        JsonWriter.WriteValue(0.0);


        JsonWriter.WritePropertyName('Disc');
        JsonWriter.WriteValue(DiscountAmount);

        JsonWriter.WritePropertyName('TotInvVal');
        JsonWriter.WriteValue(ABS(TotalInvoiceValue));

        JsonWriter.WriteEndObject();

    end;

    procedure WriteExpDtls(JsonObj1: DotNet JObject; recTransactionHeader: Record 99001472; JsonWriter1: DotNet JsonTextWriter)
    var
        ExportCategory: code[20];
        DocumentAmount: Decimal;
        SalesInvoiceLine: Record "Sales Invoice Line";
        WithPayOfDuty: Code[2];
        ShipmentBillNo: Code[20];
        ExitPort: code[10];
        recTransactionEntryLines: record 99001473;
        ShipmentBillDate: text;
        CurrencyCode: code[3];
        CountryCode: code[2];
        recStore: Record 99001470;
        recLocation: Record 14;
    begin
        if not (recTransactionHeader."LSCIN GST Customer Type" in [
            recTransactionHeader."LSCIN GST Customer Type"::Export,
            recTransactionHeader."LSCIN GST Customer Type"::"Deemed Export",
            recTransactionHeader."LSCIN GST Customer Type"::"SEZ Unit",
            recTransactionHeader."LSCIN GST Customer Type"::"SEZ Development"])
        then
            exit;


        case recTransactionHeader."LSCIN GST Customer Type" of
            recTransactionHeader."LSCIN GST Customer Type"::Export:
                ExportCategory := 'DIR';
            recTransactionHeader."LSCIN GST Customer Type"::"Deemed Export":
                ExportCategory := 'DEM';
            recTransactionHeader."LSCIN GST Customer Type"::"SEZ Unit":
                ExportCategory := 'SEZ';
            recTransactionHeader."LSCIN GST Customer Type"::"SEZ Development":
                ExportCategory := 'SED';
        end;

        // if SalesInvoiceHeader."GST Without Payment of Duty" then
        WithPayOfDuty := 'N';
        // else
        // WithPayOfDuty := 'Y';

        // ShipmentBillNo := CopyStr(SalesInvoiceHeader."Bill Of Export No.", 1, 16);
        // ShipmentBillDate := Format(SalesInvoiceHeader."Bill Of Export Date", 0, '<Year4>-<Month,2>-<Day,2>');
        // ExitPort := SalesInvoiceHeader."Exit Point";

        // SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        // if SalesInvoiceLine.FindSet() then
        //     repeat
        //         DocumentAmount := DocumentAmount + SalesInvoiceLine.Amount;
        //     until SalesInvoiceLine.Next() = 0;

        recTransactionEntryLines.Reset();
        recTransactionEntryLines.SetRange("Store No.", recTransactionHeader."Store No.");
        recTransactionEntryLines.SetRange("POS Terminal No.", recTransactionHeader."POS Terminal No.");
        recTransactionEntryLines.SetRange("Transaction No.", recTransactionHeader."Transaction No.");
        if recTransactionEntryLines.Find('-') then
            repeat
                DocumentAmount += recTransactionEntryLines."Net Amount";
            until recTransactionEntryLines.Next() = 0;

        CurrencyCode := CopyStr(recTransactionHeader."Trans. Currency", 1, 3);
        recStore.get(recTransactionHeader."Store No.");
        CountryCode := CopyStr(recStore."Country Code", 1, 2);

        JsonWriter.WritePropertyName('ExpDtls');
        JsonWriter.WriteStartObject();

        JsonWriter.WritePropertyName('ExpCat');
        JsonWriter.WriteValue(ExportCategory);

        JsonWriter.WritePropertyName('WithPay');
        JsonWriter.WriteValue(WithPayOfDuty);

        JsonWriter.WritePropertyName('ShipBNo');
        JsonWriter.WriteValue(ShipmentBillNo);

        JsonWriter.WritePropertyName('ShipBDt');
        JsonWriter.WriteValue(ShipmentBillDate);

        JsonWriter.WritePropertyName('Port');
        JsonWriter.WriteValue(ExitPort);

        JsonWriter.WritePropertyName('InvForCur');
        JsonWriter.WriteValue(DocumentAmount);

        JsonWriter.WritePropertyName('ForCur');
        JsonWriter.WriteValue(CurrencyCode);

        JsonWriter.WritePropertyName('CntCode');
        JsonWriter.WriteValue(CountryCode);

        JsonWriter.WriteEndObject();
    end;

    procedure CancelSalesE_Invoice(recSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        JsonObj1: DotNet JObject;
        JsonWriter1: DotNet JsonTextWriter;
        jsonString: text;
        jsonObjectlinq: DotNet JObject;
        encryptedIRNPayload: text;
        txtDecryptedSek: text;
        finalPayload: text;
        jsonWriter2: DotNet JsonTextWriter;
        codeReason: Code[2];
        intReasonCOde: Integer;

    begin
        JsonObj1 := JsonObj1.JObject();
        JsonWriter1 := JsonObj1.CreateWriter();

        JsonWriter1.WritePropertyName('Irn');
        JsonWriter1.WriteValue(recSalesInvoiceHeader."IRN Hash");

        // JsonWriter1.WritePropertyName('CnlRsn');
        // Case recSalesInvoiceHeader."E-Invoice Cancel Reason" of
        //     recSalesInvoiceHeader."E-Invoice Cancel Reason"::"Duplicate Order":
        //         codeReason := '1';
        //     recSalesInvoiceHeader."E-Invoice Cancel Reason"::"Data Entry Mistake":
        //         codeReason := '2';
        //     recSalesInvoiceHeader."E-Invoice Cancel Reason"::"Order Cancelled":
        //         codeReason := '3';
        //     recSalesInvoiceHeader."E-Invoice Cancel Reason"::Other:
        //         codeReason := '4';
        // end;
        // // codeReason:
        // JsonWriter1.WriteValue(codeReason);

        // JsonWriter1.WritePropertyName('CnlRem');
        // JsonWriter1.WriteValue(recSalesInvoiceHeader."E-Invoice Cancel Remarks");

        jsonString := JsonObj1.ToString();

        //GenerateAuthToken(recSalesInvoiceHeader);//Auth Token ans Sek stored in Auth Table //IRN Encrypted with decrypted Sek that was decrypted by Appkey(Random 32-bit)

        // recAuthData.Reset();
        // // recAuthData.SetRange(DocumentNum, recSalesInvoiceHeader."No.");//Document number is universal for all documents and both E-Invoice and E-Way Bill 250922
        // if recAuthData.Findlast() then begin


        Message(jsonString);
        jsonObjectlinq := jsonObjectlinq.JObject();
        jsonWriter2 := jsonObjectlinq.CreateWriter();

        jsonWriter2.WritePropertyName('Data');
        jsonWriter2.WriteValue(encryptedIRNPayload);

        finalPayload := jsonObjectlinq.ToString();
        // Message('FinalIRNPayload %1 ', finalPayload);
        // Call_IRN_API(finalPayload, true, transac, false, false);

    end;

    procedure UpdateCancelDetails(txtIRN: Text; CancelDate: Text; recTransactionHeader: record 99001472) //recSIHeader: Record "Sales Invoice Header")
    var
        SIHeader: Record "Sales Invoice Header";
        txtCancelDate: text;
        txtIrncancelled: Boolean;
        TransactionHeader: Record 99001472;

    begin
        // SIHeader.get(recSIHeader."No.");
        // SIHeader."IRN Hash" := txtIRN;
        // txtCancelDate := ConvertAckDt(CancelDate);
        // evaluate(SIHeader."E-Inv. Cancelled Date", txtCancelDate);
        // SIHeader.Modify();
        // SIHeader.get(recSIHeader."No.");
        TransactionHeader.Reset();
        TransactionHeader.SetRange("Receipt No.", recTransactionHeader."Receipt No.");
        if TransactionHeader.FindFirst() then begin
            TransactionHeader."Cancel IRN Hash" := txtIRN;
            txtCancelDate := ConvertAckDt(CancelDate);
            TransactionHeader."Irn Cancelled" := true;
            evaluate(TransactionHeader."Cancel IRN Date", txtCancelDate);
            TransactionHeader.Modify();
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    procedure Create_EInvoiceOnSalesOrderPost(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    var
        recSIHeader: Record "Sales Invoice Header";
        recSalesCrmemHeader: Record "Sales Cr.Memo Header";
    begin
        if GuiAllowed then
            if confirm('Do you want to create E-Invoice ?', true) then begin
                if SalesInvHdrNo <> '' then begin
                    recSIHeader.get(SalesInvHdrNo);
                    // GenerateIRN_01(recSIHeader);
                end;
                /* else
                    if SalesCrMemoHdrNo <> '' then begin
                        recSalesCrmemHeader.get(SalesCrMemoHdrNo);
                        CU_SalesCrEInvoice.GenerateIRN_01(recSalesCrmemHeader);
                    end*/
            end;
    end;

    /*procedure GetIRNDetails_SalesInvoice(SalesHead: Record "Sales Invoice Header")
    var
        jsonwriter1: DotNet JsonTextWriter;
        glHTTPRequest: DotNet HttpWebRequest;
        gluriObj: DotNet Uri;
        JsonString: Text;
        glResponse: DotNet HttpWebResponse;
        GetIRNURL: Label 'https://einv-apisandbox.nic.in/eicore/v1.03/Invoice/irn/';
        glstream: DotNet StreamWriter;
        glreader: DotNet StreamReader;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        jsonObjectlinq: DotNet JObject;
        genledSetup: Record 98;
        recLocation: Record 14;
        txtResponse: Text;
        recGSTRegNos: Record "GST Registration Nos.";
        decryptedIRNResponse: Text;
    begin
        if SalesHead."IRN Hash" = '' then
            Error('Operation cannot be performed as IRN does not exist for Invoice %1', SalesHead."No.");

        // recAuthData.Reset();
        // // recAuthData.SetRange(DocumentNum, SalesHead."No.");//Document number is universal for all documents and both E-Invoice and E-Way Bill 250922
        // if recAuthData.Findlast() then begin
        //     if recAuthData."Auth Token" <> '' then
        //         GenerateAuthToken(SalesHead);
        recAuthData.Reset();
        if recAuthData.Findlast() then begin
            if (recAuthData."Auth Token" <> '') and ((Time > recAuthData."Token Duration") and (recAuthData."Expiry Date" >= Today)) then
                GenerateAuthToken(SalesHead)
            else
                if (recAuthData."Expiry Date" < Today) then
                    GenerateAuthToken(SalesHead)
        end else
            if (recAuthData."Auth Token" = '') then
                GenerateAuthToken(SalesHead);
        recAuthData.Reset();
        if recAuthData.Findlast() then begin

            genledSetup.GET;
            recLocation.get(SalesHead."Location Code");
            recGSTRegNos.Reset();
            recGSTRegNos.SetRange(Code, recLocation."GST Registration No.");
            if recGSTRegNos.FindFirst() then;
            CLEAR(glHTTPRequest);
            servicepointmanager.SecurityProtocol := securityprotocol.Tls12;
            gluriObj := gluriObj.Uri(GetIRNURL + SalesHead."IRN Hash");
            glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
            glHTTPRequest.Headers.Add('gstin', recGSTRegNos.Code);
            glHTTPRequest.Headers.Add('client_id', recGSTRegNos."E-Invoice Client ID");
            glHTTPRequest.Headers.Add('client_secret', recGSTRegNos."E-Invoice Client Secret");
            glHTTPRequest.Headers.Add('user_name', recGSTRegNos."E-Invoice UserName");
            glHTTPRequest.Headers.Add('authtoken', recAuthData."Auth Token");
            glHTTPRequest.Timeout(10000);
            glHTTPRequest.Method := 'GET';
            glHTTPRequest.ContentType := 'application/json; charset=utf-8';
            // glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());
            // glstream.Write(JsonString);
            // glstream.Close();
            glHTTPRequest.Timeout(10000);
            glResponse := glHTTPRequest.GetResponse();
            glHTTPRequest.Timeout(10000);
            glreader := glreader.StreamReader(glResponse.GetResponseStream());
            txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019

            IF glResponse.StatusCode = 200 THEN BEGIN
                signedData := ParseResponse_IRN_ENCRYPT(txtResponse, false, false, false);

                GSTEncrypt := GSTEncrypt.RSA_AES();
                decryptedIRNResponse := GSTEncrypt.DecryptBySymmetricKey(signedData, recAuthData.DecryptedSEK);
                Message(decryptedIRNResponse);//230922
                                              path := 'E:\GST_invoice\file_'+DELCHR(FORMAT(TODAY),'=',char)+'_'+DELCHR(FORMAT(TIME),'=',char)+'.txt';//+FORMAT(TODAY)+FORMAT(TIME)+'.txt';
                                              File.CREATE(path);
                                              File.CREATEOUTSTREAM(Outstr);
                                              Outstr.WRITETEXT(decryptedIRNResponse);
                                              // ParseResponse_IRN_DECRYPT(decryptedIRNResponse, false, false, false, SalesHead);
                glreader.Close();
                glreader.Dispose();
            END
            ELSE
                IF (glResponse.StatusCode <> 200) THEN BEGIN
                    MESSAGE(FORMAT(glResponse.StatusCode));
                    ERROR(glResponse.StatusDescription);
                END;
        end;

    end;

    procedure GetGSTINDetails(SalesHead: Record "Sales Invoice Header")
    var
        jsonwriter1: DotNet JsonTextWriter;
        jsonObjectlinq: DotNet JObject;
        glHTTPRequest: DotNet HttpWebRequest;
        gluriObj: DotNet Uri;
        encryptedIRNPayload: text;
        JsonString: Text;
        glResponse: DotNet HttpWebResponse;
        GetGSTURL: Label 'https://einv-apisandbox.nic.in/eivital/v1.04/Master/gstin/';
        glstream: DotNet StreamWriter;
        glreader: DotNet StreamReader;
        servicepointmanager: DotNet ServicePointManager;
        securityprotocol: DotNet SecurityProtocolType;
        GSTInv_DLL: DotNet GSTEncr_Decr;
        genledSetup: Record 98;
        recLocation: Record 14;
        recGSTRegNos: Record "GST Registration Nos.";
        decryptedIRNResponse: Text;
        finalPayload: text;
        recAuthData: Record "GST E-Invoice(Auth Data)";
        txtDecryptedSek: text;
    begin
        recAuthData.Reset();
        if recAuthData.Findlast() then begin
            if (recAuthData."Auth Token" <> '') and ((Time > recAuthData."Token Duration") and (recAuthData."Expiry Date" >= Today)) then
                GenerateAuthToken(SalesHead)
            else
                if (recAuthData."Expiry Date" < Today) then
                    GenerateAuthToken(SalesHead)
        end else
            // if (recAuthData."Auth Token" = '') then
                GenerateAuthToken(SalesHead);
        recAuthData.Reset();
        if recAuthData.Findlast() then begin
            // recAuthData.Reset();
            // recAuthData.SetRange(DocumentNum, SalesHead."No.");
            // if recAuthData.Findlast() then begin

            genledSetup.GET;
            recLocation.get(SalesHead."Location Code");
            recGSTRegNos.Reset();
            recGSTRegNos.SetRange(Code, recLocation."GST Registration No.");
            if recGSTRegNos.FindFirst() then;
            CLEAR(glHTTPRequest);
            servicepointmanager.SecurityProtocol := securityprotocol.Tls12;
            gluriObj := gluriObj.Uri(GetGSTURL + recLocation."GST Registration No.");
            glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
            glHTTPRequest.Headers.Add('Gstin', recGSTRegNos.Code);
            glHTTPRequest.Headers.Add('client_id', recGSTRegNos."E-Invoice Client ID");
            glHTTPRequest.Headers.Add('client_secret', recGSTRegNos."E-Invoice Client Secret");
            glHTTPRequest.Headers.Add('user_name', recGSTRegNos."E-Invoice UserName");
            glHTTPRequest.Headers.Add('AuthToken', recAuthData."Auth Token");
            glHTTPRequest.Timeout(10000);
            glHTTPRequest.Method := 'GET';
            glHTTPRequest.ContentType := 'application/json; charset=utf-8';
            // glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());
            // glstream.Write(JsonString);
            // glstream.Close();
            glHTTPRequest.Timeout(10000);
            glResponse := glHTTPRequest.GetResponse();
            glHTTPRequest.Timeout(10000);
            glreader := glreader.StreamReader(glResponse.GetResponseStream());
            //  txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019

            IF glResponse.StatusCode = 200 THEN BEGIN
                signedData := ParseResponse_IRN_ENCRYPT(glreader.ReadToEnd, false, false, false);

                GSTInv_DLL := GSTInv_DLL.RSA_AES();
                decryptedIRNResponse := GSTInv_DLL.DecryptBySymmetricKey(signedData, recAuthData.DecryptedSEK);
                Message('GSTIN Details are %1', decryptedIRNResponse);//240922

                path := 'E:\GST_invoice\file_'+DELCHR(FORMAT(TODAY),'=',char)+'_'+DELCHR(FORMAT(TIME),'=',char)+'.txt';//+FORMAT(TODAY)+FORMAT(TIME)+'.txt';
                File.CREATE(path);
                File.CREATEOUTSTREAM(Outstr);
                Outstr.WRITETEXT(decryptedIRNResponse);
                // ParseResponse_GETGSTINDetails_Decrypt(decryptedIRNResponse, SalesHead);
                glreader.Close();
                glreader.Dispose();
            end else
                if (glResponse.StatusCode <> 200) then begin
                    MESSAGE(FORMAT(glResponse.StatusCode));
                    ERROR(glResponse.StatusDescription);
                end;
        end;
    end;


    procedure ParseResponse_GETDetails_Encrypt(TextResponse: text; SIHeader: Record "Sales Invoice Header"): text;
    var
        message1: text;
        CurrentObject: text;
        CurrentElement: text;
        ValuePair: text;
        FormatChar: label '{}';
        CurrentValue: text;
        txtStatus: text;
        p: Integer;
        x: Integer;
        recAuthData: Record "GST E-Invoice(Auth Data)";
        l: Integer;
        txtError: text;
        txtData: text;
        errPOS: Integer;
        txtInfoDtls: text;
        encoding: DotNet Encoding;
        txtExpiry: text;
        bytearr: DotNet Array;
        PlainSEK: text;
    begin
        CLEAR(message1);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;
        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;
        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        // MESSAGE(TextResponse);
        errPOS := STRPOS(TextResponse, '"Status":0');
        IF errPOS > 0 THEN
            ERROR('Error while fetching GSTIN Detils : %1', TextResponse);
        //no response

        // CurrentObject := COPYSTR(TextResponse,STRPOS(TextResponse,'{')+1,STRPOS(TextResponse,':'));
        // TextResponse := COPYSTR(TextResponse,STRLEN(CurrentObject)+1);

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');
                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');
                CASE CurrentElement OF
                    'status':
                        BEGIN
                            txtStatus := CurrentValue;
                        END;
                    'data':
                        BEGIN
                            txtData := CurrentValue;
                        END;
                    'ErrorDetails':
                        BEGIN
                            txtError := CurrentValue;
                        END;
                    'InfoDtls':
                        BEGIN
                            txtInfoDtls := CurrentValue;
                        END;
                END;

            END;
            x := x + 1;
        END;
        exit(txtData);
    END;

    procedure ParseResponse_GETGSTINDetails_Decrypt(TextResponse: text; SIHeader: Record "Sales Invoice Header"): text;
    var
        message1: text;
        CurrentObject: text;
        CurrentElement: text;
        ValuePair: text;
        PlainSEK: text;
        GSTIn_DLL: DotNet GSTEncr_Decr;
        FormatChar: label '{}';
        CurrentValue: text;
        p: Integer;
        x: Integer;
        Addr1: text;
        Addr2: text;
        Addr3: text;
        Addr4: text;
        Addr5: text;
        StateCode: Code[15];
        recAuthData: Record "GST E-Invoice(Auth Data)";
        l: Integer;
        lglName: text;
        errPOS: Integer;
        encoding: DotNet Encoding;
        Gstin: code[20];
        txtError: Text;
        bytearr: DotNet Array;
        Status: Code[10];
        DtRegd: Code[20];
        DtDReg: Code[20];
    begin
        Message(TextResponse);//240922 Message to be details 

        CLEAR(message1);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;

        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        // MESSAGE(TextResponse);
        errPOS := STRPOS(TextResponse, '"Status":0');
        IF errPOS > 0 THEN
            ERROR('Error while fetching GSTIN Detils : %1', TextResponse);
        //no response

        // CurrentObject := COPYSTR(TextResponse,STRPOS(TextResponse,'{')+1,STRPOS(TextResponse,':'));
        // TextResponse := COPYSTR(TextResponse,STRLEN(CurrentObject)+1);

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);

        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');

                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');

                CASE CurrentElement OF
                    'Gstin':
                        BEGIN
                            Gstin := CurrentValue;
                        END;
                    'TradeName':
                        BEGIN
                            txtError := CurrentValue;
                        END;
                    'LegalName':
                        BEGIN
                            lglName := CurrentValue;
                            // Message('AuthToke %1', txtAuthT);
                        END;
                    'AddrBnm':
                        BEGIN
                            Addr1 := CurrentValue;
                            // Message('EncryptedSEK %1', txtEncSEK);
                        END;
                    'AddrBno':
                        BEGIN
                            Addr2 := CurrentValue;
                        END;
                    'AddrFlno':
                        begin
                            Addr3 := CurrentValue;
                        end;
                    'AddrSt':
                        begin
                            Addr4 := CurrentValue;
                        end;
                    'AddrLoc':
                        begin
                            Addr5 := CurrentValue;
                        end;
                    'StateCode':
                        begin
                            StateCode := CurrentValue;
                        end;
                    'Status':
                        begin
                            Status := CurrentValue;
                        end;
                    'BlkStatus':
                        begin

                        end;
                    'DtReg':
                        begin
                            DtRegd := CurrentValue;
                        end;
                    'DtDReg':
                        begin
                            DtDReg := CurrentValue;
                        end;
                END;
            END;
            x := x + 1;
        END;

    end;*/

    var
        myInt: Integer;
        JsonText: Text;
        IsInvoice: Boolean;
        DocumentNo: Text[20];
        SalesLineErr: Label 'E-Invoice allowes only 100 lines per Invoice. Curent transaction is having %1 lines.', Locked = true;

        JsonWriter: DotNet JsonTextWriter;
        GlobalNULL: Variant;
        CGSTLbl: Label 'CGST', Locked = true;
        SGSTLbl: label 'SGST', Locked = true;
        IGSTLbl: Label 'IGST', Locked = true;
        CESSLbl: Label 'CESS', Locked = true;
        // BBQ_GSTIN: Label '29AAKCS3053N1ZS', Locked = true;
        gl_BillToPh: Code[20];
        OTHTxt: Label 'OTH';

        // GSTIN: Label '29AAKCS3053N1ZS', locked = true;
        signedData: text;
        // clientID: Label 'AAKCS29TXP3G937', Locked = true;
        // clientSecret: Label 'xDdRrf6L0Zzn42HhVvAP', locked = true;
        // userName: Label 'BBQBLR', Locked = true;
        gl_BillToEm: Text[100];
        // JsonLObj: DotNet JObject;
        JsonLObj: DotNet JObject;
        // DocumentNoBlankErr: Label 'Document No. Blank';
        DocumentNoBlankErr: Label 'Document No. Blank';
        JsonObject: JsonObject;
}
