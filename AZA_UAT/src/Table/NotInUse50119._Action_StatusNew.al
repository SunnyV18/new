// table 50119 Action_StatusNew
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Entry No."; Integer)
//         {
//             DataClassification = ToBeClassified;

//         }

//         field(2; "Action ID"; Integer) { DataClassification = ToBeClassified; }
//         field(3; "Date added"; DateTime) { DataClassification = ToBeClassified; }
//         field(4; "PO_ID"; Integer)
//         {
//             DataClassification = ToBeClassified;
//             // TableRelation = GRN_Staging.SystemId;
//         }
//         field(5; refID; Guid)
//         {
//             TableRelation = GRN_Staging.SystemId;
//         }
//     }

//     keys
//     {
//         key(Key1; "Entry No.")
//         {
//             Clustered = true;
//         }
//     }

//     var
//         myInt: Integer;

//     trigger OnInsert()
//     begin

//     end;

//     trigger OnModify()
//     begin

//     end;

//     trigger OnDelete()
//     begin

//     end;

//     trigger OnRename()
//     begin

//     end;

// }
