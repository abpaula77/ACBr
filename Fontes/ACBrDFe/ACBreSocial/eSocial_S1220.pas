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

unit eSocial_S1220;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS1220Collection = class;
  TS1220CollectionItem = class;
  TEvtPgtosNI = class;
  TInfoPgtoItem = class;
  TInfoPgtoColecao = class;

  TS1220Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1220CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1220CollectionItem);
  public
    function Add: TS1220CollectionItem;
    property Items[Index: Integer]: TS1220CollectionItem read GetItem write SetItem; default;
  end;

  TS1220CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtPgtosNI: TEvtPgtosNI;
    procedure setEvtPgtosNI(const Value: TEvtPgtosNI);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtPgtosNI: TEvtPgtosNI read FEvtPgtosNI write setEvtPgtosNI;
  end;

  TEvtPgtosNI = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FInfoPgto: TInfoPgtoColecao;

    {Geradores espec�ficos da classe}
    procedure GerarInfoPgto();
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;

    property IdeEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property InfoPgto: TInfoPgtoColecao read FInfoPgto write FInfoPgto;
  end;

  TInfoPgtoItem = class(TCollectionItem)
  private
    FdtPgto: TDateTime;
    FperRef: string;
    FvlrLiq: Double;
    FvlrReaj: Double;
    FvlrIRRF: Double;
  published
    property dtPgto: TDateTime read FdtPgto write FdtPgto;
    property perRef: string read FperRef write FperRef;
    property vlrLiq: Double read FvlrLiq write FvlrLiq;
    property vlrReaj: Double read FvlrReaj write FvlrReaj;
    property vlrIRRF: Double read FvlrIRRF write FvlrIRRF;
  end;

  TInfoPgtoColecao = class(TCollection)
  private
    function GetItem(Index: Integer): TInfoPgtoItem;
    procedure SetItem(Index: Integer; const Value: TInfoPgtoItem);
  public
    constructor Create; reintroduce;
    function Add: TInfoPgtoItem;
    property Items[Index: Integer]: TInfoPgtoItem read GetItem write SetItem;
  end;


implementation

uses
  eSocial_Periodicos;

{ TS1220Collection }
function TS1220Collection.Add: TS1220CollectionItem;
begin
  Result := TS1220CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1220Collection.GetItem(Index: Integer): TS1220CollectionItem;
begin
  Result := TS1220CollectionItem(inherited GetItem(Index));
end;

procedure TS1220Collection.SetItem(Index: Integer;
  Value: TS1220CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{TS1220CollectionItem}
constructor TS1220CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1220;
  FEvtPgtosNI := TEvtPgtosNI.Create(AOwner);
end;

destructor TS1220CollectionItem.Destroy;
begin
  FEvtPgtosNI.Free;
  inherited;
end;

procedure TS1220CollectionItem.setEvtPgtosNI(const Value: TEvtPgtosNI);
begin
  FEvtPgtosNI.Assign(Value);
end;

{ TEvtSolicTotal }
constructor TEvtPgtosNI.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FInfoPgto := TInfoPgtoColecao.Create;
end;

destructor TEvtPgtosNI.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FInfoPgto.Free;
  inherited;
end;

procedure TEvtPgtosNI.GerarInfoPgto;
var
  iInfoPgtoItem: Integer;
  objInfoPgtoItem: TInfoPgtoItem;
begin
  for iInfoPgtoItem := 0 to infoPgto.Count - 1 do
  begin
    objInfoPgtoItem := infoPgto.Items[iInfoPgtoItem];
    Gerador.wGrupo('infoPgto');
      Gerador.wCampo(tcDat, '', 'dtPgto', 0, 0, 0,  objInfoPgtoItem.dtPgto);
      Gerador.wCampo(tcStr, '', 'perRef', 0, 0, 0,  objInfoPgtoItem.perRef);
      Gerador.wCampo(tcDe2, '', 'vlrLiq', 0, 0, 0,  objInfoPgtoItem.vlrLiq);
      Gerador.wCampo(tcDe2, '', 'vlrReaj', 0, 0, 0, objInfoPgtoItem.vlrReaj);
      Gerador.wCampo(tcDe2, '', 'vlrIRRF', 0, 0, 0, objInfoPgtoItem.vlrIRRF);
    Gerador.wGrupo('/infoPgto');
  end;
end;

function TEvtPgtosNI.GerarXML: boolean;
begin
  try
    GerarCabecalho('');
      Gerador.wGrupo('evtPgtosNI Id="'+GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0)+'"');
        gerarIdeEvento3(self.IdeEvento);
        gerarIdeEmpregador(self.IdeEmpregador);
        GerarInfoPgto;
      Gerador.wGrupo('/evtPgtosNI');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtPgtosNI');
    Validar('evtPgtosNI');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

{ TInfoPgtoColecao }
function TInfoPgtoColecao.Add: TInfoPgtoItem;
begin
  Result := TInfoPgtoItem(inherited add);
end;

constructor TInfoPgtoColecao.Create;
begin
  inherited create(TInfoPgtoItem)
end;

function TInfoPgtoColecao.GetItem(Index: Integer): TInfoPgtoItem;
begin
  Result := TInfoPgtoItem(inherited GetItem(Index));
end;

procedure TInfoPgtoColecao.SetItem(Index: Integer; const Value: TInfoPgtoItem);
begin
  inherited SetItem(Index, Value);
end;

end.
