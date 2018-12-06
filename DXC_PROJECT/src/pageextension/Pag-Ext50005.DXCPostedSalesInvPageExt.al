pageextension 50005 "DXCPostedSalesInvPageExt" extends "Posted Sales Invoice" //MyTargetPageId
{
    layout
    {     
        addbefore("Work Description")  
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