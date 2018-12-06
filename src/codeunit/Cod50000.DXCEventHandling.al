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
    local procedure HandleAfterInsertOnVendor(var Rec : Record Vendor;RunTrigger : Boolean);
    begin

        Rec."Check Date Format" := Rec."Check Date Format"::"YYYY MM DD";
        Rec.Blocked := Rec.Blocked::All;
    end;

    //---Codeunits---
   
}

