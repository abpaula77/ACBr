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

unit pcesS1270;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnGerador,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS1270Collection = class;
  TS1270CollectionItem = class;
  TEvtContratAvNP = class;
  TRemunAvNPItem = class;
  TRemunAvNPColecao = class;

  TS1270Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1270CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1270CollectionItem);
  public
    function Add: TS1270CollectionItem;
    property Items[Index: Integer]: TS1270CollectionItem read GetItem write SetItem; default;
  end;

  TS1270CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtContratAvNP: TEvtContratAvNP;

    procedure setEvtContratAvNP(const Value: TEvtContratAvNP);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtContratAvNP: TEvtContratAvNP read FEvtContratAvNP write setEvtContratAvNP;
  end;

  TEvtContratAvNP = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FRemunAvNp: TRemunAvNPColecao;

    {Geradores espec�ficos da classe}
    procedure GerarRemunAvNP(pRemunAvNPColecao: TRemunAvNPColecao);
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor Destroy; override;

    function GerarXML(ATipoEmpregador: TEmpregador): boolean; override;

    property IdeEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property remunAvNp: TRemunAvNPColecao read FRemunAvNp write FRemunAvNp;
  end;

  TRemunAvNPColecao = class(TCollection)
  private
    function GetItem(Index: Integer): TRemunAvNPItem;
    procedure SetItem(Index: Integer; const Value: TRemunAvNPItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TRemunAvNPItem;
    property Items[Index: Integer]: TRemunAvNPItem read GetItem write SetItem;
  end;

  TRemunAvNPItem = class(TCollectionItem)
  private
    FtpInsc: tpTpInsc;
    FnrInsc: string;
    FCodLotacao: string;
    FVrBcCp00: Double;
    FVrBcCp15: Double;
    FVrBcCp20: Double;
    FVrBcCp25: Double;
    FVrBcCp13: Double;
    FVrBcFgts: Double;
    FVrDescCP: Double;
  public
    property tpInsc: tpTpInsc read FtpInsc write FtpInsc;
    property nrInsc: string read FnrInsc write FnrInsc;
    property codLotacao: string read FCodLotacao write FCodLotacao;
    property vrBcCp00: Double read FVrBcCp00 write FVrBcCp00;
    property vrBcCp15: Double read FVrBcCp15 write FVrBcCp15;
    property vrBcCp20: Double read FVrBcCp20 write FVrBcCp20;
    property vrBcCp25: Double read FVrBcCp25 write FVrBcCp25;
    property vrBcCp13: Double read FVrBcCp13 write FVrBcCp13;
    property vrBcFgts: Double read FVrBcFgts write FVrBcFgts;
    property vrDescCP: Double read FVrDescCP write FVrDescCP;
  end;

implementation

{ TS1270Collection }

function TS1270Collection.Add: TS1270CollectionItem;
begin
  Result := TS1270CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1270Collection.GetItem(Index: Integer): TS1270CollectionItem;
begin
  Result := TS1270CollectionItem(inherited GetItem(Index));
end;

procedure TS1270Collection.SetItem(Index: Integer;
  Value: TS1270CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{TS1270CollectionItem}
constructor TS1270CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento     := teS1270;
  FEvtContratAvNP := TEvtContratAvNP.Create(AOwner);
end;

destructor TS1270CollectionItem.Destroy;
begin
  FEvtContratAvNP.Free;

  inherited;
end;

procedure TS1270CollectionItem.setEvtContratAvNP(const Value: TEvtContratAvNP);
begin
  FEvtContratAvNP.Assign(Value);
end;

{ TEvtContratAvNP }
constructor TEvtContratAvNP.Create(AACBreSocial: TObject);
begin
  inherited;

  FIdeEvento     := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FRemunAvNp     := TRemunAvNPColecao.Create(FRemunAvNp);
end;

destructor TEvtContratAvNP.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FRemunAvNp.Free;

  inherited;
end;

procedure TEvtContratAvNP.GerarRemunAvNP(pRemunAvNPColecao: TRemunAvNPColecao);
var
  i: integer;
begin
  for i := 0 to pRemunAvNPColecao.Count - 1 do
  begin
    Gerador.wGrupo('remunAvNP');

    Gerador.wCampo(tcInt, '', 'tpInsc',     1,  1, 1, eSTpInscricaoToStr(pRemunAvNPColecao.Items[i].tpInsc));
    Gerador.wCampo(tcStr, '', 'nrInsc',     1, 15, 1, pRemunAvNPColecao.Items[i].nrInsc);
    Gerador.wCampo(tcStr, '', 'codLotacao', 1, 30, 1, pRemunAvNPColecao.Items[i].codLotacao);
    Gerador.wCampo(tcDe2, '', 'vrBcCp00',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp00);
    Gerador.wCampo(tcDe2, '', 'vrBcCp15',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp15);
    Gerador.wCampo(tcDe2, '', 'vrBcCp20',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp20);
    Gerador.wCampo(tcDe2, '', 'vrBcCp25',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp25);
    Gerador.wCampo(tcDe2, '', 'vrBcCp13',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp13);
    Gerador.wCampo(tcDe2, '', 'vrBcFgts',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcFgts);
    Gerador.wCampo(tcDe2, '', 'vrDescCP',   1, 14, 1, pRemunAvNPColecao.Items[i].vrDescCP);

    Gerador.wGrupo('/remunAvNP');
  end;

  if pRemunAvNPColecao.Count > 999 then
    Gerador.wAlerta('', 'remunAvNP', 'Lista de Remunera��o', ERR_MSG_MAIOR_MAXIMO + '999');
end;

function TEvtContratAvNP.GerarXML(ATipoEmpregador: TEmpregador): boolean;
begin
  try
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc,
     self.Sequencial, ATipoEmpregador);

    GerarCabecalho('evtContratAvNP');
    Gerador.wGrupo('evtContratAvNP Id="' + Self.Id + '"');

    gerarIdeEvento3(self.IdeEvento);
    gerarIdeEmpregador(self.IdeEmpregador);
    GerarRemunAvNP(remunAvNp);

    Gerador.wGrupo('/evtContratAvNP');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtContratAvNP');

    Validar('evtContratAvNP');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

{ TRemunAvNPColecao }
function TRemunAvNPColecao.Add: TRemunAvNPItem;
begin
  Result := TRemunAvNPItem(inherited Add);
end;

constructor TRemunAvNPColecao.Create(AOwner: TPersistent);
begin
  inherited Create(TRemunAvNPItem);
end;

function TRemunAvNPColecao.GetItem(Index: Integer): TRemunAvNPItem;
begin
  Result := TRemunAvNPItem(inherited GetItem(Index));
end;

procedure TRemunAvNPColecao.SetItem(Index: Integer;
  const Value: TRemunAvNPItem);
begin
  inherited SetItem(Index, Value);
end;

end.
