report 50135 "Tag Report New For All"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Tag_Report NewAZA.rdl';

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
            column(Description; Description) { }
            column(Description_2; "Description 2") { }
            column(BarcodeNo; Barcode."Barcode No.") { }
            column(BrNo; BrNo) { }
            column(HSN_SAC_Code; "HSN/SAC Code") { }
            column(colorName; colorName) { }
            column(sizeName; sizeName) { }
            column(azaCode; azaCode) { }
            column(Pic; recTmpBlob2."Value BLOB") { }
            column(DesignerCode; DesignerCode) { }
            column(Vendor_No_; "Vendor No.") { }
            column(Vendor_Item_No_; Des2) { }
            column(Text05; Text05) { }

            trigger OnAfterGetRecord()
            begin
                Clear(BarcodeText);
                Clear(recTmpBlob2);
                Clear(cduBarcodeMgt);
                BarcodeText := item."No.";
                //  cduBarcodeMgt.EncodeCode128(BarcodeText, 1, false, recTmpBlob2);//Navee---CCIt---1405023
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
                Desc := CopyStr(Item."Discription 3", 1, 11);
                Des2 := CopyStr(Item."Vendor Item No.", 1, 16);
                Text05 := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + '<b>' + Item."No." + '</b>' + '<br>' + Item."Vendor Item No." + '<br>' + DesignerCode + '&nbsp;&nbsp;&nbsp;' + Desc + '<br><b>' + 'MRP- ' + format(Item."Unit Price") + '</b>';
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

    procedure Set_filters(var ItemPara: Record Item)
    begin
        Item.CopyFilters(ItemPara);
    end;

    var
        myInt: Integer;
        Barcode: Record "LSC Barcodes";
        BrNo: Code[20];
        Text01: Label '/-';
        Text02: Label 'NA';
        Text03: Label 'MRZHNMR+IV';
        recTmpBlob2: Record "Name/Value Buffer" temporary;
        cduBarcodeMgt: Codeunit "Barcode Management";
        BarcodeText: Text;
        RecVendor: Record Vendor;
        DesignerCode: Text;
        Text05: Text;
        Desc: Text;
        Des2: Text;
}