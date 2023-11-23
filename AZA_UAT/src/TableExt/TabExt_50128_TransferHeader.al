tableextension 50128 "Ext Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50150; "Transfer Reason"; Text[100])
        {
            //  OptionMembers = " ","Transfer For Client Trail ( Home Shopping)",Others;
        }
        field(50151; "Merchandiser"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LSC Staff" where(Merchandiser = const(true));

        }
        field(50152; "Total Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Line".Quantity where("Document No." = field("No."), "Transfer-from Code" = field("Transfer-from Code")));

        }
        field(50153; "Total Amt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Line".Amount where("Document No." = field("No."), "Transfer-from Code" = field("Transfer-from Code")));

        }
        // modify("Transfer-to Code")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         if Rec."Transfer-to Code" = 'HOME SHOPP' then
        //             Rec."Direct Transfer" := true;
        //         Rec.Modify();
        //     end;
        // }
    }
    trigger OnBeforeInsert()
    var
        Retailuser: Record "LSC Retail User";
    begin
        if Retailuser.Get(UserId) then
            Rec.Validate("Transfer-from Code", Retailuser."Location Code");
    end;
}