codeunit 50000 "DXCEventHandling"
{
    // version EC1.02


    trigger OnRun();
    begin
    end;

    local procedure "---T246---"();
    begin
    end;

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

    local procedure "--CU5100918---"();
    begin
    end;    
}

