pageextension 50000 "DXCSalesOrderPageExt" extends "Sales Order" //MyTargetPageId 1
{
    layout
    {     
        addafter(Status)
        {
            field("On Hold";"On Hold")
            {
                ApplicationArea = All;
            }    

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

        addafter("Ship-to Address")
        {
            field("Shipment Approved";"Shipment Approved")
            {
               ApplicationArea = All;
            }
            
        }
                
    }   
    
}