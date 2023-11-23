pageextension 50133 LscDemoRoleExtn extends "LSC Demo Role Cent."
{
    actions
    {
        addafter("Run POS")
        {
            group("AZA Reports")
            {
                action("GRN AND RTV")
                {
                    RunObject = report "GRN AND RTV";
                    Caption = 'GRN AND RTV';
                    ApplicationArea = All;
                }
                action("Open Customer Report")
                {
                    RunObject = report "Open Customer Report";
                    Caption = 'Open Customer Order';
                    ApplicationArea = All;
                }
                action("NewCustomer Report")
                {
                    RunObject = report "NewCustomer Report";
                    Caption = 'Closed Customer Order';
                    ApplicationArea = All;
                }

                action("Sales Register Report")
                {
                    RunObject = report "Sales Register Report";
                    Caption = 'Sales Register Report';
                    ApplicationArea = All;
                }
                action("Collection Report")
                {
                    RunObject = report "Collection Report";
                    Caption = 'Collection Report';
                    ApplicationArea = All;
                }
                action("xout Report New")
                {
                    RunObject = report "xout Report Today";
                    Caption = 'Xout Report';
                    ApplicationArea = All;
                }
                action("Inventory on Hand")
                {
                    RunObject = report "Inventory on Hand";
                    Caption = 'Inventory on Hand';
                    ApplicationArea = All;
                }
                action(TransferReport)
                {
                    RunObject = report "TransferReport";
                    Caption = 'TransferReport';
                    ApplicationArea = All;
                }
            }
        }
    }
}
