table 50110 Stage
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Order number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Order detail id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Order date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Designer id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Parent designer id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Po number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "F team approval"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "po excelsheet name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Delivery date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Order delivery date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Is email sent"; text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Date added"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(14; status; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(15; "Po status"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Date modified"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Po sent date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Modified by"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "f team approval date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "f team reamrk"; text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Is alter po"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Po type"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "merchandiser name"; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Fc location"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Address line one "; text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Address line two"; text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(27; City; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(28; State; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Pin code"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "contact no."; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "email"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Vat no."; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Cin no."; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Name of company"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Gst no."; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Registerd email"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Po geography"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Designer code"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Po delay days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Address line 1"; text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Address line 2"; text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Gst registered"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Po detail id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Product title"; text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Product id"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(46; Size; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(47; color; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Quantity total"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Quantity recieved"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Cost to customer"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Mrp to customer"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Designer discount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(53; "Cost inclusive of gst"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(54; "MRP inclusive of gst "; Decimal)
        {
            DataClassification = ToBeClassified;
        }




    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}