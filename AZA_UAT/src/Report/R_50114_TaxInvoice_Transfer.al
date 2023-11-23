report 50114 TaxInvoiceTransfer
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Invoice_Transfer.rdl';




    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            RequestFilterFields = "No.";
            //DataItemTableView = sorting("No.");
            // column(LSC_Store_from; "LSC Store-from")
            // {

            // }
            // column(Name_FromStore; FromStore.Name)
            // {

            // }
            // column(Address_FromStore; FromStore.Address)
            // {

            // }
            // column(GSTNo_FromStore; FromStore."LSCIN GST Registration No")
            // {

            // }
            // column(LSC_Store_to; "LSC Store-to")
            // {

            // }
            // column(Name_ToStore; ToStore.Name)
            // {

            // }
            // column(Address_ToStore; ToStore.Address)
            // {

            // }
            // column(GSTNo_ToStore; ToStore."LSCIN GST Registration No")
            // {

            // }
            column(LSC_Store_from; "Transfer-from Code")
            {

            }
            column(Name_FromStore; "Transfer-from Name")
            {

            }
            column(Address_FromStore; "Transfer-from Address")
            {

            }
            column(GSTNo_FromStore; FromLocation."GST Registration No.")
            {

            }
            column(Transfer_from_Address_2; "Transfer-from Address 2")
            {

            }
            column(Transfer_from_City; "Transfer-from City")
            {

            }
            column(Transfer_from_Post_Code; "Transfer-from Post Code")
            {

            }
            column(Transfer_to_Address_2; "Transfer-to Address 2")
            {

            }
            column(Transfer_to_City; "Transfer-to City")
            {

            }
            column(Transfer_to_Post_Code; "Transfer-to Post Code")
            {

            }
            column(LSC_Store_to; "Transfer-to Code")
            {

            }
            column(Name_ToStore; "Transfer-to Name")
            {

            }
            column(Address_ToStore; "Transfer-to Address")
            {

            }
            column(GSTNo_ToStore; Tolocation."GST Registration No.")
            {

            }
            column(Receipt_Date; Format("Posting Date", 0, '<Day,2>-<Month,2>-<Year4>'))
            {

            }
            column(No_TRF; "No.")
            {

            }
            column(Name_Location; Location.Name)
            {

            }
            column(Address_Location; Location.Address)
            {

            }
            column(Address2_Location; Location."Address 2")
            {

            }

            column(City_Location; Location.City)
            {

            }
            column(PhoneNo_Location; Location."Phone No.")
            {

            }
            column(PostCode_Location; Location."Post Code")
            {

            }
            column(Country_Location; Location."Country/Region Code")
            {

            }

            column(Email_Location; Location."E-Mail")
            {

            }
            column(GST_Location; Location."GST Registration No.")
            {

            }
            column(CompanyName_CompanyInfo; CompanyInfo.Name)
            {

            }
            column(CINNo_CompanyInfo; CompanyInfo."CIN No.")
            {

            }
            // column(Aza_Posting_No_; "Aza Posting No.")
            // {

            // }
            column(Aza_Posting_No_; "Transfer Order No.") { }
            column(IRN_Hash; "IRN Hash") { }
            column(QR_Code; "QR Code") { }
            column(E_Way_Bill_No_; "E-Way Bill No.") { }
            column(Transfer_Reason; "Transfer Reason") { }
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemLink = "Document No." = field("No.");
                column(Item_No_; "Item No.")
                {

                }
                column(HSN_Code; "HSN/SAC Code")
                {

                }
                column(Variant_Code; VC)
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Taxable_Amount; Amount)
                {

                }
                column(cGSTpercent; cGSTpercent)
                {

                }
                column(CGST_Amt; CGST_Amt)
                {

                }
                column(SGSTpercent; SGSTpercent)
                {

                }
                column(SGST_Amt; SGST_Amt)
                {

                }
                column(Percent_IGST; IGST)
                {

                }
                column(IGSTAmount; IGSTAmount)
                {

                }
                column(SizeName; SizeName)
                {

                }
                trigger OnAfterGetRecord()
                var
                    //TaxTransactionValue: Record "LSCIN Tax Transaction Value";
                    TaxTransactionValue: Record "Tax Transaction Value";
                    taxrecordId: RecordId;
                    itemcard: Page "LSC Retail Item Card";

                    TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
                    ComponentAmt: Decimal;
                    decColumnAmt: Decimal;
                    Item: Record Item;

                begin
                    // Message('%1', "Transfer Shipment Line".Amount);
                    if item.get("Item No.") then begin
                        Des := item.Description;
                        SizeName := Item.sizeName;
                    end;
                    VC := item."Vendor No.";

                    //    Message('ID %1', "LSC Trans. Sales Entry".RecordId);
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetFilter("Tax Record ID", '%1', "Transfer Shipment Line".RecordId);
                    TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Visible on Interface", true);
                    TaxTransactionValue.SetFilter(Amount, '<>%1', 0);

                    // TaxTransactionValue.SetRange("Tax Type", 'GST');

                    // if TaxTransactionValue.FindSet() then begin
                    if TaxTransactionValue.Find('-') then
                        repeat

                            IF (TaxTransactionValue.GetAttributeColumName() <> 'GST Base Amount') AND (TaxTransactionValue.GetAttributeColumName() <> 'Total TDS Amount') THEN BEGIN
                                IF (TaxTransactionValue.GetAttributeColumName() = 'CGST') then begin
                                    // if TaxTransactionValue.Amount < "LSC Trans. Sales Entry"."Net Amount" then begin
                                    CGST_Amt := TaxTransactionValue.Amount;//ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER);
                                    cGSTpercent := TaxTransactionValue.Percent;
                                    // Message('Cgst:=%1', CGST_Amt);
                                    // end;
                                end;
                                if (TaxTransactionValue.GetAttributeColumName() = 'SGST') then begin
                                    // ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
                                    // Evaluate(decColumnAmt, TaxTransactionValue."Column Value");
                                    // taxFound := true;
                                    SGST_Amt := TaxTransactionValue.Amount;
                                    SGSTpercent := TaxTransactionValue.Percent;
                                    // Message('Sgst:=%1', SGST_Amt);
                                end;  //CITS_RS
                                if (TaxTransactionValue.GetAttributeColumName() = 'IGST') THEN BEGIN
                                    IGSTAmount := TaxTransactionValue.Amount;
                                    IGST := TaxTransactionValue.Percent;

                                    // taxFound := true;//CITS_RS
                                    //Message('Igst:=%1', IGSTAmount);
                                end;

                            end;
                        until TaxTransactionValue.next() = 0;
                    TotalGSTAmount := abs(SGST_Amt) + abs(CGST_Amt) + abs(IGSTAmount) + abs(Amount);

                end;

            }
            trigger OnAfterGetRecord()
            var
                FromAddress: Text;
            begin
                "Transfer Shipment Header".CalcFields("QR Code"); //Naveen--CCIt
                CompanyInfo.Get();
                if FromStore.Get("LSC Store-from") then;
                if ToStore.Get("LSC Store-to") then;
                if FromLocation.Get("Transfer-from Code") then;
                if Tolocation.Get("Transfer-to Code") then;

                //if Location.Get(FromStore."Location Code") then;
                if Location.Get("Transfer-from Code") then;
                // FromAddress := Location.Address;

            end;
        }
    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {
    //                     ApplicationArea = All;

    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(ActionName)
    //             {
    //                 ApplicationArea = All;

    //             }
    //         }
    //     }
    // }



    var
        myInt: Integer;
        FromStore: Record "LSC Store";
        ToStore: Record "LSC Store";
        FromLocation: Record Location;
        Tolocation: Record Location;
        VC: Text;
        Des: Text;
        SGST_Amt: Decimal;
        SGSTpercent: Decimal;
        CGST_Amt: Decimal;
        cGSTpercent: Decimal;
        IGST: Decimal;
        IGSTAmount: Decimal;
        TotalGSTAmount: Decimal;
        "Net Amount": Decimal;
        Location: Record Location;
        CompanyInfo: Record "Company Information";
        SizeName: Code[50];
}