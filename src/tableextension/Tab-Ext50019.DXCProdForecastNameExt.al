tableextension 50019 "DXCProdForecastNameExt" extends "Production Forecast Name" //MyTargetTableId
{
    fields
    {
        field(50000; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        
    }
    
}