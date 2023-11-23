page 50105 RetilCard_ItemPart
{
    Caption = 'Retail Image 2';
    DeleteAllowed = false;
    // Editable = false;
    // InsertAllowed = false;
    // ModifyAllowed = false;
    PageType = ListPart;
    // ShowFilter = false;
    SourceTable = "LSC Retail Image";
    SourceTableTemporary = true;
    SourceTableView = SORTING(Code);

    layout
    {

        area(Content)
        {

            field(Image2; TenantMedia.Content)
            {
                ApplicationArea = All;
                ShowCaption = false;

            }

        }

    }

    actions
    {

    }

    procedure SetActiveImage(TableRecordID: RecordId)
    var
        RetailImage: Record "LSC Retail Image";
        RetailImageUtils: Codeunit "LSC Retail Image Utils";
        DisplayOrder: Integer;
    begin
        Clear(TenantMedia);
        case CurrPage.Caption of
            'Store Logo', 'Retail Default Logo':
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::Logo, 0, TenantMedia);
            'QR Code for Direction', 'QR Code for Dining Table':
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::"QR Code", 0, TenantMedia);
            else
                RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::Image, 1, TenantMedia);
        end;
        if not TenantMedia.Content.HasValue then
            RetailImage.Init();

        Rec.DeleteAll;
        Rec.Init;
        Rec.Insert;
        CurrPage.Update(false);
    end;

    var
        TenantMedia: Record "Tenant Media";
}