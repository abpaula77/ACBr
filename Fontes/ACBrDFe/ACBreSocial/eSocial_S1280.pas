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

unit eSocial_S1280;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS1280Collection = class;
  TS1280CollectionItem = class;
  TEvtInfoComplPer = class;
  TInfoSubstPatrOpPortItem = class;
  TInfoSubstPatrOpPortColecao = class;
  TInfoSubstPatr = class;
  TInfoAtivConcom = class;

  TS1280Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1280CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1280CollectionItem);
  public
    function Add: TS1280CollectionItem;
    property Items[Index: Integer]: TS1280CollectionItem read GetItem write SetItem; default;
  end;

  TS1280CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtInfoComplPer: TEvtInfoComplPer;
    procedure setEvtInfoComplPer(const Value: TEvtInfoComplPer);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor  Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtInfoComplPer: TEvtInfoComplPer read FEvtInfoComplPer write setEvtInfoComplPer;
  end;

  TEvtInfoComplPer = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FInfoSubstPatr: TInfoSubstPatr;
    FInfoAtivConcom: TInfoAtivConcom;
    FInfoSubstPatrOpPort: TInfoSubstPatrOpPortColecao;

    {Geradores espec�ficos da classe}
    procedure GerarInfoSubstPatr();
    procedure GerarInfoSubstPatrOpPort();
    procedure GerarInfoAtivConcom();
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;

    property IdeEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property InfoSubstPatr: TInfoSubstPatr read FInfoSubstPatr write FInfoSubstPatr;
    property InfoAtivConcom: TInfoAtivConcom read FInfoAtivConcom write FInfoAtivConcom;
    property InfoSubstPatrOpPort: TInfoSubstPatrOpPortColecao read FInfoSubstPatrOpPort write FInfoSubstPatrOpPort;
  end;

  TInfoSubstPatr = class(TPersistent)
  private
    FindSubstPatr: tpIndSubstPatrOpPort;
    FpercRedContrib: double;
  public
    property indSubstPatr: tpIndSubstPatrOpPort read FindSubstPatr write FindSubstPatr;
    property percRedContrib: double read FpercRedContrib write FpercRedContrib;
  end;

  TInfoSubstPatrOpPortItem = class(TCollectionItem)
  private
    FcnpjOpPortuario : string;
  published
    property cnpjOpPortuario: string read FcnpjOpPortuario write FcnpjOpPortuario;
  end;

  TInfoSubstPatrOpPortColecao = class(TCollection)
  private
    function GetItem(Index: Integer): TInfoSubstPatrOpPortItem;
    procedure SetItem(Index: Integer; const Value: TInfoSubstPatrOpPortItem);
  public
    constructor Create; reintroduce;
    function Add: TInfoSubstPatrOpPortItem;
    property Items[Index: Integer]: TInfoSubstPatrOpPortItem read GetItem write SetItem;
  end;

  TInfoAtivConcom = class(TPersistent)
  private
    FfatorMes: Double;
    Ffator13: Double;
  public
    property fatorMes: Double read FfatorMes write FfatorMes;
    property fator13: Double read Ffator13 write Ffator13;
  end;


implementation

uses
  eSocial_Periodicos;

{ TS1280Collection }
function TS1280Collection.Add: TS1280CollectionItem;
begin
  Result := TS1280CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1280Collection.GetItem(Index: Integer): TS1280CollectionItem;
begin
  Result := TS1280CollectionItem(inherited GetItem(Index));
end;

procedure TS1280Collection.SetItem(Index: Integer;
  Value: TS1280CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{TS1280CollectionItem}
constructor TS1280CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1280;
  FEvtInfoComplPer := TEvtInfoComplPer.Create(AOwner);
end;

destructor TS1280CollectionItem.Destroy;
begin
  FEvtInfoComplPer.Free;
  inherited;
end;

procedure TS1280CollectionItem.setEvtInfoComplPer(const Value: TEvtInfoComplPer);
begin
  FEvtInfoComplPer.Assign(Value);
end;

{ TEvtSolicTotal }
constructor TEvtInfoComplPer.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FInfoSubstPatr := TInfoSubstPatr.Create;
  FInfoSubstPatrOpPort := TInfoSubstPatrOpPortColecao.Create;
  FInfoAtivConcom := TInfoAtivConcom.Create;
end;

destructor TEvtInfoComplPer.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FInfoSubstPatr.Free;
  FInfoSubstPatrOpPort.Free;
  FInfoAtivConcom.Free;
  inherited;
end;

procedure TEvtInfoComplPer.GerarInfoAtivConcom;
begin
  Gerador.wGrupo('infoAtivConcom');
    Gerador.wCampo(tcDe2, '', 'fatorMes', 0, 0, 0,  InfoAtivConcom.fatorMes);
    Gerador.wCampo(tcDe2, '', 'fator13', 0, 0, 0,  InfoAtivConcom.fator13);
  Gerador.wGrupo('/infoAtivConcom');
end;

procedure TEvtInfoComplPer.GerarInfoSubstPatr;
begin
  Gerador.wGrupo('infoSubstPatr');
    Gerador.wCampo(tcStr, '', 'indSubstPatr', 0, 0, 0,  eSIndSubstPatrOpPortStr(InfoSubstPatr.indSubstPatr));
    Gerador.wCampo(tcDe2, '', 'percRedContrib', 0, 0, 1,  InfoSubstPatr.percRedContrib);
  Gerador.wGrupo('/infoSubstPatr');
end;

procedure TEvtInfoComplPer.GerarInfoSubstPatrOpPort;
var
  iInfoSubstPatrOpPortItem: Integer;
  objInfoSubstPatrOpPortItem: TInfoSubstPatrOpPortItem;
begin
  for iInfoSubstPatrOpPortItem := 0 to InfoSubstPatrOpPort.Count - 1 do
  begin
    objInfoSubstPatrOpPortItem := InfoSubstPatrOpPort.Items[iInfoSubstPatrOpPortItem];
    Gerador.wGrupo('infoSubstPatrOpPort');
      Gerador.wCampo(tcStr, '', 'cnpjOpPortuario', 0, 0, 0,  objInfoSubstPatrOpPortItem.cnpjOpPortuario);
    Gerador.wGrupo('/infoSubstPatrOpPort');
  end;
end;

function TEvtInfoComplPer.GerarXML: boolean;
begin
  try
    GerarCabecalho('evtInfoComplPer');
      Gerador.wGrupo('evtInfoComplPer Id="'+GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0)+'"');
        gerarIdeEvento3(self.IdeEvento);
        gerarIdeEmpregador(self.IdeEmpregador);
        GerarInfoSubstPatr;
        GerarInfoSubstPatrOpPort;
        GerarInfoAtivConcom;
      Gerador.wGrupo('/evtInfoComplPer');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtInfoComplPer');
    Validar('evtInfoComplPer');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

{ TInfoSubstPatrOpPortColecao }
function TInfoSubstPatrOpPortColecao.Add: TInfoSubstPatrOpPortItem;
begin
  Result := TInfoSubstPatrOpPortItem(inherited add);
end;

constructor TInfoSubstPatrOpPortColecao.Create;
begin
  inherited create(TInfoSubstPatrOpPortItem)
end;

function TInfoSubstPatrOpPortColecao.GetItem(Index: Integer): TInfoSubstPatrOpPortItem;
begin
  Result := TInfoSubstPatrOpPortItem(inherited GetItem(Index));
end;

procedure TInfoSubstPatrOpPortColecao.SetItem(Index: Integer; const Value: TInfoSubstPatrOpPortItem);
begin
  inherited SetItem(Index, Value);
end;

end.
