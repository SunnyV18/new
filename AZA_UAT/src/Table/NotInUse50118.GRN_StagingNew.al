// table 50118 GRN_StagingNew
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; id; Integer)
//         {
//             DataClassification = ToBeClassified;
//             AutoIncrement = true;
//         }
//         field(2; po_number; Code[30]) { DataClassification = ToBeClassified; }
//         field(3; date_added; text[40]) { DataClassification = ToBeClassified; }
//         field(4; date_modified; Date) { DataClassification = ToBeClassified; }
//         field(5; modified_by; code[100]) { DataClassification = ToBeClassified; }
//         field(6; added_by; code[100]) { DataClassification = ToBeClassified; }
//         field(7; fc_location; Code[10]) { DataClassification = ToBeClassified; }
//         field(8; po_detail_id; Integer) { DataClassification = ToBeClassified; }
//         field(9; quantity_received; Decimal) { dataclassification = tobeclassified; DecimalPlaces = 11; }
//         field(11; qc_status; code[10]) { }
//         field(12; action_status; Code[10]) { ObsoleteState = Removed; ObsoleteReason = 'Array to be used'; }

//     }

//     keys
//     {
//         key(Key1; id)
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