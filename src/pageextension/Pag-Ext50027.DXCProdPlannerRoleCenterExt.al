// AMC-39 AC 01-03-18 Production Forecast - Change the default view by from Day to Week
pageextension 50027 "DXCProdPlannerRoleCenterExt" extends "Production Planner Role Center" //MyTargetPageId
{
    layout
    {
                
    }
    
    actions
    {
        modify("Production Forecast")
        {
            Visible = false;
        }
        addafter("Finished Production Orders")
        {   
            action("DXC Production Forecast")
            {
                ApplicationArea = Manufacturing;
                CaptionML = ENU='Production Forecast',
                            ESM='Previsión producción',
                            FRC='Prévision de production',
                            ENC='Production Forecast';
                RunObject = page "DXCProductionForecastNames";
                ToolTipML = ENU='View or edit a production forecast for your sales items, components, or both.',
                            ESM='Permite ver o editar las previsiones de producción de sus productos de ventas, componentes o ambos.',
                            FRC='Affichez ou modifiez une prévision de production pour vos articles de vente, vos composantes ou les deux.',
                            ENC='View or edit a production forecast for your sales items, components, or both.';
            }
        }
    }
}