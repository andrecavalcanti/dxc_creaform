pageextension 50028 DXCProductionForecastNamesExt extends "Production Forecast Names" //MyTargetPageId
{
    
    layout
    {
        
    }
    
    actions
    {
        modify("Edit Production Forecast")
        {
            Visible = false;
        }
        addlast(Embedding)
        {
            action(test)
            {
                RunObject = page DXCProductionForecast;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Editable := false;
    end;
}