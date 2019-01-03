// AMC-39 AC 01-03-18 Production Forecast - Change the default view by from Day to Week
page 50002 "DXCProductionForecastNames"
{
    // version NAVW111.00

    CaptionML = ENU='Production Forecast Names',
                ESM='Nombres previsión producción',
                FRC='Noms prévisions de production',
                ENC='Production Forecast Names';
    PageType = List;
    SourceTable = "Production Forecast Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Manufacturing;
                    ToolTipML = ENU='Specifies the name of the production forecast.',
                                ESM='Especifica el nombre de la previsión de producción.',
                                FRC='Spécifie le nom de la prévision de production.',
                                ENC='Specifies the name of the production forecast.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTipML = ENU='Specifies a brief description of the production forecast.',
                                ESM='Especifica una descripción breve de la previsión de producción.',
                                FRC='Indique une brève description de la prévision de production.',
                                ENC='Specifies a brief description of the production forecast.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Production Forecast")
            {
                ApplicationArea = Manufacturing;
                CaptionML = ENU='Edit Production Forecast',
                            ESM='Editar previsión producción',
                            FRC='Modifier prévision production',
                            ENC='Edit Production Forecast';
                Image = EditForecast;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';
                ToolTipML = ENU='Open the related production forecast.',
                            ESM='Abrir el pronóstico de producción correspondiente.',
                            FRC='Ouvrir la prévision production associée.',
                            ENC='Open the related production forecast.';

                trigger OnAction();
                var
                    // >> AMC-39
                    // M ProductionForecast : Page "Production Forecast";
                    ProductionForecast : Page DXCProductionForecast;
                    // << AMC-39
                begin
                    ProductionForecast.SetProductionForecastName(Name);
                    ProductionForecast.RUN;
                end;
            }
        }
    }
}

