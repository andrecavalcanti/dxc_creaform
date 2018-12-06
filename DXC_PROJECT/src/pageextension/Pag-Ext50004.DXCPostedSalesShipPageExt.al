pageextension 50004 "DXCPostedSalesShipPageExt" extends "Posted Sales Shipment" //MyTargetPageId
{
    layout
    {     
        addafter("Responsibility Center")  
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