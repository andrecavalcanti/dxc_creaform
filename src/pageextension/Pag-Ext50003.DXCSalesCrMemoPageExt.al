pageextension 50003 "DXCSalesCrMemoPageExt" extends "Sales Credit Memo" //MyTargetPageId
{
    layout
    {     
        addafter("Applies-to ID")    
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
            
            field("Shipment Approved CRM";"Shipment Approved CRM")
            {
               ApplicationArea = All;
            }
        }     
        
    }   
    
}