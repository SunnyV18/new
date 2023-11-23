report 50170 "OH Stock Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'OHStockRep.rdl';

    dataset
    {
        dataitem(item; item)
        {
            DataItemTableView = where(Inventory = filter(> 0));
            RequestFilterFields = "No.";
            //DataItemTableView = WHERE("Document Type" = FILTER("Purchase Receipt"));
            column(No_; "No.")
            {

            }
            column("GRN_Date"; "1st GRN Date") { }
            column(Vendor_No_; "Vendor No.") { }
            column(vendorname; vendorname) { }

            column(MRP; MRP) { }
            column(Unit_Cost; "Unit Cost") { }

            column(LSC_Retail_Product_Code; "LSC Retail Product Code") { }
            column(Item_Category_Code; "Item Category Code") { }
            column(LSC_Division_Code; "LSC Division Code") { }

            column(potype; potype)
            {
                OptionMembers = "CON-Consignment","C0-Customer Order","OR-Outright","MTO";
                OptionCaption = 'CON-Consignment,CO-Customer Order ,OR-Outright,MTO';
            }
            column(fc_location; "fc location") { }
            column(Description; Description) { }
            column(Description_2; "Description 2") { }
            column(Inventory; Inventory) { }
            column(Posting_Date; postingdate)
            {

            }
            // column(GRN_Date; "GRN Date") { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                itemledgerEntry.Reset();
                itemledgerEntry.SetRange("Item No.", "No.");
                if itemledgerEntry.FindFirst() then begin
                    postingdate := itemledgerEntry."Posting Date";
                    // if item.get("Item No.") then begin
                    if Recvendor.Get(Vendcode) then begin
                        vendorname := Recvendor.Name;
                        // Message(vendorname);
                    end;
                    // if items.Get("No.") then begin
                    //     grndate := items."GRN Date";
                    // end;

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
        itemledgerEntry: Record "Item Ledger Entry";
        Vendcode: Code[20];
        mrp: Decimal;
        unitcost: Decimal;
        Recvendor: Record Vendor;
        vendorname: Text;
        Comp_Info: Record "Company Information";
        itemdesc: Text;
        itemdesc2: Text;
        potype: Option;
        lscdiv: code[20];
        itemcat: Code[20];
        retaildesc: Code[20];
        fcloc: code[20];
        inventory: Decimal;
        postingdate: Date;
        items: Record Item;
        grndate: date;
}