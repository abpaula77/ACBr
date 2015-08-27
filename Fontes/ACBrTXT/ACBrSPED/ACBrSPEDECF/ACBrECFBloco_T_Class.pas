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

unit ACBrECFBloco_T_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_T, ACBrECFBlocos,
  ACBrTXTClass, ACBrECFBloco_0_Class;

type
  /// TBloco_T -

  { TBloco_T }

  TBloco_T = class(TACBrSPED)
  private
    FBloco_0: TBloco_0;
    FRegistroT001: TRegistroT001;
    FRegistroT990: TRegistroT990;

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    property Bloco_0: TBloco_0 read FBloco_0 write FBloco_0;

    constructor Create;
    destructor Destroy;

    procedure LimpaRegistros;

    procedure WriteRegistroT001;
    procedure WriteRegistroT030;
    procedure WriteRegistroT990;

    property RegistroT001: TRegistroT001 read FRegistroT001 write FRegistroT001;
    property RegistroT990: TRegistroT990 read FRegistroT990 write FRegistroT990;
  published
  end;


implementation

uses
  ACBrTXTUtils, StrUtils;

{ TBloco_T }

constructor TBloco_T.Create;
begin
  FRegistroT001 := TRegistroT001.Create;
  FRegistroT990 := TRegistroT990.Create;
end;

procedure TBloco_T.CriaRegistros;
begin
  FRegistroT001 := TRegistroT001.Create;
  FRegistroT990 := TRegistroT990.Create;
end;

destructor TBloco_T.Destroy;
begin
  FRegistroT001.Free;
  FRegistroT990.Free;
end;

procedure TBloco_T.LiberaRegistros;
begin
  FRegistroT001.Free;
  FRegistroT990.Free;
end;

procedure TBloco_T.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  Conteudo.Clear;

  /// Recriar os Registros Limpos
  CriaRegistros;
end;

procedure TBloco_T.WriteRegistroT001;
begin
  if Assigned(FRegistroT001) then begin
     with FRegistroT001 do begin
       Check(((IND_DAD = idComDados) or (IND_DAD = idSemDados)), '(T-T001) Na abertura do bloco, deve ser informado o n�mero 0 ou 1!');
       ///
       Add(LFill('T001') +
           LFill( Integer(IND_DAD), 1));
       ///
       FRegistroT990.QTD_LIN:= FRegistroT990.QTD_LIN + 1;
       WriteRegistroT030;
     end;
  end;
end;

procedure TBloco_T.WriteRegistroT030;
begin
  //
end;

procedure TBloco_T.WriteRegistroT990;
begin
  if Assigned(FRegistroT990) then begin
     with FRegistroT990 do begin
       QTD_LIN := QTD_LIN + 1;
       ///
       Add(LFill('T990') +
           LFill(QTD_LIN, 0));
     end;
  end;
end;

end.
