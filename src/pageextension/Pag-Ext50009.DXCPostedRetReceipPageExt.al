pageextension 50009 "DXCPostedRetReceipPageExt" extends "Posted Return Receipt" //MyTargetPageId
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