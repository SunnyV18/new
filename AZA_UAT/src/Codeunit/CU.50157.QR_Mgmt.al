codeunit 50157 "eInvoice_QRCode Mgmt."
{
    // Rohit 21.12.2020
    // 1.Rohit Code commented

    Permissions = TableData 112 = rimd,
                  TableData 114 = rimd,
                  tabledata 5744 =rimd;

    trigger OnRun()
    begin
    end;

    var
        ThreeTierMgt: Codeunit 419;

    // procedure InitializeSignedQRCode(SalInvHdr: Record 112; SignQR: Text)
    // var
    //     CompanyInfo: Record "Company Information";
    //     TempBlob: Codeunit "Temp Blob";
    //     QRCodeInput: Text[1024];
    //     QRCodeFileName: Text[1024];
    //     IRNLdgEnt: Record 50020;
    //     JSONManagement: Codeunit "JSON Management";
    //     QRGenerator: Codeunit "QR Generator";
    //     recRef: RecordRef;
    //     FieldRef: FieldRef;
    // begin


    //     IRNLdgEnt.SETRANGE("Document No.", SalInvHdr."No.");
    //     IRNLdgEnt.SETRANGE("Document Type", 0);
    //     //IRNLdgEnt.SETRANGE("Invoice Type",SalInvHdr."Invoice Type");
    //     IF IRNLdgEnt.FINDFIRST THEN begin

    //         recRef.Get(IRNLdgEnt.RecordId);
    //         QRGenerator.GenerateQRCodeImage(SignQR, TempBlob);
    //         FieldRef := recRef.Field(IRNLdgEnt.FieldNo(SignbedQRCode));
    //         TempBlob.ToRecordRef(RecRef, IRNLdgEnt.FieldNo(SignbedQRCode));
    //         recRef.Modify();
    //         IRNLdgEnt."Document Type" := 0;
    //         IRNLdgEnt.MODIFY;

    //     end;
    //     // Erase the temporary file

    // end;

    procedure InitializeSignedQRCodeTSH(var TransferShipHdr: Record "Transfer Shipment Header"; SignQR: Text)
    var
        CompanyInfo: Record "Company Information";
        TempBlob: Codeunit "Temp Blob";
        QRCodeInput: Text[1024];
        QRCodeFileName: Text[1024];
        //IRNLdgEnt: Record 50020;
        JSONManagement: Codeunit "JSON Management";
        QRGenerator: Codeunit "QR Generator";
        recRef: RecordRef;
        FieldRef: FieldRef;
    begin


        recRef.Get(TransferShipHdr.RecordId);
        QRGenerator.GenerateQRCodeImage(SignQR, TempBlob);
        FieldRef := recRef.Field(TransferShipHdr.FieldNo("QR Code"));
        TempBlob.ToRecordRef(RecRef, TransferShipHdr.FieldNo("QR Code"));
        recRef.Modify();


    end;
    // Erase the temporary file




    // procedure InitializeSignedQRCodeCreditMemo(SalInvHdr: Record 114; SignQR: Text)
    // var
    //     CompanyInfo: Record "Company Information";
    //     TempBlob: Codeunit "Temp Blob";
    //     QRCodeInput: Text[1024];
    //     QRCodeFileName: Text[1024];
    //     IRNLdgEnt: Record 50020;
    //     JSONManagement: Codeunit "JSON Management";
    //     QRGenerator: Codeunit "QR Generator";
    //     recRef: RecordRef;
    //     FieldRef: FieldRef;
    // begin


        // IRNLdgEnt.SETRANGE("Document No.", SalInvHdr."No.");
        // IRNLdgEnt.SETRANGE("Document Type", 1);
        // //IRNLdgEnt.SETRANGE("Invoice Type",SalInvHdr."Invoice Type");
        // IF IRNLdgEnt.FINDFIRST THEN begin

        //     recRef.Get(IRNLdgEnt.RecordId);
        //     QRGenerator.GenerateQRCodeImage(SignQR, TempBlob);
        //     FieldRef := recRef.Field(IRNLdgEnt.FieldNo(SignbedQRCode));
        //     TempBlob.ToRecordRef(RecRef, IRNLdgEnt.FieldNo(SignbedQRCode));
        //     recRef.Modify();
        //     IRNLdgEnt."Document Type" := 1;
        //     IRNLdgEnt.MODIFY;
        //     //SalInvHdr."QR Code" := TempBlob.Blob; // For Credit Memo
        // end;



   // end;
}

