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

unit ACBrECFBloco_J;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECFBlocos;

type
  /// Registro J001 - Abertura do Bloco J � Plano de Contas e Mapeamento
  TRegistroJ001 = class(TOpenBlocos)
  end;

  /// Registro J050 - Plano de Contas do Contribuinte

  { TRegistroJ050 }

  TRegistroJ050 = class(TBlocos)
  private
    fCOD_CTA_SUP: string;
    fCTA:     string;
    fNIVEL:   integer;
    fIND_CTA: string;
    fCOD_NAT: string;
    fDT_ALT:  TDate;
    fCOD_CTA: string;
  public
    property DT_ALT: TDate read fDT_ALT write fDT_ALT;
    property COD_NAT: string read fCOD_NAT write fCOD_NAT;
    property IND_CTA: string read fIND_CTA write fIND_CTA;
    property NIVEL: integer read fNIVEL write fNIVEL;
    property COD_CTA: string read fCOD_CTA write fCOD_CTA;
    property COD_CTA_SUP: string read fCOD_CTA_SUP write fCOD_CTA_SUP;
    property CTA: string read fCTA write fCTA;
  end;

  /// Registro J051 - Plano de Contas Referencial
  TRegistroJ051 = class(TBlocos)
  private
    fCOD_CCUS:    string;
    fCOD_CTA_REF: string;
  public
    property COD_CCUS: string read fCOD_CCUS write fCOD_CCUS;
    property COD_CTA_REF: string read fCOD_CTA_REF write fCOD_CTA_REF;
  end;

  /// Registro J053 - Subcontas Correlatas
  TRegistroJ053 = class(TBlocos)
  private
    fCOD_CNT_CORR: string;
    fNAT_SUB_CNT:  string;
    fCOD_IDT:      string;
  public
    property COD_IDT: string read fCOD_IDT write fCOD_IDT;
    property COD_CNT_CORR: string read fCOD_CNT_CORR write fCOD_CNT_CORR;
    property NAT_SUB_CNT: string read fNAT_SUB_CNT write fNAT_SUB_CNT;
  end;

  /// Registro J100 - Centro de Custos
  TRegistroJ100 = class(TBlocos)
  private
    fDT_ALT:   TDate;
    fCOD_CCUS: string;
    fCCUS:     string;
  public
    property DT_ALT: TDate read fDT_ALT write fDT_ALT;
    property COD_CCUS: string read fCOD_CCUS write fCOD_CCUS;
    property CCUS: string read fCCUS write fCCUS;
  end;

  /// Registro J990 - ENCERRAMENTO DO BLOCO J
  TRegistroJ990 = class(TCloseBlocos)
  end;


implementation

end.
