pageextension 50007 "DXCSalesOrderArchPageExt" extends "Sales Order Archive" //MyTargetPageId
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

        addbefore("Ship-to Code")
        {
            field("Shipment Approved CRM";"Shipment Approved CRM")
            {
               ApplicationArea = All;
            }
            
        }    
        
    }   
    
}