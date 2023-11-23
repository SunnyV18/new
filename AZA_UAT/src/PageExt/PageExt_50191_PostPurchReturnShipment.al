pageextension 50191 "Post purch Ret Ship Head" extends "Posted Return Shipment"
{
    layout
    {
        addafter("No. Printed")
        {
            field("RTV Reason"; Rec."RTV Reason")
            {
                ApplicationArea = All;

            }
            field(Merchandiser; Rec.Merchandiser)
            {
                ApplicationArea = All;

            }
        }
        addafter("Foreign Trade")
        {
            group("Tax Information")
            {
                field("IRN Hash"; Rec."IRN Hash")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("QR Code"; Rec."QR Code")
                {
                    ApplicationArea = All;
                }
                field("Acknowledgment Date"; rec."Acknowledgment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Acknowledgment N0."; rec."Acknowledgment N0.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Signed Invoice"; Rec."Signed Invoice")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("IRN Cancel Date"; "IRN Cancel Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("IRN Cancalled"; "IRN Cancalled")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // field("E-Way Bill Date"; "E-Way Bill Date")
                // {
                //     ApplicationArea = All;
                // }
                field("E-Way Bill DateTime"; "E-Way Bill DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("E-Way Bill No."; "E-Way Bill No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("E-Way Bill Valid Upto"; "E-Way Bill Valid Upto")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transporter GST REg No"; "Transporter GST REg No")
                {
                    ApplicationArea = All;
                    Caption = 'Transporter GST Reg No.';
                }
                field("Transporter Date"; "Transporter Date")
                {
                    ApplicationArea = All;
                }
                field("Transporter Doc No."; "Transporter Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Transport Mode"; "Transport Mode")
                {
                    ApplicationArea = All;
                }
                field("Transporter Name"; "Transporter Name")
                {
                    ApplicationArea = All;
                }
                field("Canceled Date"; "Canceled Date")
                {
                    ApplicationArea = All;
                    Caption = 'EWB Cancalled Date';
                    Editable = false;
                }

            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}