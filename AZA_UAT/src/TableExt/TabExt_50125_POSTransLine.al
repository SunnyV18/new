tableextension 50125 "POS TRANS LINE Ext" extends "LSC POS Trans. Line"
{
    fields
    {
        field(50001; "CO Refund Line"; Boolean) { DataClassification = ToBeClassified; }
        field(50002; "Designer Name"; Text[100]) { DataClassification = ToBeClassified; }

        field(50003; "POS Comment"; Text[100]) { DataClassification = ToBeClassified; }
        modify(Price)
        {
            trigger OnAfterValidate()
            var
                HSN_SAC: Record "HSN SSC Price";
            begin
                if Rec."LSCIN HSN/SAC Code" <> '' then begin
                    HSN_SAC.Reset();
                    HSN_SAC.SetRange("HSN Code", Rec."LSCIN HSN/SAC Code");
                    if HSN_SAC.FindSet() then begin
                        repeat
                            if ((rec.Price >= HSN_SAC."Range From") AND (rec.Price <= HSN_SAC."Range To")) then begin
                                Rec.Validate("LSCIN GST Group Code", HSN_SAC."GST Group Code");
                                Rec.Validate("LSCIN HSN/SAC Code", HSN_SAC."HSN Code");
                                rec.Modify(true);
                            end;
                        until HSN_SAC.Next() = 0;
                    end;
                end;


            end;
        }
        field(50004; "Original Store"; Code[20]) { DataClassification = ToBeClassified; }
        field(50005; "Original Pos"; Code[20]) { DataClassification = ToBeClassified; }
        field(50006; "Original Trans No."; Integer) { DataClassification = ToBeClassified; }
        field(50007; "Original Trans Line No."; Integer) { DataClassification = ToBeClassified; }


    }
}