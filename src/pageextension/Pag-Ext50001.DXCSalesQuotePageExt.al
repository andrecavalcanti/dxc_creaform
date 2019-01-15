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
        
        addafter("Sell-to Contact")     
        {
            field("Distributor/Agent Id";"Distributor/Agent Id")
            {
                ApplicationArea = All;
            }

            field("Finders Fee";"Finders Fee")
            {
                ApplicationArea = All;
            }
        }

       addbefore(ShippingOptions)
        {
            field("Shipment Approved CRM";"Shipment Approved CRM")
            {
               ApplicationArea = All;
            }
            
        }
        
    }   
    
}