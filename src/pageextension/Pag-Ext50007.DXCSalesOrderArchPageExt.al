pageextension 50007 "DXCSalesOrderArchPageExt" extends "Sales Order Archive" //MyTargetPageId
{
    layout
    {     
        addlast(General)  
        {
            field("Order Type"; "Order Type")
            {
                ApplicationArea = All;  
                Editable = false;                                        
            }

            field("Internal RMA Number";"Internal RMA Number")
            {
                ApplicationArea = All;
                Editable = false;     
            }    

        }           
        
    }   
    
}