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

unit ACBrECFBloco_C_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_C, ACBrECFBlocos,
  ACBrTXTClass, ACBrECFBloco_0_Class;

type
  /// TBloco_C -

  { TBloco_C }

  TBloco_C = class(TACBrSPED)
  private
    FBloco_0: TBloco_0;
    FRegistroC001: TRegistroC001;
    FRegistroC990: TRegistroC990;
  public
    property Bloco_0: TBloco_0 read FBloco_0 write FBloco_0;

    constructor Create; overload;
    destructor Destroy; overload;

    property RegistroC001: TRegistroC001 read FRegistroC001 write FRegistroC001;
    property RegistroC990: TRegistroC990 read FRegistroC990 write FRegistroC990;
  published
  end;


implementation

uses
  ACBrTXTUtils, StrUtils;

{ TBloco_C }

constructor TBloco_C.Create;
begin
  FRegistroC001 := TRegistroC001.Create;
  FRegistroC990 := TRegistroC990.Create;
end;

destructor TBloco_C.Destroy;
begin
  FRegistroC001.Free;
  FRegistroC990.Free;
end;

end.
