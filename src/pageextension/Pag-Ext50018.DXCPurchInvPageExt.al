pageextension 50018 "DXCPurchInvPageExt" extends "Purchase Invoice" //MyTargetPageId
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