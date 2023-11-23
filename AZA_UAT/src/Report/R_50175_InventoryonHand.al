report 50175 "Inventory on Hand"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = 'InventoryonHand.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Posting Date", "Location Code";
            DataItemTableView = sorting("Entry No.");
            column(Document_Type; "Document Type") { }
            column(Item_No_; "Item No.") { }
            column(Vendcode; Vendcode) { }
            column(vendorname; vendorname) { }
            column(mrp; mrp) { }
            column(unitcost; CostActExt) { }
            column(Document_Date; "Document Date") { }
            column(potype; potype)
            {
                OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright","MTO";
                OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            }
            column(Document_No_; "Document No.") { }
            column(lscdiv; lscdiv) { }
            column(retaildesc; retaildesc) { }
            column(itemcat; itemcat) { }
            column(Location_Code; "Location Code") { }
            column(itemdesc; itemdesc) { }
            column(itemdesc2; itemdesc2) { }
            column(itemdesc3; itemdesc3) { }
            column(itemdesc4; itemdesc4) { }
            column(Quantity; Quantity) { }
            column(Posting_Date; "Posting Date") { }
            column(VendororderNo; VendororderNo) { }
            column(colour; colour) { }
            column(size; size) { }
            column(Hsn; Hsn) { }
            column(Gstgroup; Gstgroup) { }
            column(HeaderComment; HeaderComment) { }
            column(ChildDesName; ChildDesName) { }
            column(parentdesName; parentdesName) { }
            column(PoNo; PoNo) { }
            column(pOSTdATE; pOSTdATE) { }
            column(Remaining_Quantity; "Remaining Quantity") { }
            column(vendorItem; vendorItem) { }
            column(LocName; LocName) { }
            column(Compo; Compo) { }
            column(OLdAzacode; OLdAzacode) { }
            column(CollectionType; CollectionType) { }
            column(SONo; SONo) { }
            column(GRNNo; DocumNo) { }
            column(DocumenNo; DocumenNo) { }
            column(DocumenDate; DocumenDate) { }
            // column(do)
            // column(Document_No_;"Document No.")
            // column(COSTExp; COSTExp) { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin

                Clear(LocName);
                // RECILE.Reset();
                // RECILE.SetRange("Item No.", "Item No.");
                // RECILE.SetRange("Posting Date", "Posting Date");
                // If RECILE.FindFirst() then begin
                if RecLoc.get("Item Ledger Entry"."Location Code") then
                    LocName := RecLoc.Name;
                //  Message('%1loc', LocName);
                RECILE3.Reset();
                RECILE3.SetCurrentKey("Entry No.");
                RECILE3.SetRange("Item No.", "Item No.");
                if RECILE3.FindFirst() then begin
                    DocumenDate := RECILE3."Document Date";
                    DocumenNo := RECILE3."Document No.";
                end;
                //end;
                // RECILE.Reset();
                // RECILE.SetRange("Item No.", "Item Ledger Entry"."Item No.");
                // RECILE.SetRange("Location Code", "Item Ledger Entry"."Location Code");
                // if RECILE.FindSet() then
                //     repeat

                //     until RECILE.Next() = 0;
                // RecLoc.Reset();
                // RecLoc.SetRange(Code, "Location Code");
                // if RecLoc.FindLast() then begin
                //     LocName := RecLoc.Name;
                // end;
                if ("Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Purchase Receipt") or
                ("Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::" ") or
                ("Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Transfer Receipt")
                 or ("Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Sales Return Receipt") then begin
                    DocumNo := "Item Ledger Entry"."Document No.";
                    // Message(DocumNo);
                end else
                    DocumNo := '';

                "Item Ledger Entry".CalcFields("Cost Amount (Expected)");
                "Item Ledger Entry".CalcFields("Cost Amount (Actual)");
                COSTExp := "Item Ledger Entry"."Cost Amount (Expected)";
                COSTAct := "Item Ledger Entry"."Cost Amount (Actual)";

                //Message('%1Actual,%2', COSTAct, COSTExp);
                Clear(CostActExt);
                if COSTExp = 0 then
                    CostActExt := COSTAct
                else
                    if COSTAct = 0 then
                        CostActExt := COSTExp;
                //  Message('%1', CostActExt);

                if item.get("Item No.") then begin
                    Vendcode := item."Vendor No.";
                    mrp := item.MRP;
                    OLdAzacode := item.Old_aza_code;
                    // unitcost := item."Unit Cost";
                    itemdesc := item.Description;
                    itemdesc2 := item."Description 2";
                    itemdesc3 := item."Discription 3";
                    itemdesc4 := item."Discription 4";
                    potype := item."PO type";
                    item.CalcFields("Division Description");
                    lscdiv := item."Division Description";
                    item.CalcFields("Item Cateogry Description");
                    itemcat := item."Item Cateogry Description";
                    item.CalcFields("Retail product Description");
                    retaildesc := item."Retail product Description";
                    fcloc := item."fc location";
                    colour := item.colorName;
                    size := item.sizeName;
                    PoNo := item."PO No.";
                    Hsn := item."HSN/SAC Code";
                    Gstgroup := item."GST Group Code";
                    vendorItem := Item."Vendor Item No.";
                    Compo := item.componentsNo;
                    CollectionType := item."Collection Type";
                    //GRNNo := item."GRN No.";
                    // GRNNo := "Item Ledger Entry"."Document No.";
                    SONo := item."Customer Order ID";
                    // if RecDivision.Get(lscdiv) then begin
                    //     Division := RecDivision.Description;
                    //     //   Message(Division);
                    // end;
                    // if Recitemcat.Get(itemcat) then begin
                    //     itemCategory := Recitemcat.Description;
                    //     // Message(itemCategory);
                    // end;
                    // RecRetail.Reset();
                    // RecRetail.SetRange(RecRetail."Item Category Code", "Item Category Code");
                    // RecRetail.SetRange(RecRetail.Code, "LSC Retail Product Code");
                    // if RecRetail.FindLast() then begin
                    //     Retailitem := RecRetail.Description;
                    //     // Rec.Modify(true);
                    //     //Message('%1', "Retail product Description");
                    // end;

                    // Message('%1', potype);
                    if Recvendor.Get(Vendcode) then begin
                        vendorname := Recvendor.Name;
                        parentdesName := Recvendor."Parent designer name";
                        ChildDesName := Recvendor.Name;
                        //Message(vendorname);
                    end;
                    Clear(pOSTdATE);
                    Purchrect.Reset();
                    Purchrect.SetRange("No.", "Document No.");
                    if Purchrect.FindFirst() then begin
                        VendororderNo := Purchrect."Vendor Order No.";
                        pOSTdATE := Purchrect."Posting Date";
                    end;
                    RecpurchComment.Reset();
                    RecpurchComment.SetRange("No.", "Document No.");
                    RecpurchComment.SetRange("Document Type", "Document Type"::"Purchase Receipt");
                    RecpurchComment.SetRange("Document Line No.", "Document Line No.");
                    if RecpurchComment.FindFirst() then begin
                        repeat
                            HeaderComment += ' ' + RecpurchComment.Comment + '<br>';
                        until RecpurchComment.Next = 0;
                        //  Message(HeaderComment);
                    end;
                end;

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
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
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
    var
        RetUser: Record "LSC Retail User";
    begin
        RetUser.Get(UserId);
        if RetUser."POS Super User" = false then
            Error('This user is not authorized to access this report');
    end;

    var
        myInt: Integer;
        item: Record Item;
        Vendcode: Code[20];
        LocationNew: Code[20];
        Qty: Decimal;
        NewQty: Decimal;
        mrp: Decimal;
        unitcost: Decimal;
        Recvendor: Record Vendor;
        vendorname: Text;
        Comp_Info: Record "Company Information";
        itemdesc: Text;
        itemdesc2: Text;
        itemdesc3: Text;
        itemdesc4: Text;
        GRNNo: Code[20];
        SONo: Code[20];
        potype: Option;
        lscdiv: Text;
        itemcat: Text;
        retaildesc: Text;
        VisiBool: Boolean;

        fcloc: code[20];
        Purchrect: Record "Purch. Rcpt. Header";
        VendororderNo: Code[35];
        colour: Code[20];
        size: Code[20];
        PoNo: Code[20];
        Hsn: Code[20];
        Gstgroup: Code[20];
        RecpurchComment: Record "Purch. Comment Line";
        HeaderComment: Text;
        parentdesName: Text;
        ChildDesName: Text;
        pOSTdATE: Date;
        vendorItem: Text;
        RecLoc: Record Location;
        LocName: Text;
        Division: Text;
        itemCategory: Text;
        Retailitem: Text;
        RecDivision: record "LSC Division";
        Recitemcat: Record "Item Category";
        RecRetail: Record "LSC Retail Product Group";
        Compo: Integer;
        CollectionType: Text;
        COSTExp: Decimal;
        COSTAct: Decimal;
        RECILE: Record "Item Ledger Entry";
        RECILE2: Record "Item Ledger Entry";
        RECILE3: Record "Item Ledger Entry";
        DocumenDate: Date;
        DocumenNo: Code[50];
        CostActExt: Decimal;
        DocumNo: code[20];
        OLdAzacode: Code[30];
        usersetup: Record "LSC Retail User";
        EditField: Boolean;
}