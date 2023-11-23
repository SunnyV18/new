pageextension 50193 LscPostedCustorderlistExtn extends "LSC Posted Customer Order List"
{
    layout
    {
        addafter("Processing Status")
        {
            field("Total Amount"; "Total Amount")
            {
                ApplicationArea = All;

            }
            field("Pre Approved Amount"; "Pre Approved Amount")
            {
                ApplicationArea = All;
            }
            field("Balance Amount"; ("Total Amount" - "Pre Approved Amount"))
            {
                ApplicationArea = All;
            }

        }
    }
}
