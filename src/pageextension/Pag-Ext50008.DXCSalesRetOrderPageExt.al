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

        addbefore("Location Code")
        {
            field("Shipment Approved CRM";"Shipment Approved CRM")
            {
               ApplicationArea = All;
            }
            
        }               
        
    }   
    
}