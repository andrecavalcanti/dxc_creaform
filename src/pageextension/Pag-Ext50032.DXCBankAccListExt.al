pageextension 50032 "DXCBankAccListExt" extends "Bank Account List" //MyTargetPageId
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
                Image = List;
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