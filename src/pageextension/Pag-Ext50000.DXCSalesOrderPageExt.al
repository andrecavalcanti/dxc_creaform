pageextension 50000 "DXCSalesOrderPageExt" extends "Sales Order" //MyTargetPageId 1
{
    layout
    {     
        addafter(Status)
        {
            field("On Hold";"On Hold")
            {
                ApplicationArea = All;
                  // >> AMC-81
                Importance = Standard;
                // << AMC-81
            }    

            field("Order Type"; "Order Type")
            {
                ApplicationArea = All; 
                // >> AMC-81
                Importance = Standard;
                // << AMC-81                                   
            }

            field("Internal RMA Number";"Internal RMA Number")
            {
                ApplicationArea = All;
                // >> AMC-81
                Importance = Additional;
                // << AMC-81
            }        

        } 

        addafter("Sell-to Contact")     
        {
            field("Distributor/Agent Id";"Distributor/Agent Id")
            {
                ApplicationArea = All;
                // >> AMC-81
                Importance = Standard;
                // << AMC-81
            }

            field("Finders Fee";"Finders Fee")
            {
                ApplicationArea = All;
                 // >> AMC-81
                Importance = Standard;
                // << AMC-81
            }
        }

        addbefore(ShippingOptions)
        {
            field("Shipment Approved CRM";"Shipment Approved CRM")
            {
               ApplicationArea = All;
            }
            
        }

        // >> AMC-81

        moveafter("Requested Delivery Date";"Shipment Date")
        moveafter("Shipment Date";"Promised Delivery Date")
       
        modify("Sell-to Customer No.")
        {
            Importance = Standard;
        }

        modify("Sell-to Contact")
        {
            Importance = Standard;
        }

        modify("Posting Date")
        {
            Importance = Standard;
        }

        modify("Order Date")
        {
            Importance = Standard;
        }

        modify("Requested Delivery Date")
        {
            Importance = Standard;
        }

        modify("Promised Delivery Date")
        {
            Importance = Standard;            
        } 

        modify("External Document No.")
        {
            Importance = Standard;
        }

        modify(Status)
        {
            Importance = Standard;
        }       

        modify("WMDM POS")
        {
            Importance = Additional;
        }


        // << AMC-81    
                
    }      
    
}