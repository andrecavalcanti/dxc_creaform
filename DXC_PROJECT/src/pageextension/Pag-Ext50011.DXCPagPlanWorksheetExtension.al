pageextension 50011 "DXCPagPlanWorksheetExtension" extends "Planning Worksheet" //MyTargetPageId
{
    layout
    {
        addafter("Vendor No.")
        {
            field(Purchaser; Purchaser)
            {
                ApplicationArea = All;
            }  
        }        
    }
    
    actions
    {
    }
}