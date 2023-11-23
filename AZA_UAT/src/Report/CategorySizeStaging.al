// report 50126 "Aza Process Report new"
// {
//     ApplicationArea = All;
//     Caption = 'Aza Process Report new';
//     UsageCategory = ReportsAndAnalysis;
//     dataset
//     {
//         dataitem(cateo)
//         {
//             RequestFilterFields = "Entry No.", bar_code;
//             trigger OnAfterGetRecord()
//             var
//                 myInt: Integer;
//                 RecCustomer: Record Aza_Item;
//             begin
//                 RecCustomer.Reset();
//                 RecCustomer.SetRange(RecCustomer.bar_code, bar_code);
//                 RecCustomer.SetFilter(RecCustomer."Record Status", 'Error');
//                 if RecCustomer.FindFirst() then
//                     repeat
//                         RecCustomer."Record Status" := 0;
//                         RecCustomer.Modify();
//                     until RecCustomer.Next = 0;

//             end;
//         }
//     }
//     requestpage
//     {
//         layout
//         {
//             area(content)
//             {
//                 group(GroupName)
//                 {
//                 }
//             }
//         }
//         actions
//         {
//             area(processing)
//             {
//             }
//         }
//     }

// }
