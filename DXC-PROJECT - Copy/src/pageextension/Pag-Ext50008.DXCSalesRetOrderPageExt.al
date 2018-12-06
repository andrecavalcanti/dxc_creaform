pageextension 50008 "DXCSalesRetOrderPageExt" extends "Sales Return Order" //MyTargetPageId
{
    layout
    {     
        addlast(General)  
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