page 50130 ActionStatus_Sales
{
    PageType = API;
    Caption = 'ActionStatus_Rest';
    APIPublisher = 'CCIT';
    APIGroup = 'SalesOrderAPIs';
    APIVersion = 'v1.0';
    EntityName = 'actionStatus_SO';
    EntitySetName = 'actionStatus_SO_API';
    SourceTable = Action_Status_Sales;
    DelayedInsert = true;
    Extensible = true;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(SO_ID; Rec.SO_ID)
                {
                    ApplicationArea = all;
                    Caption = 'SO ID', Locked = true;

                }
                field(SO_Detail_ID; Rec.SO_Detail_ID)
                {
                    ApplicationArea = all;
                    Caption = 'SO Detail ID', Locked = true;

                }
                field(action_id; Rec."Action ID")
                {
                    ApplicationArea = all;
                    Caption = 'Action ID', Locked = true;

                }
                field(Date_added; Rec."Date added")
                {
                    ApplicationArea = all;
                    Caption = 'Date Added', Locked = true;

                }
                field(hash; Rec.hash)
                {
                    ApplicationArea = All;
                    Caption = 'hash', Locked = true;
                }
            }
        }
    }
}