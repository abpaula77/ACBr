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

unit ACBrECFBloco_0_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_0, ACBrECFBlocos,
  ACBrTXTClass;

type
	{ TBloco_0 }

  TBloco_0 = class(TACBrSPED)
  private
    FRegistro0000: TRegistro0000;
    fRegistro0001: TRegistro0001;
    FRegistro0990: TRegistro0990;
  public
    constructor Create;
    destructor Destroy;

    procedure CriaRegistros;
    procedure LimpaRegistros;

    function Registro0000New : TRegistro0000;
    function Registro0001New : TRegistro0001;
    function Registro0010New : TRegistro0010;
    function Registro0020New : TRegistro0020;
    function Registro0030New : TRegistro0030;
    function Registro0035New : TRegistro0035;
    function Registro0930New : TRegistro0930;


    procedure WriteRegistro0000;
    procedure WriteRegistro0001;
    procedure WriteRegistro0990;

    property Registro0000 : TRegistro0000 read FRegistro0000 write FRegistro0000;
    property Registro0001 : TRegistro0001 read fRegistro0001 write fRegistro0001;
    property Registro0990 : TRegistro0990 read FRegistro0990 write FRegistro0990;
  published
  end;

implementation

uses
  ACBrTXTUtils, StrUtils;

{ TBloco_0 }

procedure TBloco_0.CriaRegistros;
begin
  inherited ;
  FRegistro0000 := TRegistro0000.Create;
  fRegistro0001 := TRegistro0001.Create;
  FRegistro0990 := TRegistro0990.Create;


  FRegistro0990.QTD_LIN := 0;
end;

procedure TBloco_0.LimpaRegistros;
begin
  inherited ;
  FRegistro0000.Free;
  fRegistro0001.Free;
  FRegistro0990.Free;
end;

constructor TBloco_0.Create;
begin
  inherited;

end;

destructor TBloco_0.Destroy;
begin

  inherited;
end;

function TBloco_0.Registro0000New: TRegistro0000;
begin

end;

function TBloco_0.Registro0001New: TRegistro0001;
begin

end;

function TBloco_0.Registro0010New: TRegistro0010;
begin

end;

function TBloco_0.Registro0020New: TRegistro0020;
begin

end;

function TBloco_0.Registro0030New: TRegistro0030;
begin

end;

function TBloco_0.Registro0035New: TRegistro0035;
begin

end;

function TBloco_0.Registro0930New: TRegistro0930;
begin

end;

procedure TBloco_0.WriteRegistro0000;
begin

end;

procedure TBloco_0.WriteRegistro0001;
begin

end;

procedure TBloco_0.WriteRegistro0990;
begin

end;

end.
