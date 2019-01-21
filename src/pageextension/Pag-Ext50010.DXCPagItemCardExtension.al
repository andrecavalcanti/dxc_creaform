// AMC-67 AC 01-14-19 Compliance Tab in Item Card
pageextension 50010 "DXCPagItemCardExtension" extends "Item Card" //MyTargetPageId
{
    layout
    {      

        addafter("Purch. Unit of Measure")
        {
            field(Purchaser; Purchaser)
            {
                ApplicationArea = All;
            }  
            // AMC-64
            field("Include Forecast";"Include Forecast")
            {
                
            }
        }   

        addbefore("Cost is Adjusted")    
        {
            field("Inventory Value Zero";"Inventory Value Zero")
            {
                ApplicationArea = All;
            }
            
        }

        // >> AMC-67

        addafter(Description)
        {
            field("Description 2";"Description 2")
            {

            }

            field("Commercial Invoice Description";"Commercial Invoice Description")
            {

            }
        }

        addafter("Automatic Ext. Texts")
        {
            field("Obsolescence Code";"Obsolesce Code")
            {

            }

            field("Obsolescence Date";"Obsolesce Date")
            {

            }

            field("Is Package";"Is Package")
            {
                
            }
        }
        addafter(Warehouse)
        {
            group("Compliance")
            {
                field(ROHS;ROHS)
                {
                    ApplicationArea = All;
                }

                field(REACH;REACH)
                {
                    ApplicationArea = All;
                }

                field("Conflict Minerals";"Conflict Minerals")
                {
                    ApplicationArea = All;
                }

                field(WEEE;WEEE)
                {
                    ApplicationArea = All;
                }

            }
        }
      
        // << AMC-67
        
    }
        
    actions
    {
    }
}