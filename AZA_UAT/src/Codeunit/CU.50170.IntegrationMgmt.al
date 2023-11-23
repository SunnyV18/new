codeunit 50170 "Integration Mgmt"
{
    trigger OnRun()
    begin
        //Process 1 : Creation of designer(Vendor)
        Clear(CU_ItemDesigner);
        ClearLastError();
        CU_ItemDesigner.ProcessVendors();
        Commit();

        //Process 2 : Creation of Item
        Clear(CU_ItemDesigner);
        ClearLastError();
        CU_ItemDesigner.ProcessItems();
        Commit();

        //Process 3 : Creation of Purchase order
        Clear(CU50106);
        ClearLastError();
        CU50106.ProcessOnlinePOs();
        Commit();


        //Process 4 : Process of GRN
        Clear(cuPOCreation);
        ClearLastError();
        cuPOCreation.ProcessGRNRecords();
        Commit();


        //Process 5 : Creation of Customers
        Clear(CU50106);
        ClearLastError();
        CU50106.ProcessCustomers();
        Commit();


        //Process 6 : Creation of Sales Orders and invoicing as per action status
        Clear(CU_SOCreation);
        ClearLastError();
        CU_SOCreation.ProcessSalesOrders();
        Commit();

    end;

    var
        myInt: Integer;
        CU_ItemDesigner: Codeunit 50113;
        recErrorLog: Record ErrorCapture;
        CU50106: Codeunit 50106;
        cuPOCreation: codeunit PO_CreationfromStaging;
        CU_SOCreation: Codeunit 50111;

}