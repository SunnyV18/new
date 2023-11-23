pageextension 50176 SalesReceivebleSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Direct Debit Mandate Nos.")
        {
            field("Salesperson No. Series"; Rec."Salesperson No. Series")
            {
                ApplicationArea = all;
                TableRelation = "No. Series".Code;
            }
            field("Ship to Address no. Series"; Rec."Ship to Address no. Series")
            {
                ApplicationArea = all;
                TableRelation = "No. Series".Code;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}