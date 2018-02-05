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

unit pcesS1300;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnGerador,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS1300Collection = class;
  TS1300CollectionItem = class;
  TEvtContrSindPatr = class;
  TContribSindItem = class;
  TContribSindColecao = class;

  TS1300Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1300CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1300CollectionItem);
  public
    function Add: TS1300CollectionItem;
    property Items[Index: Integer]: TS1300CollectionItem read GetItem write SetItem; default;
  end;

  TS1300CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtContrSindPatr: TEvtContrSindPatr;

    procedure setEvtContrSindPatr(const Value: TEvtContrSindPatr);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtContrSindPatr: TEvtContrSindPatr read FEvtContrSindPatr write setEvtContrSindPatr;
  end;

  TEvtContrSindPatr = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FContribSind: TContribSindColecao;

    {Geradores espec�ficos da classe}
    procedure GerarContribSind();
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML(ATipoEmpregador: TEmpregador): boolean; override;

    property IdeEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property ContribSind: TContribSindColecao read FContribSind write FContribSind;
  end;

  TContribSindItem = class(TCollectionItem)
  private
    FcnpjSindic: string;
    FtpContribSind: tpTpContribSind;
    FvlrContribSind: Double;
  published
    property cnpjSindic: string read FcnpjSindic write FcnpjSindic;
    property tpContribSind: tpTpContribSind read FtpContribSind write FtpContribSind;
    property vlrContribSind: Double read FvlrContribSind write FvlrContribSind;
  end;

  TContribSindColecao = class(TCollection)
  private
    function GetItem(Index: Integer): TContribSindItem;
    procedure SetItem(Index: Integer; const Value: TContribSindItem);
  public
    constructor Create; reintroduce;
    function Add: TContribSindItem;
    property Items[Index: Integer]: TContribSindItem read GetItem write SetItem;
  end;

implementation

{ TS1300Collection }

function TS1300Collection.Add: TS1300CollectionItem;
begin
  Result := TS1300CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1300Collection.GetItem(Index: Integer): TS1300CollectionItem;
begin
  Result := TS1300CollectionItem(inherited GetItem(Index));
end;

procedure TS1300Collection.SetItem(Index: Integer;
  Value: TS1300CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{TS1300CollectionItem}
constructor TS1300CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1300;
  FEvtContrSindPatr := TEvtContrSindPatr.Create(AOwner);
end;

destructor TS1300CollectionItem.Destroy;
begin
  FEvtContrSindPatr.Free;

  inherited;
end;

procedure TS1300CollectionItem.setEvtContrSindPatr(const Value: TEvtContrSindPatr);
begin
  FEvtContrSindPatr.Assign(Value);
end;

{ TEvtSolicTotal }
constructor TEvtContrSindPatr.Create(AACBreSocial: TObject);
begin
  inherited;

  FIdeEvento := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FContribSind := TContribSindColecao.Create;
end;

destructor TEvtContrSindPatr.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FContribSind.Free;

  inherited;
end;

procedure TEvtContrSindPatr.GerarContribSind;
var
  i: Integer;
begin
  for i := 0 to ContribSind.Count - 1 do
  begin
    Gerador.wGrupo('contribSind');

    Gerador.wCampo(tcStr, '', 'cnpjSindic',     14, 14, 1, ContribSind.Items[i].cnpjSindic);
    Gerador.wCampo(tcStr, '', 'tpContribSind',   1,  1, 1, eSTpContribSindToStr(ContribSind.Items[i].tpContribSind));
    Gerador.wCampo(tcDe2, '', 'vlrContribSind',  1, 14, 1, ContribSind.Items[i].vlrContribSind);

    Gerador.wGrupo('/contribSind');
  end;

  if ContribSind.Count > 999 then
    Gerador.wAlerta('', 'contribSind', 'Lista de Contribui��o Sindical', ERR_MSG_MAIOR_MAXIMO + '999');
end;

function TEvtContrSindPatr.GerarXML(ATipoEmpregador: TEmpregador): boolean;
begin
  try
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc,
     self.Sequencial, ATipoEmpregador);

    GerarCabecalho('evtContrSindPatr');
    Gerador.wGrupo('evtContrSindPatr Id="' + Self.Id + '"');

    GerarIdeEvento3(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarContribSind;

    Gerador.wGrupo('/evtContrSindPatr');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtContrSindPatr');

    Validar('evtContrSindPatr');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TContribSindColecao.Add: TContribSindItem;
begin
  Result := TContribSindItem(inherited add);
end;

constructor TContribSindColecao.Create;
begin
  inherited create(TContribSindItem)
end;

function TContribSindColecao.GetItem(Index: Integer): TContribSindItem;
begin
  Result := TContribSindItem(inherited GetItem(Index));
end;

procedure TContribSindColecao.SetItem(Index: Integer; const Value: TContribSindItem);
begin
  inherited SetItem(Index, Value);
end;

end.
