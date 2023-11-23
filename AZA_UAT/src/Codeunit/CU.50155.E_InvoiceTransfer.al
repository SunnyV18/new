
codeunit 50155 "Json Creation E-invoice"
{
    // Rohit 18-12-2020
    // 1.Worked on mapping fileds for creating Json file as per the standard format.
    trigger OnRun()
    begin
    end;

    var
        loopcount1: Integer;
        SupLoc: Record 14;
        // SalH: Record 112;
        CcustomerValue: Decimal;
        AddreLength: Integer;
        //taxinfo:Codeunit TaxInfo;
        GSTBaseAmt: Decimal;
        TDSAmt: Decimal;
        TDSBaseAmt: Decimal;
        GIGST: Decimal;
        GSGST: Decimal;
        GCGST: Decimal;
        IGSTPer: Decimal;
        SGSTPer: Decimal;
        CGSTPer: Decimal;
    //TaxInfo: Codeunit TaxInfo;

    local procedure Initialize()
    var
        myInt: Integer;
    begin
        Clear(GSTBaseAmt);
        Clear(TDSAmt);
        Clear(TDSBaseAmt);
        Clear(GIGST);
        Clear(GSGST);
        Clear(GCGST);
        Clear(IGSTPer);
        Clear(SGSTPer);
        Clear(CGSTPer);
    end;

    procedure CreateeInvoiceJSON(eInvoiceSalHdr: Record "Transfer Shipment Header"): BigText
    var
        location: Record Location;//Naveen
        location1: Record Location;
        RecRef: RecordRef;
        FrmGSTLoc: Record 14;
        //  ToGSTCust: Record 18;//Naveen
        SalInvLine: Record 5745;
        json_line: Text;
        cgst: Decimal;
        sgst: Decimal;
        json_string: Text;
        json_header: Text;
        SplyTyp: Text;
        InvTyp: Text;
        ToState: Record State;
        FrmState: Record State;
        loopcount: Integer;
        totalgst: Decimal;
        totaltaxVal: Decimal;
        MyFile: File;
        OutStr: OutStream;
        actFromStateCode: Code[10];
        acttostate: Code[10];
        cessval: Decimal;
        frompincode: Code[10];
        frmstatecode: Code[10];
        topincode: Code[10];
        toStateCode: Code[10];
        subSupplyType: Text;
        subSupplyDesc: Text;
        igst: Decimal;
        Cmpny: Record 79;
        cgstval: Decimal;
        sgstval: Decimal;
        igstval: Decimal;
        transMode: Text;
        dispatchFromGSTIN: Text;
        dispatchFromTradeName: Text;
        shipToGSTIN: Text;
        GSTUQC: Text;
        //GSTUOM: Record 204;//Naveen
        cgstRate: Decimal;
        sgstRate: Decimal;
        igstRate: Decimal;
        SInvNo: Text;
        Version: Text;
        TaxSch: Text;
        SupTyp: Text;
        RevChgDtlGSTLdgEnt: Record "Detailed GST Ledger Entry";
        RevChgSalInvLn: Record 5745;
        RegRev: Text;
        //eCommCust: Record 18;//Naveen
        EcmGstin: Text;
        Sec7GstLdgEnt: Record "GST Ledger Entry";
        IgstOnIntra: Text;
        Typ: Text;
        SlrGstin: Text;
        SlrLglNm: Text;
        SlrTrdNm: Text;
        SlrAddr1: Text;
        SlrAddr2: Text;
        SlrLoc: Text;
        SlrPin: Text;
        SlrStcd: Text;
        SlrPh: Text;
        SlrEm: Text;
        // CustGen: Record 18;//Naveen
        ByrGstin: Text;
        ByrLglNm: Text;
        ByrTrdNm: Text;
        POSStcd: Text;
        recLoc: Record Location;
        POS: Code[10];
        StateBuff: Record State;
        recState: Record State;
        Stcd: Code[2];
        placeosup: text;
        ByrAddr1: Text;
        ByrAddr2: Text;
        ByrLoc: Text;
        ByrPin: Text;
        ByrStcd: Text;
        ByrPh: Text;
        ByrEm: Text;
        DspNm: Text;
        DspAddr1: Text;
        DspAddr2: Text;
        DspLoc: Text;
        DspPin: Text;
        DspStcd: Text;
        ShpGstin: Text;
        ShpLglNm: Text;
        ShpTrdNm: Text;
        ShpAddr1: Text;
        ShpAddr2: Text;
        ShpLoc: Text;
        ShpPin: Text;
        ShpStcd: Text;
        SlNo: Text;
        IsServc: Text;
        ItmGen: Record 27;
        Qty: Text;
        FreeQty: Text;
        Barcde: Text;
        Unit: Text;
        PrdDesc: Text;
        HsnCd: Text;
        UnitPrice: Text;
        TotAmt: Text;
        Discount: Text;
        PreTaxVal: Text;
        AssAmt: Text;
        GstRt: Integer;
        IgstAmt: Text;
        CgstAmt: Text;
        SgstAmt: Text;
        GenDGLE: Record "Detailed GST Ledger Entry";
        CesRt: Text;
        CesAmt: Text;
        CesNonAdvlAmt: Text;
        StateCesRt: Text;
        StateCesAmt: Text;
        StateCesNonAdvlAmt: Text;
        OthChrg: Text;
        TotItemVal: Text;
        OrdLineRef: Text;
        OrgCntry: Text;
        GenVE: Record 5802;
        GenILE: Record 32;
        PrdSlNo: Text;
        BtchNm: Text;
        ExpDt: Text;
        WrDt: Text;
        AtrbNm: Text;
        AtrbVal: Text;
        DiscountHdr: Text;
        AssAmtHdr: Text;
        IgstAmtHdr: Text;
        CgstAmtHdr: Text;
        SgstAmtHdr: Text;
        CesAmtHdr: Text;
        StateCesAmtHdr: Text;
        OthChrgHdr: Text;
        RndOffAmt: Text;
        TotInvVal: Text;
        TotInvValFc: Text;
        DiscountHdrVal: Decimal;
        AssAmtHdrVal: Decimal;
        IgstAmtHdrVal: Decimal;
        CgstAmtHdrVal: Decimal;
        SgstAmtHdrVal: Decimal;
        CesAmtHdrVal: Decimal;
        TotInvValHdr: Decimal;
        PayNm: Text;
        AccDet: Text;
        Mode: Text;
        FinInsBr: Text;
        PayTerm: Text;
        PayInstr: Text;
        CrTrn: Text;
        DirDr: Text;
        PaymtDue: Text;
        // PayTrm: Record 3;//Naveen
        CrDay: Text;
        PaidAmt: Text;
        //GenCLE: Record 21;//Naveen
        InvRm: Text;
        InvStDt: Text;
        InvEndDt: Text;
        PrecInvNo: Text;
        PrecInvDt: Text;
        OthRefNo: Text;
        RecAdvRefr: Text;
        RecAdvDt: Text;
        TendRefr: Text;
        ContrRefr: Text;
        ExtRefr: Text;
        ProjRefr: Text;
        PORefr: Text;
        PORefDt: Text;
        DocUrl: Text;
        Docs: Text;
        Info: Text;
        ShipBNo: Text;
        ShipBDt: Text;
        ExpDuty: Text;
        Port: Text;
        RefClm: Text;
        ForCur: Text;
        CntCode: Text;
        TransId: Text;
        TransName: Text;
        Distance: Text;
        TransDocNo: Text;
        TransDocDt: Text;
        VehNo: Text;
        VehType: Text;
        EinvJson: Bigtext;
        // ShiptoAdd: Record 222;//Naveen
        ShpAddr2Text: Text;
        DspAddr2Text: Text;
        ByrAddr2Text: Text;
        SlrAddr2Text: Text;
        SlrEmText: Text;
        ByrEmText: Text;
        BarcdeText: Text;
        BtchNmText: Text;
        ModeText: Text;
        SupLoc: Record 14;
        EcmGstinText: Text;
        ByrPhText: Text;
        DspLocText: Text;
        ShpLocText: Text;
        SlrLocText: Text;
        PrdSlNoText: Text;
        OrgCntryText: Text;
        TotInvValFcText: Text;
        RndOffAmtText: Text;
        PrecInvNoText: Text;
        PrecInvDtText: Text;
        OthRefNoText: Text;
        RecCustomer: Record 18;//Naveen
        RecShipToAddr: Record 222;//Naveen
    begin


        json_string := '';
        json_header := '';
        json_line := '';
        clear(EinvJson);
        //----------------------------------------------------------JSON Start-----------------------------------------------
        Version := '1.1'; //Schema Version
                          //Taxpayer Schema
                          //TaxSch := eInvoiceSalHdr.Structure;
                          // Taxpayer Schema Done
                          //Supply Type
        SupTyp := 'B2B';
        //Supply Type Schema Done
        //Regular or Reverse Charge
        RevChgSalInvLn.RESET;
        RevChgSalInvLn.SETRANGE("Document No.", eInvoiceSalHdr."No.");
        RevChgSalInvLn.SETFILTER(Quantity, '<>%1', 0);
        IF RevChgSalInvLn.FINDFIRST THEN BEGIN
            RevChgDtlGSTLdgEnt.RESET;
            RevChgDtlGSTLdgEnt.SETRANGE("Document No.", RevChgSalInvLn."Document No.");
            RevChgDtlGSTLdgEnt.SETRANGE("Document Line No.", RevChgSalInvLn."Line No.");
            IF RevChgDtlGSTLdgEnt."Reverse Charge" = TRUE THEN
                RegRev := 'Y'
            ELSE
                RegRev := 'Y';
        END;
        //Regular or Reverse Charge Done
        EcmGstin := '';
        /*
        //e-Commerce
        EcmGstin := '';
        IF eInvoiceSalHdr."e-Commerce Customer" <> '' THEN BEGIN
          eCommCust.RESET;
          eCommCust.SETRANGE("No.",eInvoiceSalHdr."e-Commerce Customer");
          IF eCommCust.FINDFIRST THEN
            EcmGstin := eCommCust."GST Registration No.";
        END;
        IF EcmGstin <> ''THEN
          EcmGstinText:='"EcmGstin":'+'"'+EcmGstin+'"'+','
        ELSE
          EcmGstinText:='';
        //e-Commerce Done
        */
        //Flag for Supply covered under sec 7 of IGST Act
        RevChgSalInvLn.RESET;
        RevChgSalInvLn.SETRANGE("Document No.", eInvoiceSalHdr."No.");
        RevChgSalInvLn.SETFILTER(Quantity, '<>%1', 0);
        IF RevChgSalInvLn.FINDFIRST THEN BEGIN
            IgstOnIntra := 'N';
            Sec7GstLdgEnt.RESET;
            Sec7GstLdgEnt.SETRANGE("Document No.", RevChgSalInvLn."Document No.");
            Sec7GstLdgEnt.SETFILTER("GST Component Code", '%1', 'IGST');
            IF Sec7GstLdgEnt.FINDFIRST THEN BEGIN
                // IF eInvoiceSalHdr."Transfer-from Code" = '' THEN BEGIN //CCIT-Naveen
                //     IF eInvoiceSalHdr.sta = eInvoiceSalHdr."GST Bill-to State Code" THEN BEGIN
                //         IgstOnIntra := 'Y';
                //         RegRev := 'Y'; // prdp 03092021
                //     END
                //     ELSE
                //         IF eInvoiceSalHdr."Location State Code" <> eInvoiceSalHdr."GST Bill-to State Code" THEN IgstOnIntra := 'N'
                // END;
                //CCIT-29032022
            END
            ELSE
                IF eInvoiceSalHdr."Transfer-from Code" <> '' THEN BEGIN//Naveen
                    IgstOnIntra := 'N';
                END;
            //CCIT-29032022
        END;
        //Done Flag for Supply covered under sec 7 of IGST Act
        //--------------------------------------------------------------Start Document Details-------------------------------------------------
        //Typ := 'CN';
        Cmpny.GET;
        IF Cmpny.FINDFIRST THEN;
        RecRef.GETTABLE(eInvoiceSalHdr);
        IF RecRef.NUMBER = 5744 THEN BEGIN
            // IF eInvoiceSalHdr."Invoice Type" = 4 THEN
            //     Typ := 'DBN'
            // // ELSE IF ((eInvoiceSalHdr."Invoice Type" = 6) OR (eInvoiceSalHdr."Invoice Type" = 2)) THEN // prdp commented 270321
            // ELSE
            Typ := 'INV';
            //SplyTyp := 'O';
        END;
        //Document No is Invoice No.
        //Document Date is Posting No.
        //-------------------------------------------------------------------Start Seller Details----------------------------------------------------------
        //Seller GSTIN
        SupLoc.RESET;
        SupLoc.SETRANGE(Code, eInvoiceSalHdr."Transfer-from Code");
        IF SupLoc.FINDFIRST THEN BEGIN
            SlrGstin := SupLoc."GST Registration No.";
            //SlrGstin := '01AMBPG7773M002'; //Test001
        END;
        //Seller GSTIN
        Cmpny.GET;
        IF Cmpny.FINDFIRST THEN;
        //Seller Legal Name
        SlrLglNm := Cmpny.Name;
        //Done Seller Legal Name
        //----Optional NA-------------
        //Seller Trade Name
        SlrTrdNm := SupLoc.Name;
        //Done Seller Trade Name
        //----Optional NA-------------
        //Seller Address1
        IF STRLEN(CONVERTSTR(SupLoc.Address, '"', '-')) > 100 THEN BEGIN
            SlrAddr1 := COPYSTR(CONVERTSTR(SupLoc.Address, '"', '-'), 1, 100);
        END
        ELSE BEGIN
            SlrAddr1 := CONVERTSTR(SupLoc.Address, '"', '-');
        END;
        //Done Seller Address1
        //Seller Address 2
        IF STRLEN(CONVERTSTR(SupLoc."Address 2", '"', '-')) > 100 THEN BEGIN
            SlrAddr2 := COPYSTR(CONVERTSTR(SupLoc."Address 2", '"', '-'), 1, 100);
        END
        ELSE BEGIN
            SlrAddr2 := CONVERTSTR(SupLoc."Address 2", '"', '-');
        END;
        IF SlrAddr2 <> '' THEN // SlrAddr2Text:= '+''"Addr2":'+'"'+SlrAddr2+'"'+','
            SlrAddr2Text := '"Addr2":' + '"' + SlrAddr2 + '"' + ','
        ELSE
            SlrAddr2Text := '';
        //Done Seller Address 2
        //Seller Location
        SlrLoc := SupLoc.Code; // prdp 24032021 branch to code
        IF SlrLoc <> '' THEN
            SlrLocText := '"Loc":' + '"' + SlrLoc + '"' + ','
        ELSE
            SlrLocText := '';
        //Done Seller Location
        //Seller Pincode
        SlrPin := SupLoc."Post Code";
        //SlrPin := '193502';//Test 001
        //Done Seller Pincode
        IF SlrPin = '' THEN BEGIN
            SlrPin := '400059'; // prdp 050421
        END;
        //Seller State Code
        FrmState.SETRANGE(Code, SupLoc."State Code");
        IF FrmState.FINDFIRST THEN BEGIN
            IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
                SlrStcd := '0';
            END
            ELSE
                IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
                    SlrStcd := FrmState."State Code (GST Reg. No.)";
                END
        END;
        //Done Seller State Code
        //----Optional NA-------------
        //Seller Phone Number
        SlrPh := SupLoc."Phone No.";
        IF SlrPh = '' THEN BEGIN
            SlrPh := '9123456780';
        END;
        //Done Phone Number
        //----Optional NA-------------
        //----Optional NA-------------
        //Seller e-Mail ID
        SlrEm := SupLoc."E-Mail";
        IF SlrEm <> '' THEN
            SlrEmText := ',' + '"Em":' + '"' + SlrEm + '"'
        ELSE
            SlrEmText := '';


        //Nkp---
        location1.Get(eInvoiceSalHdr."Transfer-to Code");
        FrmState.RESET;
        FrmState.SETRANGE(Code, location1."State Code");
        IF FrmState.FINDFIRST THEN BEGIN
            IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
                ByrStcd := '0';
            END
            ELSE
                IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
                    ByrStcd := FrmState."State Code (GST Reg. No.)";
                END
        END;
        //Nkp--
        //Nkp+++
        IF StateBuff.GET(location1."State Code") THEN BEGIN
            Stcd := StateBuff."State Code (GST Reg. No.)";
            POS := StateBuff."State Code (GST Reg. No.)";
            //Message(POS);
        END ELSE BEGIN
            Stcd := '';
            POS := ''
        END;


        //Done e-mail ID
        //----Optional NA-------------
        //--------------------------------------------------------------------Buyer Details---------------------------------------
        /*
        //Buyer GSTIN
        IF eInvoiceSalHdr."Invoice Type" = 3 THEN
        ByrGstin := 'URP'
        ELSE IF eInvoiceSalHdr."Invoice Type" <> 3 THEN
        //ByrGstin := eInvoiceSalHdr."Customer GST Reg. No."; // Rohit
        ByrGstin :='27AACCA8432H1ZQ';
        //Done
        */
        IF eInvoiceSalHdr."Transfer-from Post Code" = '' THEN BEGIN //CCIT-22032022
                                                                    //Buyer GSTIN New code
                                                                    //Nkp++
            location.Reset();
            location.SetRange(Code, eInvoiceSalHdr."Transfer-to Code");
            IF location.FINDFIRST THEN BEGIN
                ByrGstin := location."GST Registration No.";
                ByrLglNm := location.Name;
                ByrTrdNm := location.Name;
                // ByrGstin:='01AMBPG7773M002';
            END;
            //Buyer GSTIN New code

            //----Optional NA-------------
            /*
            //Place of Supply
            IF ((eInvoiceSalHdr."Invoice Type" = 3) AND (eInvoiceSalHdr."GST Ship-to State Code" = '')) THEN BEGIN
              POSStcd := '96'
            END ELSE IF (eInvoiceSalHdr."Invoice Type" <> 2) THEN BEGIN
              IF eInvoiceSalHdr."GST Ship-to State Code" <> '' THEN BEGIN
                FrmState.SETRANGE(Code,eInvoiceSalHdr."GST Ship-to State Code");
                IF FrmState.FINDFIRST THEN BEGIN
                  IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
                    POSStcd := '0';
                  END ELSE IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
                    POSStcd := FrmState."State Code (GST Reg. No.)";
                  END;
                END;
              END ELSE IF eInvoiceSalHdr."GST Ship-to State Code" = '' THEN BEGIN
                FrmState.SETRANGE(Code,eInvoiceSalHdr."GST Bill-to State Code");
                IF FrmState.FINDFIRST THEN BEGIN
                  IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
                    POSStcd := '0';
                  END ELSE IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
                    POSStcd := FrmState."State Code (GST Reg. No.)";
                  END;
                END;
              END;
            END;
            //Done Place of Supply
            */
            //Place of Supply New code

            location1.Reset();
            location1.SetRange(Code, eInvoiceSalHdr."Transfer-from Code");
            IF location1.FINDFIRST THEN BEGIN

            end;


            FrmState.RESET;
            FrmState.SETRANGE(Code, location1."State Code");
            IF FrmState.FINDFIRST THEN BEGIN
                IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
                    POSStcd := '0';
                END
                ELSE
                    IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
                        POSStcd := FrmState."State Code (GST Reg. No.)";
                    END
            END;

            //Place of Supply New code
            //Buyer Address1
            IF STRLEN(CONVERTSTR(location.Address, '"', '-')) > 100 THEN BEGIN
                ByrAddr1 := COPYSTR(CONVERTSTR(location.Address, '"', '-'), 1, 100);
            END
            ELSE BEGIN
                ByrAddr1 := CONVERTSTR(location.Address, '"', '-');
            END;
            AddreLength := STRLEN(ByrAddr1);
            //MESSAGE('Buyer Address ='+ByrAddr1);
            //MESSAGE('Address Length = %1',AddreLength);
            //Done Buyer Address1
            //Buyer Address 2
            IF STRLEN(CONVERTSTR(location."Address 2", '"', '-')) > 100 THEN BEGIN
                ByrAddr2 := COPYSTR(CONVERTSTR(location."Address 2", '"', '-'), 1, 100);
            END
            ELSE BEGIN
                ByrAddr2 := CONVERTSTR(location."Address 2", '"', '-');
            END;
            IF ByrAddr2 <> '' THEN //ByrAddr2Text:='+''"Addr2":'+'"'+ByrAddr2+'"'+','
                ByrAddr2Text := '"Addr2":' + '"' + ByrAddr2 + '"' + ','
            ELSE
                ByrAddr2Text := '';
            //Done Buyer Address 2
            //Buyer Location
            //eInvoiceSalHdr.TESTFIELD("Sell-to City");
            ByrLoc := location.City;
            IF ByrLoc = '' THEN BEGIN
                ByrLoc := 'Mumbai';
            END;
            /* // prdp commented 250321
            IF ByrLoc = '' THEN
              ERROR('Customer has to have a valid city!')
            ELSE IF ByrLoc <> '' THEN
              ByrLoc := eInvoiceSalHdr."Sell-to City";
              */
            // prdp commented 250321
            //Done Buyer Location
            //Rohit Buyer Location
            /*
            //Buyer Location New code
            FrmState.RESET;
            FrmState.SETRANGE(Code,RecCustomer."State Code");
            IF FrmState.FINDFIRST THEN BEGIN
              IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
                ByrLoc := '0';
              END ELSE IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
                ByrLoc := FrmState."State Code (GST Reg. No.)";
              END
            END;
            //Buyer Location new code
            */
            //Buyer Pincode
            // IF eInvoiceSalHdr."Invoice Type" = 3 THEN BEGIN
            //     ByrPin := '999999';
            // END
            //ELSE
            // IF ((eInvoiceSalHdr."Invoice Type" <> 3) AND (eInvoiceSalHdr."Sell-to Post Code" <> '')) THEN
            ByrPin := location."Post Code";
            // ELSE
            //     IF ((eInvoiceSalHdr."Invoice Type" <> 3) AND (eInvoiceSalHdr."Sell-to Post Code" = '')) THEN //ERROR('Customer has to have a valid post code!');
            //         //Done Buyer Pincode
            //         IF ByrPin = '' THEN BEGIN
            //             ByrPin := '400059'; // prdp 050421
            //         END;
            /*
            //Buyer State Code
            IF eInvoiceSalHdr."Invoice Type" = 3 THEN BEGIN
              ByrStcd := '96';
            END ELSE IF eInvoiceSalHdr."Invoice Type" <> 3 THEN BEGIN
            FrmState.SETRANGE(Code,eInvoiceSalHdr.State);
              IF FrmState.FINDFIRST THEN BEGIN
                IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
                  ERROR('Customer has to have a valid State code!')
                END ELSE IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
                  ByrStcd := FrmState."State Code (GST Reg. No.)";
                END;
              END;
            END;
            //Done Buyer State Code
            */
            //Buyer State Code new code
            //Nkp++
            // FrmState.RESET;
            // FrmState.SETRANGE(Code, location1."State Code");
            // IF FrmState.FINDFIRST THEN BEGIN
            //     IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
            //         ByrStcd := '0';
            //     END
            //     ELSE
            //         IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
            //             ByrStcd := FrmState."State Code (GST Reg. No.)";
            //         END
            // END;
            //Nkp--
            //Buyer State Code new code
            //----Optional NA-------------
            //Buyer Phone Number
            // CustGen.RESET;  
            // CustGen.SETRANGE("No.", eInvoiceSalHdr."Sell-to Customer No.");
            // IF CustGen.FINDFIRST THEN ByrPh := CustGen."Phone No.";
            // IF ByrPh = '' THEN BEGIN
            //     ByrPh := '9123456780';
            // END;
            ByrPh := location."Phone No.";// '9123456780'
            IF ByrPh <> '' THEN
                ByrPhText := ',' + '"Ph":' + '"' + ByrPh + '"'
            ELSE
                ByrPhText := '';
            // ByrPh := '9123456780';
            //Done Phone Number
            //----Optional NA-------------
            //----Optional NA-------------
            //Buyer e-Mail ID
            // CustGen.RESET;
            // CustGen.SETRANGE("No.", eInvoiceSalHdr."Sell-to Customer No.");
            // IF CustGen.FINDFIRST THEN BEGIN
            //     ByrEm := CustGen."E-Mail";
            //     IF ByrEm <> '' THEN
            //         ByrEmText := ',' + '"Em":' + '"' + ByrEm + '"'
            //     ELSE
            //         ByrEmText := '';
            // END;
            //Done e-mail ID
            //----Optional NA-------------
            //CCIT-22032022
        END
        ELSE
            // IF eInvoiceSalHdr."Ship-to Code" <> '' THEN BEGIN
            //     //Buyer GSTIN New code
            //     RecShipToAddr.RESET;
            //     RecShipToAddr.SETRANGE(RecShipToAddr.Code, eInvoiceSalHdr."Ship-to Code");
            //     RecShipToAddr.SETRANGE(RecShipToAddr."Customer No.", eInvoiceSalHdr."Sell-to Customer No.");
            //     IF RecShipToAddr.FINDFIRST THEN BEGIN
            //         ByrGstin := RecShipToAddr."GST Registration No.";
            //         // ByrGstin:='01AMBPG7773M002';
            //     END;
            //Buyer GSTIN New code
            //Buyer Legal Name new code
            //     RecShipToAddr.RESET;
            //     RecShipToAddr.SETRANGE(RecShipToAddr.Code, eInvoiceSalHdr."Ship-to Code");
            //     RecShipToAddr.SETRANGE(RecShipToAddr."Customer No.", eInvoiceSalHdr."Sell-to Customer No.");
            //     IF RecShipToAddr.FINDFIRST THEN BEGIN
            //         ByrLglNm := RecShipToAddr.Name;
            //     END;
            //     //Buyer Legal Name new code
            //     //----Optional NA-------------
            //     //Buyer Trade Name
            //     //ByrTrdNm := eInvoiceSalHdr."Sell-to Customer Name 2";
            //     ByrTrdNm := eInvoiceSalHdr."Ship-to Name";
            //     //Done Buyer Trade Name
            //     //----Optional NA-------------
            //     //Place of Supply New code
            //     RecShipToAddr.RESET;
            //     RecShipToAddr.SETRANGE(RecShipToAddr.Code, eInvoiceSalHdr."Ship-to Code");
            //     RecShipToAddr.SETRANGE(RecShipToAddr."Customer No.", eInvoiceSalHdr."Sell-to Customer No.");
            //     IF RecShipToAddr.FINDFIRST THEN BEGIN
            //         FrmState.RESET;
            //         FrmState.SETRANGE(Code, RecShipToAddr.State);
            //         IF FrmState.FINDFIRST THEN BEGIN
            //             IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
            //                 POSStcd := '0';
            //             END
            //             ELSE
            //                 IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
            //                     POSStcd := FrmState."State Code (GST Reg. No.)";
            //                 END
            //         END;
            //     END;
            //     //Place of Supply New code
            //     //Buyer Address1
            //     IF STRLEN(CONVERTSTR(eInvoiceSalHdr."Ship-to Address", '"', '-')) > 100 THEN BEGIN
            //         ByrAddr1 := COPYSTR(CONVERTSTR(eInvoiceSalHdr."Ship-to Address", '"', '-'), 1, 100);
            //     END
            //     ELSE BEGIN
            //         ByrAddr1 := CONVERTSTR(eInvoiceSalHdr."Ship-to Address", '"', '-');
            //     END;
            //     AddreLength := STRLEN(ByrAddr1);
            //     //MESSAGE('Buyer Address ='+ByrAddr1);
            //     //MESSAGE('Address Length = %1',AddreLength);
            //     //Done Buyer Address1
            //     //Buyer Address 2
            //     IF STRLEN(CONVERTSTR(eInvoiceSalHdr."Ship-to Address 2", '"', '-')) > 100 THEN BEGIN
            //         ByrAddr2 := COPYSTR(CONVERTSTR(eInvoiceSalHdr."Ship-to Address 2", '"', '-'), 1, 100);
            //     END
            //     ELSE BEGIN
            //         ByrAddr2 := CONVERTSTR(eInvoiceSalHdr."Ship-to Address 2", '"', '-');
            //     END;
            //     IF ByrAddr2 <> '' THEN //ByrAddr2Text:='+''"Addr2":'+'"'+ByrAddr2+'"'+','
            //         ByrAddr2Text := '"Addr2":' + '"' + ByrAddr2 + '"' + ','
            //     ELSE
            //         ByrAddr2Text := '';
            //     //Done Buyer Address 2
            //     //Buyer Location
            //     //eInvoiceSalHdr.TESTFIELD("Sell-to City");
            //     ByrLoc := eInvoiceSalHdr."Ship-to City";
            //     IF ByrLoc = '' THEN BEGIN
            //         ByrLoc := 'Mumbai';
            //     END;
            //     //Buyer Pincode
            //     IF eInvoiceSalHdr."Invoice Type" = 3 THEN BEGIN
            //         ByrPin := '999999';
            //     END
            //     ELSE
            //         IF ((eInvoiceSalHdr."Invoice Type" <> 3) AND (eInvoiceSalHdr."Ship-to Post Code" <> '')) THEN
            //             ByrPin := eInvoiceSalHdr."Ship-to Post Code"
            //         ELSE
            //             IF ((eInvoiceSalHdr."Invoice Type" <> 3) AND (eInvoiceSalHdr."Ship-to Post Code" = '')) THEN //ERROR('Customer has to have a valid post code!');
            //                 //Done Buyer Pincode
            //                 IF ByrPin = '' THEN BEGIN
            //                     ByrPin := '400059'; // prdp 050421
            //                 END;
            //     //Buyer State Code new code
            //     RecShipToAddr.RESET;
            //     RecShipToAddr.SETRANGE(RecShipToAddr.Code, eInvoiceSalHdr."Ship-to Code");
            //     RecShipToAddr.SETRANGE(RecShipToAddr."Customer No.", eInvoiceSalHdr."Sell-to Customer No.");
            //     IF RecShipToAddr.FINDFIRST THEN BEGIN
            //         FrmState.RESET;
            //         FrmState.SETRANGE(Code, RecShipToAddr.State);
            //         IF FrmState.FINDFIRST THEN BEGIN
            //             IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
            //                 ByrStcd := '0';
            //             END
            //             ELSE
            //                 IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
            //                     ByrStcd := FrmState."State Code (GST Reg. No.)";
            //                 END
            //         END;
            //     END;
            //     //Buyer State Code new code
            //     //----Optional NA-------------
            //     //Buyer Phone Number
            //     RecShipToAddr.RESET;
            //     RecShipToAddr.SETRANGE(RecShipToAddr.Code, eInvoiceSalHdr."Ship-to Code");
            //     RecShipToAddr.SETRANGE(RecShipToAddr."Customer No.", eInvoiceSalHdr."Sell-to Customer No.");
            //     IF RecShipToAddr.FINDFIRST THEN IF CustGen.FINDFIRST THEN ByrPh := RecShipToAddr."Phone No.";
            //     IF ByrPh = '' THEN BEGIN
            //         ByrPh := '9123456780';
            //     END;
            //     IF ByrPh <> '' THEN
            //         ByrPhText := ',' + '"Ph":' + '"' + ByrPh + '"'
            //     ELSE
            //         ByrPhText := '';
            //     // ByrPh := '9123456780';
            //     //Done Phone Number
            //     //----Optional NA-------------
            //     //----Optional NA-------------
            //     //Buyer e-Mail ID
            //     RecShipToAddr.RESET;
            //     RecShipToAddr.SETRANGE(RecShipToAddr.Code, eInvoiceSalHdr."Ship-to Code");
            //     RecShipToAddr.SETRANGE(RecShipToAddr."Customer No.", eInvoiceSalHdr."Sell-to Customer No.");
            //     IF RecShipToAddr.FINDFIRST THEN BEGIN
            //         ByrEm := RecShipToAddr."E-Mail";
            //         IF ByrEm <> '' THEN
            //             ByrEmText := ',' + '"Em":' + '"' + ByrEm + '"'
            //         ELSE
            //             ByrEmText := '';
            //     END;
            //     //Done e-mail ID
            //     //----Optional NA-------------
            // END;
            //CCIT-22032022
            //-----------------------------------------------------------------Despatcher Details Start--------------------------------------------
            // Despatcher Name
            Cmpny.GET;
        IF Cmpny.FINDFIRST THEN;
        DspNm := Cmpny.Name;
        // Despatcher Name
        //Fetch Despatcher Details
        FrmGSTLoc.SETRANGE(Code, eInvoiceSalHdr."Transfer-from Code");
        IF FrmGSTLoc.FINDFIRST THEN BEGIN
            IF STRLEN(CONVERTSTR(FrmGSTLoc.Address, '"', '-')) > 100 THEN BEGIN
                DspAddr1 := COPYSTR(CONVERTSTR(FrmGSTLoc.Address, '"', '-'), 1, 100);
            END
            ELSE BEGIN
                DspAddr1 := CONVERTSTR(FrmGSTLoc.Address, '"', '-');
            END;
            IF STRLEN(CONVERTSTR(FrmGSTLoc."Address 2", '"', '-')) > 100 THEN BEGIN
                DspAddr2 := COPYSTR(CONVERTSTR(FrmGSTLoc."Address 2", '"', '-'), 1, 100);
            END
            ELSE BEGIN
                DspAddr2 := CONVERTSTR(FrmGSTLoc."Address 2", '"', '-');
            END;
            IF DspAddr2 <> '' THEN //DspAddr2Text:='+''"Addr2":'+'"'+DspAddr2+'"'+','
                DspAddr2Text := '"Addr2":' + '"' + DspAddr2 + '"' + ','
            ELSE
                DspAddr2Text := '';
            //Location
            DspLoc := FrmGSTLoc.Code; // prdp 24032021 branch to code
            IF DspLoc <> '' THEN
                DspLocText := '"Loc":' + '"' + DspLoc + '"' + ','
            ELSE
                DspLocText := '';
            //Location
            //Pin code
            DspPin := FrmGSTLoc."Post Code";
            //Pin code
            //Post Code
            IF ((FrmGSTLoc."Post Code" <> '')) THEN
                DspPin := FrmGSTLoc."Post Code"
            ELSE
                IF ((FrmGSTLoc."Post Code" = '')) THEN DspPin := '100000';
            //Post Code
            //Despatcher State Code
            FrmState.SETRANGE(Code, FrmGSTLoc."State Code");
            IF FrmState.FINDFIRST THEN BEGIN
                IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
                    DspStcd := '0';
                END
                ELSE
                    IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
                        DspStcd := FrmState."State Code (GST Reg. No.)";
                    END;

            END;
        END;
        //Done Despatcher State Code
        //--------------------------------------------------------------------Start Shipper Details---------------------------------------
        /*
        //Shipping GSTIN

        IF eInvoiceSalHdr."GST Ship-to State Code" <> '' THEN BEGIN
          ShiptoAdd.RESET;
          ShiptoAdd.SETRANGE(Code,eInvoiceSalHdr."Ship-to Code");
          IF ShiptoAdd.FINDFIRST THEN BEGIN
            ShpGstin := ShiptoAdd."GST Registration No."
          END
        END ELSE IF eInvoiceSalHdr."GST Ship-to State Code" = '' THEN BEGIN
          //ShpGstin := eInvoiceSalHdr."Customer GST Reg. No."; //Rohit
        END;
        //Done
        */
        //CCIT-22032022
        /*
        //Shipping GSTIN New code
        RecCustomer.RESET;
        RecCustomer.SETRANGE(RecCustomer."No.",eInvoiceSalHdr."Sell-to Customer No.");
        IF RecCustomer.FINDFIRST THEN BEGIN
          ByrGstin := RecCustomer."GST Registration No.";
         // ByrGstin := '01AMBPG7773M002';
        END;
        //Shipping GSTIN new code

        {
        //Shipping Legal Name
        ShpLglNm:= eInvoiceSalHdr."Ship-to Name";
        //Done Shipping Legal Name
        }

        //Shipping Legal Name new code
        RecCustomer.RESET;
        RecCustomer.SETRANGE(RecCustomer."No.",eInvoiceSalHdr."Sell-to Customer No.");
        IF RecCustomer.FINDFIRST THEN BEGIN
          ByrLglNm := RecCustomer.Name;
        END;
        //Shipping Legal Name new code

        //Shipping Trade Name
        //ShpTrdNm := eInvoiceSalHdr."Ship-to Name 2";
        ShpTrdNm := eInvoiceSalHdr."Ship-to Name";
        //Done Shipping Trade Name

        //Shipping Address1
        IF STRLEN(CONVERTSTR(eInvoiceSalHdr."Ship-to Address",'"','-')) > 100 THEN BEGIN
        ShpAddr1 := COPYSTR(CONVERTSTR(eInvoiceSalHdr."Ship-to Address",'"','-'),1,100);
        END ELSE BEGIN
        ShpAddr1 := CONVERTSTR(eInvoiceSalHdr."Ship-to Address",'"','-');
        END;
        //Done Shipping Address1

        //Shipping Address 2
        IF STRLEN(CONVERTSTR(eInvoiceSalHdr."Ship-to Address 2",'"','-')) > 100 THEN BEGIN
        ShpAddr2 := COPYSTR(CONVERTSTR(eInvoiceSalHdr."Ship-to Address 2",'"','-'),1,100);
        END ELSE BEGIN
        ShpAddr2 := CONVERTSTR(eInvoiceSalHdr."Ship-to Address 2",'"','-');
        END;
        IF ShpAddr2 <>'' THEN
        //ShpAddr2Text:= '+''"Addr2":'+'"'+ShpAddr2+'"'+','
        ShpAddr2Text:= '"Addr2":'+'"'+ShpAddr2+'"'+','
        ELSE
        ShpAddr2Text:= '';

        //Done Shipping Address 2

        //Shipping Location
        ShpLoc := eInvoiceSalHdr."Ship-to City";

        IF ShpLoc <> '' THEN
        ShpLocText:='"Loc":'+'"'+ShpLoc+'"'+','
        ELSE
        ShpLocText:='';
        //ShpLoc := 'Shipping City';
        //Done Shipping Location

        //Shipping Pincode
        IF eInvoiceSalHdr."Invoice Type" = 2 THEN BEGIN
          ShpPin := '999999';
        END ELSE IF eInvoiceSalHdr."Invoice Type" <> 2 THEN
          ShpPin := eInvoiceSalHdr."Ship-to Post Code";
        //Done Shipping Pincode

        //Shipping State Code
        IF eInvoiceSalHdr."Ship-to Code" <> '' THEN BEGIN
          FrmState.SETRANGE(Code,eInvoiceSalHdr."GST Ship-to State Code");
          IF FrmState.FINDFIRST THEN BEGIN
            IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
              ShpStcd := '0';
            END ELSE IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
              ShpStcd := FrmState."State Code (GST Reg. No.)";
            END;
          END
        END ELSE IF (eInvoiceSalHdr."Ship-to Code" = '') THEN BEGIN
          FrmState.SETRANGE(Code,eInvoiceSalHdr."GST Bill-to State Code");
          IF FrmState.FINDFIRST THEN BEGIN
            IF FrmState."State Code (GST Reg. No.)" = '' THEN BEGIN
              ShpStcd := '0';
            END ELSE IF FrmState."State Code (GST Reg. No.)" <> '' THEN BEGIN
              ShpStcd := FrmState."State Code (GST Reg. No.)";
            END;
          END
        END;
        //Done Shipping State Code
        */
        //CCIT-22032022
        //-------------------------------------------------------------------------Start Item List--------------------------------------------------------------------------
        //-------------------------------------------------------------------------Start Item Details-----------------------------------------------------------------------
        SalInvLine.RESET;
        //SalInvLine.SETASCENDING("Line No.");
        SalInvLine.SETFILTER("Document No.", '%1', eInvoiceSalHdr."No.");
        //SalInvLine.SETFILTER(Type,'%1',2);
        SalInvLine.SETFILTER(Quantity, '<>%1', 0);
        IF SalInvLine.FIND('-') THEN BEGIN
            //MESSAGE(FORMAT(SalInvLine.COUNT));
            loopcount := 0;
            json_line := '';
            loopcount := SalInvLine.COUNT;
            loopcount1 := 0;
            json_line := json_line + '"ItemList":' + '[';
            REPEAT
                loopcount1 := loopcount1 + 1;
                SlNo := FORMAT(loopcount1);
                //Product Description is Sales Line Description
                //SalInvLine.TESTFIELD(Description);
                PrdDesc := CONVERTSTR(SalInvLine.Description, '"', '-');
                //Done Product Description
                //Is Service
                // IF SalInvLine.Type = 1 THEN
                //     IsServc := 'Y'
                // ELSE
                //     IF SalInvLine.Type = 2 THEN BEGIN
                //         ItmGen.RESET;
                //         ItmGen.SETRANGE("No.", SalInvLine."No.");
                //         ItmGen.SETFILTER(Type, '%1', 1);
                //         IF ItmGen.FINDFIRST THEN
                //             IsServc := 'Y'
                //         ELSE
                //             IsServc := 'N'
                //     END
                //     ELSE
                //         IF ((SalInvLine.Type <> 1) OR (SalInvLine.Type <> 2)) THEN BEGIN
                //             IsServc := 'N';
                //         END;
                //Done Is Service
                // Product HSN Code is from Sales Line
                SalInvLine.TESTFIELD("HSN/SAC Code");
                HsnCd := SalInvLine."HSN/SAC Code";
                //Product HSN Code Done
                // Bar Code is optional
                Barcde := '';
                //Barcde := 'Bracode12345';
                IF Barcde <> '' THEN
                    BarcdeText := '"Barcde":' + '"' + Barcde + '"' + ','
                ELSE
                    BarcdeText := '';
                //Barcode Done
                //  Quantity and Free Quantity
                Qty := DELCHR(FORMAT(SalInvLine.Quantity), '=', ',');
                FreeQty := '0'; //Optional so hard coded to zero
                //Done Quantity and Free Quantity
                /*
                                //Unit of Measure
                                  //Unit :=  SalInvLine."Unit of Measure Code"; // commneted on 29032021
                                  IF STRLEN(SalInvLine."Unit of Measure") > 8 THEN BEGIN
                                  Unit :=  COPYSTR(SalInvLine."Unit of Measure",1,8); // added on 29032021
                                  END ELSE BEGIN
                                  Unit :=SalInvLine."Unit of Measure"; // added on 29032021
                                  END;
                                //Unit of Measure
                                */
                //Rohit
                /*
                                    //Unit
                                    GSTUOM.RESET;
                                    GSTUOM.SETRANGE(Code,SalInvLine."Unit of Measure Code");
                                    IF GSTUOM.FINDFIRST THEN
                                      IF GSTUOM."GST Reporting UQC" = '' THEN
                                        ERROR('Please specify GST Reporting UOM for the UOM for item code %1',SalInvLine."No.");

                                        Unit := GSTUOM."GST Reporting UQC";
                                    //Unit Done
                                */
                //Rohit
                Unit := 'BAG'; // prdp 290321 hardocode
                //Unit Price
                SalInvLine.TESTFIELD("Unit Price");
                UnitPrice := DELCHR(FORMAT(ROUND(SalInvLine."Unit Price", 0.01)), '=', ',');
                //Unit Price Done
                //Total Amount
                SalInvLine.TESTFIELD(Quantity);
                TotAmt := DELCHR(FORMAT(ROUND(SalInvLine.Quantity * SalInvLine."Unit Price", 0.01)), '=', ',');
                // - (SalInvLine."Line Discount Amount"+SalInvLine."Inv. Discount Amount")
                //TotAmt := DELCHR(FORMAT((ROUND(SalInvLine.Quantity*SalInvLine."Unit Price",0.01)) - (ROUND(SalInvLine."Line Discount Amount",0.01)+ROUND(SalInvLine."Inv. Discount Amount",0.01))),'=',',');
                //Total Amount Done
                //Discount
                // Discount := DELCHR(FORMAT(ROUND(SalInvLine."Line Discount Amount", 0.01) + ROUND(SalInvLine."Inv. Discount Amount", 0.01)), '=', ',');
                // IF ((SalInvLine."Line Discount Amount" + SalInvLine."Inv. Discount Amount") = 0) THEN Discount := '0';
                // DiscountHdrVal := DiscountHdrVal + ROUND((SalInvLine."Line Discount Amount" + SalInvLine."Inv. Discount Amount"), 0.01);
                //Discount Done
                //Pre tax value
                Discount := '0';
                PreTaxVal := '1';
                //Pre tax value Done
                //Taxable Amount
                AssAmt := DELCHR(FORMAT(ROUND((SalInvLine.Quantity * SalInvLine."Unit Price"), 0.01)), '=', ',');
                IF ((ROUND(SalInvLine.Quantity, 0.01) * ROUND(SalInvLine."Unit Price", 0.01)) = 0) THEN AssAmt := '0';
                AssAmtHdrVal := AssAmtHdrVal + ((ROUND(SalInvLine.Quantity * SalInvLine."Unit Price", 0.01)));
                //Taxable Amount Done
                //GST Rate
                // SalInvLine.TESTFIELD("GST %");
                //MESSAGE('GST Rate %1',GstRt);
                //GST Rate Done
                IgstAmt := '';
                //IGST Amount
                GenDGLE.RESET;
                GenDGLE.SETRANGE("Document No.", SalInvLine."Document No.");
                GenDGLE.SETRANGE("Document Line No.", SalInvLine."Line No.");
                GenDGLE.SETRANGE("GST Component Code", 'IGST');
                IF GenDGLE.FINDFIRST THEN BEGIN
                    IgstAmt := DELCHR(FORMAT(GenDGLE."GST Amount" * (-1)), '=', ',');
                    Igstval := GenDGLE."GST Amount" * (-1);
                    IF IgstAmt = '' THEN IgstAmt := '0';
                    IgstAmtHdrVal := IgstAmtHdrVal + (GenDGLE."GST Amount" * (-1));
                    CgstAmt := '0';
                    SgstAmt := '0';
                END;
                IF IgstAmt = '' THEN IgstAmt := '0';
                //IGST Amount Done
                GstRt := ROUND(GenDGLE."GST %", 1, '=');
                //CGST Amount
                CgstAmt := '';
                GenDGLE.RESET;
                GenDGLE.SETRANGE("Document No.", SalInvLine."Document No.");
                GenDGLE.SETRANGE("Document Line No.", SalInvLine."Line No.");
                GenDGLE.SETRANGE("GST Component Code", 'CGST');
                IF GenDGLE.FINDFIRST THEN BEGIN
                    CgstAmt := DELCHR(FORMAT(GenDGLE."GST Amount" * (-1)), '=', ',');
                    cgstval := GenDGLE."GST Amount" * (-1);
                    IF CgstAmt = '' THEN CgstAmt := '0';
                    GstRt := GstRt + ROUND(GenDGLE."GST %", 1, '=');
                    CgstAmtHdrVal := CgstAmtHdrVal + (GenDGLE."GST Amount" * (-1));
                    IgstAmt := '0';
                    //SgstAmt := '0';
                END;
                IF CgstAmt = '' THEN CgstAmt := '0';
                //CGST Amount Done
                //SGST Amount
                SgstAmt := '';
                GenDGLE.RESET;
                GenDGLE.SETRANGE("Document No.", SalInvLine."Document No.");
                GenDGLE.SETRANGE("Document Line No.", SalInvLine."Line No.");
                GenDGLE.SETRANGE("GST Component Code", 'SGST');
                IF GenDGLE.FINDFIRST THEN BEGIN
                    SgstAmt := DELCHR(FORMAT(GenDGLE."GST Amount" * (-1)), '=', ',');
                    sgstval := GenDGLE."GST Amount" * (-1);
                    IF SgstAmt = '' THEN SgstAmt := '0';
                    GstRt := GstRt + ROUND(GenDGLE."GST %", 1, '=');
                    SgstAmtHdrVal := SgstAmtHdrVal + (GenDGLE."GST Amount" * (-1));
                    //CgstAmt := '0';
                    IgstAmt := '0';
                END;
                IF SgstAmt = '' THEN SgstAmt := '0';
                //SGST Amount Done
                //CESS
                //CesRt := '';
                GenDGLE.RESET;
                GenDGLE.SETRANGE("Document No.", SalInvLine."Document No.");
                GenDGLE.SETRANGE("Document Line No.", SalInvLine."Line No.");
                GenDGLE.SETRANGE("GST Component Code", 'CESS');
                IF GenDGLE.FINDFIRST THEN BEGIN
                    CesRt := FORMAT(GenDGLE."GST %");
                    cessval := GenDGLE."GST Amount";
                    CesAmt := DELCHR(FORMAT(GenDGLE."GST Amount"), '=', ',');
                    CesAmtHdrVal := CesAmtHdrVal + GenDGLE."GST Amount";
                END;
                IF CesRt = '' THEN CesRt := '0';
                IF CesAmt = '' THEN CesAmt := '0';
                //CESS Done
                //Cess Non-Advol Amount
                CesNonAdvlAmt := '0';
                //Cess Non-Advol Amount Done
                //State Cess and Other Charge
                StateCesAmt := '0';
                StateCesNonAdvlAmt := '0';
                StateCesRt := '0';
                //OthChrg := '0';
                // Other charge new code
                Initialize();
                // TaxInfo.GetTaxInfo(SalInvLine.RecordId, GSTBaseAmt, TDSBaseAmt, TDSAmt, GIGST, GSGST, GCGST, IGSTPer, SGSTPer, CGSTPer);
                //taxinfo.GetTaxInfo(SalInvLine.RecordId,);
                OthChrg := DELCHR(FORMAT(TDSAmt), '=', ','); // Added code to delete comma
                // Other charge new code
                //State Cess and Other Charge Done
                //Total Item Value
                //TotItemVal := DELCHR(FORMAT(SalInvLine."Amount To Customer"),'=',','); // Rohit Changed as line amount.
                CcustomerValue := 0;
                CcustomerValue := SalInvLine.Amount + igstval + Sgstval + cgstval;
                TotItemVal := DELCHR(FORMAT(CcustomerValue), '=', ',');
                IF TotItemVal = '' THEN TotItemVal := '0';
                TotInvValHdr := TotInvValHdr + CcustomerValue;
                //Total Item Value Done
                //Order line referencee
                OrdLineRef := FORMAT(SalInvLine."Line No.");
                //Order line referencee Done
                //Orgin Country
                // OrgCntry := SalInvLine.Narration;
                IF OrgCntry <> '' THEN
                    OrgCntryText := ',' + '"OrgCntry":' + '"' + OrgCntry + '"'
                ELSE
                    IF OrgCntry = '' THEN OrgCntryText := '';
                //Orgin Country Done
                //Test001
                //----------------------------------------------------------------Batch Details-------------------------------------------------------------------
                // Added code for new Batch Details
                GenVE.RESET;
                GenVE.SETRANGE("Document No.", SalInvLine."Document No.");
                GenVE.SETRANGE("Document Line No.", SalInvLine."Line No.");
                IF GenVE.FINDFIRST THEN BEGIN
                    GenILE.RESET;
                    GenILE.SETRANGE("Entry No.", GenVE."Item Ledger Entry No.");
                    IF GenILE.FINDFIRST THEN BEGIN
                        IF GenILE."Lot No." <> '' THEN BEGIN
                            PrdSlNo := '';
                            BtchNm := GenILE."Lot No.";
                            ExpDt := FORMAT(GenILE."Expiration Date", 0, '<day,2>/<month,2>/<year4>');
                            WrDt := '';
                        END
                        ELSE
                            IF GenILE."Lot No." = '' THEN BEGIN
                                PrdSlNo := '';
                                BtchNm := '';
                                ExpDt := '';
                                WrDt := '';
                            END;
                    END;
                END;
                // Added code for new Batch Details
                /*
                 //Product Serial Number and Batch Details
                   GenVE.RESET;
                   GenVE.SETRANGE("Document No.",SalInvLine."Document No.");
                   GenVE.SETRANGE("Document Line No.",SalInvLine."Line No.");
                   IF GenVE.FINDFIRST THEN BEGIN
                     GenILE.RESET;
                     GenILE.SETRANGE("Entry No.",GenVE."Item Ledger Entry No.");
                     IF GenILE.FINDFIRST THEN BEGIN
                       PrdSlNo := GenILE."Serial No.";

                       IF PrdSlNo <>'' THEN
                       PrdSlNoText:= '"PrdSlNo":'+'"'+PrdSlNo+'"'+','
                       ELSE
                       PrdSlNoText:='';
                       //  PrdSlNo := 'SN12673';

                      //Test001
                       IF BtchNm = '' THEN
                         BtchNm := 'BN12673';
                     //Test001

                       ExpDt := FORMAT(GenILE."Expiration Date",0,'<day,2>/<month,2>/<year4>');
                       WrDt := FORMAT(GenILE."Warranty Date",0,'<day,2>/<month,2>/<year4>');

                       IF ExpDt = '' THEN
                         ExpDt := '25/09/2020';

                       IF WrDt = '' THEN
                         WrDt := '25/09/2020';
                         BtchNm := GenILE."Lot No.";
                       IF BtchNm <>'' THEN
                       //BtchNmText:='"Nm":'+'"'+BtchNm+'"'+','
                       BtchNmText :='"BchDtls":'+'{'+'"Expdt":'+'"'+ExpDt+'"'+','+'"wrDt":'+'"'+WrDt+'"' +'}'+','
                       ELSE
                       BtchNmText:='XYZ'; //Test001


                     END;
                   END;
                 //Product Serial Number and Batch Details Done

               //Test001
               */
                //-------------------------------------------------------------------------Attribute Details--------------------------------------------------------------
                //Attribute Details
                AtrbNm := CONVERTSTR(SalInvLine.Description, '"', '-');
                AtrbVal := DELCHR(FORMAT(SalInvLine."Amount"), '=', ',');
                IF AtrbVal = '' THEN AtrbVal := '0';
                //Attribute Details Done
                // AtrbNm := '';  // Test 001
                // AtrbVal := ''; // Test 001
                loopcount := loopcount - 1;
                GSTUQC := '';
                //Item Line Json creation
                IF (loopcount) > 0 THEN BEGIN
                    json_line := json_line + '{' + '"SlNo":' + '"' + SlNo + '"' + ',' + '"PrdDesc":' + '"' + CONVERTSTR(SalInvLine.Description, '"', '-') + '"' + ',' + '"IsServc":' + '"' + 'N' + '"' + ',' + '"HsnCd":' + '"' + HsnCd + '"' + ',' + BarcdeText //+'"Barcde":'+'"'+Barcde+'"'+','
                    + '"Qty":' + Qty + ',' + '"FreeQty":' + FreeQty + ',' + '"Unit":' + '"' + Unit + '"' + ',' + '"UnitPrice":' + UnitPrice + ',' + '"TotAmt":' + TotAmt + ',' + '"Discount":' + Discount + ',' + '"PreTaxVal":' + PreTaxVal + ',' + '"AssAmt":' + AssAmt + ',' + '"GstRt":' + format(GstRt) + ',' + '"IgstAmt":' + IgstAmt + ',' + '"CgstAmt":' + CgstAmt + ',' + '"SgstAmt":' + SgstAmt + ',' + '"CesRt":' + CesRt + ',' + '"CesAmt":' + CesAmt + ',' + '"CesNonAdvlAmt":' + CesNonAdvlAmt + ',' + '"StateCesRt":' + StateCesRt + ',' + '"StateCesAmt":' + StateCesAmt + ',' + '"StateCesNonAdvlAmt":' + StateCesNonAdvlAmt + ',' + '"OthChrg":' + OthChrg + ',' + '"TotItemVal":' + TotItemVal + ',' + '"OrdLineRef":' + '"' + OrdLineRef + '"' + ',' + OrgCntryText //+'"OrgCntry":'+'"'+OrgCntry+'"'+','
                    + PrdSlNoText //+'"PrdSlNo":'+'"'+PrdSlNo+'"'+','
                    //Batch Details
                    //+BtchNmText  //Test001
                    //+'"BchDtls":'+'{'
                    //+BtchNmText
                    //+'"Nm":'+'"'+BtchNm+'"'+','
                    //+'"Expdt":'+'"'+ExpDt+'"'+','
                    //+'"wrDt":'+'"'+WrDt+'"'
                    //+'}'+','
                    //Atribute Details
                    + '"AttribDtls":' + '[' + '{' + '"Nm":' + '"' + AtrbNm + '"' + ',' + '"Nm":' + '"' + AtrbVal + '"' + '}' + ']' + '}' + ','
                END
                ELSE
                    IF (loopcount) = 0 THEN BEGIN
                        json_line := json_line + '{' + '"SlNo":' + '"' + SlNo + '"' + ',' + '"PrdDesc":' + '"' + CONVERTSTR(SalInvLine.Description, '"', '-') + '"' + ',' + '"IsServc":' + '"' + 'N' + '"' + ',' + '"HsnCd":' + '"' + HsnCd + '"' + ',' + BarcdeText //+'"Barcde":'+'"'+Barcde+'"'+','
                        + '"Qty":' + Qty + ',' + '"FreeQty":' + FreeQty + ',' + '"Unit":' + '"' + Unit + '"' + ',' + '"UnitPrice":' + UnitPrice + ',' + '"TotAmt":' + TotAmt + ',' + '"Discount":' + Discount + ',' + '"PreTaxVal":' + PreTaxVal + ',' + '"AssAmt":' + AssAmt + ',' + '"GstRt":' + format(GstRt) + ',' + '"IgstAmt":' + IgstAmt + ',' + '"CgstAmt":' + CgstAmt + ',' + '"SgstAmt":' + SgstAmt + ',' + '"CesRt":' + CesRt + ',' + '"CesAmt":' + CesAmt + ',' + '"CesNonAdvlAmt":' + CesNonAdvlAmt + ',' + '"StateCesRt":' + StateCesRt + ',' + '"StateCesAmt":' + StateCesAmt + ',' + '"StateCesNonAdvlAmt":' + StateCesNonAdvlAmt + ',' + '"OthChrg":' + OthChrg + ',' + '"TotItemVal":' + TotItemVal + ',' + '"OrdLineRef":' + '"' + OrdLineRef + '"' + ',' + OrgCntryText //+'"OrgCntry":'+'"'+OrgCntry+'"'+','
                        + PrdSlNoText //+'"PrdSlNo":'+'"'+PrdSlNo+'"'+','
                        //Batch Details
                        //+'"BchDtls":'+'{'
                        + BtchNmText + '"Nm":' + '"' + BtchNm + '"' + ',' //Test001
                                                                          //+'"Expdt":'+'"'+ExpDt+'"'+','
                                                                          //+'"wrDt":'+'"'+WrDt+'"'
                                                                          //+'}'+','
                                                                          //Atribute Details
                        + '"AttribDtls":' + '[' + '{' + '"Nm":' + '"' + AtrbNm + '"' + ',' + '"Val":' + '"' + AtrbVal + '"' + '}' + ']' + '}'
                    END;
            UNTIL SalInvLine.NEXT = 0;
            json_line := json_line + ']' + ',';
        END;
        //-------------------------------------------------------------------------Header Value / Amount Details-------------------------------------------------------------
        AssAmtHdr := DELCHR(FORMAT(AssAmtHdrVal), '=', ',');
        IF AssAmtHdr = '' THEN AssAmtHdr := '0';
        CgstAmtHdr := DELCHR(FORMAT(CgstAmtHdrVal), '=', ',');
        IF CgstAmtHdr = '' THEN CgstAmtHdr := '0';
        SgstAmtHdr := DELCHR(FORMAT(SgstAmtHdrVal), '=', ',');
        IF SgstAmtHdr = '' THEN SgstAmtHdr := '0';
        IgstAmtHdr := DELCHR(FORMAT(IgstAmtHdrVal), '=', ',');
        IF IgstAmtHdr = '' THEN IgstAmtHdr := '0';
        CesAmtHdr := DELCHR(FORMAT(CesAmtHdrVal), '=', ',');
        IF CesAmtHdr = '' THEN CesAmtHdr := '0';
        StateCesAmtHdr := DELCHR(FORMAT(StateCesAmtHdr), '=', ',');
        IF StateCesAmtHdr = '' THEN StateCesAmtHdr := '0';
        DiscountHdr := DELCHR(FORMAT(DiscountHdr), '=', ',');
        IF DiscountHdr = '' THEN DiscountHdr := '0';
        OthChrgHdr := DELCHR(FORMAT(OthChrgHdr), '=', ',');
        IF OthChrgHdr = '' THEN OthChrgHdr := '0';
        RndOffAmt := '0';
        IF RndOffAmt = '0' THEN RndOffAmtText := RndOffAmt;
        TotInvValFc := DELCHR(FORMAT(TotInvValHdr), '=', ','); //-------------------------------------------
        IF TotInvValFc = '' THEN TotInvValFc := '0';
        TotInvVal := DELCHR(FORMAT(TotInvValHdr), '=', ',');
        IF TotInvVal = '' THEN TotInvVal := '0';
        //Assessable value Done
        //-----------------------------------------------------------------------Payee Details Start-------------------------------------------------------------------------
        PayNm := '';
        AccDet := '';
        Mode := '';
        FinInsBr := '';
        PayTerm := '';
        PayInstr := '';
        CrTrn := '';
        DirDr := '';
        CrDay := '';
        PaidAmt := '';
        PaymtDue := '';
        /*
          //Payee Details
            PayNm := 'Dummy Payee Name';
            AccDet := 'Dummy AC Detail';
            Mode := eInvoiceSalHdr."Payment Method Code";
            IF Mode <>'' THEN
            ModeText:='"Mode":'+'"'+Mode+'"'+','
            ELSE
            ModeText:='';
            //IF Mode = '' THEN
            //  Mode := 'Cash';//Hardcoded

            FinInsBr := 'DummyBranch';

            //Payment Terms
            IF eInvoiceSalHdr."Payment Terms Code" <> '' THEN BEGIN
              PayTrm.RESET;
              PayTrm.SETRANGE(Code,eInvoiceSalHdr."Payment Terms Code");
              IF PayTrm.FINDFIRST THEN
                PayTerm := FORMAT(CALCDATE(PayTrm."Due Date Calculation"));
            END ELSE IF eInvoiceSalHdr."Payment Terms Code" = '' THEN
              PayTerm := '0';
            //Payment Terms Done

            PayInstr := 'Dummy Pay Instr';
            CrTrn := 'Dummy Credit Tran';
            DirDr := 'Dummy DIrect Tran';
            //CrDay := FORMAT(CALCDATE(PayTrm."Due Date Calculation"));
            CrDay := '30';

            //Paid Amount
              GenCLE.RESET;
              GenCLE.SETRANGE("Document No.",eInvoiceSalHdr."No.");
              IF GenCLE.FINDFIRST THEN BEGIN
                GenCLE.CALCFIELDS("Original Amt. (LCY)","Remaining Amt. (LCY)");

                PaidAmt := DELCHR(FORMAT(GenCLE."Original Amt. (LCY)" - GenCLE."Remaining Amt. (LCY)"),'=',',');
                PaymtDue := DELCHR(FORMAT(GenCLE."Remaining Amt. (LCY)"),'=',',');
              END;

        */
        //-----------------------------------------------------------------------Reference Details Start-------------------------------------------------
        /*
        InvRm := '';

        InvStDt := '';
        InvEndDt := '';
        */
        //Remarks
        InvRm := 'Invoice Remarks';
        //InvStDt := '01/08/2020';
        InvStDt := FORMAT(CALCDATE('-CM', eInvoiceSalHdr."Posting Date"), 0, '<day,2>/<month,2>/<year4>');
        InvEndDt := FORMAT(CALCDATE('CM', eInvoiceSalHdr."Posting Date"), 0, '<day,2>/<month,2>/<year4>');
        //-----------------------------------------------------------------------Preceeding Document Details Stat------------------------------------------------
        PrecInvNo := '';
        PrecInvDt := '';
        OthRefNo := '';
        /*
            PrecInvNo := '';
            IF PrecInvNo <> '' THEN
             PrecInvNoText := '"InvNo":'+'"'+PrecInvNo+'"'
            ELSE
              PrecInvNoText := '';

            PrecInvDt := '';
            IF PrecInvDt <> '' THEN
             PrecInvDtText := ','+'"InvDt":'+'"'+PrecInvDt+'"'
            ELSE
              PrecInvDtText := '';

            OthRefNo := '';
            IF OthRefNo <> '' THEN
             OthRefNoText := ','+'"OthRefNo":'+'"'+OthRefNo+'"'
            ELSE
              OthRefNoText := '';
         */
        //--------------------------------------------------------------------------Contract Details Start------------------------------------------------------
        RecAdvRefr := '';
        RecAdvDt := '';
        TendRefr := '';
        ContrRefr := '';
        ExtRefr := '';
        ProjRefr := '';
        PORefr := '';
        PORefDt := '';
        /*
            RecAdvRefr := 'Doc/003';
            RecAdvDt := '01/08/2020';
            TendRefr := 'Abc001';
            ContrRefr := 'Co123';
            ExtRefr := 'Yo456';
            ProjRefr := 'Doc-456';
            PORefr := 'Doc-789';
            PORefDt := '01/08/2020';
        */
        //--------------------------------------------------------------------------Any additional Document Details Start------------------------------------------
        DocUrl := '';
        Docs := '';
        Info := '';
        /*
         DocUrl := 'https://einv-apisandbox.nic.in';
         Docs := 'Test Doc';
         Info := 'Document Test';
        */
        //--------------------------------------------------------------------------Export Details Start-----------------------------------------------------------
        ShipBNo := 'A-248';
        ShipBDt := '01/08/2020';
        Port := 'INABG1';
        RefClm := 'N';
        ForCur := 'AED';
        CntCode := 'AE';
        ExpDuty := '0';
        //LogSecurityAudit();
        location1.Get(eInvoiceSalHdr."Transfer-to Code");
        location.get(eInvoiceSalHdr."Transfer-from Code");
        EinvJson.AddText('{' +
          '"Version": "1.1",' +
          '"TranDtls": {' +
            '"TaxSch": "GST",' +
            '"SupTyp": "B2B",' +
            '"RegRev": "N",' +
            //'"EcmGstin": null,' +
            '"IgstOnIntra": "N"' +
          '},' +
          '"DocDtls": {' +
            '"Typ": "INV",' +
            '"No":' + '"' + format(eInvoiceSalHdr."No.") + '",' +
            '"Dt":' + '"' + FORMAT(eInvoiceSalHdr."Posting Date", 0, '<day,2>/<month,2>/<year4>') + '"' +
          '},' +
          '"SellerDtls": {' +
            '"Gstin": "' + location."GST Registration No." + '",' +
            // '"Gstin": "' + '01AMBPG7773M002' + '",' +
            '"LglNm": "' + Format(location.name) + '",' +
            '"TrdNm": "' + Format(location.Name) + '",' +
            '"Addr1": "' + format(location.Address) + '",' +
            '"Addr2": "' + Format(location."Address 2") + '",' +
            '"Loc": "' + Format(location.City) + '",' +
            '"Pin": ' + Format(location."Post Code") + ',' +
            '"Stcd": "' + SlrStcd + '",' +
            // '"Pin": ' + '180013' + ',' +
            // '"Stcd": "' + '01' + '",' +
            '"Ph": "' + Format(location."Phone No.") + '"' +
          //'"Em": "' + Format(location."E-Mail") + '"' +
          '},' +
          '"BuyerDtls": {' +
              '"Gstin": "' + location1."GST Registration No." + '",' +
            // '"Gstin": "' + '37AMBPG7773M002' + '",' +
            '"LglNm": "' + location1.Name + '",' +
            '"TrdNm": "' + location1.Name + '",' +
            '"Pos": "' + POS + '",' +
            '"Addr1": "' + location1.Address + '",' +
            '"Addr2": "' + Format(location1."Address 2") + '",' +
            '"Loc": "' + Format(location1.City) + '",' +
            '"Pin": ' + Format(location1."Post Code") + ',' +
            '"Stcd": "' + ByrStcd + '"' +
          // '"Pin": ' + '515001' + ',' +
          // '"Stcd": "' + '37' + '"' +
          // '"Ph": "' + Format(location1."Phone No.") + '",' +
          // '"Em": "' + Format(location1."E-Mail") + '"' +
          '},' +
          json_line +
          '"ValDtls": {' +
            '"AssVal": ' + AssAmtHdr + ',' +
            '"CgstVal": ' + CgstAmtHdr + ',' +
            '"SgstVal": ' + SgstAmtHdr + ',' +
            '"IgstVal": ' + IgstAmtHdr + ',' +
            '"CesVal": ' + CesAmtHdr + ',' +
            '"StCesVal": ' + StateCesAmt + ',' +
            '"Discount": ' + '0' + ',' +
            '"OthChrg": ' + OthChrgHdr + ',' +
            '"RndOffAmt": ' + RndOffAmtText + ',' +
             '"TotInvVal": ' + TotInvVal +// ',' +
                                          // '"TotInvValFc": ' + TotInvValFc + '' +



          '}' +
'}');

        // EinvJson.AddText('{' + '"Version":' + '"' + Version + '"' + ',' //Transaction Details
        // + '"TranDtls":' + '{' + '"TaxSch":' + '"' + TaxSch + '"' + ',' + '"SupTyp":' + '"' + SupTyp + '"' + ',' + '"RegRev":' + '"' + RegRev + '"' + ',' + EcmGstinText //+'"EcmGstin":'+'"'+EcmGstin+'"'+','
        // + '"IgstOnIntra":' + '"' + IgstOnIntra + '"' + '}' + ',' //Document Details
        // + '"DocDtls":' + '{' + '"Typ":' + '"' + Typ + '"' + ',' + '"No":' + '"' + eInvoiceSalHdr."No." + '"' + ',' //+'"No":'+'"'+'TSTDOC0007'+'"'+','
        // + '"Dt":' + '"' + FORMAT(eInvoiceSalHdr."Posting Date", 0, '<day,2>/<month,2>/<year4>') + '"' + '}' + ',' //Seller Details
        // + '"SellerDtls":' + '{' //   + '"Gstin":' + '"' + SlrGstin + '"' + ','
        // //   + '"LglNm":' + '"' + SlrLglNm + '"' + ','
        // + '"Gstin":' + '"' + '01AMBPG7773M002' + '"' + ',' + '"LglNm":' + '"' + SlrLglNm + '"' + ',' + '"TrdNm":' + '"' + SlrTrdNm + '"' + ',' + '"Addr1":' + '"' + SlrAddr1 + '"' + ',' + SlrAddr2Text //+'"Addr2":'+'"'+SlrAddr2+'"'+','
        // + SlrLocText //+'"Loc":'+'"'+SlrLoc+'"'+','
        // //   + '"Pin":' + SlrPin + ','
        // //   + '"Stcd":' + '"' + SlrStcd + '"' + ','
        // + '"Pin":' + '181102' + ',' + '"Stcd":' + '"' + 'JK' + '"' + ',' + '"Ph":' + '"' + SlrPh + '"' + SlrEmText //+'"Em":'+'"'+SlrEm+'"'
        // + '}' + ',' //Buyer Details
        // + '"BuyerDtls":' + '{' + '"Gstin":' + '"' + ByrGstin + '"' + ',' + '"LglNm":' + '"' + ByrLglNm + '"' + ',' + '"TrdNm":' + '"' + ByrTrdNm + '"' + ',' + '"Pos":' + '"' + POSStcd + '"' + ',' + '"Addr1":' + '"' + ByrAddr1 + '"' + ',' + ByrAddr2Text //+'"Addr2":'+'"'+ByrAddr2+'"'+','
        // + '"Loc":' + '"' + ByrLoc + '"' + ',' + '"Pin":' + ByrPin + ',' + '"Stcd":' + '"' + ByrStcd + '"' + ByrPhText //+'"Ph":'+'"'+ByrPh+'"'
        // + ByrEmText // +'"Em":'+'"'+ByrEm+'"'
        // + '}' + ',' //Dispatcher Details
        // // +'"DispDtls":'+'{'
        // // +'"Nm":'+'"'+DspNm+'"'+','
        // //  +'"Addr1":'+'"'+DspAddr1+'"'+','
        // // +DspAddr2Text
        // //+'"Addr2":'+'"'+DspAddr2+'"'+','
        // //+DspLocText //+'"Loc":'+'"'+DspLoc+'"'+','
        // // +'"Pin":'+DspPin+','
        // //  +'"Stcd":'+'"'+DspStcd+'"'
        // //  +'}'+','
        // //Shipping Details
        // // +'"ShipDtls":'+'{'
        // //+'"Gstin":'+'"'+ShpGstin+'"'+','
        // // +'"LglNm":'+'"'+ShpLglNm+'"'+','
        // // +'"TrdNm":'+'"'+ShpTrdNm+'"'+','
        // //+'"Addr1":'+'"'+ShpAddr1+'"'+','
        // // +ShpAddr2Text
        // //+'"Addr2":'+'"'+ShpAddr2+'"'+','
        // //+ShpLocText //+'"Loc":'+'"'+ShpLoc+'"'+','
        // //+'"Pin":'+ShpPin+','
        // // +'"Stcd":'+'"'+ShpStcd+'"'
        // //+'}'+','
        // //Add Item Line Details
        // + json_line //Value / Amount Details
        // + '"ValDtls":' + '{' + '"AssVal":' + AssAmtHdr + ',' + '"CgstVal":' + CgstAmtHdr + ',' + '"SgstVal":' + SgstAmtHdr + ',' + '"IgstVal":' + IgstAmtHdr + ',' + '"CesVal":' + CesAmtHdr + ',' + '"StCesVal":' + StateCesAmt + ',' + '"Discount":' + DiscountHdr + ',' + '"OthChrg":' + OthChrgHdr + ',' //+'"RndOffAmt":'+RndOffAmt+','
        // + RndOffAmtText + '"TotInvVal":' + TotInvVal //+','+'"TotInvValFc":'+TotInvValFc
        // + '}' + ',' //Payee Details - Optional
        // /*
        //   +'"PayDtls":'+'{'
        //   +'"Nm":'+'"'+PayNm+'"'+','
        //   +'"Accdet":'+'"'+AccDet+'"'+','
        //   +ModeText
        //   //+'"Mode":'+'"'+Mode+'"'+','
        //   +'"Fininsbr":'+'"'+FinInsBr+'"'+','
        //   +'"Payterm":'+'"'+PayTerm+'"'+','
        //   +'"Payinstr":'+'"'+PayInstr+'"'+','
        //   +'"Crtrn":'+'"'+CrTrn+'"'+','
        //   +'"Dirdr":'+'"'+DirDr+'"'+','
        //   +'"Crday":'+CrDay+','
        //   +'"Paidamt":'+PaidAmt+','
        //   +'"Paymtdue":'+PaymtDue
        //   +'}'+','
        //   */
        // //Reference Details
        // + '"RefDtls":' + '{' + '"InvRm":' + '"' + InvRm + '"' + ',' + '"DocPerdDtls":' + '{' + '"InvStDt":' + '"' + InvStDt + '"' + ',' + '"InvEndDt":' + '"' + InvEndDt + '"' //+'}'+','
        // + '}' //Preceeding Document Details - Conditional Mandatory
        // /*
        //   +'"PrecDocDtls":'+'['
        //   +'{'
        //   +PrecInvNoText
        //   +PrecInvDtText
        //   +OthRefNoText
        //   +'}'
        //   +']'+','
        //   */
        // //Contract Details - Optional
        // /*
        //   +'"ContrDtls":'+'['
        //   +'{'
        //   +'"RecAdvRefr":'+'"'+RecAdvRefr+'"'+','
        //   +'"RecAdvDt":'+'"'+RecAdvDt+'"'+','
        //   +'"Tendrefr":'+'"'+TendRefr+'"'+','
        //   +'"Contrrefr":'+'"'+ContrRefr+'"'+','
        //   +'"Extrefr":'+'"'+ExtRefr+'"'+','
        //   +'"Projrefr":'+'"'+ProjRefr+'"'+','
        //   +'"Porefr":'+'"'+PORefr+'"'+','
        //   +'"PoRefDt":'+'"'+PORefDt+'"'
        //   +'}'
        //   +']'*/
        // //+'}'+','
        // + '}' //Any additional Document Details - Optional
        // /*
        //   +'"AddlDocDtls":'+'['
        //   +'{'
        //   +'"Url":'+'"'+DocUrl+'"'+','
        //   +'"Docs":'+'"'+Docs+'"'+','
        //   +'"Info":'+'"'+Info+'"'
        //   +'}'
        //   +']'+','
        //   */
        // //Export Details - Optional
        // /*
        //   +'"ExpDtls":'+'{'
        //   +'"ShipBNo":'+'"'+ShipBNo+'"'+','
        //   +'"ShipBDt":'+'"'+ShipBDt+'"'+','
        //   +'"Port":'+'"'+Port+'"'+','
        //   +'"RefClm":'+'"'+RefClm+'"'+','
        //   +'"ForCur":'+'"'+ForCur+'"'+','
        //   +'"CntCode":'+'"'+CntCode+'"'+','
        //   +'"ExpDuty":'+ExpDuty
        //   +'}'
        //   */
        // + '}');
        /*
        //Test
        MyFile.CREATE('D:\Json\'+'Rohit'+'.txt');
        MESSAGE('Created');
        //MESSAGE('Sales invoice No = %1',SInvNo);

        //MESSAGE(EinvJson);
        //MyFile.WRITEMODE(TRUE);
        MyFile.CREATEOUTSTREAM(OutStr);
        OutStr.WRITETEXT('Rohit Vaidya');
        MyFile.CLOSE;
        //Test
        */
        SInvNo := CONVERTSTR(eInvoiceSalHdr."No.", '/', '_');
        //MyFile.CREATE('D:\json\eInvoice_'+SInvNo+'.txt');
        //MyFile.CREATE('D:\Users\jitendra\Desktop\E- Invoice\Json\'+SInvNo+'.txt');
        /* MyFile.CREATE('D:\EinvJson\' + SInvNo + '.txt');
        //MESSAGE('Created');
        //MESSAGE('Sales invoice No = %1',SInvNo);

        //MESSAGE(EinvJson);
        //MyFile.WRITEMODE(TRUE);
        MyFile.CREATEOUTSTREAM(OutStr);
        OutStr.WRITETEXT(EinvJson);
        MyFile.CLOSE; */
        //NitishPAtel
        Message(Format(EinvJson));
        EXIT(EinvJson);
    end;

    procedure "Generate E-Way-BillByIRN"(Var SalesInvHdr: Record "Transfer Shipment Header"): Bigtext
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
        TransMode: Integer;
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
        lrDate: Text;
        LRNo: text;
    begin
        // GSTEInvoice.GenerateAuthPayload(Rec."No.",TRUE);//Auth Token stored
        // recAuthData.RESET;
        // recAuthData.SETCURRENTKEY("Sr No.");
        // recAuthData.SETFILTER(DocumentNum,'=%1',Rec."No.");
        // IF recAuthData.FINDLAST THEN;


        // IF ShippingAgent.GET(SalesInvHdr."Shipping Agent Code") THEN BEGIN
        //     TransID := ShippingAgent."GST Registration No.";
        //     TransName := ShippingAgent.Name;
        //     TransMode := SalesInvHdr."Transport Method";
        //     Distance := SalesInvHdr."Distance (Km)";//ROUND("Distance (Km)",1,'=')
        //     VehNo := SalesInvHdr."Vehicle No.";
        //     LRNo := SalesInvHdr."LR/RR No.";

        IF STRLEN(FORMAT(SalesInvHdr."LR/RR Date")) > 1 THEN BEGIN


            lrDate := FORMAT(SalesInvHdr."LR/RR Date", 0, '<day,2>/<month,2>/<year4>');//Naveen--CCIt
        END;
        TransID := SalesInvHdr."Transporter GST REg No";
        TransName := SalesInvHdr."Transporter Name";
        TransMode := SalesInvHdr."Transport Mode";
        Distance := SalesInvHdr."Distance (Km)";//ROUND("Distance (Km)",1,'=')
        VehNo := SalesInvHdr."Vehicle No.";
        LRNo := SalesInvHdr."Transporter Doc No.";
        lrDate := FORMAT(SalesInvHdr."Transporter Date", 0, '<day,2>/<month,2>/<year4>');

        IF SalesInvHdr."Vehicle Type" <> SalesInvHdr."Vehicle Type"::" " THEN
            IF SalesInvHdr."Vehicle Type" = SalesInvHdr."Vehicle Type"::ODC THEN
                VehType := 'O'
            ELSE
                VehType := 'R'
        ELSE
            VehType := '';
        //END;
        sb := sb.StringBuilder;
        StringWriter := StringWriter.StringWriter(sb);
        JsonTextWriter := JsonTextWriter.JsonTextWriter(StringWriter);
        JsonTextWriter.Formatting := JsonFormatting.Indented;

        JsonTextWriter.WriteStartObject;
        JsonTextWriter.WritePropertyName('irn');
        JsonTextWriter.WriteValue(SalesInvHdr."IRN Hash");

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
        JsonTextWriter.WriteValue(format(TransMode));
        JsonTextWriter.WriteEndObject;
        JsonTextWriter.Flush;
        MESSAGE('%1', sb.ToString());
        exit(sb.ToString());

    end;

    procedure CancelEwayBill(Var TransferHeader: Record "Transfer Shipment Header"): Text
    var
        ewayJson: JsonObject;
    begin

        ewayJson.Add('ewbNo', TransferHeader."E-Way Bill No.");
        ewayJson.Add('cancelRsnCode', 2);
        ewayJson.Add('cancelRmrk', 'Wrong Entry');
        exit(format(ewayJson));

    end;

    procedure CancelIRN(Var TransferHeader: Record "Transfer Shipment Header"): Text
    var
        ewayJson: JsonObject;
    begin

        ewayJson.Add('Irn', TransferHeader."IRN Hash");
        ewayJson.Add('CnlRsn', '1');
        ewayJson.Add('CnlRem', 'Wrong Entry');
        exit(format(ewayJson));

    end;



}