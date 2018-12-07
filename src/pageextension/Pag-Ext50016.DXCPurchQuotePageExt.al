pageextension 50016 "DXCPurchQuotePageExt" extends "Purchase Quote" //MyTargetPageId
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