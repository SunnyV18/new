// report 50125 "New Report Aza"
// {
//     ApplicationArea = All;
//     Caption = 'New Report Aza';
//     UsageCategory = ReportsAndAnalysis;
//     dataset
//     {
//         dataitem(Vendor; Vendor)
//         {
//             RequestFilterFields = "No.";
//             trigger OnAfterGetRecord()
//             var
//                 myInt: Integer;
//                 RecCustomer: Record Vendor;
//             begin
//                 RecCustomer.Reset();
//                 RecCustomer.SetRange(RecCustomer."No.", Vendor."No.");
//                 RecCustomer.SetRange(RecCustomer.Blocked);
//                 if RecCustomer.FindFirst() then
//                     repeat
//                         RecCustomer.Blocked := 0;
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
