page 50122 "GST Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "GST Master";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                }
                field("Subcategory 1"; Rec."Subcategory 1")
                {
                    ApplicationArea = All;
                }
                field("Subcategory 2"; Rec."Subcategory 2")
                {
                    ApplicationArea = All;
                }
                field(Fabric_Type; Rec.Fabric_Type) { ApplicationArea = all; }
                field("Material Name"; Rec."Material Name")
                {
                    ApplicationArea = All;
                }
                field("GST Group"; Rec."GST Group")
                {
                    ApplicationArea = All;
                }
                field("HSN Code"; Rec."HSN Code")
                {
                    ApplicationArea = All;
                }
                field("From Amount"; Rec."From Amount")
                {
                    ApplicationArea = All;
                }
                field("To Amount"; Rec."To Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}