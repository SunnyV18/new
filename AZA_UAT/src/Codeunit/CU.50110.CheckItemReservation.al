codeunit 50110 CheckItemReservation
{
    trigger OnRun()
    begin
        RecItem.Reset();
        if RecItem.FindSet() then
            repeat
                Reservation(RecItem);
            until RecItem.Next() = 0;
    end;

    procedure Reservation(pItem: Record Item)
    var
        Days: Integer;
    begin
        if pItem.ItemSaleReserved = true then
            if pItem."First Payment Received Date" = 0D then begin
                Days := Today - pItem."Item Booking Date";
                if Days > 3 then begin
                    pItem.ItemSaleReserved := false;
                    pItem.Modify();
                end;
            end;

    end;

    procedure Discountdatevalidation(pItem: Record Item)
    begin
        if pItem."Discount till date valid" <= Today then begin
            pItem.Validate(discountPercentByAza, 0);
            pItem.Validate(discountPercentByDesg, 0);
            pItem.Validate("Disc Amt", 0);
        end;
    end;

    var
        myInt: Integer;
        RecItem: Record item;


}