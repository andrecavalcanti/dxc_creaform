pageextension 50010 "DXCPagItemCardExtension" extends "Item Card" //MyTargetPageId
{
    layout
    {
        addafter("Purch. Unit of Measure")
        {
            field(Purchaser; Purchaser)
            {
                ApplicationArea = All;
            }  
            // AMC-64
            field("Include Forecast";"Include Forecast")
            {
                
            }
        }   

        addbefore("Cost is Adjusted")    
        {
            field("Inventory Value Zero";"Inventory Value Zero")
            {
                ApplicationArea = All;
            }
            
        }
        
    }
        
    actions
    {
    }
}