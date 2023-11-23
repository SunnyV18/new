pageextension 50170 TransferOrderExt extends "Transfer Order"
{
    layout
    {
        addafter(Status)
        {
            field("Transfer Reason"; Rec."Transfer Reason")
            {
                ApplicationArea = All;

            }
        }
        addafter("Transfer Reason")
        {
            field(Merchandiser; Merchandiser)
            {
                ApplicationArea = All;
            }
        }
        addafter("Load Unreal Prof Amt on Invt.")
        {
            field("Total Qty"; "Total Qty") { ApplicationArea = all; Editable = false; }
            field("Total Amt"; "Total Amt") { ApplicationArea = all; Editable = false; }
        }
        modify("Transfer-from Code")
        {
            Editable = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(PostAndPrint)
        {
            Visible = false;
        }
    }

    // trigger OnOpenPage()
    // var
    //     recRetailUser: Record "LSC Retail User";
    // begin
    //     recRetailUser.Reset();
    //     recRetailUser.SetRange(ID, UserId);
    //     if recRetailUser.FindFirst() then begin
    //         Rec.FilterGroup(0);
    //         Rec.SetRange("Transfer-to Code", recRetailUser."Location Code");
    //         Rec.FilterGroup(3);
    //     end;
    // end;

    var
        myInt: Integer;
}