report 50203 VendorUnBlocking
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    // DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var 
            begin
                if Vendor.Blocked = Vendor.Blocked::All then begin
                    Vendor.Blocked := Vendor.Blocked::" ";
                    Vendor.Modify();
                end;
            end;

        } 
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Testt)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    var
        myInt: Integer;
}