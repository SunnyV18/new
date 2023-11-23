dotnet
{
    assembly("System")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Net.HttpStatusCode"; HttpStatusCode)
        {
        }
        type("System.Collections.Specialized.NameValueCollection"; ResponseHeader)
        {
        }
    }
}
codeunit 50156 "E-Invoice Creation"
{
    Permissions = TableData 112 = rimd,
                  TableData 113 = rimd,
                  tabledata 5744 = rimd;

    //TableData 50030=rimd;

    trigger OnRun()
    begin

    end;

    var
        RecCust: Record 18;
        RecCust2: Record 18;
        //Tab50017: Record 50017;
        Tab5802: Record 5802;
        recGeneralLedSet: Record 98;
        Url: Text;
        Json: Text;
        // Httpclint: HttpClient;
        // HttpContnt: HttpContent;
        // HttpResponseMsg: HttpResponseMessage;
        // HttpHdr: HttpHeaders;
        REGAccessLevelEnum: Codeunit 8;
        PostUrl: Text;
        Params: Text;
        JObject: JsonObject;
        Registration: Record 3;
        ApiResult: Text;
        // TempBlob: Codeunit Temp Blob;
        // RequestBlob: Codeunit Temp Blob;
        Instr: InStream;
        body: Text;
        jsonobj: Integer;
        AuthToken: Text;
        PostedInv: Record 112;
        EWBNo: Text;
        Position1: Integer;
        MainResult: Text;
        Position2: Integer;
        EWBDate: Text;
        Position3: Integer;
        EWBValid: Text;
        Position4: Integer;
        EWBCancleDate: Text;
        //rec50021: Record 50021;
        jtoken: JsonToken;

    local procedure OldCOde()
    begin
    end;

    procedure GenerateAuthToken(ClientId: Text; ClientSecret: Text): Text
    var
        AuthUrl: Text;
        AuthJson: Text;
        AuthHttpclint: HttpClient;
        AuthHttpContnt: HttpContent;
        AuthHttpResponseMsg: HttpResponseMessage;
        AuthHttpHdr: HttpHeaders;
        AuthREGAccessLevelEnum: Codeunit 8;
        AuthPostUrl: Text;
        AuthParams: Text;
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        AuthJObject: JsonObject;
        AuthRegistration: Record 3;
        AuthApiResult: Text;
        // AuthTempBlob: Record 99008535;
        // AuthRequestBlob: Record 99008535;
        AuthInstr: InStream;
        Authbody: Text;
        recGeneralLedSetup: Record 98;
        Authjsonobj: Integer;
        AuthToken: Text;
        AuthJsonToken: JsonToken;
        Issuccess: Boolean;
    begin
        // recGeneralLedSetup.Get();
        // AuthPostUrl := recGeneralLedSetup."E-Invoice Auth URL";
        // AuthHttpContnt.GetHeaders(AuthHttpHdr);
        // AuthHttpHdr.Add('gspappid', ClientId);
        // AuthHttpHdr.Add('gspappsecret', ClientSecret);
        // AuthHttpHdr.Remove('Content-Type');
        // AuthHttpHdr.Add('Content-Type', 'application/json');
        // AuthHttpHdr.Remove('Return-Type');
        // AuthHttpHdr.Add('Return-Type', 'application/json');
        // AuthHttpclint.Timeout(60000 * 3);
        // if AuthHttpclint.Post(AuthPostUrl, AuthHttpContnt, AuthHttpResponseMsg) then begin
        //>>
        recGeneralLedSetup.Get();
        AuthPostUrl := 'https://gsp.adaequare.com/gsp/authenticate?action=GSP&grant_type=token';//recGeneralLedSetup."E-Invoice Auth URL";
        AuthHttpContnt.GetHeaders(AuthHttpHdr);
        AuthHttpHdr.Remove('Content-Type');
        AuthHttpHdr.Add('gspappid', ClientId);
        AuthHttpHdr.Add('gspappsecret', ClientSecret);
        Request.Method := 'POST';
        Request.SetRequestUri(AuthPostUrl);
        Request.Content(AuthHttpContnt);

        if Client.Send(Request, Response) then
            if Response.IsSuccessStatusCode() then begin
                if Response.Content.ReadAs(AuthApiResult) then;
            end else
                if Response.Content.ReadAs(AuthApiResult) then;
        //>>
        // AuthHttpResponseMsg.Content.ReadAs(AuthApiResult);
        IF AuthApiResult <> '' THEN BEGIN
            //MESSAGE(AuthApiResult);
            AuthJObject.ReadFrom(AuthApiResult);


            IF AuthJObject.Get('access_token', jtoken) THEN BEGIN

                AuthToken := jtoken.AsValue().AsText();
                EXIT(AuthToken);
                Message(AuthToken);
            end else
                Message('Error during authentication %1', AuthApiResult);
        END;

        // END ELSE
        //     MESSAGE('2' + 'Error when connecting API');
    end;
    // var
    //     AuthUrl: Text;
    //     AuthJson: Text;
    //     AuthHttpclint: HttpClient;
    //     AuthHttpContnt: HttpContent;
    //     AuthHttpResponseMsg: HttpResponseMessage;
    //     AuthHttpHdr: HttpHeaders;
    //     AuthREGAccessLevelEnum: Codeunit 8;
    //     AuthPostUrl: Text;
    //     AuthParams: Text;

    //     AuthJObject: JsonObject;
    //     AuthRegistration: Record 3;
    //     AuthApiResult: Text;
    //     // AuthTempBlob: Record 99008535;
    //     // AuthRequestBlob: Record 99008535;
    //     AuthInstr: InStream;
    //     Authbody: Text;
    //     recGeneralLedSetup: Record 98;
    //     Authjsonobj: Integer;
    //     AuthToken: Text;
    //     AuthJsonToken: JsonToken;
    // begin
    //     recGeneralLedSetup.Get();
    //     AuthPostUrl := recGeneralLedSetup."E-Invoice Auth URL";
    //     AuthHttpContnt.GetHeaders(AuthHttpHdr);
    //     AuthHttpHdr.Add('gspappid', ClientId);
    //     AuthHttpHdr.Add('gspappsecret', ClientSecret);
    //     AuthHttpHdr.Remove('Content-Type');
    //     AuthHttpHdr.Add('Content-Type', 'application/json');
    //     AuthHttpHdr.Remove('Return-Type');
    //     AuthHttpHdr.Add('Return-Type', 'application/json');
    //     AuthHttpclint.Timeout(60000 * 3);
    //     if AuthHttpclint.Post(AuthPostUrl, AuthHttpContnt, AuthHttpResponseMsg) then begin

    //         AuthHttpResponseMsg.Content.ReadAs(AuthApiResult);
    //         IF AuthApiResult <> '' THEN BEGIN
    //             // MESSAGE(AuthApiResult);
    //             AuthJObject.ReadFrom(AuthApiResult);


    //             IF AuthJObject.Get('access_token', jtoken) THEN BEGIN

    //                 AuthToken := jtoken.AsValue().AsText();
    //                 EXIT(AuthToken);
    //             end else
    //                 Message('Error during authentication %1', AuthApiResult);
    //         END;

    //     END ELSE
    //         MESSAGE('2' + 'Error when connecting API');
    // end;

    procedure GenerateIRN(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; var TransferShipmentHdr: Record 5744)
    var

        IRNUrl: Text;
        IRNJson: Text;
        IRNHttpclint: HttpClient;
        IRNHttpContnt: HttpContent;
        IRNHttpResponseMsg: HttpResponseMessage;
        IRNHttpHdr: HttpHeaders;
        IRNREGAccessLevelEnum: Codeunit 8;
        IRNPostUrl: Text;
        IRNParams: Text;
        IRNJObject: JsonObject;
        IRNRegistration: Record 3;
        IRNApiResult: Text;
        IRNTempBlob: Codeunit "Temp Blob";
        //IRNRequestBlob: Record 99008535;
        IRNInstr: InStream;
        IRNbody: Bigtext;
        IRNjsonobj: Integer;
        IRNToken: Text;

        IRNresultJObject: JsonObject;

        IRNsuccessJObject: JsonObject;

        IRNmessageJObject: JsonObject;

        IRNAckNoJObject: JsonObject;

        IRNAckDtJObject: JsonObject;

        IRNValJObject: JsonObject;
        successStatus: Boolean;
        Statusmessage: Text;
        AckNo: Text;
        AckDt: Text;
        IRN: Text;
        SignedInvoice: Text;
        JsonMgmt: Codeunit 50155;
        result: Text;
        Lineno: Integer;
        //IRNLdgEnt: Record 50020;
        SignedQR: Text;

        IRNSignQRJObject: JsonObject;
        QRMgmt: Codeunit 50157;
        AuthToken: Text;
        InvoiceJson: Text;
        MyFile: File;
        StreamInTest: InStream;
        Buffer: Text;
        SInvNo: Text;
        FilePath: Text;
        FileName: Text;
        OutStr: OutStream;
        IRNJtoken: JsonToken;
        IRNResultToken: JsonToken;
        Httpclint: HttpClient;
        HttpContnt: HttpContent;
        IRNHttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        HttpHdr: DotNet ResponseHeader;
        response: InStream;
        HttpStatus: DotNet HttpStatusCode;
    begin
        recGeneralLedSet.Get();
        IRNPostUrl := recGeneralLedSet."E-Invoice IRN Generation URL";
        Message(Authorization);
        IRNbody := JsonMgmt.CreateeInvoiceJSON(TransferShipmentHdr);
        IRNHttpContnt.WriteFrom(Format(IRNbody));
        IRNHttpContnt.GetHeaders(IRNHttpHdr);
        // IRNHttpHdr.Add('user_name', user_name);
        // IRNHttpHdr.Add('password', password);
        IRNHttpHdr.Remove('Content-Type');
        IRNHttpHdr.Add('Content-Type', 'application/json');
        IRNHttpHdr.Remove('Return-Type');
        //IRNHttpHdr.Add('gstin', gstin);
        //IRNHttpHdr.Add('requestid', GenerateReqId);
        //IRNHttpHdr.Add('Authorization', Authorization);
        IRNHttpHdr.Add('Return-Type', 'application/json');
        // IRNHttpHdr.Add('Return-Type', 'application/json');
        // // IRNHttpHdr.Add('Return-Type', 'application/json');
        // IRNHttpWebRequestMgt.Initialize(IRNPostUrl);
        // IRNHttpWebRequestMgt.DisableUI;
        // IRNHttpWebRequestMgt.SetMethod('POST');
        // //IRNHttpWebRequestMgt.SetMethod('GET');//Nkp--CCIt
        // IRNHttpWebRequestMgt.SetTimeout(60000 * 3);
        // IRNHttpWebRequestMgt.SetContentType('application/json');
        // IRNHttpWebRequestMgt.SetReturnType('application/json');
        // IRNHttpWebRequestMgt.AddHeader('user_name', user_name);
        // IRNHttpWebRequestMgt.AddHeader('password', password);
        // IRNHttpWebRequestMgt.AddHeader('gstin', gstin);
        // IRNHttpWebRequestMgt.AddHeader('requestid', GenerateReqId);
        // IRNHttpWebRequestMgt.AddHeader('Authorization', Authorization);

        //MESSAGE(JsonMgmt.CreateeInvoiceJSON(TransferShipmentHdr));
        // IRNTempBlob.CreateInStream(response);
        // IRNHttpWebRequestMgt.AddBodyAsText(format(JsonMgmt.CreateeInvoiceJSON(TransferShipmentHdr)));
        // if IRNHttpWebRequestMgt.GetResponse(response, HttpStatus, HttpHdr) then begin
        // IRNbody := JsonMgmt.CreateeInvoiceJSON(TransferShipmentHdr);
        // IRNHttpContnt.WriteFrom(Format(IRNbody));
        IRNHttpclint.DefaultRequestHeaders.Add('user_name', user_name);
        IRNHttpclint.DefaultRequestHeaders.Add('password', password);
        IRNHttpclint.DefaultRequestHeaders.Add('gstin', gstin);
        IRNHttpclint.DefaultRequestHeaders.Add('requestid', GenerateReqId);//'drstrdtfuy34ghjghjgf'
        IRNHttpclint.DefaultRequestHeaders.Add('Authorization', Authorization);
        IRNHttpclint.Timeout(60000 * 3);
        if IRNHttpclint.Post(IRNPostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
            //response.Read(IRNApiResult);
            IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);
            IF IRNApiResult <> '' THEN BEGIN
                //MESSAGE(IRNApiResult);

                IRNJObject.ReadFrom(IRNApiResult);
                IRNsuccessJObject.ReadFrom(IRNApiResult);
                IRNmessageJObject.ReadFrom(IRNApiResult);
                IRNresultJObject.ReadFrom(IRNApiResult);


                //"success"
                IF IRNJObject.Get('success', IRNJtoken) THEN BEGIN

                    successStatus := IRNJtoken.AsValue().AsBoolean();
                    //  MESSAGE(successStatus);
                END;

                //"message"
                IF IRNJObject.Get('message', IRNJtoken) THEN BEGIN
                    Statusmessage := IRNJtoken.AsValue().AsText();
                    MESSAGE(Statusmessage);
                END;

                IF successStatus = false THEN BEGIN

                    Message(Format(IRNApiResult));

                END;


                IF (successStatus = True) THEN BEGIN
                    //MESSAGE('Response status is %1 and message is %2',successStatus,Statusmessage);
                    //result
                    IF IRNJObject.Get('result', IRNjtoken) THEN BEGIN
                        IRNresultJObject := IRNJtoken.AsObject();
                        //result := IRNjtoken.AsValue().AsText();
                        //MESSAGE(result);
                    END;

                    //"AckNo"
                    IF IRNresultJObject.Get('AckNo', IRNResultToken) THEN BEGIN

                        AckNo := IRNResultToken.AsValue().AsText();
                        //MESSAGE(AckNo);
                    END;

                    //AckDt
                    IF IRNresultJObject.Get('AckDt', IRNResultToken) THEN BEGIN
                        //IRNAckDtJObject := IRNAckDtJObject.GetValue('AckDt');
                        AckDt := IRNResultToken.AsValue().AsText();
                        //MESSAGE(AckDt);
                    END;

                    //IRN
                    IF IRNresultJObject.Get('Irn', IRNResultToken) THEN BEGIN
                        //IRNValJObject := IRNValJObject.GetValue('Irn');
                        IRN := IRNResultToken.AsValue().AsText();
                        //MESSAGE(IRN);
                    END;
                    IF IRNresultJObject.Get('SignedInvoice', IRNResultToken) THEN BEGIN
                        //IRNValJObject := IRNValJObject.GetValue('Irn');
                        SignedInvoice := IRNResultToken.AsValue().AsText();
                        //MESSAGE(IRN);
                    END;

                    //SignedQRCode
                    IF IRNresultJObject.Get('SignedQRCode', IRNResultToken) THEN BEGIN
                        //IRNSignQRJObject := IRNSignQRJObject.GetValue('SignedQRCode');
                        SignedQR := IRNResultToken.AsValue().AsText();
                        //MESSAGE('SignQRCODE:%1',SignedQR);
                    END;
                    // MESSAGE('SignQRCODE:%1',SignedQR);
                    TransferShipmentHdr."Acknowledgment N0." := AckNo;
                    TransferShipmentHdr."Acknowledgment Date" := AckDt;
                    TransferShipmentHdr."IRN Hash" := IRN;
                    //TransferShipmentHdr."Signed Invoice" := SignedInvoice;
                    TransferShipmentHdr.Modify();
                    QRMgmt.InitializeSignedQRCodeTSH(TransferShipmentHdr, SignedQR);

                END;

                //ERASE(FilePath+FileName); // Erase Commented by Rohit
            END;

            //MESSAGE(AuthJObject.GetValue('statusCode').ToString);

        END ELSE
            MESSAGE('2' + 'Error when connecting API');

    end;

    procedure GenerateReqId(): Text
    var
        RandomDigit: Text[50];
    begin
        RandomDigit := CREATEGUID;
        RandomDigit := DELCHR(RandomDigit, '=', '{}-0');
        RandomDigit := COPYSTR(RandomDigit, 1, 11);
        //MESSAGE(RandomDigit);
        EXIT(RandomDigit);
    end;

    //     procedure CancelIRN(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; TransferShipmentHdr: Record 5744)
    //     var
    //         IRNUrl: Text;
    //         IRNJson: Text;
    //         IRNHttpclint: HttpClient;
    //         IRNHttpContnt: HttpContent;
    //         IRNHttpResponseMsg: HttpResponseMessage;
    //         IRNHttpHdr: HttpHeaders;
    //         IRNREGAccessLevelEnum: Codeunit 8;
    //         IRNPostUrl: Text;
    //         IRNParams: Text;

    //         IRNJObject: JsonObject;
    //         IRNRegistration: Record 3;
    //         IRNApiResult: Text;
    //         // IRNTempBlob: Record "99008535;
    //         // IRNRequestBlob: Record "99008535;
    //         IRNInstr: InStream;
    //         IRNbody: BigText;
    //         IRNjsonobj: Integer;
    //         IRNToken: Text;

    //         IRNresultJObject: JsonObject;

    //         IRNsuccessJObject: JsonObject;

    //         IRNmessageJObject: JsonObject;

    //         IRNAckNoJObject: JsonObject;

    //         IRNAckDtJObject: JsonObject;

    //         IRNValJObject: JsonObject;
    //         successStatus: Boolean;
    //         Statusmessage: Text;
    //         AckNo: Text;
    //         AckDt: Text;
    //         IRN: Text;
    //         JsonMgmt: Codeunit "Json Creation E-invoice";
    //         result: Text;
    //         Lineno: Integer;
    //         //IRNLdgEnt: Record 50020;
    //         SignedQR: Text;
    //         IRNCnlDtJObject: JsonObject;
    //         QRMgmt: Codeunit 50157;
    //         AuthToken: Text;
    //         InvoiceJson: Text;
    //         MyFile: File;
    //         StreamInTest: InStream;
    //         Buffer: Text;
    //         SInvNo: Text;
    //         FilePath: Text;
    //         FileName: Text;
    //         CancelDate: Text;
    //         IRNJtoken: JsonToken;
    //         IRNResultToken: JsonToken;

    //     begin

    //         IRNHttpContnt.GetHeaders(IRNHttpHdr);
    //         IRNHttpHdr.Remove('Content-Type');
    //         IRNHttpHdr.Add('Content-Type', 'application/json');
    //         IRNHttpHdr.Remove('Return-Type');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('user_name', user_name);
    //         IRNHttpHdr.Add('password', password);
    //         IRNHttpHdr.Add('gstin', gstin);
    //         IRNHttpHdr.Add('requestid', GenerateReqId);
    //         IRNHttpHdr.Add('Authorization', Authorization);

    //         // IRNHttpWebRequestMgt.Initialize(IRNPostUrl);

    //         // IRNHttpWebRequestMgt.DisableUI;

    //         // IRNHttpWebRequestMgt.SetMethod('POST');
    //         // //HttpWebRequestMgt.SetMethod('GET');
    //         // IRNHttpWebRequestMgt.SetTimeout(60000 * 3);
    //         // IRNHttpWebRequestMgt.SetContentType('application/json');
    //         // IRNHttpWebRequestMgt.SetReturnType('application/json');
    //         // IRNHttpWebRequestMgt.AddHeader('user_name', user_name);
    //         // IRNHttpWebRequestMgt.AddHeader('password', password);
    //         // IRNHttpWebRequestMgt.AddHeader('gstin', gstin);
    //         // IRNHttpWebRequestMgt.AddHeader('requestid', GenerateReqId);
    //         // IRNHttpWebRequestMgt.AddHeader('Authorization', Authorization);

    //         //MESSAGE(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));
    //         //IRNHttpWebRequestMgt.AddBodyAsText(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));

    //         IRNbody := JsonMgmt.CreateCancelIRNJSON(TransferShipmentHdr);


    //         IRNHttpContnt.WriteFrom(format(IRNbody));
    //         if IRNHttpclint.Post(PostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
    //             IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);


    //             IF IRNApiResult <> '' THEN BEGIN
    //                 //MESSAGE(IRNApiResult);

    //                 IRNJObject.ReadFrom(IRNApiResult);
    //                 IRNsuccessJObject.ReadFrom(IRNApiResult);
    //                 IRNmessageJObject.ReadFrom(IRNApiResult);
    //                 IRNresultJObject.ReadFrom(IRNApiResult);


    //                 //"success"
    //                 IF IRNJObject.Get('success', IRNJtoken) THEN BEGIN

    //                     successStatus := IRNJtoken.AsValue().AsBoolean();
    //                     //  MESSAGE(successStatus);
    //                 END;

    //                 //"message"
    //                 IF IRNJObject.Get('message', IRNJtoken) THEN BEGIN
    //                     Statusmessage := IRNJtoken.AsValue().AsText();
    //                     MESSAGE(Statusmessage);
    //                 END;

    //                 IF successStatus = False THEN BEGIN

    //                     rec50021.RESET;
    //                     rec50021.SETRANGE(rec50021."Document Type", rec50021."Document Type"::Invoice);
    //                     rec50021.SETRANGE("Sales Inv/Cr Memo No.", TransferShipmentHdr."No.");
    //                     rec50021.SETRANGE(rec50021."Entry Type", rec50021."Entry Type"::"Cancel IRN");
    //                     IF rec50021.FINDFIRST THEN BEGIN
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021.MODIFY(TRUE);

    //                     END ELSE BEGIN

    //                         rec50021.RESET;
    //                         rec50021.INIT;
    //                         rec50021."Document Type" := rec50021."Document Type"::Invoice;
    //                         rec50021."Sales Inv/Cr Memo No." := TransferShipmentHdr."No.";
    //                         rec50021."External Document No." := TransferShipmentHdr."External Document No.";
    //                         rec50021."Integration Document No." := TransferShipmentHdr."Integration Doc No";
    //                         rec50021."Customer No." := TransferShipmentHdr."Sell-to Customer No.";
    //                         rec50021."Customer Name" := TransferShipmentHdr."Sell-to Customer Name";
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021."Entry Type" := rec50021."Entry Type"::"Cancel IRN";
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021.INSERT(TRUE);

    //                     END;

    //                 END;
    //                 IF (successStatus = True) THEN BEGIN

    //                     IF IRNJObject.Get('result', IRNjtoken) THEN BEGIN
    //                         IRNresultJObject := IRNJtoken.AsObject();
    //                         result := IRNjtoken.AsValue().AsText();
    //                         //MESSAGE(result);
    //                     END;

    //                     //"AckNo"
    //                     IF IRNresultJObject.Get('AckNo', IRNResultToken) THEN BEGIN

    //                         AckNo := jtoken.AsValue().AsText();
    //                         //MESSAGE(AckNo);
    //                     END;

    //                     //AckDt
    //                     IF IRNresultJObject.Get('AckDt', IRNResultToken) THEN BEGIN
    //                         //IRNAckDtJObject := IRNAckDtJObject.GetValue('AckDt');
    //                         AckDt := jtoken.AsValue().AsText();
    //                         //MESSAGE(AckDt);
    //                     END;

    //                     //IRN
    //                     IF IRNresultJObject.Get('Irn', IRNResultToken) THEN BEGIN
    //                         //IRNValJObject := IRNValJObject.GetValue('Irn');
    //                         IRN := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;

    //                     //SignedQRCode
    //                     IF IRNresultJObject.Get('SignedQRCode', IRNResultToken) THEN BEGIN
    //                         //IRNSignQRJObject := IRNSignQRJObject.GetValue('SignedQRCode');
    //                         SignedQR := jtoken.AsValue().AsText();
    //                         //MESSAGE('SignQRCODE:%1',SignedQR);
    //                     END;

    //                     IRNLdgEnt.RESET;
    //                     IRNLdgEnt.SETRANGE(IRNLdgEnt."Document No.", TransferShipmentHdr."No.");
    //                     IF IRNLdgEnt.FINDFIRST THEN BEGIN
    //                         IRNLdgEnt.CancelIRNDate := CancelDate;
    //                         IRNLdgEnt.VALIDATE(IRNLdgEnt.Status, IRNLdgEnt.Status::Cancelled);
    //                         IRNLdgEnt.MODIFY(TRUE);
    //                     END;


    //                     /*
    //                         IRNLdgEnt.RESET;
    //                         IF IRNLdgEnt.FINDSET THEN
    //                           IF IRNLdgEnt.FINDLAST THEN
    //                             Lineno := IRNLdgEnt."Line No." + 10000
    //                           ELSE
    //                             Lineno := 10000;

    //                           IRNLdgEnt.INIT;
    //                           IRNLdgEnt."Document No." := SalInvHdr."No.";
    //                           IRNLdgEnt."Line No." := Lineno;
    //                           IRNLdgEnt."Document Type" := 0;
    //                           IRNLdgEnt."Invoice Type" := SalInvHdr."Invoice Type";
    //                           IRNLdgEnt.IRN := IRN;
    //                           //IRNLdgEnt.SignbedQRCode:=

    //                           IRNLdgEnt."IRN Ack Date" := AckDt;
    //                           IRNLdgEnt.Status := 1;
    //                           IRNLdgEnt.INSERT;
    //                           //QRMgmt.InitializeSignedQRCode(SalInvHdr,SignedQR);
    //                     */
    //                 END;
    //                 //ERASE(FilePath+FileName); // Erase Commented by Rohit
    //             END;

    //             //MESSAGE(AuthJObject.GetValue('statusCode').ToString);

    //         END ELSE
    //             MESSAGE('2' + 'Error when connecting API');//MESSAGE('2'+RegistrationError);

    //     end;

    //     procedure GenerateIRNForCreditMemo(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; TransferShipmentHdr: Record 5744)
    //     var
    //         IRNUrl: Text;
    //         IRNJson: Text;
    //         IRNHttpclint: HttpClient;
    //         IRNHttpContnt: HttpContent;
    //         IRNHttpResponseMsg: HttpResponseMessage;
    //         IRNHttpHdr: HttpHeaders;
    //         IRNREGAccessLevelEnum: Codeunit 8;
    //         IRNPostUrl: Text;
    //         IRNParams: Text;

    //         IRNJObject: JsonObject;
    //         IRNRegistration: Record 3;
    //         IRNApiResult: Text;
    //         // IRNTempBlob: Record "99008535;
    //         // IRNRequestBlob: Record "99008535;
    //         IRNInstr: InStream;
    //         IRNbody: BigText;
    //         IRNjsonobj: Integer;
    //         IRNToken: Text;

    //         IRNresultJObject: JsonObject;

    //         IRNsuccessJObject: JsonObject;

    //         IRNmessageJObject: JsonObject;

    //         IRNAckNoJObject: JsonObject;

    //         IRNAckDtJObject: JsonObject;

    //         IRNValJObject: JsonObject;
    //         successStatus: Boolean;
    //         Statusmessage: Text;
    //         AckNo: Text;
    //         AckDt: Text;
    //         IRN: Text;
    //         JsonMgmt: Codeunit 50009;
    //         result: Text;
    //         Lineno: Integer;
    //         IRNLdgEnt: Record 50020;
    //         SignedQR: Text;

    //         IRNSignQRJObject: JsonObject;
    //         QRMgmt: Codeunit 50011;
    //         AuthToken: Text;
    //         InvoiceJson: Text;
    //         MyFile: File;
    //         StreamInTest: InStream;
    //         Buffer: Text;
    //         SInvNo: Text;
    //         FilePath: Text;
    //         FileName: Text;
    //         OutStr: OutStream;
    //         IRNJtoken: JsonToken;
    //         IRNResultToken: JsonToken;
    //     begin


    //         IRNHttpContnt.GetHeaders(IRNHttpHdr);
    //         IRNHttpHdr.Remove('Content-Type');
    //         IRNHttpHdr.Add('Content-Type', 'application/json');
    //         IRNHttpHdr.Remove('Return-Type');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('user_name', user_name);
    //         IRNHttpHdr.Add('password', password);
    //         IRNHttpHdr.Add('gstin', gstin);
    //         IRNHttpHdr.Add('requestid', GenerateReqId);
    //         IRNHttpHdr.Add('Authorization', Authorization);

    //         IRNbody := JsonMgmt.CreateCreditMemoJSON(TransferShipmentHdr);// For Credit Memo
    //                                                             //done
    //                                                             // 
    //         IRNHttpContnt.WriteFrom(format(IRNbody));
    //         if IRNHttpclint.Post(PostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
    //             IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);
    //             IF IRNApiResult <> '' THEN BEGIN
    //                 //MESSAGE(IRNApiResult);

    //                 IRNJObject.ReadFrom(IRNApiResult);
    //                 IRNsuccessJObject.ReadFrom(IRNApiResult);
    //                 IRNmessageJObject.ReadFrom(IRNApiResult);
    //                 IRNresultJObject.ReadFrom(IRNApiResult);

    //                 //"success"
    //                 IF IRNJObject.Get('success', IRNJtoken) THEN BEGIN

    //                     successStatus := IRNJtoken.AsValue().AsBoolean();
    //                     //  MESSAGE(successStatus);
    //                 END;

    //                 //"message"
    //                 IF IRNJObject.Get('message', IRNJtoken) THEN BEGIN
    //                     Statusmessage := IRNJtoken.AsValue().AsText();
    //                     MESSAGE(Statusmessage);
    //                 END;

    //                 IF successStatus = False THEN BEGIN

    //                     rec50021.RESET;
    //                     rec50021.SETRANGE(rec50021."Document Type", rec50021."Document Type"::"Credit Memo");
    //                     rec50021.SETRANGE("Sales Inv/Cr Memo No.", TransferShipmentHdr."No.");
    //                     rec50021.SETRANGE(rec50021."Entry Type", rec50021."Entry Type"::"Generate IRN");
    //                     IF rec50021.FINDFIRST THEN BEGIN
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021.MODIFY(TRUE);

    //                     END ELSE BEGIN

    //                         rec50021.RESET;
    //                         rec50021.INIT;
    //                         rec50021."Document Type" := rec50021."Document Type"::"Credit Memo";
    //                         rec50021."Sales Inv/Cr Memo No." := TransferShipmentHdr."No.";
    //                         rec50021."External Document No." := TransferShipmentHdr."External Document No.";
    //                         rec50021."Integration Document No." := TransferShipmentHdr."Integration Doc No";
    //                         rec50021."Customer No." := TransferShipmentHdr."Sell-to Customer No.";
    //                         rec50021."Customer Name" := TransferShipmentHdr."Sell-to Customer Name";
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021."Entry Type" := rec50021."Entry Type"::"Generate IRN";
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021.INSERT(TRUE);

    //                     END;

    //                 END;



    //                 IF (successStatus = True) THEN BEGIN
    //                     //MESSAGE('Response status is %1 and message is %2',successStatus,Statusmessage);
    //                     //result
    //                     IF IRNJObject.Get('result', IRNjtoken) THEN BEGIN
    //                         IRNresultJObject := IRNJtoken.AsObject();
    //                         result := IRNjtoken.AsValue().AsText();
    //                         //MESSAGE(result);
    //                     END;


    //                     // IRNAckNoJObject := IRNAckNoJObject.Parse(result);
    //                     // IRNAckDtJObject := IRNAckDtJObject.Parse(result);
    //                     // IRNValJObject := IRNValJObject.Parse(result);
    //                     // IRNSignQRJObject := IRNSignQRJObject.Parse(result);

    //                     //"AckNo"
    //                     IF IRNresultJObject.Get('AckNo', IRNResultToken) THEN BEGIN

    //                         AckNo := jtoken.AsValue().AsText();
    //                         //MESSAGE(AckNo);
    //                     END;

    //                     //AckDt
    //                     IF IRNresultJObject.Get('AckDt', IRNResultToken) THEN BEGIN
    //                         //IRNAckDtJObject := IRNAckDtJObject.GetValue('AckDt');
    //                         AckDt := jtoken.AsValue().AsText();
    //                         //MESSAGE(AckDt);
    //                     END;

    //                     //IRN
    //                     IF IRNresultJObject.Get('Irn', IRNResultToken) THEN BEGIN
    //                         //IRNValJObject := IRNValJObject.GetValue('Irn');
    //                         IRN := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;

    //                     //SignedQRCode
    //                     IF IRNresultJObject.Get('SignedQRCode', IRNResultToken) THEN BEGIN
    //                         //IRNSignQRJObject := IRNSignQRJObject.GetValue('SignedQRCode');
    //                         SignedQR := jtoken.AsValue().AsText();
    //                         //MESSAGE('SignQRCODE:%1',SignedQR);
    //                     END;
    //                     //MESSAGE('SignQRCODE:%1',SignedQR);
    //                     Lineno := 0;
    //                     IRNLdgEnt.RESET;
    //                     IF IRNLdgEnt.FINDSET THEN
    //                         IF IRNLdgEnt.FINDLAST THEN
    //                             Lineno := IRNLdgEnt."Entry No." + 1
    //                         ELSE
    //                             Lineno := 1;

    //                     IRNLdgEnt.INIT;
    //                     IRNLdgEnt."Entry No." := Lineno;
    //                     IRNLdgEnt."Document No." := TransferShipmentHdr."No.";
    //                     IRNLdgEnt."Document Type" := 1;
    //                     IRNLdgEnt."Invoice Type" := TransferShipmentHdr."Invoice Type";
    //                     IRNLdgEnt.VALIDATE(IRNLdgEnt.IRN, IRN);
    //                     //IRNLdgEnt.SignbedQRCode:=

    //                     IRNLdgEnt."IRN Ack No" := AckNo;
    //                     IRNLdgEnt."IRN Ack Date" := AckDt;
    //                     IRNLdgEnt.Status := 1;
    //                     IRNLdgEnt.INSERT(TRUE);
    //                     QRMgmt.InitializeSignedQRCodeCreditMemo(TransferShipmentHdr, SignedQR); //Commented for QR Code Nitish

    //                 END;
    //                 //ERASE(FilePath+FileName); // Erase Commented by Rohit
    //             END;

    //             //MESSAGE(AuthJObject.GetValue('statusCode').ToString);

    //         END ELSE
    //             MESSAGE('2' + 'Error when connecting API');
    //     end;

    //     procedure CancelIRNCreditMemo(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; TransferShipmentHdr: Record 5744)
    //     var
    //         IRNUrl: Text;
    //         IRNJson: Text;
    //         IRNHttpclint: HttpClient;
    //         IRNHttpContnt: HttpContent;
    //         IRNHttpResponseMsg: HttpResponseMessage;
    //         IRNHttpHdr: HttpHeaders;
    //         IRNREGAccessLevelEnum: Codeunit 8;
    //         IRNPostUrl: Text;
    //         IRNParams: Text;

    //         IRNJObject: JsonObject;
    //         IRNRegistration: Record 3;
    //         IRNApiResult: Text;
    //         // IRNTempBlob: Record 99008535;
    //         // IRNRequestBlob: Record 99008535;
    //         IRNInstr: InStream;
    //         IRNbody: BigText;
    //         IRNjsonobj: Integer;
    //         IRNToken: Text;

    //         IRNresultJObject: JsonObject;

    //         IRNsuccessJObject: JsonObject;

    //         IRNmessageJObject: JsonObject;

    //         IRNAckNoJObject: JsonObject;

    //         IRNAckDtJObject: JsonObject;

    //         IRNValJObject: JsonObject;
    //         successStatus: Boolean;
    //         Statusmessage: Text;
    //         AckNo: Text;
    //         AckDt: Text;
    //         IRN: Text;
    //         JsonMgmt: Codeunit 50009;
    //         result: Text;
    //         Lineno: Integer;
    //         IRNLdgEnt: Record 50020;
    //         SignedQR: Text;

    //         IRNCnlDtJObject: JsonObject;
    //         QRMgmt: Codeunit 50011;
    //         AuthToken: Text;
    //         InvoiceJson: Text;
    //         MyFile: File;
    //         StreamInTest: InStream;
    //         Buffer: Text;
    //         SInvNo: Text;
    //         FilePath: Text;
    //         FileName: Text;
    //         CancelDate: Text;
    //         IRNJtoken: JsonToken;
    //         IRNResultToken: JsonToken;
    //     begin


    //         IRNHttpContnt.GetHeaders(IRNHttpHdr);
    //         IRNHttpHdr.Remove('Content-Type');
    //         IRNHttpHdr.Add('Content-Type', 'application/json');
    //         IRNHttpHdr.Remove('Return-Type');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('user_name', user_name);
    //         IRNHttpHdr.Add('password', password);
    //         IRNHttpHdr.Add('gstin', gstin);
    //         IRNHttpHdr.Add('requestid', GenerateReqId);
    //         IRNHttpHdr.Add('Authorization', Authorization);

    //         //MESSAGE(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));
    //         //IRNHttpWebRequestMgt.AddBodyAsText(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));

    //         IRNbody := JsonMgmt.CancelIRNCreditMemo(TransferShipmentHdr);



    //         // //done
    //         // SInvNo := CONVERTSTR(SalInvHdr."No.", '/', '_');
    //         // FilePath := 'D:\EinvJson\CanceleInvoice_';
    //         // FileName := SInvNo + '.txt';
    //         // MyFile.CREATE('D:\EinvJson\' + SInvNo + '.txt');

    //         // IRNHttpWebRequestMgt.AddBody(FilePath + FileName);
    //         // //body:='{"Vendor_Code":"AOTPJ4755JESF","Verification":"Success"}';

    //         // //HttpWebRequestMgt.AddBodyAsText(body);



    //         IRNHttpContnt.WriteFrom(format(IRNbody));
    //         if IRNHttpclint.Post(PostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
    //             IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);


    //             IF IRNApiResult <> '' THEN BEGIN
    //                 //MESSAGE(IRNApiResult);

    //                 IRNJObject.ReadFrom(IRNApiResult);
    //                 IRNsuccessJObject.ReadFrom(IRNApiResult);
    //                 IRNmessageJObject.ReadFrom(IRNApiResult);
    //                 IRNresultJObject.ReadFrom(IRNApiResult);

    //                 //"success"
    //                 IF IRNJObject.Get('success', IRNJtoken) THEN BEGIN

    //                     successStatus := IRNJtoken.AsValue().AsBoolean();
    //                     //  MESSAGE(successStatus);
    //                 END;
    //                 //"message"
    //                 IF IRNJObject.Get('message', IRNJtoken) THEN BEGIN
    //                     Statusmessage := IRNJtoken.AsValue().AsText();
    //                     MESSAGE(Statusmessage);
    //                 END;

    //                 IF successStatus = False THEN BEGIN

    //                     rec50021.RESET;
    //                     rec50021.SETRANGE(rec50021."Document Type", rec50021."Document Type"::"Credit Memo");
    //                     rec50021.SETRANGE("Sales Inv/Cr Memo No.", TransferShipmentHdr."No.");
    //                     rec50021.SETRANGE(rec50021."Entry Type", rec50021."Entry Type"::"Cancel IRN");
    //                     IF rec50021.FINDFIRST THEN BEGIN
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021.MODIFY(TRUE);

    //                     END ELSE BEGIN

    //                         rec50021.RESET;
    //                         rec50021.INIT;
    //                         rec50021."Document Type" := rec50021."Document Type"::"Credit Memo";
    //                         rec50021."Sales Inv/Cr Memo No." := TransferShipmentHdr."No.";
    //                         rec50021."External Document No." := TransferShipmentHdr."External Document No.";
    //                         rec50021."Integration Document No." := TransferShipmentHdr."Integration Doc No";
    //                         rec50021."Customer No." := TransferShipmentHdr."Sell-to Customer No.";
    //                         rec50021."Customer Name" := TransferShipmentHdr."Sell-to Customer Name";
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021."Entry Type" := rec50021."Entry Type"::"Cancel IRN";
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021.INSERT(TRUE);

    //                     END;

    //                 END;



    //                 IF (successStatus = True) THEN BEGIN
    //                     //MESSAGE('Response status is %1 and message is %2',successStatus,Statusmessage);
    //                     //result
    //                     IF IRNJObject.Get('result', IRNjtoken) THEN BEGIN
    //                         IRNresultJObject := IRNJtoken.AsObject();
    //                         result := IRNjtoken.AsValue().AsText();
    //                         //MESSAGE(result);
    //                     END;

    //                     // IRNValJObject := IRNValJObject.Parse(result);
    //                     // IRNCnlDtJObject := IRNCnlDtJObject.Parse(result);

    //                     //IRN
    //                     IF IRNresultJObject.Get('Irn', IRNResultToken) THEN BEGIN
    //                         //IRNValJObject := IRNValJObject.GetValue('Irn');
    //                         IRN := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;

    //                     //Cancel Date
    //                     IF IRNresultJObject.Get('CancelDate', IRNResultToken) THEN BEGIN
    //                         //IRNCnlDtJObject := IRNCnlDtJObject.GetValue('CancelDate');
    //                         CancelDate := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;

    //                     IRNLdgEnt.RESET;
    //                     IRNLdgEnt.SETRANGE(IRNLdgEnt."Document No.", TransferShipmentHdr."No.");
    //                     IF IRNLdgEnt.FINDFIRST THEN BEGIN
    //                         IRNLdgEnt.CancelIRNDate := CancelDate;
    //                         IRNLdgEnt.VALIDATE(IRNLdgEnt.Status, IRNLdgEnt.Status::Cancelled);
    //                         IRNLdgEnt.MODIFY(TRUE);
    //                     END


    //                     /*
    //                         IRNLdgEnt.RESET;
    //                         IF IRNLdgEnt.FINDSET THEN
    //                           IF IRNLdgEnt.FINDLAST THEN
    //                             Lineno := IRNLdgEnt."Line No." + 10000
    //                           ELSE
    //                             Lineno := 10000;

    //                           IRNLdgEnt.INIT;
    //                           IRNLdgEnt."Document No." := SalInvHdr."No.";
    //                           IRNLdgEnt."Line No." := Lineno;
    //                           IRNLdgEnt."Document Type" := 0;
    //                           IRNLdgEnt."Invoice Type" := SalInvHdr."Invoice Type";
    //                           IRNLdgEnt.IRN := IRN;
    //                           //IRNLdgEnt.SignbedQRCode:=

    //                           IRNLdgEnt."IRN Ack Date" := AckDt;
    //                           IRNLdgEnt.Status := 1;
    //                           IRNLdgEnt.INSERT;
    //                           //QRMgmt.InitializeSignedQRCode(SalInvHdr,SignedQR);
    //                     */
    //                 END;
    //                 //ERASE(FilePath+FileName); // Erase Commented by Rohit
    //             END;

    //             //MESSAGE(AuthJObject.GetValue('statusCode').ToString);

    //         END ELSE
    //             MESSAGE('2' + 'Error when connecting API');//MESSAGE('2'+RegistrationError);

    //     end;

    //     procedure GenerateIRNBulk(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; TransferShipmentHdr: Record 5744)
    //     var
    //         IRNUrl: Text;
    //         IRNJson: Text;
    //         IRNHttpclint: HttpClient;
    //         IRNHttpContnt: HttpContent;
    //         IRNHttpResponseMsg: HttpResponseMessage;
    //         IRNHttpHdr: HttpHeaders;
    //         IRNREGAccessLevelEnum: Codeunit 8;
    //         IRNPostUrl: Text;
    //         IRNParams: Text;
    //         IRNJObject: JsonObject;
    //         IRNRegistration: Record 3;
    //         IRNApiResult: Text;

    //         IRNInstr: InStream;
    //         IRNbody: BigText;
    //         IRNjsonobj: Integer;
    //         IRNToken: Text;

    //         IRNresultJObject: JsonObject;

    //         IRNsuccessJObject: JsonObject;

    //         IRNmessageJObject: JsonObject;

    //         IRNAckNoJObject: JsonObject;

    //         IRNAckDtJObject: JsonObject;

    //         IRNValJObject: JsonObject;
    //         successStatus: Boolean;
    //         Statusmessage: Text;
    //         AckNo: Text;
    //         AckDt: Text;
    //         IRN: Text;
    //         JsonMgmt: Codeunit 50009;
    //         result: Text;
    //         Lineno: Integer;
    //         IRNLdgEnt: Record 50020;
    //         SignedQR: Text;

    //         IRNSignQRJObject: JsonObject;
    //         QRMgmt: Codeunit 50011;
    //         AuthToken: Text;
    //         InvoiceJson: Text;
    //         MyFile: File;
    //         StreamInTest: InStream;
    //         Buffer: Text;
    //         SInvNo: Text;
    //         FilePath: Text;
    //         FileName: Text;
    //         OutStr: OutStream;
    //         IRNJtoken: JsonToken;
    //         IRNResultToken: JsonToken;
    //     begin

    //         IRNHttpContnt.GetHeaders(IRNHttpHdr);
    //         IRNHttpHdr.Add('user_name', user_name);
    //         IRNHttpHdr.Add('password', password);
    //         IRNHttpHdr.Remove('Content-Type');
    //         IRNHttpHdr.Add('Content-Type', 'application/json');
    //         IRNHttpHdr.Remove('Return-Type');
    //         IRNHttpHdr.Add('gstin', gstin);
    //         IRNHttpHdr.Add('requestid', GenerateReqId);
    //         IRNHttpHdr.Add('Authorization', Authorization);
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');

    //         //MESSAGE(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));
    //         //IRNHttpWebRequestMgt.AddBodyAsText(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));



    //         IRNbody := JsonMgmt.CreateeInvoiceJSON(TransferShipmentHdr);
    //         IRNHttpContnt.WriteFrom(Format(IRNbody));
    //         IRNHttpclint.Timeout(60000 * 3);

    //         //Pick Json from file
    //         /*
    //         MyFile.OPEN('D:\json\File1.txt');
    //         MyFile.CREATEINSTREAM(StreamInTest);
    //         StreamInTest.READTEXT(Buffer);
    //         InvoiceJson := Buffer;
    //         IRNHttpWebRequestMgt.AddBodyAsText(InvoiceJson);
    //         */

    //         //MESSAGE(InvoiceJson);


    //         //done
    //         if IRNHttpclint.Post(PostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
    //             IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);

    //             IF IRNApiResult <> '' THEN BEGIN
    //                 // MESSAGE(IRNApiResult);


    //                 IRNJObject.ReadFrom(IRNApiResult);
    //                 IRNsuccessJObject.ReadFrom(IRNApiResult);
    //                 IRNmessageJObject.ReadFrom(IRNApiResult);
    //                 IRNresultJObject.ReadFrom(IRNApiResult);

    //                 //"success"
    //                 IF IRNJObject.Get('success', IRNJtoken) THEN BEGIN

    //                     successStatus := IRNJtoken.AsValue().AsBoolean();
    //                     //  MESSAGE(successStatus);
    //                 END;

    //                 //"message"
    //                 IF IRNJObject.Get('message', IRNJtoken) THEN BEGIN
    //                     Statusmessage := IRNJtoken.AsValue().AsText();
    //                     MESSAGE(Statusmessage);
    //                 END;
    //                 IF successStatus = False THEN BEGIN

    //                     rec50021.RESET;
    //                     rec50021.SETRANGE(rec50021."Document Type", rec50021."Document Type"::Invoice);
    //                     rec50021.SETRANGE("Sales Inv/Cr Memo No.", TransferShipmentHdr."No.");
    //                     rec50021.SETRANGE(rec50021."Entry Type", rec50021."Entry Type"::"Generate IRN");
    //                     IF rec50021.FINDFIRST THEN BEGIN
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021.MODIFY(TRUE);

    //                     END ELSE BEGIN

    //                         rec50021.RESET;
    //                         rec50021.INIT;
    //                         rec50021."Document Type" := rec50021."Document Type"::Invoice;
    //                         rec50021."Sales Inv/Cr Memo No." := TransferShipmentHdr."No.";
    //                         rec50021."External Document No." := TransferShipmentHdr."External Document No.";
    //                         rec50021."Integration Document No." := TransferShipmentHdr."Integration Doc No";
    //                         rec50021."Customer No." := TransferShipmentHdr."Sell-to Customer No.";
    //                         rec50021."Customer Name" := TransferShipmentHdr."Sell-to Customer Name";
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021."Entry Type" := rec50021."Entry Type"::"Generate IRN";
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021.INSERT(TRUE);

    //                     END;

    //                 END;


    //                 IF (successStatus = True) THEN BEGIN
    //                     //MESSAGE('Response status is %1 and message is %2',successStatus,Statusmessage);
    //                     //result
    //                     IF IRNJObject.Get('result', IRNjtoken) THEN BEGIN
    //                         IRNresultJObject := IRNJtoken.AsObject();
    //                         result := IRNjtoken.AsValue().AsText();
    //                         //MESSAGE(result);
    //                     END;

    //                     //"AckNo"
    //                     IF IRNresultJObject.Get('AckNo', IRNResultToken) THEN BEGIN

    //                         AckNo := jtoken.AsValue().AsText();
    //                         //MESSAGE(AckNo);
    //                     END;

    //                     //AckDt
    //                     IF IRNresultJObject.Get('AckDt', IRNResultToken) THEN BEGIN
    //                         //IRNAckDtJObject := IRNAckDtJObject.GetValue('AckDt');
    //                         AckDt := jtoken.AsValue().AsText();
    //                         //MESSAGE(AckDt);
    //                     END;

    //                     //IRN
    //                     IF IRNresultJObject.Get('Irn', IRNResultToken) THEN BEGIN
    //                         //IRNValJObject := IRNValJObject.GetValue('Irn');
    //                         IRN := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;


    //                     //SignedQRCode
    //                     IF IRNresultJObject.Get('SignedQRCode', IRNResultToken) THEN BEGIN
    //                         //IRNSignQRJObject := IRNSignQRJObject.GetValue('SignedQRCode');
    //                         SignedQR := jtoken.AsValue().AsText();
    //                         //MESSAGE('SignQRCODE:%1',SignedQR);
    //                     END;
    //                     // MESSAGE('SignQRCODE:%1',SignedQR);

    //                     IRNLdgEnt.RESET;
    //                     IRNLdgEnt.SETCURRENTKEY("Entry No.", "Document No.");
    //                     IRNLdgEnt.ASCENDING(TRUE);
    //                     IRNLdgEnt.SETFILTER("Entry No.", '<>%1', 0);
    //                     IF IRNLdgEnt.FINDLAST THEN
    //                         Lineno := IRNLdgEnt."Entry No." + 1
    //                     ELSE
    //                         Lineno := 1;

    //                     IRNLdgEnt.INIT;
    //                     IRNLdgEnt."Entry No." := Lineno;
    //                     IRNLdgEnt."Document No." := TransferShipmentHdr."No.";
    //                     IRNLdgEnt."Document Type" := 0;
    //                     IRNLdgEnt."Invoice Type" := TransferShipmentHdr."Invoice Type";
    //                     IRNLdgEnt.VALIDATE(IRNLdgEnt.IRN, IRN);
    //                     //IRNLdgEnt.SignbedQRCode:=

    //                     IRNLdgEnt."IRN Ack No" := AckNo;
    //                     IRNLdgEnt."IRN Ack Date" := AckDt;
    //                     IRNLdgEnt.Status := 1;

    //                     IRNLdgEnt.INSERT(TRUE);
    //                     QRMgmt.InitializeSignedQRCode(TransferShipmentHdr, SignedQR);//Nitish
    //                 END;
    //                 //ERASE(FilePath+FileName); // Erase Commented by Rohit
    //             END;

    //             //MESSAGE(AuthJObject.GetValue('statusCode').ToString);

    //         END ELSE
    //             MESSAGE('2' + 'Error when connecting API');

    //     end;

    //     procedure CancelIRNBulk(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; TransferShipmentHdr: Record 5744)
    //     var
    //         IRNUrl: Text;
    //         IRNJson: Text;
    //         IRNHttpclint: HttpClient;
    //         IRNHttpContnt: HttpContent;
    //         IRNHttpResponseMsg: HttpResponseMessage;
    //         IRNHttpHdr: HttpHeaders;
    //         IRNREGAccessLevelEnum: Codeunit 8;
    //         IRNPostUrl: Text;
    //         IRNParams: Text;

    //         IRNJObject: JsonObject;
    //         IRNRegistration: Record 3;
    //         IRNApiResult: Text;

    //         IRNInstr: InStream;
    //         IRNbody: BigText;
    //         IRNjsonobj: Integer;
    //         IRNToken: Text;

    //         IRNresultJObject: JsonObject;

    //         IRNsuccessJObject: JsonObject;

    //         IRNmessageJObject: JsonObject;

    //         IRNAckNoJObject: JsonObject;

    //         IRNAckDtJObject: JsonObject;

    //         IRNValJObject: JsonObject;
    //         successStatus: Boolean;
    //         Statusmessage: Text;
    //         AckNo: Text;
    //         AckDt: Text;
    //         IRN: Text;
    //         JsonMgmt: Codeunit 50009;
    //         result: Text;
    //         Lineno: Integer;
    //         IRNLdgEnt: Record 50020;
    //         SignedQR: Text;

    //         IRNCnlDtJObject: JsonObject;
    //         QRMgmt: Codeunit 50011;
    //         AuthToken: Text;
    //         InvoiceJson: Text;
    //         MyFile: File;
    //         StreamInTest: InStream;
    //         Buffer: Text;
    //         SInvNo: Text;
    //         FilePath: Text;
    //         FileName: Text;
    //         CancelDate: Text;
    //         IRNJtoken: JsonToken;
    //         IRNResultToken: JsonToken;
    //     begin

    //         IRNHttpContnt.GetHeaders(IRNHttpHdr);
    //         IRNHttpHdr.Remove('Content-Type');
    //         IRNHttpHdr.Add('Content-Type', 'application/json');
    //         IRNHttpHdr.Remove('Return-Type');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('user_name', user_name);
    //         IRNHttpHdr.Add('password', password);
    //         IRNHttpHdr.Add('gstin', gstin);
    //         IRNHttpHdr.Add('requestid', GenerateReqId);
    //         IRNHttpHdr.Add('Authorization', Authorization);

    //         //MESSAGE(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));
    //         //IRNHttpWebRequestMgt.AddBodyAsText(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));

    //         IRNbody := JsonMgmt.CreateCancelIRNJSON(TransferShipmentHdr);
    //         IRNHttpContnt.WriteFrom(format(IRNbody));
    //         if IRNHttpclint.Post(PostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
    //             IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);

    //             IF IRNApiResult <> '' THEN BEGIN
    //                 //MESSAGE(IRNApiResult);

    //                 IRNJObject.ReadFrom(IRNApiResult);
    //                 IRNsuccessJObject.ReadFrom(IRNApiResult);
    //                 IRNmessageJObject.ReadFrom(IRNApiResult);
    //                 IRNresultJObject.ReadFrom(IRNApiResult);
    //                 //"success"
    //                 IF IRNJObject.Get('success', IRNJtoken) THEN BEGIN

    //                     successStatus := IRNJtoken.AsValue().AsBoolean();
    //                     //  MESSAGE(successStatus);
    //                 END;

    //                 //"message"
    //                 IF IRNJObject.Get('message', IRNJtoken) THEN BEGIN
    //                     Statusmessage := IRNJtoken.AsValue().AsText();
    //                     MESSAGE(Statusmessage);
    //                 END;


    //                 IF successStatus = False THEN BEGIN

    //                     rec50021.RESET;
    //                     rec50021.SETRANGE(rec50021."Document Type", rec50021."Document Type"::Invoice);
    //                     rec50021.SETRANGE("Sales Inv/Cr Memo No.", TransferShipmentHdr."No.");
    //                     rec50021.SETRANGE(rec50021."Entry Type", rec50021."Entry Type"::"Cancel IRN");
    //                     IF rec50021.FINDFIRST THEN BEGIN
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021.MODIFY(TRUE);

    //                     END ELSE BEGIN

    //                         rec50021.RESET;
    //                         rec50021.INIT;
    //                         rec50021."Document Type" := rec50021."Document Type"::Invoice;
    //                         rec50021."Sales Inv/Cr Memo No." := TransferShipmentHdr."No.";
    //                         rec50021."External Document No." := TransferShipmentHdr."External Document No.";
    //                         rec50021."Integration Document No." := TransferShipmentHdr."Integration Doc No";
    //                         rec50021."Customer No." := TransferShipmentHdr."Sell-to Customer No.";
    //                         rec50021."Customer Name" := TransferShipmentHdr."Sell-to Customer Name";
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021."Entry Type" := rec50021."Entry Type"::"Cancel IRN";
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021.INSERT(TRUE);

    //                     END;

    //                 END;


    //                 IF (successStatus = True) THEN BEGIN
    //                     //MESSAGE('Response status is %1 and message is %2',successStatus,Statusmessage);
    //                     //result
    //                     IF IRNJObject.Get('result', IRNjtoken) THEN BEGIN
    //                         IRNresultJObject := IRNJtoken.AsObject();
    //                         result := IRNjtoken.AsValue().AsText();
    //                         //MESSAGE(result);
    //                     END;


    //                     //IRN
    //                     IF IRNresultJObject.Get('Irn', IRNResultToken) THEN BEGIN
    //                         //IRNValJObject := IRNValJObject.GetValue('Irn');
    //                         IRN := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;

    //                     //Cancel Date
    //                     IF IRNresultJObject.Get('CancelDate', IRNResultToken) THEN BEGIN
    //                         //IRNCnlDtJObject := IRNCnlDtJObject.GetValue('CancelDate');
    //                         CancelDate := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;
    //                     IRNLdgEnt.RESET;
    //                     IRNLdgEnt.SETRANGE(IRNLdgEnt."Document No.", TransferShipmentHdr."No.");
    //                     IF IRNLdgEnt.FINDFIRST THEN BEGIN
    //                         IRNLdgEnt.CancelIRNDate := CancelDate;
    //                         IRNLdgEnt.VALIDATE(IRNLdgEnt.Status, IRNLdgEnt.Status::Cancelled);
    //                         IRNLdgEnt.MODIFY(TRUE);
    //                     END


    //                     /*
    //                         IRNLdgEnt.RESET;
    //                         IF IRNLdgEnt.FINDSET THEN
    //                           IF IRNLdgEnt.FINDLAST THEN
    //                             Lineno := IRNLdgEnt."Line No." + 10000
    //                           ELSE
    //                             Lineno := 10000;

    //                           IRNLdgEnt.INIT;
    //                           IRNLdgEnt."Document No." := SalInvHdr."No.";
    //                           IRNLdgEnt."Line No." := Lineno;
    //                           IRNLdgEnt."Document Type" := 0;
    //                           IRNLdgEnt."Invoice Type" := SalInvHdr."Invoice Type";
    //                           IRNLdgEnt.IRN := IRN;
    //                           //IRNLdgEnt.SignbedQRCode:=

    //                           IRNLdgEnt."IRN Ack Date" := AckDt;
    //                           IRNLdgEnt.Status := 1;
    //                           IRNLdgEnt.INSERT;
    //                           //QRMgmt.InitializeSignedQRCode(SalInvHdr,SignedQR);
    //                     */
    //                 END;
    //                 //ERASE(FilePath+FileName); // Erase Commented by Rohit
    //             END;

    //             //MESSAGE(AuthJObject.GetValue('statusCode').ToString);

    //         END ELSE
    //             MESSAGE('2' + 'Error when connecting API');//MESSAGE('2'+RegistrationError);

    //     end;

    //     procedure GenerateIRNForCreditMemoBulk(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; TransferShipmentHdr: Record 5744)
    //     var
    //         IRNUrl: Text;
    //         IRNJson: Text;
    //         IRNHttpclint: HttpClient;
    //         IRNHttpContnt: HttpContent;
    //         IRNHttpResponseMsg: HttpResponseMessage;
    //         IRNHttpHdr: HttpHeaders;
    //         IRNREGAccessLevelEnum: Codeunit 8;
    //         IRNPostUrl: Text;
    //         IRNParams: Text;

    //         IRNJObject: JsonObject;
    //         IRNRegistration: Record 3;
    //         IRNApiResult: Text;
    //         // IRNTempBlob: Record "99008535;
    //         // IRNRequestBlob: Record "99008535;
    //         IRNInstr: InStream;
    //         IRNbody: BigText;
    //         IRNjsonobj: Integer;
    //         IRNToken: Text;

    //         IRNresultJObject: JsonObject;

    //         IRNsuccessJObject: JsonObject;

    //         IRNmessageJObject: JsonObject;

    //         IRNAckNoJObject: JsonObject;

    //         IRNAckDtJObject: JsonObject;

    //         IRNValJObject: JsonObject;
    //         successStatus: Boolean;
    //         Statusmessage: Text;
    //         AckNo: Text;
    //         AckDt: Text;
    //         IRN: Text;
    //         JsonMgmt: Codeunit 50009;
    //         result: Text;
    //         Lineno: Integer;
    //         IRNLdgEnt: Record 50020;
    //         SignedQR: Text;

    //         IRNSignQRJObject: JsonObject;
    //         QRMgmt: Codeunit 50011;
    //         AuthToken: Text;
    //         InvoiceJson: Text;
    //         MyFile: File;
    //         StreamInTest: InStream;
    //         Buffer: Text;
    //         SInvNo: Text;
    //         FilePath: Text;
    //         FileName: Text;
    //         OutStr: OutStream;
    //         IRNJtoken: JsonToken;
    //         IRNResultToken: JsonToken;
    //     begin
    //         //For Pittie
    //         //'https://gsp.adaequare.com/test/enriched/ei/api/invoice';

    //         //IRNPostUrl:= 'https://gsp.adaequare.com/enriched/ei/api/invoice';

    //         //For EA
    //         IRNPostUrl := 'https://gsp.adaequare.com/enriched/ei/api/invoice';

    //         IRNHttpContnt.GetHeaders(IRNHttpHdr);
    //         IRNHttpHdr.Remove('Content-Type');
    //         IRNHttpHdr.Add('Content-Type', 'application/json');
    //         IRNHttpHdr.Remove('Return-Type');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('user_name', user_name);
    //         IRNHttpHdr.Add('password', password);
    //         IRNHttpHdr.Add('gstin', gstin);
    //         IRNHttpHdr.Add('requestid', GenerateReqId);
    //         IRNHttpHdr.Add('Authorization', Authorization);

    //         IRNbody := JsonMgmt.CreateCreditMemoJSON(TransferShipmentHdr);// For Credit Memo
    //                                                             //done
    //         IRNHttpContnt.WriteFrom(format(IRNbody));
    //         if IRNHttpclint.Post(PostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
    //             IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);

    //             IF IRNApiResult <> '' THEN BEGIN
    //                 //MESSAGE(IRNApiResult);

    //                 IRNJObject.ReadFrom(IRNApiResult);
    //                 IRNsuccessJObject.ReadFrom(IRNApiResult);
    //                 IRNmessageJObject.ReadFrom(IRNApiResult);
    //                 IRNresultJObject.ReadFrom(IRNApiResult);

    //                 //"success"
    //                 IF IRNJObject.Get('success', IRNJtoken) THEN BEGIN

    //                     successStatus := IRNJtoken.AsValue().AsBoolean();
    //                     //  MESSAGE(successStatus);
    //                 END;

    //                 //"message"
    //                 IF IRNJObject.Get('message', IRNJtoken) THEN BEGIN
    //                     Statusmessage := IRNJtoken.AsValue().AsText();
    //                     MESSAGE(Statusmessage);
    //                 END;

    //                 IF successStatus = False THEN BEGIN

    //                     rec50021.RESET;
    //                     rec50021.SETRANGE(rec50021."Document Type", rec50021."Document Type"::"Credit Memo");
    //                     rec50021.SETRANGE("Sales Inv/Cr Memo No.", TransferShipmentHdr."No.");
    //                     rec50021.SETRANGE(rec50021."Entry Type", rec50021."Entry Type"::"Generate IRN");
    //                     IF rec50021.FINDFIRST THEN BEGIN
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021.MODIFY(TRUE);

    //                     END ELSE BEGIN

    //                         rec50021.RESET;
    //                         rec50021.INIT;
    //                         rec50021."Document Type" := rec50021."Document Type"::"Credit Memo";
    //                         rec50021."Sales Inv/Cr Memo No." := TransferShipmentHdr."No.";
    //                         rec50021."External Document No." := TransferShipmentHdr."External Document No.";
    //                         rec50021."Integration Document No." := TransferShipmentHdr."Integration Doc No";
    //                         rec50021."Customer No." := TransferShipmentHdr."Sell-to Customer No.";
    //                         rec50021."Customer Name" := TransferShipmentHdr."Sell-to Customer Name";
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021."Entry Type" := rec50021."Entry Type"::"Generate IRN";
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021.INSERT(TRUE);

    //                     END;

    //                 END;



    //                 IF (successStatus = True) THEN BEGIN
    //                     //MESSAGE('Response status is %1 and message is %2',successStatus,Statusmessage);
    //                     //result
    //                     IF IRNJObject.Get('result', IRNjtoken) THEN BEGIN
    //                         IRNresultJObject := IRNJtoken.AsObject();
    //                         result := IRNjtoken.AsValue().AsText();
    //                         //MESSAGE(result);
    //                     END;

    //                     //"AckNo"
    //                     IF IRNresultJObject.Get('AckNo', IRNResultToken) THEN BEGIN

    //                         AckNo := jtoken.AsValue().AsText();
    //                         //MESSAGE(AckNo);
    //                     END;

    //                     //AckDt
    //                     IF IRNresultJObject.Get('AckDt', IRNResultToken) THEN BEGIN
    //                         //IRNAckDtJObject := IRNAckDtJObject.GetValue('AckDt');
    //                         AckDt := jtoken.AsValue().AsText();
    //                         //MESSAGE(AckDt);
    //                     END;

    //                     //IRN
    //                     IF IRNresultJObject.Get('Irn', IRNResultToken) THEN BEGIN
    //                         //IRNValJObject := IRNValJObject.GetValue('Irn');
    //                         IRN := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;


    //                     //SignedQRCode
    //                     IF IRNresultJObject.Get('SignedQRCode', IRNResultToken) THEN BEGIN
    //                         //IRNSignQRJObject := IRNSignQRJObject.GetValue('SignedQRCode');
    //                         SignedQR := jtoken.AsValue().AsText();
    //                         //MESSAGE('SignQRCODE:%1',SignedQR);
    //                     END;
    //                     //MESSAGE('SignQRCODE:%1',SignedQR);
    //                     Lineno := 0;
    //                     IRNLdgEnt.RESET;
    //                     IF IRNLdgEnt.FINDSET THEN
    //                         IF IRNLdgEnt.FINDLAST THEN
    //                             Lineno := IRNLdgEnt."Entry No." + 1
    //                         ELSE
    //                             Lineno := 1;

    //                     IRNLdgEnt.INIT;
    //                     IRNLdgEnt."Entry No." := Lineno;
    //                     IRNLdgEnt."Document No." := TransferShipmentHdr."No.";
    //                     IRNLdgEnt."Document Type" := 1;
    //                     IRNLdgEnt."Invoice Type" := TransferShipmentHdr."Invoice Type";
    //                     IRNLdgEnt.VALIDATE(IRNLdgEnt.IRN, IRN);
    //                     //IRNLdgEnt.SignbedQRCode:=

    //                     IRNLdgEnt."IRN Ack No" := AckNo;
    //                     IRNLdgEnt."IRN Ack Date" := AckDt;
    //                     IRNLdgEnt.Status := 1;
    //                     IRNLdgEnt.INSERT(TRUE);
    //                     QRMgmt.InitializeSignedQRCodeCreditMemo(TransferShipmentHdr, SignedQR); //Commented for QR Code Nitish

    //                 END;
    //                 //ERASE(FilePath+FileName); // Erase Commented by Rohit
    //             END;

    //             //MESSAGE(AuthJObject.GetValue('statusCode').ToString);

    //         END ELSE
    //             MESSAGE('2' + 'Error when connecting API');
    //     end;

    //     procedure CancelIRNCreditMemoBulk(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; TransferShipmentHdr: Record 5744)
    //     var
    //         RNUrl: Text;
    //         IRNJson: Text;
    //         IRNHttpclint: HttpClient;
    //         IRNHttpContnt: HttpContent;
    //         IRNHttpResponseMsg: HttpResponseMessage;
    //         IRNHttpHdr: HttpHeaders;
    //         IRNREGAccessLevelEnum: Codeunit 8;
    //         IRNPostUrl: Text;
    //         IRNParams: Text;

    //         IRNJObject: JsonObject;
    //         IRNRegistration: Record 3;
    //         IRNApiResult: Text;
    //         // IRNTempBlob: Record 99008535;
    //         // IRNRequestBlob: Record 99008535;
    //         IRNInstr: InStream;
    //         IRNbody: BigText;
    //         IRNjsonobj: Integer;
    //         IRNToken: Text;

    //         IRNresultJObject: JsonObject;

    //         IRNsuccessJObject: JsonObject;

    //         IRNmessageJObject: JsonObject;

    //         IRNAckNoJObject: JsonObject;

    //         IRNAckDtJObject: JsonObject;

    //         IRNValJObject: JsonObject;
    //         successStatus: Boolean;
    //         Statusmessage: Text;
    //         AckNo: Text;
    //         AckDt: Text;
    //         IRN: Text;
    //         JsonMgmt: Codeunit 50009;
    //         result: Text;
    //         Lineno: Integer;
    //         IRNLdgEnt: Record 50020;
    //         SignedQR: Text;

    //         IRNCnlDtJObject: JsonObject;
    //         QRMgmt: Codeunit "eInvoice_QRCode Mgmt.";
    //         AuthToken: Text;
    //         InvoiceJson: Text;
    //         MyFile: File;
    //         StreamInTest: InStream;
    //         Buffer: Text;
    //         SInvNo: Text;
    //         FilePath: Text;
    //         FileName: Text;
    //         CancelDate: Text;
    //         IRNJtoken: JsonToken;
    //         IRNResultToken: JsonToken;
    //     begin
    //         //IRNPostUrl:='https://gsp.adaequare.com/test/enriched/ei/api/invoice/cancel';

    //         //'https://gsp.adaequare.com/test/enriched/ei/api/invoice/cancel';

    //         //IRNPostUrl:= 'https://gsp.adaequare.com/enriched/ei/api/invoice/cancel';

    //         IRNPostUrl := 'https://gsp.adaequare.com/enriched/ei/api/invoice/cancel';


    //         IRNHttpContnt.GetHeaders(IRNHttpHdr);
    //         IRNHttpHdr.Add('user_name', user_name);
    //         IRNHttpHdr.Add('password', password);
    //         IRNHttpHdr.Remove('Content-Type');
    //         IRNHttpHdr.Add('Content-Type', 'application/json');
    //         IRNHttpHdr.Remove('Return-Type');
    //         IRNHttpHdr.Add('gstin', gstin);
    //         IRNHttpHdr.Add('requestid', GenerateReqId);
    //         IRNHttpHdr.Add('Authorization', Authorization);
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         IRNHttpHdr.Add('Return-Type', 'application/json');
    //         //MESSAGE(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));
    //         //IRNHttpWebRequestMgt.AddBodyAsText(JsonMgmt.CreateeInvoiceJSON(SalInvHdr));

    //         IRNbody := JsonMgmt.CancelIRNCreditMemo(TransferShipmentHdr);


    //         IRNHttpContnt.WriteFrom(format(IRNbody));
    //         if IRNHttpclint.Post(PostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
    //             IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);

    //             IF IRNApiResult <> '' THEN BEGIN
    //                 //MESSAGE(IRNApiResult);

    //                 IRNJObject.ReadFrom(IRNApiResult);
    //                 IRNsuccessJObject.ReadFrom(IRNApiResult);
    //                 IRNmessageJObject.ReadFrom(IRNApiResult);
    //                 IRNresultJObject.ReadFrom(IRNApiResult);
    //                 //"success"
    //                 IF IRNJObject.Get('success', IRNJtoken) THEN BEGIN

    //                     successStatus := IRNJtoken.AsValue().AsBoolean();
    //                     //  MESSAGE(successStatus);
    //                 END;

    //                 //"message"
    //                 IF IRNJObject.Get('message', IRNJtoken) THEN BEGIN
    //                     Statusmessage := IRNJtoken.AsValue().AsText();
    //                     MESSAGE(Statusmessage);
    //                 END;

    //                 IF successStatus = False THEN BEGIN

    //                     rec50021.RESET;
    //                     rec50021.SETRANGE(rec50021."Document Type", rec50021."Document Type"::"Credit Memo");
    //                     rec50021.SETRANGE("Sales Inv/Cr Memo No.", TransferShipmentHdr."No.");
    //                     rec50021.SETRANGE(rec50021."Entry Type", rec50021."Entry Type"::"Cancel IRN");
    //                     IF rec50021.FINDFIRST THEN BEGIN
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021.MODIFY(TRUE);

    //                     END ELSE BEGIN

    //                         rec50021.RESET;
    //                         rec50021.INIT;
    //                         rec50021."Document Type" := rec50021."Document Type"::"Credit Memo";
    //                         rec50021."Sales Inv/Cr Memo No." := TransferShipmentHdr."No.";
    //                         rec50021."External Document No." := TransferShipmentHdr."External Document No.";
    //                         rec50021."Integration Document No." := TransferShipmentHdr."Integration Doc No";
    //                         rec50021."Customer No." := TransferShipmentHdr."Sell-to Customer No.";
    //                         rec50021."Customer Name" := TransferShipmentHdr."Sell-to Customer Name";
    //                         rec50021."Last Updated On" := CURRENTDATETIME;
    //                         rec50021."Entry Type" := rec50021."Entry Type"::"Cancel IRN";
    //                         IF STRLEN(Statusmessage) > 250 THEN BEGIN
    //                             rec50021.Response := COPYSTR(Statusmessage, 1, 250);
    //                         END ELSE BEGIN
    //                             rec50021.Response := Statusmessage;
    //                         END;
    //                         rec50021.INSERT(TRUE);

    //                     END;

    //                 END;



    //                 IF (successStatus = True) THEN BEGIN
    //                     //MESSAGE('Response status is %1 and message is %2',successStatus,Statusmessage);
    //                     //result
    //                     IF IRNJObject.Get('result', IRNjtoken) THEN BEGIN
    //                         IRNresultJObject := IRNJtoken.AsObject();
    //                         result := IRNjtoken.AsValue().AsText();
    //                         //MESSAGE(result);
    //                     END;


    //                     //IRN
    //                     IF IRNresultJObject.Get('Irn', IRNResultToken) THEN BEGIN
    //                         //IRNValJObject := IRNValJObject.GetValue('Irn');
    //                         IRN := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;

    //                     //Cancel Date
    //                     IF IRNresultJObject.Get('CancelDate', IRNResultToken) THEN BEGIN
    //                         //IRNCnlDtJObject := IRNCnlDtJObject.GetValue('CancelDate');
    //                         CancelDate := jtoken.AsValue().AsText();
    //                         //MESSAGE(IRN);
    //                     END;

    //                     IRNLdgEnt.RESET;
    //                     IRNLdgEnt.SETRANGE(IRNLdgEnt."Document No.", TransferShipmentHdr."No.");
    //                     IF IRNLdgEnt.FINDFIRST THEN BEGIN
    //                         IRNLdgEnt.CancelIRNDate := CancelDate;
    //                         IRNLdgEnt.VALIDATE(IRNLdgEnt.Status, IRNLdgEnt.Status::Cancelled);
    //                         IRNLdgEnt.MODIFY(TRUE);
    //                     END


    //                     /*
    //                         IRNLdgEnt.RESET;
    //                         IF IRNLdgEnt.FINDSET THEN
    //                           IF IRNLdgEnt.FINDLAST THEN
    //                             Lineno := IRNLdgEnt."Line No." + 10000
    //                           ELSE
    //                             Lineno := 10000;

    //                           IRNLdgEnt.INIT;
    //                           IRNLdgEnt."Document No." := SalInvHdr."No.";
    //                           IRNLdgEnt."Line No." := Lineno;
    //                           IRNLdgEnt."Document Type" := 0;
    //                           IRNLdgEnt."Invoice Type" := SalInvHdr."Invoice Type";
    //                           IRNLdgEnt.IRN := IRN;
    //                           //IRNLdgEnt.SignbedQRCode:=

    //                           IRNLdgEnt."IRN Ack Date" := AckDt;
    //                           IRNLdgEnt.Status := 1;
    //                           IRNLdgEnt.INSERT;
    //                           //QRMgmt.InitializeSignedQRCode(SalInvHdr,SignedQR);
    //                     */
    //                 END;
    //                 //ERASE(FilePath+FileName); // Erase Commented by Rohit
    //             END;

    //             //MESSAGE(AuthJObject.GetValue('statusCode').ToString);

    //         END ELSE
    //             MESSAGE('2' + 'Error when connecting API');//MESSAGE('2'+RegistrationError);

    //     end;*/

    procedure GenerateEwayBillByIRN(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; Var TransferHeader: Record "Transfer Shipment Header")
    var
        IRNUrl: Text;
        IRNJson: Text;
        IRNHttpclint: HttpClient;
        IRNHttpContnt: HttpContent;
        IRNHttpResponseMsg: HttpResponseMessage;
        IRNHttpHdr: HttpHeaders;
        IRNREGAccessLevelEnum: Codeunit 8;
        IRNPostUrl: Text;
        IRNParams: Text;
        IRNJObject: JsonObject;
        IRNRegistration: Record 3;
        IRNApiResult: Text;
        IRNTempBlob: Codeunit "Temp Blob";
        //IRNRequestBlob: Record 99008535;
        IRNInstr: InStream;
        IRNbody: BigText;
        IRNjsonobj: Integer;
        IRNToken: Text;

        IRNresultJObject: JsonObject;

        IRNsuccessJObject: JsonObject;

        IRNmessageJObject: JsonObject;

        IRNAckNoJObject: JsonObject;

        IRNAckDtJObject: JsonObject;

        IRNValJObject: JsonObject;
        successStatus: Boolean;
        Statusmessage: Text;
        AckNo: Text;
        AckDt: Text;
        IRN: Text;
        SignedInvoice: Text;
        JsonMgmt: Codeunit 50155;
        result: Text;
        Lineno: Integer;
        //IRNLdgEnt: Record 50020;
        SignedQR: Text;

        IRNSignQRJObject: JsonObject;
        QRMgmt: Codeunit 50157;
        AuthToken: Text;
        InvoiceJson: Text;
        MyFile: File;
        StreamInTest: InStream;
        Buffer: Text;
        SInvNo: Text;
        FilePath: Text;
        FileName: Text;
        OutStr: OutStream;
        IRNJtoken: JsonToken;
        IRNResultToken: JsonToken;
        Httpclint: HttpClient;
        HttpContnt: HttpContent;
        distancetxt: text;
        IRNArray: JsonArray;
    begin
        recGeneralLedSet.Get();
        // IRNPostUrl := 'https://gsp.adaequare.com/test/enriched/ei/api/ewaybill';
        IRNPostUrl := recGeneralLedSet."E_Way Bill URL";
        IRNbody := JsonMgmt."Generate E-Way-BillByIRN"(TransferHeader);
        IRNHttpContnt.WriteFrom(Format(IRNbody));
        IRNHttpContnt.GetHeaders(IRNHttpHdr);
        // IRNHttpHdr.Add('user_name', user_name);
        // IRNHttpHdr.Add('password', password);
        IRNHttpHdr.Remove('Content-Type');
        IRNHttpHdr.Add('Content-Type', 'application/json');
        IRNHttpHdr.Remove('Return-Type');
        //IRNHttpHdr.Add('gstin', gstin);
        //IRNHttpHdr.Add('requestid', GenerateReqId);
        //IRNHttpHdr.Add('Authorization', Authorization);
        IRNHttpHdr.Add('Return-Type', 'application/json');
        // IRNHttpHdr.Add('Return-Type', 'application/json');

        IRNHttpclint.DefaultRequestHeaders.Add('user_name', user_name);
        IRNHttpclint.DefaultRequestHeaders.Add('password', password);
        IRNHttpclint.DefaultRequestHeaders.Add('gstin', gstin);
        IRNHttpclint.DefaultRequestHeaders.Add('requestid', GenerateReqId);
        IRNHttpclint.DefaultRequestHeaders.Add('Authorization', Authorization);
        IRNHttpclint.Timeout(60000 * 3);
        if IRNHttpclint.Post(IRNPostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
            //response.Read(IRNApiResult);
            IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);
            IF IRNApiResult <> '' THEN BEGIN
                Message('Request payload %1', IRNbody);
                MESSAGE(IRNApiResult);
                //"access_token":

                IRNresultJObject.ReadFrom(IRNApiResult);
                IRNresultJObject.Get('success', IRNResultToken);
                successStatus := IRNResultToken.AsValue().AsBoolean();

                if successStatus = true then begin
                    if IRNresultJObject.Get('result', IRNResultToken) then begin
                        IRNmessageJObject := IRNResultToken.AsObject();
                        if IRNmessageJObject.Get('EwbNo', IRNJToken) then
                            TransferHeader."E-Way Bill No." := IRNJtoken.AsValue().AsText();
                        if IRNmessageJObject.Get('EwbDt', IRNJToken) then begin
                            TransferHeader."E-Way Bill DateTime" := IRNJtoken.AsValue().AsText();//astext
                            //TransferHeader."E-Way Bill Date" := DT2Date(TransferHeader."E-Way Bill DateTime");
                        end;
                        if IRNmessageJObject.Get('EwbValidTill', IRNJToken) then
                            TransferHeader."E-Way Bill Valid Upto" := IRNJtoken.AsValue().AsText();//astext


                    end;
                    if IRNresultJObject.Get('info', IRNResultToken) then begin
                        IRNArray := IRNResultToken.AsArray();
                        IRNArray.Get(0, IRNResultToken);
                        IRNmessageJObject := IRNResultToken.AsObject();
                        //  if IRNmessageJObject.Get('InfCd', IRNJToken) then
                        //     TransferHeader."E-Way Bill Valid Upto" := IRNJtoken.AsValue().AsDateTime();
                        if TransferHeader."Distance (Km)" = 0 then
                            if IRNmessageJObject.Get('Desc', IRNJToken) then begin
                                distancetxt := IRNJtoken.AsValue().AsText().TrimEnd('KM');
                                distancetxt := distancetxt.TrimStart('Pin-Pin calc distance:');
                                Evaluate(TransferHeader."Distance (Km)", distancetxt);
                            end;
                        //TransferHeader."Distance (Km)" := ;
                    end;
                    TransferHeader.Modify();
                end;
                if successStatus = false then begin
                    message('Error occurred while generating E-Way bill %1', IRNApiResult);
                    // IRNmessageJObject.Get('message', IRNJtoken);
                    // Message(jtoken.AsValue().AsText());
                end;


            end;

        end;
        /*{
    "success": true,
    "message": "E-Way Bill generated successfully",
    "result": {
        "EwbNo": 361009196027,
        "EwbDt": "2023-04-18 12:38:00",
        "EwbValidTill": "2023-05-01 23:59:00"
    },
    "info": [
        {
            "InfCd": "EWBPPD",
            "Desc": "Pin-Pin calc distance: 2555KM"
        }
    ]
}*/

    end;

    procedure CancelEwayBill(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; Var TransferHeader: Record "Transfer Shipment Header")
    var
        IRNUrl: Text;
        IRNJson: Text;
        IRNHttpclint: HttpClient;
        IRNHttpContnt: HttpContent;
        IRNHttpResponseMsg: HttpResponseMessage;
        IRNHttpHdr: HttpHeaders;
        IRNREGAccessLevelEnum: Codeunit 8;
        IRNPostUrl: Text;
        IRNParams: Text;
        IRNJObject: JsonObject;
        IRNRegistration: Record 3;
        IRNApiResult: Text;
        IRNTempBlob: Codeunit "Temp Blob";
        //IRNRequestBlob: Record 99008535;
        IRNInstr: InStream;
        IRNbody: Text;
        IRNjsonobj: Integer;
        IRNToken: Text;

        IRNresultJObject: JsonObject;

        IRNsuccessJObject: JsonObject;

        IRNmessageJObject: JsonObject;

        IRNAckNoJObject: JsonObject;

        IRNAckDtJObject: JsonObject;

        IRNValJObject: JsonObject;
        successStatus: Boolean;
        Statusmessage: Text;
        AckNo: Text;
        AckDt: Text;
        IRN: Text;
        SignedInvoice: Text;
        JsonMgmt: Codeunit 50155;
        result: Text;
        Lineno: Integer;
        //IRNLdgEnt: Record 50020;
        SignedQR: Text;

        IRNSignQRJObject: JsonObject;
        QRMgmt: Codeunit 50157;
        AuthToken: Text;
        InvoiceJson: Text;
        MyFile: File;
        StreamInTest: InStream;
        Buffer: Text;
        SInvNo: Text;
        FilePath: Text;
        FileName: Text;
        OutStr: OutStream;
        IRNJtoken: JsonToken;
        IRNResultToken: JsonToken;
        Httpclint: HttpClient;
        HttpContnt: HttpContent;
        distancetxt: text;
        IRNArray: JsonArray;
    begin
        // IRNPostUrl := 'https://gsp.adaequare.com/test/enriched/ei/api/ewayapi';
        // IRNPostUrl := 'https://gsp.adaequare.com/enriched/ei/api/ewayapi';
        recGeneralLedSet.Get();
        IRNPostUrl := recGeneralLedSet."Cancel E-Way Bill";
        IRNbody := JsonMgmt.CancelEwayBill(TransferHeader);
        IRNHttpContnt.WriteFrom(Format(IRNbody));
        IRNHttpContnt.GetHeaders(IRNHttpHdr);
        // IRNHttpHdr.Add('user_name', user_name);
        // IRNHttpHdr.Add('password', password);
        IRNHttpHdr.Remove('Content-Type');
        IRNHttpHdr.Add('Content-Type', 'application/json');
        IRNHttpHdr.Remove('Return-Type');
        //IRNHttpHdr.Add('gstin', gstin);
        //IRNHttpHdr.Add('requestid', GenerateReqId);
        //IRNHttpHdr.Add('Authorization', Authorization);
        IRNHttpHdr.Add('Return-Type', 'application/json');
        // IRNHttpHdr.Add('Return-Type', 'application/json');

        IRNHttpclint.DefaultRequestHeaders.Add('username', user_name);
        IRNHttpclint.DefaultRequestHeaders.Add('password', password);
        IRNHttpclint.DefaultRequestHeaders.Add('gstin', gstin);
        IRNHttpclint.DefaultRequestHeaders.Add('requestid', GenerateReqId);
        IRNHttpclint.DefaultRequestHeaders.Add('Authorization', Authorization);
        IRNHttpclint.Timeout(60000 * 3);
        if IRNHttpclint.Post(IRNPostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
            //response.Read(IRNApiResult);
            IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);
            IF IRNApiResult <> '' THEN BEGIN
                Message('Request payload %1', IRNbody);
                MESSAGE(IRNApiResult);
                //"access_token":

                IRNresultJObject.ReadFrom(IRNApiResult);
                IRNresultJObject.Get('success', IRNResultToken);
                successStatus := IRNResultToken.AsValue().AsBoolean();

                if successStatus = true then begin
                    if IRNresultJObject.Get('result', IRNResultToken) then begin
                        IRNmessageJObject := IRNResultToken.AsObject();

                        if IRNmessageJObject.Get('cancelDate', IRNJToken) then
                            TransferHeader."Canceled Date" := IRNJtoken.AsValue().AsText();//astext


                    end;

                    TransferHeader.Modify();
                end;
                if successStatus = false then begin
                    message('Error occurred while generating E-Way bill %1', IRNApiResult);
                    // IRNmessageJObject.Get('message', IRNJtoken);
                    // Message(jtoken.AsValue().AsText());
                end;


            end;

        end;
        /*{
    "success": true,
    "message": "E-Way bill cancelled successfully",
    "result": {
        "ewayBillNo": "361009196283",
        "cancelDate": "19/04/2023 12:02:00 AM"
    }
}*/

    end;

    procedure CancelIRNEinvoice(user_name: Text; password: Text; gstin: Code[15]; Authorization: Text; Var TransferHeader: Record "Transfer Shipment Header")
    var
        IRNUrl: Text;
        IRNJson: Text;
        IRNHttpclint: HttpClient;
        IRNHttpContnt: HttpContent;
        IRNHttpResponseMsg: HttpResponseMessage;
        IRNHttpHdr: HttpHeaders;
        IRNREGAccessLevelEnum: Codeunit 8;
        IRNPostUrl: Text;
        IRNParams: Text;
        IRNJObject: JsonObject;
        IRNRegistration: Record 3;
        IRNApiResult: Text;
        IRNTempBlob: Codeunit "Temp Blob";
        //IRNRequestBlob: Record 99008535;
        IRNInstr: InStream;
        IRNbody: Text;
        IRNjsonobj: Integer;
        IRNToken: Text;

        IRNresultJObject: JsonObject;

        IRNsuccessJObject: JsonObject;

        IRNmessageJObject: JsonObject;

        IRNAckNoJObject: JsonObject;

        IRNAckDtJObject: JsonObject;

        IRNValJObject: JsonObject;
        successStatus: Boolean;
        Statusmessage: Text;
        AckNo: Text;
        AckDt: Text;
        IRN: Text;
        SignedInvoice: Text;
        JsonMgmt: Codeunit 50155;
        result: Text;
        Lineno: Integer;
        //IRNLdgEnt: Record 50020;
        SignedQR: Text;

        IRNSignQRJObject: JsonObject;
        QRMgmt: Codeunit 50157;
        AuthToken: Text;
        InvoiceJson: Text;
        MyFile: File;
        StreamInTest: InStream;
        Buffer: Text;
        SInvNo: Text;
        FilePath: Text;
        FileName: Text;
        OutStr: OutStream;
        IRNJtoken: JsonToken;
        IRNResultToken: JsonToken;
        Httpclint: HttpClient;
        HttpContnt: HttpContent;
        distancetxt: text;
        IRNArray: JsonArray;
    begin
        // IRNPostUrl := 'https://gsp.adaequare.com/test/enriched/ei/api/invoice/cancel';
        //IRNPostUrl := 'https://gsp.adaequare.com/enriched/ei/api/invoice/cancel';
        recGeneralLedSet.Get();
        IRNPostUrl := recGeneralLedSet."Cancel E-Invoice URL";
        IRNbody := JsonMgmt.CancelIRN(TransferHeader);
        IRNHttpContnt.WriteFrom(Format(IRNbody));
        IRNHttpContnt.GetHeaders(IRNHttpHdr);
        // IRNHttpHdr.Add('user_name', user_name);
        // IRNHttpHdr.Add('password', password);
        IRNHttpHdr.Remove('Content-Type');
        IRNHttpHdr.Add('Content-Type', 'application/json');
        IRNHttpHdr.Remove('Return-Type');
        //IRNHttpHdr.Add('gstin', gstin);
        //IRNHttpHdr.Add('requestid', GenerateReqId);
        //IRNHttpHdr.Add('Authorization', Authorization);
        IRNHttpHdr.Add('Return-Type', 'application/json');
        // IRNHttpHdr.Add('Return-Type', 'application/json');

        IRNHttpclint.DefaultRequestHeaders.Add('user_name', user_name);
        IRNHttpclint.DefaultRequestHeaders.Add('password', password);
        IRNHttpclint.DefaultRequestHeaders.Add('gstin', gstin);
        IRNHttpclint.DefaultRequestHeaders.Add('requestid', GenerateReqId);
        IRNHttpclint.DefaultRequestHeaders.Add('Authorization', Authorization);
        IRNHttpclint.Timeout(60000 * 3);
        if IRNHttpclint.Post(IRNPostUrl, IRNHttpContnt, IRNHttpResponseMsg) then begin
            //response.Read(IRNApiResult);
            IRNHttpResponseMsg.Content.ReadAs(IRNApiResult);
            IF IRNApiResult <> '' THEN BEGIN
                Message('Request payload %1', IRNbody);
                MESSAGE(IRNApiResult);
                //"access_token":

                IRNresultJObject.ReadFrom(IRNApiResult);
                IRNresultJObject.Get('success', IRNResultToken);
                successStatus := IRNResultToken.AsValue().AsBoolean();

                if successStatus = true then begin
                    if IRNresultJObject.Get('result', IRNResultToken) then begin
                        IRNmessageJObject := IRNResultToken.AsObject();

                        if IRNmessageJObject.Get('CancelDate', IRNJToken) then
                            TransferHeader."IRN Cancel Date" := IRNJtoken.AsValue().AsText();//astext
                        TransferHeader."IRN Cancalled" := true;

                    end;

                    TransferHeader.Modify();
                end;
                if successStatus = false then begin
                    message('Error occurred while generating Cancelling IRN %1', IRNApiResult);
                    // IRNmessageJObject.Get('message', IRNJtoken);
                    // Message(jtoken.AsValue().AsText());
                end;


            end;

        end;
        /*{
    "success": true,
    "message": "E-Way bill cancelled successfully",
    "result": {
        "ewayBillNo": "361009196283",
        "cancelDate": "19/04/2023 12:02:00 AM"
    }
}*/

    end;



}

