pageextension 50029 "DXCBlanketSalesOrderExt" extends "Blanket Sales Order" //MyTargetPageId
{
    layout
    {
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
    
    actions
    {
    }
}