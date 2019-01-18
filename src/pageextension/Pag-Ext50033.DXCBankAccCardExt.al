pageextension 50033 "DXCBankAccCardExt" extends "Bank Account Card" //MyTargetPageId
{
    layout
    {
        
    }
    
    actions
    {
        // >> AMC-85
        addafter(Statements)
        {
            action(BankRecList)
            {
                CaptionML = ENU='Bank Rec. List',                               
                            ENC='Bank Rec. List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;                
                RunObject = Page "Bank Rec. List";
                RunPageLink = "Bank Account No."=FIELD("No.");
            }
        }
        // << AMC-85

        // >> AMC-85
        modify(Statements)
        {
            Visible = false;
        }
        // << AMC-85
    }
}