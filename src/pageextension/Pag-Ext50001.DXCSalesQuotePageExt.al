pageextension 50001 "DXCSalesQuotePageExt" extends "Sales Quote" //MyTargetPageId
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