page 50151 "E-Invoice Setup"
{
    DeleteAllowed = false;
    SourceTable = 50167;
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Integration Enabled"; Rec."Integration Enabled")
                {
                    ApplicationArea = All;
                }
                field("Auto Generate E-Invoice"; Rec."Auto Generate E-Invoice")
                {
                    ApplicationArea = All;
                }
                field("Integration Mode"; Rec."Integration Mode")
                {
                    ApplicationArea = All;
                }
                field("Show Schema Messsage"; Rec."Show Schema Messsage")
                {
                    ApplicationArea = All;
                }
            }
            group("E-Invoice")
            {
                Caption = 'E-Invoice';

                field(Host; Rec.Host)
                {
                    ApplicationArea = All;
                }
                // field("Authorization Token"; Rec."Authorization Token")
                // {
                //     ApplicationArea = All;
                // }
                field("URL IRN Generation"; Rec."URL IRN Generation")
                {
                    ApplicationArea = All;
                }
                field("URL IRN Cancellation"; Rec."URL IRN Cancellation")
                {
                    ApplicationArea = All;
                }
                field("URL E-Waybill"; Rec."URL E-Waybill")
                {
                    ApplicationArea = All;
                }
                field("URL Cancel E-Waybill"; Rec."URL Cancel E-Waybill")
                {
                    ApplicationArea = All;
                }
                field("URL Print E-Waybill"; Rec."URL Print E-Waybill")
                {
                    ApplicationArea = All;
                }
                field("Schema Type"; Rec."Schema Type")
                {
                    ApplicationArea = All;
                }
                field("User Name"; "User Name")
                {
                    ApplicationArea = All;
                }
                field(Password; Password)
                {
                    ApplicationArea = All;
                }
                field("Client ID"; "Client ID")
                {
                    ApplicationArea = All;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ApplicationArea = All;
                }
                field(AuthTokenURL; AuthTokenURL)
                {
                    ApplicationArea = All;
                }

            }
            /* group("E-WayBill")
             {
                 Caption = 'E-WayBill';
                 field("wIntegration Enabled"; Rec."wIntegration Enabled")
                 {
                     ApplicationArea = All;
                 }
                 field(wHost; Rec.wHost)
                 {
                     ApplicationArea = All;
                 }
                 // field("wAuthorization Token"; Rec."wAuthorization Token")
                 // {
                 //     ApplicationArea = All;
                 // }
                 field("wURL EWB Generation"; Rec."wURL EWB Generation")
                 {
                     ApplicationArea = All;
                 }
                 field("wURL EWB Cancellation"; Rec."wURL EWB Cancellation")
                 {
                     ApplicationArea = All;
                 }
                 field("wURL EWB Update"; Rec."wURL EWB Update")
                 {
                     ApplicationArea = All;
                 }
                 field("wURL EWB Print"; Rec."wURL EWB Print")
                 {
                     ApplicationArea = All;
                 }
                 field("wURL EWB Extend"; Rec."wURL EWB Extend")
                 {
                     ApplicationArea = All;
                 }
                 field("wEWB PDF File Path"; Rec."wEWB PDF File Path")
                 {
                     ApplicationArea = All;
                 }
                 field("wEWB Print Type"; Rec."wEWB Print Type")
                 {
                     ApplicationArea = All;
                 }
                 field("wEWB File Name Type"; Rec."wEWB File Name Type")
                 {
                     ApplicationArea = All;
                 }
                 field("wShow Schema Message"; Rec."wShow Schema Message")
                 {
                     ApplicationArea = All;
                 }
             }*/
        }
    }

    actions
    {
    }

}

