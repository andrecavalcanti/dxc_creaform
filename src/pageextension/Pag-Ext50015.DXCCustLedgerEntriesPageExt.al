pageextension 50015 "DXCCustLedgerEntriesPageExt" extends "Customer Ledger Entries"//MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field(Comment;Comment)
            {
                ApplicationArea = All;
            }
        }
    }
    
    actions
    {
    }
}