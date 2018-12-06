pageextension 50006 "DXCPostedSalesCrMemoPageExt" extends "Posted Sales Credit Memo" //MyTargetPageId
{
    layout
    {     
        addafter("No. Printed")   
        {
            field("Order Type"; "Order Type")
            {
                ApplicationArea = All;   
                Editable = false;                                       
            }

            field("Internal RMA Number";"Internal RMA Number")
            {
                ApplicationArea = All;
                Editable = false;     
            }    

        }           
        
    }   
    
}