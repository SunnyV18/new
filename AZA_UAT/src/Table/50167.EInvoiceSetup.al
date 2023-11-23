table 50167 "E-Invoice Setup"
{


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Integration Enabled"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Auto Generate E-Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Host; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Authorization Token"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "URL IRN Generation"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "URL IRN Cancellation"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Schema Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Show Schema Messsage"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Request JSON Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Response JSON Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Integration Mode"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'ClearTaxDemo,Live';
            OptionMembers = ClearTaxDemo,Live;
        }
        field(31; "URL E-Waybill"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "URL Cancel E-Waybill"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "URL Print E-Waybill"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(101; "wIntegration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(102; wHost; Text[250])
        {
            Caption = 'Host';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(103; "wAuthorization Token"; Text[100])
        {
            Caption = 'Authorization Token';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(104; "wURL EWB Generation"; Text[250])
        {
            Caption = 'URL EWB Generation';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(105; "wURL EWB Cancellation"; Text[250])
        {
            Caption = 'URL EWB Cancellation';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(106; "wURL EWB Update"; Text[250])
        {
            Caption = 'URL EWB Update';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(107; "wURL EWB Print"; Text[250])
        {
            Caption = 'URL EWB Print';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(108; "wURL EWB Extend"; Text[250])
        {
            Caption = 'URL EWB Extend';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(109; "wEWB PDF File Path"; Text[250])
        {
            Caption = 'EWB PDF File Path';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(110; "wEWB Print Type"; Option)
        {
            Caption = 'EWB Print Type';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
            OptionCaption = 'Basic,Detailed';
            OptionMembers = basic,detailed;
        }
        field(111; "wEWB File Name Type"; Option)
        {
            Caption = 'EWB File Name Type';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
            OptionCaption = 'EWB ID,EWB No.,Document No.';
            OptionMembers = "EWB ID","EWB No.","Document No.";
        }
        field(112; "wShow Schema Message"; Boolean)
        {
            Caption = 'Show Schema Message';
            DataClassification = ToBeClassified;
            Description = 'CTEWB';
        }
        field(113; B2CURLgen; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'SN-TEC-T21952';
        }
        field(114; B2CQRpath; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'SN-TEC-T21952';
        }
        field(115; "User Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(116; Password; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(117; "Client ID"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(118; "Client Secret"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(119; AuthTokenURL; Text[100])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

