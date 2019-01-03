pageextension 50013 "DXCSalesOrderSubformPageExt" extends "Sales Order Subform" //MyTargetPageId
{
    layout
    {        
        addlast(Control1)
        {
            field("Outstanding Quantity";"Outstanding Quantity")
            {
                ApplicationArea = All;
            }
        }

        addafter("Qty. to Assemble to Order")
        {
            field("Qty. to Assemble to Stock";"Qty. to Assemble to Stock")
            {
                ApplicationArea = All;

                trigger OnValidate();
                begin
                    QtyToAsmToOrderOnAfterValidateDXC;
                end;
            }  

        }      
        
    }
    
    actions
    {
    }

    local procedure QtyToAsmToOrderOnAfterValidateDXC();
    begin
        CurrPage.SAVERECORD;
        if Reserve = Reserve::Always then
          AutoReserve;
        CurrPage.UPDATE(true);
    end;
}