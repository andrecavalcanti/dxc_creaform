pageextension 50012 "DXCSalesOrderPageExt" extends "Sales Order" //MyTargetPageId
{
    layout
    {
        addafter(Status)
        {
            field("On Hold";"On Hold")
            {
                ApplicationArea = All;
            }            

        }
    }
    
    actions
    {
    }
}