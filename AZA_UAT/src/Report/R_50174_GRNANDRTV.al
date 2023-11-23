report 50174 "GRN AND RTV"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'GrnAndRtv.rdl';


    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Posting Date", "Location Code";
            DataItemTableView = WHERE("Document Type" = FILTER("Purchase Receipt" | "Purchase Return Shipment" | " "), "Entry Type" = filter("Positive Adjmt." | "Purchase"));
            column(Document_Type; "Document Type")
            {

            }
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
            column(vendorItem; vendorItem) { }
            column(CollectionType; CollectionType) { }
            column(LocName; LocName) { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
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
                if item.get("Item No.") then begin
                    Vendcode := item."Vendor No.";
                    mrp := item.MRP;
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
                    CollectionType := item."Collection Type";
                    //   GstAmt :=item.gsta
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
                    Purchrect.Reset();
                    Purchrect.SetRange("No.", "Document No.");
                    if Purchrect.FindFirst() then begin
                        VendororderNo := Purchrect."Vendor Order No.";

                    end;
                    Clear(HeaderComment);
                    RecpurchComment.Reset();
                    RecpurchComment.SetRange("No.", "Document No.");
                    //RecpurchComment.SetRange("Document Type", "Document Type"::"Purchase Receipt");
                    //RecpurchComment.SetRange("Document Line No.", "Document Line No.");
                    if RecpurchComment.FindFirst() then begin
                        repeat
                            HeaderComment += ' ' + RecpurchComment.Comment;
                        until RecpurchComment.Next = 0;
                        //  Message(HeaderComment);
                    end;

                end;
                RecLoc.Reset();
                RecLoc.SetRange(Code, "Location Code");
                if RecLoc.FindFirst() then begin
                    LocName := RecLoc.Name;
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
    var
        myInt: Integer;
        item: Record Item;
        Vendcode: Code[20];
        mrp: Decimal;
        unitcost: Decimal;
        Recvendor: Record Vendor;
        vendorname: Text;
        Comp_Info: Record "Company Information";
        itemdesc: Text;
        itemdesc2: Text;
        itemdesc3: Text;
        itemdesc4: Text;
        potype: Option;
        lscdiv: Text;
        itemcat: Text;
        retaildesc: Text;
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
        vendorItem: Text;
        Division: Text;
        itemCategory: Text;
        Retailitem: Text;
        RecDivision: record "LSC Division";
        Recitemcat: Record "Item Category";
        RecRetail: Record "LSC Retail Product Group";
        GstAmt: Decimal;
        CollectionType: Text;
        RecLoc: Record Location;
        LocName: Text;
        COSTExp: Decimal;
        COSTAct: Decimal;
        CostActExt: Decimal;



}