
pageextension 50014 "DXCProdForecastMatrixPageExt" extends "Production Forecast Matrix" //MyTargetPageId
{
    // AMC-39 AC 12-11-18 Production Forecast - Change the default view by from Day to Week
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