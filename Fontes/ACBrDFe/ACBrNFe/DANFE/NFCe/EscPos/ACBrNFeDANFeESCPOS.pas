{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
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
{ http://www.opensource.org/licenses/gpl-license.php                           }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 04/04/2013:  Andr� Ferreira de Moraes
|*   Inicio do desenvolvimento
|* 20/11/2014:  Welkson Renny de Medeiros
|*   Contribui��es para impress�o na Bematech e Daruma
|* 25/11/2014: R�gys Silveira
|*   Acertos gerais e adapta��o do layout a norma t�cnica
|*   adi��o de m�todo para impress�o de relat�rios
|*   adi��o de impress�o de eventos
|* 28/11/2014: R�gys Silveira
|*   Implementa��o da possibilidade de utilizar tags nos relatorios (segue o
|*   padr�o do acbrecf)
|* 06/05/2015: DSA
|*   Refatora��o para usar TACBrPosPrinter
******************************************************************************}

{$I ACBr.inc}

unit ACBrNFeDANFeESCPOS;

interface

uses
  Classes, SysUtils, {$IFDEF FPC} LResources, {$ENDIF}
  ACBrNFeDANFEClass, ACBrPosPrinter,
  pcnNFe, pcnEnvEventoNFe;

type
  { TACBrNFeDANFeESCPOS }

  TACBrNFeDANFeESCPOS = class(TACBrNFeDANFEClass)
  private
    FPosPrinter : TACBrPosPrinter ;
    procedure MontarEnviarDANFE(NFE: TNFe; const AResumido: Boolean);
    procedure SetPosPrinter(AValue: TACBrPosPrinter);
  protected
    FpNFe: TNFe;
    FpEvento: TEventoNFe;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure AtivarPosPrinter;

    procedure GerarCabecalho;
    procedure GerarItens;
    procedure GerarTotais(Resumido: Boolean = False);
    procedure GerarPagamentos(Resumido: Boolean = False);
    procedure GerarTotTrib;
    procedure GerarObsCliente;
    procedure GerarObsFisco;
    procedure GerarDadosConsumidor;
    procedure GerarRodape(Cancelamento: Boolean = False);
    procedure GerarDadosEvento;
    procedure GerarObservacoesEvento;
    procedure GerarClicheEmpresa;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDANFE(NFE: TNFe = nil); override;
    procedure ImprimirDANFEResumido(NFE: TNFe = nil); override;
    procedure ImprimirEVENTO(NFE: TNFe = nil); override;

    procedure ImprimirRelatorio(const ATexto: TStrings; const AVias: Integer = 1;
      const ACortaPapel: Boolean = True; const ALogo : Boolean = True);
  published
    property PosPrinter : TACBrPosPrinter read FPosPrinter write SetPosPrinter;
  end;

procedure Register;

implementation

uses
  strutils, Math,
  ACBrNFe, ACBrConsts, ACBrValidador, ACBrUtil, ACBrDFeUtil,
   pcnConversao, pcnAuxiliar;

procedure Register;
begin
  RegisterComponents('ACBrNFe', [TACBrNFeDANFeESCPOS]);
end;

{ TACBrNFeDANFeESCPOS }

constructor TACBrNFeDANFeESCPOS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPosPrinter := Nil;
end;

destructor TACBrNFeDANFeESCPOS.Destroy;
begin
  inherited Destroy;
end;


procedure TACBrNFeDANFeESCPOS.SetPosPrinter(AValue: TACBrPosPrinter);
begin
  if AValue <> FPosPrinter then
  begin
     if Assigned(FPosPrinter) then
        FPosPrinter.RemoveFreeNotification(Self);

     FPosPrinter := AValue;

     if AValue <> nil then
        AValue.FreeNotification(self);
  end ;
end;

procedure TACBrNFeDANFeESCPOS.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) then
  begin
    if (AComponent is TACBrPosPrinter) and (FPosPrinter <> nil) then
       FPosPrinter := nil ;
  end;
end;

procedure TACBrNFeDANFeESCPOS.AtivarPosPrinter;
begin
  if not Assigned( FPosPrinter ) then
    raise Exception.Create('Componente PosPrinter n�o associado');

  FPosPrinter.Ativar;
end;

procedure TACBrNFeDANFeESCPOS.GerarClicheEmpresa;
var
  Cmd, LinhaCmd: String;
begin
  FPosPrinter.Buffer.Add('</zera></ce></logo>');

  if Length( Trim( FpNFe.Emit.xNome ) ) > FPosPrinter.ColunasFonteNormal then
    Cmd := '</ce><c><n>'
  else
    Cmd := '</fn></ce><n>';

  FPosPrinter.Buffer.Add(Cmd + FpNFe.Emit.xNome + '</n>');

  if Trim(FpNFe.Emit.xFant) <> '' then
  begin
    if Length( Trim( FpNFe.Emit.xFant ) ) > FPosPrinter.ColunasFonteNormal then
      Cmd := '</ce><c><n>'
    else
      Cmd := '</fn></ce><n>';

    FPosPrinter.Buffer.Add(Cmd + FpNFe.Emit.xFant + '</n>');
  end;

  FPosPrinter.Buffer.Add('<c>' + QuebraLinhas(
    Trim(FpNFe.Emit.EnderEmit.xLgr) + ', ' +
    Trim(FpNFe.Emit.EnderEmit.nro) + '  ' +
    Trim(FpNFe.Emit.EnderEmit.xCpl) + '  ' +
    Trim(FpNFe.Emit.EnderEmit.xBairro) +  ' ' +
    Trim(FpNFe.Emit.EnderEmit.xMun) + '/' + Trim(FpNFe.Emit.EnderEmit.UF) + '  ' +
    'Cep:' + FormatarCEP(IntToStr(FpNFe.Emit.EnderEmit.CEP)) + '  ' +
    'Tel:' + FormatarFone(FpNFe.Emit.EnderEmit.fone)
    , FPosPrinter.ColunasFonteCondensada)
  );

  LinhaCmd := 'CNPJ: ' + FormatarCNPJ(FpNFe.Emit.CNPJCPF);
  if Trim(FpNFe.Emit.IE) <> '' then
  begin
    LinhaCMd := PadSpace(LinhaCmd + '|' + 'IE: ' + FormatarIE(FpNFe.Emit.IE, FpNFe.Emit.EnderEmit.UF),
                        FPosPrinter.ColunasFonteCondensada, '|') ;
  end;

  FPosPrinter.Buffer.Add('</ae><c><n>' + LinhaCmd + '</n>');

  if Trim(FpNFe.Emit.IM) <> '' then
    FPosPrinter.Buffer.Add('</ae><c><n>' + 'IM: ' + FpNFe.Emit.IM + '</n>' );

  FPosPrinter.Buffer.Add('</fn></linha_simples>');
end;

procedure TACBrNFeDANFeESCPOS.GerarCabecalho;
begin
  GerarClicheEmpresa;

  FPosPrinter.Buffer.Add(ACBrStr('</ce><c><n>DANFE NFC-e - Documento Auxiliar'));
  FPosPrinter.Buffer.Add(ACBrStr('da Nota Fiscal Eletr�nica para Consumidor Final'));
  FPosPrinter.Buffer.Add(ACBrStr('N�o permite aproveitamento de cr�dito de ICMS</n>'));
end;

procedure TACBrNFeDANFeESCPOS.GerarItens;
var
  i: Integer;
  nTamDescricao: Integer;
  VlrLiquido: Double;
  sItem, sCodigo, sDescricao, sQuantidade, sUnidade, sVlrUnitario, sVlrProduto,
    LinhaCmd: String;
begin
  if ImprimirItens then
  begin
    FPosPrinter.Buffer.Add('</ae><c></linha_simples>');
    FPosPrinter.Buffer.Add(ACBrStr(PadSpace('#|CODIGO|DESCRI��O|QTD|UN|VL UN R$|VL TOTAL R$',
                                            FPosPrinter.ColunasFonteCondensada, '|')));
    FPosPrinter.Buffer.Add('</linha_simples>');

    for i := 0 to FpNFe.Det.Count - 1 do
    begin
      with FpNFe.Det.Items[i] do
      begin
        sItem        :=        IntToStrZero( Prod.nItem, 3);
        sDescricao   :=                Trim( Prod.xProd);
        sUnidade     :=                Trim( Prod.uCom);
        sVlrProduto  :=       FormatFloatBr( Prod.vProd, '###,###,##0.00');
        sCodigo      :=        ManterCodigo( Prod.cEAN , Prod.cProd );
        sVlrUnitario := FormatValorUnitario( Prod.VUnCom );
        sQuantidade  :=    FormatQuantidade( Prod.QCom, False );

        if ImprimeEmUmaLinha then
        begin
          LinhaCmd := sItem + ' ' + sCodigo + ' ' + '[DesProd] ' + sQuantidade + ' ' +
            sUnidade + ' X ' + sVlrUnitario + ' ' + sVlrProduto;

          // acerta tamanho da descri��o
          nTamDescricao := FPosPrinter.ColunasFonteCondensada - Length(LinhaCmd) + 9;
          sDescricao := PadRight(Copy(sDescricao, 1, nTamDescricao), nTamDescricao);

          LinhaCmd := StringReplace(LinhaCmd, '[DesProd]', sDescricao, [rfReplaceAll]);
          FPosPrinter.Buffer.Add('</ae><c>' + LinhaCmd);
        end
        else
        begin
          LinhaCmd := sItem + ' ' + sCodigo + ' ' + sDescricao;
          FPosPrinter.Buffer.Add('</ae><c>' + LinhaCmd);

          LinhaCmd :=
            PadRight(sQuantidade, 15) + ' ' + PadRight(sUnidade, 6) + ' X ' +
            PadRight(sVlrUnitario, 13) + '|' + sVlrProduto;
          LinhaCmd := padSpace(LinhaCmd, FPosPrinter.ColunasFonteCondensada, '|');
          FPosPrinter.Buffer.Add('</ae><c>' + LinhaCmd);
        end;

        if ImprimeDescAcrescItem then
        begin
          VlrLiquido := (Prod.qCom * Prod.vUnCom) + Prod.vOutro - Prod.vDesc;

          // desconto
          if Prod.vDesc > 0 then
          begin
            LinhaCmd := '</ae><c>' + padSpace(
                'desconto ' + padLeft(FormatFloatBr(Prod.vDesc, '-0.00'), 15, ' ')
                +IIf((Prod.vOutro > 0),'','|' + FormatFloatBr(VlrLiquido, '0.00')) ,
                FPosPrinter.ColunasFonteCondensada, '|');
            FPosPrinter.Buffer.Add('</ae><c>' + LinhaCmd);
          end;

          // ascrescimo
          if Prod.vOutro > 0 then
          begin
            LinhaCmd := '</ae><c>' + ACBrStr(padSpace(
                'acr�scimo ' + padLeft(FormatFloatBr(Prod.vOutro, '+0.00'), 15, ' ')
                + '|' + FormatFloatBr(VlrLiquido, '0.00'),
                FPosPrinter.ColunasFonteCondensada, '|'));
            FPosPrinter.Buffer.Add('</ae><c>' + LinhaCmd);
          end;
        end;
      end;
    end;
  end;
end;

procedure TACBrNFeDANFeESCPOS.GerarTotais(Resumido: Boolean);
begin
  FPosPrinter.Buffer.Add('</linha_simples>');
  FPosPrinter.Buffer.Add('<c>' + PadSpace('QTD. TOTAL DE ITENS|' +
     IntToStrZero(FpNFe.Det.Count, 3), FPosPrinter.ColunasFonteCondensada, '|'));

  if not Resumido then
  begin
    if (FpNFe.Total.ICMSTot.vDesc > 0) or (FpNFe.Total.ICMSTot.vOutro > 0) then
      FPosPrinter.Buffer.Add('<c>' + PadSpace('Subtotal|' +
         FormatFloat('#,###,##0.00', FpNFe.Total.ICMSTot.vProd + FpNFe.Total.ISSQNtot.vServ),
         FPosPrinter.ColunasFonteCondensada, '|'));

    if (FpNFe.Total.ICMSTot.vDesc > 0) then
      FPosPrinter.Buffer.Add('<c>' + PadSpace('Descontos|' +
         FormatFloat('-#,###,##0.00', FpNFe.Total.ICMSTot.vDesc),
         FPosPrinter.ColunasFonteCondensada, '|'));

    if FpNFe.Total.ICMSTot.vOutro > 0 then
      FPosPrinter.Buffer.Add('<c>' + ACBrStr(PadSpace('Acr�scimos|' +
         FormatFloat('+#,###,##0.00', FpNFe.Total.ICMSTot.vOutro),
         FPosPrinter.ColunasFonteCondensada, '|')));
  end;

  FPosPrinter.Buffer.Add('</ae><e>' + PadSpace('VALOR TOTAL R$|' +
     FormatFloat('#,###,##0.00', FpNFe.Total.ICMSTot.vNF),
     FPosPrinter.ColunasFonteCondensada div 2, '|') + '</e>');
end;

procedure TACBrNFeDANFeESCPOS.GerarPagamentos(Resumido: Boolean = False);
var
  i: Integer;
  {Total,} Troco: Real;
begin
  //Total := 0;
  FPosPrinter.Buffer.Add('<c>' + PadSpace('FORMA DE PAGAMENTO | Valor Pago',
     FPosPrinter.ColunasFonteCondensada, '|'));

  for i := 0 to FpNFe.pag.Count - 1 do
  begin
    FPosPrinter.Buffer.Add('<c>' + ACBrStr(PadSpace(FormaPagamentoToDescricao(FpNFe.pag.Items[i].tPag) +
       '|' + FormatFloat('#,###,##0.00', FpNFe.pag.Items[i].vPag),
       FPosPrinter.ColunasFonteCondensada, '|')));
    //Total := Total + FpNFe.pag.Items[i].vPag;
  end;

  //Troco := Total - FpNFe.Total.ICMSTot.vNF;
  Troco := vTroco;
  if Troco > 0 then
    FPosPrinter.Buffer.Add('<c>' + PadSpace('Troco R$|' +
       FormatFloat('#,###,##0.00', Troco), FPosPrinter.ColunasFonteCondensada, '|'));

  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNFeDANFeESCPOS.GerarTotTrib;
begin
 if TributosSeparadamente = False then
  begin
   if FpNFe.Total.ICMSTot.vTotTrib > 0 then
    begin
     FPosPrinter.Buffer.Add('<c>' + ACBrStr(PadSpace('Informa��o dos Tributos Totais Incidentes|' +
        FormatFloat('#,###,##0.00', FpNFe.Total.ICMSTot.vTotTrib),
        FPosPrinter.ColunasFonteCondensada, '|')));
     FPosPrinter.Buffer.Add('<c>(Lei Federal 12.741/2012)');
     FPosPrinter.Buffer.Add('</linha_simples>');
    end;
  end
 else
  begin
   if (vTribFed > 0) or (vTribEst > 0) or (vTribMun > 0) then
    begin
     FPosPrinter.Buffer.Add(ACBrStr('<c>Informa��o dos Tributos Totais (Lei Federal 12.741/2012)'));

     FPosPrinter.Buffer.Add('<c>' + PadSpace('Tributos Federais   R$ :|' +
        FormatFloat('#,###,##0.00', vTribFed), FPosPrinter.ColunasFonteCondensada, '|'));
     FPosPrinter.Buffer.Add('<c>' + PadSpace('Tributos Estaduais  R$ :|' +
        FormatFloat('#,###,##0.00', vTribEst), FPosPrinter.ColunasFonteCondensada, '|'));
     FPosPrinter.Buffer.Add('<c>' + PadSpace('Tributos Municipais R$ :|' +
        FormatFloat('#,###,##0.00', vTribMun), FPosPrinter.ColunasFonteCondensada, '|'));

     if Trim(FonteTributos) <> '' then
      FPosPrinter.Buffer.Add('<c>' + PadSpace('Fonte : '+FonteTributos+'|' +
         ChaveTributos, FPosPrinter.ColunasFonteCondensada, '|'));

     FPosPrinter.Buffer.Add('</linha_simples>');
    end;
  end;
end;

procedure TACBrNFeDANFeESCPOS.GerarObsCliente;
var
  TextoObservacao: AnsiString;
begin
  TextoObservacao := Trim(FpNFe.InfAdic.infCpl);
  if TextoObservacao <> '' then
  begin
    TextoObservacao := StringReplace(FpNFe.InfAdic.infCpl, ';', sLineBreak, [rfReplaceAll]);
    FPosPrinter.Buffer.Add('<c>' + TextoObservacao);
    FPosPrinter.Buffer.Add('</linha_simples>');
  end;
end;

procedure TACBrNFeDANFeESCPOS.GerarObsFisco;
begin
  // se homologa��o imprimir o texto de homologa��o
  if FpNFe.ide.tpAmb = taHomologacao then
  begin
    FPosPrinter.Buffer.Add(ACBrStr('</ce><c><n>EMITIDA EM AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL'));
  end;

  // se diferente de normal imprimir a emiss�o em conting�ncia
  if FpNFe.ide.tpEmis <> teNormal then
  begin
    FPosPrinter.Buffer.Add(ACBrStr('</ce></fn><n>EMITIDA EM CONTING�NCIA'));
  end;

  // dados da nota eletronica de consumidor
  FPosPrinter.Buffer.Add(ACBrStr('</n></ce><c>' +
    'N�mero ' + IntToStrZero(FpNFe.ide.nNF, 9) +
    ' S�rie ' + IntToStrZero(FpNFe.ide.serie, 3) +
    ' Emiss�o ' + DateTimeToStr(FpNFe.ide.dEmi)
  ));

  // via consumidor ou estabelecimento
  FPosPrinter.Buffer.Add('</fn></ce>' +
     IfThen(ViaConsumidor, 'Via Consumidor', 'Via Estabelecimento'));

  // chave de acesso
  FPosPrinter.Buffer.Add('<c>Consulte pela Chave de Acesso em:');
  FPosPrinter.Buffer.Add( TACBrNFe(ACBrNFe).GetURLConsultaNFCe(FpNFe.ide.cUF, FpNFe.ide.tpAmb));
  FPosPrinter.Buffer.Add('</fn>CHAVE DE ACESSO');
  FPosPrinter.Buffer.Add('<c>' + FormatarChaveAcesso(OnlyNumber(FpNFe.infNFe.ID)) + '</fn>');
  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNFeDANFeESCPOS.GerarDadosConsumidor;
var
  LinhaCmd: String;
begin
  LinhaCmd := '</ce></fn><n>CONSUMIDOR</n>';
  FPosPrinter.Buffer.Add(LinhaCmd);

  if (FpNFe.Dest.idEstrangeiro = '') and (FpNFe.Dest.CNPJCPF = '') then
  begin
    FPosPrinter.Buffer.Add(ACBrStr('CONSUMIDOR N�O IDENTIFICADO'));
  end
  else
  begin
    if FpNFe.Dest.idEstrangeiro <> '' then
      LinhaCmd := 'ID Estrangeiro: ' + FpNFe.Dest.idEstrangeiro
    else
    begin
      if Length(Trim(FpNFe.Dest.CNPJCPF)) > 11 then
        LinhaCmd := 'CNPJ: ' + FormatarCNPJ(FpNFe.Dest.CNPJCPF)
      else
        LinhaCmd := 'CPF: ' + FormatarCPF(FpNFe.Dest.CNPJCPF);
    end;
    FPosPrinter.Buffer.Add(LinhaCmd);

    LinhaCmd := Trim(FpNFe.Dest.xNome);
    if LinhaCmd <> '' then
    begin
      if Length( LinhaCmd ) > FPosPrinter.ColunasFonteNormal then
        LinhaCmd := '<c>' + LinhaCmd;

      FPosPrinter.Buffer.Add(LinhaCmd);
    end;

    LinhaCmd := Trim(
      Trim(FpNFe.Dest.EnderDest.xLgr) + ' ' +
      IfThen(Trim(FpNFe.Dest.EnderDest.xLgr) = '','',Trim(FpNFe.Dest.EnderDest.nro)) + ' ' +
      Trim(FpNFe.Dest.EnderDest.xCpl) + ' ' +
      Trim(FpNFe.Dest.EnderDest.xBairro) + ' ' +
      Trim(FpNFe.Dest.EnderDest.xMun) + ' ' +
      Trim(FpNFe.Dest.EnderDest.UF)
    );
    if LinhaCmd <> '' then
      FPosPrinter.Buffer.Add('<c>' + LinhaCmd);
  end;
end;

procedure TACBrNFeDANFeESCPOS.GerarRodape(Cancelamento: Boolean = False);
var
  qrcode: AnsiString;
  ConfigQRCodeErrorLevel: Integer;
begin
  FPosPrinter.Buffer.Add('</fn></linha_simples>');
  FPosPrinter.Buffer.Add('</ce>Consulta via leitor de QR Code');

  if EstaVazio(Trim(FpNFe.infNFeSupl.qrCode)) then
    qrcode := TACBrNFe(ACBrNFe).GetURLQRCode(
      FpNFe.ide.cUF,
      FpNFe.ide.tpAmb,
      FpNFe.infNFe.ID,
      IfThen(FpNFe.Dest.idEstrangeiro <> '', FpNFe.Dest.idEstrangeiro, FpNFe.Dest.CNPJCPF),
      FpNFe.ide.dEmi,
      FpNFe.Total.ICMSTot.vNF,
      FpNFe.Total.ICMSTot.vICMS,
      FpNFe.signature.DigestValue)
  else
    qrcode := FpNFe.infNFeSupl.qrCode;

  ConfigQRCodeErrorLevel := FPosPrinter.ConfigQRCode.ErrorLevel;

  // impress�o do qrcode
  FPosPrinter.Buffer.Add( '<qrcode_error>0</qrcode_error>'+
                          '<qrcode>'+qrcode+'</qrcode>'+
                          '<qrcode_error>'+IntToStr(ConfigQRCodeErrorLevel)+'</qrcode_error>');

  // protocolo de autoriza��o
  if FpNFe.Ide.tpEmis <> teOffLine then
  begin
    FPosPrinter.Buffer.Add(ACBrStr('<c>Protocolo de Autoriza��o'));
    FPosPrinter.Buffer.Add('<c>'+Trim(FpNFe.procNFe.nProt) + ' ' +
       IfThen(FpNFe.procNFe.dhRecbto <> 0, DateTimeToStr(FpNFe.procNFe.dhRecbto),
              '') + '</fn>');
  end;

  FPosPrinter.Buffer.Add('</linha_simples>');

  // sistema
  if Sistema <> '' then
    FPosPrinter.Buffer.Add('</ce><c>' + Sistema);

  if Site <> '' then
    FPosPrinter.Buffer.Add('</ce><c>' + Site);

  // pular linhas e cortar o papel
  if FPosPrinter.CortaPapel then
    FPosPrinter.Buffer.Add('</corte_total>')
  else
    FPosPrinter.Buffer.Add('</pular_linhas>')
end;

procedure TACBrNFeDANFeESCPOS.MontarEnviarDANFE(NFE: TNFe;
  const AResumido: Boolean);
begin
  if NFE = nil then
  begin
    if not Assigned(ACBrNFe) then
      raise Exception.Create(ACBrStr('Componente ACBrNFe n�o atribu�do'));

    FpNFe := TACBrNFe(ACBrNFe).NotasFiscais.Items[0].NFE;
  end
  else
    FpNFe := NFE;

  GerarCabecalho;
  GerarItens;
  GerarTotais(AResumido);
  GerarPagamentos(AResumido);
  GerarTotTrib;
  GerarObsCliente;
  GerarObsFisco;
  GerarDadosConsumidor;
  GerarRodape;

  FPosPrinter.Imprimir('',False,True,True,NumCopias);
end;

procedure TACBrNFeDANFeESCPOS.ImprimirDANFE(NFE: TNFe);
begin
  AtivarPosPrinter;
  MontarEnviarDANFE(NFE, False);
end;

procedure TACBrNFeDANFeESCPOS.ImprimirDANFEResumido(NFE: TNFe);
var
  OldImprimirItens: Boolean;
begin
  AtivarPosPrinter;
  OldImprimirItens := ImprimirItens;
  try
    ImprimirItens := False;
    MontarEnviarDANFE(NFE, True);
  finally
    ImprimirItens := OldImprimirItens;
  end;
end;

procedure TACBrNFeDANFeESCPOS.GerarDadosEvento;
const
  TAMCOLDESCR = 11;
begin
  // dados da nota eletr�nica
  FPosPrinter.Buffer.Add('</fn></ce><n>Nota Fiscal para Consumidor Final</n>');
  FPosPrinter.Buffer.Add(ACBrStr('N�mero: ' + IntToStrZero(FpNFe.ide.nNF, 9) +
                                 ' S�rie: ' + IntToStrZero(FpNFe.ide.serie, 3)));
  FPosPrinter.Buffer.Add(ACBrStr('Emiss�o: ' + DateTimeToStr(FpNFe.ide.dEmi)) + '</n>');
  FPosPrinter.Buffer.Add(' ');
  FPosPrinter.Buffer.Add('<c>CHAVE ACESSO');
  FPosPrinter.Buffer.Add(FormatarChaveAcesso(OnlyNumber(FpNFe.infNFe.ID)));
  FPosPrinter.Buffer.Add('</linha_simples>');

  // dados do evento
  FPosPrinter.Buffer.Add('</fn><n>EVENTO</n>');
  FPosPrinter.Buffer.Add('</fn></ae>' + PadRight('Evento:', TAMCOLDESCR) +
     FpEvento.Evento[0].InfEvento.TipoEvento );
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Descri��o:', TAMCOLDESCR)) +
     FpEvento.Evento[0].InfEvento.DescEvento);
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Org�o:', TAMCOLDESCR)) +
     IntToStr(FpEvento.Evento[0].InfEvento.cOrgao) );
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Ambiente:', TAMCOLDESCR) +
     IfThen(FpEvento.Evento[0].RetInfEvento.tpAmb = taProducao,
            'PRODUCAO', 'HOMOLOGA��O - SEM VALOR FISCAL') ));
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Emiss�o:', TAMCOLDESCR)) +
     DateTimeToStr(FpEvento.Evento[0].InfEvento.dhEvento) );
  FPosPrinter.Buffer.Add( PadRight('Sequencia:', TAMCOLDESCR) +
     IntToStr(FpEvento.Evento[0].InfEvento.nSeqEvento) );
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Vers�o:', TAMCOLDESCR)) +
     FpEvento.Evento[0].InfEvento.versaoEvento );
  FPosPrinter.Buffer.Add( PadRight('Status:', TAMCOLDESCR) +
     FpEvento.Evento[0].RetInfEvento.xMotivo );
  FPosPrinter.Buffer.Add( PadRight('Protocolo:', TAMCOLDESCR) +
     FpEvento.Evento[0].RetInfEvento.nProt );
  FPosPrinter.Buffer.Add( PadRight('Registro:', TAMCOLDESCR) +
     DateTimeToStr(FpEvento.Evento[0].RetInfEvento.dhRegEvento) );

  FPosPrinter.Buffer.Add('</linha_simples>');
end;


procedure TACBrNFeDANFeESCPOS.GerarObservacoesEvento;
begin
  if FpEvento.Evento[0].InfEvento.detEvento.xJust <> '' then
  begin
    FPosPrinter.Buffer.Add('</linha_simples>');
    FPosPrinter.Buffer.Add('</fn></ce><n>JUSTIFICATIVA</n>');
    FPosPrinter.Buffer.Add('</fn></ae>' +
       FpEvento.Evento[0].InfEvento.detEvento.xJust );
  end

  else if FpEvento.Evento[0].InfEvento.detEvento.xCorrecao <> '' then
  begin
    FPosPrinter.Buffer.Add('</linha_simples>');
    FPosPrinter.Buffer.Add('</fn></ce><n>' + ACBrStr('CORRE��O') + '</n>' );
    FPosPrinter.Buffer.Add('</fn></ae>' +
       FpEvento.Evento[0].InfEvento.detEvento.xCorrecao );
  end;
end;

procedure TACBrNFeDANFeESCPOS.ImprimirEVENTO(NFE: TNFe);
begin
  if NFE = nil then
  begin
    if not Assigned(ACBrNFe) then
      raise Exception.Create(ACBrStr('Componente ACBrNFe n�o atribu�do'));

    if TACBrNFe(ACBrNFe).NotasFiscais.Count <= 0 then
      raise Exception.Create(ACBrStr('XML da NFe n�o informado, obrigat�rio para o modelo ESCPOS'))
    else
      FpNFe := TACBrNFe(ACBrNFe).NotasFiscais.Items[0].NFE;
  end
  else
    FpNFe := NFE;

  FpEvento := TACBrNFe(ACBrNFe).EventoNFe;
  if not Assigned(FpEvento) then
    raise Exception.Create('Arquivo de Evento n�o informado!');

  AtivarPosPrinter;
  GerarClicheEmpresa;
  GerarDadosEvento;
  GerarDadosConsumidor;
  GerarObservacoesEvento;
  GerarRodape;

  FPosPrinter.Imprimir;
end;

procedure TACBrNFeDANFeESCPOS.ImprimirRelatorio(const ATexto: TStrings; const AVias: Integer = 1;
      const ACortaPapel: Boolean = True; const ALogo : Boolean = True);
var
  LinhaCmd: String;
begin
  LinhaCmd := '</zera>';
  if ALogo then
    LinhaCmd := LinhaCmd + '</ce></logo>';

  LinhaCmd := LinhaCmd + '</ae>';
  FPosPrinter.Buffer.Add(LinhaCmd);

  FPosPrinter.Buffer.AddStrings( ATexto );
  if ACortaPapel then
    FPosPrinter.Buffer.Add('</corte_parcial>')
  else
    FPosPrinter.Buffer.Add('</pular_linhas>');

  FPosPrinter.Imprimir('', True, True, True, AVias);
end;


{$IFDEF FPC}

initialization
{$I ACBrNFeDANFeESCPOS.lrs}
{$ENDIF}

end.
