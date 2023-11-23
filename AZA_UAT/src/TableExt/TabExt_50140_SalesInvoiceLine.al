tableextension 50140 SaleesInvoiceLineExt extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Order Detail Id"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Aza Online Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Discount Percent By Desg"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Discount Percent By Aza"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Promo Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Credit By Product"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Loyalty By Product"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Is Return And Exchange"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Shipping Company Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Shipping Company Name RTV"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Tracking Id"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Tracking Id RTV"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Delivery Date RTV"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Track date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Track Date RTV"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Invoice Number"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Invoice Number RTV"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Dispatch Date "; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "In Warehouse"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Ship Date RTV"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Loyalty Points"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Loyalty Flag"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Estm Delivery Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Is Customization Received"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Is Blouse Customization Received"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Alteration Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Product Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Shipping Status"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Ship Mode"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "SubTotal 2"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "SubTotal 1"; Decimal)
        {
            DataClassification = ToBeClassified;
        }


    }

    var
        myInt: Integer;
}