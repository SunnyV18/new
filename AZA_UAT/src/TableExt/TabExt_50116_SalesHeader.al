tableextension 50116 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50001; Dimensions; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Gross Wt."; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Net Weight"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Country of Origin"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Country of Final Destination"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "IGST Payment Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Not Applicable","LUT or Export under Bond","Export Against Payment of IGST";
            OptionCaption = ' ,Not Applicable, LUT or Export under Bond, Export Against Payment of IGST';
        }
        field(50007; "Promo Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Promo Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Payment Id"; Text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Transaction Id"; Text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Payer Id"; Text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Payment Method"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Redeem Points"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Redeem Points Credit"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Shipping Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Duties & Taxes"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Total Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Date Added"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Date Modified"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Order Status"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Payment Status"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50022; Currency; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Currency Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "State Tax Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Pan Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Charge Back Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Charge Back Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "Loyalty Point"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "Loyalty Percent"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Loyalty Unit"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "Redeem Loyalty points"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "New Shipping Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50037; "Is Loyalty Free Ship"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Current loyalty Tier"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Billing Locality"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Billing State"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Billing Email"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Billing Landmark"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Shipping Locality"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Shipping State"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Shipping Landmark"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Store No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Store"."No.";
        }


    }
    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin

        RecLscRetail.Get(UserId);
        Validate("Location Code", RecLscRetail."Location Code");

    end;

    var
        myInt: Integer;
        RecLLoc: Record Location;
        RecLscRetail: Record "LSC Retail User";
}