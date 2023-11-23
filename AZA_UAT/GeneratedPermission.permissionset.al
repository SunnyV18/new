permissionset 50100 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata "item transfer Header"=RIMD,
        tabledata "Item Transfer Line"=RIMD,
        tabledata Stage=RIMD,
        table "item transfer Header"=X,
        table "Item Transfer Line"=X,
        table Stage=X,
        report CreditNote=X,
        report "Tax Invoice"=X,
        codeunit PublishWebService=X,
        page "Item Transfer"=X,
        page "Item Transfer Subform"=X,
        page "Items Transfers"=X,
        page Stage=X;
}