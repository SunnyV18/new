pageextension 50180 PostedShptSubformExt extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter("Quantity Invoiced")
        {
            field("Order Detail Id"; Rec."Order Detail Id") { ApplicationArea = all; }
            field("Product Id"; Rec."Product Id") { ApplicationArea = all; }
            field("Aza Online Code"; Rec."Aza Online Code") { ApplicationArea = all; }
            field("Discount Percent By Desg"; Rec."Discount Percent By Desg") { ApplicationArea = all; }
            field("Discount Percent By Aza"; Rec."Discount Percent By Aza") { ApplicationArea = all; }
            field("Promo Discount"; Rec."Promo Discount") { ApplicationArea = all; }
            field("Credit By Product"; Rec."Credit By Product") { ApplicationArea = all; }
            field("Loyalty By Product"; Rec."Loyalty By Product") { ApplicationArea = all; }
            field("Is Return And Exchange"; Rec."Is Return And Exchange") { ApplicationArea = all; }
            field("Shipping Company Name"; Rec."Shipping Company Name") { ApplicationArea = all; }
            field("Shipping Company Name RTV"; Rec."Shipping Company Name RTV") { ApplicationArea = all; }
            field("Shipping Status"; Rec."Shipping Status") { ApplicationArea = all; }
            field("Tracking Id"; Rec."Tracking Id") { ApplicationArea = all; }
            field("Tracking Id RTV"; Rec."Tracking Id RTV") { ApplicationArea = all; }
            field("Delivery Date RTV"; Rec."Delivery Date RTV") { ApplicationArea = all; }
            field("Track date"; Rec."Track date") { ApplicationArea = all; }
            field("Track Date RTV"; Rec."Track Date RTV") { ApplicationArea = all; }
            field("Invoice Number"; Rec."Invoice Number") { ApplicationArea = all; }
            field("Invoice Number RTV"; Rec."Invoice Number RTV") { ApplicationArea = all; }
            field("Dispatch Date "; Rec."Dispatch Date ") { ApplicationArea = all; }
            field("In Warehouse"; Rec."In Warehouse") { ApplicationArea = all; }
            field("Ship Date RTV"; Rec."Ship Date RTV") { ApplicationArea = all; }
            field("Ship Mode"; Rec."Ship Mode") { ApplicationArea = all; }
            field("Loyalty Points"; Rec."Loyalty Points") { ApplicationArea = all; }
            field("Loyalty Flag"; Rec."Loyalty Flag") { ApplicationArea = all; }
            field("Estm Delivery Date"; Rec."Estm Delivery Date") { ApplicationArea = all; }
            field("Is Customization Received"; Rec."Is Customization Received") { ApplicationArea = all; }
            field("Is Blouse Customization Received"; Rec."Is Blouse Customization Received") { ApplicationArea = all; }
            field("Alteration Charges"; Rec."Alteration Charges") { ApplicationArea = all; }



        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}