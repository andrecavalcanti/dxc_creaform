pageextension 50000 "DXCSalesOrderPageExt" extends "Sales Order" //MyTargetPageId 1
{
    layout
    {     
        addbefore("Work Description")   
        {
            field("Order Type"; "Order Type")
            {
                ApplicationArea = All;                                     
            }

            field("Internal RMA Number";"Internal RMA Number")
            {
                ApplicationArea = All;
            }    

        }           
        
    }   
    
}