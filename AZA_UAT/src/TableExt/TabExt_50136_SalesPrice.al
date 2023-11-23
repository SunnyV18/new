tableextension 50136 SalesPriceExt extends "Sales Price"
{
    fields
    {
        // Add changes to table fields here
        modify("Price Inclusive of Tax")
        {
            trigger OnBeforeValidate()
            begin
                //   Error('You are not permitted to edit this field');
            end;
        }
    }


    var
        myInt: Integer;
}