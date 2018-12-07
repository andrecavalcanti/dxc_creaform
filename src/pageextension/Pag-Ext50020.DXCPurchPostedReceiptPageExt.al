pageextension 50020 "DXCPurchPostedReceiptPageExt" extends "Posted Purchase Receipt" //MyTargetPageId
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