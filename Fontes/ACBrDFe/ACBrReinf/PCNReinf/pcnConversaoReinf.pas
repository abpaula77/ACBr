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

  TpTpAmb                 = (taProducao = 1, taProducaoRestritaDadosReais = 2, taProducaoRestritaDadosFicticios = 3);

  tpSimNao                = (tpSim, tpNao);

  TpProcEmi               = (peAplicEmpregador = 1, peAplicGoverno = 2);

  TpIndCoop               = (icNaoecooperativa, icCooperativadeTrabalho, icCooperativadeProducao, icOutrasCooperativas );

  tpTpProc                = (tpAdministrativo, tpJudicial);

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


  TReinfSchema            =   (
                             rsevtInfoContri, // R-1000 - Informa��es do Empregador/Contribuinte
                             rsevtTabProcesso,      // R-1070 - Tabela de Processos Administrativos/Judiciais
                             rsevtServTom, // R-2010 - Reten��o Contribui��o Previdenci�ria - Servi�os Tomados
                             rsevtServPrest, // R - 2020
                             rsevtCPRB, // R-2060
                             rsevtFechaEvPer, // R-2099
                             rsevtReabreEvPer, // R-2098
                             rsevtExclusao // R-9000
                             );

const
  PrefixVersao = '-v';
  TReinfSchemaStr : array[0..7] of string = ('evtInfoContribuinte','evtTabProcesso', 'evtTomadorServicos', 'evtPrestadorServicos',
    'evtInfoCPRB', 'evtFechamento', 'evtReabreEvPer', 'evtExclusao');

implementation

end.
