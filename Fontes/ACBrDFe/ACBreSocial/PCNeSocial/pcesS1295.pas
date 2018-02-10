{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 01/03/2016: Guilherme Costa
|*  - Passado o namespace para gera��o do cabe�alho
******************************************************************************}
{$I ACBr.inc}

unit pcesS1295;

interface

uses
  SysUtils, Classes,
  pcnConversao,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS1295Collection = class;
  TS1295CollectionItem = class;
  TEvtTotConting = class;

  TS1295Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1295CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1295CollectionItem);
  public
    function Add: TS1295CollectionItem;
    property Items[Index: Integer]: TS1295CollectionItem read GetItem write SetItem; default;
  end;

  TS1295CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtTotConting: TEvtTotConting;

    procedure setEvtTotConting(const Value: TEvtTotConting);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtTotConting: TEvtTotConting read FEvtTotConting write setEvtTotConting;
  end;

  TEvtTotConting = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FIdeRespInf : TIdeRespInf;

    {Geradores espec�ficos da classe}
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML(ATipoEmpregador: TEmpregador): boolean; override;

    property IdeEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeRespInf: TIdeRespInf read FIdeRespInf write FIdeRespInf;
  end;

implementation

{ TS1295Collection }

function TS1295Collection.Add: TS1295CollectionItem;
begin
  Result := TS1295CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1295Collection.GetItem(Index: Integer): TS1295CollectionItem;
begin
  Result := TS1295CollectionItem(inherited GetItem(Index));
end;

procedure TS1295Collection.SetItem(Index: Integer; Value: TS1295CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{TS1295CollectionItem}
constructor TS1295CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1295;
  FEvtTotConting := TEvtTotConting.Create(AOwner);
end;

destructor TS1295CollectionItem.Destroy;
begin
  FEvtTotConting.Free;

  inherited;
end;

procedure TS1295CollectionItem.setEvtTotConting(const Value: TEvtTotConting);
begin
  FEvtTotConting.Assign(Value);
end;

{ TEvtSolicTotal }
constructor TEvtTotConting.Create(AACBreSocial: TObject);
begin
  inherited;

  FIdeEvento := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeRespInf := TIdeRespInf.Create;
end;

destructor TEvtTotConting.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeRespInf.Free;

  inherited;
end;

function TEvtTotConting.GerarXML(ATipoEmpregador: TEmpregador): boolean;
begin
  try
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc,
     self.Sequencial, ATipoEmpregador);

    GerarCabecalho('evtTotConting');
    Gerador.wGrupo('evtTotConting Id="' + Self.Id + '"');

    GerarIdeEvento3(self.IdeEvento, False);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarIdeRespInf(Self.IdeRespInf);

    Gerador.wGrupo('/evtTotConting');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtTotConting');

    Validar(schevtTotConting);
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

end.
