tableextension 50007 "DXCItemExtension" extends Item //MyTargetTableId
{
    fields
    {
        //comment
        field(500000; Purchaser; code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
    }
    
}