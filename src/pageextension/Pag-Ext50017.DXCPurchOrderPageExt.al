pageextension 50017 "DXCPurchOrderPageExt" extends "Purchase Order" //MyTargetPageId
{
    layout
    {     
        addlast(General)
        {
            field("Created By";"Created By")
            {
                ApplicationArea = All;   
                Editable = false;  
            }
        }       
        
    }   
    
}