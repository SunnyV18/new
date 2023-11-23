page 50106 GRN_Staging_Rest
{
    PageType = API;
    Caption = 'GRN_StagingAPI';
    APIPublisher = 'CCIT';
    APIGroup = 'GRN_APIs';
    APIVersion = 'v1.0';
    EntityName = 'GRN_Staging';
    EntitySetName = 'GRN_Staging';
    SourceTable = GRN_Staging;
    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(id; Rec.id)
                {
                    ApplicationArea = all;
                }
                field(po_number; Rec.po_number)
                {
                    ApplicationArea = All;

                }
                field(date_added; Rec.date_added)
                {
                    ApplicationArea = All;

                }
                field(date_modified; Rec.date_modified)
                {
                    ApplicationArea = All;

                }
                field(modified_by; Rec.modified_by)
                {
                    ApplicationArea = All;

                }
                field(added_by; Rec.added_by)
                {
                    ApplicationArea = All;

                }
                field(fc_location; Rec.fc_location)
                {
                    ApplicationArea = All;

                }
                field(po_detail_id; Rec.po_detail_id)
                {
                    ApplicationArea = All;

                }
                field(quantity_received; Rec.quantity_received)
                {
                    ApplicationArea = All;

                }
                field(qc_status; Rec.qc_status)
                {
                    ApplicationArea = All;

                }
                field(barcode; Rec.barcode)
                {
                    ApplicationArea = all;
                }
                // field("Error Date"; Rec."Error Date")
                // {
                //     ApplicationArea = all;
                // }
                // field(action_status; Rec.action_status)
                // {
                //     ApplicationArea = All;
                // }
                part(actionStatus; GRN_ActionStatus_Rest)
                {
                    ApplicationArea = all;
                    Caption = 'Lines', Locked = true;
                    EntityName = 'actionStatus';
                    EntitySetName = 'actionStatus_API';
                    SubPageLink = PO_ID = field(po_detail_id);
                }

            }
        }
    }
}