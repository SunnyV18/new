table 50115 "HSN SSC Price"
{
    fields
    {
        field(1; "GST Group Code"; Code[20])
        {

        }
        field(2; "HSN Code"; Code[20])
        {
        }
        field(3; "Range From"; Decimal)
        {

        }
        field(4; "Range To"; Decimal)
        {

        }
    }
    keys
    {
        key(PK; "GST Group Code", "HSN Code")
        {
            Clustered = true;
        }
    }
}