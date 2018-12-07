pageextension 50023 "DXCPurchOrderArchPageExt" extends "Purchase Order Archive" //MyTargetPageId
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