page 50103 "LSC Trans. Sales Entry"
{
    ApplicationArea = All;
    Caption = 'LSC Trans. Sales Entry List';
    PageType = List;
    SourceTable = "LSC Trans. Sales Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Sales Staff"; Rec."Sales Staff")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Staff field.';
                }
                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Division Code field.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Category Code field.';
                }
                field("Retail Product Code"; Rec."Retail Product Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Retail Product Code field.';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price field.';
                }
                field("Net Price"; Rec."Net Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Price field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount % field.';
                }
                field("Total Disc.%"; Rec."Total Disc.%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Disc.% field.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amount field.';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Amount field.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Trans. Time"; Rec."Trans. Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Time field.';
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Amount field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Store No."; Rec."Store No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store No. field.';
                }
                field("POS Terminal No."; Rec."POS Terminal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Terminal No. field.';
                }
                field("Staff ID"; Rec."Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff ID field.';
                }
                field("Trans. Date"; Rec."Trans. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans. Date field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field("LSCIN GST Group Code"; Rec."LSCIN GST Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Group Code field.';
                }
                field("LSCIN GST Amount"; Rec."LSCIN GST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Amount field.';
                }
                field("LSCIN GST Group Type"; Rec."LSCIN GST Group Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Group Type field.';
                }
                field("LSCIN HSN/SAC Code"; Rec."LSCIN HSN/SAC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSN/SAC Code field.';
                }
                field("LSCIN GST Jurisdiction Type"; Rec."LSCIN GST Jurisdiction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Jurisdiction Type field.';
                }
            }
        }
    }
}
