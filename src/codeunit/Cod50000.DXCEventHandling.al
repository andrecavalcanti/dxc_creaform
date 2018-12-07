codeunit 50000 "DXCEventHandling"
{
    // version EC1.02


    trigger OnRun();
    begin
    end;    

    // ---T246---
    [EventSubscriber(ObjectType::Table, 246, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure HandleAfterValidateNoOnReqLine(var Rec : Record "Requisition Line";var xRec : Record "Requisition Line";CurrFieldNo : Integer);
    var
        Item : Record Item;                
    begin

        if (Rec.Type <> Rec.Type::Item) then
          exit;

        Item.GET(Rec."No.");

        Rec.Purchaser := Item.Purchaser;
    end;    

    // ---T23---
    [EventSubscriber(ObjectType::Table, 23, 'OnAfterInsertEvent', '', false, false)]
    local procedure HandleAfterInsertOnVendor(var Rec : Record Vendor; RunTrigger : Boolean);
    begin

        Rec."Check Date Format" := Rec."Check Date Format"::"YYYY MM DD";
        Rec.Blocked := Rec.Blocked::All;
    end;

    //---T21---
    [EventSubscriber(ObjectType::Table, 21, 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure HandleAfterCopyCustLedgerEntryFromGenJnlLineOnCustLedgerEntry(var CustLedgerEntry : Record "Cust. Ledger Entry"; GenJournalLine : Record "Gen. Journal Line");
    begin

        CustLedgerEntry.Comment := GenJournalLine.Comment;    
            
    end;

    //---T38---
    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInsertEvent', '', false, false)]
    local procedure HandleAfterInsertOnPurchHeader(var Rec : Record "Purchase Header"; Runtrigger : Boolean);
    begin
        Rec."Created By" := USERID;  
    end;

     [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure HandleAfterValidateNoOnPurchHeader(var Rec : Record "Purchase Header";var xRec : Record "Purchase Header";CurrFieldNo : Integer);
    var
                    
    begin
      
        Rec."Created By" := UserId;
    end;    

    //---Codeunits---

   
}

