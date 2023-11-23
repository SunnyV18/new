tableextension 50118 SalesInvoiceHeaderExt extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here
        field(50001; Dimensions; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Gross Wt."; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Net Weight"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Country of Origin"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Country of Final Destination"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "IGST Payment Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Not Applicable","LUT or Export under Bond","Export Against Payment of IGST";
            OptionCaption = ' ,Not Applicable, LUT or Export under Bond, Export Against Payment of IGST';
        }
        field(50046; "Store No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Store"."No.";
        }

        field(50047; "PDF Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50048; "E-Invoice Cancel Reason"; Option)
        {
            OptionMembers = "","Duplicate Order","Data Entry Mistake","Order Cancelled",Other;
            DataClassification = ToBeClassified;
        }
        field(50049; "E-Invoice Cancel Remarks"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
         field(50050 ; "CT E-Way Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
         field(50051 ; "CT E-Way Cancelled"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
          field(50052 ; "EwayBillNo"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
          field(50053 ; "ResponseMsg"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
          field(50054 ; "EwayBillDate"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
          field(50055 ; "ValidUpto";DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}