pageextension 50104 RetailItemCard_Ext extends "LSC Retail Item Card"
{
    layout
    {
        modify("Unit Price Including VAT")
        {
            Editable = false;
        }
        addlast(General)
        {
            field(MRP; Rec.MRP) { ApplicationArea = all; Editable = true; }
        }
        addafter(MRP)
        {
            field("Taxable Value"; Rec."Taxable Value") { ApplicationArea = all; Editable = false; }
        }
        modify("No.")
        {
            Editable = true;
        }

        addafter(Merchandising)
        {
            group(AzaAttributes)
            {
                field(tagCode; Rec.tagCode) { ApplicationArea = all; }
                field("PO Created"; Rec."PO Created") { ApplicationArea = all; }
                field("PO No."; Rec."PO No.") { ApplicationArea = all; }
                field(Old_aza_code; Rec.Old_aza_code) { ApplicationArea = all; }
                field(azaCode; Rec.azaCode) { ApplicationArea = all; }
                field("fc location"; Rec."fc location") { ApplicationArea = all; Editable = false; }
                field(subSubCategoryCode; Rec.subSubCategoryCode) { ApplicationArea = all; Visible = false; }
                field(designerID; Rec.designerID) { ApplicationArea = all; }
                field(componentsNo; Rec.tagCode) { ApplicationArea = all; }
                field(productThumbImg; Rec.tagCode) { ApplicationArea = all; }
                field(addedBy; Rec.tagCode) { ApplicationArea = all; }
                field(dateAdded; Rec.dateAdded) { ApplicationArea = all; }
                field(status; Rec.status) { ApplicationArea = all; }
                field(modifiedBy; Rec.modifiedBy) { ApplicationArea = all; }
                field(merchandiserName; Rec.merchandiserName) { ApplicationArea = all; }
                field("Fabric Type"; Rec."Fabric Type") { ApplicationArea = all; }
                field(image2; Rec.tagCode) { ApplicationArea = all; }
                field(image3; Rec.image3) { ApplicationArea = all; }
                field(image4; Rec.image4) { ApplicationArea = all; }
                field(image5; Rec.image5) { ApplicationArea = all; }
                field(image6; Rec.image6) { ApplicationArea = all; }
                field(image7; Rec.image7) { ApplicationArea = all; }
                field(image8; Rec.image8) { ApplicationArea = all; }
                field(image9; Rec.image9) { ApplicationArea = all; }
                field(image10; Rec.image10) { ApplicationArea = all; }
                field(sizeName; Rec.sizeName) { ApplicationArea = all; }
                field("Size ID"; Rec."Size ID") { ApplicationArea = all; }
                field(colorName; Rec.colorName) { ApplicationArea = all; }
                field("Color ID"; Rec."Color ID") { ApplicationArea = all; }
                field(discountPercent; Rec.discountPercent) { ApplicationArea = all; }
                field(discountPercentByDesg; Rec.discountPercentByDesg) { ApplicationArea = all; }
                field(DiscountAmountbyDesg; Rec.DiscountAmountbyDesg) { ApplicationArea = all; Caption = 'Disc Amt'; Visible = false; }
                field("Disc Amt"; Rec."Disc Amt") { ApplicationArea = all; Caption = 'DiscountAmountbyDesg'; }
                field(discountPercentByAza; Rec.discountPercentByAza) { ApplicationArea = all; }
                field(discountAmountbyAza; Rec.discountAmountbyAza) { ApplicationArea = all; }
                field(filterPrice; Rec.filterPrice) { ApplicationArea = all; }
                field(ItemSaleReserved; Rec.ItemSaleReserved) { ApplicationArea = all; Editable = true; }
                field("PO type"; "PO type") { ApplicationArea = All; }
                field("Discount till date valid"; "Discount till date valid") { ApplicationArea = all; }
                field("Customer Order ID"; Rec."Customer Order ID") { ApplicationArea = all; }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                    begin
                        // if Rec."Customer No." <> '' then begin
                        //     if Rec.ItemSaleReserved = true then begin
                        //         glCustEditable := false;
                        //         CurrPage.Update(true);
                        //     end;

                        // end else
                        //     glCustEditable := true;    //090323commented
                        //Editable = glCustEditable; //150223
                    end;

                }


                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;

                }
                //SK++
                field("Store No."; Rec."Store No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Blocked By User ID"; Rec."Blocked By User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Blocked DateTime"; Rec."Blocked DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                //SK--
                field("Neckline Type"; Rec."Neckline Type") { ApplicationArea = all; }
                field("Sleeve Length"; Rec."Sleeve Length") { ApplicationArea = all; }
                field("Closure Type"; Rec."Closure Type") { ApplicationArea = all; }
                field("Type of Pattern"; Rec."Type of Pattern") { ApplicationArea = all; }
                field("Type of Work"; Rec."Type of Work") { ApplicationArea = all; }
                field("Sleeve Type"; Rec."Sleeve Type") { ApplicationArea = all; }
                field("Stylist Note"; Rec."Stylist Note") { ApplicationArea = all; }
                field("Tag Printed"; Rec."Tag Printed") { ApplicationArea = all; }
                field("Tag Print Count"; Rec."Tag Print Count") { ApplicationArea = all; }
                field("Is Approved for Sale"; Rec."Is Approved for Sale") { ApplicationArea = all; Editable = false; }
                field("First Payment Received Date"; Rec."First Payment Received Date") { ApplicationArea = all; }
                field("Item Booking Date"; Rec."Item Booking Date") { ApplicationArea = all; }
                field("Item Delivery Date"; Rec."Item Delivery Date") { ApplicationArea = all; }
                field("Payment Due Date"; Rec."Payment Due Date") { ApplicationArea = all; }
                field("Vendor Amt. to Pay"; Rec."Vendor Amt. to Pay") { ApplicationArea = all; }
                field("Vendor Payment Date"; Rec."Vendor Payment Date") { ApplicationArea = all; }
                field("Vendor Payment"; "Vendor Payment") { ApplicationArea = All; }
                field("Is Advance"; Rec."Is Advance") { ApplicationArea = all; }
                field("Cust. Phone No."; Rec."Cust. Phone No.") { ApplicationArea = all; }
                //>>>>>>>>>>>
                field("Component description"; Rec."Component description") { ApplicationArea = All; }
                field("sale associate"; Rec."sale associate") { ApplicationArea = All; }
                field(Padded; Rec.Padded) { ApplicationArea = All; }
                field("Attached can can"; Rec."Attached can can") { ApplicationArea = All; }
                field("Query Confirmed By"; "Query Confirmed By") { ApplicationArea = All; }
                field("Collection Type"; "Collection Type") { ApplicationArea = All; }
                field("Product Classication"; "Product Classication") { ApplicationArea = All; }
                field("extra charges Designer"; "extra charges Designer") { ApplicationArea = All; }
                field("extra charges aza"; "extra charges aza") { ApplicationArea = All; }
                field("Order Delivery Date"; "Order Delivery Date") { ApplicationArea = All; }
                field(measurements; Rec.measurements) { ApplicationArea = All; }
                field(ref_barcode; Rec.ref_barcode) { ApplicationArea = All; }
                field("Original AZA Code"; "Original AZA Code") { ApplicationArea = All; }
            }

        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
            }
            field("Discription 3"; Rec."Discription 3")
            {
                ApplicationArea = All;
                Caption = 'Description 3';
            }
            field("Discription 4"; Rec."Discription 4")
            {
                ApplicationArea = All;
                Caption = 'Description 4';
            }
            field(product_desc; product_desc)
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    lscdivision: Record Aza_Item;
                begin
                    if lscdivision.Get(Rec."No.") then begin
                        product_desc := lscdivision.product_desc;

                    end;
                end;
            }
        }
        addafter("PO No.")
        {
            field("GRN No."; "GRN No.")
            {
                ApplicationArea = All;
            }
        }


        addafter(RetailImagePreviewFactbox)
        {
            /* part(RetilCard_ItemPart; RetilCard_ItemPart)
             {
                 ApplicationArea = All;
                 Enabled = false;
                 ShowFilter = false;
                 Caption = 'Picture 2';
             }*/
            part(Picture; "Picture")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
            }
            part(Picture2; "Item Picture 2")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
            }
            // part(Picture; "Picture")
            // {
            //     SubPageLink = "No." = field("No.");
            //     ApplicationArea = all;
            // }
        }
        addafter("Division Code")
        {
            field("Division Description"; "Division Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item Category Code")
        {
            field("Item Cateogry Description"; "Item Cateogry Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("Retail Product Code")
        {
            field("Retail product Description"; "Retail product Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("PO No.")
        {
            field("1st GRN Date"; rec."1st GRN Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Comp. Price Incl. VAT")
        {
            field("Inclusive of GST"; "Inclusive of GST")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor No.")
        {
            field("Vendor Abbreviation"; "Vendor Abbreviation") { ApplicationArea = all; }
        }
        modify(modifiedBy) { Editable = false; }

        modify("fc location") { Editable = false; }
        modify("PO Created") { Editable = false; }
        modify("Price Inclusive of Tax") { Editable = false; }

        // Add changes to page layout here
    }



    actions
    {
        addafter("Where Used on POS")
        {
            action("Approve for Sale")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Approval;
                trigger OnAction()
                var
                begin
                    if Retailuser.Get(UserId) then
                        if Retailuser."Item Approve" = false then begin
                            Error('You Cannot Authorize to Approve the Item');
                        end;
                    Rec.TestField("Unit Price");
                    Rec.TestField("GST Group Code");
                    if Rec."Unit Cost" < 10 then
                        Error('Please update the actual unit cost!');
                    Rec.TestField("HSN/SAC Code");//Uncomment suggest by sunny 270923
                    Rec.TestField("GST Credit");
                    //Rec.TestField("Price Exclusive of Tax");
                    Rec.TestField("Unit Cost");//Uncomment suggest by sunny 270923
                    rec."Is Approved for Sale" := true;
                    rec.Modify();
                    //CurrPage.Update();
                end;
            }
            action("Check discount date validation")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Approval;
                trigger OnAction()
                var
                    CU: Codeunit 50110;
                begin
                    CU.Discountdatevalidation(Rec);
                end;
            }
            action("Item Ready for Sale")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Approval;

                trigger OnAction()
                var
                    cuFunctions: Codeunit Functions;
                begin
                    // Rec.TestField("Unit Price");
                    // Rec.TestField("GST Group Code");
                    // Rec.TestField("HSN/SAC Code");
                    // Rec.TestField("GST Credit");
                    //Rec.TestField("Price Exclusive of Tax");
                    // Rec.TestField("Unit Cost");
                    // rec."Is Approved for Sale" := true;
                    if rec."Customer No." = '' then Error('Customer no. cannot be blank for this action !');
                    rec."Customer No." := '';
                    rec.Modify();
                    CurrPage.Update(false);
                    cuFunctions.ManualBlockBridgeInventory(Rec) //150223 CITS_RS
                    //CurrPage.Update();
                end;
            }
            /*  action("Approve for Sale")
              {
                  Promoted = true;
                  PromotedIsBig = true;
                  PromotedCategory = Process;
                  Image = Approval;
                  trigger OnAction()
                  var
                  begin
                      Rec.TestField("Unit Price");
                      Rec.TestField("GST Group Code");
                      if Rec."Unit Cost" < 10 then
                          Error('Please update the actual unit cost!');
                      // Rec.TestField("HSN/SAC Code");
                      Rec.TestField("GST Credit");
                      //Rec.TestField("Price Exclusive of Tax");
                      // Rec.TestField("Unit Cost");
                      rec."Is Approved for Sale" := true;
                      rec.Modify();
                      //CurrPage.Update();

                  end;
              }*/
            action("Create Transfer Document")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = TransferOrder;
                trigger OnAction()
                var
                    recTransferHeader: Record "Transfer Header";
                    cuNoSeries: Codeunit 396;
                    recTransferLine: Record "Transfer Line";
                    recStore: Record 99001470;
                    recRetailUser: Record "LSC Retail User";
                begin
                    Rec.TestField(ItemSaleReserved);
                    recRetailUser.Reset();
                    recRetailUser.SetRange(ID, UserId);
                    if recRetailUser.FindFirst() then begin
                        recStore.Get(recRetailUser."Location Code");
                        recTransferHeader.Init();
                        recTransferHeader.validate("No.", cuNoSeries.GetNextNo(recStore."Transfer Order No. Series", Today, false));
                        recTransferHeader.Validate("Transfer-from Code", Rec."fc location");
                        recTransferHeader.Validate("Transfer-to Code", recStore."No.");
                        recTransferHeader.validate("Posting Date", Today);
                        recTransferHeader.validate("Shipment Date", Today);
                        // recTransferHeader.validate(" Date", Today);
                        recTransferHeader.validate("In-Transit Code", 'OWN LOG.');
                        recTransferHeader.Insert();

                        recTransferLine.Init();
                        recTransferLine.validate("Document No.", recTransferHeader."No.");
                        recTransferLine.Validate("Line No.", 10000);
                        recTransferLine.Validate("Transfer-to Code", recTransferHeader."Transfer-to Code");
                        recTransferLine.Validate("Transfer-from Code", recTransferHeader."Transfer-from Code");
                        recTransferLine.Validate("Item No.", Rec."No.");
                        recTransferLine.Validate("Unit of Measure Code", Rec."Base Unit of Measure");
                        recTransferLine.Validate("Gen. Prod. Posting Group", Rec."Gen. Prod. Posting Group");
                        recTransferLine.Validate("Inventory Posting Group", Rec."Inventory Posting Group");
                        recTransferLine.Validate(Quantity, 1);
                        recTransferLine.Validate("Quantity (Base)", 1);
                        recTransferLine.Validate("In-Transit Code", 'OWN LOG.');
                        recTransferLine.Insert();
                    end;
                end;
            }
            action("Update GST/HSN")
            {
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;//CITS_RS 250123
                Image = ServiceTax;
                trigger OnAction()
                var
                    GSTMaster: Record "GST Master";
                    Item: Record Item;
                    recFound: Boolean;
                begin
                    Rec.TestField("LSC Division Code");
                    Rec.TestField("Item Category Code");
                    // Rec.TestField("LSC Retail Product Code");
                    Rec.TestField("Unit Cost");
                    if Item.Get(Rec."No.") then begin
                        if (Item."LSC Retail Product Code" <> '') and (Item."Fabric Type" <> '') then begin
                            GSTMaster.Reset();
                            GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
                            GSTMaster.SetRange(GSTMaster."Subcategory 1", Item."Item Category Code");
                            GSTMaster.SetRange(GSTMaster."Subcategory 2", Item."LSC Retail Product Code");
                            GSTMaster.SetRange(Fabric_Type, Item."Fabric Type");
                            GSTMaster.SetFilter("From Amount", '<=%1', Item."Unit Cost");
                            GSTMaster.SetFilter("To Amount", '>=%1', Item."Unit Cost");
                            if GSTMaster.FindFirst() then begin
                                Item.Validate(Item."GST Group Code", GSTMaster."GST Group");
                                Item.Validate(Item."HSN/SAC Code", GSTMaster."HSN Code");
                                recFound := true;
                            end;
                            Item.Validate("GST Credit", Item."GST Credit"::Availment);
                            Item.Modify();
                        end else
                            if (Item."LSC Retail Product Code" <> '') and (Item."Fabric Type" = '') then begin
                                GSTMaster.Reset();
                                GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
                                GSTMaster.SetRange(GSTMaster."Subcategory 1", Item."Item Category Code");
                                GSTMaster.SetRange(GSTMaster."Subcategory 2", Item."LSC Retail Product Code");
                                GSTMaster.SetRange(Fabric_Type, '');
                                GSTMaster.SetFilter("From Amount", '<=%1', Item."Unit Cost");
                                GSTMaster.SetFilter("To Amount", '>=%1', Item."Unit Cost");
                                if GSTMaster.FindFirst() then begin
                                    Item.Validate(Item."GST Group Code", GSTMaster."GST Group");
                                    Item.Validate(Item."HSN/SAC Code", GSTMaster."HSN Code");
                                    recFound := true;
                                end;
                                Item.Validate("GST Credit", Item."GST Credit"::Availment);
                                Item.Modify();
                            end else
                                if (Item."LSC Retail Product Code" = '') and (Item."Fabric Type" = '') then begin
                                    GSTMaster.Reset();
                                    GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
                                    GSTMaster.SetRange(GSTMaster."Subcategory 1", Item."Item Category Code");
                                    GSTMaster.SetRange(GSTMaster."Subcategory 2", '');
                                    GSTMaster.SetRange(Fabric_Type, '');
                                    GSTMaster.SetFilter("From Amount", '<=%1', Item."Unit Cost");
                                    GSTMaster.SetFilter("To Amount", '>=%1', Item."Unit Cost");
                                    if GSTMaster.FindFirst() then begin
                                        Item.Validate(Item."GST Group Code", GSTMaster."GST Group");
                                        Item.Validate(Item."HSN/SAC Code", GSTMaster."HSN Code");
                                        recFound := true;
                                    end;
                                    Item.Validate("GST Credit", Item."GST Credit"::Availment);
                                    Item.Modify();
                                end else
                                    if (Item."Item Category Code" = '') and
                               (Item."LSC Retail Product Code" = '') and (Item."Fabric Type" = '') then begin
                                        GSTMaster.Reset();
                                        GSTMaster.SetRange(GSTMaster.Category, Item."LSC Division Code");
                                        GSTMaster.SetRange(GSTMaster."Subcategory 1", '');
                                        GSTMaster.SetRange(GSTMaster."Subcategory 2", '');
                                        GSTMaster.SetRange(Fabric_Type, '');
                                        GSTMaster.SetFilter("From Amount", '<=%1', Item."Unit Cost");
                                        GSTMaster.SetFilter("To Amount", '>=%1', Item."Unit Cost");
                                        if GSTMaster.FindFirst() then begin
                                            Item.Validate(Item."GST Group Code", GSTMaster."GST Group");
                                            Item.Validate(Item."HSN/SAC Code", GSTMaster."HSN Code");
                                            recFound := true;
                                        end;
                                        Item.Validate("GST Credit", Item."GST Credit"::Availment);
                                        Item.Modify();
                                    end;
                    end;
                end;
            }
            action(GenerateBarCode)
            {
                ApplicationArea = all;
                Caption = 'Generate Barcode';
                Promoted = true;
                PromotedCategory = Process;
                Image = BarCode;
                trigger OnAction()
                var
                    Item: Record Item;
                    ItemLedgEnrty: Record "Item Ledger Entry";
                begin
                    // Item.Reset();
                    // Item.SetRange("No.", rec."No.");
                    // Item.SetRange("Is Approved for Sale", true);
                    // if Item.FindSet() then begin
                    //     // if ((discountPercentByDesg > 0) And (discountPercentByAza > 0)) then begin
                    //     if (discountPercent <> 0) then //begin
                    //         Error('Generate Promotag')
                    //     //  end
                    //     else
                    //         Report.RunModal(50107, true, false, Item);
                    // end;
                    Item.Reset();
                    Item.SetRange("No.", Rec."No.");
                    Item.SetRange("Is Approved for Sale", true);
                    if Item.FindFirst() then begin
                        ItemLedgEnrty.Reset();
                        ItemLedgEnrty.SetRange("Item No.", Item."No.");
                        if ItemLedgEnrty.FindLast() then begin
                            if ItemLedgEnrty."Remaining Quantity" = 0 then
                                Error('Inventory for this item should not be equal to zero')
                            else begin
                                if (discountPercent <> 0) then //begin
                                    Error('Generate Promotag')
                                //  end
                                else
                                    Report.RunModal(Report::"Generate Barcode", true, false, Item);
                            end;
                        end
                        else
                            Error('Inventory for this item should not be equal to zero');
                    end else
                        Message('You have to approve item for sale first');
                end;
                //  end;

            }
            action("Generate PromoTag")
            {
                ApplicationArea = all;
                Caption = 'Generate PromoTag';
                Promoted = true;
                PromotedCategory = Process;
                Image = BarCode;
                trigger OnAction()
                var
                    Item: Record Item;
                    ItemLedgEnrty: Record "Item Ledger Entry";
                begin
                    // Item.Reset();
                    // Item.SetRange("No.", rec."No.");
                    // Item.SetRange("Is Approved for Sale", true);
                    // if Item.FindSet() then begin
                    //     if ((discountPercentByDesg = 0) And (discountPercentByAza = 0)) then //begin
                    //         Error('Generate Barcode')
                    //     //end
                    //     else
                    //         Report.RunModal(50108, true, false, Item);
                    // end;

                    Item.Reset();
                    Item.SetRange("No.", Rec."No.");
                    Item.SetRange("Is Approved for Sale", true);
                    if Item.FindFirst() then begin
                        ItemLedgEnrty.Reset();
                        ItemLedgEnrty.SetRange("Item No.", Item."No.");
                        if ItemLedgEnrty.FindLast() then begin
                            if ItemLedgEnrty."Remaining Quantity" = 0 then
                                Error('Inventory for this item should not be equal to zero')
                            else
                                if ((discountPercentByDesg = 0) And (discountPercentByAza = 0)) then //begin
                                    Error('Generate Barcode')
                                //end
                                else
                                    Report.RunModal(50134, true, false, Item);
                        end else
                            Error('Inventory for this item should not be equal to zero');
                    end else
                        Message('You have to approve item for sale first');
                    // els
                end;


            }
            action(CheckReservation)
            {
                ApplicationArea = all;
                Caption = 'CheckReservation';
                Promoted = true;
                PromotedCategory = Process;
                Image = AbsenceCalendar;
                trigger OnAction()
                var
                    CU: Codeunit 50110;
                begin
                    CU.Reservation(Rec);
                end;
            }


            // Add changes to page actions here
            action("Create Vendor Payment")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = Payment;
                trigger OnAction()
                var
                    recGenJnlLine: Record 81;
                    recItem: Record 27;
                    recPayablesSetup: Record 312;
                    recVendor: Record 23;
                    recGenLedSet: Record "General Ledger Setup";
                    recSalesReceivable: Record "Sales & Receivables Setup";
                    pgBankPmt: Page "Bank Payment Voucher";
                    CU_NoSeriesMgmt: Codeunit 396;
                    recGenJnlBatch: Record "Gen. Journal Batch";
                begin
                    recVendor.get(Rec."Vendor No.");
                    if (Rec."Item Booking Date" <> 0D) and (Rec."Item Delivery Date" = 0D) then begin
                        recGenJnlLine.Init();
                        recGenJnlLine.validate("Journal Template Name", 'BANK PAYM');
                        recGenJnlLine.validate("Journal Batch Name", 'DEFAULT');
                        recGenJnlLine."Line No." := 10000;
                        recGenJnlLine.validate("Document Type", recGenJnlLine."Document Type"::Payment);
                        recGenJnlBatch.Get('BANK PAYM', 'DEFAULT');
                        recGenJnlLine.Validate("Document No.", CU_NoSeriesMgmt.GetNextNo(recGenJnlBatch."No. Series", Today, true));
                        recGenJnlLine.validate("Account Type", recGenJnlLine."Account Type"::Vendor);
                        recGenJnlLine.validate("Account No.", Rec."Vendor No.");
                        recGenJnlLine.validate("Document Date", Today);
                        recGenJnlLine.validate("Posting Date", Today);
                        recGenJnlLine.BarCode := Rec."No.";
                        recGenJnlLine.validate("Bal. Account Type", recGenJnlBatch."Bal. Account Type");//;  recGenJnlLine."Bal. Account Type"::Vendor);
                        recGenJnlLine.validate(Amount, Rec."Vendor Amt. to Pay");
                        recGenJnlLine.validate("Amount (LCY)", Rec."Vendor Amt. to Pay");
                        recGenJnlLine.Description := StrSubstNo('Vendor %1 payment for Item %2', Rec."Vendor No.", Rec."No.");
                        recGenJnlLine."Location Code" := Rec."Location Filter";
                        recGenJnlLine."GST Group Code" := Rec."GST Group Code";
                        recGenJnlLine."Vendor GST Reg. No." := recVendor."GST Registration No.";
                        recGenJnlLine.validate("GST Group Type", recGenJnlLine."GST Group Type"::Goods);
                        recGenJnlLine.Comment := StrSubstNo('Vendor %1 payment for Item %2', Rec."Vendor No.", Rec."No.");
                        if recGenJnlLine.Insert() then
                            Message('Vendor Payment created successfully');
                        // recGenJnlLine.Amount := Rec.pay
                    end;

                end;
            }
        }

        addafter("&Bin Contents")
        {


            /*  action(NewAction)
              {
                  trigger OnAction()
                  var
                      myInt: Integer;
                  begin
                      CurrPage.RetilCard_ItemPart.Page.SetActiveImage(Rec.RecordId);
                  end;
              }*/
        }
    }

    trigger OnAfterGetCurrRecord()
    //trigger OnValidate()
    var
        myInt: Integer;
        RecPurcRctHead: Record "Purch. Rcpt. Line";
        taxablevalue: Decimal;
    begin

        if Rec."Customer No." <> '' then
            glCustEditable := false
        else
            glCustEditable := true;


        // if retailproductcode.Get(Rec."LSC Retail Product Code") then begin
        RecPurcRctHead.Reset();
        RecPurcRctHead.SetRange(RecPurcRctHead."No.", Rec."No.");
        //RecPurcRctHead.SetRange(RecPurcRctHead.Code, Rec."LSC Retail Product Code");
        if RecPurcRctHead.FindFirst() then begin
            "GRN No." := RecPurcRctHead."Document No.";
            "1st GRN Date" := RecPurcRctHead."Posting Date";
            //Message('%1', "Retail product Description");
        end;
    end;

    trigger OnAfterGetRecord()
    //trigger OnValidate()
    var
        myInt: Integer;
        RecPurcRctHead: Record "Purch. Rcpt. Line";
        taxablevalue: Decimal;
    begin
        // if retailproductcode.Get(Rec."LSC Retail Product Code") then begin
        RecPurcRctHead.Reset();
        RecPurcRctHead.SetRange(RecPurcRctHead."No.", Rec."No.");
        //RecPurcRctHead.SetRange(RecPurcRctHead.Code, Rec."LSC Retail Product Code");
        if RecPurcRctHead.FindFirst() then begin
            "GRN No." := RecPurcRctHead."Document No.";
            "1st GRN Date" := RecPurcRctHead."Posting Date";
            //Message('%1', "Retail product Description");
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        /*  if Rec."Is Approved for Sale" = true then
             Rec."Is Approved for Sale" := false;
         Rec.Modify();  */
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
        itemunit: Record "Item Unit of Measure";
        salesunit: Code[10];
    begin
        if itemunit.Get(Rec."Sales Unit of Measure") then begin
            "Sales Unit of Measure" := itemunit.Code;

        end
    end;




    var
        myInt: Integer;
        glCustEditable: Boolean;
        Retailuser: Record "LSC Retail User";

}