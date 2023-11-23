tableextension 50108 TransferShipmentHeaderExt extends "Transfer Shipment Header"
{
    fields
    {
        field(50000; "Aza Posting No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50115; "IRN Hash"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(50116; "QR Code"; Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50117; "Acknowledgment N0."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50118; "Acknowledgment Date"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50119; "Signed Invoice"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50130; "IRN Cancel Date"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50131; "IRN Cancalled"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50120; "E-Way Bill Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50121; "E-Way Bill DateTime"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50122; "E-Way Bill No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50123; "E-Way Bill Valid Upto"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50124; "Transporter GST REg No"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50125; "Transporter Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50126; "Transporter Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50127; "Transporter Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50128; "Transport Mode"; enum TransportMode)
        {
            DataClassification = ToBeClassified;
        }
        field(50129; "Canceled Date"; text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50150; "Transfer Reason"; Text[100])
        {
            // OptionMembers = " ","Transfer For Client Trail ( Home Shopping)",Others;
            Editable = false;
        }
        field(50151; "Merchandiser"; Text[100])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "LSC Staff" where(Merchandiser = const(true));
            // FieldClass = FlowField;
            // CalcFormula = lookup("Transfer Header".Merchandiser where("No." = field("No.")));

        }
        field(50152; "Total Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Shipment Line".Quantity where("Document No." = field("No.")));

        }
        field(50153; "Total Amt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Shipment Line".Amount where("Document No." = field("No.")));

        }


        // Add changes to table fields here20
    }
    trigger OnAfterInsert()
    var

        ShippingAgent: Record "Shipping Agent";
    begin
        if "Shipping Agent Code" <> '' then begin
            ShippingAgent.get("Shipping Agent Code");
            "Transporter GST REg No" := ShippingAgent."GST Registration No.";
            "Transporter Name" := ShippingAgent.Name;
        end;

    end;

    var
        myInt: Integer;
}