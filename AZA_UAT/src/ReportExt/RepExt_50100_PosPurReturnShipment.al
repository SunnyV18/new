reportextension 50100 "Posted Purch Ret Shipment Ext" extends "Purchase - Return Shipment"
{
    RDLCLayout = 'PurchaseReturnShipmentExt.rdl';
    dataset
    {
        add("Return Shipment Line")
        {
            column(AZACode; AZACode) { }

        }
        modify("Return Shipment Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                item: Record Item;
            begin
                if item.Get("Return Shipment Line"."No.") then
                    AZACode := item.Old_aza_code;
            end;
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }
    var
        AZACode: Code[50];
}