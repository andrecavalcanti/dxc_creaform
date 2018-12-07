pageextension 50021 "DXCPostedPurchInvPageExt" extends "Posted Purchase Invoice" //MyTargetPageId
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