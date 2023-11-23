pageextension 50117 PosTransShipmentExt extends "Posted Transfer Shipment"
{
    layout
    {

        addlast(General)
        {
            field("Aza Posting No."; "Aza Posting No.") { ApplicationArea = all; }
            field("Transfer Reason"; "Transfer Reason") { ApplicationArea = all; Editable = false; }
            field(Merchandiser; Rec.Merchandiser)
            {
                ApplicationArea = all;
                Editable = false;
            }

            field("Total Qty"; "Total Qty") { ApplicationArea = all; Editable = false; }
            field("Total Amt"; "Total Amt") { ApplicationArea = all; Editable = false; }

        }
        addafter("Foreign Trade")
        {
            group("Tax Information")
            {
                field("IRN Hash"; Rec."IRN Hash")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("QR Code"; Rec."QR Code")
                {
                    ApplicationArea = All;
                }
                field("Acknowledgment Date"; rec."Acknowledgment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Acknowledgment N0."; rec."Acknowledgment N0.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Signed Invoice"; Rec."Signed Invoice")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("IRN Cancel Date"; "IRN Cancel Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("IRN Cancalled"; "IRN Cancalled")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // field("E-Way Bill Date"; "E-Way Bill Date")
                // {
                //     ApplicationArea = All;
                // }
                field("E-Way Bill DateTime"; "E-Way Bill DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("E-Way Bill No."; "E-Way Bill No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("E-Way Bill Valid Upto"; "E-Way Bill Valid Upto")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transporter GST REg No"; "Transporter GST REg No")
                {
                    ApplicationArea = All;
                    Caption = 'Transporter GST Reg No.';
                }
                field("Transporter Date"; "Transporter Date")
                {
                    ApplicationArea = All;
                }
                field("Transporter Doc No."; "Transporter Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Transport Mode"; "Transport Mode")
                {
                    ApplicationArea = All;
                }
                field("Transporter Name"; "Transporter Name")
                {
                    ApplicationArea = All;
                }
                field("Canceled Date"; "Canceled Date")
                {
                    ApplicationArea = All;
                    Caption = 'EWB Cancalled Date';
                    Editable = false;
                }

            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action(TaxInvoice)
            {
                Caption = 'Tax Invoice';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    transShipHdr: Record "Transfer Shipment Header";
                begin
                    transShipHdr.Reset();
                    transShipHdr.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::TaxInvoiceTransfer, true, false, transShipHdr);
                end;
            }
            action("Generate IRN")
            {
                //Caption = 'Tax Invoice';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    transShipHdr: Record "Transfer Shipment Header";
                    RecLocation: Record Location;
                    REcState: Record State;
                    LocationGSTNo: Code[30];
                    cuTransferAPI: Codeunit 50156;//commented due to errors 180423
                    UserID: Text;
                    Password: Text;
                    ClientID: Text;
                    ClientSecret: Text;
                    AuthToken: text;
                    GstRegNo: Record "GST Registration Nos.";
                begin
                    IF NOT CONFIRM('Do you want to Generate IRN ?', FALSE)
                      THEN
                        EXIT;

                    UserID := '';
                    Password := '';
                    ClientID := '';
                    ClientSecret := '';
                    LocationGSTNo := '';

                    RecLocation.RESET;
                    RecLocation.SETRANGE(RecLocation.Code, Rec."Transfer-from Code");
                    IF RecLocation.FINDFIRST THEN BEGIN
                        LocationGSTNo := RecLocation."GST Registration No.";
                    END;

                    // REcState.RESET;
                    // REcState.SETRANGE(REcState.Code, RecLocation."State Code");
                    // IF REcState.FINDFIRST THEN BEGIN
                    //     UserIDState := REcState."User Id";
                    //     PasswordState := REcState.Password;
                    // END;
                    if GstRegNo.Get(LocationGSTNo) then begin
                        UserID := GstRegNo."E-Invoice UserName";
                        Password := GstRegNo."E-Invoice Password";
                        ClientID := GstRegNo."E-Invoice Client ID";
                        ClientSecret := GstRegNo."E-Invoice Client Secret";

                    end;

                    IF LocationGSTNo = '' THEN
                        ERROR('GST Reg No must not be blank for state %1', RecLocation."State Code");

                    IF UserID = '' THEN
                        ERROR('User ID must not be blank for state %1', RecLocation."State Code");

                    IF Password = '' THEN
                        ERROR('Password must not be blank for state %1', RecLocation."State Code");

                    IF ClientID = '' THEN
                        ERROR('ClientID must not be blank for state %1', ClientID);

                    IF ClientSecret = '' THEN
                        ERROR('Client secret must not be blank for state %1', ClientSecret);


                    //commented due to errors 180423
                    // AuthToken := 'Bearer ' + cuTransferAPI.GenerateAuthToken('87712B75AAE34C4F8DA3BC97BECFD209', '1D410F73G5486G4E20GB673G1166661FC8B1');
                    // //RecCodeunitAPI.GenerateIRN(UserIDState, PasswordState, LocationGSTNo, AuthToken, Rec);
                    // cuTransferAPI.GenerateIRN('adqgspjkusr1', 'Gsp@1234', '01AMBPG7773M002', AuthToken, Rec);commented080923
                    //1509//AuthToken := 'Bearer ' + cuTransferAPI.GenerateAuthToken('D9BA800FBB71466B9F74D954F914BF97', '2DF7F0D2G4E9FG4EEFGB4E6GF0955698EB73');
                    AuthToken := 'Bearer ' + cuTransferAPI.GenerateAuthToken(ClientID, ClientSecret);
                    cuTransferAPI.GenerateIRN(UserID, Password, LocationGSTNo, AuthToken, Rec);
                    CurrPage.Update(true);
                    Rec.Modify();
                end;
            }
        }
        addafter("Generate IRN")
        {

            action("Generate E-Way-Bill")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    transShipHdr: Record "Transfer Shipment Header";
                    cuTransferAPI: Codeunit 50156;//commented due to errors 180423
                    RecLocation: Record Location;
                    REcState: Record State;
                    LocationGSTNo: Code[30];
                    UserIDState: Text;
                    PasswordState: Text;
                    AuthToken: text;
                    transfshipLine: Record "Transfer Shipment Line";
                    newAmount: Decimal;
                    total: Decimal;
                    LinesCount: Integer;
                    UserID: Text;
                    Password: Text;
                    ClientID: Text;
                    ClientSecret: Text;
                    GstRegNo: Record "GST Registration Nos.";
                begin
                    UserID := '';
                    Password := '';
                    ClientID := '';
                    ClientSecret := '';
                    LocationGSTNo := '';

                    RecLocation.RESET;
                    RecLocation.SETRANGE(RecLocation.Code, Rec."Transfer-from Code");
                    IF RecLocation.FINDFIRST THEN BEGIN
                        LocationGSTNo := RecLocation."GST Registration No.";
                    END;

                    // REcState.RESET;
                    // REcState.SETRANGE(REcState.Code, RecLocation."State Code");
                    // IF REcState.FINDFIRST THEN BEGIN
                    //     UserIDState := REcState."User Id";
                    //     PasswordState := REcState.Password;
                    // END;
                    if GstRegNo.Get(LocationGSTNo) then begin
                        UserID := GstRegNo."E-Invoice UserName";
                        Password := GstRegNo."E-Invoice Password";
                        ClientID := GstRegNo."E-Invoice Client ID";
                        ClientSecret := GstRegNo."E-Invoice Client Secret";

                    end;

                    IF LocationGSTNo = '' THEN
                        ERROR('GST Reg No must not be blank for state %1', RecLocation."State Code");

                    IF UserID = '' THEN
                        ERROR('User ID must not be blank for state %1', RecLocation."State Code");

                    IF Password = '' THEN
                        ERROR('Password must not be blank for state %1', RecLocation."State Code");

                    IF ClientID = '' THEN
                        ERROR('ClientID must not be blank for state %1', ClientID);

                    IF ClientSecret = '' THEN
                        ERROR('Client secret must not be blank for state %1', ClientSecret);


                    //Nkp++
                    // transfshipLine.Reset();
                    // newAmount := 0;
                    // transfshipLine.SetRange("Document No.", "No.");
                    // if transfshipLine.FindSet() then
                    //     repeat
                    //         newAmount += transfshipLine.Amount;
                    //     // total += newAmount;
                    //     //Message('%1', newAmount);

                    //     until transfshipLine.Next = 0;
                    // if newAmount < 50000 then
                    //     Error('Transfer order Amount should be greater than 50000 to Generate Eway-Bill');
                    //Nkp--
                    //commented due to errors 180423
                    AuthToken := 'Bearer ' + cuTransferAPI.GenerateAuthToken(ClientID, ClientSecret);
                    //RecCodeunitAPI.GenerateIRN(UserIDState, PasswordState, LocationGSTNo, AuthToken, Rec);
                    cuTransferAPI.GenerateEwayBillByIRN(UserID, Password, LocationGSTNo, AuthToken, Rec);
                    CurrPage.Update(true);
                end;
            }
            action("Cancel E-Way-Bill")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    transShipHdr: Record "Transfer Shipment Header";
                    cuTransferAPI: Codeunit 50156;//commented due to errors 180423
                    RecLocation: Record Location;
                    REcState: Record State;
                    LocationGSTNo: Code[30];
                    UserIDState: Text;
                    PasswordState: Text;
                    AuthToken: text;
                    UserID: Text;
                    Password: Text;
                    ClientID: Text;
                    ClientSecret: Text;
                    GstRegNo: Record "GST Registration Nos.";

                begin
                    UserID := '';
                    Password := '';
                    ClientID := '';
                    ClientSecret := '';
                    LocationGSTNo := '';

                    RecLocation.RESET;
                    RecLocation.SETRANGE(RecLocation.Code, Rec."Transfer-from Code");
                    IF RecLocation.FINDFIRST THEN BEGIN
                        LocationGSTNo := RecLocation."GST Registration No.";
                    END;
                    if GstRegNo.Get(LocationGSTNo) then begin
                        UserID := GstRegNo."E-Invoice UserName";
                        Password := GstRegNo."E-Invoice Password";
                        ClientID := GstRegNo."E-Invoice Client ID";
                        ClientSecret := GstRegNo."E-Invoice Client Secret";

                    end;

                    IF LocationGSTNo = '' THEN
                        ERROR('GST Reg No must not be blank for state %1', RecLocation."State Code");

                    IF UserID = '' THEN
                        ERROR('User ID must not be blank for state %1', RecLocation."State Code");

                    IF Password = '' THEN
                        ERROR('Password must not be blank for state %1', RecLocation."State Code");

                    IF ClientID = '' THEN
                        ERROR('ClientID must not be blank for state %1', ClientID);

                    IF ClientSecret = '' THEN
                        ERROR('Client secret must not be blank for state %1', ClientSecret);
                    //commented due to errors 180423
                    AuthToken := 'Bearer ' + cuTransferAPI.GenerateAuthToken(ClientID, ClientSecret);
                    //RecCodeunitAPI.GenerateIRN(UserIDState, PasswordState, LocationGSTNo, AuthToken, Rec);
                    cuTransferAPI.CancelEwayBill(UserID, Password, LocationGSTNo, AuthToken, Rec);
                    CurrPage.Update(true);

                end;
            }
        }
        addafter("Generate IRN")
        {
            action("Cancel IRN")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    transShipHdr: Record "Transfer Shipment Header";
                    RecLocation: Record Location;
                    REcState: Record State;
                    LocationGSTNo: Code[30];
                    cuTransferAPI: Codeunit 50156;//commented due to errors 180423
                    UserID: Text;
                    Password: Text;
                    ClientID: Text;
                    ClientSecret: Text;
                    AuthToken: text;
                    GstRegNo: Record "GST Registration Nos.";

                begin
                    // //commented due to errors 180423
                    // AuthToken := 'Bearer ' + cuTransferAPI.GenerateAuthToken('87712B75AAE34C4F8DA3BC97BECFD209', '1D410F73G5486G4E20GB673G1166661FC8B1');
                    // //RecCodeunitAPI.GenerateIRN(UserIDState, PasswordState, LocationGSTNo, AuthToken, Rec);
                    // cuTransferAPI.CancelIRNEinvoice('adqgspjkusr1', 'Gsp@1234', '01AMBPG7773M002', AuthToken, Rec);
                    // CurrPage.Update(true);

                    UserID := '';
                    Password := '';
                    ClientID := '';
                    ClientSecret := '';
                    LocationGSTNo := '';

                    RecLocation.RESET;
                    RecLocation.SETRANGE(RecLocation.Code, Rec."Transfer-from Code");
                    IF RecLocation.FINDFIRST THEN BEGIN
                        LocationGSTNo := RecLocation."GST Registration No.";
                    END;
                    if GstRegNo.Get(LocationGSTNo) then begin
                        UserID := GstRegNo."E-Invoice UserName";
                        Password := GstRegNo."E-Invoice Password";
                        ClientID := GstRegNo."E-Invoice Client ID";
                        ClientSecret := GstRegNo."E-Invoice Client Secret";

                    end;

                    IF LocationGSTNo = '' THEN
                        ERROR('GST Reg No must not be blank for state %1', RecLocation."State Code");

                    IF UserID = '' THEN
                        ERROR('User ID must not be blank for state %1', RecLocation."State Code");

                    IF Password = '' THEN
                        ERROR('Password must not be blank for state %1', RecLocation."State Code");

                    IF ClientID = '' THEN
                        ERROR('ClientID must not be blank for state %1', ClientID);

                    IF ClientSecret = '' THEN
                        ERROR('Client secret must not be blank for state %1', ClientSecret);


                    AuthToken := 'Bearer ' + cuTransferAPI.GenerateAuthToken(ClientID, ClientSecret);
                    cuTransferAPI.CancelIRNEinvoice(UserID, Password, LocationGSTNo, AuthToken, Rec);
                    CurrPage.Update(true);
                    Rec.Modify();
                end;
            }
        }

    }
    // trigger OnAfterGetRecord()
    // var
    //     myInt: Integer;
    //     salesorderdtls: Record "Transfer Header";
    //     taxablevalue: Decimal;
    // begin
    //     if salesorderdtls.Get(Rec."No.") then begin
    //         merch := salesorderdtls.Merchandiser;

    //     end;


    //end;

    var
        myInt: Integer;
        merch: Text;
}