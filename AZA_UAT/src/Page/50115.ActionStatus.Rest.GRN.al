page 50115 GRN_ActionStatus_Rest
{
    PageType = API;
    Caption = 'ActionStatus_Rest';
    APIPublisher = 'CCIT';
    APIGroup = 'GRN_APIs';
    APIVersion = 'v1.0';
    EntityName = 'actionStatus';
    EntitySetName = 'actionStatus_API';
    SourceTable = ActionStatus_GRN;
    DelayedInsert = true;
    // ODataKeyFields = SystemId;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(PO_ID; Rec.PO_ID)
                {
                    Caption = 'PO ID', Locked = true;
                    ApplicationArea = all;

                }
                field(BarCode; Rec.BarCode)//Naveen
                {
                    ApplicationArea = All;
                    Caption = 'BarCode', Locked = true;
                }
                field(action_id; Rec."Action ID")
                {
                    Caption = 'Action ID', Locked = true;
                    ApplicationArea = all;

                }
                field(date_added; Rec."Date added")
                {
                    Caption = 'Date Added', Locked = true;
                    ApplicationArea = all;

                }
                field(hash; Rec.hash)
                {
                    Caption = 'hash', Locked = true;
                    ApplicationArea = all;
                }
            }
        }
    }
}