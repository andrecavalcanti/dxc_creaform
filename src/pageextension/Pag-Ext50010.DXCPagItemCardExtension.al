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