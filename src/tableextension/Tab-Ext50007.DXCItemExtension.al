tableextension 50007 "DXCItemExtension" extends Item //MyTargetTableId
{
    fields
    {
        field(500000; Purchaser; code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(50001; CRM;  Boolean)
        {
            
        }
        // AMC-64
        field(50002; "Include Forecast"; Boolean)
        {

        }
    }
    
}