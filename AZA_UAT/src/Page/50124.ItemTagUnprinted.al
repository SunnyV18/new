// page 50124 TagUnprinted
// {
//     PageType = List;
//     ApplicationArea = All;
//     Editable = false;
//     UsageCategory = Lists;
//     SourceTable = Item;
//     SourceTableView = sorting("No.") order(ascending) where("Tag Printed" = const(false));

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("No."; Rec."No.") { ApplicationArea = all; }
//             }
//         }
//         area(Factboxes)
//         {

//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction();
//                 begin

//                 end;
//             }
//         }
//     }
// }