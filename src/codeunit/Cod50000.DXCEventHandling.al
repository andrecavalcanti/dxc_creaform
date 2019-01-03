// AMC-39 AC 01-03-18 Production Forecast - Change the default view by from Day to Week
codeunit 50000 "DXCEventHandling"
{
    //AMC-39 AC 12-11-18 Production Forecast - Change the default view by from Day to Week
     var
        Text001 : TextConst ENU=' must be 0 when %1 is %2',ESM=' debe ser 0 cuando %1 es %2',FRC=' doit être 0 lorsque %1 est %2',ENC=' must be 0 when %1 is %2';
        Text002 : TextConst ENU='You must either specify %1 or %2.',ESM='Debe especificar %1 o %2.',FRC='Vous devez spécifier %1 ou %2.',ENC='You must either specify %1 or %2.';
        Location : Record Location;
        Item : Record Item;
        SKU : Record "Stockkeeping Unit";

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
    //---T37---
   

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

    // ---Page---

    //---P9245---
    
    // >> AMC-39
    [EventSubscriber(ObjectType::Page, 9245, 'OnOpenPageEvent', '', false, false)]
    local procedure HandleOpenPageOnProductionForecastMatrix(var Rec : Record Item)
    begin
        Rec."Include Forecast" := true;
    end; 
    // >> AMC-39

    //---Codeunits---
    
}

