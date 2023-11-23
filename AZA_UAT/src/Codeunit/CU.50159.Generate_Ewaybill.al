codeunit 50159 Generate_Ewaybill
{
    trigger OnRun()
    begin

    end;

    var
        SalesInvHeader: Record "Transfer Shipment Header";
        HasIncomingDocument: Boolean;
        DocExchStatusStyle: Text;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        // RecTSH: Record "112";
        SalesPersonName: Text[50];
        // RecSP: Record "13";
        // RSIH: Record "112";
        // "--------------------------": Integer;
        GlobalNULL: Variant;
        BinaryWriter: DotNet BinaryWriter;
        BinaryReader: DotNet BinaryReader;
        bbbb: Text;
        RecLocation: Record Location;
        // GSTManagement: Codeunit "16401";
        LRNo: Text;
        lrDate: Text;
        mont: Text;
        PDate: Text;
        Dt: Text;
        JsonString: Text;
        GSTEInvoice: Codeunit "Json Creation E-invoice";
        // recAuthData: Record "50037";
        recGSTRegNos: Record "GST Registration Nos.";
        genledSetup: Record "General Ledger Setup";
        glHTTPRequest: DotNet HttpWebRequest;
        gluriObj: DotNet Uri;
        glstream: DotNet StreamWriter;
        glJsonString: Text;
        glResponse: DotNet HttpWebResponse;
        glreader: DotNet StreamReader;
        txtResponse: Text;
        servicepointmanager: DotNet ServicePointManager;
        signedData: Text;
        decryptedIRNResponse: Text;
        cnlrem: Text;

    local procedure "Generate E-Way-BillByIRN"(Var SalesInvHdr: Record "Transfer Shipment Header")
    var
        ServicePointManger: DotNet ServicePointManager;
        SecurityProtocol: DotNet SecurityProtocolType;
        // XMLDoc: Automation ;
        xmlText: Text;
        MyFile: File;
        MyOutStream: OutStream;
        xml: DotNet XmlDocument;
        uriObj: DotNet Uri;
        PrefixArray: DotNet Array;
        DataString: DotNet String;
        DataArray: array[500] of Boolean;
        StringReader: DotNet StringReader;
        PropertyName: Text;
        Jsonuri: Text[1024];
        RequestVar: Text[1024];
        CRLF: Text[2];
        WinHttpService: DotNet HttpWebRequest;
        sb: DotNet StringBuilder;
        stream: DotNet StreamWriter;
        lgResponse: DotNet HttpWebResponse;
        credentials: DotNet CredentialCache;
        reader: DotNet StreamReader;
        responsetext: Text[1024];
        hdrNode: DotNet XmlNode;
        ChildNode: DotNet XmlNode;
        ItemNode: DotNet XmlNode;
        recItem: Record Item;
        str: Text;
        JObject: DotNet JObject;
        i: Integer;
        JObject1: DotNet JObject;
        ParsedJson: Text;
        gspappid: Text;
        gspappsecret: Text;
        // headersg: DotNet HttpRequestHeader;
        //SalesInvHdr: Record "Transfer Shipment Header";
        Ackdatetime: DateTime;
        ShippingAgent: Record "Shipping Agent";
        TransID: Text;
        TransName: Text;
        TransMode: Text;
        Distance: Integer;
        VehNo: Text;
        VehType: Text;
        JsonTextWriter: DotNet JsonTextWriter;
        StringWriter: DotNet StringWriter;
        JsonFormatting: DotNet Formatting;
        Ewaybilldatetxt: Text;
        Ewaybilldate: DateTime;
        Ewaybilldatevalidtxt: Text;
        Ewaybilldatevalid: DateTime;
    begin
        // GSTEInvoice.GenerateAuthPayload(Rec."No.",TRUE);//Auth Token stored
        // recAuthData.RESET;
        // recAuthData.SETCURRENTKEY("Sr No.");
        // recAuthData.SETFILTER(DocumentNum,'=%1',Rec."No.");
        // IF recAuthData.FINDLAST THEN;


        IF ShippingAgent.GET(SalesInvHdr."Shipping Agent Code") THEN BEGIN
            TransID := ShippingAgent."GST Registration No.";
            TransName := ShippingAgent.Name;
            TransMode := SalesInvHdr."Transport Method";
            Distance := SalesInvHdr."Distance (Km)";//ROUND("Distance (Km)",1,'=')
            VehNo := SalesInvHdr."Vehicle No.";
            LRNo := SalesInvHdr."LR/RR No.";

            IF STRLEN(FORMAT(SalesInvHdr."LR/RR Date")) > 1 THEN BEGIN
                Dt := FORMAT(DATE2DMY(SalesInvHdr."LR/RR Date", 1));
                IF STRLEN(Dt) <> 2 THEN
                    Dt := '0' + Dt;
                mont := FORMAT(DATE2DMY(SalesInvHdr."LR/RR Date", 2));
                IF STRLEN(mont) <> 2 THEN
                    mont := '0' + mont;

                lrDate := Dt + '/' + mont + '/' + FORMAT(DATE2DMY(SalesInvHdr."LR/RR Date", 3));
            END;

            IF SalesInvHdr."Vehicle Type" <> SalesInvHdr."Vehicle Type"::" " THEN
                IF SalesInvHdr."Vehicle Type" = SalesInvHdr."Vehicle Type"::ODC THEN
                    VehType := 'O'
                ELSE
                    VehType := 'R'
            ELSE
                VehType := '';
        END;
        sb := sb.StringBuilder;
        StringWriter := StringWriter.StringWriter(sb);
        JsonTextWriter := JsonTextWriter.JsonTextWriter(StringWriter);
        JsonTextWriter.Formatting := JsonFormatting.Indented;

        JsonTextWriter.WriteStartObject;
        JsonTextWriter.WritePropertyName('irn');
        JsonTextWriter.WriteValue(SalesInvHdr."IRN Hash");
        //JsonTextWriter.WriteValue('299c29db7d215a62beb0faee4053f2cb90d9a6327bd8f44e49ad6ee5b52c38a3');
        //JsonTextWriter.WriteValue('3b22d124cdabc2f471db988972c86834a8e393e79760a967678886c9f57b2121');
        JsonTextWriter.WritePropertyName('TransId');
        JsonTextWriter.WriteValue(TransID);

        JsonTextWriter.WritePropertyName('TransName');
        JsonTextWriter.WriteValue(TransName);
        JsonTextWriter.WritePropertyName('Distance');
        JsonTextWriter.WriteValue(Distance);
        IF LRNo <> '' THEN BEGIN
            JsonTextWriter.WritePropertyName('TransDocNo');
            JsonTextWriter.WriteValue(LRNo);
            JsonTextWriter.WritePropertyName('TransDocDt');
            JsonTextWriter.WriteValue(lrDate);
        END;
        JsonTextWriter.WritePropertyName('VehNo');
        JsonTextWriter.WriteValue(VehNo);

        JsonTextWriter.WritePropertyName('VehType');
        JsonTextWriter.WriteValue(VehType);
        JsonTextWriter.WritePropertyName('TransMode');
        JsonTextWriter.WriteValue(TransMode);
        JsonTextWriter.WriteEndObject;
        JsonTextWriter.Flush;
        MESSAGE('%1', sb.ToString());
        //WinHttpService.Timeout := 120000;
        //stream := stream.StreamWriter(WinHttpService.GetRequestStream());
        //stream.Write(sb.ToString());
        //stream.Close();



        RecLocation.GET(SalesInvHdr."Transfer-to Code");//Nkp--CCIT
        recGSTRegNos.GET(RecLocation."GST Registration No.");
        CLEAR(GlobalNULL);
        //Jsonuri := 'https://botstore.lemontechnologies.net/api/v2/generate_invoice_e_way_bill_api/';

        genledSetup.GET;
        CLEAR(glHTTPRequest);
        //servicepointmanager.SecurityProtocol := SecurityProtocol.Tls12;
        gluriObj := gluriObj.Uri(genledSetup."E_Way Bill URL");
        //gluriObj := gluriObj.Uri(Jsonuri);
        // glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
        // // glHTTPRequest.Headers.Add('Authorization',recAuthData."Auth Token");//Nkp
        // glHTTPRequest.Headers.Add('gstin', recGSTRegNos.Code);//Live
        // //  glHTTPRequest.Headers.Add('gstin','27ABFPD4021L002');//Sandbox
        // glHTTPRequest.KeepAlive := TRUE;
        // glHTTPRequest.Timeout(10000);
        // glHTTPRequest.Method := 'POST';
        // glHTTPRequest.ContentType := 'application/json; charset=utf-8';
        // glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());
        // glstream.Write(sb.ToString());
        // glstream.Close();
        // glHTTPRequest.Timeout(10000);
        // glResponse := glHTTPRequest.GetResponse();
        // glHTTPRequest.Timeout(10000);
        // glreader := glreader.StreamReader(glResponse.GetResponseStream());
        // txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019

        // IF glResponse.StatusCode = 200 THEN BEGIN
        //     //MESSAGE(txtResponse);
        //     ParseResponse_EWAYBILL_DECRYPT(txtResponse, SalesInvHdr."No.", TRUE);

        // END ELSE
        //     ERROR('Error ' + lgResponse.StatusDescription + '   ' + responsetext);
        // //    MESSAGE('Done..'
        // COMMIT;
    end;

    local procedure "Cancel E-Way-Bill"()
    var
        ServicePointManger: DotNet ServicePointManager;
        SecurityProtocol: DotNet SecurityProtocolType;
        //  XMLDoc: Automation ;
        xmlText: Text;
        MyFile: File;
        MyOutStream: OutStream;
        xml: DotNet XmlDocument;
        uriObj: DotNet Uri;
        PrefixArray: DotNet Array;
        DataString: DotNet String;
        DataArray: array[500] of Boolean;
        StringReader: DotNet StringReader;
        PropertyName: Text;
        Jsonuri: Text[1024];
        RequestVar: Text[1024];
        CRLF: Text[2];
        WinHttpService: DotNet HttpWebRequest;
        sb: DotNet StringBuilder;
        stream: DotNet StreamWriter;
        credentials: DotNet CredentialCache;
        glResponse: DotNet HttpWebResponse;
        reader: DotNet StreamReader;
        responsetext: Text[1024];
        hdrNode: DotNet XmlNode;
        ChildNode: DotNet XmlNode;
        ItemNode: DotNet XmlNode;
        recItem: Record Item;
        str: Text;
        JObject: DotNet JObject;
        i: Integer;
        JObject1: DotNet JObject;
        ParsedJson: Text;
        gspappid: Text;
        gspappsecret: Text;
        //  headersg: DotNet HttpRequestHeader;
        SalesInvHdr: Record "Transfer Shipment Header";
        Ackdatetime: DateTime;
        StringWriter: DotNet StringWriter;
        JsonTextWriter: DotNet JsonTextWriter;
        JsonFormatting: DotNet Formatting;
    begin
        // GSTEInvoice.GenerateAuthPayload(Rec."No.",TRUE);//Auth Token stored
        // recAuthData.RESET;
        // recAuthData.SETCURRENTKEY("Sr No.");
        // recAuthData.SETFILTER(DocumentNum,'=%1',Rec."No.");
        // IF recAuthData.FINDLAST THEN;


        sb := sb.StringBuilder;
        StringWriter := StringWriter.StringWriter(sb);
        JsonTextWriter := JsonTextWriter.JsonTextWriter(StringWriter);
        JsonTextWriter.Formatting := JsonFormatting.Indented;
        cnlrem := 'Cancelled the order';

        JsonTextWriter.WriteStartObject;
        JsonTextWriter.WritePropertyName('ewayBillNo');
        JsonTextWriter.WriteValue(SalesInvHdr."E-Way Bill No.");
        JsonTextWriter.WritePropertyName('cancelRmrk');
        JsonTextWriter.WriteValue(cnlrem);
        JsonTextWriter.WriteEndObject;
        JsonTextWriter.Flush;
        MESSAGE('%1', sb.ToString());
        //WinHttpService.Timeout := 120000;
        //stream := stream.StreamWriter(WinHttpService.GetRequestStream());
        //stream.Write(sb.ToString());
        //stream.Close();

        RecLocation.GET(SalesInvHdr."Transfer-from Code");//Nkp--CCIt
        //Jsonuri := 'https://botstore.lemontechnologies.net/api/v1/cancel_ewb_api/';

        genledSetup.GET;
        CLEAR(glHTTPRequest);
        servicepointmanager.SecurityProtocol := SecurityProtocol.Tls12;
        gluriObj := gluriObj.Uri(genledSetup."Cancel E-Way Bill");//"Cancel Eway Bill URL"
        //gluriObj := gluriObj.Uri(Jsonuri);
        glHTTPRequest := glHTTPRequest.CreateDefault(gluriObj);
        // glHTTPRequest.Headers.Add('Authorization',recAuthData."Auth Token");//Nkp
        //glHTTPRequest.Headers.Add('gstin',recGSTRegNos.Code);//Live
        glHTTPRequest.Headers.Add('gstin', '27ABFPD4021L002');//Sandbox
        glHTTPRequest.KeepAlive := TRUE;
        glHTTPRequest.Timeout(10000);
        glHTTPRequest.Method := 'POST';
        glHTTPRequest.ContentType := 'application/json; charset=utf-8';
        glstream := glstream.StreamWriter(glHTTPRequest.GetRequestStream());
        glstream.Write(sb.ToString());
        glstream.Close();
        glHTTPRequest.Timeout(10000);
        glResponse := glHTTPRequest.GetResponse();
        glHTTPRequest.Timeout(10000);
        glreader := glreader.StreamReader(glResponse.GetResponseStream());
        txtResponse := glreader.ReadToEnd;//Response Length exceeds the max. allowed text length in Navision 19092019

        IF glResponse.StatusCode = 200 THEN BEGIN
            ParseResponse_EWAYBILL_CANCEL_DECRYPT(txtResponse, SalesInvHdr."No.", TRUE);
        END ELSE
            ERROR('Error ' + glResponse.StatusDescription + '   ' + responsetext);
        //    MESSAGE('Done..'
        COMMIT;
    end;

    local procedure ParseResponse_EWAYBILL_DECRYPT(TextResponse: Text; DocumentNumber: Code[70]; IsInvoice: Boolean): Text
    var
        txtInfodDtls: Text;
        txtSignedData: Text;
        txtError: Text;
        //recAuthData: Record "50037";
        message1: Text;
        CurrentObject: Text;
        p: Integer;
        x: Integer;
        l: Integer;
        ValuePair: Text;
        CurrentElement: Text;
        FormatChar: Label '{}';
        CurrentValue: Text;
        txtAckNum: Text;
        txtAckDate: Text;
        txtIRN: Text;
        txtSignedInvoice: Text;
        txtSignedQR: Text;
        txtEWBNum: Text;
        txtEWBDt: Text;
        txtEWBValid: Text;
        txtRemarks: Text;
        recSIHead: Record "Transfer Shipment Header";
        txtStatus: Text;
        recSalesCrMemo: Record "Sales Cr.Memo Header";
        SalesInvHdr: Record "Transfer Shipment Header";
        txtErrorMsg: Text;
        BillDateTime: Text;
        temptxteno: Text;
        ValidUptoDateTime: Text;
    begin
        //Get value from Json Response >>

        //CLEAR(message1);
        //MESSAGE(TextResponse);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;

        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        // MESSAGE(TextResponse);
        // EXIT;

        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');
                CurrentElement := DELCHR(CurrentElement, '=', ' ');

                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');
                CurrentValue := DELCHR(CurrentValue, '=', ' ');

                CASE CurrentElement OF
                    'Status':
                        BEGIN
                            txtStatus := CurrentValue;
                        END;
                    'ErrorDetails':
                        BEGIN
                            txtError := CurrentValue;
                        END;
                    'Data':
                        BEGIN
                            temptxteno := DELCHR(CurrentValue, '=', 'EwbNo');
                            txtEWBNum := temptxteno;
                        END;
                    'EwbDt':
                        BEGIN
                            txtEWBDt := CurrentValue;
                        END;
                    'EwbValidTill':
                        BEGIN
                            txtEWBValid := CurrentValue;
                        END;
                    'ErrorMessage':
                        BEGIN
                            txtErrorMsg := CurrentValue;
                        END;
                END;
            END;
            x := x + 1;
        END;

        IF txtStatus = '1' THEN BEGIN
            SalesInvHdr.RESET();
            SalesInvHdr.SETRANGE(SalesInvHdr."No.", SalesInvHdr."No.");
            IF SalesInvHdr.FIND('-') THEN BEGIN
                SalesInvHdr."E-Way Bill No." := txtEWBNum;
                //  SalesInvHdr."E-Way Bill DateTime" := GetDT(txtEWBDt);//Naveen
                // SalesInvHdr."E-Way Bill Valid Upto" := GetDT(txtEWBValid);
                SalesInvHdr."E-Way Bill DateTime" := txtEWBDt;//Naveen
                SalesInvHdr."E-Way Bill Valid Upto" := txtEWBValid;

                /*BillDateTime := ConvertDt(txtEWBDt);
                EVALUATE(SalesInvHdr."E-Way Bill DateTime",BillDateTime);
                ValidUptoDateTime := ConvertDt(txtEWBValid);
                EVALUATE(SalesInvHdr."E-Way Bill Valid Upto",ValidUptoDateTime);*/
                SalesInvHdr.MODIFY;
            END;
        END ELSE
            IF txtStatus = '0' THEN
                ERROR('Error : %1', TextResponse);

    end;

    local procedure ParseResponse_EWAYBILL_CANCEL_DECRYPT(TextResponse: Text; DocumentNumber: Code[70]; IsInvoice: Boolean): Text
    var
        txtInfodDtls: Text;
        txtSignedData: Text;
        txtError: Text;
        //  recAuthData: Record "50037";
        message1: Text;
        CurrentObject: Text;
        p: Integer;
        x: Integer;
        l: Integer;
        ValuePair: Text;
        CurrentElement: Text;
        FormatChar: Label '{}';
        CurrentValue: Text;
        txtAckNum: Text;
        txtAckDate: Text;
        txtIRN: Text;
        txtSignedInvoice: Text;
        txtSignedQR: Text;
        txtEWBNum: Text;
        txtEWBDt: Text;
        txtEWBValid: Text;
        txtRemarks: Text;
        recSIHead: Record "Transfer Shipment Header";
        txtStatus: Text;
        recSalesCrMemo: Record "Sales Cr.Memo Header";
        SalesInvHdr: Record "Transfer Shipment Header";
        txtErrorMsg: Text;
        tempewaybillno: Text;
    begin
        //Get value from Json Response >>

        //CLEAR(message1);
        //MESSAGE(TextResponse);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;

        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        // MESSAGE(TextResponse);
        // EXIT;

        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');
                CurrentElement := DELCHR(CurrentElement, '=', ' ');

                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');
                CurrentValue := DELCHR(CurrentValue, '=', ' ');

                CASE CurrentElement OF
                    'status':
                        BEGIN
                            txtStatus := CurrentValue;
                        END;
                    'ErrorDetails':
                        BEGIN
                            txtError := CurrentValue;
                        END;
                    'Data':
                        BEGIN
                            tempewaybillno := DELCHR(CurrentValue, '=', 'ewayBillNo');
                            txtEWBNum := tempewaybillno;
                        END;
                    'cancelDate':
                        BEGIN
                            txtEWBDt := CurrentValue;
                        END;
                    'error':
                        BEGIN
                            txtErrorMsg := CurrentValue;
                        END;
                END;
            END;
            x := x + 1;
        END;

        IF txtStatus = '1' THEN BEGIN
            MESSAGE('Cancel Successfully : E-Way Bill No. : %1 ,Date : %2', txtEWBNum, txtEWBDt);
            SalesInvHdr.RESET();
            SalesInvHdr.SETRANGE(SalesInvHdr."No.", SalesInvHdr."No.");
            IF SalesInvHdr.FIND('-') THEN BEGIN
                SalesInvHdr."E-Way Bill No." := '';
                //  SalesInvHdr."E-Way Bill DateTime" := 0DT;
                // SalesInvHdr."E-Way Bill Valid Upto" := 0DT;
                SalesInvHdr."E-Way Bill DateTime" := '';
                SalesInvHdr."E-Way Bill Valid Upto" := '';
                SalesInvHdr.MODIFY;
            END;
        END
        ELSE
            IF txtStatus = '0' THEN
                ERROR('Error : %1', TextResponse);
    end;

    local procedure ConvertDt(AckDt2: Text): Text
    var
        YYYY: Text;
        MM: Text;
        DD: Text;
        DateTime: Text;
        DT: Text;
    begin
        YYYY := COPYSTR(AckDt2, 1, 4);
        MM := COPYSTR(AckDt2, 6, 2);
        DD := COPYSTR(AckDt2, 9, 2);

        // TIME := COPYSTR(AckDt2,12,8);

        //DateTime := DD + '-' + MM + '-' + YYYY + ' ' + COPYSTR(AckDt2,11,8);
        DT := DD + '/' + MM + '/' + YYYY;
        EXIT(DT);
    end;

    local procedure GetDT(InputString: Text[30]) YourDT: DateTime
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
        TheTime: Time;
    begin

        EVALUATE(Day, COPYSTR(InputString, 9, 2));  //2021-10-25192500
        EVALUATE(Month, COPYSTR(InputString, 6, 2));
        EVALUATE(Year, COPYSTR(InputString, 1, 4));
        EVALUATE(TheTime, COPYSTR(InputString, 11, 6));
        YourDT := CREATEDATETIME(DMY2DATE(Day, Month, Year), TheTime);


        /*EVALUATE(Day, COPYSTR(InputString,1,2));
        EVALUATE(Month, COPYSTR(InputString,4,2));
        EVALUATE(Year, COPYSTR(InputString,7,2));
        EVALUATE(TheTime, COPYSTR(InputString,12,8));
        YourDT := FORMAT(Day)+'-'+FORMAT(Month)+'-'+FORMAT(Year); */

    end;
}
