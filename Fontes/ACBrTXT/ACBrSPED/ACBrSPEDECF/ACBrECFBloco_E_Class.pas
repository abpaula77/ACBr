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

unit ACBrECFBloco_E_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_E, ACBrECFBlocos,
  ACBrTXTClass, ACBrECFBloco_0_Class;

type
  /// TBloco_E -

  { TBloco_E }

  TBloco_E = class(TACBrSPED)
  private
    FBloco_0: TBloco_0;
    FRegistroE001: TRegistroE001;
    FRegistroE990: TRegistroE990;

    procedure CriaRegistros;
    procedure LiberaRegistros;

  public
    property Bloco_0: TBloco_0 read FBloco_0 write FBloco_0;
    constructor Create;
    destructor Destroy;

    procedure LimpaRegistros;
    procedure WriteRegistroE001;
    procedure WriteRegistroE990;

    property RegistroE001: TRegistroE001 read FRegistroE001 write FRegistroE001;
    property RegistroE990: TRegistroE990 read FRegistroE990 write FRegistroE990;
  published
  end;


implementation

uses
  ACBrTXTUtils, StrUtils;

{ TBloco_E }

constructor TBloco_E.Create;
begin
  CriaRegistros;
end;

procedure TBloco_E.CriaRegistros;
begin
  FRegistroE001 := TRegistroE001.Create;
  FRegistroE990 := TRegistroE990.Create;

  FRegistroE990.QTD_LIN := 0;
end;

destructor TBloco_E.Destroy;
begin
  LiberaRegistros;
end;

procedure TBloco_E.LiberaRegistros;
begin
  FRegistroE001.Free;
  FRegistroE990.Free;
end;

procedure TBloco_E.LimpaRegistros;
begin
  LiberaRegistros;
  Conteudo.Clear;

  CriaRegistros;
end;

procedure TBloco_E.WriteRegistroE001;
begin
  if Assigned(FRegistroE001) then begin
    with FRegistroE001 do begin
      Check(((IND_DAD = idComDados) or (IND_DAD = idSemDados)), '(E-E001) Na abertura do bloco, deve ser informado o n�mero 0 ou 1!');
      Add(LFill('E001') +
          LFill( Integer(IND_DAD), 1));
      FRegistroE990.QTD_LIN:= FRegistroE990.QTD_LIN + 1;
    end;
  end;
end;

procedure TBloco_E.WriteRegistroE990;
begin
  if Assigned(FRegistroE990) then begin
    with FRegistroE990 do begin
      QTD_LIN := QTD_LIN + 1;
      Add(LFill('E990') +
          LFill(QTD_LIN, 0));
    end;
  end;
end;

end.
