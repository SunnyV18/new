pageextension 50188 GeneralLedgerExt extends "General Ledger Setup"
{
    layout
    {
        addafter(Application)
        {
            group("E-Invoice")
            {
                field("Enable E-Invoice POS"; "Enable E-Invoice POS") { ApplicationArea = all; }
                field("E-Invoice Auth URL"; Rec."E-Invoice Auth URL") { ApplicationArea = all; }
                field("E-Invoice IRN Generation URL"; Rec."E-Invoice IRN Generation URL") { ApplicationArea = all; Caption = 'IRN Generation URL'; }
                field("E_Way Bill URL"; Rec."E_Way Bill URL") { ApplicationArea = all; Caption = 'E-Way Bill URL'; }
                field("Cancel E-Invoice URL"; Rec."Cancel E-Invoice URL") { ApplicationArea = all; Visible = false; }
                field("Cancel E-Way Bill"; Rec."Cancel E-Way Bill") { ApplicationArea = all; }
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
