pageextension 50129 "Ext Retail Users" extends "LSC Retail Users"
{
    layout
    {
        addafter("Buyer Group Code")
        {
            field("Authorize Item Sales Reserve"; "Authorize Item Sales Reserve")
            {
                ApplicationArea = All;
            }
            field(Adminstrator; Adminstrator)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("Edit Page"; "Edit Page")
            {
                ApplicationArea = All;
            }
            field("Item Approve"; "Item Approve")
            {

            }
            field("Store visible"; "Store visible") { ApplicationArea = All; }
        }
    }
}