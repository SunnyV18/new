page 50125 GRNPage
{
    PageType = List;
    ApplicationArea = All;
    caption = 'Aza GRN Page';
    UsageCategory = Lists;
    SourceTable = GRN_Staging;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.id)
                {
                    ApplicationArea = All;

                }
                field(po_number; Rec.po_number) { ApplicationArea = all; }
                field(date_added; Rec.date_added) { ApplicationArea = all; }
                field(date_modified; Rec.date_modified) { ApplicationArea = all; }
                field(po_detail_id; Rec.po_detail_id) { ApplicationArea = all; }
                field(barcode; Rec.barcode) { ApplicationArea = all; }
                field(added_by; Rec.added_by) { ApplicationArea = all; }
                field(fc_location; Rec.fc_location) { ApplicationArea = all; }
                field(quantity_received; Rec.quantity_received) { ApplicationArea = all; }
                field(qc_status; Rec.qc_status) { ApplicationArea = all; }
                // field(action_status;action_status){ApplicationArea=all;}
                field("Record Status"; Rec."Record Status") { ApplicationArea = all; }
                field("Error Date"; Rec."Error Date") { ApplicationArea = all; }
                field("Error Text"; Rec."Error Text") { ApplicationArea = all; }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ProcessGRN)
            {
                ApplicationArea = All;
                Promoted = true;

                trigger OnAction();
                var
                    cuPOCreation: codeunit PO_CreationfromStaging;
                begin
                    cuPOCreation.ProcessGRNRecords();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}