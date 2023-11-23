page 50143 "GRN Action Hash"
{
    ApplicationArea = All;
    Caption = 'GRN Action Hash';
    PageType = List;
    SourceTable = "GRN Action Hash";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Po Number field.';
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
