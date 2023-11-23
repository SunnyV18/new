pageextension 50128 LscCustorderlistExtn extends "LSC Customer Order List"
{
    layout
    {
        addafter("Lines Collected")
        {
            field("Total Amount"; "Total Amount")
            {
                ApplicationArea = All;

            }
            field("Canceled Amount"; "Canceled Amount") { ApplicationArea = All; }
            field("Pre Approved Amount"; "Pre Approved Amount")
            {
                ApplicationArea = All;
            }
            field("Balance Amount"; ("Total Amount" - "Pre Approved Amount"))
            {
                ApplicationArea = All;
            }
            field("Total Remaining"; ("Total Amount" - "Canceled Amount"))
            {
                ApplicationArea = All;
            }

        }
    }
}
