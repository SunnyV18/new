page 50121 "HSN SAC Price"
{
    ApplicationArea = All;
    Caption = 'HSN/SAC Price';
    PageType = List;
    SourceTable = "HSN SSC Price";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {


                field("GST Group Code"; "GST Group Code")
                {
                    ApplicationArea = All;
                }
                field("HSN Code"; "HSN Code")
                {
                    ApplicationArea = All;
                }
                field("Range From"; "Range From")
                {
                    ApplicationArea = All;
                }
                field("Range To"; "Range To")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}


