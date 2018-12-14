page 50000 "DXCProductionForecast"
{
    // version NAVW111.00
    // AMC-39 AC 12-11-18 Production Forecast - Change the default view by from Day to Week
    CaptionML = ENU='Production Forecast',
                ESM='Previsión producción',
                FRC='Prévision de production',
                ENC='Production Forecast';
    DataCaptionExpression = ProductionForecastName;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU='General',
                            ESM='General',
                            FRC='Général',
                            ENC='General';
                field(ProductionForecastName;ProductionForecastName)
                {
                    ApplicationArea = Manufacturing;
                    CaptionML = ENU='Production Forecast Name',
                                ESM='Nombre previsión producción',
                                FRC='Nom prévision de production',
                                ENC='Production Forecast Name';
                    TableRelation = "Production Forecast Name".Name;
                    ToolTipML = ENU='Specifies the name of the relevant production forecast for which you are creating an entry.',
                                ESM='Especifica el nombre de la previsión de producción correspondiente para la que está creando un movimiento.',
                                FRC='Spécifie le nom de la prévision de production appropriée pour laquelle vous créez une écriture.',
                                ENC='Specifies the name of the relevant production forecast for which you are creating an entry.';

                    trigger OnValidate();
                    begin
                        SetMatrix;
                    end;
                }
                field(LocationFilter;LocationFilter)
                {
                    ApplicationArea = Manufacturing;
                    CaptionML = ENU='Location Filter',
                                ESM='Filtro almacén',
                                FRC='Filtre emplacement',
                                ENC='Location Filter';
                    ToolTipML = ENU='Specifies a location code if you want to create a forecast entry for a specific location.',
                                ESM='Especifica un código de almacén para crear un movimiento de previsión para un almacén determinado.',
                                FRC='Spécifie un code d''emplacement si vous souhaitez créer une écriture prévision pour un emplacement spécifique.',
                                ENC='Specifies a location code if you want to create a forecast entry for a specific location.';

                    trigger OnLookup(Text : Text) : Boolean;
                    var
                        Loc : Record Location;
                        LocList : Page "Location List";                        
                        
                    begin
                        LocList.LOOKUPMODE(true);
                        Loc.SETRANGE("Use As In-Transit",false);
                        LocList.SETTABLEVIEW(Loc);
                        if not (LocList.RUNMODAL = ACTION::LookupOK) then
                          exit(false);

                        Text := LocList.GetSelectionFilter;                        

                        exit(true);
                    end;

                    trigger OnValidate();
                    var
                        Location : Record Location;
                    begin
                        Location.SETFILTER(Code,LocationFilter);
                        LocationFilter := Location.GETFILTER(Code);
                        SetMatrix;
                    end;
                }
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Manufacturing;
                    CaptionML = ENU='View by',
                                ESM='Ver por',
                                FRC='Afficher par',
                                ENC='View by';
                    OptionCaptionML = ENU='Day,Week,Month,Quarter,Year,Accounting Period',
                                      ESM='Día,Semana,Mes,Trimestre,Año,Periodo contable',
                                      FRC='Jour,Semaine,Mois,Trimestre,Année,Période comptable',
                                      ENC='Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTipML = ENU='Specifies by which period amounts are displayed.',
                                ESM='Especifica para qué periodos se muestran los importes.',
                                FRC='Indique selon quelle périodicité les montants sont affichés.',
                                ENC='Specifies by which period amounts are displayed.';

                    trigger OnValidate();
                    begin
                        SetColumns(SetWanted::First);
                    end;
                }
                field(QtyType;QtyType)
                {
                    ApplicationArea = Manufacturing;
                    CaptionML = ENU='View as',
                                ESM='Ver como',
                                FRC='Afficher en tant que',
                                ENC='View as';
                    OptionCaptionML = ENU='Net Change,Balance at Date',
                                      ESM='Saldo periodo,Saldo a la fecha',
                                      FRC='Variation nette,Solde en date du',
                                      ENC='Net Change,Balance at Date';
                    ToolTipML = ENU='Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.',
                                ESM='Especifica cómo se muestran los importes. Cambio neto: indica el cambio neto del saldo del periodo seleccionado. Saldo a la fecha: muestra el saldo en el último día del periodo seleccionado.',
                                FRC='Spécifie la manière dont les montants sont affichés. Solde période : le solde pour la période sélectionnée. Solde au : le solde au dernier jour de la période sélectionnée.',
                                ENC='Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate();
                    begin
                        QtyTypeOnAfterValidate;
                    end;
                }
                field(ForecastType;ForecastType)
                {
                    ApplicationArea = Manufacturing;
                    CaptionML = ENU='Forecast Type',
                                ESM='Tipo previsión',
                                FRC='Type prévision',
                                ENC='Forecast Type';
                    OptionCaptionML = ENU='Sales Item,Component,Both',
                                      ESM='Producto venta,Componente,Ambos',
                                      FRC='Article ventes,Composante,Les deux',
                                      ENC='Sales Item,Component,Both';
                    ToolTipML = ENU='Specifies one of the following two types when you create a production forecast entry: sales item or component item.',
                                ESM='Especifica uno de los siguientes dos tipos al crear un movimiento de previsión de producción: producto de venta o elemento de componente.',
                                FRC='Spécifie l''un des deux types suivants lorsque vous créez une écriture prévision de production : article vente ou article de composante.',
                                ENC='Specifies one of the following two types when you create a production forecast entry: sales item or component item.';

                    trigger OnValidate();
                    begin
                        ForecastTypeOnAfterValidate;
                    end;
                }
                field(DateFilter;DateFilter)
                {
                    ApplicationArea = Manufacturing;
                    CaptionML = ENU='Date Filter',
                                ESM='Filtro fecha',
                                FRC='Filtre date',
                                ENC='Date Filter';
                    ToolTipML = ENU='Specifies the dates that will be used to filter the amounts in the window.',
                                ESM='Especifica las fechas que se usarán para filtrar los importes en la ventana.',
                                FRC='Spécifie les dates qui sont utilisées pour filtrer les montants dans la fenêtre.',
                                ENC='Specifies the dates that will be used to filter the amounts in the window.';

                    trigger OnValidate();
                    var
                        ApplicationManagement : Codeunit ApplicationManagement;
                    begin
                        if ApplicationManagement.MakeDateFilter(DateFilter) = 0 then;
                        SetColumns(SetWanted::First);
                    end;
                }
            }
            part(Matrix;"Production Forecast Matrix")
            {
                ApplicationArea = Manufacturing;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU='F&unctions',
                            ESM='Acci&ones',
                            FRC='F&onctions',
                            ENC='F&unctions';
                Image = "Action";
                action("Copy Production Forecast")
                {
                    ApplicationArea = Manufacturing;
                    CaptionML = ENU='Copy Production Forecast',
                                ESM='Copiar previsión producc.',
                                FRC='Copier prévision de production',
                                ENC='Copy Production Forecast';
                    Ellipsis = true;
                    Image = CopyForecast;
                    RunObject = Report "Copy Production Forecast";
                    ToolTipML = ENU='Copy an existing production forecast to quickly create a similar forecast.',
                                ESM='Copiar una versión de una previsión de producción existente para crear rápidamente una previsión similar.',
                                FRC='Copier une prévision de production existante pour créer rapidement une prévision similaire.',
                                ENC='Copy an existing production forecast to quickly create a similar forecast.';
                }
            }
            action("Previous Set")
            {
                ApplicationArea = Manufacturing;
                CaptionML = ENU='Previous Set',
                            ESM='Conjunto anterior',
                            FRC='Jeu précédent',
                            ENC='Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTipML = ENU='Go to the previous set of data.',
                            ESM='Permite desplazarse al conjunto de datos anterior.',
                            FRC='Allez à l''ensemble de données précédent.',
                            ENC='Go to the previous set of data.';

                trigger OnAction();
                begin
                    SetColumns(SetWanted::Previous);
                end;
            }
            action("Previous Column")
            {
                ApplicationArea = Manufacturing;
                CaptionML = ENU='Previous Column',
                            ESM='Columna anterior',
                            FRC='Colonne précédente',
                            ENC='Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTipML = ENU='Go to the previous column.',
                            ESM='Permite desplazarse a la columna anterior.',
                            FRC='Accédez à la colonne précédente.',
                            ENC='Go to the previous column.';

                trigger OnAction();
                begin
                    SetColumns(SetWanted::PreviousColumn);
                end;
            }
            action("Next Column")
            {
                ApplicationArea = Manufacturing;
                CaptionML = ENU='Next Column',
                            ESM='Columna siguiente',
                            FRC='Colonne suivante',
                            ENC='Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTipML = ENU='Go to the next column.',
                            ESM='Permite desplazarse a la columna siguiente.',
                            FRC='Accéder à la colonne suivante.',
                            ENC='Go to the next column.';

                trigger OnAction();
                begin
                    SetColumns(SetWanted::NextColumn);
                end;
            }
            action("Next Set")
            {
                ApplicationArea = Manufacturing;
                CaptionML = ENU='Next Set',
                            ESM='Conjunto siguiente',
                            FRC='Jeu suivant',
                            ENC='Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTipML = ENU='Go to the next set of data.',
                            ESM='Permite desplazarse al conjunto de datos siguiente.',
                            FRC='Allez à l''ensemble de données suivant.',
                            ENC='Go to the next set of data.';

                trigger OnAction();
                begin
                    SetColumns(SetWanted::Next);
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        if (NewProductionForecastName <> '') and (NewProductionForecastName <> ProductionForecastName) then
          ProductionForecastName := NewProductionForecastName;

        //>> AMC-39 
        PeriodType := PeriodType::Week;
        // << AMC-39

        SetColumns(SetWanted::First);
    end;

    var
        MatrixRecords : array [32] of Record Date;
        PeriodType : Option Day,Week,Month,Quarter,Year,"Accounting Period";
        QtyType : Option "Net Change","Balance at Date";
        ForecastType : Option "Sales Item",Component,Both;
        ProductionForecastName : Text[30];
        NewProductionForecastName : Text[30];
        LocationFilter : Text;
        DateFilter : Text[1024];
        MatrixColumnCaptions : array [32] of Text[1024];
        ColumnSet : Text[1024];
        SetWanted : Option First,Previous,Same,Next,PreviousColumn,NextColumn;
        PKFirstRecInCurrSet : Text[100];
        CurrSetLength : Integer;

    [Scope('Personalization')]
    procedure SetColumns(SetWanted : Option Initial,Previous,Same,Next,PreviousSet,NextSet);
    var
        MatrixMgt : Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted,ARRAYLEN(MatrixRecords),false,PeriodType,DateFilter,PKFirstRecInCurrSet,
          MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
        SetMatrix;
    end;

    [Scope('Personalization')]
    procedure SetProductionForecastName(NextProductionForecastName : Text[30]);
    begin
        NewProductionForecastName := NextProductionForecastName;
    end;
    
    [Scope('Internal')]
    procedure SetMatrix();
    begin
        CurrPage.Matrix.PAGE.Load(
          MatrixColumnCaptions,MatrixRecords,ProductionForecastName,DateFilter,LocationFilter,ForecastType,
          QtyType,CurrSetLength);
        CurrPage.UPDATE(false);
    end;

    local procedure ForecastTypeOnAfterValidate();
    begin
        SetMatrix;
    end;

    local procedure QtyTypeOnAfterValidate();
    begin
        SetMatrix;
    end;
}

