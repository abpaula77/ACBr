{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - NFe - http://www.nfe.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
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

{*******************************************************************************
|* Historico
|*
*******************************************************************************}

{$I ACBr.inc}

unit ACBrNFeDAInutRLRetrato;


interface

uses
  SysUtils, Variants, Classes, StrUtils,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}
      Graphics, Controls, Forms, Dialogs, ExtCtrls,
  {$ENDIF}
  pcnNFe, pcnConversao, ACBrNFe, ACBrNFeDAInutRL, ACBrUtil,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts,
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB;

type

  { TfrmNFeDAInutRLRetrato }

  TfrmNFeDAInutRLRetrato = class(TfrmNFeDAInutRL)
    rlb_01_Titulo: TRLBand;
    rllProtocolo: TRLLabel;
    rllOrgao: TRLLabel;
    rllDescricao: TRLLabel;
    rlLabel2: TRLLabel;
    rlLabel78: TRLLabel;
    rllModelo: TRLLabel;
    rlb_07_Rodape: TRLBand;
    rlb_03_Inutilizacao: TRLBand;
    rlsQuadro01: TRLDraw;
    rlsLinhaV10: TRLDraw;
    rlsLinhaV09: TRLDraw;
    rlsLinhaH04: TRLDraw;
    rlsLinhaV01: TRLDraw;
    rlShape46: TRLDraw;
    rllLinha3: TRLLabel;
    rllLinha2: TRLLabel;
    rllLinha1: TRLLabel;
    rlShape88: TRLDraw;
    rllTituloEvento: TRLLabel;
    rlShape48: TRLDraw;
    rlLabel9: TRLLabel;
    rllTipoAmbiente: TRLLabel;
    rlLabel6: TRLLabel;
    rllSerie: TRLLabel;
    rlLabel28: TRLLabel;
    rllAno: TRLLabel;
    rlLabel17: TRLLabel;
    rllNumeracao: TRLLabel;
    rlShape49: TRLDraw;
    rlShape50: TRLDraw;
    rlLabel18: TRLLabel;
    rllStatus: TRLLabel;
    rlb_05_NaoUsado_Detalhe: TRLBand;
    rlb_02_Emitente: TRLBand;
    rlsQuadro02: TRLDraw;
    rlsLinhaH07: TRLDraw;
    rlsLinhaH06: TRLDraw;
    rllRazaoEmitente: TRLLabel;
    rllMunEmitente: TRLLabel;
    rllInscEstEmitente: TRLLabel;
    rllEnderecoEmitente: TRLLabel;
    rllCNPJEmitente: TRLLabel;
    rllCEPEmitente: TRLLabel;
    rlLabel98: TRLLabel;
    rlLabel93: TRLLabel;
    rlLabel24: TRLLabel;
    rlLabel22: TRLLabel;
    rlLabel16: TRLLabel;
    rlLabel13: TRLLabel;
    rlLabel12: TRLLabel;
    rlShape51: TRLDraw;
    rlShape53: TRLDraw;
    rlShape82: TRLDraw;
    rlShape99: TRLDraw;
    rlLabel4: TRLLabel;
    rllBairroEmitente: TRLLabel;
    rlShape108: TRLDraw;
    rlLabel5: TRLLabel;
    rllFoneEmitente: TRLLabel;
    rlShape109: TRLDraw;
    rllblSistema: TRLLabel;
    rlShape1: TRLDraw;
    rlb_04_NaoUsado: TRLBand;
    rlb_06_NaoUsado_Summary: TRLBand;
    rlLabel15: TRLLabel;
    rlShape2: TRLDraw;
    rlLabel1: TRLLabel;
    rllJustificativa: TRLLabel;
    procedure RLInutBeforePrint(Sender: TObject; var PrintReport: Boolean);
    procedure rlb_02_EmitenteBeforePrint(Sender: TObject; var PrintBand: Boolean);
    procedure rlb_03_InutilizacaoBeforePrint(Sender: TObject; var PrintBand: Boolean);
    procedure rlb_05_NaoUsado_DetalheBeforePrint(Sender: TObject; var PrintBand: Boolean);
    procedure rlb_06_NaoUsado_SummaryBeforePrint(Sender: TObject; var PrintBand: Boolean);
    procedure rlb_07_RodapeBeforePrint(Sender: TObject; var PrintBand: Boolean);
    procedure rldbtxtValorPrint(sender: TObject; var Value: String);
    procedure rlsQuadro01AfterPrint(Sender: TObject);
  private
    procedure Itens;
  public
    procedure ProtocoloNFe(const sProtocolo: String);
  end;

implementation

uses
  DateUtils, ACBrDFeUtil;

{$R *.dfm}

var
  FProtocoloNFe : String;

procedure TfrmNFeDAInutRLRetrato.Itens;
var
  i: Integer;
begin
 // Itens
 (*
  if ( cdsCorrecao.Active ) then
  begin
    cdsCorrecao.CancelUpdates;
  end
  else
  begin
    cdsCorrecao.CreateDataSet;
  end;

  for i := 0 to (FEventoNFe.InfEvento.detEvento.infCorrecao.Count -1) do
  begin
    cdsCorrecao.Append;
    cdsCorrecaoItem.AsInteger := FEventoNFe.InfEvento.detEvento.infCorrecao[i].nroItemAlterado;
    cdsCorrecaoGrupo.AsString := FEventoNFe.InfEvento.detEvento.infCorrecao[i].grupoAlterado;
    cdsCorrecaoCampo.AsString := FEventoNFe.InfEvento.detEvento.infCorrecao[i].campoAlterado;
    cdsCorrecaoValor.AsString := FEventoNFe.InfEvento.detEvento.infCorrecao[i].valorAlterado;
    cdsCorrecao.Post;
  end;
  *)
end;

procedure TfrmNFeDAInutRLRetrato.ProtocoloNFe(const sProtocolo: String);
begin
  FProtocoloNFe := sProtocolo;
end;

procedure TfrmNFeDAInutRLRetrato.RLInutBeforePrint(Sender: TObject; var PrintReport: Boolean);
begin
  inherited;

  Itens;

  RLNFeInut.Title := 'Inutiliza��o';

  RLNFeInut.Margins.TopMargin    := FMargemSuperior * 100;
  RLNFeInut.Margins.BottomMargin := FMargemInferior * 100;
  RLNFeInut.Margins.LeftMargin   := FMargemEsquerda * 100;
  RLNFeInut.Margins.RightMargin  := FMargemDireita  * 100;

end;

procedure TfrmNFeDAInutRLRetrato.rlb_02_EmitenteBeforePrint(
  Sender: TObject; var PrintBand: Boolean);
begin
  inherited;
  PrintBand := False;

 (*
  if FNFe <> nil
   then begin
    PrintBand := True;

    rllRazaoEmitente.Caption    := FNFe.emit.xNome;
    rllCNPJEmitente.Caption     := DFeUtil.FormatarCNPJCPF(FNFe.emit.CNPJ);
    rllEnderecoEmitente.Caption := FNFe.emit.EnderEmit.xLgr + ', ' + FNFe.emit.EnderEmit.nro;
    rllBairroEmitente.Caption   := FNFe.emit.EnderEmit.xBairro;
    rllCEPEmitente.Caption      := DFeUtil.FormatarCEP(FormatFloat('00000000', FNFe.emit.EnderEmit.CEP));
    rllMunEmitente.Caption      := FNFe.emit.EnderEmit.xMun + ' - ' + FNFe.emit.EnderEmit.UF;
    rllFoneEmitente.Caption     := DFeUtil.FormatarFone(FNFe.emit.enderEmit.fone);
    rllInscEstEmitente.Caption  := FNFe.emit.IE;
   end;
   *)
end;

procedure TfrmNFeDAInutRLRetrato.rlb_03_InutilizacaoBeforePrint(Sender: TObject; var PrintBand: Boolean);
begin
  inherited;

  with FACBrNFe.InutNFe do
    begin
      rllOrgao.Caption := IntToStr(cUF);

      case tpAmb of
       taProducao:    rllTipoAmbiente.Caption := 'PRODU��O';
       taHomologacao: rllTipoAmbiente.Caption := 'HOMOLOGA��O - SEM VALOR FISCAL';
      end;

      rllAno.Caption       := IntToStr(ano);
      rllModelo.Caption    := IntToStr(Modelo);
      rllSerie.Caption     := IntToStr(Serie);
      rllNumeracao.Caption := IntToStr(nNFIni) + ' a ' + IntToStr(nNFFin);

      rllStatus.Caption    := IntToStr(RetInutNFe.cStat) + ' - ' + RetInutNFe.xMotivo;
      rllProtocolo.Caption := RetInutNFe.nProt + ' ' +
                              DateTimeToStr(RetInutNFe.dhRecbto);

      rllJustificativa.Caption := xJust;
    end;
end;

procedure TfrmNFeDAInutRLRetrato.rlb_05_NaoUsado_DetalheBeforePrint(Sender: TObject;
  var PrintBand: Boolean);
begin
  inherited;
//  PrintBand := True;
end;

procedure TfrmNFeDAInutRLRetrato.rlb_06_NaoUsado_SummaryBeforePrint(
  Sender: TObject; var PrintBand: Boolean);
begin
  inherited;
//  PrintBand := True;
end;

procedure TfrmNFeDAInutRLRetrato.rlb_07_RodapeBeforePrint(
  Sender: TObject; var PrintBand: Boolean);
begin
  inherited;

  rllblSistema.Caption := FSistema + ' - ' + FUsuario;
end;

procedure TfrmNFeDAInutRLRetrato.rldbtxtValorPrint(sender: TObject;
  var Value: String);
var
  vLength: Integer;
begin
  inherited;
  (*
  vLength := 11 * ((Length(Value) div 90) + 1);

  rlb_08_Correcao_Detalhe.Height := vLength;

  rldbtxtValor.Height := vLength;
  rlShape11.Height    := vLength;
  rlShape3.Height     := vLength;
  rlShape6.Height     := vLength;
  rlShape4.Height     := vLength;
  *)
end;

procedure TfrmNFeDAInutRLRetrato.rlsQuadro01AfterPrint(Sender: TObject);
begin

end;

end.

