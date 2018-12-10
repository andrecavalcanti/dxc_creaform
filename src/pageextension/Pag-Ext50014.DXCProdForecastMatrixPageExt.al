//AMC-64
pageextension 50014 "DXCProdForecastMatrixPageExt" extends "Production Forecast Matrix" //MyTargetPageId
{
    layout
    {
        addafter(Description)
        {
            field("Include Forecast";"Include Forecast")
            {
                ApplicationArea = All;
            }
        }
        
    }
    
    actions
    {
    }
}