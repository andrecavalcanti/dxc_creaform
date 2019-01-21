tableextension 50027 "DXCSalesLineArchExt" extends "Sales Line Archive"
{
    fields
    {
        // Add changes to table fields here
  
         // >> AMC-63
        field(50004; "Hidden On Invoice"; Boolean)
        {
            
        }
        
        field(50005; "Visible Unit Price"; Decimal)
        {
            DecimalPlaces = 2:2;
        }
        
        field(50006; "CRM Line Number"; Code[9])
        {
            
        }
        
        field(50007; "List Price"; Decimal)
        {
           DecimalPlaces = 2:2;
        }
        
        field(50008; "RMA Serial Number";  Text[20])
        {
            
        }

        field(50009; "To Be Supplied By"; Text[10])
        {
            
        }
        // << AMC-63
        
        
    }  
      
  
}

