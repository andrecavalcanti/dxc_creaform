// AMC-63 AC 01-03-19 CRM Sales Order Line Integration - New Field
// AMC-68 AC 01-03-19 Sales Order - Assemble to Stock Process Update
tableextension 50018 "DXCSalesLineExt" extends "Sales Line"
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

        // >> AMC-79
/*         field(50002; CRM; Boolean)
        {

        } */
        // << AMC-79
        
        
    }  
    var
        WhseValidateSourceLine : Codeunit "Whse. Validate Source Line";
        ATOLink : Record "Assemble-to-Order Link";
        Text009 : TextConst ENU=' must be 0 when %1 is %2',ESM=' debe ser 0 cuando %1 es %2',FRC=' doit être 0 lorsque %1 est %2',ENC=' must be 0 when %1 is %2';
        Text031 : TextConst ENU='You must either specify %1 or %2.',ESM='Debe especificar %1 o %2.',FRC='Vous devez spécifier %1 ou %2.',ENC='You must either specify %1 or %2.';
        Text045 : TextConst ENU='cannot be more than %1',ESM='no puede ser superior a %1',FRC='ne peut être supérieur à %1',ENC='cannot be more than %1';
    
  
}

