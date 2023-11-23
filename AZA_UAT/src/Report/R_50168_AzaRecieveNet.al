report 50168 AZARecieveNet
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'AzaRecieveNet.rdl';


    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Posting Date";
            DataItemTableView = WHERE("Document Type" = FILTER("Purchase Receipt" | "Purchase Invoice" | "Purchase Return Shipment" | "Purchase Credit Memo"));
            column(Document_Type; "Document Type")
            {

            }
            column(Item_No_; "Item No.") { }
            column(Vendcode; Vendcode) { }
            column(vendorname; vendorname) { }
            column(mrp; mrp) { }
            column(unitcost; unitcost) { }
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
            column(fcloc; fcloc) { }
            column(itemdesc; itemdesc) { }
            column(itemdesc2; itemdesc2) { }
            column(Quantity; Quantity) { }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if item.get("Item No.") then begin
                    Vendcode := item."Vendor No.";
                    mrp := item.MRP;
                    unitcost := item."Unit Cost";
                    itemdesc := item.Description;
                    itemdesc2 := item."Description 2";
                    potype := item."PO type";
                    lscdiv := item."LSC Division Code";
                    itemcat := item."Item Category Code";
                    retaildesc := item."LSC Retail Product Code";
                    fcloc := item."fc location";
                    // Message('%1', potype);
                    if Recvendor.Get(Vendcode) then begin
                        vendorname := Recvendor.Name;
                        //Message(vendorname);
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
        potype: Option;
        lscdiv: code[20];
        itemcat: Code[20];
        retaildesc: Code[20];
        fcloc: code[20];

}