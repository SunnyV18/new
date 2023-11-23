// pageextension 50105 RetailImageFactLink extends "LSC Retail Image Link Factbox"
// {
//     layout
//     {

//         addafter("TenantMedia.Content")
//         {
//             field(CustomImage2; TenantMedia.Content)
//             {
//                 ApplicationArea = all;
//                 ShowCaption = false;
//             }
//         }
//         // Add changes to page layout here
//     }

//     actions
//     {

//         // Add changes to page actions here
//     }

//     procedure SetActiveImage1(TableRecordID: RecordId)
//     var
//         RetailImage: Record "LSC Retail Image";
//         RetailImageUtils: Codeunit "LSC Retail Image Utils";
//         DisplayOrder: Integer;
//     begin
//         Clear(TenantMedia);
//         case CurrPage.Caption of
//             'Store Logo', 'Retail Default Logo':
//                 RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::Logo, 0, TenantMedia);
//             'QR Code for Direction', 'QR Code for Dining Table':
//                 RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::"QR Code", 0, TenantMedia);
//             else
//                 RetailImageUtils.ReturnTenantMediaForRecordId(TableRecordID, Enum::"LSC Retail Image Link Type"::Image, 1, TenantMedia);
//         end;
//         if not TenantMedia.Content.HasValue then
//             RetailImage.Init();

//         Rec.DeleteAll;
//         Rec.Init;
//         Rec.Insert;
//         CurrPage.Update(false);
//     end;


//     var
//         myInt: Integer;
//         TenantMedia: Record "Tenant Media";
// }