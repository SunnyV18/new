page 50104 "Category Size Staging"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CategorySizeStaging";
    Caption = 'Aza Category Size Staging';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;


                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;

                }
                field("Sub Category Code"; Rec."Sub Category Code")
                {
                    ApplicationArea = All;

                }
                field("Sub Category Name"; Rec."Sub Category Name")
                {
                    ApplicationArea = All;

                }
                field("Sub Sub Category Code"; Rec."Sub Sub Category Code")
                {
                    ApplicationArea = All;

                }
                field("Sub Sub Category Name"; Rec."Sub Sub Category Name")
                {
                    ApplicationArea = All;

                }
                field(RecProcessed; Rec.RecProcessed)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Record Status"; Rec."Record Status") { ApplicationArea = all; }
                field("No. of Errors"; "No. of Errors") { ApplicationArea = all; }
                field("Error Text"; "Error Text") { ApplicationArea = all; }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportCatagories)
            {
                ApplicationArea = All;
                Caption = 'Import Catagories';


                trigger OnAction()
                var
                    ItemCatagory: Record "Item Category";
                    division: Record "LSC Division";
                    RetailProductGroup: Record "LSC Retail Product Group";
                    CategorySizeStaging: Record CategorySizeStaging;
                    CU_ItemCreation: Codeunit ProcessItem_Designer;
                begin
                    CU_ItemCreation.ProcessCategoryMaster();// error handling added for Category creation 270123 CITS_RS
                    /*CategorySizeStaging.Reset();
                    CategorySizeStaging.SetRange(RecProcessed, false);
                    if CategorySizeStaging.FindSet() then begin
                        repeat
                            CategorySizeStaging.TestField(Code);
                            CategorySizeStaging.TestField("Sub Category Code");
                            CategorySizeStaging.TestField("Sub Sub Category Code");
                            if not division.Get(CategorySizeStaging.Code) then begin
                                division.Init();
                                division.Code := CategorySizeStaging.Code;
                                division.Description := CategorySizeStaging.Name;
                                division.Insert(true);
                            end;
                            if not ItemCatagory.Get(CategorySizeStaging."Sub Category Code") then begin
                                ItemCatagory.Init();
                                ItemCatagory.Code := CategorySizeStaging."Sub Category Code";
                                ItemCatagory.Description := CategorySizeStaging."Sub Category Name";
                                ItemCatagory."LSC Division Code" := CategorySizeStaging.Code;
                                ItemCatagory.Insert(true);
                            end;
                            if not RetailProductGroup.Get(CategorySizeStaging."Sub Category Code", CategorySizeStaging."Sub Sub Category Code") then begin
                                RetailProductGroup.Init();
                                RetailProductGroup."Item Category Code" := CategorySizeStaging."Sub Category Code";
                                RetailProductGroup.Code := CategorySizeStaging."Sub Sub Category Code";
                                RetailProductGroup.Description := CategorySizeStaging."Sub Sub Category Name";
                                RetailProductGroup.Insert(true);
                            end;
                            CategorySizeStaging.RecProcessed := true;
                            CategorySizeStaging.Modify();
                        until CategorySizeStaging.Next() = 0;
                        Message('Categories Created Successfully');
                    end;*/

                end;
            }
        }
    }
}