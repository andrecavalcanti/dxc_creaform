pageextension 50002 "DXCSalesInvoicePageExt" extends "Sales Invoice" //MyTargetPageId
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