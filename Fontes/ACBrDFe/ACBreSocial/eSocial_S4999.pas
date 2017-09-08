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
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S4999;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS4999Collection = class;
  TS4999CollectionItem = class;
  TEvtAdesao = class;
  TInfoAdesao = class;


  TS4999Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS4999CollectionItem;
    procedure SetItem(Index: Integer; Value: TS4999CollectionItem);
  public
    function Add: TS4999CollectionItem;
    property Items[Index: Integer]: TS4999CollectionItem read GetItem write SetItem; default;
  end;

  TS4999CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtAdesao: TEvtAdesao;
    procedure setEvtAdesao(const Value: TEvtAdesao);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtAdesao: TEvtAdesao read FEvtAdesao write setEvtAdesao;
  end;

  TEvtAdesao = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FInfoAdesao: TInfoAdesao;

    {Geradores espec�ficos da classe}
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;

    property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property InfoAdesao: TInfoAdesao read FInfoAdesao write FInfoAdesao;
  end;

  TInfoAdesao = class
  private
    FdtAdesao: string;
  public
    property dtAdesao: string read FdtAdesao write FdtAdesao;
  end;


implementation

uses
  eSocial_NaoPeriodicos;

{ TS4999Collection }

function TS4999Collection.Add: TS4999CollectionItem;
begin
  Result := TS4999CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS4999Collection.GetItem(Index: Integer): TS4999CollectionItem;
begin
  Result := TS4999CollectionItem(inherited GetItem(Index));
end;

procedure TS4999Collection.SetItem(Index: Integer;
  Value: TS4999CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS4999CollectionItem }

constructor TS4999CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS4999;
  FEvtAdesao := TEvtAdesao.Create(AOwner);
end;

destructor TS4999CollectionItem.Destroy;
begin
  FEvtAdesao.Free;
  inherited;
end;

procedure TS4999CollectionItem.setEvtAdesao(const Value: TEvtAdesao);
begin
  FEvtAdesao.Assign(Value);
end;

{ TEvtSolicTotal }

constructor TEvtAdesao.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento2.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FInfoAdesao := TInfoAdesao.Create;
end;

destructor TEvtAdesao.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FInfoAdesao.Free;
  inherited;
end;

function TEvtAdesao.GerarXML: boolean;
begin
  try
    GerarCabecalho('');
      Gerador.wGrupo('evtAdesao Id="'+GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0)+'"');
        //gerarIdVersao(self);
        gerarIdeEvento2(self.IdeEvento);
        gerarIdeEmpregador(self.IdeEmpregador);
        Gerador.wGrupo('infoAdesao');
          Gerador.wCampo(tcStr, '', 'dtAdesao', 0, 0, 0, self.InfoAdesao.dtAdesao);
        Gerador.wGrupo('/infoAdesao');
      Gerador.wGrupo('/evtAdesao');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtAdesao');
    Validar('evtAdesao');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

end.
