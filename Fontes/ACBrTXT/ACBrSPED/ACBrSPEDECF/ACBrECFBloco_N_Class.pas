{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014   Juliomar Marchetti                   }
{					                    2015   Isaque Pinheiro	    	             }
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

unit ACBrECFBloco_N_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_N, ACBrECFBlocos,
  ACBrTXTClass, ACBrECFBloco_0_Class;

type
  /// TBloco_N -

  { TBloco_N }

  TBloco_N = class(TACBrSPED)
  private
    FBloco_0: TBloco_0;
    FRegistroN001: TRegistroN001;
    FRegistroN990: TRegistroN990;
  public
    property Bloco_0: TBloco_0 read FBloco_0 write FBloco_0;

    constructor Create;
    destructor Destroy;

    property RegistroN001: TRegistroN001 read FRegistroN001 write FRegistroN001;
    property RegistroN990: TRegistroN990 read FRegistroN990 write FRegistroN990;
  published
  end;


implementation

uses
  ACBrTXTUtils, StrUtils;

{ TBloco_N }

constructor TBloco_N.Create;
begin
  FRegistroN001 := TRegistroN001.Create;
  FRegistroN990 := TRegistroN990.Create;
end;

destructor TBloco_N.Destroy;
begin
  FRegistroN001.Free;
  FRegistroN990.Free;
end;

end.
