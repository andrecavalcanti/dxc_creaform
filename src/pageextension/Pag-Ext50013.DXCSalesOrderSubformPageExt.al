
pageextension 50013 "DXCSalesOrderSubformPageExt" extends "Sales Order Subform" //MyTargetPageId
{
    layout
    {        
        addlast(Control1)
        {
            field("Outstanding Quantity";"Outstanding Quantity")
            {
                ApplicationArea = All;
            }
               // >> AMC-63
            field("Hidden On Invoice"; "Hidden On Invoice")
            {
                ApplicationArea = All;                
            }
            
            field("Visible Unit Price"; "Visible Unit Price")
            {
                ApplicationArea = All; 
            }

            field("CRM Line Number"; "CRM Line Number")
            {
                ApplicationArea = All; 
            }

            field("List Price"; "List Price")
            {
                ApplicationArea = All; 
            }

            field("RMA Serial Number"; "RMA Serial Number")
            {
                ApplicationArea = All; 
            }

            field("To Be Supplied By"; "To Be Supplied By")
            {
                ApplicationArea = All; 
            }
            // << AMC-63

        }
  
        
    }
    
    actions
    {
    }
  
}