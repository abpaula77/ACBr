{******************************************************************************}
{ Projeto: Componente ACBrReinf                                                }
{  Biblioteca multiplataforma de componentes Delphi para envio de eventos do   }
{ Reinf                                                                        }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }


{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}
{******************************************************************************
|* Historico
|*
|* 04/12/2017: Renato Rubinho
|*  - Implementados registros que faltavam e isoladas as respectivas classes 
*******************************************************************************}

unit pcnConversaoReinf;

{$I ACBr.inc}

interface

uses
  SysUtils, Classes;

type

  tpTpInsc                = (tiCNPJ, tiCPF, tiCNO);

  TpTpInscProp            = (tpCNPJ, tpCPF);

  TLayOutReinf            = (LayEnvioLoteEventos, LayConsultaLoteEventos);

  TStatusReinf            = (stIdle, stEnvLoteEventos, stConsultaLote);

  TTypeOperacao           = (toInclusao, toAlteracao, toExclusao);

  TpTpAmb                 = (taNenhum, taProducao, taProducaoRestritaDadosReais, taProducaoRestritaDadosFicticios);

  tpSimNao                = (tpSim, tpNao);

  TpProcEmi               = (peNenhum, peAplicEmpregador, peAplicGoverno);

  TpIndCoop               = (icNaoecooperativa, icCooperativadeTrabalho, icCooperativadeProducao, icOutrasCooperativas );

  tpTpProc                = (tpAdministrativo, tpJudicial);

  tpIndSusp               = (siLiminarMandadoSeguranca,
                             siAntecipacaoTutela,
                             siLiminarMedidaCautelar,
                             siSentencaMandadoSegurancaFavoravelContribuinte ,
                             siSentencaAcaoOrdinariaFavContribuinteConfirmadaPeloTRF,
                             siAcordaoTRFFavoravelContribuinte,
                             siAcordaoSTJRecursoEspecialFavoravelContribuinte,
                             siAcordaoSTFRecursoExtraordinarioFavoravelContribuinte,
                             siSentenca1instanciaNaoTransitadaJulgadoEfeitoSusp,
                             siDecisaoDefinitivaAFavorDoContribuinte,
                             siSemSuspensaoDaExigibilidade);

  TTipoEvento             = (teR1000, teR1070, teR2010, teR2020, teR2030,
                             teR2040, teR2050, teR2060, teR2070, teR2098,
                             teR2099, teR3010, teR5001, teR5011, teR9000);

  TindSitPJ               = (spNormal, spExtincao, spFusao, spCisao, spIncorporacao);

  TindAutoria             = (taContribuinte, taOutraEntidade);

  TIndRetificacao         = (trOriginal, trRetificacao);

  TpindObra               = (ioNaoeObraDeConstrucaoCivil,
                             ioObradeConstrucaoCivilTotal,
                             ioObradeConstrucaoCivilParcial);

  TpindCPRB               = (icNaoContribuintePrevidenciariaReceitaBruta,
                             icContribuintePrevidenciaReceitaBruta);

  TtpProcRetPrinc         = (tprAdministrativoTomador, tprJudicialTomador,
                             tprJudicialPrestador);

  TReinfSchema            = (
                            schevtInfoContri,         // R-1000 - Informa��es do Contribuinte
                            schevtTabProcesso,        // R-1070 - Tabela de Processos Administrativos/Judiciais
                            schevtServTom,            // R-2010 - Reten��o Contribui��o Previdenci�ria - Servi�os Tomados
                            schevtServPrest,          // R-2020 - Reten��o Contribui��o Previdenci�ria - Servi�os Prestados
                            schevtAssocDespRec,       // R-2030 - Recursos Recebidos por Associa��o Desportiva
                            schevtAssocDespRep,       // R-2040 - Recursos Repassados para Associa��o Desportiva
                            schevtComProd,            // R-2050 - Comercializa��o da Produ��o por Produtor Rural PJ/Agroind�stria
                            schevtCPRB,               // R-2060 - Contribui��o Previdenci�ria sobre a Receita Bruta - CPRB
                            schevtPgtosDivs,          // R-2070 - Reten��es na Fonte - IR, CSLL, Cofins, PIS/PASEP
                            schevtReabreEvPer,        // R-2098 - Reabertura dos Eventos Peri�dicos
                            schevtFechaEvPer,         // R-2099 - Fechamento dos Eventos Peri�dicos
                            schevtEspDesportivo,      // R-3010 - Receita de Espet�culo Desportivo
                            schevtTotal,              // R-5001 - Informa��es das bases e dos tributos consolidados por contribuinte
                            schevtTotalConsolid,      // R-5011 - Informa��es de bases e tributos consolidadas por per�odo de apura��o
                            schevtExclusao,           // R-9000 - Exclus�o de Eventos
                            schErro, schConsultaLoteEventos, schEnvioLoteEventos
                            );

  TtpAjuste               = (taReducao, taAcrescimo);

  TcodAjuste              = (
                            caRegimeCaixa = 1,           // Ajuste da CPRB: Ado��o do Regime de Caixa
                            caDifValRecPer = 2,          // Ajuste da CPRB: Diferimento de Valores a recolher no per�odo
                            caAdiValDif = 3,             // Adi��o de valores Diferidos em Per�odo(s) Anteriores(es)
                            caExpDiretas = 4,            // Exporta��es diretas
                            caTransInternacional = 5,    // Transporte internacional de cargas
                            caVendasCanceladas = 6,      // Vendas canceladas e os descontos incondicionais concedidos
                            caIPI = 7,                   // IPI, se inclu�do na receita bruta
                            caICMS = 8,                  // ICMS, quando cobrado pelo vendedor dos bens ou prestador dos servi�os na condi��o de substituto tribut�rio
                            caReceBruta = 9,             // Receita bruta reconhecida pela constru��o, recupera��o, reforma, amplia��o ou melhoramento da infraestrutura, cuja contrapartida seja ativo intang�vel representativo de direito de explora��o, no caso de contratos de concess�o de servi�os p�blicos
                            caValAporte = 10,            // O valor do aporte de recursos realizado nos termos do art 6 �3 inciso III da Lei 11.079/2004
                            caOutras = 11                // Demais ajustes oriundos da Legisla��o Tribut�ria, estorno ou outras situa��es
                            );

  TindExistInfo           = (
                            eiComMovComInfo = 1,    // H� informa��es de bases e/ou de tributos
                            eiComMovSemInfo = 2,    // H� movimento, por�m n�o h� informa��es de bases ou de tributos
                            eiSemMov = 3            // N�o h� movimento na compet�ncia
                            );

  TindEscrituracao        = ( ieNaoObrig,  // 0 - N�o � obrigada
                              ieObrig      // 1 - Empresa obrigada a entregar a ECD
                            );

  TindDesoneracao         = ( idNaoAplic,  // 0 - N�o Aplic�vel
                              idAplic      // 1 - Empresa enquadrada nos art. 7� a 9� da Lei 12.546/2011
                            );

  TindAcordoIsenMulta     = ( aiSemAcordo, // 0 - Sem acordo
                              aiComAcordo  // 1 - Com acordo
                            );

  TindNIF                 = ( nifCom = 1,        // 1 - Benefici�rio com NIF;
                              nifDispensado = 2, // 2 - Benefici�rio dispensado do NIF
                              nifNaoExige = 3    // 3 - Pa�s n�o exige NIF
                            );

  TindTpDeducao           = ( itdOficial = 1,    // 1 - Previd�ncia Oficial
                              itdPrivada = 2,    // 2 - Previd�ncia Privada
                              itdFapi = 3,       // 3 - Fapi
                              itdFunpresp = 4,   // 4 - Funpresp
                              itdPensao = 5,     // 5 - Pens�o Aliment�cia
                              itdDependentes = 6 // 6 - Dependentes
                            );

  TtpIsencao              = ( tiIsenta = 1,              // 1 - Parcela Isenta 65 anos
                              tiAjudaCusto = 2,          // 2 - Di�ria e Ajuda de Custo
                              tiIndenizaRescisao = 3,    // 3 - Indeniza��o e rescis�o de contrato, inclusive a t�tulo de PDV
                              tiAbono = 4,               // 4 - Abono pecuni�rio
                              tiOutros = 5,              // 5 - Outros (especificar)
                              tiLucros = 6,              // 6 - Lucros e dividendos pagos a partir de 1996
                              tiSocioMicroempresa = 7,   // 7 - Valores pagos a titular ou s�cio de microempresa ou empresa de pequeno porte, exceto pr�-labore e alugueis
                              tiPensaoAposentadoria = 8, // 8 - Pens�o, aposentadoria ou reforma por mol�stia grave ou acidente em servi�o
                              tiBeneficiosIndiretos = 9, // 9 - Benef�cios indiretos e/ou reembolso de despesas recebidas por volunt�rio da copa do mundo ou da copa das confedera��es
                              tiBolsaEstudo = 10,        // 10 - Bolsa de estudo recebida por m�dico-residente
                              tiComplAposentadoria = 11  // 11 - Complementa��o de aposentadoria, correspondente �s contribui��es efetuadas no per�odo de 01/01/1989 a 31/12/1995
                            );

  TindPerReferencia       = ( iprMensal = 1,     // 1 - Folha de Pagamento Mensal
                              iprDecTerceiro = 2 // 2 - Folha do D�cimo Terceiro Sal�rio
                            );

  TindOrigemRecursos      = ( iorProprios = 1, // 1 - Recursos do pr�prio declarante
                              iorTerceiros = 2 // 2 - Recursos de terceiros - Declarante � a Institui��o Financeira respons�vel apenas pelo repasse dos valores
                            );

  TtpRepasse              = ( trPatrocinio,    // 1 - Patroc�nio
                              trLicenciamento, // 2 - Licenciamento de marcas e s�mbolos
                              trPublicidade,   // 3 - Publicidade
                              trPropaganda,    // 4 - Propaganda
                              trTransmissao    // 5 - Transmiss�o de espet�culos
                            );

  TindCom                 = ( icProdRural,  // 1 - Comercializa��o da Produ��o por Prod. Rural PJ/Agroind�stria, exceto para entidades executoras do PAA
                              icPAA,        // 8 - Comercializa��o da Produ��o para Entidade do Programa de Aquisi��o de Alimentos - PAA
                              icMercExterno // 9 - Comercializa��o direta da Produ��o no Mercado Externo
                            );

  TtpCompeticao           = ( ttcOficial = 1,   // 1 - Oficial
                              ttcnaoOficial = 2 // 2 - N�o Oficial
                            );

  TcategEvento            = ( tceInternacional = 1,  // 1 - Internacional
                              tceInterestadual = 2,  // 2 - Interestadual
                              tceEstadual = 3,       // 3 - Estadual
                              tceLocal = 4           // 4 - Local
                            );

  TtpIngresso             = ( ttiArquibancada = 1, // 1 - Arquibancada
                              ttiGeral = 2,        // 2 - Geral
                              ttiCadeiras = 3,     // 3 - Cadeiras
                              ttiCamarote = 4      // 4 - Camarote
                            );

  TtpReceita              = ( ttrTransmissso = 1, // 1 - Transmiss�o
                              ttrPropaganda = 2,  // 2 - Propaganda
                              ttrPublicidade = 3, // 3 - Publicidade
                              ttrSorteio = 4,     // 4 - Sorteio
                              ttrOutros = 5       // 5 - Outros
                            );

   TVersaoReinf           = ( v1_02_00, // v1.2
                              v1_03_00  // v1.3
                            );

const
  PrefixVersao = '-v';
  TReinfSchemaStr : array[0..14] of string = ('evtInfoContribuinte',                 // R-1000 - Informa��es do Contribuinte
                                              'evtTabProcesso',                      // R-1070 - Tabela de Processos Administrativos/Judiciais
                                              'evtTomadorServicos',                  // R-2010 - Reten��o Contribui��o Previdenci�ria - Servi�os Tomados
                                              'evtPrestadorServicos',                // R-2020 - Reten��o Contribui��o Previdenci�ria - Servi�os Prestados
                                              'evtRecursoRecebidoAssociacao',        // R-2030 - Recursos Recebidos por Associa��o Desportiva
                                              'evtRecursoRepassadoAssociacao',       // R-2040 - Recursos Repassados para Associa��o Desportiva
                                              'evtInfoProdRural',                    // R-2050 - Comercializa��o da Produ��o por Produtor Rural PJ/Agroind�stria
                                              'evtInfoCPRB',                         // R-2060 - Contribui��o Previdenci�ria sobre a Receita Bruta - CPRB
                                              'evtPagamentosDiversos',               // R-2070 - Reten��es na Fonte - IR, CSLL, Cofins, PIS/PASEP
                                              'evtReabreEvPer',                      // R-2098 - Reabertura dos Eventos Peri�dicos
                                              'evtFechamento',                       // R-2099 - Fechamento dos Eventos Peri�dicos
                                              'evtEspDesportivo',                    // R-3010 - Receita de Espet�culo Desportivo
                                              'evtTotal',                            // R-5001 - Informa��es das bases e dos tributos consolidados por contribuinte
                                              'evtTotalConsolid',                    // R-5011 - Informa��es de bases e tributos consolidadas por per�odo de apura��o
                                              'evtExclusao'                          // R-9000 - Exclus�o de Eventos
                                              );

  TReinfSchemaRegistro : array[0..14] of string = ('R-1000', // rsevtInfoContri    - Informa��es do Contribuinte
                                                   'R-1070', // rsevtTabProcesso   - Tabela de Processos Administrativos/Judiciais
                                                   'R-2010', // rsevtServTom       - Reten��o Contribui��o Previdenci�ria - Servi�os Tomados
                                                   'R-2020', // rsevtServPrest     - Reten��o Contribui��o Previdenci�ria - Servi�os Prestados
                                                   'R-2030', // rsevtAssocDespRec  - Recursos Recebidos por Associa��o Desportiva
                                                   'R-2040', // rsevtAssocDespRep  - Recursos Repassados para Associa��o Desportiva
                                                   'R-2050', // rsevtComProd       - Comercializa��o da Produ��o por Produtor Rural PJ/Agroind�stria
                                                   'R-2060', // rsevtCPRB          - Contribui��o Previdenci�ria sobre a Receita Bruta - CPRB
                                                   'R-2070', // rsevtPgtosDivs     - Reten��es na Fonte - IR, CSLL, Cofins, PIS/PASEP
                                                   'R-2098', // rsevtReabreEvPer   - Reabertura dos Eventos Peri�dicos
                                                   'R-2099', // rsevtFechaEvPer    - Fechamento dos Eventos Peri�dicos
                                                   'R-3010', // rsevtEspDesportivo - Receita de Espet�culo Desportivo
                                                   'R-5001', // rsevtTotal         - Informa��es das bases e dos tributos consolidados por contribuinte
                                                   'R-5011', // rsevtTotalConsolid - Informa��es de bases e tributos consolidadas por per�odo de apura��o
                                                   'R-9000'  // rsevtExclusao      - Exclus�o de Eventos
                                                   );

function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutReinf;
function SchemaReinfToStr(const t: TReinfSchema): String;
function LayOutToSchema(const t: TLayOutReinf): TReinfSchema;
function LayOutReinfToServico(const t: TLayOutReinf): String;
function VersaoReinfToDbl(const t: TVersaoReinf): Real;
function VersaoReinfToStr(const t: TVersaoReinf): String;

function TpInscricaoToStr(const t: tpTpInsc ): string;
function StrToTpInscricao(var ok: boolean; const s: string): tpTpInsc;

function tpAmbReinfToStr(const t: TptpAmb ): string;
function StrTotpAmbReinf(var ok: boolean; const s: string): TptpAmb;

function procEmiReinfToStr(const t: TpprocEmi ): string;
function StrToprocEmiReinf(var ok: boolean; const s: string): TpprocEmi;

function indEscrituracaoToStr(const t: TindEscrituracao ): string;
function StrToindEscrituracao(var ok: boolean; const s: string): TindEscrituracao;

function indDesoneracaoToStr(const t: TindDesoneracao ): string;
function StrToindDesoneracao(var ok: boolean; const s: string): TindDesoneracao;

function indAcordoIsenMultaToStr(const t: TindAcordoIsenMulta ): string;
function StrToindAcordoIsenMulta(var ok: boolean; const s: string): TindAcordoIsenMulta;

function indSitPJToStr(const t: TindSitPJ ): string;
function StrToindSitPJ(var ok: boolean; const s: string): TindSitPJ;

function SimNaoToStr(const t: tpSimNao): string;
function StrToSimNao(var ok: boolean; const s: string): tpSimNao;

function TpProcToStr(const t: tpTpProc ): string;
function StrToTpProc(var ok: boolean; const s: string): tpTpProc;

function indAutoriaToStr(const t: TindAutoria ): string;
function StrToindAutoria(var ok: boolean; const s: string): TindAutoria;

function IndSuspToStr(const t: tpIndSusp ): string;
function StrToIndSusp(var ok: boolean; const s: string): tpIndSusp;

function IndRetificacaoToStr(const t: TIndRetificacao ): string;
function StrToIndRetificacao(var ok: boolean; const s: string): TIndRetificacao;

function indObraToStr(const t: TpindObra ): string;
function StrToindObra(var ok: boolean; const s: string): TpindObra;

function indCPRBToStr(const t: TpindCPRB ): string;
function StrToindCPRB(var ok: boolean; const s: string): TpindCPRB;

function tpProcRetPrincToStr(const t: TtpProcRetPrinc ): string;
function StrTotpProcRetPrinc(var ok: boolean; const s: string): TtpProcRetPrinc;

function tpRepasseToStr(const t: TtpRepasse ): string;
function StrTotpRepasse(var ok: boolean; const s: string): TtpRepasse;

function indComToStr(const t: TindCom ): string;
function StrToindCom(var ok: boolean; const s: string): TindCom;



implementation

uses
  pcnConversao, typinfo;

function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutReinf;
begin
   Result := StrToEnumerado(ok, s,
    ['EnviarLoteEventos', 'ConsultarLoteEventos'],
    [ LayEnvioLoteEventos, LayConsultaLoteEventos ] );
end;

function SchemaReinfToStr(const t: TReinfSchema): String;
begin
  Result := GetEnumName(TypeInfo(TReinfSchema), Integer( t ) );
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function LayOutToSchema(const t: TLayOutReinf): TReinfSchema;
begin
   case t of
    LayEnvioLoteEventos:    Result := schEnvioLoteEventos;
    LayConsultaLoteEventos: Result := schConsultaLoteEventos;
  else
    Result := schErro;
  end;
end;

function LayOutReinfToServico(const t: TLayOutReinf): String;
begin
   Result := EnumeradoToStr(t,
    ['EnviarLoteEventos', 'ConsultarLoteEventos'],
    [ LayEnvioLoteEventos, LayConsultaLoteEventos ] );
end;

function VersaoReinfToDbl(const t: TVersaoReinf): Real;
begin
  case t of
    v1_02_00: result := 1.02;
    v1_03_00: result := 1.03;
  else
    result := 0;
  end;
end;

function VersaoReinfToStr(const t: TVersaoReinf): String;
begin
  result := EnumeradoToStr(t, ['1_02_00', '1_03_00'], [v1_02_00, v1_03_00]);
end;

function TpInscricaoToStr(const t:tpTpInsc ): string;
begin
  result := EnumeradoToStr2(t, ['1', '2', '4'] );
end;

function StrToTpInscricao(var ok: boolean; const s: string): tpTpInsc;
begin
  result := tpTpInsc( StrToEnumerado2(ok , s, ['1', '2', '4'] ) );
end;

function tpAmbReinfToStr(const t: TptpAmb ): string;
begin
  result := EnumeradoToStr2(t, ['0', '1', '2', '3']);
end;

function StrTotpAmbReinf(var ok: boolean; const s: string): TptpAmb;
begin
  result := TptpAmb( StrToEnumerado2(ok , s, ['0', '1', '2', '3']) );
end;

function ProcEmiReinfToStr(const t: TpProcEmi ): string;
begin
  result := EnumeradoToStr2(t, ['0', '1', '2']);
end;

function StrToProcEmiReinf(var ok: boolean; const s: string): TpProcEmi;
begin
  result := TpProcEmi( StrToEnumerado2(ok , s, ['0', '1', '2']) );
end;

function indEscrituracaoToStr(const t: TindEscrituracao ): string;
begin
  result := EnumeradoToStr2(t, ['0', '1']);
end;

function StrToindEscrituracao(var ok: boolean; const s: string): TindEscrituracao;
begin
  result := TindEscrituracao( StrToEnumerado2(ok , s, ['0', '1']) );
end;

function indDesoneracaoToStr(const t: TindDesoneracao ): string;
begin
  result := EnumeradoToStr2(t, ['0', '1']);
end;

function StrToindDesoneracao(var ok: boolean; const s: string): TindDesoneracao;
begin
  result := TindDesoneracao( StrToEnumerado2(ok , s, ['0', '1']) );
end;

function indAcordoIsenMultaToStr(const t: TindAcordoIsenMulta ): string;
begin
  result := EnumeradoToStr2(t, ['0', '1']);
end;

function StrToindAcordoIsenMulta(var ok: boolean; const s: string): TindAcordoIsenMulta;
begin
  result := TindAcordoIsenMulta( StrToEnumerado2(ok , s, ['0', '1']) );
end;

function indSitPJToStr(const t: TindSitPJ ): string;
begin
  result := EnumeradoToStr2(t, ['0', '1', '2', '3', '4']);
end;

function StrToindSitPJ(var ok: boolean; const s: string): TindSitPJ;
begin
  result := TindSitPJ( StrToEnumerado2(ok , s, ['0', '1', '2', '3', '4']) );
end;

function SimNaoToStr(const t: tpSimNao): string;
begin
  result := EnumeradoToStr2(t, ['S', 'N']);
end;

function StrToSimNao(var ok: boolean; const s: string): tpSimNao;
begin
  result := tpSimNao( StrToEnumerado2(ok , s, ['S', 'N']) );
end;

function TpProcToStr(const t: tpTpProc ): string;
begin
  result := EnumeradoToStr2(t, ['1', '2']);
end;

function StrToTpProc(var ok: boolean; const s: string): tpTpProc;
begin
  result := tpTpProc( StrToEnumerado2(ok , s, ['1', '2']) );
end;

function indAutoriaToStr(const t: TindAutoria ): string;
begin
  result := EnumeradoToStr2(t, ['1', '2']);
end;

function StrToindAutoria(var ok: boolean; const s: string): TindAutoria;
begin
  result := TindAutoria( StrToEnumerado2(ok , s, ['1', '2']) );
end;

function IndSuspToStr(const t: tpIndSusp ): string;
begin
  result := EnumeradoToStr2(t, ['01', '04', '05', '08', '09', '10', '11', '12',
                                '13', '90', '92']);
end;

function StrToIndSusp(var ok: boolean; const s: string): tpIndSusp;
begin
  result := tpIndSusp( StrToEnumerado2(ok , s, ['01', '04', '05', '08', '09',
                                                '10', '11', '12', '13', '90',
                                                '92']) );
end;

function IndRetificacaoToStr(const t: TIndRetificacao ): string;
begin
  result := EnumeradoToStr2(t, ['1', '2']);
end;

function StrToIndRetificacao(var ok: boolean; const s: string): TIndRetificacao;
begin
  result := TIndRetificacao( StrToEnumerado2(ok , s, ['1', '2']) );
end;

function indObraToStr(const t: TpindObra ): string;
begin
  result := EnumeradoToStr2(t, ['0', '1', '2']);
end;

function StrToindObra(var ok: boolean; const s: string): TpindObra;
begin
  result := TpindObra( StrToEnumerado2(ok , s, ['0', '1', '2']) );
end;

function indCPRBToStr(const t: TpindCPRB ): string;
begin
  result := EnumeradoToStr2(t, ['0', '1']);
end;

function StrToindCPRB(var ok: boolean; const s: string): TpindCPRB;
begin
  result := TpindCPRB( StrToEnumerado2(ok , s, ['0', '1']) );
end;

function tpProcRetPrincToStr(const t: TtpProcRetPrinc ): string;
begin
  result := EnumeradoToStr2(t, ['1', '2', '3']);
end;

function StrTotpProcRetPrinc(var ok: boolean; const s: string): TtpProcRetPrinc;
begin
  result := TtpProcRetPrinc( StrToEnumerado2(ok , s, ['1', '2', '3']) );
end;

function tpRepasseToStr(const t: TtpRepasse ): string;
begin
  result := EnumeradoToStr2(t, ['1', '2', '3', '4', '5']);
end;

function StrTotpRepasse(var ok: boolean; const s: string): TtpRepasse;
begin
  result := TtpRepasse( StrToEnumerado2(ok , s, ['1', '2', '3', '4', '5']) );
end;

function indComToStr(const t: TindCom ): string;
begin
  result := EnumeradoToStr2(t, ['1', '8', '9']);
end;

function StrToindCom(var ok: boolean; const s: string): TindCom;
begin
  result := TindCom( StrToEnumerado2(ok , s, ['1', '8', '9']) );
end;


end.
