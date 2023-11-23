tableextension 50103 AzaItem_Attributes extends Item
{
    fields
    {
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            var
                HSN_SAC: Record "HSN SSC Price";
                SalPrice: Record "Sales Price";
                CustomerPriceGrp: Record "Customer Price Group";
                Gstgroup: Record "GST Group";
                GSTMaster1: Record "GST Master";
            begin
                if Rec."HSN/SAC Code" <> '' then begin
                    HSN_SAC.Reset();
                    HSN_SAC.SetRange("HSN Code", Rec."HSN/SAC Code");
                    if HSN_SAC.FindSet() then begin
                        repeat
                            if ((rec."Unit Price" >= HSN_SAC."Range From") AND (rec."Unit Price" <= HSN_SAC."Range To")) then begin
                                Rec.Validate("GST Group Code", HSN_SAC."GST Group Code");
                                Rec.Validate("HSN/SAC Code", HSN_SAC."HSN Code");
                                rec.Modify(true);
                            end;
                        until HSN_SAC.Next() = 0;
                    end;
                end;

                SalPrice.Reset();
                SalPrice.SetRange("Item No.", "No.");
                SalPrice.SetRange("Sales Type", SalPrice."Sales Type"::"Customer Price Group");
                //SalPrice.SetRange();
                if Not SalPrice.FindFirst() then begin
                    SalPrice.Init();
                    SalPrice."Sales Type" := SalPrice."Sales Type"::"Customer Price Group";
                    SalPrice.Validate("Sales Code", 'All');
                    SalPrice.Validate("Item No.", Rec."No.");
                    SalPrice.Validate("Unit Price", Rec."Unit Price");
                    SalPrice.Insert();
                end else begin
                    SalPrice.Validate("Unit Price", Rec."Unit Price");
                    SalPrice.Modify();
                end;

                Gstgroup.Reset();
                Gstgroup.SetRange(Code, Rec."GST Group Code");
                if Gstgroup.FindFirst() then begin
                    Rec."Taxable Value" := ("Unit Price" * 100) / (100 + Gstgroup."GST %");
                    GSTMaster1.Reset();
                    GSTMaster1.SetRange(GSTMaster1.Category, Rec."LSC Division Code");
                    GSTMaster1.SetRange(GSTMaster1."Subcategory 1", Rec."Item Category Code");
                    GSTMaster1.SetRange(GSTMaster1."Subcategory 2", Rec."LSC Retail Product Code");
                    GSTMaster1.SetRange(Fabric_Type, Rec."Fabric Type");
                    GSTMaster1.SetFilter("From Amount", '<=%1', Rec."Taxable Value");
                    GSTMaster1.SetFilter("To Amount", '>=%1', Rec."Taxable Value");
                    if GSTMaster1.FindFirst() then begin
                        Rec.Validate("GST Group Code", GSTMaster1."GST Group");
                        Rec.Validate("HSN/SAC Code", GSTMaster1."HSN Code");
                    end;
                    Rec.Modify();
                end;
                if (Rec."Is Approved for Sale" = true) And (Rec."Unit Price" <> xRec."Unit Price") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;

        }
        modify("Unit Cost")
        {
            trigger OnAfterValidate()
            var
                GstGroup: Record "GST Group";
                Gstrate1: Decimal;
            begin
                "Vendor Amt. to Pay" := Rec."Unit Cost";
                // Modify();

                GstGroup.Reset();
                GstGroup.SetRange(Code, Rec."GST Group Code");
                if GstGroup.FindFirst() then
                    Gstrate1 := GstGroup."GST %";
                Rec."Inclusive of GST" := Round(Rec."Unit Cost" + ((Rec."Unit Cost" * Gstrate1) / 100), 0.01);
                // Rec.Modify();

                if (Rec."Is Approved for Sale" = true) And (Rec."Unit Cost" <> xRec."Unit Cost") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        modify("GST Group Code")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec."GST Group Code" <> xRec."GST Group Code") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        modify("GST Credit")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec."GST Credit" <> xRec."GST Credit") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        modify("HSN/SAC Code")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec."HSN/SAC Code" <> xRec."HSN/SAC Code") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                Recvendor: Record Vendor;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec."Vendor No." <> xRec."Vendor No.") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
                if Recvendor.Get(Rec."Vendor No.") then begin
                    "Vendor Abbreviation" := Recvendor."Designer Abbreviation";
                    "Vendor Name" := Recvendor.Name;
                end;
            end;
        }
        modify("LSCIN Price Inclusive of Tax")
        {
            //editable = false;

            trigger OnAfterValidate()
            var
                SalPrice: Record "Sales Price";
            begin
                SalPrice.Reset();
                SalPrice.SetRange("Item No.", "No.");
                SalPrice.SetRange("Sales Type", SalPrice."Sales Type"::"Customer Price Group");
                if SalPrice.FindFirst() then begin
                    if "LSCIN Price Inclusive of Tax" then
                        SalPrice.Validate("Price Inclusive of Tax", true)
                    else
                        SalPrice.Validate("Price Inclusive of Tax", false);
                    SalPrice.Modify();
                end;//13-2-23
            end;

            trigger OnBeforeValidate()
            begin
                Error('You are not permitted to edit this field');
            end;  //on13-2-23
        }

        field(50000; tagCode; Code[50]) { DataClassification = ToBeClassified; }
        field(50001; azaCode; Code[50]) { DataClassification = ToBeClassified; }
        field(50002; subSubCategoryCode; Code[10]) { DataClassification = ToBeClassified; }
        field(50003; designerID; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec.designerID <> xRec.designerID) then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        field(50004; componentsNo; Integer) { DataClassification = ToBeClassified; }
        field(50005; productThumbImg; Code[150]) { DataClassification = ToBeClassified; }
        field(50006; addedBy; Code[70]) { DataClassification = ToBeClassified; }

        field(50007; dateAdded; DateTime) { DataClassification = ToBeClassified; }
        field(50008; status; Boolean) { DataClassification = ToBeClassified; }
        field(50009; modifiedBy; Code[20]) { DataClassification = ToBeClassified; }
        field(50061; "Modified Date"; DateTime) { DataClassification = ToBeClassified; }
        field(50010; merchandiserName; Code[50]) { DataClassification = ToBeClassified; }
        field(50011; image1; Text[250]) { DataClassification = ToBeClassified; Caption = 'Image1'; }

        field(50012; image2; Text[250]) { DataClassification = ToBeClassified; }

        field(50013; image3; Text[250]) { DataClassification = ToBeClassified; }

        field(50014; image4; Text[250]) { DataClassification = ToBeClassified; }

        field(50015; image5; Text[250]) { DataClassification = ToBeClassified; }

        field(50016; image6; Text[250]) { DataClassification = ToBeClassified; }

        field(50017; image7; Text[250]) { DataClassification = ToBeClassified; }

        field(50018; image8; Text[250]) { DataClassification = ToBeClassified; }

        field(50019; image9; Text[250]) { DataClassification = ToBeClassified; }

        field(50020; image10; Text[250]) { DataClassification = ToBeClassified; }
        field(50021; sizeName; Code[100]) { DataClassification = ToBeClassified; }
        field(50022; colorName; Code[100]) { DataClassification = ToBeClassified; }

        field(50023; discountPercent; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                UnitP: Decimal;
                Salprice: Record "Sales Price";
            begin
                if discountPercent > 0 then begin
                    UnitP := OrgUnitPrice - Round((OrgUnitPrice * discountPercent) / 100, 1, '=');
                    UnitP := UnitP - "Disc Amt";
                    Rec.Validate("Unit Price", UnitP);
                    Salprice.Reset();
                    Salprice.SetRange("Item No.", Rec."No.");
                    if Salprice.FindFirst() then begin
                        Salprice.Validate("Unit Price", UnitP);
                        Salprice.Modify();
                    end;
                end else begin
                    UnitP := Round(((Rec."Unit Price" + "Disc Amt") * 100) / (100 - xRec.discountPercent), 1, '=');
                    UnitP := UnitP - "Disc Amt";
                    Rec.Validate("Unit Price", UnitP);
                    Salprice.Reset();
                    Salprice.SetRange("Item No.", Rec."No.");
                    if Salprice.FindFirst() then begin
                        Salprice.Validate("Unit Price", UnitP);
                        Salprice.Modify();
                    end;
                end;
            end;
        }
        field(50024; discountPercentByDesg; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                AmtToPay: Decimal;
                OrgAmtToPay: Decimal;

            begin
                if Rec."Disc Amt" <> 0 then
                    Error('Disc Amt must have to be zero');
                // Rec.TestField("Disc Amt", 0);
                DiscountAmountbyDesg := 0;
                "Disc Amt" := 0;
                // if Rec.discountPercent > 0 then begin
                //     if Rec."Unit Price" > 0 then
                //         OrgUnitPrice := Round((Rec."Unit Price" / (100 - Rec.discountPercent)) * 100, 1, '=');
                // end else
                //     OrgUnitPrice := Rec."Unit Price";
                if xRec.discountPercentByDesg > 0 then begin
                    if Rec."Unit Cost" > 0 then
                        OrgUnitPrice := Round((Rec."Unit Cost" / (100 - xRec.discountPercentByDesg)) * 100, 1, '=');
                end else
                    OrgUnitPrice := Rec."Unit Cost";

                //Rec.Validate(discountPercent, discountPercentByDesg + discountPercentByAza);
                Rec.Validate("Unit Cost", (OrgUnitPrice - Round((OrgUnitPrice * discountPercentByDesg) / 100, 1, '=')));


                //vendor amt to pay>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                if xRec.discountPercentByDesg = 0 then
                    OrgAmtToPay := Rec."Vendor Amt. to Pay"
                else begin
                    if Rec."Vendor Amt. to Pay" > 0 then begin
                        OrgAmtToPay := (Rec."Vendor Amt. to Pay" * 100) / (100 - xRec.discountPercentByDesg);
                        //OrgAmtToPay := Rec."Vendor Amt. to Pay" + xRec."Disc Amt";
                    end;
                end;

                if discountPercentByDesg > 0 then begin
                    if OrgAmtToPay > 0 then begin
                        AmtToPay := OrgAmtToPay - Round((OrgAmtToPay * discountPercentByDesg) / 100, 1, '=');
                        rec.validate("Vendor Amt. to Pay", AmtToPay);
                        //Rec."Unit Cost" := AmtToPay;
                    end;
                end else begin
                    Rec.validate("Vendor Amt. to Pay", OrgAmtToPay);
                end;
                //vendor amt to pay<<

                if discountPercentByDesg > 0 then begin
                    if OrgUnitPrice > 0 then begin
                        DiscountAmountbyDesg := (OrgUnitPrice * discountPercentByDesg) / 100;
                        //"Disc Amt" := (OrgUnitPrice * discountPercentByDesg) / 100;
                    end;
                end;
            end;

        }


        field(50025; discountPercentByAza; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UnitP: Decimal;
                UnitPV: Decimal;
                SalPriceUP: Decimal;

            // SalesPrice: Record "Sales Price";
            begin
                discountAmountbyAza := 0;
                if Rec.discountPercent > 0 then begin
                    if Rec."Unit Price" > 0 then
                        OrgUnitPrice := Round(((Rec."Unit Price" + "Disc Amt") / (100 - Rec.discountPercent)) * 100, 1, '=');
                end else
                    OrgUnitPrice := Rec."Unit Price" + "Disc Amt";
                Rec.Validate(discountPercent, discountPercentByDesg + discountPercentByAza);

                if discountPercentByAza > 0 then begin
                    if OrgUnitPrice > 0 then
                        discountAmountbyAza := (OrgUnitPrice * discountPercentByAza) / 100;
                end;
                Rec.Modify(true);
            end;
        }

        field(50026; filterPrice; Decimal) { DataClassification = ToBeClassified; }

        field(50027; "PO Created"; Boolean) { DataClassification = ToBeClassified; }
        field(50028; "Neckline Type"; Code[250]) { DataClassification = ToBeClassified; Caption = 'Necline Type'; }
        field(50029; "Type of Work"; Code[250]) { DataClassification = ToBeClassified; Caption = 'Type of Work'; }
        field(50030; "Sleeve Length"; Code[250]) { DataClassification = ToBeClassified; Caption = 'Sleeve Length'; }
        field(50031; "Closure Type"; Code[250]) { DataClassification = ToBeClassified; Caption = 'Closure Type'; }
        field(50032; "Fabric Type"; Code[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fabric Type';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec."Fabric Type" <> xRec."Fabric Type") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        field(50033; "Type of Pattern"; Code[250]) { DataClassification = ToBeClassified; Caption = 'Type of Pattern'; }
        field(50034; "Product Title"; Code[150]) { DataClassification = ToBeClassified; Caption = 'Product Title'; }
        field(50035; "Sleeve Type"; Code[250]) { DataClassification = ToBeClassified; Caption = 'Sleeve Type'; }

        field(50060; "Stylist Note"; Code[150]) { DataClassification = ToBeClassified; }
        field(50036; "Designer Code"; Code[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Designer Code';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec."Designer Code" <> xRec."Designer Code") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        // field(50037; CustomImage2; Blob) { DataClassification = ToBeClassified; Subtype = Bitmap; }
        // Add changes to table fields here
        field(50038; "PO type"; Option)
        {
            OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright","MTO";
            OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec."PO type" <> xRec."PO type") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        field(50039; ItemSaleReserved; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RetailSetup: Record "LSC Retail Setup";
                RetailUser: Record "LSC Retail User";
                RecStore: Record "LSC Store";
                SMTPMailSetup: Record "SMTP Mail Setup";
                whseEntr: Record "Warehouse Entry";
                SMTP: Codeunit "SMTP Mail";
                Store: Record "LSC Store";
                Store2: Record "LSC Store";
                VarSender: Text[80];
                cuFunctions: Codeunit Functions;
                VarRecipient: List of [Text];
                VarRecipient2: List of [Text];
                BUserId: Code[60];
                BDateT: DateTime;
                VarStoreNo: Code[20];
                Item: Record Item;
                ItemNo: Code[30];
                ItemName: Code[100];
                cdUserLoc: Code[10];
                recLocation: Record 14;
                VarStoreID: code[30];
                StoreDescription: Code[30];
                ItemDescription: Text[100];
                blockDate: Text[10];
                vend: Record Vendor;
                DesignerName: Text[100];
            begin
                RetailSetup.Get();
                if RetailSetup."Allow Manual Blocking" = true then begin
                    if ItemSaleReserved = true then begin
                        //CITS_RS 020323
                        cdUserLoc := cuFunctions.GetRetailUserLoc();
                        // if cdUserLoc = Rec."fc location" then  // allowing the blocking of inventory from same location as user's CITS_RS 310523
                        //     Error('You cannot block inventory for your own location!');
                        //CITS_RS 020323
                        if "Customer No." = '' then Error('Customer No. should not be blank');
                        Rec.CalcFields(Inventory);
                        if Rec.Inventory <= 0 then Error('Inventory should be greater than zero for this action!');
                        if Remarks = '' then Error('Remarks should not be blank');
                        if "Blocked By User ID" = '' then begin
                            Validate("Blocked By User ID", UserId);
                            Validate("Blocked DateTime", CurrentDateTime);
                            BDateT := CurrentDateTime;
                            ItemNo := Rec."No.";
                            if Item.Get(Rec."No.") then begin
                                ItemDescription := Item.Description;
                                if vend.Get(Item."Vendor No.") then
                                    DesignerName := vend.Name;
                            end;
                            RetailUser.Reset();
                            RetailUser.SetRange(ID, UserId);
                            if RetailUser.FindFirst() then begin
                                Validate("Store No.", RetailUser."Store No.");
                                recLocation.Get(RetailUser."Store No.");//CITS_RS 130223
                                VarStoreNo := RetailUser."Store No.";//CITS_RS 210223
                                VarStoreID := format(recLocation."fc_location ID");//CITS_RS 130223
                                // VarStoreNo := RetailUser."Store No.";
                                if RetailUser.Name <> '' then//CITS_RS 200223
                                    BUserId := RetailUser.Name
                                else
                                    BUserId := RetailUser.ID;
                                Modify(true);
                                if not cuFunctions.ManualBlockBridgeInventory(Rec) then//call Store Reduce API on Manual Blocking 130223 CITS_RS
                                    Message(GetLastErrorText());
                            end;
                            //mail>>>>>>
                            if VarStoreID <> Rec."fc location" then begin
                                if Store.Get(VarStoreNo) then
                                    StoreDescription := Store.Name;
                                SMTPMailSetup.Get();
                                VarSender := SMTPMailSetup."User ID";

                                if Store2.Get(Rec."fc location") then
                                    VarRecipient.Add(Store2."Email id");
                                VarRecipient2.Add(Store2.Email2);

                                blockDate := CopyStr(Format(BDateT), 1, 8);
                                ///>>>>>>
                                SMTPMailSetup.GET;
                                SMTP.CreateMessage('CCIT', VarSender, VarRecipient, 'Item Blocking Notification-AZA Admin', '');
                                //SMTP.CreateMessage('CCIT','', VarRecipient, 'Notice for Item Booking','');//commented CITS_RS
                                // SMTP.GetCC(VarRecipient2);
                                // VarRecipient2.Add(Store2.Email2);
                                SMTP.AddCC(VarRecipient2);
                                SMTP.AppendBody('Dear Sir/Madam');
                                //SMTP.AppendBody('<br><Br>');
                                SMTP.AppendBody('<br><Br>');
                                SMTP.AppendBody('This Item ' + Format(ItemNo) + ' (' + Format(ItemDescription) + ')' + ', (Designer Name-' + DesignerName + ')' + ' is blocked by User -' + BUserId);// + ', from store-' + VarStoreNo + ', at' + Format(BDateT));
                                SMTP.AppendBody('<br>');
                                SMTP.AppendBody('From Store - ' + StoreDescription + ' on ' + blockDate);
                                SMTP.AppendBody('<br><Br>');
                                //SMTP.AppendBody('<br><Br>');
                                SMTP.AppendBody('AZA Admin');
                                // SMTP.AppendBody('<br><Br>');
                                // SMTP.AppendBody('we will be glad to assist you!');
                                // SMTP.AppendBody('<br><Br>');
                                //SMTP.AppendBody('<b> Thanks & Regards </b>');
                                //SMTP.AppendBody('<br><Br>');
                                if SMTP.Send then
                                    MESSAGE('Email Sent Successfully');
                            END;

                            //  end else begin
                            //RecStore.Get(Rec."Store No.");
                            if ("Blocked By User ID" = UserId) then begin
                                Validate("Blocked By User ID", UserId);
                                Validate("Blocked DateTime", CurrentDateTime);
                                RetailUser.Reset();
                                RetailUser.SetRange(ID, UserId);
                                if RetailUser.FindFirst() then
                                    Validate("Store No.", RetailUser."Store No.");
                                Modify(true);
                            end else
                                Error('You do not have access to perform this task');
                        end;
                    end else begin
                        RetailUser.Get(UserId);
                        if ("Blocked By User ID" = UserId) AND ("Store No." = RetailUser."Store No.") then begin
                            Clear("Blocked By User ID");
                            Clear("Blocked DateTime");
                            Clear(Remarks);
                            Clear("Store No.");
                            Modify(true);
                            // if not cuFunctions.ManualUnBlockBridgeInventory(Rec) then //CITS_RS 130223
                            //Message(GetLastErrorText());
                        end else begin
                            // RetailUser.Reset();
                            // RetailUser.SetRange(ID, UserId);
                            // if RetailUser.FindFirst() then begin
                            if RetailUser."Authorize Item Sales Reserve" = true then begin
                                Clear("Blocked By User ID");
                                Clear("Blocked DateTime");
                                Clear(Remarks);
                                Clear("Store No.");
                                Modify(true);
                                // if not cuFunctions.ManualUnBlockBridgeInventory(Rec) then//CITS_RS 130223
                                //Message(GetLastErrorText());
                            end else
                                Error('You do not have access to perform this task');
                            // end;
                        end;
                    end;
                end else
                    Error('Allow Manual Inventory is disabled');
            end;
        }
        field(50040; "Item Booking Date"; Date) { DataClassification = ToBeClassified; }
        field(50041; "Is Approved for Sale"; Boolean) { DataClassification = ToBeClassified; }

        field(50042; "Item Delivery Date"; Date) { DataClassification = ToBeClassified; }
        field(50043; "Payment Due Date"; Date) { DataClassification = ToBeClassified; }
        field(50044; Picture2; MediaSet)
        {
            Caption = 'Picture 2';
        }

        field(50045; "Vendor Amt. to Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                // if "Vendor Amt. to Pay" > 0 then begin
                //     if "Vendor Amt. to Pay" > DiscountAmountbyDesg then
                //         "Vendor Amt. to Pay" := "Vendor Amt. to Pay" - DiscountAmountbyDesg;
                // end;
                // if "Vendor Amt. to Pay" > 0 then begin
                //     Rec."Unit Cost" := "Vendor Amt. to Pay";
                // end;//240823by ketan
            end;
        }
        field(50047; "Customer No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
            begin
                if Rec."Customer No." <> '' then begin
                    if Rec.ItemSaleReserved = true then
                        Error('You can not change Customer No. when item is reserved');
                end;
            end;

        }
        field(50048; "Is Advance"; Boolean) { DataClassification = ToBeClassified; }
        field(50049; "Cust. Phone No."; Code[15]) { DataClassification = ToBeClassified; }
        field(50050; DiscountAmountbyDesg; Decimal)
        {
            DataClassification = ToBeClassified;
            //Editable = false;

            trigger OnValidate()
            var
                AmtToPay: Decimal;
                OrgAmtToPay: Decimal;
            begin
                discountPercentByDesg := 0;
                if Rec.discountPercent > 0 then begin
                    if Rec."Unit Price" > 0 then
                        OrgUnitPrice := Round((Rec."Unit Price" / (100 - Rec.discountPercent)) * 100, 1, '=');
                end else
                    OrgUnitPrice := Rec."Unit Price";

                if DiscountAmountbyDesg > 0 then begin
                    if OrgUnitPrice > 0 then
                        Rec.discountPercentByDesg := (DiscountAmountbyDesg / OrgUnitPrice) * 100;
                end else begin
                    Rec.discountPercentByDesg := 0;
                end;
                //vendor amt to pay>>
                if xRec.discountPercentByDesg = 0 then
                    OrgAmtToPay := Rec."Vendor Amt. to Pay"
                else begin
                    if Rec."Vendor Amt. to Pay" > 0 then begin
                        OrgAmtToPay := (Rec."Vendor Amt. to Pay" * 100) / (100 - xRec.discountPercentByDesg);
                    end;
                end;

                if discountPercentByDesg > 0 then begin
                    if OrgAmtToPay > 0 then begin
                        AmtToPay := OrgAmtToPay - Round((OrgAmtToPay * discountPercentByDesg) / 100, 1, '=');
                        rec."Vendor Amt. to Pay" := AmtToPay;
                    end;
                end else begin
                    Rec."Vendor Amt. to Pay" := OrgAmtToPay;
                end;
                //vendor amt to pay<<

                Rec.Validate(discountPercent, discountPercentByAza + discountPercentByDesg);


            end;
        }
        field(50051; "First Payment Received Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "fc location"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(50053; discountAmountbyAza; Decimal)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger OnValidate()
            var
                AmtToPay: Decimal;
                OrgAmtToPay: Decimal;
            begin
                discountPercentByAza := 0;
                if Rec.discountPercent > 0 then begin
                    if Rec."Unit Price" > 0 then
                        OrgUnitPrice := Round(((Rec."Unit Price" + "Disc Amt") / (100 - Rec.discountPercent)) * 100, 1, '=');
                end else
                    OrgUnitPrice := Rec."Unit Price" + "Disc Amt";

                if discountAmountbyAza > 0 then begin
                    if OrgUnitPrice > 0 then
                        discountPercentByAza := (discountAmountbyAza / OrgUnitPrice) * 100;
                end else begin
                    discountPercentByAza := 0;
                end;


                Rec.Validate(discountPercent, discountPercentByAza + discountPercentByDesg);


            end;
        }
        field(50058; "Disc Amt"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                AmtToPay: Decimal;
                OrgAmtToPay: Decimal;
            begin
                if discountPercentByDesg <> 0 then
                    Error('Discount percent by desg must have to be zero');

                // if xRec."Disc Amt" <> 0 then
                //     OrgUnitPrice := Rec."Unit Price" + xRec."Disc Amt"
                // else
                //     OrgUnitPrice := Rec."Unit Price";
                if xRec."Disc Amt" <> 0 then
                    OrgUnitPrice := Rec."Unit Cost" + xRec."Disc Amt"
                else
                    OrgUnitPrice := Rec."Unit Cost";

                // if Rec."Disc Amt" > 0 then begin
                //     Rec.Validate("Unit Price", (OrgUnitPrice - Rec."Disc Amt"));
                // end else begin
                //     Rec.Validate("Unit Price", (OrgUnitPrice));
                // end;//240823by ketan
                if Rec."Disc Amt" > 0 then begin
                    Rec.Validate("Unit Cost", (OrgUnitPrice - Rec."Disc Amt"));
                end else begin
                    Rec.Validate("Unit Cost", (OrgUnitPrice));
                end;


                //vendor amt to pay>>
                if Rec."Disc Amt" > 0 then begin
                    Rec.Validate("Vendor Amt. to Pay", Rec."Vendor Amt. to Pay" + xRec."Disc Amt" - Rec."Disc Amt");
                end else begin
                    Rec.Validate("Vendor Amt. to Pay", Rec."Vendor Amt. to Pay" + xRec."Disc Amt");
                end;
                //vendor amt to pay<<
            end;

        }
        //SK++
        field(50054; "Blocked By User ID"; Code[250])
        {

        }
        field(50055; "Blocked DateTime"; DateTime)
        {

        }
        field(50056; Remarks; Text[250])
        {

        }
        field(50057; "Store No."; Code[20])
        {

        }
        field(50059; Old_aza_code; Code[30])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec.Old_aza_code <> xRec.Old_aza_code) then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        field(50062; "RTV created"; Boolean) { DataClassification = ToBeClassified; }

        field(50063; "PO No."; Code[30]) { DataClassification = ToBeClassified; }
        field(50064; "Tag Printed"; Boolean) { DataClassification = ToBeClassified; Editable = false; }
        field(50065; "Tag Print Count"; Integer) { DataClassification = ToBeClassified; Editable = false; }
        field(50066; "Color ID"; Code[20]) { DataClassification = ToBeClassified; }
        field(50067; "Size ID"; Code[20]) { DataClassification = ToBeClassified; }
        field(50068; "MRP"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec."MRP" <> xRec."MRP") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        field(50069; "Customer Order ID"; Code[50]) { DataClassification = ToBeClassified; }
        field(50070; "Taxable Value"; Decimal) { DataClassification = ToBeClassified; }
        field(50071; "Division Description"; Text[250])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;//Naveen
            CalcFormula = lookup("LSC Division".Description where(Code = field("LSC Division Code")));
        }
        field(50072; "Item Cateogry Description"; Text[250])
        {
            // DataClassification = ToBeClassified;
            FieldClass = FlowField;//Naveen
            CalcFormula = lookup("Item Category".Description where(Code = field("Item Category Code")));

        }
        field(50073; "Retail product Description"; Text[250])
        {
            // DataClassification = ToBeClassified;
            FieldClass = FlowField;//Naveen
            CalcFormula = lookup("LSC Retail Product Group".Description where(Code = field("LSC Retail Product Code")));
        }
        field(50074; "1st GRN Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50075; "Inclusive of GST"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                GstGroup: Record "GST Group";
                Gstrate1: Decimal;
            begin
                GstGroup.Reset();
                GstGroup.SetRange(Code, Rec."GST Group Code");
                if GstGroup.FindFirst() then begin
                    Gstrate1 := GstGroup."GST %";
                    Rec."Unit Cost" := Round(Rec."Inclusive of GST" - ((Rec."Inclusive of GST" * Gstrate1) / (100 + gstrate1)), 0.01);
                    Rec.Modify();
                end;

                if (Rec."Is Approved for Sale" = true) And (Rec."Inclusive of GST" <> xRec."Inclusive of GST") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;

            end;
        }
        field(50076; "Discount till date valid"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50077; "Discription 3"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50078; "Discription 4"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50079; "product_desc"; Text[1000])
        {
            //DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = lookup(Aza_Item.product_desc where(bar_code = field("No.")));
            // trigger OnValidate()
            // var
            //     lscdivision: Record Aza_Item;
            // begin
            //     if lscdivision.Get(Rec."No.") then begin
            //         product_desc := lscdivision.product_desc;

            //     end;
            // end;
        }
        field(50080; "GRN No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(50081; "Component description"; Text[250]) { DataClassification = ToBeClassified; }
        field(50082; "sale associate"; Code[30]) { DataClassification = ToBeClassified; }
        field(50083; Padded; Boolean) { DataClassification = ToBeClassified; }
        field(50084; "Attached can can"; Boolean) { DataClassification = ToBeClassified; }
        field(50085; "Query Confirmed By"; Text[100]) { DataClassification = ToBeClassified; }
        field(50086; "Collection Type"; text[50]) { DataClassification = ToBeClassified; }
        field(50087; "Product Classication"; text[50]) { DataClassification = ToBeClassified; }
        field(50088; "extra charges Designer"; Decimal) { DataClassification = ToBeClassified; }
        field(50089; "extra charges aza"; Decimal) { DataClassification = ToBeClassified; }
        field(50090; "Vendor Payment Date"; Date) { DataClassification = ToBeClassified; }
        field(50091; "Order Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(50092; "measurements"; Text[1000]) { DataClassification = ToBeClassified; }
        field(50093; "ref_barcode"; Code[50]) { DataClassification = ToBeClassified; }
        field(50094; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));

        }
        field(50095; "Original AZA Code"; Code[30]) { DataClassification = ToBeClassified; }

        modify("LSC Division Code")
        {
            trigger OnAfterValidate()
            var
                lscdivision: Record "LSC Division";
            begin
                if lscdivision.Get(Rec."LSC Division Code") then begin
                    "Division Description" := lscdivision.Description;
                    if (Rec."Is Approved for Sale" = true) And (Rec."LSC Division Code" <> xRec."LSC Division Code") then begin
                        Rec."Is Approved for Sale" := false;
                        Rec.Modify();
                    end;
                end;
            end;
        }
        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                Itemcat: Record "Item Category";
                taxablevalue: Decimal;
            begin
                if Itemcat.Get(Rec."Item Category Code") then begin
                    "Item Cateogry Description" := Itemcat.Description;
                end;
                if (Rec."Is Approved for Sale" = true) And (Rec."Item Category Code" <> xRec."Item Category Code") then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }

        modify("LSC Retail Product Code")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                retailproductcode: Record "LSC Retail Product Group";
                taxablevalue: Decimal;
            begin
                // if retailproductcode.Get(Rec."LSC Retail Product Code") then begin
                retailproductcode.Reset();
                retailproductcode.SetRange(retailproductcode."Item Category Code", Rec."Item Category Code");
                retailproductcode.SetRange(retailproductcode.Code, Rec."LSC Retail Product Code");
                if retailproductcode.FindLast() then begin
                    "Retail product Description" := retailproductcode.Description;
                    // Rec.Modify(true);
                    //Message('%1', "Retail product Description");
                    if (Rec."Is Approved for Sale" = true) And (Rec."LSC Retail Product Code" <> xRec."LSC Retail Product Code") then begin
                        Rec."Is Approved for Sale" := false;
                        Rec.Modify();
                    end;
                end;
            end;
        }
        field(50100; "Vendor Abbreviation"; Text[10])
        {
            Caption = 'Vendor Abbreviation';
            DataClassification = ToBeClassified;
        }
        field(50101; "Vendor Payment"; Code[25])
        {
            DataClassification = ToBeClassified;
        }


        // modify("Sales Unit of Measure")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         myInt: Integer;
        //         itemunit: Record "Item Unit of Measure";
        //         salesunit: Code[10];
        //     begin
        //         if itemunit.Get(Rec."Sales Unit of Measure") then begin
        //             "Sales Unit of Measure" := itemunit.Code;

        //         end;

        //     end;
        // }
        modify(Description)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Is Approved for Sale" = true) And (Rec.Description <> xRec.Description) then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;
            end;
        }
        modify(Type)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;

            begin
                if (Rec."Is Approved for Sale" = true) And (Rec.Type <> xRec.Type) then begin
                    Rec."Is Approved for Sale" := false;
                    Rec.Modify();
                end;

            end;
        }

    }
    fieldgroups
    {
        addlast(DropDown; Old_aza_code)
        {

        }
    }

    trigger OnAfterInsert()
    var
        myInt: Integer;
        itemunit: Record "Item Unit of Measure";
        salesunit: Code[10];
    begin
        if itemunit.Get(Rec."Sales Unit of Measure") then begin
            "Sales Unit of Measure" := itemunit.Code;

        end;
    end;

    var
        myInt: Integer;
        OrgUnitPrice: Decimal;
        glCustEditable: Boolean;
        cuFunctions: Codeunit Functions;
}