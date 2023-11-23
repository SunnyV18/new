pageextension 50198 "AZA Transaction Factbox" extends "LSC Transaction Factbox"
{
    layout
    {
        addafter(TransSignature)
        {
            field(TransCOItems; TransCOItems)
            {
                ApplicationArea = All;
                Caption = 'Customer Order Items';
                //Visible = FieldVisible_g;
                ///ToolTip = 'Show the Trans. Sales Entries linked to the transaction.';

                trigger OnDrillDown()
                var
                    TransCOItem: Record "Trans Customer Order Items";
                    TransCOItemPage: Page "Trans CO Items";
                begin
                    FilterCOItemEntries(TransCOItem);
                    TransCOItemPage.SetTableView(TransCOItem);
                    TransCOItemPage.Editable(false);
                    TransCOItemPage.LookupMode(true);
                    TransCOItemPage.RunModal;
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        TransCOItems: Integer;

    trigger OnAfterGetRecord()
    begin
        TransCOItems := GetTransCOItems;
    end;

    procedure GetTransCOItems(): Decimal
    var
        TransCOItem: Record "Trans Customer Order Items";
    begin
        FilterCOItemEntries(TransCOItem);
        exit(TransCOItem.Count);
    end;

    procedure FilterCOItemEntries(var TransCOItem_p: Record "Trans Customer Order Items")
    begin
        TransCOItem_p.FilterGroup(2);
        TransCOItem_p.SetRange("Store No.", Rec."Store No.");
        TransCOItem_p.SetRange("POS Terminal No.", Rec."POS Terminal No.");
        TransCOItem_p.SetRange("Transaction No.", Rec."Transaction No.");
        TransCOItem_p.FilterGroup(0);
    end;
}