tableextension 50002 "DXCSalesInvHeaderExt" extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Order Type"; Option)
        {
            OptionMembers = Technology,RMA,"Maintenance Renewal",Service,Accessories;
        }

        field(50001; "Internal RMA Number"; Text[20])
        {

        }
    }

    

}