// AMC-44 AC 01-13-19 Additonal Fields to Sales Header
tableextension 50000 "DXCSalesHeaderExtension" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Order Type"; Option)
        {
            OptionMembers = Technology,RMA,"Maintenance Renewal",Service,Accessories;
        }

        field(50001; "Internal RMA Number"; Text[20])
        {

        }

        field(50002; CRM;  Boolean)
        {
            
        }
        // >> AMC-44
        field(50003; "Purch. Order No."; Code[20])
        {
            Caption = 'Purch. Order No.';
            DataClassification = ToBeClassified;
        }
        
        field(50004; "Distributor/Agent Id"; Integer)
        {
            Caption = 'Distributor/Agent Id';
            DataClassification = ToBeClassified;
        }
        
        field(50005; "Finders Fee"; Decimal)
        {
            Caption = 'Finders Fee';
            DataClassification = ToBeClassified;
        }

        field(50006; "Shipment Approved CRM"; Boolean)
        {
            Caption = 'Shipment Approved CRM';
            DataClassification = ToBeClassified;
        }
        
        // << AMC-44

    }  

}

