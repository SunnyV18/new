page 50116 ODataBoundAction_ILE
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Item Ledger Entry";
    ODataKeyFields = "Item No.";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    [ServiceEnabled]
    procedure ItemRes(item: Code[20]): Text
    var

        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemJobject: JsonObject;
        // JsonWriter: DotNet JsonTextWriter;
        // JObject: dotnet JObject;
        JSJsonObject: JsonObject;
        JAJsonArray: JsonArray;
        ActionContext: WebServiceActionContext;
        ResultCode: WebServiceActionResultCode;
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::ODataBoundAction_ILE);
        ActionContext.AddEntityKey(Rec.FieldNo("Item No."), Rec."Item No.");


        // JObject := JObject.JObject();
        // JsonWriter := JObject.CreateWriter();

        // JsonWriter.WritePropertyName('item');
        // JsonWriter.WriteStartArray();

        // JsonWriter.WriteEndArray();

        ItemJobject.Add('Item No.', item);
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", item);
        IF ItemLedgerEntry.FindSet() then
            repeat
                Clear(JSJsonObject);
                JSJsonObject.Add('Location Code', ItemLedgerEntry."Location Code");
                JSJsonObject.Add('Reamining Quantity', ItemLedgerEntry."Remaining Quantity");
                JAJsonArray.Add(JSJsonObject);
            until
            ItemLedgerEntry.Next() = 0;
        ItemJobject.Add('Item', JAJsonArray);


        ActionContext.SetResultCode(WebServiceActionResultCode::Get);
        exit(Format(ItemJobject));
        // Message(Format(ItemJobject));
    end;

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction();
    //             begin

    //             end;
    //         }
    //     }
    // }
}