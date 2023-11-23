page 50111 "Item Transfer"
{
    PageType = Card;
    //ApplicationArea = All;
   // UsageCategory = Administration;
    SourceTable = "item transfer Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Documnet No."; rec."Documnet No.")
                {
                    ApplicationArea = All;

                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = All;

                }
                field("Transfer from location Code"; rec."Transfer from loaction Code")
                {
                    ApplicationArea = All;

                }
                field("Transfer to loaction Code"; rec."Transfer to loaction Code")
                {
                    ApplicationArea = All;

                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Created By"; rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created Time"; rec."Created DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            part("Subform"; "Item Transfer Subform")
            {
                SubPageLink = "Document No." = field("Documnet No.");
                ApplicationArea = all;
                UpdatePropagation = Both;
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(Release)
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    rec.Status := rec.Status::Release;

                end;
            }
        }
    }

    var
        myInt: Integer;
}