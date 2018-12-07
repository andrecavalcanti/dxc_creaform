pageextension 50022 "DXCPostedPurchCrMemoPageExt" extends "Posted Purchase Credit Memo" //MyTargetPageId
{
    layout
    {     
        addlast(General)
        {
            field("Created By";"Created By")
            {
                ApplicationArea = All;     
            }
        }       
        
    }   
    
}