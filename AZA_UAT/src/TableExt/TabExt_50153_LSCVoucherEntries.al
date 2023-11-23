tableextension 50153 "CC Voucher Entries" extends "LSC Voucher Entries"
{
    //KKS- 07/08/2023
    fields
    {
        // Add changes to table fields here
        field(50000; "Customer No."; Code[20])
        { }
        field(50001; "Customer Name"; Text[100])
        { }
        field(50003; "Sales Staff"; Code[20])
        { }
        field(50004; "Customer Advance Data Entry"; Boolean)
        { }
        field(50005; "Sales Staff Name"; Text[100])
        { }
        field(50006; "Customer Phone No."; Text[30])
        { }
    }

    var
        myInt: Integer;


    //KKS+ 07/08/2023
}