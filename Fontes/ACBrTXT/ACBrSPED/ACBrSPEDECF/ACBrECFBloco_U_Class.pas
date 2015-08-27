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

unit ACBrECFBloco_U_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_U, ACBrECFBlocos,
  ACBrTXTClass, ACBrECFBloco_0_Class;

type
  /// TBloco_U -

  { TBloco_U }

  TBloco_U = class(TACBrSPED)
  private
    FBloco_0: TBloco_0;
    FRegistroU001: TRegistroU001;
    FRegistroU990: TRegistroU990;

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    property Bloco_0: TBloco_0 read FBloco_0 write FBloco_0;

    constructor Create;
    destructor Destroy;

    procedure LimpaRegistros;    

    procedure WriteRegistroU001;
    procedure WriteRegistroU030;
    procedure WriteRegistroU990;

    property RegistroU001: TRegistroU001 read FRegistroU001 write FRegistroU001;
    property RegistroU990: TRegistroU990 read FRegistroU990 write FRegistroU990;
  published
  end;


implementation

uses
  ACBrTXTUtils, StrUtils;

{ TBloco_U }

constructor TBloco_U.Create;
begin
  FRegistroU001 := TRegistroU001.Create;
  FRegistroU990 := TRegistroU990.Create;
end;

procedure TBloco_U.CriaRegistros;
begin
  FRegistroU001 := TRegistroU001.Create;
  FRegistroU990 := TRegistroU990.Create;
end;

destructor TBloco_U.Destroy;
begin
  FRegistroU001.Free;
  FRegistroU990.Free;
end;

procedure TBloco_U.LiberaRegistros;
begin
  FRegistroU001.Free;
  FRegistroU990.Free;
end;

procedure TBloco_U.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  Conteudo.Clear;

  /// Recriar os Registros Limpos
  CriaRegistros;
end;

procedure TBloco_U.WriteRegistroU001;
begin
  if Assigned(FRegistroU001) then begin
     with FRegistroU001 do begin
       Check(((IND_DAD = idComDados) or (IND_DAD = idSemDados)), '(U-U001) Na abertura do bloco, deve ser informado o n�mero 0 ou 1!');
       Add(LFill('U001') +
           LFill( Integer(IND_DAD), 1));
           
       FRegistroU990.QTD_LIN:= FRegistroU990.QTD_LIN + 1;
       WriteRegistroU030;
     end;
  end;
end;

procedure TBloco_U.WriteRegistroU030;
begin
//
end;

procedure TBloco_U.WriteRegistroU990;
begin
  if Assigned(FRegistroU990) then begin
     with FRegistroU990 do begin
       QTD_LIN := QTD_LIN + 1;
       ///
       Add(LFill('U990') +
           LFill(QTD_LIN, 0));
     end;
  end;
end;

end.
