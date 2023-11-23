report 50108 "PromoTag Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'PromoTag.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Posted Sales Invoice';

            column(No_; "No.") { }
            column(Unit_Price; "Unit Price") { }
            column(Text01; Text01) { }
            column(Text02; Text02) { }
            column(Text03; Text03) { }
            column(Text04; Text04) { }
            column(Description; Desc) { }
            column(Description_2; "Description 2") { }
            column(Vendor_Item_No_; VendItem) { }
            column(BarcodeNo; Barcode."Barcode No.") { }
            column(BrNo; BrNo) { }
            column(HSN_SAC_Code; "HSN/SAC Code") { }
            column(colorName; colorName) { }
            column(sizeName; sizeName) { }
            column(azaCode; azaCode) { }
            column(MRP; MRP) { }
            column(AzaPrice; AzaPrice) { }
            column(Pic; recTmpBlob2."Value BLOB") { }
            column(DesignerCode; DesignerCode) { }
            column(DesiAbber; DesiAbber) { }
            column(DesiAbber1; DesiAbber1) { }
            column(DesiAbber2; DesiAbber2) { }
            column(Text05; Text05) { }
            column(Text06; Text06) { }
            column(Text07; Text07) { }
            column(Text09; Text09) { }

            trigger OnAfterGetRecord()
            begin
                Clear(BarcodeText);
                Clear(recTmpBlob2);
                Clear(cduBarcodeMgt);
                BarcodeText := item."No.";
                //  cduBarcodeMgt.EncodeCode128(BarcodeText, 1, false, recTmpBlob2);
                cduBarcodeMgt.EncodeCode39(BarcodeText, 1, false, false, recTmpBlob2);
                //Barcode No.
                Barcode.SetRange("Item No.", Item."No.");
                if Barcode.FindFirst() then begin
                    BrNo := Barcode."Barcode No.";
                end;
                RecVendor.Reset();
                RecVendor.SetRange("No.", "Vendor No.");
                if RecVendor.FindFirst() then begin
                    DesignerCode := RecVendor."Designer Abbreviation";
                end;
                LSCDivi.Reset();
                LSCDivi.SetRange(Code, "LSC Division Code");
                if LSCDivi.FindFirst() then begin
                    DesiAbber := LSCDivi."Abbreviation";
                    //  Message(DesiAbber);
                end;
                ItemCategory.Reset();
                ItemCategory.SetRange(Code, "Item Category Code");
                if ItemCategory.FindFirst() then begin
                    DesiAbber1 := ItemCategory."Abbreviation";
                    //  Message(DesiAbber1);
                end;
                LSCRetailProduct.Reset();
                LSCRetailProduct.SetRange("Item Category Code", "Item Category Code");
                LSCRetailProduct.SetRange(Code, "LSC Retail Product Code");
                if LSCRetailProduct.FindFirst() then begin
                    DesiAbber2 := LSCRetailProduct."Abbreviation";
                end;
                Desc := CopyStr(Item.Description, 1, 27);
                VendItem := CopyStr(Item."Vendor Item No.", 1, 27);
                Text05 := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + '<b>' + Item."No." + '</b>' + '<br><b>' + Item."Vendor Item No." + '</b>' + '<br>' + Item.Description;//+ '</b>' + '<br><b>' + 'MRP-  ' + Format(Item.MRP) + '</b>' + '/-(Incl. of all Taxes)' + '<br><b>' + 'Aza Price-  ' + Format(Item."Unit Price") + '</b>';// + '</b>';//<font size="-10">' + Text01 + '</font>';
                // Message(DesiAbber2);
                // '<br>' + Item."Description 2" +
                Text06 := DesiAbber + '&nbsp;&nbsp;' + DesiAbber1 + '&nbsp;&nbsp;' + DesiAbber2 + '<br>' + DesignerCode + '</b>';
                // Text07 := '<b>' + DesiAbber + '&nbsp;&nbsp;' + DesiAbber1 + '&nbsp;&nbsp;' + DesiAbber2 + '</b>' + '<br>' + Item.colorName + '&nbsp;&nbsp;' + '<b>' + DesignerCode + '</b>';// + 'MRP- ' + format(Item.MRP) + '</b>';
                //+ '<br>' + Item."Vendor Item No."
                AzaPrice := 'Aza Price-' + Format(Item."Unit Price");
            end;


        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPreReport()
    begin
        // Barcode.get();
        //Barcode.CalcFields(Picture);
    end;

    trigger OnPostReport()
    var
        recItem: record 27;
    begin
        //CITS_RS 200223
        if recItem.Get(BarcodeText) then begin
            recItem."Tag Print Count" += 1;
            recItem."Tag Printed" := true;
            recItem.Modify(false);
        end;

    end;

    var
        myInt: Integer;
        Desc: Text;
        VendItem: Text;
        Barcode: Record "LSC Barcodes";
        BrNo: Code[20];
        AzaPrice: Text;
        Text01: Label '/-  (Incl. of all taxes)';
        Text09: Label '/-';
        Text02: Label 'NA';
        Text03: Label 'MRZHNMR+IV';
        Text04: Label '/-';
        recTmpBlob2: Record "Name/Value Buffer" temporary;
        cduBarcodeMgt: Codeunit "Barcode Management";
        BarcodeText: Text;
        RecVendor: Record Vendor;
        DesignerCode: Text;
        RecItem: Record Item;
        LSCDivi: Record "LSC Division";
        DesiAbber: Text;
        ItemCategory: Record "Item Category";
        DesiAbber1: Text;
        LSCRetailProduct: Record "LSC Retail Product Group";
        DesiAbber2: Text;
        Text05: Text;
        Text06: Text;
        Text07: Text;
}