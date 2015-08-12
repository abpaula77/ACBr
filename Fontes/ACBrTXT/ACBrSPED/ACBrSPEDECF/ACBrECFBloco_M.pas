{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014   Juliomar Marchetti                   }
{					  Isaque Pinheiro		       }
{ 					  Daniel Sim�es de Almeida	       }
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
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
*******************************************************************************}

{$I ACBr.inc}

unit ACBrECFBloco_M;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECFBlocos;

type
  /// Registro M001 - Abertura do Bloco M � Livro Eletr�nico de
  /// Apura��o do Lucro Real (e-Lalur) e Licro Eletr�nico
  /// de Apura��o da Base de C�lculo da CSLL (e-Lacs)
  TRegistroM001 = class(TOpenBlocos)
  end;

  /// Registro M010 - Identifica��o da Conta na Parte B e-Lalur e do e-Lacs

  { TRegistroM010 }

  TRegistroM010 = class(TBlocos)
  private
    fCNPJ_SIT_ESP: string;
    fIND_Vl_SALDO_INI: string;
    fVl_SALDO_INI: variant;
    fDESC_LAN_ORIG: string;
    fDESC_CTA_LAL: string;
    fDT_LIM_LAL:   TDateTime;
    fDT_AP_LAL:    TDateTime;
    fCOD_LAN_ORIG: integer;
    fCOD_TRIBUTO:  integer;
    fCOD_CTA_B:    string;
  public
    property COD_CTA_B: string read fCOD_CTA_B write fCOD_CTA_B;
    property DESC_CTA_LAL: string read fDESC_CTA_LAL write fDESC_CTA_LAL;
    property DT_AP_LAL: TDateTime read fDT_AP_LAL write fDT_AP_LAL;
    property COD_LAN_ORIG: integer read fCOD_LAN_ORIG write fCOD_LAN_ORIG;
    property DESC_LAN_ORIG: string read fDESC_LAN_ORIG write fDESC_LAN_ORIG;
    property DT_LIM_LAL: TDateTime read fDT_LIM_LAL write fDT_LIM_LAL;
    property COD_TRIBUTO: integer read fCOD_TRIBUTO write fCOD_TRIBUTO;
    property Vl_SALDO_INI: variant read fVl_SALDO_INI write fVl_SALDO_INI;
    property IND_Vl_SALDO_INI: string read fIND_Vl_SALDO_INI write fIND_Vl_SALDO_INI;
    property CNPJ_SIT_ESP: string read fCNPJ_SIT_ESP write fCNPJ_SIT_ESP;
  end;

  /// Registro M030 - Identifica��o do Per�odo e Forma de Apura��o do
  /// IRPJ e da CSLL das Empresas Tributadas pelo Lucro Real
  TRegistroM030 = class(TBlocos)
  private
    fDT_FIN:   TDateTime;
    fPER_APUR: string;
    fDT_INI:   TDateTime;
  public
    property DT_INI: TDateTime read fDT_INI write fDT_INI;
    property DT_FIN: TDateTime read fDT_FIN write fDT_FIN;
    property PER_APUR: string read fPER_APUR write fPER_APUR;
  end;

  /// Registro M300 - Lan�amentos da Parte A do e-Lalur

  { TRegistroM300 }

  TRegistroM300 = class(TBlocos)
  private
    fHIST_LAN_LAL: string;
    fIND_RELACAO: integer;
    fCODIGO:    string;
    fTIPO_LANCAMENTO: string;
    fDESCRICAO: string;
    fVALOR:     variant;
  public
    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property TIPO_LANCAMENTO: string read fTIPO_LANCAMENTO write fTIPO_LANCAMENTO;
    property IND_RELACAO: integer read fIND_RELACAO write fIND_RELACAO;
    property VALOR: variant read fVALOR write fVALOR;
    property HIST_LAN_LAL: string read fHIST_LAN_LAL write fHIST_LAN_LAL;
  end;

  /// Registro M305 - Conta da Parte B do e-Lalur
  TRegistroM305 = class(TBlocos)
  private
    fVL_CTA:     variant;
    fIND_VL_CTA: string;
    fCOD_CTA_B:  string;
  public
    property COD_CTA_B: string read fCOD_CTA_B write fCOD_CTA_B;
    property VL_CTA: variant read fVL_CTA write fVL_CTA;
    property IND_VL_CTA: string read fIND_VL_CTA write fIND_VL_CTA;
  end;

  /// Registro M310 - Contas Cont�beis Relacionadas ao Lan�amento da Parte A do e-Lalur.
  TRegistroM310 = class(TBlocos)
  private
    fCOD_CTA:    string;
    fCOD_CCUS:   string;
    fVL_CTA:     variant;
    fIND_VL_CTA: string;
  public
    property COD_CTA: string read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: string read fCOD_CCUS write fCOD_CCUS;
    property VL_CTA: variant read fVL_CTA write fVL_CTA;
    property IND_VL_CTA: string read fIND_VL_CTA write fIND_VL_CTA;
  end;

  /// Registro M312 - N�meros dos Lan�amentos Relacionados � Conta Cont�bil
  TRegistroM312 = class(TBlocos)
  private
    fNUM_LCTO: string;
  public
    property NUM_LCTO: string read fNUM_LCTO write fNUM_LCTO;
  end;

  /// Registro M315 - Identifica��o de Processos Judiciais e
  /// Administrativos Referentes ao Lan�amento
  TRegistroM315 = class(TBlocos)
  private
    fIND_PROC: string;
    fNUM_PROC: string;
  public
    property IND_PROC: string read fIND_PROC write fIND_PROC;
    property NUM_PROC: string read fNUM_PROC write fNUM_PROC;
  end;

  /// Registro M350 - Lan�amentos da Parte A do e-Lacs

  { TRegistroM350 }

  TRegistroM350 = class(TBlocos)
  private
    fHIST_LAN_LAL: string;
    fVALOR:     variant;
    fCODIGO:    string;
    fDESCRICAO: string;
    fTIPO_LANCAMENTO: string;
    fIND_RELACAO: integer;
  public
    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property TIPO_LANCAMENTO: string read fTIPO_LANCAMENTO write fTIPO_LANCAMENTO;
    property IND_RELACAO: integer read fIND_RELACAO write fIND_RELACAO;
    property VALOR: variant read fVALOR write fVALOR;
    property HIST_LAN_LAL: string read fHIST_LAN_LAL write fHIST_LAN_LAL;
  end;

  /// Registro M355 - Conta da Parte B do e-Lacs

  { TRegistroM355 }

  TRegistroM355 = class(TBlocos)
  private
    fVL_CTA:     variant;
    fIND_VL_CTA: string;
    fCOD_CTA_B:  string;
  public
    property COD_CTA_B: string read fCOD_CTA_B write fCOD_CTA_B;
    property VL_CTA: variant read fVL_CTA write fVL_CTA;
    property IND_VL_CTA: string read fIND_VL_CTA write fIND_VL_CTA;
  end;

  /// Registro M360 - Contas Cont�beis Relacionadas ao Lan�amento da
  /// Parte A do e-Lacs.

  { TRegistroM360 }

  TRegistroM360 = class(TBlocos)
  private
    fCOD_CCUS:   string;
    fCOD_CONTA:  string;
    fCOD_CENTRO_CUSTOS: string;
    fCOD_CTA:    string;
    fIND_VL_CTA: string;
    fVL_CTA:     variant;
    fIND_VALOR_CONTA: string;
  public
    property COD_CTA: string read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: string read fCOD_CCUS write fCOD_CCUS;
    property VL_CTA: variant read fVL_CTA write fVL_CTA;
    property IND_VL_CTA: string read fIND_VL_CTA write fIND_VL_CTA;
  end;

  /// Registro M362 - N�meros dos Lan�amentos Relacionados � Conta
  /// Cont�bil

  { TRegistroM362 }

  TRegistroM362 = class(TBlocos)
  private
    fNUM_LCTO: string;
  public
    property NUM_LCTO: string read fNUM_LCTO write fNUM_LCTO;
  end;

  /// Registro M365 - Identifica��o de Processos Judiciais e
  /// Administrativos Referentes ao Lan�amento

  { TRegistroM365 }

  TRegistroM365 = class(TBlocos)
  private
    fIND_PROC: string;
    fNUM_PROC: string;
  public
    property IND_PROC: string read fIND_PROC write fIND_PROC;
    property NUM_PROC: string read fNUM_PROC write fNUM_PROC;
  end;

  /// Registro M410 - Lan�amentos na Conta da Parte B do e-Lalur e do e-
  /// Lacs Sem Reflexo na Parte A

  { TRegistroM410 }

  TRegistroM410 = class(TBlocos)
  private
    fCOD_CTA_B:     string;
    fCOD_CTA_B_CTP: string;
    fCOD_TRIBUTO:   string;
    fHIST_LAN_LALB: string;
    fIND_LAN_ANT:   string;
    fIND_VAL_LAN_LALB_PB: string;
    fVAL_LAN_LALB_PB: variant;
  public
    property COD_CTA_B: string read fCOD_CTA_B write fCOD_CTA_B;
    property COD_TRIBUTO: string read fCOD_TRIBUTO write fCOD_TRIBUTO;
    property VAL_LAN_LALB_PB: variant read fVAL_LAN_LALB_PB write fVAL_LAN_LALB_PB;
    property IND_VAL_LAN_LALB_PB: string read fIND_VAL_LAN_LALB_PB write fIND_VAL_LAN_LALB_PB;
    property COD_CTA_B_CTP: string read fCOD_CTA_B_CTP write fCOD_CTA_B_CTP;
    property HIST_LAN_LALB: string read fHIST_LAN_LALB write fHIST_LAN_LALB;
    property IND_LAN_ANT: string read fIND_LAN_ANT write fIND_LAN_ANT;
  end;

  /// Registro M415 - Identifica��o de Processos Judiciais e
  /// Administrativos Referentes ao Lan�amento

  { TRegistroM415 }

  TRegistroM415 = class(TBlocos)
  private
    fIND_PROC: string;
    fNUM_PROC: string;
  public
    property IND_PROC: string read fIND_PROC write fIND_PROC;
    property NUM_PROC: string read fNUM_PROC write fNUM_PROC;
  end;

  /// Registro M500 - Controle de Saldos das Contas da Parte B do e-Lalur
  /// e do e-Lacs

  { TRegistroM500 }

  TRegistroM500 = class(TBlocos)
  private
    fCOD_CTA_B:      string;
    fCOD_TRIBUTO:    string;
    fIND_SD_FIM_LAL: string;
    fIND_SD_INI_LAL: string;
    fIND_VL_LCTO_PARTE_A: variant;
    fIND_VL_LCTO_PARTE_B: string;
    fSD_FIM_LAL:     variant;
    fSD_INI_LAL:     variant;
    fVL_LCTO_PARTE_A: variant;
    fVL_LCTO_PARTE_B: variant;
  public
    property COD_CTA_B: string read fCOD_CTA_B write fCOD_CTA_B;
    property COD_TRIBUTO: string read fCOD_TRIBUTO write fCOD_TRIBUTO;
    property SD_INI_LAL: variant read fSD_INI_LAL write fSD_INI_LAL;
    property IND_SD_INI_LAL: string read fIND_SD_INI_LAL write fIND_SD_INI_LAL;
    property VL_LCTO_PARTE_A: variant read fVL_LCTO_PARTE_A write fVL_LCTO_PARTE_A;
    property IND_VL_LCTO_PARTE_A: variant read fIND_VL_LCTO_PARTE_A write fIND_VL_LCTO_PARTE_A;
    property VL_LCTO_PARTE_B: variant read fVL_LCTO_PARTE_B write fVL_LCTO_PARTE_B;
    property IND_VL_LCTO_PARTE_B: string read fIND_VL_LCTO_PARTE_B write fIND_VL_LCTO_PARTE_B;
    property SD_FIM_LAL: variant read fSD_FIM_LAL write fSD_FIM_LAL;
    property IND_SD_FIM_LAL: string read fIND_SD_FIM_LAL write fIND_SD_FIM_LAL;
  end;

  /// Registro M990 - ENCERRAMENTO DO BLOCO M
  TRegistroM990 = class(TCloseBlocos)
  end;


implementation

end.
