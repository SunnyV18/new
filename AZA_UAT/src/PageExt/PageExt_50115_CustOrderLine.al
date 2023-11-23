pageextension 50115 CustOrderLineExt extends "LSC Customer Order Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("POS Sales Associate"; Rec."POS Sales Associate") { ApplicationArea = all; }
            field("LSCIN GST Place of Supply"; Rec."LSCIN GST Place of Supply") { ApplicationArea = all; }
            field("LSCIN GST Group Code"; Rec."LSCIN GST Group Code") { ApplicationArea = all; }
            field("LSCIN GST Group Type"; Rec."LSCIN GST Group Type") { ApplicationArea = all; }
            field("LSCIN HSN/SAC Code"; Rec."LSCIN HSN/SAC Code") { ApplicationArea = all; }
            field("LSCIN Exempted"; Rec."LSCIN Exempted") { ApplicationArea = all; }
            field("LSCIN Price Inclusive of Tax"; Rec."LSCIN Price Inclusive of Tax") { ApplicationArea = all; }
            field("LSCIN Unit Price Incl. of Tax"; Rec."LSCIN Unit Price Incl. of Tax") { ApplicationArea = all; }
            field("LSCIN GST Amount"; Rec."LSCIN GST Amount") { ApplicationArea = all; }
            field("POS Comment"; "POS Comment") { ApplicationArea = all; }

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