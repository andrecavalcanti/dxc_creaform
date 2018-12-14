report 50001 "DXCCheckStubCheckStubAmetek"
{
    // version NAVNA10.00,EC1.06,EC1.08

    // EC1.06 AC 08-24-18 Canadian payment process for Ivalua Project
    // EC1.08 AC 10-16-18 Signature on checks
    //AMC-40 Changes to A/P Cheque Format
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode\ReportLayouts/CheckStubCheckStubAmetek.rdlc';

    CaptionML = ENU='Check (Stub/Check/Stub)',
                ESM='Cheque (Serie/Cheque/Serie)',
                FRC='Chèque (Talon/Chèque/Talon)',
                ENC='Cheque (Stub/Cheque/Stub)';
    Permissions = TableData "Bank Account"=m;

    dataset
    {
        dataitem(VoidGenJnlLine;"Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
            RequestFilterFields = "Journal Template Name","Journal Batch Name","Posting Date";

            trigger OnAfterGetRecord();
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;

            trigger OnPreDataItem();
            begin
                 if CurrReport.PREVIEW then
                  ERROR(Text000);

                if UseCheckNo = '' then
                  ERROR(Text001);

                if INCSTR(UseCheckNo) = '' then
                  ERROR(USText004);

                if TestPrint then
                  CurrReport.BREAK;

                if not ReprintChecks then
                  CurrReport.BREAK;

                if (GETFILTER("Line No.") <> '') or (GETFILTER("Document No.") <> '') then
                  ERROR(
                    Text002,FIELDCAPTION("Line No."),FIELDCAPTION("Document No."));
                SETRANGE("Bank Payment Type","Bank Payment Type"::"Computer Check");
                SETRANGE("Check Printed",true);
            end;
        }
        dataitem(TestGenJnlLine;"Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name","Journal Batch Name","Line No.");

            trigger OnAfterGetRecord();
            begin
                if Amount = 0 then
                  CurrReport.SKIP;

                TESTFIELD("Bal. Account Type","Bal. Account Type"::"Bank Account");
                if "Bal. Account No." <> BankAcc2."No." then
                  CurrReport.SKIP;
                case "Account Type" of
                  "Account Type"::"G/L Account":
                    begin
                      if BankAcc2."Check Date Format" = BankAcc2."Check Date Format"::" " then
                        ERROR(USText006,BankAcc2.FIELDCAPTION("Check Date Format"),BankAcc2.TABLECAPTION,BankAcc2."No.");
                      if BankAcc2."Bank Communication" = BankAcc2."Bank Communication"::"S Spanish" then
                        ERROR(USText007,BankAcc2.FIELDCAPTION("Bank Communication"),BankAcc2.TABLECAPTION,BankAcc2."No.");
                    end;
                  "Account Type"::Customer:
                    begin
                      Cust.GET("Account No.");
                      if Cust."Check Date Format" = Cust."Check Date Format"::" " then
                        ERROR(USText006,Cust.FIELDCAPTION("Check Date Format"),Cust.TABLECAPTION,"Account No.");
                      if Cust."Bank Communication" = Cust."Bank Communication"::"S Spanish" then
                        ERROR(USText007,Cust.FIELDCAPTION("Bank Communication"),Cust.TABLECAPTION,"Account No.");
                    end;
                  "Account Type"::Vendor:
                    begin
                      Vend.GET("Account No.");
                      if Vend."Check Date Format" = Vend."Check Date Format"::" " then
                        ERROR(USText006,Vend.FIELDCAPTION("Check Date Format"),Vend.TABLECAPTION,"Account No.");
                      if Vend."Bank Communication" = Vend."Bank Communication"::"S Spanish" then
                        ERROR(USText007,Vend.FIELDCAPTION("Bank Communication"),Vend.TABLECAPTION,"Account No.");
                    end;
                  "Account Type"::"Bank Account":
                    begin
                      BankAcc.GET("Account No.");
                      if BankAcc."Check Date Format" = BankAcc."Check Date Format"::" " then
                        ERROR(USText006,BankAcc.FIELDCAPTION("Check Date Format"),BankAcc.TABLECAPTION,"Account No.");
                      if BankAcc."Bank Communication" = BankAcc."Bank Communication"::"S Spanish" then
                        ERROR(USText007,BankAcc.FIELDCAPTION("Bank Communication"),BankAcc.TABLECAPTION,"Account No.");
                    end;
                end;
            end;

            trigger OnPreDataItem();
            begin
                if TestPrint then begin
                  BankAcc2.GET(BankAcc2."No.");
                  BankCurrencyCode := BankAcc2."Currency Code";
                end;

                if TestPrint then
                  CurrReport.BREAK;
                BankAcc2.GET(BankAcc2."No.");
                BankCurrencyCode := BankAcc2."Currency Code";

                if BankAcc2."Country/Region Code" <> 'CA' then
                  CurrReport.BREAK;
                BankAcc2.TESTFIELD(Blocked,false);
                COPY(VoidGenJnlLine);
                BankAcc2.GET(BankAcc2."No.");
                BankAcc2.TESTFIELD(Blocked,false);
                SETRANGE("Bank Payment Type","Bank Payment Type"::"Computer Check");
                SETRANGE("Check Printed",false);
            end;
        }
        dataitem(GenJnlLine;"Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
            column(GenJnlLine_Journal_Template_Name;"Journal Template Name")
            {
            }
            column(GenJnlLine_Journal_Batch_Name;"Journal Batch Name")
            {
            }
            column(GenJnlLine_Line_No_;"Line No.")
            {
            }
            column(Vend_No;Vend."No." + ' - ' + Vend.Name)
            {
            }
            column(Vend_Name;Vend."No." + ' - ' + Vend.Name)
            {
            }
            dataitem(CheckPages;"Integer")
            {
                DataItemTableView = SORTING(Number);
                column(CheckToAddr_1_;CheckToAddr[1])
                {
                }
                column(CheckDateText;CheckDateText)
                {
                }
                column(CheckNoText;CheckNoText)
                {
                }
                column(PageNo;PageNo)
                {
                }
                column(CheckPages_Number;Number)
                {
                }
                column(CheckNoTextCaption;CheckNoTextCaptionLbl)
                {
                }
                dataitem(PrintSettledLoop;"Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 10;
                    column(PreprintedStub;PreprintedStub)
                    {
                    }
                    column(LineAmount;LineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineDiscount;LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmount___LineDiscount;LineAmount + LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(DocNo;DocNo)
                    {
                    }
                    column(DocDate;DocDate)
                    {
                    }
                    column(PostingDesc;PostingDesc)
                    {
                    }
                    column(PrintSettledLoop_Number;Number)
                    {
                    }
                    column(LineAmountCaption;LineAmountCaptionLbl)
                    {
                    }
                    column(LineDiscountCaption;LineDiscountCaptionLbl)
                    {
                    }
                    column(DocNoCaption;DocNoCaptionLbl)
                    {
                    }
                    column(DocDateCaption;DocDateCaptionLbl)
                    {
                    }
                    column(Posting_DescriptionCaption;Posting_DescriptionCaptionLbl)
                    {
                    }
                    column(AmountCaption;AmountCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if not TestPrint then begin
                          if FoundLast then begin
                            if RemainingAmount <> 0 then begin
                              DocNo := '';
                              ExtDocNo := '';
                              LineAmount := RemainingAmount;
                              LineAmount2 := RemainingAmount;
                              CurrentLineAmount := LineAmount2;
                              LineDiscount := 0;
                              RemainingAmount := 0;

                              PostingDesc := CheckToAddr[1];
                            end else
                              CurrReport.BREAK;
                          end else
                            case ApplyMethod of
                              ApplyMethod::OneLineOneEntry:
                                begin
                                  case BalancingType of
                                    BalancingType::Customer:
                                      begin
                                        CustLedgEntry.RESET;
                                        CustLedgEntry.SETCURRENTKEY("Document No.");
                                        CustLedgEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
                                        CustLedgEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
                                        CustLedgEntry.SETRANGE("Customer No.",BalancingNo);
                                        CustLedgEntry.FIND('-');
                                        CustUpdateAmounts(CustLedgEntry,RemainingAmount);
                                      end;
                                    BalancingType::Vendor:
                                      begin
                                        VendLedgEntry.RESET;
                                        VendLedgEntry.SETCURRENTKEY("Document No.");
                                        VendLedgEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
                                        VendLedgEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
                                        VendLedgEntry.SETRANGE("Vendor No.",BalancingNo);
                                        VendLedgEntry.FIND('-');
                                        VendUpdateAmounts(VendLedgEntry,RemainingAmount);
                                      end;
                                  end;
                                  RemainingAmount := RemainingAmount - LineAmount2;
                                  CurrentLineAmount := LineAmount2;
                                  FoundLast := true;
                                end;
                              ApplyMethod::OneLineID:
                                begin
                                  case BalancingType of
                                    BalancingType::Customer:
                                      begin
                                        CustUpdateAmounts(CustLedgEntry,RemainingAmount);
                                        FoundLast := (CustLedgEntry.NEXT = 0) or (RemainingAmount <= 0);
                                        if FoundLast and not FoundNegative then begin
                                          CustLedgEntry.SETRANGE(Positive,false);
                                          FoundLast := not CustLedgEntry.FIND('-');
                                          FoundNegative := true;
                                        end;
                                      end;
                                    BalancingType::Vendor:
                                      begin
                                        VendUpdateAmounts(VendLedgEntry,RemainingAmount);
                                        FoundLast := (VendLedgEntry.NEXT = 0) or (RemainingAmount <= 0);
                                        if FoundLast and not FoundNegative then begin
                                          VendLedgEntry.SETRANGE(Positive,false);
                                          FoundLast := not VendLedgEntry.FIND('-');
                                          FoundNegative := true;
                                        end;
                                      end;
                                  end;
                                  RemainingAmount := RemainingAmount - LineAmount2;
                                  CurrentLineAmount := LineAmount2
                                end;
                              ApplyMethod::MoreLinesOneEntry:
                                begin
                                  CurrentLineAmount := GenJnlLine2.Amount;
                                  LineAmount2 := CurrentLineAmount;
                                  if GenJnlLine2."Applies-to ID" <> '' then
                                    ERROR(
                                      Text016 +
                                      Text017);
                                  GenJnlLine2.TESTFIELD("Check Printed",false);
                                  GenJnlLine2.TESTFIELD("Bank Payment Type",GenJnlLine2."Bank Payment Type"::"Computer Check");

                                  if GenJnlLine2."Applies-to Doc. No." = '' then begin
                                    DocNo := '';
                                    ExtDocNo := '';
                                    LineAmount := CurrentLineAmount;
                                    LineDiscount := 0;
                                    PostingDesc := GenJnlLine2.Description;
                                  end else
                                    case BalancingType of
                                      BalancingType::"G/L Account":
                                        begin
                                          DocNo := GenJnlLine2."Document No.";
                                          ExtDocNo := GenJnlLine2."External Document No.";
                                          LineAmount := CurrentLineAmount;
                                          LineDiscount := 0;
                                          PostingDesc := GenJnlLine2.Description;
                                        end;
                                      BalancingType::Customer:
                                        begin
                                          CustLedgEntry.RESET;
                                          CustLedgEntry.SETCURRENTKEY("Document No.");
                                          CustLedgEntry.SETRANGE("Document Type",GenJnlLine2."Applies-to Doc. Type");
                                          CustLedgEntry.SETRANGE("Document No.",GenJnlLine2."Applies-to Doc. No.");
                                          CustLedgEntry.SETRANGE("Customer No.",BalancingNo);
                                          CustLedgEntry.FIND('-');
                                          CustUpdateAmounts(CustLedgEntry,CurrentLineAmount);
                                          LineAmount := CurrentLineAmount;
                                        end;
                                      BalancingType::Vendor:
                                        begin
                                          VendLedgEntry.RESET;
                                          VendLedgEntry.SETCURRENTKEY("Document No.");
                                          VendLedgEntry.SETRANGE("Document Type",GenJnlLine2."Applies-to Doc. Type");
                                          VendLedgEntry.SETRANGE("Document No.",GenJnlLine2."Applies-to Doc. No.");
                                          VendLedgEntry.SETRANGE("Vendor No.",BalancingNo);
                                          VendLedgEntry.FIND('-');
                                          VendUpdateAmounts(VendLedgEntry,CurrentLineAmount);
                                          LineAmount := CurrentLineAmount;
                                        end;
                                      BalancingType::"Bank Account":
                                        begin
                                          DocNo := GenJnlLine2."Document No.";
                                          ExtDocNo := GenJnlLine2."External Document No.";
                                          LineAmount := CurrentLineAmount;
                                          LineDiscount := 0;
                                          PostingDesc := GenJnlLine2.Description;
                                        end;
                                    end;

                                  FoundLast := GenJnlLine2.NEXT = 0;
                                end;
                            end;

                          TotalLineAmount := TotalLineAmount + CurrentLineAmount;
                          TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        end else begin
                          if FoundLast then
                            CurrReport.BREAK;
                          FoundLast := true;
                          DocNo := Text010;
                          ExtDocNo := Text010;
                          LineAmount := 0;
                          LineDiscount := 0;
                          PostingDesc := '';
                        end;

                        if DocNo = '' then
                          CurrencyCode2 := GenJnlLine."Currency Code";

                        Stub2LineNo := Stub2LineNo + 1;
                        Stub2DocNo[Stub2LineNo] := DocNo;
                        Stub2DocDate[Stub2LineNo] := DocDate;
                        Stub2LineAmount[Stub2LineNo] := LineAmount;
                        Stub2LineDiscount[Stub2LineNo] := LineDiscount;
                        Stub2PostingDesc[Stub2LineNo] := PostingDesc;
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not TestPrint then
                          if FirstPage then begin
                            FoundLast := true;
                            case ApplyMethod of
                              ApplyMethod::OneLineOneEntry:
                                FoundLast := false;
                              ApplyMethod::OneLineID:
                                case BalancingType of
                                  BalancingType::Customer:
                                    begin
                                      CustLedgEntry.RESET;
                                      CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
                                      CustLedgEntry.SETRANGE("Customer No.",BalancingNo);
                                      CustLedgEntry.SETRANGE(Open,true);
                                      CustLedgEntry.SETRANGE(Positive,true);
                                      CustLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
                                      FoundLast := not CustLedgEntry.FIND('-');
                                      if FoundLast then begin
                                        CustLedgEntry.SETRANGE(Positive,false);
                                        FoundLast := not CustLedgEntry.FIND('-');
                                        FoundNegative := true;
                                      end else
                                        FoundNegative := false;
                                    end;
                                  BalancingType::Vendor:
                                    begin
                                      VendLedgEntry.RESET;
                                      VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
                                      VendLedgEntry.SETRANGE("Vendor No.",BalancingNo);
                                      VendLedgEntry.SETRANGE(Open,true);
                                      VendLedgEntry.SETRANGE(Positive,true);
                                      VendLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
                                      FoundLast := not VendLedgEntry.FIND('-');
                                      if FoundLast then begin
                                        VendLedgEntry.SETRANGE(Positive,false);
                                        FoundLast := not VendLedgEntry.FIND('-');
                                        FoundNegative := true;
                                      end else
                                        FoundNegative := false;
                                    end;
                                end;
                              ApplyMethod::MoreLinesOneEntry:
                                FoundLast := false;
                            end;
                          end else
                            FoundLast := false;

                        if PreprintedStub then begin
                          TotalText := '';
                        end else begin
                          TotalText := Text019;
                          Stub2DocNoHeader := USText011;
                          Stub2DocDateHeader := USText012;
                          Stub2AmountHeader := USText013;
                          Stub2DiscountHeader := USText014;
                          Stub2NetAmountHeader := USText015;
                          Stub2PostingDescHeader := USText017;
                        end;
                        GLSetup.GET;
                        PageNo := PageNo + 1;
                    end;
                }
                dataitem(PrintCheck;"Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(PrnChkCheckToAddr_CheckStyle__CA_5_;PrnChkCheckToAddr[CheckStyle::CA,5])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__CA_4_;PrnChkCheckToAddr[CheckStyle::CA,4])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__CA_3_;PrnChkCheckToAddr[CheckStyle::CA,3])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__CA_2_;PrnChkCheckToAddr[CheckStyle::CA,2])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__CA_1_;PrnChkCheckToAddr[CheckStyle::CA,1])
                    {
                    }  
                    column(PrnChkCheckAmountText_CheckStyle__US_;PrnChkCheckAmountText[CheckStyle::US])
                    {
                    }                
                    column(PrnChkCheckDateText_CheckStyle__US_;PrnChkCheckDateText[CheckStyle::US])
                    {
                    }
                    column(PrnChkDescriptionLine_CheckStyle__US_2_;PrnChkDescriptionLine[CheckStyle::US,2])
                    {
                    }
                    column(PrnChkDescriptionLine_CheckStyle__US_1_;PrnChkDescriptionLine[CheckStyle::US,1])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_1_;PrnChkCheckToAddr[CheckStyle::US,1])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_2_;PrnChkCheckToAddr[CheckStyle::US,2])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_4_;PrnChkCheckToAddr[CheckStyle::US,4])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_3_;PrnChkCheckToAddr[CheckStyle::US,3])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_5_;PrnChkCheckToAddr[CheckStyle::US,5])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_4_;PrnChkCompanyAddr[CheckStyle::US,4])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_6_;PrnChkCompanyAddr[CheckStyle::US,6])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_5_;PrnChkCompanyAddr[CheckStyle::US,5])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_3_;PrnChkCompanyAddr[CheckStyle::US,3])
                    {
                    }
                    column(PrnChkCheckNoText_CheckStyle__US_;PrnChkCheckNoText[CheckStyle::US])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_2_;PrnChkCompanyAddr[CheckStyle::US,2])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_1_;PrnChkCompanyAddr[CheckStyle::US,1])
                    {
                    }
                    column(TotalLineAmount;TotalLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText;TotalText)
                    {
                    }
                    column(PrnChkVoidText_CheckStyle__US_;PrnChkVoidText[CheckStyle::US])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_1_;PrnChkCompanyAddr[CheckStyle::CA,1])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_2_;PrnChkCompanyAddr[CheckStyle::CA,2])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_3_;PrnChkCompanyAddr[CheckStyle::CA,3])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_4_;PrnChkCompanyAddr[CheckStyle::CA,4])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_5_;PrnChkCompanyAddr[CheckStyle::CA,5])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_6_;PrnChkCompanyAddr[CheckStyle::CA,6])
                    {
                    }
                    column(PrnChkDescriptionLine_CheckStyle__CA_1_;PrnChkDescriptionLine[CheckStyle::CA,1])
                    {
                    }
                    column(PrnChkDescriptionLine_CheckStyle__CA_2_;PrnChkDescriptionLine[CheckStyle::CA,2])
                    {
                    }
                    column(PrnChkCheckDateText_CheckStyle__CA_;PrnChkCheckDateText[CheckStyle::CA])
                    {
                    }
                    column(PrnChkDateIndicator_CheckStyle__CA_;PrnChkDateIndicator[CheckStyle::CA])
                    {
                    }
                    column(PrnChkCheckAmountText_CheckStyle__CA_;PrnChkCheckAmountText[CheckStyle::CA])
                    {
                    }
                    column(PrnChkVoidText_CheckStyle__CA_;PrnChkVoidText[CheckStyle::CA])
                    {
                    }
                    column(PrnChkCurrencyCode_CheckStyle__CA_;PrnChkCurrencyCode[CheckStyle::CA])
                    {
                    }
                    column(PrnChkCurrencyCode_CheckStyle__US_;PrnChkCurrencyCode[CheckStyle::US])
                    {
                    }
                    column(CheckNoText_Control1480000;CheckNoText)
                    {
                    }
                    column(CheckDateText_Control1480021;CheckDateText)
                    {
                    }
                    column(CheckToAddr_1__Control1480022;CheckToAddr[1])
                    {
                    }
                    column(Stub2DocNoHeader;Stub2DocNoHeader)
                    {
                    }
                    column(Stub2DocDateHeader;Stub2DocDateHeader)
                    {
                    }
                    column(Stub2AmountHeader;Stub2AmountHeader)
                    {
                    }
                    column(Stub2DiscountHeader;Stub2DiscountHeader)
                    {
                    }
                    column(Stub2NetAmountHeader;Stub2NetAmountHeader)
                    {
                    }
                    column(Stub2LineAmount_1_;Stub2LineAmount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_1_;Stub2LineDiscount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_1____Stub2LineDiscount_1_;Stub2LineAmount[1] + Stub2LineDiscount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_1_;Stub2DocDate[1])
                    {
                    }
                    column(Stub2DocNo_1_;Stub2DocNo[1])
                    {
                    }
                    column(Stub2LineAmount_2_;Stub2LineAmount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_2_;Stub2LineDiscount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_2____Stub2LineDiscount_2_;Stub2LineAmount[2] + Stub2LineDiscount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_2_;Stub2DocDate[2])
                    {
                    }
                    column(Stub2DocNo_2_;Stub2DocNo[2])
                    {
                    }
                    column(Stub2LineAmount_3_;Stub2LineAmount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_3_;Stub2LineDiscount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_3____Stub2LineDiscount_3_;Stub2LineAmount[3] + Stub2LineDiscount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_3_;Stub2DocDate[3])
                    {
                    }
                    column(Stub2DocNo_3_;Stub2DocNo[3])
                    {
                    }
                    column(Stub2LineAmount_4_;Stub2LineAmount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_4_;Stub2LineDiscount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_4____Stub2LineDiscount_4_;Stub2LineAmount[4] + Stub2LineDiscount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_4_;Stub2DocDate[4])
                    {
                    }
                    column(Stub2DocNo_4_;Stub2DocNo[4])
                    {
                    }
                    column(Stub2LineAmount_5_;Stub2LineAmount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_5_;Stub2LineDiscount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_5____Stub2LineDiscount_5_;Stub2LineAmount[5] + Stub2LineDiscount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_5_;Stub2DocDate[5])
                    {
                    }
                    column(Stub2DocNo_5_;Stub2DocNo[5])
                    {
                    }
                    column(Stub2LineAmount_6_;Stub2LineAmount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_6_;Stub2LineDiscount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_6____Stub2LineDiscount_6_;Stub2LineAmount[6] + Stub2LineDiscount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_6_;Stub2DocDate[6])
                    {
                    }
                    column(Stub2DocNo_6_;Stub2DocNo[6])
                    {
                    }
                    column(Stub2LineAmount_7_;Stub2LineAmount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_7_;Stub2LineDiscount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_7____Stub2LineDiscount_7_;Stub2LineAmount[7] + Stub2LineDiscount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_7_;Stub2DocDate[7])
                    {
                    }
                    column(Stub2DocNo_7_;Stub2DocNo[7])
                    {
                    }
                    column(Stub2LineAmount_8_;Stub2LineAmount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_8_;Stub2LineDiscount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_8____Stub2LineDiscount_8_;Stub2LineAmount[8] + Stub2LineDiscount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_8_;Stub2DocDate[8])
                    {
                    }
                    column(Stub2DocNo_8_;Stub2DocNo[8])
                    {
                    }
                    column(Stub2LineAmount_9_;Stub2LineAmount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_9_;Stub2LineDiscount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_9____Stub2LineDiscount_9_;Stub2LineAmount[9] + Stub2LineDiscount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_9_;Stub2DocDate[9])
                    {
                    }
                    column(Stub2DocNo_9_;Stub2DocNo[9])
                    {
                    }
                    column(Stub2LineAmount_10_;Stub2LineAmount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_10_;Stub2LineDiscount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_10____Stub2LineDiscount_10_;Stub2LineAmount[10] + Stub2LineDiscount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_10_;Stub2DocDate[10])
                    {
                    }
                    column(Stub2DocNo_10_;Stub2DocNo[10])
                    {
                    }
                    column(TotalLineAmount_Control1480082;TotalLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText_Control1480083;TotalText)
                    {
                    }
                    column(Stub2PostingDescHeader;Stub2PostingDescHeader)
                    {
                    }
                    column(Stub2PostingDesc_1_;Stub2PostingDesc[1])
                    {
                    }
                    column(Stub2PostingDesc_2_;Stub2PostingDesc[2])
                    {
                    }
                    column(Stub2PostingDesc_4_;Stub2PostingDesc[4])
                    {
                    }
                    column(Stub2PostingDesc_3_;Stub2PostingDesc[3])
                    {
                    }
                    column(Stub2PostingDesc_8_;Stub2PostingDesc[8])
                    {
                    }
                    column(Stub2PostingDesc_7_;Stub2PostingDesc[7])
                    {
                    }
                    column(Stub2PostingDesc_6_;Stub2PostingDesc[6])
                    {
                    }
                    column(Stub2PostingDesc_5_;Stub2PostingDesc[5])
                    {
                    }
                    column(Stub2PostingDesc_10_;Stub2PostingDesc[10])
                    {
                    }
                    column(Stub2PostingDesc_9_;Stub2PostingDesc[9])
                    {
                    }
                    column(CheckToAddr_5_;CheckToAddr[5])
                    {
                    }
                    column(CheckToAddr_4_;CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr_3_;CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr_2_;CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr_01_;CheckToAddr[1])
                    {
                    }
                    column(VoidText;VoidText)
                    {
                    }
                    column(BankCurrencyCode;BankCurrencyCode)
                    {
                    }
                    column(DollarSignBefore_CheckAmountText_DollarSignAfter;DollarSignBefore + CheckAmountText + DollarSignAfter)
                    {
                    }
                    column(DescriptionLine_1__;DescriptionLine[1])
                    {
                    }
                    column(DescriptionLine_2__;DescriptionLine[2])
                    {
                    }
                    column(DateIndicator;DateIndicator)
                    {
                    }
                    column(CheckDateText_Control1020013;CheckDateText)
                    {
                    }
                    column(CheckNoText_Control1020014;CheckNoText)
                    {
                    }
                    column(CompanyAddr_6_;CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr_5_;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_4_;CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr_3_;CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_2_;CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_1_;CompanyAddr[1])
                    {
                    }
                    column(CheckStyleIndex;CheckStyleIndex)
                    {
                    }
                    column(CompanyAddr_7_;CompanyAddr[7])
                    {
                    }
                    column(PrintCheck_Number;Number)
                    {
                    }
                    column(CheckNoText_Control1480000Caption;CheckNoText_Control1480000CaptionLbl)
                    {
                    }
                    column(PrintSignature_;PrintSignature)
                    {
                    }

                    trigger OnAfterGetRecord();
                    var
                        CurrencySymbol : Code[5];
                    begin
                        if not TestPrint then
                          with GenJnlLine do begin
                            CheckLedgEntry.INIT;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := "Posting Date";
                            CheckLedgEntry."Document Type" := "Document Type";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := CheckToAddr[1];
                            CheckLedgEntry."Bank Payment Type" := "Bank Payment Type";
                            CheckLedgEntry."Bal. Account Type" := BalancingType;
                            CheckLedgEntry."Bal. Account No." := BalancingNo;
                            if FoundLast then begin
                              if TotalLineAmount < 0 then
                                ERROR(
                                  Text020,
                                  UseCheckNo,TotalLineAmount);
                              CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                              CheckLedgEntry.Amount := TotalLineAmount;
                            end else begin
                              CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Voided;
                              CheckLedgEntry.Amount := 0;
                            end;
                            CheckLedgEntry."Check Date" := "Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry,RECORDID);

                            if FoundLast then begin
                              CheckAmountText := CheckLedgEntry.GetCheckAmountText(BankAcc2."Currency Code",CurrencySymbol);
                              if CheckLanguage = 3084 then begin   // French
                                DollarSignBefore := '';
                                DollarSignAfter := CurrencySymbol;
                              end else begin
                                DollarSignBefore := CurrencySymbol;
                                DollarSignAfter := ' ';
                              end;
                              if not ChkTransMgt.FormatNoText(DescriptionLine,CheckLedgEntry.Amount,CheckLanguage,BankAcc2."Currency Code") then
                                ERROR(DescriptionLine[1]);
                              VoidText := '';
                            // >> EC1.06
                            DollarSignBefore := '';
                            // << EC1.06
                            end else begin
                              CLEAR(CheckAmountText);
                              CLEAR(DescriptionLine);
                              DescriptionLine[1] := Text021;
                              DescriptionLine[2] := DescriptionLine[1];
                              VoidText := Text022;
                            end;
                          end
                        else
                          with GenJnlLine do begin
                            CheckLedgEntry.INIT;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := "Posting Date";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := Text023;
                            CheckLedgEntry."Bank Payment Type" := "Bank Payment Type"::"Computer Check";
                            CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::"Test Print";
                            CheckLedgEntry."Check Date" := "Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry,RECORDID);

                            CheckAmountText := Text024;
                            DescriptionLine[1] := Text025;
                            DescriptionLine[2] := DescriptionLine[1];
                            VoidText := Text022;
                          end;

                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := false;

                        CLEAR(PrnChkCompanyAddr);
                        CLEAR(PrnChkCheckToAddr);
                        CLEAR(PrnChkCheckNoText);
                        CLEAR(PrnChkCheckDateText);
                        CLEAR(PrnChkDescriptionLine);
                        CLEAR(PrnChkVoidText);
                        CLEAR(PrnChkDateIndicator);
                        CLEAR(PrnChkCurrencyCode);
                        CLEAR(PrnChkCheckAmountText);
                        COPYARRAY(PrnChkCompanyAddr[CheckStyle],CompanyAddr,1);
                        COPYARRAY(PrnChkCheckToAddr[CheckStyle],CheckToAddr,1);
                        PrnChkCheckNoText[CheckStyle] := CheckNoText;
                        PrnChkCheckDateText[CheckStyle] := CheckDateText;
                        COPYARRAY(PrnChkDescriptionLine[CheckStyle],DescriptionLine,1);
                        PrnChkVoidText[CheckStyle] := VoidText;
                        PrnChkDateIndicator[CheckStyle] := DateIndicator;
                        PrnChkCurrencyCode[CheckStyle] := BankAcc2."Currency Code";
                        StartingLen := STRLEN(CheckAmountText);
                        if CheckStyle = CheckStyle::US then
                          ControlLen := 27
                        else
                          ControlLen := 29;
                        CheckAmountText := CheckAmountText + DollarSignBefore + DollarSignAfter;
                        Index := 0;
                        if CheckAmountText = Text024 then begin
                          if STRLEN(CheckAmountText) < (ControlLen - 12) then begin
                            repeat
                              Index := Index + 1;
                              CheckAmountText := INSSTR(CheckAmountText,'*',STRLEN(CheckAmountText) + 1);
                            until (Index = ControlLen) or (STRLEN(CheckAmountText) >= (ControlLen - 12))
                          end;
                        end else
                          if STRLEN(CheckAmountText) < (ControlLen - 11) then begin
                            repeat
                              Index := Index + 1;
                              CheckAmountText := INSSTR(CheckAmountText,'*',STRLEN(CheckAmountText) + 1);
                            until (Index = ControlLen) or (STRLEN(CheckAmountText) >= (ControlLen - 11))
                          end;
                        CheckAmountText :=
                          DELSTR(CheckAmountText,StartingLen + 1,STRLEN(DollarSignBefore + DollarSignAfter));
                        NewLen := STRLEN(CheckAmountText);
                        if NewLen <> StartingLen then
                          CheckAmountText :=
                            COPYSTR(CheckAmountText,StartingLen + 1) +
                            COPYSTR(CheckAmountText,1,StartingLen);
                        PrnChkCheckAmountText[CheckStyle] :=
                          DollarSignBefore + CheckAmountText + DollarSignAfter;

                        if CheckStyle = CheckStyle::CA then
                          CheckStyleIndex := 0
                        else
                          CheckStyleIndex := 1;

                        // >> EC1.08
                        // IF TotalLineAmount < PurchPayablesSetup."Check Signature Threshold" THEN BEGIN
                        //  CompanyInfo.CALCFIELDS("Check Signature 1");
                        //  CompanyInfo.CALCFIELDS("Check Signature 2");
                        // END;

                        // << EC1.08
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    if FoundLast then
                      CurrReport.BREAK;

                    UseCheckNo := INCSTR(UseCheckNo);
                    if not TestPrint then
                      CheckNoText := UseCheckNo
                    else
                      CheckNoText := Text011;

                    Stub2LineNo := 0;
                    CLEAR(Stub2DocNo);
                    CLEAR(Stub2DocDate);
                    CLEAR(Stub2LineAmount);
                    CLEAR(Stub2LineDiscount);
                    CLEAR(Stub2PostingDesc);
                    Stub2DocNoHeader := '';
                    Stub2DocDateHeader := '';
                    Stub2AmountHeader := '';
                    Stub2DiscountHeader := '';
                    Stub2NetAmountHeader := '';
                    Stub2PostingDescHeader := '';
                end;

                trigger OnPostDataItem();
                begin
                    if not TestPrint then begin
                      if UseCheckNo <> GenJnlLine."Document No." then begin
                        GenJnlLine3.RESET;
                        GenJnlLine3.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
                        GenJnlLine3.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                        GenJnlLine3.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
                        GenJnlLine3.SETRANGE("Posting Date",GenJnlLine."Posting Date");
                        GenJnlLine3.SETRANGE("Document No.",UseCheckNo);
                        if GenJnlLine3.FIND('-') then
                          GenJnlLine3.FIELDERROR("Document No.",STRSUBSTNO(Text013,UseCheckNo));
                      end;

                      if ApplyMethod <> ApplyMethod::MoreLinesOneEntry then begin
                        GenJnlLine3 := GenJnlLine;
                        GenJnlLine3.TESTFIELD("Posting No. Series",'');
                        GenJnlLine3."Document No." := UseCheckNo;
                        GenJnlLine3."Check Printed" := true;
                        GenJnlLine3.MODIFY;
                      end else begin
                        "TotalLineAmount$" := 0;
                        if GenJnlLine2.FIND('-') then begin
                          HighestLineNo := GenJnlLine2."Line No.";
                          repeat
                            if BankAcc2."Currency Code" <> GenJnlLine2."Currency Code" then
                              ERROR(Text005);
                            if GenJnlLine2."Line No." > HighestLineNo then
                              HighestLineNo := GenJnlLine2."Line No.";
                            GenJnlLine3 := GenJnlLine2;
                            GenJnlLine3.TESTFIELD("Posting No. Series",'');
                            GenJnlLine3."Bal. Account No." := '';
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::" ";
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Check Printed" := true;
                            GenJnlLine3.VALIDATE(Amount);
                            "TotalLineAmount$" := "TotalLineAmount$" + GenJnlLine3."Amount (LCY)";
                            GenJnlLine3.MODIFY;
                          until GenJnlLine2.NEXT = 0;
                        end;

                        GenJnlLine3.RESET;
                        GenJnlLine3 := GenJnlLine;
                        GenJnlLine3.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                        GenJnlLine3.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
                        GenJnlLine3."Line No." := HighestLineNo;
                        if GenJnlLine3.NEXT = 0 then
                          GenJnlLine3."Line No." := HighestLineNo + 10000
                        else begin
                          while GenJnlLine3."Line No." = HighestLineNo + 1 do begin
                            HighestLineNo := GenJnlLine3."Line No.";
                            if GenJnlLine3.NEXT = 0 then
                              GenJnlLine3."Line No." := HighestLineNo + 20000;
                          end;
                          GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) div 2;
                        end;
                        GenJnlLine3.INIT;
                        GenJnlLine3.VALIDATE("Posting Date",GenJnlLine."Posting Date");
                        GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                        GenJnlLine3."Document No." := UseCheckNo;
                        GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::"Bank Account";
                        GenJnlLine3.VALIDATE("Account No.",BankAcc2."No.");
                        if BalancingType <> BalancingType::"G/L Account" then
                          GenJnlLine3.Description := STRSUBSTNO(Text014,SELECTSTR(BalancingType + 1,Text062),BalancingNo);
                        GenJnlLine3.VALIDATE(Amount,-TotalLineAmount);
                        if TotalLineAmount <> "TotalLineAmount$" then
                          GenJnlLine3.VALIDATE("Amount (LCY)",-"TotalLineAmount$");
                        GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::"Computer Check";
                        GenJnlLine3."Check Printed" := true;
                        GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                        GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                        GenJnlLine3."Allow Zero-Amount Posting" := true;
                        GenJnlLine3."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                        GenJnlLine3."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                        GenJnlLine3."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                        GenJnlLine3.INSERT;
                      end;
                    end;

                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.MODIFY;
                    if CommitEachCheck then begin
                      COMMIT;
                      CLEAR(CheckManagement);
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    FirstPage := true;
                    FoundLast := false;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if OneCheckPrVendor and ("Currency Code" <> '') and
                   ("Currency Code" <> Currency.Code)
                then begin
                  Currency.GET("Currency Code");
                  Currency.TESTFIELD("Conv. LCY Rndg. Debit Acc.");
                  Currency.TESTFIELD("Conv. LCY Rndg. Credit Acc.");
                end;

                if not TestPrint then begin
                  if Amount = 0 then
                    CurrReport.SKIP;

                  TESTFIELD("Bal. Account Type","Bal. Account Type"::"Bank Account");
                  if "Bal. Account No." <> BankAcc2."No." then
                    CurrReport.SKIP;

                  if ("Account No." <> '') and ("Bal. Account No." <> '') then begin
                    BalancingType := "Account Type";
                    BalancingNo := "Account No.";
                    RemainingAmount := Amount;
                    if OneCheckPrVendor then begin
                      ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                      GenJnlLine2.RESET;
                      GenJnlLine2.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
                      GenJnlLine2.SETRANGE("Journal Template Name","Journal Template Name");
                      GenJnlLine2.SETRANGE("Journal Batch Name","Journal Batch Name");
                      GenJnlLine2.SETRANGE("Posting Date","Posting Date");
                      GenJnlLine2.SETRANGE("Document No.","Document No.");
                      GenJnlLine2.SETRANGE("Account Type","Account Type");
                      GenJnlLine2.SETRANGE("Account No.","Account No.");
                      GenJnlLine2.SETRANGE("Bal. Account Type","Bal. Account Type");
                      GenJnlLine2.SETRANGE("Bal. Account No.","Bal. Account No.");
                      GenJnlLine2.SETRANGE("Bank Payment Type","Bank Payment Type");
                      GenJnlLine2.FIND('-');
                      RemainingAmount := 0;
                    end else
                      if "Applies-to Doc. No." <> '' then
                        ApplyMethod := ApplyMethod::OneLineOneEntry
                      else
                        if "Applies-to ID" <> '' then
                          ApplyMethod := ApplyMethod::OneLineID
                        else
                          ApplyMethod := ApplyMethod::Payment;
                  end else
                    if "Account No." = '' then
                      FIELDERROR("Account No.",Text004)
                    else
                      FIELDERROR("Bal. Account No.",Text004);

                  CLEAR(CheckToAddr);
                  CLEAR(SalesPurchPerson);
                  case BalancingType of
                    BalancingType::"G/L Account":
                      begin
                        CheckToAddr[1] := Description;
                        ChkTransMgt.SetCheckPrintParams(
                          BankAcc2."Check Date Format",
                          BankAcc2."Check Date Separator",
                          BankAcc2."Country/Region Code",
                          BankAcc2."Bank Communication",
                          CheckToAddr[1],
                          CheckDateFormat,
                          DateSeparator,
                          CheckLanguage,
                          CheckStyle);
                      end;
                    BalancingType::Customer:
                      begin
                        Cust.GET(BalancingNo);
                        if Cust.Blocked = Cust.Blocked::All then
                          ERROR(Text064,Cust.FIELDCAPTION(Blocked),Cust.Blocked,Cust.TABLECAPTION,Cust."No.");
                        Cust.Contact := '';
                        FormatAddr.Customer(CheckToAddr,Cust);
                        if BankAcc2."Currency Code" <> "Currency Code" then
                          ERROR(Text005);
                        if Cust."Salesperson Code" <> '' then
                          SalesPurchPerson.GET(Cust."Salesperson Code");
                        ChkTransMgt.SetCheckPrintParams(
                          Cust."Check Date Format",
                          Cust."Check Date Separator",
                          BankAcc2."Country/Region Code",
                          Cust."Bank Communication",
                          CheckToAddr[1],
                          CheckDateFormat,
                          DateSeparator,
                          CheckLanguage,
                          CheckStyle);
                      end;
                    BalancingType::Vendor:
                      begin
                        Vend.GET(BalancingNo);
                        if Vend.Blocked in [Vend.Blocked::All,Vend.Blocked::Payment] then
                          ERROR(Text064,Vend.FIELDCAPTION(Blocked),Vend.Blocked,Vend.TABLECAPTION,Vend."No.");
                        Vend.Contact := '';
                        FormatAddr.Vendor(CheckToAddr,Vend);
                        if BankAcc2."Currency Code" <> "Currency Code" then
                          ERROR(Text005);
                        if Vend."Purchaser Code" <> '' then
                          SalesPurchPerson.GET(Vend."Purchaser Code");
                        ChkTransMgt.SetCheckPrintParams(
                          Vend."Check Date Format",
                          Vend."Check Date Separator",
                          BankAcc2."Country/Region Code",
                          Vend."Bank Communication",
                          CheckToAddr[1],
                          CheckDateFormat,
                          DateSeparator,
                          CheckLanguage,
                          CheckStyle);
                      end;
                    BalancingType::"Bank Account":
                      begin
                        BankAcc.GET(BalancingNo);
                        BankAcc.TESTFIELD(Blocked,false);
                        BankAcc.Contact := '';
                        FormatAddr.BankAcc(CheckToAddr,BankAcc);
                        if BankAcc2."Currency Code" <> BankAcc."Currency Code" then
                          ERROR(Text008);
                        if BankAcc."Our Contact Code" <> '' then
                          SalesPurchPerson.GET(BankAcc."Our Contact Code");
                        ChkTransMgt.SetCheckPrintParams(
                          BankAcc."Check Date Format",
                          BankAcc."Check Date Separator",
                          BankAcc2."Country/Region Code",
                          BankAcc."Bank Communication",
                          CheckToAddr[1],
                          CheckDateFormat,
                          DateSeparator,
                          CheckLanguage,
                          CheckStyle);
                      end;
                  end;

                  CheckDateText :=
                    ChkTransMgt.FormatDate("Posting Date",CheckDateFormat,DateSeparator,CheckLanguage,DateIndicator);
                end else begin
                  if ChecksPrinted > 0 then
                    CurrReport.BREAK;
                  ChkTransMgt.SetCheckPrintParams(
                    BankAcc2."Check Date Format",
                    BankAcc2."Check Date Separator",
                    BankAcc2."Country/Region Code",
                    BankAcc2."Bank Communication",
                    CheckToAddr[1],
                    CheckDateFormat,
                    DateSeparator,
                    CheckLanguage,
                    CheckStyle);
                  BalancingType := BalancingType::Vendor;
                  BalancingNo := Text010;
                  CLEAR(CheckToAddr);
                  for i := 1 to 5 do
                    CheckToAddr[i] := Text003;
                  CLEAR(SalesPurchPerson);
                  CheckNoText := Text011;
                  if CheckStyle = CheckStyle::CA then
                    CheckDateText := DateIndicator
                  else
                    CheckDateText := Text010;
                end;
            end;

            trigger OnPreDataItem();
            var
                CompanyInfo : Record "Company Information";
            begin
                COPY(VoidGenJnlLine);
                CompanyInfo.GET;
                if not TestPrint then begin
                  FormatAddr.Company(CompanyAddr,CompanyInfo);
                  BankAcc2.GET(BankAcc2."No.");
                  BankAcc2.TESTFIELD(Blocked,false);
                  COPY(VoidGenJnlLine);
                  SETRANGE("Bank Payment Type","Bank Payment Type"::"Computer Check");
                  SETRANGE("Check Printed",false);
                end else begin
                  CLEAR(CompanyAddr);
                  for i := 1 to 5 do
                    CompanyAddr[i] := Text003;
                end;
                ChecksPrinted := 0;

                SETRANGE("Account Type","Account Type"::"Fixed Asset");
                if FIND('-') then
                  FIELDERROR("Account Type");
                SETRANGE("Account Type");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    CaptionML = ENU='Options',
                                ESM='Opciones',
                                FRC='Options',
                                ENC='Options';
                    field(BankAccount;BankAcc2."No.")
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Bank Account',
                                    ESM='Banco',
                                    FRC='Compte bancaire',
                                    ENC='Bank Account';
                        TableRelation = "Bank Account";
                        ToolTipML = ENU='Specifies the bank account that the check will be drawn from.',
                                    ESM='Especifica la cuenta bancaria desde la que se gira el cheque.',
                                    FRC='Indique le compte bancaire à partir duquel le chèque sera tiré.',
                                    ENC='Specifies the bank account that the cheque will be drawn from.';

                        trigger OnValidate();
                        begin
                            if BankAcc2."No." <> '' then begin
                              BankAcc2.GET(BankAcc2."No.");
                              BankAcc2.TESTFIELD("Last Check No.");
                              UseCheckNo := BankAcc2."Last Check No.";
                            end;
                        end;
                    }
                    field(UseCheckNo;UseCheckNo)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Last Check No.',
                                    ESM='Òlt. nº cheque',
                                    FRC='N° du dernier chèque',
                                    ENC='Last Cheque No.';
                        ToolTipML = ENU='Specifies the number of the last check that was issued. If you have entered a number in the Last Check No. field in the Bank Account Card window, the number will appear here when you fill in the Bank Account field.',
                                    ESM='Especifica el número del último cheque emitido. Si especificó un número en el campo Òlt. nº cheque de la ventana Ficha banco, el número aparecerá aquí cuando rellene el campo Banco.',
                                    FRC='Spécifie le numéro du dernière chèque qui a été émis. Si vous avez entré un numéro dans le champ N° du dernier chèque de la fenêtre Fiche compte bancaire, le numéro apparaîtra ici lorsque vous renseignez le champ Compte bancaire.',
                                    ENC='Specifies the number of the last cheque that was issued. If you have entered a number in the Last Cheque No. field in the Bank Account Card window, the number will appear here when you fill in the Bank Account field.';
                    }
                    field(OneCheckPerVendorPerDocumentNo;OneCheckPrVendor)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='One Check per Vendor per Document No.',
                                    ESM='Un cheque por proveedor y nº documento',
                                    FRC='Un chèque par fournisseur par n° document',
                                    ENC='One Cheque per Vendor per Document No.';
                        MultiLine = true;
                        ToolTipML = ENU='Specifies if only one check is printed per vendor for each document number.',
                                    ESM='Especifica si se imprime un solo cheque por proveedor para cada número de documento.',
                                    FRC='Spécifie si un seul chèque est imprimé par fournisseur pour chaque numéro de document.',
                                    ENC='Specifies if only one cheque is printed per vendor for each document number.';
                    }
                    field(ReprintChecks;ReprintChecks)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Reprint Checks',
                                    ESM='Reimprimir cheques',
                                    FRC='Réimprimer les chèques',
                                    ENC='Reprint Cheques';
                        ToolTipML = ENU='Specifies if checks are printed again if you canceled the printing due to a problem.',
                                    ESM='Especifica si los cheques se vuelven a imprimir si canceló la impresión debido a un problema.',
                                    FRC='Spécifie si des chèques sont réimprimés si un problème vous a obligé à annuler l''impression.',
                                    ENC='Specifies if cheques are printed again if you cancelled the printing due to a problem.';
                    }
                    field(TestPrint;TestPrint)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Test Print',
                                    ESM='Test impresión',
                                    FRC='Épreuve',
                                    ENC='Test Print';
                        ToolTipML = ENU='Specifies if you want to print the checks on blank paper before you print them on check forms.',
                                    ESM='Especifica si desea imprimir los cheques sobre papel en blanco antes de imprimirlos sobre formularios de cheque.',
                                    FRC='Spécifie si vous souhaitez imprimer les chèques sur du papier blanc avant de les imprimer sur des formulaires appropriés.',
                                    ENC='Specifies if you want to print the cheques on blank paper before you print them on cheque forms.';
                    }
                    field(PreprintedStub;PreprintedStub)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Preprinted Stub',
                                    ESM='Serie preimpresa',
                                    FRC='Talon pré-imprimé',
                                    ENC='Preprinted Stub';
                        ToolTipML = ENU='Specifies if you use check forms with preprinted stubs.',
                                    ESM='Especifica si se usan formularios de cheque con series preimpresas.',
                                    FRC='Spécifie si vous utilisez des formulaires de chèque avec parties préimprimées.',
                                    ENC='Specifies if you use cheque forms with preprinted stubs.';
                    }
                    field(CommitEachCheck;CommitEachCheck)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Commit Each Check',
                                    ESM='Emitir cada cheque',
                                    FRC='Déposer chaque chèque',
                                    ENC='Commit Each Cheque';
                        ToolTipML = ENU='Specifies if you want each check to commit to the database after printing instead of at the end of the print job. This allows you to avoid differences between the data and check stock on networks where the print job is cached.',
                                    ESM='Especifica si desea que cada cheque se confirme en la base de datos después de su impresión, en lugar de al final del trabajo de impresión. De este modo, se evita que se produzcan diferencias entre los datos y las existencias de cheques en las redes donde está almacenado en caché el trabajo de impresión.',
                                    FRC='Spécifie si vous souhaitez que chaque chèque soit déposé dans la base de données après impression plutôt qu''à la fin du travail d''impression. Cela vous permet d''éviter les différences entre les stocks de chèques et de données sur les réseaux où le travail d''impression est mis en cache.',
                                    ENC='Specifies if you want each cheque to commit to the database after printing instead of at the end of the print job. This allows you to avoid differences between the data and check stock on networks where the print job is cached.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            if BankAcc2."No." <> '' then
              if BankAcc2.GET(BankAcc2."No.") then
                UseCheckNo := BankAcc2."Last Check No."
              else begin
                BankAcc2."No." := '';
                UseCheckNo := '';
              end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        GenJnlTemplate.GET(VoidGenJnlLine.GETFILTER("Journal Template Name"));
        if not GenJnlTemplate."Force Doc. Balance" then
          if not CONFIRM(USText001,true) then
            ERROR(USText002);

        PageNo := 0;

        // >> EC1.08
        //CompanyInfo.GET;
        //CompanyInfo.TESTFIELD("Check Signature 1");
        //CompanyInfo.TESTFIELD("Check Signature 2");

        //PurchPayablesSetup.GET;
        //PurchPayablesSetup.TESTFIELD("Check Signature Threshold");
        // << EC1.08
    end;

    var
        Text000 : TextConst ENU='Preview is not allowed.',ESM='No está permitida la vista preliminar.',FRC='Impossible d''afficher à l''écran.',ENC='Preview is not allowed.';
        Text001 : TextConst ENU='Last Check No. must be filled in.',ESM='Debe rellenar el últ. nº cheque.',FRC='Le numéro du dernier chèque doit être renseigné.',ENC='Last Cheque No. must be filled in.';
        Text002 : TextConst ENU='Filters on %1 and %2 are not allowed.',ESM='No están permitidos filtros en %1 y %2.',FRC='Les filtres sur %1 et %2 ne sont pas permis.',ENC='Filters on %1 and %2 are not allowed.';
        Text003 : TextConst ENU='XXXXXXXXXXXXXXXX',ESM='XXXXXXXXXXXXXXXX',FRC='XXXXXXXXXXXXXXXX',ENC='XXXXXXXXXXXXXXXX';
        Text004 : TextConst ENU='must be entered.',ESM='se debe introducir.',FRC='doit être entré',ENC='must be entered.';
        Text005 : TextConst ENU='The Bank Account and the General Journal Line must have the same currency.',ESM='El banco y el registro línea deben tener la misma divisa.',FRC='Le compte bancaire et la ligne du journal général doivent avoir la même devise.',ENC='The Bank Account and the General Journal Line must have the same currency.';
        Text008 : TextConst ENU='Both Bank Accounts must have the same currency.',ESM='Ambos bancos deben tener la misma divisa.',FRC='Les deux comptes bancaires doivent avoir la même devise.',ENC='Both Bank Accounts must have the same currency.';
        Text010 : TextConst ENU='XXXXXXXXXX',ESM='XXXXXXXXXX',FRC='XXXXXXXXXX',ENC='XXXXXXXXXX';
        Text011 : TextConst ENU='XXXX',ESM='XXXX',FRC='XXXX',ENC='XXXX';
        Text013 : TextConst ENU='%1 already exists.',ESM='Ya existe %1.',FRC='%1 existe déjà.',ENC='%1 already exists.';
        Text014 : TextConst ENU='Check for %1 %2',ESM='Cheque para %1 %2',FRC='Vérifiez pour %1 %2',ENC='Check for %1 %2';
        Text016 : TextConst ENU='In the Check report, One Check per Vendor and Document No.\',ESM='En informe de cheques, Un cheque por proveedor y nº documento\',FRC='Dans l''état Chèque, un chèque par fournisseur et par n° document\',ENC='In the Cheque report, One Cheque per Vendor and Document No.\';
        Text017 : TextConst ENU='must not be activated when Applies-to ID is specified in the journal lines.',ESM='no se debe activar cuando se ha usado Liq. por id. en las líneas de diario.',FRC='ne doit pas être activé lorsque Code affecté à est spécifié dans les lignes du journal.',ENC='must not be activated when Applies-to ID is specified in the journal lines.';
        Text019 : TextConst ENU='Total',ESM='Total',FRC='Total',ENC='Total';
        Text020 : TextConst ENU='The total amount of check %1 is %2. The amount must be positive.',ESM='El importe total del cheque %1 es %2. El importe debe ser positivo.',FRC='Le montant total du chèque %1 est de %2. Le montant doit être positif.',ENC='The total amount of cheque %1 is %2. The amount must be positive.';
        Text021 : TextConst ENU='VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID',ESM='ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO',FRC='ANNULÉ ANNULÉ ANNULÉ ANNULÉ ANNULÉ ANNULÉ ANNULÉ ANNULÉ ANNULÉ ANNULÉ ANNULÉ',ENC='VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022 : TextConst ENU='NON-NEGOTIABLE',ESM='NO NEGOCIABLE',FRC='NON NÉGOCIABLE',ENC='NON-NEGOTIABLE';
        Text023 : TextConst ENU='Test print',ESM='Test impresión',FRC='Épreuve',ENC='Test print';
        Text024 : TextConst ENU='XXXX.XX',ESM='XXXX.XX',FRC='XXXX.XX',ENC='XXXX.XX';
        Text025 : TextConst ENU='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',ESM='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',FRC='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',ENC='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text030 : TextConst ENU=' is already applied to %1 %2 for customer %3.',ESM=' ya se aplicó a %1 %2 para el cliente %3.',FRC=' est déjà appliqué à %1 %2 pour le client %3.',ENC=' is already applied to %1 %2 for customer %3.';
        Text031 : TextConst ENU=' is already applied to %1 %2 for vendor %3.',ESM=' ya se aplicó a %1 %2 para el proveedor %3.',FRC=' est déjà appliqué à %1 %2 pour le fournisseur %3.',ENC=' is already applied to %1 %2 for vendor %3.';
        SalesPurchPerson : Record "Salesperson/Purchaser";
        GenJnlLine2 : Record "Gen. Journal Line";
        GenJnlLine3 : Record "Gen. Journal Line";
        Cust : Record Customer;
        CustLedgEntry : Record "Cust. Ledger Entry";
        Vend : Record Vendor;
        VendLedgEntry : Record "Vendor Ledger Entry";
        BankAcc : Record "Bank Account";
        BankAcc2 : Record "Bank Account";
        CheckLedgEntry : Record "Check Ledger Entry";
        Currency : Record Currency;
        GenJnlTemplate : Record "Gen. Journal Template";
        FormatAddr : Codeunit "Format Address";
        CheckManagement : Codeunit CheckManagement;
        ChkTransMgt : Report "Check Translation Management";
        CompanyAddr : array [8] of Text[50];
        CheckToAddr : array [8] of Text[50];
        BalancingType : Option "G/L Account",Customer,Vendor,"Bank Account";
        BalancingNo : Code[20];
        CheckNoText : Text[30];
        CheckDateText : Text[30];
        CheckAmountText : Text[30];
        DescriptionLine : array [2] of Text[80];
        DocNo : Text[30];
        ExtDocNo : Text[30];
        VoidText : Text[30];
        LineAmount : Decimal;
        LineDiscount : Decimal;
        TotalLineAmount : Decimal;
        "TotalLineAmount$" : Decimal;
        TotalLineDiscount : Decimal;
        RemainingAmount : Decimal;
        CurrentLineAmount : Decimal;
        UseCheckNo : Code[20];
        FoundLast : Boolean;
        ReprintChecks : Boolean;
        TestPrint : Boolean;
        FirstPage : Boolean;
        OneCheckPrVendor : Boolean;
        FoundNegative : Boolean;
        CommitEachCheck : Boolean;
        ApplyMethod : Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted : Integer;
        HighestLineNo : Integer;
        PreprintedStub : Boolean;
        TotalText : Text[10];
        DocDate : Date;
        i : Integer;
        CurrencyCode2 : Code[10];
        CurrencyExchangeRate : Record "Currency Exchange Rate";
        LineAmount2 : Decimal;
        GLSetup : Record "General Ledger Setup";
        Text064 : TextConst ENU='%1 must not be %2 for %3 %4.',ESM='%1 no debe ser %2 para %3 %4.',FRC='%1 ne doit pas être %2 lorsque %3 %4.',ENC='%1 must not be %2 for %3 %4.';
        Text062 : TextConst ENU='G/L Account,Customer,Vendor,Bank Account',ESM='Cuenta,Cliente,Proveedor,Banco',FRC='Compte du grand livre,Client,Fournisseur,Compte bancaire',ENC='G/L Account,Customer,Vendor,Bank Account';
        USText001 : TextConst ENU='Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?',ESM='Aviso:  los cheques no podrán anularse si Forzar saldo por nº documento está establecido en No en el Libro diario. ¿Desea continuar?',FRC='Avertissement : impossible d''annuler financièrement un chèque lorsque le paramètre Forcer équilibre doc. est défini à Non dans le modèle de journal. Souhaitez-vous poursuivre quand même?',ENC='Warning:  Cheques cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?';
        USText002 : TextConst ENU='Process canceled at user request.',ESM='Proceso cancelado a petición del usuario.',FRC='Processus annulé à la demande de l''utilisateur.',ENC='Process cancelled at user request.';
        USText004 : TextConst ENU='Last Check No. must include at least one digit, so that it can be incremented.',ESM='El último N° de cheque debe incluir al menos un dígito, de modo que pueda ser incrementado.',FRC='Le n° du dernier chèque doit comprendre au moins un chiffre afin de pouvoir être incrémenté.',ENC='Last Cheque No. must include at least one digit, so that it can be incremented.';
        DateIndicator : Text[10];
        CheckDateFormat : Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD";
        CheckStyle : Option US,CA;
        CheckLanguage : Integer;
        DateSeparator : Option " ","-",".","/";
        DollarSignBefore : Code[5];
        DollarSignAfter : Code[5];
        PrnChkCompanyAddr : array [2,8] of Text[50];
        PrnChkCheckToAddr : array [2,8] of Text[50];
        PrnChkCheckNoText : array [2] of Text[30];
        PrnChkCheckDateText : array [2] of Text[30];
        PrnChkCheckAmountText : array [2] of Text[30];
        PrnChkDescriptionLine : array [2,2] of Text[80];
        PrnChkVoidText : array [2] of Text[30];
        PrnChkDateIndicator : array [2] of Text[10];
        PrnChkCurrencyCode : array [2] of Code[10];
        USText006 : TextConst ENU='You cannot use the <blank> %1 option with a Canadian style check. Please check %2 %3.',ESM='No puede usar la opción %1 <blank> con un corrector de estilo canadiense. Compruebe %2 %3.',FRC='Vous ne pouvez pas utiliser l''option %1 <vide> avec un chèque canadien. Veuillez vérifier %2 %3',ENC='You cannot use the <blank> %1 option with a Canadian style cheque. Please check %2 %3.';
        USText007 : TextConst ENU='You cannot use the Spanish %1 option with a Canadian style check. Please check %2 %3.',ESM='No puede usar la opción %1 Español con un corrector de estilo canadiense. Compruebe %2 %3.',FRC='Vous ne pouvez pas utiliser l''option %1 Espagnol avec un chèque canadien. Veuillez vérifier %2 %3',ENC='You cannot use the Spanish %1 option with a Canadian style cheque. Please check %2 %3.';
        Stub2LineNo : Integer;
        Stub2DocNo : array [50] of Text[30];
        Stub2DocDate : array [50] of Date;
        Stub2LineAmount : array [50] of Decimal;
        Stub2LineDiscount : array [50] of Decimal;
        Stub2PostingDesc : array [50] of Text[50];
        Stub2DocNoHeader : Text[30];
        Stub2DocDateHeader : Text[30];
        Stub2AmountHeader : Text[30];
        Stub2DiscountHeader : Text[30];
        Stub2NetAmountHeader : Text[30];
        Stub2PostingDescHeader : Text[30];
        USText011 : TextConst ENU='Document No.',ESM='Nº documento',FRC='N° de document',ENC='Document No.';
        USText012 : TextConst ENU='Document Date',ESM='Fecha emisión documento',FRC='Date document',ENC='Document Date';
        USText013 : TextConst ENU='Amount',ESM='Importe',FRC='Montant',ENC='Amount';
        USText014 : TextConst ENU='Discount',ESM='Descuento',FRC='Escompte',ENC='Discount';
        USText015 : TextConst ENU='Net Amount',ESM='Imp. neto',FRC='Montant net',ENC='Net Amount';
        PostingDesc : Text[50];
        USText017 : TextConst ENU='Posting Description',ESM='Texto de registro',FRC='Description du report',ENC='Posting Description';
        StartingLen : Integer;
        ControlLen : Integer;
        NewLen : Integer;
        CheckStyleIndex : Integer;
        Index : Integer;
        BankCurrencyCode : Text[30];
        PageNo : Integer;
        CheckNoTextCaptionLbl : TextConst ENU='Check No.',ESM='Nº cheque',FRC='N° de chèque',ENC='Cheque No.';
        LineAmountCaptionLbl : TextConst ENU='Net Amount',ESM='Imp. neto',FRC='Montant net',ENC='Net Amount';
        LineDiscountCaptionLbl : TextConst ENU='Discount',ESM='Descuento',FRC='Escompte',ENC='Discount';
        DocNoCaptionLbl : TextConst ENU='Document No.',ESM='Nº documento',FRC='N° de document',ENC='Document No.';
        DocDateCaptionLbl : TextConst ENU='Document Date',ESM='Fecha emisión documento',FRC='Date de document',ENC='Document Date';
        Posting_DescriptionCaptionLbl : TextConst ENU='Posting Description',ESM='Texto de registro',FRC='Description du report',ENC='Posting Description';
        AmountCaptionLbl : TextConst ENU='Amount',ESM='Importe',FRC='Montant',ENC='Amount';
        CheckNoText_Control1480000CaptionLbl : TextConst ENU='Check No.',ESM='Nº cheque',FRC='N° de chèque',ENC='Cheque No.';
        "---Eclipse Var---" : Integer;
        CompanyInfo : Record "Company Information";
        PurchPayablesSetup : Record "Purchases & Payables Setup";
        PrintSignature : Boolean;

    local procedure CustUpdateAmounts(var CustLedgEntry2 : Record "Cust. Ledger Entry";RemainingAmount2 : Decimal);
    begin
        if (ApplyMethod = ApplyMethod::OneLineOneEntry) or
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        then begin
          GenJnlLine3.RESET;
          GenJnlLine3.SETCURRENTKEY(
            "Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.");
          GenJnlLine3.SETRANGE("Account Type",GenJnlLine3."Account Type"::Customer);
          GenJnlLine3.SETRANGE("Account No.",CustLedgEntry2."Customer No.");
          GenJnlLine3.SETRANGE("Applies-to Doc. Type",CustLedgEntry2."Document Type");
          GenJnlLine3.SETRANGE("Applies-to Doc. No.",CustLedgEntry2."Document No.");
          if ApplyMethod = ApplyMethod::OneLineOneEntry then
            GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine."Line No.")
          else
            GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine2."Line No.");
          if CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " then
            if GenJnlLine3.FIND('-') then
              GenJnlLine3.FIELDERROR(
                "Applies-to Doc. No.",
                STRSUBSTNO(
                  Text030,
                  CustLedgEntry2."Document Type",CustLedgEntry2."Document No.",
                  CustLedgEntry2."Customer No."));
        end;

        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Document Date";
        PostingDesc := CustLedgEntry2.Description;

        CurrencyCode2 := CustLedgEntry2."Currency Code";
        CustLedgEntry2.CALCFIELDS("Remaining Amount");

        LineAmount := -(CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible" -
                        CustLedgEntry2."Accepted Payment Tolerance");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,LineAmount),
            Currency."Amount Rounding Precision");
        if ((((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) and
              (LineAmount2 >= RemainingAmount2)) or
             ((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::"Credit Memo") and
              (LineAmount2 <= RemainingAmount2))) and
            (GenJnlLine."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) or
           CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
        then begin
          LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
          if CustLedgEntry2."Accepted Payment Tolerance" <> 0 then
            LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        end else begin
          if RemainingAmount2 >=
             ROUND(
               -(ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                   CustLedgEntry2."Remaining Amount")),Currency."Amount Rounding Precision")
          then
            LineAmount2 :=
              ROUND(
                -(ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                    CustLedgEntry2."Remaining Amount")),Currency."Amount Rounding Precision")
          else begin
            LineAmount2 := RemainingAmount2;
            LineAmount :=
              ROUND(
                ExchangeAmt(CustLedgEntry2."Posting Date",CurrencyCode2,GenJnlLine."Currency Code",
                  LineAmount2),Currency."Amount Rounding Precision");
          end;
          LineDiscount := 0;
        end;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2 : Record "Vendor Ledger Entry";RemainingAmount2 : Decimal);
    begin
        if (ApplyMethod = ApplyMethod::OneLineOneEntry) or
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        then begin
          GenJnlLine3.RESET;
          GenJnlLine3.SETCURRENTKEY(
            "Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.");
          GenJnlLine3.SETRANGE("Account Type",GenJnlLine3."Account Type"::Vendor);
          GenJnlLine3.SETRANGE("Account No.",VendLedgEntry2."Vendor No.");
          GenJnlLine3.SETRANGE("Applies-to Doc. Type",VendLedgEntry2."Document Type");
          GenJnlLine3.SETRANGE("Applies-to Doc. No.",VendLedgEntry2."Document No.");
          if ApplyMethod = ApplyMethod::OneLineOneEntry then
            GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine."Line No.")
          else
            GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine2."Line No.");
          if VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " then
            if GenJnlLine3.FIND('-') then
              GenJnlLine3.FIELDERROR(
                "Applies-to Doc. No.",
                STRSUBSTNO(
                  Text031,
                  VendLedgEntry2."Document Type",VendLedgEntry2."Document No.",
                  VendLedgEntry2."Vendor No."));
        end;

        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocNo := ExtDocNo;
        DocDate := VendLedgEntry2."Document Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";
        VendLedgEntry2.CALCFIELDS("Remaining Amount");
        PostingDesc := VendLedgEntry2.Description;

        LineAmount := -(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible" -
                        VendLedgEntry2."Accepted Payment Tolerance");

        LineAmount2 :=
          ROUND(
            ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,LineAmount),
            Currency."Amount Rounding Precision");

        if ((((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::Invoice) and
              (LineAmount2 <= RemainingAmount2)) or
             ((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::"Credit Memo") and
              (LineAmount2 <= RemainingAmount2))) and
            (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) or
           VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        then begin
          LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
          if VendLedgEntry2."Accepted Payment Tolerance" <> 0 then
            LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        end else begin
          if RemainingAmount2 >=
             ROUND(
               -(ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                   VendLedgEntry2."Amount to Apply")),Currency."Amount Rounding Precision")
          then begin
            LineAmount2 :=
              ROUND(
                -(ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                    VendLedgEntry2."Amount to Apply")),Currency."Amount Rounding Precision");
            LineAmount :=
              ROUND(
                ExchangeAmt(VendLedgEntry2."Posting Date",CurrencyCode2,GenJnlLine."Currency Code",
                  LineAmount2),Currency."Amount Rounding Precision");
          end else begin
            LineAmount2 := RemainingAmount2;
            LineAmount :=
              ROUND(
                ExchangeAmt(VendLedgEntry2."Posting Date",CurrencyCode2,GenJnlLine."Currency Code",
                  LineAmount2),Currency."Amount Rounding Precision");
          end;
          LineDiscount := 0;
        end;
    end;

    procedure InitializeRequest(BankAcc : Code[20];LastCheckNo : Code[20];NewOneCheckPrVend : Boolean;NewReprintChecks : Boolean;NewTestPrint : Boolean;NewPreprintedStub : Boolean);
    begin
        if BankAcc <> '' then
          if BankAcc2.GET(BankAcc) then begin
            UseCheckNo := LastCheckNo;
            OneCheckPrVendor := NewOneCheckPrVend;
            ReprintChecks := NewReprintChecks;
            TestPrint := NewTestPrint;
            PreprintedStub := NewPreprintedStub;
          end;
    end;

    procedure ExchangeAmt(PostingDate : Date;CurrencyCode : Code[10];CurrencyCode2 : Code[10];Amount : Decimal) Amount2 : Decimal;
    begin
        if (CurrencyCode <> '') and (CurrencyCode2 = '') then
          Amount2 :=
            CurrencyExchangeRate.ExchangeAmtLCYToFCY(
              PostingDate,CurrencyCode,Amount,CurrencyExchangeRate.ExchangeRate(PostingDate,CurrencyCode))
        else
          if (CurrencyCode = '') and (CurrencyCode2 <> '') then
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                PostingDate,CurrencyCode2,Amount,CurrencyExchangeRate.ExchangeRate(PostingDate,CurrencyCode2))
          else
            if (CurrencyCode <> '') and (CurrencyCode2 <> '') and (CurrencyCode <> CurrencyCode2) then
              Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate,CurrencyCode2,CurrencyCode,Amount)
            else
              Amount2 := Amount;
    end;
}

