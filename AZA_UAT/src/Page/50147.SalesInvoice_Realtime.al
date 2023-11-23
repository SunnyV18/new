page 50147 SalesInvoice_Reatltime
{
    Caption = 'SalesInvoice_Realtime';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SalesInvoice_Realtime;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(order_id; order_id) { ApplicationArea = all; }
                field(order_details_id; order_details_id) { ApplicationArea = all; }
                field(Action_ID; Rec.Action_ID) { ApplicationArea = all; }
                field(Countryname; Rec.Countryname) { ApplicationArea = all; }
                field(State; Rec.State) { ApplicationArea = all; }
                field(Address; Rec.Address) { ApplicationArea = all; }
                field(GSTwithoutPaymentOfDuty; Rec.GSTwithoutPaymentOfDuty) { ApplicationArea = all; }
                field(id; id) { ApplicationArea = all; }
                field(po_number; po_number) { ApplicationArea = All; }
                field(fc_id; fc_id) { ApplicationArea = All; }
                field(Name; Name) { ApplicationArea = All; }
                field(PostCode; PostCode) { ApplicationArea = All; }
                field(City; City) { ApplicationArea = All; }
                field("No. of Errors"; Rec."No. of Errors") { ApplicationArea = all; }
                field("Error Text"; Rec."Error Text") { ApplicationArea = all; }
                field("Record Status"; Rec."Record Status") { ApplicationArea = all; }
                field("Gst Registration No."; "Gst Registration No.") { ApplicationArea = all; }
                field("PAN No."; "PAN No.") { ApplicationArea = all; }

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