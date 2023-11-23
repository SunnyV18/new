page 50132 CreateCustomerPOS
{
    PageType = Card;
    Caption = 'Create Customer';
    ApplicationArea = all;
    UsageCategory = Administration;
    SourceTable = 18;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ShowMandatory = true;
                    ApplicationArea = all;
                }
                field("State Code"; Rec."State Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = all;
                }
            }
            group("Address & Contact")
            {
                field(Address; Rec.Address) { ApplicationArea = all; }
                field("Address 2"; Rec."Address 2") { ApplicationArea = all; }
                field("Country/Region Code"; Rec."Country/Region Code") { ApplicationArea = all; }
                field(City; Rec.City) { ApplicationArea = all; }
                field("Post Code"; Rec."Post Code") { ApplicationArea = all; }
                field("Phone No."; Rec."Phone No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = all;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.") { ApplicationArea = all; }
                field("E-Mail"; Rec."E-Mail") { ApplicationArea = all; }
            }
            group(Shipping)
            {
                field("Ship-to Code"; Rec."Ship-to Code") { ApplicationArea = all; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = all; }
            }
            group("Tax Information")
            {
                field("Assessee Code"; Rec."Assessee Code") { ApplicationArea = all; }
                field("P.A.N. No."; Rec."P.A.N. No.") { ApplicationArea = all; }
                field("Adhaar No."; Rec."Adhaar No.") { ApplicationArea = all; }
                field("GST Customer Type"; Rec."GST Customer Type") { ApplicationArea = all; }
                field("GST Registration Type"; Rec."GST Registration Type") { ApplicationArea = all; }
                field("GST Registration No."; Rec."GST Registration No.") { ApplicationArea = all; }
                field("Passport No."; Rec."Passport No.") { ApplicationArea = all; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}