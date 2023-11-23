codeunit 50115 ProcessItem_DesignerProceImage
{
    trigger OnRun()
    begin
        ProcessImages(barcode_g);
    end;

    var
        barcode_g: Code[100];

    procedure SetBarcode(parmBarcode: Code[100])
    var
        myInt: Integer;
    begin
        barcode_g := parmBarcode;
    end;

    procedure ProcessImages(parmBarcode: Code[100])
    var
        L_Instream: InStream;
        ImageURL: Text;
        client: HttpClient;
        Response: HttpResponseMessage;
        errorFound: Boolean;
        L_Instream2: InStream;
        ImageURL2: Text;
        updateFlag: Boolean;
        client2: HttpClient;
        recItemStage: Record Aza_Item;
        boolUpdated: Boolean;
        recItem: Record 27;
        Response2: HttpResponseMessage;
    begin
        Clear(ImageURL);
        Clear(client);
        Clear(boolUpdated);
        Clear(Response);
        recItemStage.Reset();
        recItemStage.SetRange(bar_code, parmBarcode);
        // recItemStage.SetFilter(image1, '<>%1|%2', ' ', '');
        if not recItemStage.FindLast() then;// Error('Item %1 not found in Aza staging during image processing', recItemStage.bar_code);

        if (recItemStage.image1 <> ' ') and (recItemStage.image1 <> '') then begin
            ImageURL := recItemStage.image1;
            Clear(L_Instream);
            if client.Get(ImageURL, Response) then
                if Response.Content.ReadAs(L_Instream) then
                    if StrLen(recItemStage.bar_code) > 20 then begin
                        if recItem.get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then begin
                            Clear(recItem.Picture);
                            recItem.Picture.ImportStream(L_Instream, 'Image 1');
                            recItem.Modify();
                        end;
                    end else begin
                        if recItem.Get(copystr(recItemStage.bar_code, 1, 20)) then begin
                            Clear(recItem.Picture);
                            recItem.Picture.ImportStream(L_Instream, 'Image 1');
                            recItem.Modify();
                        end;
                    end;
            boolUpdated := true;
        end;

        if (recItemStage.image2 <> ' ') and (recItemStage.image2 <> '') then begin

            Clear(ImageURL2);
            Clear(client2);
            Clear(Response2);
            ImageURL2 := recItemStage.image2;
            Clear(L_Instream2);
            if client2.Get(ImageURL2, Response2) then
                if Response2.Content.ReadAs(L_Instream2) then
                    if StrLen(recItemStage.bar_code) > 20 then begin
                        if recItem.Get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then begin
                            Clear(recItem.Picture2);
                            recItem.Picture2.ImportStream(L_Instream2, 'Image 2');
                            recItem.Modify();
                        end;
                    end else begin
                        if recItem.Get(copystr(recItemStage.bar_code, 1, 20)) then begin
                            Clear(recItem.Picture2);
                            recItem.Picture2.ImportStream(L_Instream2, 'Image 2');
                            recItem.Modify();
                        end;
                    end;
            boolUpdated := true;
        end;

        // if boolUpdated then
        //     if strlen(parmBarcode) > 20 then begin
        //         if recItem.Get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then
        //             recItem.Modify();
        //     end else begin
        //         if recItem.Get(copystr(recItemStage.bar_code, StrLen(recItemStage.bar_code) - 20 + 1)) then
        //             recItem.Modify();
        //     end;
    end;
}