xmlport 50158 ImportItemsXmlPort
{
    Format = VariableText;
    Direction = Import;
    FileName = 'Details.csv';
    FormatEvaluate = Legacy;
    //TextEncoding = UTF8;
    UseRequestPage = false;
    //TableSeparator = 'NewLine';//New line

    schema
    {
        textelement(ImportitemAccount)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                AutoUpdate = false;
                AutoSave = false;
                // AutoReplace = true;
                UseTemporary = true;
                fieldelement(itemno; Item."No.")
                {
                    FieldValidate = Yes;
                    MinOccurs = Once;
                    AutoCalcField = true;

                }
                fieldelement(itemOldAzaCode; Item.Old_aza_code)
                {
                    FieldValidate = Yes;
                    MinOccurs = Once;
                    AutoCalcField = true;

                }
                fieldelement(itemDesc; Item.Description)
                {
                    FieldValidate = yes;
                    MinOccurs = Once;
                    AutoCalcField = true;
                }
                fieldelement(itemDesc2; Item."Description 2")
                {
                    FieldValidate = yes;
                    MinOccurs = Once;
                }
                fieldelement(itemDesc3; Item."Discription 3")
                {
                    FieldValidate = yes;
                    MinOccurs = zero;
                }
                fieldelement(itemDesc4; Item."Discription 4")
                {
                    FieldValidate = yes;
                    MinOccurs = zero;
                }
                fieldelement(ItemDivision; Item."LSC Division Code")
                {
                    FieldValidate = Yes;
                    MinOccurs = Zero;
                    AutoCalcField = true;

                }
                textelement(lscdiv)
                {
                    //FieldValidate = Yes;
                    MinOccurs = Zero;
                    // AutoCalcField = true;

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
                    FieldValidate = Yes;
                    MinOccurs = Once;
                    AutoCalcField = true;

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
                    //FieldValidate = Yes;
                    MinOccurs = Zero;
                    // AutoCalcField = true;

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
                    AutoCalcField = true;
                }
                fieldelement(itemisapprove; Item."Is Approved for Sale")
                {
                    FieldValidate = Yes;
                    MinOccurs = Once;
                    AutoCalcField = true;

                }
                trigger OnBeforeInsertRecord()
                var
                    itemtab: Record Item;
                begin

                    itemtab.Get(Item."No.");
                    //itemtab."Unit Cost" := Item."Unit Cost";
                    itemtab.Validate(Description, Item.Description);
                    itemtab.Validate("Description 2", Item."Description 2");
                    itemtab.Validate("Discription 3", Item."Discription 3");
                    itemtab.Validate("Discription 4", Item."Discription 4");
                    itemtab.Validate("Search Description", item."Search Description");
                    itemtab.Validate("LSC Division Code", Item."LSC Division Code");
                    itemtab.Validate("Item Category Code", Item."Item Category Code");
                    itemtab.Validate("LSC Retail Product Code", Item."LSC Retail Product Code");
                    itemtab.Validate("Collection Type", Item."Collection Type");
                    itemtab.Validate("No.", Item."No.");
                    itemtab.Validate(Old_aza_code, Item.Old_aza_code);
                    itemtab.Validate(MRP, Item.MRP);
                    //  itemtab.Validate("Unit Cost", Item."Unit Cost");
                    itemtab.Validate("Tag Printed", Item."Tag Printed");
                    itemtab.Validate("fc location", Item."fc location");
                    itemtab.Validate("Sales Unit of Measure", Item."Sales Unit of Measure");
                    itemtab.Validate("Base Unit of Measure", Item."Base Unit of Measure");
                    itemtab.Validate("Vendor No.", Item."Vendor No.");
                    itemtab.Validate("LSC Exclude from Replenishment", Item."LSC Exclude from Replenishment");
                    // itemtab.Validate("GST Credit", Item."GST Credit");
                    // itemtab.Validate("GST Group Code", Item."GST Group Code");
                    // itemtab.Validate("HSN/SAC Code", Item."HSN/SAC Code");
                    itemtab.Validate("Customer Order ID", Item."Customer Order ID");
                    //itemtab.Validate("Customer No.", item."Customer No.");
                    itemtab.Validate("PO No.", Item."PO No.");
                    itemtab.Validate("PO type", item."PO type");
                    // itemtab.Validate("HSN/SAC Code", Item."HSN/SAC Code");
                    itemtab.Validate("Vendor Item No.", Item."Vendor Item No.");
                    itemtab.Validate("Vendor Abbreviation", Item."Vendor Abbreviation");
                    itemtab.Validate("Inclusive of GST", Item."Inclusive of GST");
                    itemtab.Validate(Exempted, Item.Exempted);
                    itemtab.Validate("Unit Price", Item."Unit Price");
                    // if Item.discountPercent <> 0 then
                    //     itemtab.Validate(discountPercent, Item.discountPercent);
                    if (Item.discountPercentByDesg <> 0) and (Item."Disc Amt" = 0) then
                        itemtab.Validate(discountPercentByDesg, Item.discountPercentByDesg);
                    // if (Item.discountPercentByDesg = 0) and (Item."Disc Amt" <> 0) then begin
                    //     itemtab.Validate("Disc Amt", Item."Disc Amt");
                    // end;
                    // Message('%1', Item.discountPercentByAza);
                    if (Item.discountPercentByAza <> 0) and (Item.discountAmountbyAza = 0) then
                        itemtab.Validate(discountPercentByAza, Item.discountPercentByAza);
                    //if (Item.discountPercentByAza = 0) and (Item.discountAmountbyAza <> 0) then
                    itemtab.Validate(discountAmountbyAza, Item.discountAmountbyAza);
                    itemtab.Validate(DiscountAmountbyDesg, Item.DiscountAmountbyDesg);
                    // GstGroup.Reset();
                    // GstGroup.SetRange(Code, Item."GST Group Code");
                    // if GstGroup.FindFirst() then
                    //     Gstrate1 := GstGroup."GST %";
                    // Item."Unit Cost" := Round(Item."Inclusive of GST" - ((Item."Inclusive of GST" * Gstrate1) / (100 + gstrate1)), 0.01);
                    // if Retailuser.Get(UserId) then
                    //     if Retailuser."Item Approve" = false then begin
                    //         Error('You Cannot Authorize to Approve the Item');
                    //     end;
                    // Item.TestField("Unit Price");
                    // Item.TestField("GST Group Code");
                    // if Item."Unit Cost" < 10 then
                    //     Error('Please update the actual unit cost!');
                    // // Rec.TestField("HSN/SAC Code");
                    // Item.TestField("GST Credit");
                    //Rec.TestField("Price Exclusive of Tax");
                    // Rec.TestField("Unit Cost");
                    //Item."Is Approved for Sale" := true;
                    itemtab.Validate("GST Credit", Item."GST Credit");
                    itemtab.Validate("GST Group Code", Item."GST Group Code");
                    itemtab.Validate("HSN/SAC Code", Item."HSN/SAC Code");
                    itemtab.validate("Is Approved for Sale", Item."Is Approved for Sale");
                    //Recvendor.Validate(Name, vendorname);
                    // Message('%1',Item.discountPercentByAza);
                    // Message('item %1', Item."Is Approved for Sale");
                    // Message('item tab 2 %1', itemtab."Is Approved for Sale");

                    itemtab.Modify();
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
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
        Retailuser: Record "LSC Retail User";
        GstGroup: Record "GST Group";
        Gstrate1: Decimal;
}