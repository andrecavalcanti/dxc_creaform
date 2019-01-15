tableextension 50001 "DXCSalesShipHeaderExt" extends "Sales Shipment Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Order Type"; Option)
        {
            OptionMembers = Technology,RMA,"Maintenance Renewal",Service,Accessories;
            Editable = false;
        }

        field(50001; "Internal RMA Number"; Text[20])
        {
            Editable = false;
        }

        field(50002; CRM;  Boolean)
        {
            Editable = false;
        }
          // >> AMC-44
        field(50003; "Purch. Order No."; Code[20])
        {
            Caption = 'Purch. Order No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        
        field(50004; "Distributor/Agent Id"; Integer)
        {
            Caption = 'Distributor/Agent Id';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        
        field(50005; "Finders Fee"; Decimal)
        {
            Caption = 'Finders Fee';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50006; "Shipment Approved CRM"; Boolean)
        {
            Caption = 'Shipment Approved';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        
        // << AMC-44
    }   

}