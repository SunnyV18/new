page 50110 Stage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Stage;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(ID; rec.ID)
                {
                    ApplicationArea = All;

                }
                field("Order number"; rec."Order number")
                {
                    ApplicationArea = All;
                }
                field("Order detail id"; rec."Order detail id")
                {
                    ApplicationArea = All;
                }
                field("Order date"; rec."Order date")
                {
                    ApplicationArea = All;
                }
                field("Designer id"; rec."Designer id")
                {
                    ApplicationArea = All;
                }
                field("Parent designer id"; rec."Parent designer id")
                {
                    ApplicationArea = All;
                }
                field("Po number"; rec."Po number")
                {
                    ApplicationArea = All;
                }
                field("F team approval"; rec."F team approval")
                {
                    ApplicationArea = All;
                }
                field("po excelsheet name"; rec."po excelsheet name")
                {
                    ApplicationArea = All;
                }
                field("Delivery date"; rec."Delivery date")
                {
                    ApplicationArea = All;
                }
                field("Order delivery date"; rec."Order delivery date")
                {
                    ApplicationArea = All;
                }
                field("Is email sent"; rec."Is email sent")
                {
                    ApplicationArea = All;
                }
                field("Date added"; rec."Date added")
                {
                    ApplicationArea = All;
                }
                field(status; rec.status)
                {
                    ApplicationArea = All;
                }
                field("Po status"; rec."Po status")
                {
                    ApplicationArea = All;
                }
                field("Date modified"; rec."Date modified")

                {
                    ApplicationArea = All;
                }
                field("Po sent date"; rec."Po sent date")
                {
                    ApplicationArea = All;
                }
                field("Modified by"; rec."Modified by")
                {
                    ApplicationArea = All;
                }
                field("f team approval date"; rec."f team approval date")
                {
                    ApplicationArea = All;
                }
                field("f team reamrk"; rec."f team reamrk")
                {
                    ApplicationArea = All;
                }
                field("Is alter po"; rec."Is alter po")
                {
                    ApplicationArea = All;
                }
                field("Po type"; rec."Po type")
                {
                    ApplicationArea = All;
                }
                field("merchandiser name"; rec."merchandiser name")
                {
                    ApplicationArea = All;
                }
                field("Fc location"; rec."Fc location")
                {
                    ApplicationArea = All;
                }
                field("Address line one "; rec."Address line one ")
                {
                    ApplicationArea = All;
                }
                field("Address line two"; rec."Address line two")
                {
                    ApplicationArea = All;

                }
                field(City; rec.City)
                {
                    ApplicationArea = All;
                }
                field(State; rec.State)
                {
                    ApplicationArea = All;
                }
                field("Pin code"; rec."Pin code")
                {
                    ApplicationArea = All;
                }
                field("contact no."; rec."contact no.")
                {
                    ApplicationArea = All;
                }
                field(email; rec.email)
                {
                    ApplicationArea = All;
                }
                field("Vat no."; rec."Vat no.")
                {
                    ApplicationArea = All;
                }
                field("Cin no."; rec."Cin no.")
                {
                    ApplicationArea = All;
                }
                field("Name of company"; rec."Name of company")
                {
                    ApplicationArea = All;
                }
                field("Gst no."; rec."Gst no.")
                {
                    ApplicationArea = All;
                }
                field("Registerd email"; rec."Registerd email")
                {
                    ApplicationArea = All;
                }
                field("Po geography"; rec."Po geography")
                {
                    ApplicationArea = All;
                }
                field("Designer code"; rec."Designer code")
                {
                    ApplicationArea = All;
                }
                field("Po delay days"; rec."Po delay days")
                {
                    ApplicationArea = All;
                }
                field("Address line 1"; rec."Address line 1")
                {
                    ApplicationArea = All;
                }
                field("Address line 2"; rec."Address line 2")
                {
                    ApplicationArea = All;
                }
                field("Gst registered"; rec."Gst registered")
                {
                    ApplicationArea = All;
                }
                field("Po detail id"; rec."Po detail id")
                {
                    ApplicationArea = All;
                }
                field("Product title"; rec."Product title")
                {
                    ApplicationArea = All;
                }
                field("Product id"; rec."Product id")
                {
                    ApplicationArea = All;

                }
                field(Size; rec.Size)
                {
                    ApplicationArea = All;
                }
                field(color; rec.color)
                {
                    ApplicationArea = All;
                }
                field("Quantity total"; rec."Quantity total")
                {
                    ApplicationArea = All;
                }
                field("Quantity recieved"; rec."Quantity recieved")
                {
                    ApplicationArea = All;
                }
                field("Cost to customer"; rec."Cost to customer")
                {
                    ApplicationArea = All;
                }
                field("Mrp to customer"; rec."Mrp to customer")
                {
                    ApplicationArea = All;
                }
                field("Designer discount"; rec."Designer discount")
                {
                    ApplicationArea = All;
                }
                field("Cost inclusive of gst"; rec."Cost inclusive of gst")
                {
                    ApplicationArea = All;
                }
                field("MRP inclusive of gst "; rec."MRP inclusive of gst ")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}