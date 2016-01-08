{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }
{                                                                              }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
| Historico
|
******************************************************************************}
{$I ACBr.inc}

unit ACBrNFeDANFeRLSimplificado;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RLReport, RLPDFFilter, RLBarcode, ACBrNFeDANFeRL,
  pcnConversao, DB, RLFilters;

type

  { TfrlDANFeRLSimplificado }

  TfrlDANFeRLSimplificado = class(TfrlDANFeRL)
    RLb02_Emitente: TRLBand;
    RLb03_DadosGerais: TRLBand;
    RLb04_Destinatario: TRLBand;
    RLb05a_Cab_Itens: TRLBand;
    RLb05b_Desc_Itens: TRLBand;
    RLb05c_Lin_Itens: TRLBand;
    RLb06a_Totais: TRLBand;
    RLb06b_Tributos: TRLBand;
    RLiLogo: TRLImage;
    RLLabel1: TRLLabel;
    RLLabel142: TRLLabel;
    RLLabel143: TRLLabel;
    RLLabel147: TRLLabel;
    RLLabel148: TRLLabel;
    RLLabel149: TRLLabel;
    RLLabel150: TRLLabel;
    RLLabel27: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel9: TRLLabel;
    RLlChave: TRLLabel;
    RLlDescricao: TRLLabel;
    RLlEmissao: TRLLabel;
    RLlEntradaSaida: TRLLabel;
    RLlMsgTipoEmissao: TRLLabel;
    RLlProtocolo: TRLLabel;
    RLlTipoEmissao: TRLLabel;
    RLlTributos: TRLLabel;
    RLmDestinatario: TRLMemo;
    RLmEmitente: TRLMemo;
    RLmPagDesc: TRLMemo;
    RLmPagValor: TRLMemo;
    RLmProdutoCodigo: TRLDBText;
    RLmProdutoDescricao: TRLDBText;
    RLmProdutoItem: TRLDBText;
    RLmProdutoQTDE: TRLDBText;
    RLmProdutoTotal: TRLDBText;
    RLmProdutoUnidade: TRLDBText;
    RLmProdutoValor: TRLDBText;
    RLShape102: TRLDraw;
    RLShape68: TRLDraw;
    rlb01_Chave: TRLBand;
    RLBarcode1: TRLBarcode;
    RLLabel17: TRLLabel;
    lblNumero: TRLLabel;
    procedure RLb02_EmitenteBeforePrint(Sender: TObject; var PrintIt: boolean);
    procedure RLb03_DadosGeraisBeforePrint(Sender: TObject; var PrintIt: boolean
      );
    procedure RLb04_DestinatarioBeforePrint(Sender: TObject;
      var PrintIt: boolean);
    procedure RLb06a_TotaisBeforePrint(Sender: TObject; var PrintIt: boolean);
    procedure RLb06b_TributosBeforePrint(Sender: TObject; var PrintIt: boolean);
    procedure RLNFeBeforePrint(Sender: TObject;
      var PrintReport: Boolean);
    procedure rlmProdutoDescricaoPrint(sender: TObject; var Value: string);

    procedure rlb01_ChaveBeforePrint(Sender: TObject;
      var PrintBand: Boolean);
  private
    { Private declarations }
    FTotalPages: Integer;
    TotalItens: Integer;
    procedure Itens;
  public
    { Public declarations }
    procedure ProtocoloNFE( const sProtocolo : String );
  end;

implementation

uses
 StrUtils, DateUtils,
 ACBrUtil, ACBrValidador, ACBrDFeUtil,
 pcnNFe, pcnConversaoNFe, ACBrNFeDANFeRLClass;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
   _NUM_ITEMS_PAGE1      = 18;
   _NUM_ITEMS_OTHERPAGES = 50;

procedure TfrlDANFeRLSimplificado.RLNFeBeforePrint(Sender: TObject;
  var PrintReport: Boolean);
var
 nRestItens: Integer;
begin
  inherited;

  //rlb05a_Cab_Itens.Enabled := FImprimeItens;
  //rlb05b_Desc_Itens.Enabled := FImprimeItens;
  //rlb05c_Lin_Itens.Enabled := FImprimeItens;

  Itens;
  FTotalPages := 1;

  if ( FNFe.Det.Count > _NUM_ITEMS_PAGE1 ) then
   begin
      nRestItens := FNFe.Det.Count - _NUM_ITEMS_PAGE1;
      if nRestItens <= _NUM_ITEMS_OTHERPAGES then
         Inc( FTotalPages )
      else
      begin
         Inc( FTotalPages, nRestItens div _NUM_ITEMS_OTHERPAGES );
         if ( nRestItens mod _NUM_ITEMS_OTHERPAGES ) > 0 then
            Inc( FTotalPages )
      end;
   end;

  RLNFe.Title:='NF-e: ' + FormatFloat( '000,000,000', FNFe.Ide.nNF );

  with RLNFe.Margins do
  begin
    TopMargin    := FMargemSuperior * 10;
    BottomMargin := FMargemInferior * 10;
    LeftMargin   := FMargemEsquerda * 10;
    RightMargin  := FMargemDireita  * 10;
  end;
end;

procedure TfrlDANFeRLSimplificado.RLb02_EmitenteBeforePrint(Sender: TObject;
  var PrintIt: boolean);
begin
  inherited;

//  PrintBand := RLNFe.PageNumber = 1;

  if FExpandirLogoMarca
   then begin
    rliLogo.top         := 13;
    rliLogo.Left        := 2;
    rliLogo.Height      := 108;
    rliLogo.Width       := 284;
    rliLogo.Stretch     := True;
    rlmEmitente.Enabled := False;
   end;

  if (FLogo <> '') and FilesExists(FLogo)
   then rliLogo.Picture.LoadFromFile(FLogo);

  if not FExpandirLogoMarca
   then begin
    rlmEmitente.Enabled := True;
    rlmEmitente.Lines.Clear;
    with FNFe.Emit do
     begin
      rlmEmitente.Lines.Add(TACBrNFeDANFeRL(Owner).ManterNomeImpresso( XNome , XFant ));
      with EnderEmit do
       begin
        rlmEmitente.Lines.Add(XLgr + IfThen(Nro = '0', '', ', ' + Nro) +
                              IfThen(XCpl = '', '', ', ' + XCpl) +
                              IfThen(XBairro = '', '', ', ' + XBairro) +
                              ', ' + XMun + '/ ' + UF);
       end;
      rlmEmitente.Lines.Add('CNPJ: ' + FormatarCNPJouCPF(CNPJCPF) +
                            ' IE: '+ IE);
     end;
   end;
end;

procedure TfrlDANFeRLSimplificado.RLb03_DadosGeraisBeforePrint(Sender: TObject;
  var PrintIt: boolean);
begin
  // Contingencia ********************************************************
  if FNFe.Ide.tpEmis in [teContingencia, teFSDA]
   then rllTipoEmissao.Caption := 'CONTINGENCIA FS-DA';

  rllEntradaSaida.Caption := tpNFToStr( FNFe.Ide.tpNF );

  lblNumero.Caption := ACBrStr('N�mero: ' + FormatFloat('000,000,000', FNFe.Ide.nNF) +
                       ' - S�rie: '+ FormatFloat('000', FNFe.Ide.serie));

  rllEmissao.Caption := ACBrStr('Emiss�o: ' + FormatDateTimeBr(FNFe.Ide.dEmi));
end;

procedure TfrlDANFeRLSimplificado.RLb04_DestinatarioBeforePrint(
  Sender: TObject; var PrintIt: boolean);
var
 vTpEmissao: Integer;
begin
  inherited;

  rlmDestinatario.Lines.Clear;
  with FNFe.Dest do
   begin
    rlmDestinatario.Lines.Add(XNome);
    with EnderDest do
     begin
      rlmDestinatario.Lines.Add(XLgr + IfThen(Nro = '0', '', ', ' + Nro) +
                            IfThen(XCpl = '', '', ', ' + XCpl) +
                            IfThen(XBairro = '', '', ', ' + XBairro) +
                            ', ' + XMun + '/ ' + UF);
     end;
    rlmDestinatario.Lines.Add(ACBrStr('CPF/CNPJ: ' + FormatarCNPJouCPF(CNPJCPF) +
                              ' IE: ' + IE));
   end;

  if FNFe.Ide.tpAmb = taHomologacao then
   begin
     rllMsgTipoEmissao.Caption := ACBrStr('HOMOLOGA��O - SEM VALOR FISCAL');
     rllMsgTipoEmissao.Enabled := True;
     rllMsgTipoEmissao.Visible := True;
   end;

  if FNFe.procNFe.cStat > 0 then
   begin
     if ((FNFe.procNFe.cStat in [101, 151, 155]) or (FNFeCancelada)) then
     begin
       rllMsgTipoEmissao.Caption := 'NF-e CANCELADA';
       rllMsgTipoEmissao.Visible := True;
       rllMsgTipoEmissao.Enabled := True;
     end;
     if FNFe.procNFe.cStat = 110 then
     begin
       rllMsgTipoEmissao.Caption := 'NF-e DENEGADA';
       rllMsgTipoEmissao.Visible := True;
       rllMsgTipoEmissao.Enabled := True;
     end;
     if not FNFe.procNFe.cStat in [100, 101, 110, 151, 155] then
     begin
       rllMsgTipoEmissao.Caption := FNFe.procNFe.xMotivo;
       rllMsgTipoEmissao.Visible := True;
       rllMsgTipoEmissao.Enabled := True;
     end;
   end;

  if FNFe.Ide.tpEmis = teContingencia then
      vTpEmissao:=2
  else
  if FNFe.Ide.tpEmis = teFSDA then
      vTpEmissao:=5;

  case vTpEmissao of
   2: begin
       rllMsgTipoEmissao.Caption := ACBrStr('DANFE em Contingencia - impresso em decorrencia de problemas tecnicos');
       rllMsgTipoEmissao.Visible := True;
       rllMsgTipoEmissao.Enabled := True;
      end;
   5: begin
       rllMsgTipoEmissao.Caption := ACBrStr('DANFE em Contingencia - impresso em decorrencia de problemas tecnicos');
       rllMsgTipoEmissao.Visible := True;
       rllMsgTipoEmissao.Enabled := True;
      end;
  end;

 rllMsgTipoEmissao.Repaint;
end;

procedure TfrlDANFeRLSimplificado.RLb06a_TotaisBeforePrint(Sender: TObject;
  var PrintIt: boolean);
begin
  inherited;

//  PrintBand := RLNFe.PageNumber = 1;

  rlmPagDesc.Lines.Clear;
  rlmPagValor.Lines.Clear;

  rlmPagDesc.Lines.Add('Qtde Total de Itens');
  rlmPagValor.Lines.Add(IntToStr(TotalItens));

  rlmPagDesc.Lines.Add('Valor Total');
  rlmPagValor.Lines.Add(FormatFloatBr(FNFE.Total.ICMSTot.vNF));
end;

procedure TfrlDANFeRLSimplificado.RLb06b_TributosBeforePrint(Sender: TObject;
  var PrintIt: boolean);
var
 Perc: Double;
begin
  inherited;
//  PrintBand := RLNFe.PageNumber = 1;

  Perc := (FNFE.Total.ICMSTot.vTotTrib / FNFE.Total.ICMSTot.vNF) * 100;
  rllTributos.Caption := ACBrStr('Valor aprox. dos tributos: ' +
                         FormatFloatBr(FNFE.Total.ICMSTot.vTotTrib) +
                         '(' + FormatFloatBr(Perc) + '%)(Fonte: IBPT)');
end;

procedure TfrlDANFeRLSimplificado.rlmProdutoDescricaoPrint(sender: TObject;
  var Value: string);
var
 intTamanhoDescricao,
 intTamanhoAdicional,
 intDivisaoDescricao,
 intDivisaoAdicional,
 intResto: Integer;
begin
  inherited;

  intTamanhoDescricao := Length(cdsItens.FieldByName( 'DESCRICAO' ).AsString);
  intDivisaoAdicional := 0;
  if Length(cdsItens.FieldByName( 'INFADIPROD' ).AsString)>0
   then begin
    intTamanhoAdicional := Length('InfAdic: '+cdsItens.FieldByName( 'INFADIPROD' ).AsString);
    intDivisaoAdicional := intTamanhoAdicional DIV 35;
    intResto := intTamanhoAdicional - (intTamanhoAdicional DIV 35)*35;
    if intResto > 0
     then intDivisaoAdicional := intDivisaoAdicional + 1;
   end;

  intDivisaoDescricao := intTamanhoDescricao DIV 35;
  intResto := intTamanhoDescricao - (intTamanhoDescricao DIV 35)*35;
  if intResto>0
   then intDivisaoDescricao := intDivisaoDescricao + 1;

  if cdsItens.FieldByName('INFADIPROD').AsString <> ''
   then Value := Value + #13 + 'InfAd: ' + cdsItens.FieldByName('INFADIPROD').AsString;
end;

procedure TfrlDANFeRLSimplificado.Itens;
var
  nItem: Integer;
begin
  cdsItens.Close;
  cdsItens.CreateDataSet;
  cdsItens.Open;
  TotalItens  := FNFe.Det.Count;
  for nItem   := 0 to (FNFe.Det.Count - 1) do
  begin
    with FNFe.Det.Items[nItem] do
    begin
      with Prod do
      begin
        with Imposto.ICMS do
        begin
          cdsItens.Append;
          cdsItens.FieldByName('ITEM').AsString         := FormatFloat('000', nItem );
          cdsItens.FieldByName('CODIGO').AsString       := TACBrNFeDANFeRL(Owner).ManterCodigo(cEAN, CProd);
          cdsItens.FieldByName('DESCRICAO').AsString    := XProd;
          cdsItens.FieldByName('INFADIPROD').AsString   := infAdProd;
          cdsItens.FieldByName('NCM').AsString          := NCM;
          cdsItens.FieldByName('CST').AsString          := OrigToStr(Imposto.ICMS.orig) + CSTICMSToStr(Imposto.ICMS.CST);
          cdsItens.FieldByName('CSOSN').AsString        := OrigToStr(Imposto.ICMS.orig) + CSOSNIcmsToStr(Imposto.ICMS.CSOSN);
          cdsItens.FieldByName('CFOP').AsString         := CFOP;
          cdsItens.FieldByName('QTDE').AsString         := TACBrNFeDANFeRL(Owner).FormatQuantidade( Prod.qCom);
          cdsItens.FieldByName('VALOR').AsString        := TACBrNFeDANFeRL(Owner).FormatValorUnitario(  Prod.vUnCom);
          cdsItens.FieldByName('UNIDADE').AsString      := UCom;
          cdsItens.FieldByName('TOTAL').AsString        := FormatFloat('###,###,###,##0.00', vProd);
          cdsItens.FieldByName('VALORDESC').AsString    := FormatFloat('###,###,###,##0.00', ManterDesPro( Prod.vDesc ,Prod.vProd));
          cdsItens.FieldByName('Valorliquido').AsString := FormatFloatBr( Prod.vProd - ManterDesPro( Prod.vDesc ,Prod.vProd),'###,###,##0.00');
          cdsItens.FieldByName('BICMS').AsString        := FormatFloat('###,###,###,##0.00', Imposto.ICMS.VBC);
          cdsItens.FieldByName('ALIQICMS').AsString     := FormatFloat('###,###,###,##0.00', Imposto.ICMS.PICMS);
          cdsItens.FieldByName('VALORICMS').AsString    := FormatFloat('###,###,###,##0.00', Imposto.ICMS.VICMS);
          cdsItens.FieldByName('BICMSST').AsString      := FormatFloat('###,###,###,##0.00', Imposto.ICMS.vBCST);
          cdsItens.FieldByName('VALORICMSST').AsString  := FormatFloat('###,###,###,##0.00', Imposto.ICMS.vICMSST);
          cdsItens.FieldByName('ALIQIPI').AsString      := FormatFloat('##0.00', Imposto.IPI.PIPI);
          cdsItens.FieldByName('VALORIPI').AsString     := FormatFloat('##0.00', Imposto.IPI.VIPI);
          cdsItens.Post;
        end;
      end;
    end;
  end;
  cdsItens.First;
end;

procedure TfrlDANFeRLSimplificado.ProtocoloNFE( const sProtocolo : String );
begin
  FProtocoloNFE := sProtocolo;
end;

procedure TfrlDANFeRLSimplificado.rlb01_ChaveBeforePrint(Sender: TObject;
  var PrintBand: Boolean);
begin
  inherited;

  PrintBand := RLNFe.PageNumber = 1;

  RLBarcode1.Caption := Copy ( FNFe.InfNFe.Id, 4, 44 );

  rllChave.Caption := FormatarChaveAcesso(Copy(FNFe.InfNFe.Id, 4, 44));

  // Normal **************************************************************
  if FNFe.Ide.tpEmis in [teNormal, teSCAN]
   then begin
    if FNFe.procNFe.cStat = 100
     then rllDescricao.Caption := ACBrStr('Protocolo de Autoriza��o');

    if FNFe.procNFe.cStat in [101, 151, 155]
     then rllDescricao.Caption:= ACBrStr('Protocolo de Homologa��o de Cancelamento');

    if FNFe.procNFe.cStat = 110
     then rllDescricao.Caption:= ACBrStr('Protocolo de Denega��o de Uso');
   end;

  if FProtocoloNFE <> ''
   then rllProtocolo.Caption := FProtocoloNFE
   else rllProtocolo.Caption := FNFe.procNFe.nProt + ' ' +
                                IfThen(FNFe.procNFe.dhRecbto <> 0, DateTimeToStr(FNFe.procNFe.dhRecbto), '');

  //FTotalPages := HrTotalPages;
end;

end.
