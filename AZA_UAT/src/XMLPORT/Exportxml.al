xmlport 50157 ExportItemsXmlPort
{
    Direction = Export;
    FileName = 'Details.csv';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TableSeparator = '<NewLine><NewLine>';
    // UseRequestPage = false;
    // TextEncoding = UTF8;
    // Permissions = tabledata Integer = imd;

    schema
    {

        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'ItemHeader';
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                AutoSave = false;
                textelement(ItemNoTitle)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemNoTitle := Item.FieldCaption("No.");
                    end;
                }
                textelement(OldAzacodeTitle)
                {

                    trigger OnBeforePassVariable()
                    begin
                        OldAzacodeTitle := Item.FieldCaption(Old_aza_code);
                    end;
                }
                textelement(ItemDescTitle)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemDescTitle := Item.FieldCaption(Description);
                    end;
                }
                textelement(ItemDesc2Title)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemDesc2Title := Item.FieldCaption("Description 2");
                    end;
                }
                textelement(ItemDesc3Title)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemDesc3Title := Item.FieldCaption("Discription 3");
                    end;
                }
                textelement(ItemDesc4Title)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemDesc4Title := Item.FieldCaption("Discription 4");
                    end;
                }
                textelement(ItemDivisionTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemDivisionTitle := Item.FieldCaption("LSC Division Code");
                    end;
                }
                textelement(DivisionDescriptionTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DivisionDescriptionTitle := Item.FieldCaption("Division Description");
                    end;
                }
                textelement(ItemCategoryCodeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemCategoryCodeTitle := Item.FieldCaption("Item Category Code");
                    end;
                }
                textelement(ItemCategoryDescTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemCategoryDescTitle := Item.FieldCaption("Item Cateogry Description");
                    end;
                }
                textelement(LSCRetailProductCodeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        LSCRetailProductCodeTitle := Item.FieldCaption("LSC Retail Product Code");
                    end;
                }
                textelement(LSCRetailProductDescTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        LSCRetailProductDescTitle := Item.FieldCaption("Retail product Description");
                    end;
                }
                textelement(CollectionTypeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CollectionTypeTitle := Item.FieldCaption("Collection Type");
                    end;
                }
                textelement(fclocationTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        fclocationTitle := Item.FieldCaption("fc location");
                    end;
                }
                textelement(ItemMRPTitle)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemMRPTitle := Item.FieldCaption(MRP);
                    end;
                }
                textelement(SalesUnitofMeasureTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SalesUnitofMeasureTitle := Item.FieldCaption("Sales Unit of Measure");
                    end;
                }
                textelement(BaseUnitofMeasureTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BaseUnitofMeasureTitle := Item.FieldCaption("Base Unit of Measure");
                    end;
                }
                textelement(VendorNoTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        VendorNoTitle := Item.FieldCaption("Vendor No.");
                    end;
                }
                textelement(vendornameTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        vendornameTitle := Recvendor.FieldCaption(Name)
                    end;

                }
                textelement(VendorAbberivationTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        VendorAbberivationTitle := Item.FieldCaption("Vendor Abbreviation")
                    end;

                }
                textelement(VendorItemNoTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        VendorItemNoTitle := Item.FieldCaption("Vendor Item No.")
                    end;

                }
                // textelement(discountPercentTitle)
                // {
                //     trigger OnBeforePassVariable()
                //     begin
                //         discountPercentTitle := Item.FieldCaption(discountPercent);
                //     end;
                // }
                textelement(discountPercentByDesgTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        discountPercentByDesgTitle := Item.FieldCaption(discountPercentByDesg);
                    end;
                }
                textelement(DiscountAmountbyDesgTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DiscountAmountbyDesgTitle := Item.FieldCaption(DiscountAmountbyDesg);
                    end;
                }
                textelement(discountPercentByAzaTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        discountPercentByAzaTitle := Item.FieldCaption(discountPercentByAza);
                    end;
                }
                textelement(discountAmountbyAzaTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        discountAmountbyAzaTitle := Item.FieldCaption(discountAmountbyAza);
                    end;
                }
                textelement(CustomerOrderIDTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomerOrderIDTitle := Item.FieldCaption("Customer Order ID");
                    end;
                }
                textelement(CustomerNoTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomerNoTitle := Item.FieldCaption("Customer No.");
                    end;
                }
                textelement(PONoTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PONoTitle := Item.FieldCaption("PO No.");
                    end;
                }
                textelement(POtypeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        POtypeTitle := Item.FieldCaption("PO type");
                    end;
                }
                textelement(GSTGroupCodeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GSTGroupCodeTitle := Item.FieldCaption("GST Group Code");
                    end;
                }
                textelement(HSNSACCodeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        HSNSACCodeTitle := Item.FieldCaption("HSN/SAC Code");
                    end;
                }
                textelement(GSTCreditTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GSTCreditTitle := Item.FieldCaption("GST Credit");
                    end;
                }
                textelement(InclusiveofGSTTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        InclusiveofGSTTitle := Item.FieldCaption("Inclusive of GST");
                    end;
                }
                textelement(ItemUnitPriceTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemUnitPriceTitle := Item.FieldCaption("Unit Price");
                    end;
                }
                textelement(isApproveforsaleTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        isApproveforsaleTitle := Item.FieldCaption("Is Approved for Sale");
                    end;
                }

            }
            tableelement(Item; Item)
            {
                XmlName = 'ItemAccount';
                RequestFilterFields = "No.";
                fieldelement(itemno; Item."No.")
                {
                    FieldValidate = yes;
                    MinOccurs = Once;

                }
                fieldelement(itemno; Item.Old_aza_code)
                {
                    FieldValidate = yes;
                    MinOccurs = Once;

                }
                fieldelement(itemDesc; Item.Description)
                {
                    FieldValidate = yes;
                    MinOccurs = Once;
                }
                fieldelement(itemDesc2; Item."Description 2")
                {
                    FieldValidate = yes;
                    MinOccurs = Once;
                }
                fieldelement(itemDesc3; Item."Discription 3")
                {
                    FieldValidate = yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(itemDesc4; Item."Discription 4")
                {
                    FieldValidate = yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(ItemDivision; Item."LSC Division Code")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                textelement(lscdiv)
                {

                    MinOccurs = Zero;
                    //  AutoCalcField = true;
                }
                fieldelement(ItemCategoryCode; Item."Item Category Code")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                textelement(itemcat)
                {

                    MinOccurs = Zero;
                    //  AutoCalcField = true;
                }
                fieldelement(LSCRetailProductCode; Item."LSC Retail Product Code")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                textelement(retaildesc)
                {

                    MinOccurs = Zero;
                    //  AutoCalcField = true;
                }
                fieldelement(CollectionType; Item."Collection Type")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(fclocation; Item."fc location")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(ItemMrp; Item.MRP)
                {
                    FieldValidate = yes;
                    MinOccurs = Once;
                }
                fieldelement(SalesUnitofMeasure; Item."Sales Unit of Measure")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(BaseUnitofMeasure; Item."Base Unit of Measure")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(VendorNo; Item."Vendor No.")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                textelement(vendorname)
                {

                    MinOccurs = Zero;
                    //  AutoCalcField = true;
                }
                fieldelement(VendorAbberivation; Item."Vendor Abbreviation")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(VendorItemNo; Item."Vendor Item No.")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                // fieldelement(discountPercent; Item.discountPercent)
                // {
                //     FieldValidate = Yes;
                //     MinOccurs = Zero;
                //     AutoCalcField = true;
                // }
                fieldelement(discountPercentByDesg; Item.discountPercentByDesg)
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(DiscountAmountbyDesg; Item.DiscountAmountbyDesg)
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(discountPercentByAza; Item.discountPercentByAza)
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(discountAmountbyAza; Item.discountAmountbyAza)
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(CustomerOrderID; Item."Customer Order ID")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(CustomerNo; Item."Customer No.")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(PONo; Item."PO No.")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(POtype; Item."PO type")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(GSTGroupCode; Item."GST Group Code")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(HSNSACCode; Item."HSN/SAC Code")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(GSTCredit; Item."GST Credit")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;
                }
                fieldelement(ItemInclusiveofGST; Item."Inclusive of GST")
                {
                    FieldValidate = yes;
                    MinOccurs = Once;

                }
                fieldelement(ItemUnitPrice; Item."Unit Price")
                {
                    FieldValidate = yes;
                    MinOccurs = Once;

                }
                fieldelement(itemisapprove; Item."Is Approved for Sale")
                {
                    FieldValidate = yes;
                    MinOccurs = Once;
                    AutoCalcField = true;

                }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                // Recvendor: Record Vendor;
                // vendorname: Text;
                begin
                    Item.CalcFields("Division Description");
                    lscdiv := Item."Division Description";
                    Item.CalcFields("Item Cateogry Description");
                    itemcat := Item."Item Cateogry Description";
                    item.CalcFields("Retail product Description");
                    retaildesc := Item."Retail product Description";
                    Recvendor.Reset();
                    Recvendor.SetRange("No.", Item."Vendor No.");
                    if Recvendor.FindFirst() then begin
                        vendorname := Recvendor.Name;
                        // if Recvendor.Get(Vendcode) then begin
                        //     vendorname := Recvendor.Name;
                        // Message(vendorname);
                    end;

                end;

            }
        }
    }
    trigger OnPostXmlPort()
    begin

        Message('Done');
    end;

    var
        Recvendor: Record Vendor;
        //vendorname: Text;
        Vendcode: Code[20];
    // lscdiv: Text;

}
