tableextension 50149 "Posted purch Ret Ship Head" extends "Return Shipment Header"
{
    fields
    {
        field(50021; "RTV Reason"; Option)
        {
            OptionMembers = " ","For Alteration","Asked By Designer","For Sourcing","Consignment Return (RTV Permanent)","For Order Refernce",Others;
            Editable = false;
        }
        field(50023; Merchandiser; text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
        RecLscRetail: Record "LSC Retail User";
}