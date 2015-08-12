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

unit ACBrECFBloco_L;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECFBlocos;

type
  /// Registro L001 - Abertura do Bloco L � Lucro Real
  TRegistroL001 = class(TOpenBlocos)
  end;

  /// Registro L030 - Identifica��o dos Per�odos e Formas de Apura��o do
  /// IRPJ e da CSLL no Ano-Calend�rio
  TRegistroL030 = class(TBlocos)
  private
    fDT_FIN:   TDateTime;
    fPER_APUR: string;
    fDT_INI:   TDateTime;
  public
    property DT_INI: TDateTime read fDT_INI write fDT_INI;
    property DT_FIN: TDateTime read fDT_FIN write fDT_FIN;
    property PER_APUR: string read fPER_APUR write fPER_APUR;
  end;

  /// Registro L100 - Balan�o Patrimonial

  { TRegistroL100 }

  TRegistroL100 = class(TBlocos)
  private
    fIND_VAL_CTA_REF_FIN: string;
    fIND_VAL_CTA_REF_INI: string;
    fVALOR_SALDO_INICIAL: variant;
    fDESCRICAO: string;
    fCOD_CTA_SUP: string;
    fCOD_NAT: string;
    fNIVEL:  integer;
    fCODIGO: string;
    fTIPO:   string;
    fVAL_CTA_REF_FIN: variant;
    fVAL_CTA_REF_INI: variant;
  public
    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property TIPO: string read fTIPO write fTIPO;
    property NIVEL: integer read fNIVEL write fNIVEL;
    property COD_NAT: string read fCOD_NAT write fCOD_NAT;
    property COD_CTA_SUP: string read fCOD_CTA_SUP write fCOD_CTA_SUP;
    property VAL_CTA_REF_INI: variant read fVAL_CTA_REF_INI write fVAL_CTA_REF_INI;
    property IND_VAL_CTA_REF_INI: string read fIND_VAL_CTA_REF_INI write fIND_VAL_CTA_REF_INI;
    property VAL_CTA_REF_FIN: variant read fVAL_CTA_REF_FIN write fVAL_CTA_REF_FIN;
    property IND_VAL_CTA_REF_FIN: string read fIND_VAL_CTA_REF_FIN write fIND_VAL_CTA_REF_FIN;
  end;

  /// Registro L200 - M�todo de Avalia��o do Estoque Final
  TRegistroL200 = class(TBlocos)
  private
    fIND_AVAL_ESTOQ: string;
  public
    property IND_AVAL_ESTOQ: string read fIND_AVAL_ESTOQ write fIND_AVAL_ESTOQ;
  end;

  /// Registro L210 - Informativo da Composi��o de Custos
  TRegistroL210 = class(TBlocos)
  private
    fCODIGO:    string;
    fVALOR:     variant;
    fDESCRICAO: string;
  public
    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property VALOR: variant read fVALOR write fVALOR;
  end;

  /// Registro L300 - Demonstra��o do Resultado do Exerc�cio
  TRegistroL300 = class(TBlocos)
  private
    fIND_VALOR: string;
    fDESCRICAO: string;
    fCOD_CTA_SUP: string;
    fVALOR:   variant;
    fCOD_NAT: string;
    fNIVEL:   integer;
    fCODIGO:  string;
    fTIPO:    string;
  public
    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property TIPO: string read fTIPO write fTIPO;
    property NIVEL: integer read fNIVEL write fNIVEL;
    property COD_NAT: string read fCOD_NAT write fCOD_NAT;
    property COD_CTA_SUP: string read fCOD_CTA_SUP write fCOD_CTA_SUP;
    property VALOR: variant read fVALOR write fVALOR;
    property IND_VALOR: string read fIND_VALOR write fIND_VALOR;
  end;

  /// Registro L990 - ENCERRAMENTO DO BLOCO L
  TRegistroL990 = class(TCloseBlocos)
  end;

implementation

end.
