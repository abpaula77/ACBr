{******************************************************************************}
{ Projeto: Componente ACBrReinf                                                }
{  Biblioteca multiplataforma de componentes Delphi para envio de eventos do   }
{ Reinf                                                                        }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }


{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}

unit ACBrReinfRetEventos;

interface

uses
  ACBrReinfClasses;

type

  TRetornoLoteEventos = class
  private
    FACBrReinf: TObject;
    FIdeTransmissor: TIdeTransmissor;
    FStatus: TStatus;
    FEventos: TRetEventos;
  public
    constructor Create(AOwner: TObject); reintroduce;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  	property IdeTransmissor : TIdeTransmissor read FIdeTransmissor;
    property Status: TStatus read FStatus;
    property Eventos: TRetEventos read FEventos write FEventos;
  end;

implementation

{ TRetornoLoteEventos }

procedure TRetornoLoteEventos.AfterConstruction;
begin
  inherited;
  FIdeTransmissor := TIdeTransmissor.Create;
  FStatus := TStatus.Create;
  FEventos := TRetEventos.Create;
end;

procedure TRetornoLoteEventos.BeforeDestruction;
begin
  inherited;
  FEventos.Free;
  FIdeTransmissor.Free;
  FStatus.Free;
end;

constructor TRetornoLoteEventos.Create(AOwner: TObject);
begin
  Inherited Create;
  FACBrReinf := AOwner;
end;

end.
