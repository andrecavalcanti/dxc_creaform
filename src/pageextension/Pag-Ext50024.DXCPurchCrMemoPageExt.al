pageextension 50024 "DXCPurchCrMemoPageExt" extends "Purchase Credit Memo" //MyTargetPageId
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