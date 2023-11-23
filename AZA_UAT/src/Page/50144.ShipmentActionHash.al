page 50144 "Shipment Action Hash"
{
    ApplicationArea = All;
    Caption = 'Shipment Action Hash';
    PageType = List;
    SourceTable = "Shipment Action Hash";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("So No."; Rec."So No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the So No. field.';
                }
                field("Action ID"; Rec."Action ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action ID field.';
                }
                field(Barcode; Rec.Barcode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Barcode field.';
                }

                field(hash; Rec.hash)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the hash field.';
                }
            }
        }
    }
}
