report 50166 Transferout
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Transfer_out.rdl';


    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            RequestFilterFields = "No.", "Posting Date";
            column(No_; "No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Transfer_from_Code; "Transfer-from Code") { }
            column(Transfer_to_Code; "Transfer-to Code") { }
            column(CompanyName_CompanyInfo; Comp_Info.Name)
            {

            }
            column(CINNo_CompanyInfo; Comp_Info."CIN No.")
            {

            }
            column(Comppic; Comp_Info.Picture) { }

            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemLink = "Document No." = field("No.");
                column(Item_No_; "Item No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Description_2; "Description 2")
                {

                }
                column(Vendcode; Vendcode) { }
                column(mrp; mrp) { }
                column(unitcost; unitcost) { }
                column(Quantity; Quantity) { }
                column(vendorname; vendorname) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    if item.get("Item No.") then begin
                        Vendcode := item."Vendor No.";
                        mrp := item.MRP;
                        unitcost := item."Unit Cost";
                        if Recvendor.Get(Vendcode) then begin
                            vendorname := Recvendor.Name;
                            //  Message(vendorname);
                        end;

                    end;
                 

                end;




            }
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
        Index: Integer;
    begin
        Comp_Info.get();
        Comp_Info.CalcFields(Picture);
    end;

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    var
        myInt: Integer;
        item: Record Item;
        Vendcode: Code[20];
        mrp: Decimal;
        unitcost: Decimal;
        Recvendor: Record Vendor;
        vendorname: Text;
        Comp_Info: Record "Company Information";
        RecLscStaff: Record "LSC Staff";
        RecReciptHeader: Record "Transfer Receipt Header";
        merch: Text;

}