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

unit ACBrECFBloco_E;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECFBlocos;

type
  /// Registro E001 - Abertura do Bloco E � Informa��es Recuperadas da
  /// ECF Anterior e C�lculo Fiscal dos Dados Recuperados da ECD
  TRegistroE001 = class(TOpenBlocos)
  private
  public
  end;

  /// Registro E010 - Saldos Finais Recuperados da ECF Anterior
  TRegistroE010 = class(TBlocos)
  private
    fVAL_CTA_REF:  currency;
    fIND_VAL_CTA_REF: string;
    fCOD_NAT:      string;
    fCOD_CTA_REF:  string;
    fDESC_CTA_REF: string;
  public
    property COD_NAT: string read fCOD_NAT write fCOD_NAT;
    property COD_CTA_REF: string read fCOD_CTA_REF write fCOD_CTA_REF;
    property DESC_CTA_REF: string read fDESC_CTA_REF write fDESC_CTA_REF;
    property VAL_CTA_REF: currency read fVAL_CTA_REF write fVAL_CTA_REF;
    property IND_VAL_CTA_REF: string read fIND_VAL_CTA_REF write fIND_VAL_CTA_REF;
  end;

  /// Registro E015 - Contas Cont�beis Mapeadas
  TRegistroE015 = class(TBlocos)
  private
    fCOD_CTA:     string;
    fCOD_CCUS:    string;
    fVAL_CTA:     variant;
    fDESC_CTA:    string;
    fIND_VAL_CTA: string;
  public
    property COD_CTA: string read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: string read fCOD_CCUS write fCOD_CCUS;
    property DESC_CTA: string read fDESC_CTA write fDESC_CTA;
    property VAL_CTA: variant read fVAL_CTA write fVAL_CTA;
    property IND_VAL_CTA: string read fIND_VAL_CTA write fIND_VAL_CTA;
  end;

  /// Registro E020 - Saldos Finais das Contas da Parte B do e-Lalur da
  /// ECF Imediatamente Anterior
  TRegistroE020 = class(TBlocos)
  private
    fVL_SALDO_FIN: variant;
    fIND_VL_SALDO_FIN: string;
    fDESC_CTA_LAL: string;
    fDT_LIM_LAL: TDateTime;
    fDT_AP_LAL: TDateTime;
    fDESC_LAN_ORIG: string;
    fCOD_LAN_ORIG: integer;
    fTRIBUTO:   string;
    fCOD_CTA_B: string;
  public
    property COD_CTA_B: string read fCOD_CTA_B write fCOD_CTA_B;
    property DESC_CTA_LAL: string read fDESC_CTA_LAL write fDESC_CTA_LAL;
    property DT_AP_LAL: TDateTime read fDT_AP_LAL write fDT_AP_LAL;
    property COD_LAN_ORIG: integer read fCOD_LAN_ORIG write fCOD_LAN_ORIG;
    property DESC_LAN_ORIG: string read fDESC_LAN_ORIG write fDESC_LAN_ORIG;
    property DT_LIM_LAL: TDateTime read fDT_LIM_LAL write fDT_LIM_LAL;
    property TRIBUTO: string read fTRIBUTO write fTRIBUTO;
    property VL_SALDO_FIN: variant read fVL_SALDO_FIN write fVL_SALDO_FIN;
    property IND_VL_SALDO_FIN: string read fIND_VL_SALDO_FIN write fIND_VL_SALDO_FIN;

  end;

  /// Registro E030 - IdentificaC�o do Per�odo
  TRegistroE030 = class(TBlocos)
  private
    fPER_APUR: string;
    fDT_FIN:   TDateTime;
    fDT_INI:   TDateTime;
  public
    property DT_INI: TDateTime read fDT_INI write fDT_INI;
    property DT_FIN: TDateTime read fDT_FIN write fDT_FIN;
    property PER_APUR: string read fPER_APUR write fPER_APUR;
  end;

  /// Registro E155 - Detalhes dos Saldos Cont�beis Calculados com Base nas ECD
  TRegistroE155 = class(TBlocos)
  private
    fCOD_CTA:    string;
    fVL_SLD_FIN: variant;
    fVL_SLD_INI: variant;
    fCOD_CCUS:   string;
    fIND_VL_SLD_FIN: string;
    fIND_VL_SLD_INI: string;
    fVL_CRED:    variant;
    fVL_DEB:     variant;
  public
    property COD_CTA: string read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: string read fCOD_CCUS write fCOD_CCUS;
    property VL_SLD_INI: variant read fVL_SLD_INI write fVL_SLD_INI;
    property IND_VL_SLD_INI: string read fIND_VL_SLD_INI write fIND_VL_SLD_INI;
    property VL_DEB: variant read fVL_DEB write fVL_DEB;
    property VL_CRED: variant read fVL_CRED write fVL_CRED;
    property VL_SLD_FIN: variant read fVL_SLD_FIN write fVL_SLD_FIN;
    property IND_VL_SLD_FIN: string read fIND_VL_SLD_FIN write fIND_VL_SLD_FIN;
  end;

  /// Registro E355 - Detalhes dos Saldos das Contas de Resultado Antes do Encerramento
  TRegistroE355 = class(TBlocos)
  private
    fCOD_CTA:    string;
    fVL_SLD_FIN: variant;
    fCOD_CCUS:   string;
    fIND_VL_SLD_FIN: string;
  public
    property COD_CTA: string read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: string read fCOD_CCUS write fCOD_CCUS;
    property VL_SLD_FIN: variant read fVL_SLD_FIN write fVL_SLD_FIN;
    property IND_VL_SLD_FIN: string read fIND_VL_SLD_FIN write fIND_VL_SLD_FIN;
  end;

  /// Registro E990 - ENCERRAMENTO DO BLOCO E
  TRegistroE990 = class(TCloseBlocos)
  end;

implementation

end.
