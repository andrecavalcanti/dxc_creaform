// AMC-67 AC 01-14-19 Compliance Tab in Item Card
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
        // >>  AMC -67
        field(50003;"ROHS";Option)
        {
            OptionMembers = " ", Compliant, "Not compliant", "N/A", Inherit;                      
        }

        field(50004;"REACH";Option)
        {
            OptionMembers = " ", Compliant, "Not compliant", "N/A", Inherit;                      
        }

        field(50005;"Conflict Minerals";Option)
        {
            OptionMembers = " ","Conflict Free", Exempt, "Indeterminable", Unknown;                      
        }

        field(50006;"WEEE";Option)
        {
            OptionMembers = " ",Compliant, "Not compliant", "N/A", Inherit;                      
        }

        field(50007;"Obsolesce Code";Option)
        {
            OptionMembers = " ","End of Line", "Not compliant", "Engineering Change Request";                      
        }

        field(50008;"Obsolesce Date";Date)
        {
                               
        }

        field(50009;"Commercial Invoice Description";Text[50])
        {
                               
        }

        field(50010;"Is Package";Boolean)
        {
                               
        }
        // <<  AMC -67
    }
    
}