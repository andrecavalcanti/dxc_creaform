pageextension 50012 "DXCCashReceiptJnlPageExt" extends "Cash Receipt Journal" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field("Payment Method Code";"Payment Method Code")
            {
                ApplicationArea = All;
            }           
        }

        modify("External Document No.")
        {
            Visible = true;
        }

        modify(Comment)
        {
            Visible = true;
        }
    }
    
    actions
    {
    }
}