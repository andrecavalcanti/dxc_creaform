
// AMC-68 AC 01-03-19 Sales Order - Assemble to Stock Process Update
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
        // >> AMC-68
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
        // << AMC-68     
        
    }
    
    actions
    {
    }
    // >> AMC-68
    local procedure QtyToAsmToOrderOnAfterValidateDXC();
    begin
        CurrPage.SAVERECORD;
        if Reserve = Reserve::Always then
          AutoReserve;
        CurrPage.UPDATE(true);
    end;
    // << AMC-68
}