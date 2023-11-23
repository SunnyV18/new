// page 50123 GRNAPI_Staging
// {
//     PageType = API;
//     Caption = 'GRN_Staging';
//     APIPublisher = 'CCIT';
//     APIGroup = 'GRN_StagingNew';
//     APIVersion = 'v1.0';
//     EntityName = 'GRN_StagingPg';
//     EntitySetName = 'GRNStaging_NewAPIs';
//     SourceTable = GRN_StagingNew;
//     DelayedInsert = true;
//     ODataKeyFields = SystemId;

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field(id; Rec.SystemId) { Editable = false; Caption = 'Id'; }
//                 field(po_number; Rec.po_number) { ApplicationArea = all; Caption = 'PO No.'; }
//                 field(date_added; Rec.date_added) { ApplicationArea = all; Caption = 'Date Added'; }
//                 field(date_modified; Rec.date_modified) { ApplicationArea = all; Caption = 'Date Modified'; }
//                 field(modified_by; Rec.modified_by) { ApplicationArea = all; Caption = 'Modified By'; }
//                 field(added_by; Rec.added_by) { ApplicationArea = all; caption = 'Added by'; }
//                 field(fc_location; Rec.fc_location) { ApplicationArea = all; Caption = 'FC Location'; }
//                 field(po_detail_id; Rec.po_detail_id) { ApplicationArea = all; Caption = 'PO Detail ID'; }
//                 field(qc_status; Rec.qc_status) { ApplicationArea = all; Caption = 'QC Status'; }

//                 part(actionStatusNew; ActionStatus_New)
//                 {
//                     ApplicationArea = all;
//                     Caption = 'Lines';
//                     EntityName = 'ActionStatusPg';
//                     // EntitySetName = 'ActionStatus_GRN';
//                     //EntitySetName = 'GRNStaging_NewAPIs';
//                     SubPageLink = refID = field(SystemId);
//                 }

//             }
//         }
//     }
// }