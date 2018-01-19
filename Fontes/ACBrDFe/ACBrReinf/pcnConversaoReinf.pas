{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }

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

  tpTpInsc                = (tiCNPJ = 1, tiCPF = 2, tiCNO = 4);

  TpTpInscProp            = (tpCNPJ, tpCPF);

  TLayReinf = (orLayENVIO, orLayConsulta);

  TTypeOperacao         = (toInclusao, toAlteracao, toExclusao);

  TpTpAmb                 = (taNenhum, taProducao, taProducaoRestritaDadosReais, taProducaoRestritaDadosFicticios);

  tpSimNao                = (tpSim, tpNao);

  TpProcEmi               = (peNenhum, peAplicEmpregador, peAplicGoverno);

  TpIndCoop               = (icNaoecooperativa, icCooperativadeTrabalho, icCooperativadeProducao, icOutrasCooperativas );

  tpTpProc                = (tpAdministrativo = 1, tpJudicial = 2);

  tpIndSusp               = (siLiminarMandadoSeguranca = 1,
                             siAntecipacaoTutela = 4,
                             siLiminarMedidaCautelar = 5,
                             siSentencaMandadoSegurancaFavoravelContribuinte = 8,
                             siSentencaAcaoOrdinariaFavContribuinteConfirmadaPeloTRF = 9,
                             siAcordaoTRFFavoravelContribuinte = 10,
                             siAcordaoSTJRecursoEspecialFavoravelContribuinte = 11,
                             siAcordaoSTFRecursoExtraordinarioFavoravelContribuinte = 12,
                             siSentenca1instanciaNaoTransitadaJulgadoEfeitoSusp = 13,
                             siDecisaoDefinitivaAFavorDoContribuinte = 90,
                             siSemSuspensaoDaExigibilidade = 92);


  TindSitPJ               = (spNormal, spExtincao, spFusao, spCisao, spIncorporacao);

  TTypeAutoria            = (taContribuinte = 1, taOutraEntidade = 2);

  TIndRetificacao         = (trOriginal = 1, trRetificacao = 2);

  TpindObra               = (ioNaoeObraDeConstrucaoCivil = 0, ioObradeConstrucaoCivilTotal = 1, ioObradeConstrucaoCivilParcial = 2);

  TpindCPRB               = (icNaoContribuintePrevidenciariaReceitaBruta = 0, icContribuintePrevidenciaReceitaBruta = 1);

  TtpProcRetPrinc         = (tprAdministrativoTomador = 1, tprJudicialTomador = 2, tprJudicialPrestador = 3);


  TReinfSchema            = (
                            rsevtInfoContri,         // R-1000 - Informa��es do Contribuinte
                            rsevtTabProcesso,        // R-1070 - Tabela de Processos Administrativos/Judiciais
                            rsevtServTom,            // R-2010 - Reten��o Contribui��o Previdenci�ria - Servi�os Tomados
                            rsevtServPrest,          // R-2020 - Reten��o Contribui��o Previdenci�ria - Servi�os Prestados
                            rsevtAssocDespRec,       // R-2030 - Recursos Recebidos por Associa��o Desportiva
                            rsevtAssocDespRep,       // R-2040 - Recursos Repassados para Associa��o Desportiva
                            rsevtComProd,            // R-2050 - Comercializa��o da Produ��o por Produtor Rural PJ/Agroind�stria
                            rsevtCPRB,               // R-2060 - Contribui��o Previdenci�ria sobre a Receita Bruta - CPRB
                            rsevtPgtosDivs,          // R-2070 - Reten��es na Fonte - IR, CSLL, Cofins, PIS/PASEP
                            rsevtReabreEvPer,        // R-2098 - Reabertura dos Eventos Peri�dicos
                            rsevtFechaEvPer,         // R-2099 - Fechamento dos Eventos Peri�dicos
                            rsevtEspDesportivo,      // R-3010 - Receita de Espet�culo Desportivo
                            rsevtTotal,              // R-5001 - Informa��es das bases e dos tributos consolidados por contribuinte
                            rsevtTotalConsolid,      // R-5011 - Informa��es de bases e tributos consolidadas por per�odo de apura��o
                            rsevtExclusao            // R-9000 - Exclus�o de Eventos
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

  TtpRepasse              = ( trPatrocinio = 1,    // 1 - Patroc�nio
                              trLicenciamento = 2, // 2 - Licenciamento de marcas e s�mbolos
                              trPublicidade = 3,   // 3 - Publicidade
                              trPropaganda = 4,    // 4 - Propaganda
                              trTransmissao = 5    // 5 - Transmiss�o de espet�culos
                            );

  TindCom                 = ( icProdRural = 1,  // 1 - Comercializa��o da Produ��o por Prod. Rural PJ/Agroind�stria, exceto para entidades executoras do PAA
                              icPAA = 2,        // 8 - Comercializa��o da Produ��o para Entidade do Programa de Aquisi��o de Alimentos - PAA
                              icMercExterno = 3 // 9 - Comercializa��o direta da Produ��o no Mercado Externo
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

   TpcnVersaoReinf        = ( v1_02_00, // v1.2
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

implementation

end.
