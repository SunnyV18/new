page 50114 TransferOrderStaging
{
    PageType = List;
    Caption = 'Aza Transfer Order Staging';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = TransferOrderStage;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(transfer_order_id; Rec.transfer_order_id)
                {
                    ApplicationArea = All;

                }
                field(transfer_from_fc; Rec.transfer_from_fc)
                {
                    ApplicationArea = All;

                }
                field(transfer_to_fc; Rec.transfer_to_fc)
                {
                    ApplicationArea = All;

                }
                field(posting_date; Rec.posting_date)
                {
                    ApplicationArea = All;

                }
                field(barcode; Rec.barcode)
                {
                    ApplicationArea = All;

                }
                field(order_id; Rec.order_id)
                {
                    ApplicationArea = All;

                }
                field(order_detail_id; Rec.order_detail_id)
                {
                    ApplicationArea = All;

                }
                field(transfer_order_status; Rec.transfer_order_status)
                {
                    ApplicationArea = All;

                }
                field(date_added; Rec.date_added)
                {
                    ApplicationArea = All;

                }
                field(added_by; Rec.added_by)
                {
                    ApplicationArea = All;

                }
                field(date_modified; Rec.date_modified)
                {
                    ApplicationArea = All;

                }
                field(modified_by; Rec.modified_by)
                {
                    ApplicationArea = All;

                }
                field("No. of Errors"; Rec."No. of Errors")
                {
                    ApplicationArea = all;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = all;
                }
                field("Error Date"; Rec."Error Date")
                {
                    ApplicationArea = all;
                }
                field(Record_Status; Rec.Record_Status)
                {
                    ApplicationArea = all;
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
            action(TransferOrder)
            {
                ApplicationArea = All;
                Caption = 'CreateTransferOrder';

                trigger OnAction();
                var
                    CU50107: Codeunit 50107;
                begin
                    CurrPage.SaveRecord();
                    CU50107.ProcessTransferOrders();
                    CurrPage.Update(false);
                    Message('Transfer Order Created');
                end;
            }
        }
    }
}