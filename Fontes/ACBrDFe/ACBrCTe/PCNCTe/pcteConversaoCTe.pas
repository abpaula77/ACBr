////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar CTe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da CTe          //
//                                                                            //
//        site: www.projetocooperar.org/cte                                   //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_cte/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa � software livre; voc� pode redistribu�-lo    //
//              e/ou modific�-lo sob os termos da Licen�a P�blica Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              vers�o 2 da Licen�a como (a seu crit�rio) qualquer vers�o     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa � distribu�do na expectativa de ser �til,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia impl�cita de  //
//              COMERCIALIZA��O ou de ADEQUA��O A QUALQUER PROP�SITO EM       //
//              PARTICULAR. Consulte a Licen�a P�blica Geral GNU para obter   //
//              mais detalhes. Voc� deve ter recebido uma c�pia da Licen�a    //
//              P�blica Geral GNU junto com este programa; se n�o, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licen�a oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licen�a  n�o  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  CTe", n�o  podendo o mesmo ser    //
//              utilizado sem previa autoriza��o.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manuten��o deste cabe�alho junto ao c�digo     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{$I ACBr.inc}

unit pcteConversaoCTe;

interface

uses
  SysUtils, StrUtils, Classes;

type

  TpcnTipoCTe = (tnEntrada, tnSaida);
  TpcnFinalidadeCTe = (fnNormal, fnComplementar, fnAjuste, fnDevolucao);

  TLayOutCTe = (LayCTeRecepcao, LayCTeRetRecepcao, LayCTeCancelamento,
                LayCTeInutilizacao, LayCTeConsulta, LayCTeStatusServico,
                LayCTeCadastro, LayCTeEvento, LayCTeEventoEPEC);

  TSchemaCTe = ( schErro, schCTe, schcancCTe, schInutCTe, schEventoCTe,
                 schconsReciCTe, schconsSitCTe, schconsStatServ, schconsCad,
                 schcteModalAereo, schcteModalAquaviario, schcteModalDutoviario,
                 schcteModalFerroviario, schcteModalRodoviario, schcteMultiModal,
                 schevEPECCTe, schevCancCTe, schevRegMultimodal, schevCCeCTe );

  TStatusACBrCTe = (stCTeIdle, stCTeStatusServico, stCTeRecepcao, stCTeRetRecepcao,
                    stCTeConsulta, stCTeCancelamento, stCTeInutilizacao,
                    stCTeRecibo, stCTeCadastro, stCTeEmail, stCTeCCe,
                    stCTeEvento, stCTeEnvioWebService);

  TVersaoCTe = (ve200);
  TpcnSituacaoCTe = (snAutorizado, snDenegado, snCancelada);

  TpcteFormaPagamento = (fpPago, fpAPagar, fpOutros);
  TpcteTipoCTe = (tcNormal, tcComplemento, tcAnulacao, tcSubstituto);
  TpcteTipoServico = (tsNormal, tsSubcontratacao, tsRedespacho, tsIntermediario, tsMultimodal);
  TpcteRetira = (rtSim, rtNao);
  TpcteTomador = ( tmRemetente, tmExpedidor, tmRecebedor, tmDestinatario, tmOutros);
  TpcteRspSeg = (rsRemetente, rsExpedidor, rsRecebedor, rsDestinatario, rsEmitenteCTe, rsTomadorServico);
  TpcteLotacao = (ltNao, ltSim);
  TpcteMask = (msk4x2, msk7x2, msk9x2, msk10x2, msk13x2, msk15x2, msk6x3, mskAliq);
  TpcteDirecao = (drNorte, drLeste, drSul, drOeste);
  TpcteTipoNavegacao = (tnInterior, tnCabotagem);
  TpcteTipoTrafego = (ttProprio, ttMutuo, ttRodoferroviario, ttRodoviario);
  TpcteTipoDataPeriodo = (tdSemData, tdNaData, tdAteData, tdApartirData, tdNoPeriodo, tdNaoInformado);
  TpcteTipoHorarioIntervalo = (thSemHorario, thNoHorario, thAteHorario, thApartirHorario, thNoIntervalo, thNaoInformado);
  TpcteTipoDocumento = (tdDeclaracao, tdDutoviario, tdOutros);
  TpcteTipoDocumentoAnterior = (daCTRC, daCTAC, daACT, daNF7, daNF27, daCAN, daCTMC, daATRE, daDTA, daCAI, daCCPI, daCA, daTIF, daOutros);
  TpcteRspPagPedagio = (rpEmitente, rpRemetente, rpExpedidor, rpRecebedor, rpDestinatario, rpTomadorServico);
  TpcteTipoDispositivo = (tdCartaoMagnetico, tdTAG, tdTicket);
  TpcteTipoPropriedade = (tpProprio, tpTerceiro);
  TpcteTrafegoMutuo = (tmOrigem, tmDestino);

const
//  CTecabMsg       = '2.00';
//  CTeconsStatServ = '2.00';
//  CTeenviCTe      = '2.00';
//  CTeconsReciCTe  = '2.00';
//  CTeconsSitCTe   = '2.00';
//  CTecancCTe      = '1.04';
//  CTeinutCTe      = '2.00';
//  CTeconsCad      = '2.00';
//  CTeEventoCTe    = '2.00';

  CTeModalRodo    = '2.00';
  CTeModalAereo   = '2.00';
  CTeModalAqua    = '2.00';
  CTeModalFerro   = '2.00';
  CTeModalDuto    = '2.00';
  CTeMultiModal   = '2.00';

function LayOutToServico(const t: TLayOutCTe): String;
function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutCTe;

function LayOutToSchema(const t: TLayOutCTe): TSchemaCTe;

function SchemaCTeToStr(const t: TSchemaCTe): String;
function StrToSchemaCTe(out ok: Boolean; const s: String): TSchemaCTe;

function tpNFToStr(const t: TpcnTipoCTe): String;
function StrToTpNF(out ok: Boolean; const s: String): TpcnTipoCTe;

function FinCTeToStr(const t: TpcnFinalidadeCTe): String;
function StrToFinCTe(out ok: Boolean; const s: String): TpcnFinalidadeCTe;

function SituacaoCTeToStr(const t: TpcnSituacaoCTe): String;
function StrToSituacaoCTe(out ok: Boolean; const s: String): TpcnSituacaoCTe;

function StrToVersaoCTe(out ok: Boolean; const s: String): TVersaoCTe;
function VersaoCTeToStr(const t: TVersaoCTe): String;

function DblToVersaoCTe(out ok: Boolean; const d: Double): TVersaoCTe;
function VersaoCTeToDbl(const t: TVersaoCTe): Double;

function tpforPagToStr(const t: TpcteFormaPagamento): string;
function tpforPagToStrText(const t: TpcteFormaPagamento): string;
function StrTotpforPag(out ok: boolean; const s: string): TpcteFormaPagamento;

function tpCTePagToStr(const t: TpcteTipoCTe): string;
function tpCTToStr(const t: TpcteTipoCTe): string;
function tpCTToStrText(const t: TpcteTipoCTe): string;
function StrTotpCTe(out ok: boolean; const s: string): TpcteTipoCTe;

function TpServPagToStr(const t: TpcteTipoServico): string;
function TpServToStrText(const t: TpcteTipoServico): string;
function StrToTpServ(out ok: boolean; const s: string): TpcteTipoServico;

function TpRetiraPagToStr(const t: TpcteRetira): string;
function StrToTpRetira(out ok: boolean; const s: string): TpcteRetira;

function TpTomadorPagToStr(const t: TpcteTomador): string;
function TpTomadorToStr(const t: TpcteTomador): String;
function TpTomadorToStrText(const t: TpcteTomador): String;
function StrToTpTomador(out ok: boolean; const s: String ): TpcteTomador;

function TpRspSeguroToStr(const t: TpcteRspSeg): String;
function TpRspSeguroToStrText(const t: TpcteRspSeg): String;
function StrToTpRspSeguro(out ok: boolean; const s: String ): TpcteRspSeg;

function TpLotacaoToStr(const t: TpcteLotacao): string;
function StrToTpLotacao(out ok: boolean; const s: String ): TpcteLotacao;

function TpMaskToStrText(const t: TpcteMask): string;
function StrToTpMask(out ok: boolean; const s: string): TpcteMask;

function TpDirecaoToStr(const t: TpcteDirecao): string;
function StrToTpDirecao(out ok: boolean; const s: string): TpcteDirecao;

function TpNavegacaoToStr(const t: TpcteTipoNavegacao): string;
function StrToTpNavegacao(out ok: boolean; const s: string): TpcteTipoNavegacao;

function TpTrafegoToStr(const t: TpcteTipoTrafego): string;
function StrToTpTrafego(out ok: boolean; const s: string): TpcteTipoTrafego;

function TpDataPeriodoToStr(const t: TpcteTipoDataPeriodo): string;
function StrToTpDataPeriodo(out ok: boolean; const s: string): TpcteTipoDataPeriodo;

function TpHorarioIntervaloToStr(const t: TpcteTipoHorarioIntervalo): string;
function StrToTpHorarioIntervalo(out ok: boolean; const s: string): TpcteTipoHorarioIntervalo;

function TpDocumentoToStr(const t: TpcteTipoDocumento): string;
function StrToTpDocumento(out ok: boolean; const s: string): TpcteTipoDocumento;

function TpDocumentoAnteriorToStr(const t: TpcteTipoDocumentoAnterior): string;
function StrToTpDocumentoAnterior(out ok: boolean; const s: string): TpcteTipoDocumentoAnterior;

function RspPagPedagioToStr(const t: TpcteRspPagPedagio): string;
function StrToRspPagPedagio(out ok: boolean; const s: string): TpcteRspPagPedagio;

function TpDispositivoToStr(const t: TpcteTipoDispositivo): string;
function StrToTpDispositivo(out ok: boolean; const s: string): TpcteTipoDispositivo;

function TpPropriedadeToStr(const t: TpcteTipoPropriedade): string;
function StrToTpPropriedade(out ok: boolean; const s: string): TpcteTipoPropriedade;

function TrafegoMutuoToStr(const t: TpcteTrafegoMutuo): string;
function StrToTrafegoMutuo(out ok: boolean; const s: string): TpcteTrafegoMutuo;

implementation

uses
  pcnConversao, typinfo;

function LayOutToServico(const t: TLayOutCTe): String;
begin
  Result := EnumeradoToStr(t,
    ['CTeRecepcao', 'CTeRetRecepcao', 'CTeCancelamento',
     'CTeInutilizacao', 'CTeConsultaProtocolo', 'CTeStatusServico',
     'CTeConsultaCadastro', 'RecepcaoEvento', 'RecepcaoEventoEPEC'],
    [ LayCTeRecepcao, LayCTeRetRecepcao, LayCTeCancelamento,
      LayCTeInutilizacao, LayCTeConsulta, LayCTeStatusServico,
      LayCTeCadastro, LayCTeEvento, LayCTeEventoEPEC]);
end;

function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutCTe;
begin
  Result := StrToEnumerado(ok, s,
    ['CTeRecepcao', 'CTeRetRecepcao', 'CTeCancelamento',
     'CTeInutilizacao', 'CTeConsultaProtocolo', 'CTeStatusServico',
     'CTeConsultaCadastro', 'RecepcaoEvento', 'RecepcaoEventoEPEC'],
    [ LayCTeRecepcao, LayCTeRetRecepcao, LayCTeCancelamento,
      LayCTeInutilizacao, LayCTeConsulta, LayCTeStatusServico,
      LayCTeCadastro, LayCTeEvento, LayCTeEventoEPEC]);
end;

function LayOutToSchema(const t: TLayOutCTe): TSchemaCTe;
begin
  case t of
    LayCTeRecepcao:       Result := schCTe;
    LayCTeRetRecepcao:    Result := schconsReciCTe;
    LayCTeCancelamento:   Result := schcancCTe;
    LayCTeInutilizacao:   Result := schInutCTe;
    LayCTeConsulta:       Result := schconsSitCTe;
    LayCTeStatusServico:  Result := schconsStatServ;
    LayCTeCadastro:       Result := schconsCad;
    LayCTeEvento:         Result := schEventoCTe;
  else
    Result := schErro;
  end;
end;

function SchemaCTeToStr(const t: TSchemaCTe): String;
begin
  Result := GetEnumName(TypeInfo(TSchemaCTe), Integer( t ) );
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaCTe(out ok: Boolean; const s: String): TSchemaCTe;
var
  P: Integer;
  SchemaStr: String;
begin
  P := pos('_', s);
  if P > 0 then
    SchemaStr := copy(s, 1, P-1)
  else
    SchemaStr := s;

  if LeftStr(SchemaStr, 3) <> 'sch' then
    SchemaStr := 'sch' + SchemaStr;

  Result := TSchemaCTe( GetEnumValue(TypeInfo(TSchemaCTe), SchemaStr ) );
end;

// B11 - Tipo do Documento Fiscal **********************************************
function tpNFToStr(const t: TpcnTipoCTe): String;
begin
  Result := EnumeradoToStr(t, ['0', '1'], [tnEntrada, tnSaida]);
end;

function StrToTpNF(out ok: Boolean; const s: String): TpcnTipoCTe;
begin
  Result := StrToEnumerado(ok, s, ['0', '1'], [tnEntrada, tnSaida]);
end;

// B25 - Finalidade de emiss�o da NF-e *****************************************
function FinCTeToStr(const t: TpcnFinalidadeCTe): String;
begin
  Result := EnumeradoToStr(t, ['1', '2', '3', '4'],
    [fnNormal, fnComplementar, fnAjuste, fnDevolucao]);
end;

function StrToFinCTe(out ok: Boolean; const s: String): TpcnFinalidadeCTe;
begin
  Result := StrToEnumerado(ok, s, ['1', '2', '3', '4'],
    [fnNormal, fnComplementar, fnAjuste, fnDevolucao]);
end;

function SituacaoCTeToStr(const t: TpcnSituacaoCTe): String;
begin
  Result := EnumeradoToStr(t, ['1', '2', '3'], [snAutorizado,
    snDenegado, snCancelada]);
end;

function StrToSituacaoCTe(out ok: Boolean; const s: String): TpcnSituacaoCTe;
begin
  Result := StrToEnumerado(ok, s, ['1', '2', '3'], [snAutorizado,
    snDenegado, snCancelada]);
end;

function StrToVersaoCTe(out ok: Boolean; const s: String): TVersaoCTe;
begin
  Result := StrToEnumerado(ok, s, ['2.00'], [ve200]);
end;

function VersaoCTeToStr(const t: TVersaoCTe): String;
begin
  Result := EnumeradoToStr(t, ['2.00'], [ve200]);
end;

function DblToVersaoCTe(out ok: Boolean; const d: Double): TVersaoCTe;
begin
  ok := True;

  if d = 2.0 then
    Result := ve200
  else
  begin
    Result := ve200;
    ok := False;
  end;
end;

function VersaoCTeToDbl(const t: TVersaoCTe): Double;
begin
  case t of
    ve200: Result := 2.0;
  else
    Result := 0;
  end;
end;

function tpCTToStr(const t: TpcteTipoCTe): string;
begin
  result := EnumeradoToStr(t, ['0', '1', '2', '3'], [tcNormal, tcComplemento, tcAnulacao, tcSubstituto]);
end;

function tpCTToStrText(const t: TpcteTipoCTe): string;
begin
  result := EnumeradoToStr(t, ['NORMAL', 'COMPLEMENTO', 'ANULA��O', 'SUBSTITUTO'], [tcNormal, tcComplemento, tcAnulacao, tcSubstituto]);
end;

function TpMaskToStrText(const t: TpcteMask): string;
begin
  result := EnumeradoToStr(t, ['#,##0.00', '#,###,##0.00', '###,###,##0.00', '#,###,###,##0.00', '#,###,###,###,##0.00', '###,###,###,###,##0.00', '###,##0.000', '#00%'],
    [msk4x2, msk7x2, msk9x2, msk10x2, msk13x2, msk15x2, msk6x3, mskAliq]);
end;

function StrToTpMask(out ok: boolean; const s: string): TpcteMask;
begin
  result := StrToEnumerado(ok, s, ['#,##0.00', '#,###,##0.00', '#,###,###,##0.00', '#,###,###,###,##0.00', '###,###,###,###,##0.00', '###,##0.000', '#00%'],
    [msk4x2, msk7x2, msk10x2, msk13x2, msk15x2, msk6x3, mskAliq]);
end;

function tpforPagToStr(const t: TpcteFormaPagamento): string;
begin
  result := EnumeradoToStr(t, ['0','1', '2'], [fpPago, fpAPagar, fpOutros]);
end;

function tpforPagToStrText(const t: TpcteFormaPagamento): string;
begin
  result := EnumeradoToStr(t, ['PAGO','A PAGAR', 'OUTROS'], [fpPago, fpAPagar, fpOutros]);
end;

function StrTotpforPag(out ok: boolean; const s: string): TpcteFormaPagamento;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2'], [fpPago, fpAPagar, fpOutros]);
end;

function tpCTePagToStr(const t: TpcteTipoCTe): string;
begin
  result := EnumeradoToStr(t, ['0','1', '2', '3'], [tcNormal, tcComplemento, tcAnulacao, tcSubstituto]);
end;

function StrTotpCTe(out ok: boolean; const s: string): TpcteTipoCTe;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3'], [tcNormal, tcComplemento, tcAnulacao, tcSubstituto]);
end;

function TpServPagToStr(const t: TpcteTipoServico): string;
begin
  result := EnumeradoToStr(t, ['0','1', '2', '3', '4'],
                              [tsNormal, tsSubcontratacao, tsRedespacho, tsIntermediario, tsMultimodal]);
end;

function TpServToStrText(const t: TpcteTipoServico): string;
begin
  result := EnumeradoToStr(t, ['NORMAL','SUBCONTRATA��O', 'REDESPACHO', 'REDESP. INTERMEDI�RIO', 'VINC. A MULTIMODAL'],
                              [tsNormal, tsSubcontratacao, tsRedespacho, tsIntermediario, tsMultimodal]);
end;

function StrToTpServ(out ok: boolean; const s: string): TpcteTipoServico;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3', '4'],
                                  [tsNormal, tsSubcontratacao, tsRedespacho, tsIntermediario, tsMultimodal]);
end;

function TpRetiraPagToStr(const t: TpcteRetira): string;
begin
  result := EnumeradoToStr(t, ['0','1'], [rtSim, rtNao]);
end;

function StrToTpRetira(out ok: boolean; const s: string): TpcteRetira;
begin
  result := StrToEnumerado(ok, s, ['0', '1'], [rtSim, rtNao]);
end;

function TpTomadorPagToStr(const t: TpcteTomador): string;
begin
  result := EnumeradoToStr(t, ['0','1', '2', '3', '4'], [tmRemetente, tmExpedidor, tmRecebedor, tmDestinatario, tmOutros]);
end;

function TpTomadorToStr(const t: TpcteTomador): String;
begin
  result := EnumeradoToStr(t, ['0', '1', '2', '3', '4'], [tmRemetente, tmExpedidor, tmRecebedor, tmDestinatario, tmOutros]);
end;

function TpTomadorToStrText(const t: TpcteTomador): String;
begin
  result := EnumeradoToStr(t, ['REMETENTE', 'EXPEDIDOR', 'RECEBEDOR', 'DESTINATARIO', 'OUTROS'],
    [tmRemetente, tmExpedidor, tmRecebedor, tmDestinatario, tmOutros]);
end;

function TpRspSeguroToStr(const t: TpcteRspSeg): String;
begin
  result := EnumeradoToStr(t, ['0', '1', '2', '3', '4', '5'], [rsRemetente, rsExpedidor, rsRecebedor, rsDestinatario, rsEmitenteCTe, rsTomadorServico]);
end;

function TpRspSeguroToStrText(const t: TpcteRspSeg): String;
begin
  result := EnumeradoToStr(t, ['REMETENTE', 'EXPEDIDOR', 'RECEBEDOR', 'DESTINATARIO', 'EMITENTE', 'TOMADOR SERVICO'],
    [rsRemetente, rsExpedidor, rsRecebedor, rsDestinatario, rsEmitenteCTe, rsTomadorServico]);
end;

function TpLotacaoToStr(const t: TpcteLotacao): string;
begin
  result := EnumeradoToStr(t, ['0','1'], [ltNao, ltSim]);
end;

function StrToTpTomador(out ok: boolean; const s: String ): TpcteTomador;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3', '4'], [tmRemetente, tmExpedidor, tmRecebedor, tmDestinatario, tmOutros]);
end;

function StrToTpRspSeguro(out ok: boolean; const s: String ): TpcteRspSeg;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3', '4', '5'], [rsRemetente, rsExpedidor, rsRecebedor, rsDestinatario, rsEmitenteCTe, rsTomadorServico]);
end;

function StrToTpLotacao(out ok: boolean; const s: String ): TpcteLotacao;
begin
  result := StrToEnumerado(ok, s, ['0', '1'], [ltNao, ltSim]);
end;

function TpDirecaoToStr(const t: TpcteDirecao): string;
begin
  result := EnumeradoToStr(t, ['N','L','S','O'], [drNorte , drLeste, drSul, drOeste]);
end;

function StrToTpDirecao(out ok: boolean; const s: string): TpcteDirecao;
begin
  result := StrToEnumerado(ok, s, ['N','L','S','O'], [drNorte , drLeste, drSul, drOeste]);
end;

function TpNavegacaoToStr(const t: TpcteTipoNavegacao): string;
begin
  result := EnumeradoToStr(t, ['0','1'], [tnInterior , tnCabotagem]);
end;

function StrToTpNavegacao(out ok: boolean; const s: string): TpcteTipoNavegacao;
begin
  result := StrToEnumerado(ok, s, ['0','1'], [tnInterior , tnCabotagem]);
end;

function TpTrafegoToStr(const t: TpcteTipoTrafego): string;
begin
  result := EnumeradoToStr(t, ['0','1','2','3'], [ttProprio , ttMutuo, ttRodoferroviario, ttRodoviario]);
end;

function StrToTpTrafego(out ok: boolean; const s: string): TpcteTipoTrafego;
begin
  result := StrToEnumerado(ok, s, ['0','1','2','3'], [ttProprio , ttMutuo, ttRodoferroviario, ttRodoviario]);
end;

function TpDataPeriodoToStr(const t: TpcteTipoDataPeriodo): string;
begin
  result := EnumeradoToStr(t, ['0','1','2','3','4','N'],
                              [tdSemData, tdNaData, tdAteData, tdApartirData, tdNoPeriodo, tdNaoInformado]);
end;

function StrToTpDataPeriodo(out ok: boolean; const s: string): TpcteTipoDataPeriodo;
begin
  result := StrToEnumerado(ok, s, ['0','1','2','3','4','N'],
                                  [tdSemData, tdNaData, tdAteData, tdApartirData, tdNoPeriodo, tdNaoInformado]);
end;

function TpHorarioIntervaloToStr(const t: TpcteTipoHorarioIntervalo): string;
begin
  result := EnumeradoToStr(t, ['0','1','2','3','4','N'],
                              [thSemHorario, thNoHorario, thAteHorario, thApartirHorario, thNoIntervalo, thNaoInformado]);
end;

function StrToTpHorarioIntervalo(out ok: boolean; const s: string): TpcteTipoHorarioIntervalo;
begin
  result := StrToEnumerado(ok, s, ['0','1','2','3','4','N'],
                                  [thSemHorario, thNoHorario, thAteHorario, thApartirHorario, thNoIntervalo, thNaoInformado]);
end;

function TpDocumentoToStr(const t: TpcteTipoDocumento): string;
begin
  result := EnumeradoToStr(t, ['00','10','99'], [tdDeclaracao, tdDutoviario, tdOutros]);
end;

function StrToTpDocumento(out ok: boolean; const s: string): TpcteTipoDocumento;
begin
  result := StrToEnumerado(ok, s, ['00','10','99'], [tdDeclaracao, tdDutoviario, tdOutros]);
end;

function TpDocumentoAnteriorToStr(const t: TpcteTipoDocumentoAnterior): string;
begin
  result := EnumeradoToStr(t, ['00','01','02','03','04','05','06','07','08','09','10','11','12','99'],
   [daCTRC, daCTAC, daACT, daNF7, daNF27, daCAN, daCTMC, daATRE, daDTA, daCAI, daCCPI, daCA, daTIF, daOutros]);
end;

function StrToTpDocumentoAnterior(out ok: boolean; const s: string): TpcteTipoDocumentoAnterior;
begin
  result := StrToEnumerado(ok, s, ['00','01','02','03','04','05','06','07','08','09','10','11','12','99'],
   [daCTRC, daCTAC, daACT, daNF7, daNF27, daCAN, daCTMC, daATRE, daDTA, daCAI, daCCPI, daCA, daTIF, daOutros]);
end;

function RspPagPedagioToStr(const t: TpcteRspPagPedagio): string;
begin
  result := EnumeradoToStr(t, ['0','1','2','3','4','5'], [rpEmitente, rpRemetente, rpExpedidor, rpRecebedor, rpDestinatario, rpTomadorServico]);
end;

function StrToRspPagPedagio(out ok: boolean; const s: string): TpcteRspPagPedagio;
begin
  result := StrToEnumerado(ok, s, ['0','1','2','3','4','5'], [rpEmitente, rpRemetente, rpExpedidor, rpRecebedor, rpDestinatario, rpTomadorServico]);
end;

function TpDispositivoToStr(const t: TpcteTipoDispositivo): string;
begin
  result := EnumeradoToStr(t, ['1','2','3'], [tdCartaoMagnetico, tdTAG, tdTicket]);
end;

function StrToTpDispositivo(out ok: boolean; const s: string): TpcteTipoDispositivo;
begin
  result := StrToEnumerado(ok, s, ['1','2','3'], [tdCartaoMagnetico, tdTAG, tdTicket]);
end;

function TpPropriedadeToStr(const t: TpcteTipoPropriedade): string;
begin
  result := EnumeradoToStr(t, ['P','T'], [tpProprio, tpTerceiro]);
end;

function StrToTpPropriedade(out ok: boolean; const s: string): TpcteTipoPropriedade;
begin
  result := StrToEnumerado(ok, s, ['P','T'], [tpProprio, tpTerceiro]);
end;

function TrafegoMutuoToStr(const t: TpcteTrafegoMutuo): string;
begin
  result := EnumeradoToStr(t, ['1','2'],
   [tmOrigem, tmDestino]);
end;

function StrToTrafegoMutuo(out ok: boolean; const s: string): TpcteTrafegoMutuo;
begin
  result := StrToEnumerado(ok, s, ['1','2'],
   [tmOrigem, tmDestino]);
end;

end.
