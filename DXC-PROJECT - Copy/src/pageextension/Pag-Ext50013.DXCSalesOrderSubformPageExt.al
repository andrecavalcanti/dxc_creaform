pageextension 50013 "DXCSalesOrderSubformPageExt" extends "Sales Order Subform" //MyTargetPageId
{
    layout
    {        
        addlast(Control1)
        {
            field("Outstanding Quantity";"Outstanding Quantity")
            {
                ApplicationArea = All;
            }
        }
        
    }
    
    actions
    {
    }
}