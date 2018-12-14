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
     [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Qty. to Assemble to Stock', false, false)]
    local procedure Handle(var Rec : Record "Sales Line";var xRec : Record "Sales Line";CurrFieldNo : Integer);
    var
        SalesLineReserve : Codeunit "Sales Line-Reserve";
        WhseValidateSourceLine : Codeunit "Whse. Validate Source Line";
    begin
        exit;
        WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);

        Rec."Qty. to Asm. to Order (Base)" := CalcBaseQty(Rec."Qty. to Assemble to Order", Rec);

        if Rec."Qty. to Asm. to Order (Base)" <> 0 then begin
          Rec.TESTFIELD("Drop Shipment",false);
          Rec.TESTFIELD("Special Order",false);
          if Rec."Qty. to Asm. to Order (Base)" < 0 then
            Rec.FIELDERROR(Rec."Qty. to Assemble to Order",STRSUBSTNO(Text001,Rec.FIELDCAPTION("Quantity (Base)"),Rec."Quantity (Base)"));
          Rec.TESTFIELD("Appl.-to Item Entry",0);

          case Rec."Document Type" of
            Rec."Document Type"::"Blanket Order",
            Rec."Document Type"::Quote:
              if (Rec."Quantity (Base)" = 0) or (Rec."Qty. to Asm. to Order (Base)" <= 0) or SalesLineReserve.ReservEntryExist(Rec) then
                Rec.TESTFIELD("Qty. to Asm. to Order (Base)",0)
              else
                if Rec."Quantity (Base)" <> Rec."Qty. to Asm. to Order (Base)" then
                  Rec.FIELDERROR("Qty. to Assemble to Order",STRSUBSTNO(Text002,0,Rec."Quantity (Base)"));
            Rec."Document Type"::Order:
              ;
            else
              Rec.TESTFIELD("Qty. to Asm. to Order (Base)",0);
          end;
        end;

        Rec.CheckItemAvailable(Rec.FIELDNO("Qty. to Assemble to Order"));
        if not (CurrFieldNo in [Rec.FIELDNO(Quantity),Rec.FIELDNO("Qty. to Assemble to Order")]) then
          GetDefaultBin(Rec);
        AutoAsmToOrder(Rec);
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

    // ---Page---

    //---p9245---
    //AMC-39
    [EventSubscriber(ObjectType::Page, 9245, 'OnOpenPageEvent', '', false, false)]
    local procedure HandleOpenPageOnProductionForecastMatrix(var Rec : Record Item)
    begin
        Rec."Include Forecast" := true;
    end; 

    //---Codeunits---

       local procedure CalcBaseQty(Qty : Decimal;PSalesLine : Record "Sales Line") : Decimal;
    begin
        PSalesLine.TESTFIELD("Qty. per Unit of Measure");
        exit(ROUND(Qty * PSalesLine."Qty. per Unit of Measure",0.00001));
    end;

    local procedure GetDefaultBin(PSalesLine : Record "Sales Line");
    var
        WMSManagement : Codeunit "WMS Management";
    begin
        if PSalesLine.Type <> PSalesLine.Type::Item then
          exit;

        PSalesLine."Bin Code" := '';
        if PSalesLine."Drop Shipment" then
          exit;

        if (PSalesLine."Location Code" <> '') and (PSalesLine."No." <> '') then begin
          GetLocation(PSalesLine."Location Code");
          if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then begin
            if (PSalesLine."Qty. to Assemble to Order" > 0) or IsAsmToOrderRequired(PSalesLine) then
              if GetATOBin(Location,PSalesLine."Bin Code") then
                exit;

            WMSManagement.GetDefaultBin(PSalesLine."No.",PSalesLine."Variant Code",PSalesLine."Location Code",PSalesLine."Bin Code");
            HandleDedicatedBin(false, PSalesLine);
          end;
        end;
    end;

    [Scope('Personalization')]
    procedure AutoAsmToOrder(PSalesLine : Record "Sales Line");
    var
        ATOLink : Record "Assemble-to-Order Link";
    begin
        ATOLink.UpdateAsmFromSalesLine(PSalesLine);
    end;

    local procedure GetLocation(LocationCode : Code[10]);
    begin
        if LocationCode = '' then
          CLEAR(Location)
        else
          if Location.Code <> LocationCode then
            Location.GET(LocationCode);
    end;

    [Scope('Personalization')]
    procedure IsAsmToOrderRequired(PSalesLine : Record "Sales Line") : Boolean;
    var
        Item : Record Item;
    begin
        if (PSalesLine.Type <> PSalesLine.Type::Item) or (PSalesLine."No." = '') then
          exit(false);
        GetItem(PSalesLine);
        if GetSKU(PSalesLine) then
          exit(SKU."Assembly Policy" = SKU."Assembly Policy"::"Assemble-to-Order");
        exit(Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order");
    end;

    [Scope('Personalization')]
    procedure GetATOBin(Location : Record Location;var BinCode : Code[20]) : Boolean;
    var
        AsmHeader : Record "Assembly Header";
    begin
        if not Location."Require Shipment" then
          BinCode := Location."Asm.-to-Order Shpt. Bin Code";
        if BinCode <> '' then
          exit(true);

        if AsmHeader.GetFromAssemblyBin(Location,BinCode) then
          exit(true);

        exit(false);
    end;

    local procedure HandleDedicatedBin(IssueWarning : Boolean;PSalesLine : Record "Sales Line");
    var
        WhseIntegrationMgt : Codeunit "Whse. Integration Management";
    begin
        if not IsInbound(PSalesLine) and (PSalesLine."Quantity (Base)" <> 0) then
          WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc(PSalesLine."Location Code",PSalesLine."Bin Code",IssueWarning);
    end;

    local procedure GetItem(PSalesLine : Record "Sales Line");
    begin
        PSalesLine.TESTFIELD("No.");
        if PSalesLine."No." <> Item."No." then
          Item.GET(PSalesLine."No.");
    end;

    local procedure GetSKU(PSalesLine : Record "Sales Line") : Boolean;
    begin
        if (SKU."Location Code" = PSalesLine."Location Code") and
           (SKU."Item No." = PSalesLine."No.") and
           (SKU."Variant Code" = PSalesLine."Variant Code")
        then
          exit(true);
        if SKU.GET(PSalesLine."Location Code",PSalesLine."No.",PSalesLine."Variant Code") then
          exit(true);

        exit(false);
    end;

    [Scope('Personalization')]
    procedure IsInbound(PSalesLine : Record "Sales Line") : Boolean;
    begin
        case PSalesLine."Document Type" of
          PSalesLine."Document Type"::Order,PSalesLine."Document Type"::Invoice,PSalesLine."Document Type"::Quote,PSalesLine."Document Type"::"Blanket Order":
            exit(PSalesLine."Quantity (Base)" < 0);
          PSalesLine."Document Type"::"Return Order",PSalesLine."Document Type"::"Credit Memo":
            exit(PSalesLine."Quantity (Base)" > 0);
        end;

        exit(false);
    end;
}

