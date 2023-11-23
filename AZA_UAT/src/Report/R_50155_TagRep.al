report 50107 "Tag Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Tag_Report.rdl';

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
            column(Description; Desc) { }
            column(Description_2; Des2) { }
            column(Vendor_Item_No_; VendItem) { }
            column(BarcodeNo; Barcode."Barcode No.") { }
            column(BrNo; BrNo) { }
            column(HSN_SAC_Code; "HSN/SAC Code") { }
            column(colorName; colorName) { }
            column(sizeName; sizeName) { }
            column(azaCode; azaCode) { }
            column(Pic; recTmpBlob2."Value BLOB") { }
            column(DesignerCode; DesignerCode) { }
            column(DesiAbber; DesiAbber) { }
            column(DesiAbber1; DesiAbber1) { }
            column(DesiAbber2; DesiAbber2) { }
            column(Text04; Text04) { }
            column(Text05; Text05) { }
            column(Text06; Text06) { }
            column(Text07; Text07) { }
            column(Text08; Text08) { }
            trigger OnAfterGetRecord()
            begin
                Clear(BarcodeText);
                Clear(recTmpBlob2);
                Clear(cduBarcodeMgt);
                BarcodeText := item."No.";
                //cduBarcodeMgt.EncodeCode128(BarcodeText, 1, false, recTmpBlob2);//Navee---CCIt---1405023
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
                Desc := CopyStr(Item.Description, 1, 23);
                Des2 := CopyStr(Item."Vendor Item No.", 1, 23);
                VendItem := CopyStr(Item."Vendor Item No.", 1, 23);
                Text05 := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + '<b>' + Item."No." + '</b>' + '<br>' + Des2 + '<br>' + Desc;// + '<br><b>' + 'MRP- ' + format(Item."Unit Price") + '</b>';//<font size="-10">' + Text01 + '</font>';
                // Message(DesiAbber2);
                Text08 := '<b>' + 'MRP- ' + format(Item."Unit Price") + '</b>';
                Text06 := DesiAbber + '&nbsp;&nbsp;' + DesiAbber1 + '&nbsp;&nbsp;' + DesiAbber2 + '<br><br>' + DesignerCode + '</b>';
                //Text07 := '<b>' + DesiAbber + '&nbsp;&nbsp;' + DesiAbber1 + '&nbsp;&nbsp;' + DesiAbber2 + '</b>' + '<br>' + Item.colorName + '&nbsp;&nbsp;' + '<b>' + DesignerCode + '</b>';// + Item."Vendor Item No." + '</b>';
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

    var
        myInt: Integer;
        Barcode: Record "LSC Barcodes";
        BrNo: Code[20];
        Text01: Label '/-  (Incl. of all taxes)';
        Text02: Label 'NA';
        Text03: Label 'MRZHNMR+IV';
        Text04: Label 'MRP- ';
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
        Text08: Text;
        Desc: Text;
        Des2: Text;
        VendItem: Text;
}