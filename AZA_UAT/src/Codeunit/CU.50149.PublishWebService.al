codeunit 50149 "PublishWebService"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    var
        tentwebService: Record "Tenant Web Service";
    begin
        tentwebService.Init();
        tentwebService."Object Type" := tentwebService."Object Type"::Page;
        tentwebService."Object ID" := 50110;
        tentwebService."Service Name" := 'Stage Page';
        tentwebService.Published := true;
        if not tentwebService.Insert(true) then
            tentwebService.Modify(true);
    end;
}