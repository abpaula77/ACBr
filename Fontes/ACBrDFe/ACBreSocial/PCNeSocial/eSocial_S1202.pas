{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }

{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }

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

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 01/03/2016: Guilherme Costa
|*  - Altera��es para valida��o com o XSD
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S1202;

interface

uses
  SysUtils, Classes, Dialogs, Controls,
  pcnConversao, ACBrUtil,
  eSocial_Common, eSocial_Conversao, eSocial_Gerador;

type

  TRemunPer1202Collection = class;
  TRemunPer1202CollectionItem = class;
  TIdeEstabCollection = class;
  TIdeEstabCollectionItem = class;
  TIdePeriodoCollectionItem = class;
  TIdePeriodoCollection = class;
  TIdeADCCollectionItem = class;
  TIdeADCCollection = class;
  TInfoPerAnt = class;
  TInfoPerApur = class;
  TeS1202IdeTrabalhador = class;
  TEvtRemunRPPS = class;
  TS1202CollectionItem = class;
  TS1202Collection = class;
  TDMDevCollection = class;
  TDMDevCollectionItem = class;


  TS1202Collection = class(TOwnedCollection)
  private
    function GetItem(Index: integer): TS1202CollectionItem;
    procedure SetItem(Index: integer; Value: TS1202CollectionItem);
  public
    function Add: TS1202CollectionItem;
    property Items[Index: integer]: TS1202CollectionItem read GetItem write SetItem;
      default;
  end;

  TS1202CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtRmnRPPS: TEvtRemunRPPS;
    procedure seTEvtRemunRPPS(const Value: TEvtRemunRPPS);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtRmnRPPS: TEvtRemunRPPS read FEvtRmnRPPS write seTEvtRemunRPPS;
  end;

  TDMDevCollection = class(TCollection)
  private
    function GetItem(Index: integer): TDMDevCollectionItem;
    procedure SetItem(Index: integer; Value: TDMDevCollectionItem);
  public
    constructor Create(); reintroduce;

    function Add: TDMDevCollectionItem;
    property Items[Index: integer]: TDMDevCollectionItem read GetItem write SetItem;
      default;
  end;


  TDMDevCollectionItem = class(TCollectionItem)
  private
    FIdeDmDev: string;
    FInfoPerApur: TInfoPerApur;
    FInfoPerAnt: TInfoPerAnt;
    function getInfoPerApur: TInfoPerApur;
    function getInfoPerAnt: TInfoPerAnt;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function infoPerApurInst(): boolean;
    function infoPerAntInst(): boolean;
  published
    property ideDmDev: string read FIdeDmDev write FIdeDmDev;
    property infoPerApur: TInfoPerApur read getInfoPerApur write FInfoPerApur;
    property infoPerAnt: TInfoPerAnt read getInfoPerAnt write FInfoPerAnt;
  end;

  TEvtRemunRPPS = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FIdeTrabalhador: TeS1202IdeTrabalhador;
    FDMDev: TDMDevCollection;
    {Geradores espec�ficos desta classe}

    procedure GerarIdeEstab(objIdeEstab: TIdeEstabCollection;
      nomeRemunPer: string = 'remunPerApur');
    procedure GerarRemunPer(objRemunPer: TRemunPer1202Collection;
      nomeRemunPer: string = 'remunPerApur');
    procedure GerarIdePeriodo(objIdePeriodo: TIdePeriodoCollection);
    procedure GerarIdeADC(objIdeADC: TideADCCollection);

    procedure GerarIdeTrabalhador();
    procedure GerarDmDev();
    procedure GerarInfoPerApur(pInfoPerApur: TInfoPerApur);
    procedure GerarInfoPerAnt(pInfoPerAnt: TInfoPerAnt);
  public
    constructor Create(AACBreSocial: TObject); overload;
    destructor Destroy; override;

    function GerarXML: boolean; override;

    property ideEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property ideEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property ideTrabalhador: TeS1202IdeTrabalhador
      read FIdeTrabalhador write FIdeTrabalhador;
    property dmDev: TDMDevCollection read FDMDev write FDMDev;
  end;

  TRemunPer1202Collection = class(TCollection)
  private
    FNomeGrupoXML: string;
    function GetItem(Index: integer): TRemunPer1202CollectionItem;
    procedure SetItem(Index: integer; Value: TRemunPer1202CollectionItem);
  public
    constructor Create(); reintroduce;
    function Add: TRemunPer1202CollectionItem;
    property Items[Index: integer]: TRemunPer1202CollectionItem read GetItem write SetItem;
    property grupoXML: string read FNomeGrupoXML;
  end;

  TRemunPer1202CollectionItem = class(TRemunPerCollectionItem)
  private
    FCodCateg: Integer;
  public
    property codCateg: Integer read FCodCateg write FCodCateg;
  end;

  TIdeEstabCollection = class(TCollection)
  private
    function GetItem(Index: integer): TIdeEstabCollectionItem;
    procedure SetItem(Index: integer; Value: TIdeEstabCollectionItem);
  public
    constructor Create; reintroduce;
    function Add: TIdeEstabCollectionItem;
    property Items[Index: integer]: TIdeEstabCollectionItem
      read GetItem write SetItem;
  end;

  TIdeEstabCollectionItem = class(TCollectionItem)
  private
    FTpInsc: TpTpInsc;
    FNrInsc: string;
    FRemunPerApur: TRemunPer1202Collection;
    FRemunPerAnt: TRemunPer1202Collection;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property tpInsc: TpTPInsc read FTpInsc write FTpInsc;
    property nrInsc: string read FNrInsc write FNrInsc;
    property remunPerApur: TRemunPer1202Collection read FRemunPerApur write FRemunPerApur;
    property remunPerAnt: TRemunPer1202Collection read FRemunPerAnt write FRemunPerAnt;
  end;

  TIdePeriodoCollection = class(TCollection)
  private
    function GetItem(Index: integer): TIdePeriodoCollectionItem;
    procedure SetItem(Index: integer; Value: TIdePeriodoCollectionItem);
  public
    constructor Create; reintroduce;
    function Add: TIdePeriodoCollectionItem;
    property Items[Index: integer]: TIdePeriodoCollectionItem read GetItem write SetItem;
  end;

  TIdePeriodoCollectionItem = class(TCollectionItem)
  private
    FPerRef: string;
    FIdeEstab: TIdeEstabCollection;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property perRef: string read FPerRef write FPerRef;
    property ideEstab: TIdeEstabCollection read FIdeEstab write FIdeEstab;
  end;

  TIdeADCCollection = class(TCollection)
  private
    function GetItem(Index: integer): TIdeADCCollectionItem;
    procedure SetItem(Index: integer; Value: TIdeADCCollectionItem);
  public
    constructor Create; reintroduce;
    function add: TIdeADCCollectionItem;
    property Items[Index: integer]: TIdeADCCollectionItem read GetItem write SetItem;
  end;

  TIdeADCCollectionItem = class(TCollectionItem)
  private
    FDtLei: TDate;
    FNrLei: string;
    FDtEf: TDate;
    FIdePeriodo: TIdePeriodoCollection;
  public
    constructor Create; reintroduce;

    property DtLei: TDate read FDtLei write FDtLei;
    property nrLei: string read FNrLei write FNrLei;
    property DtEf: TDate read FDtEf write FDtEf;
    property idePeriodo: TIdePeriodoCollection read FIdePeriodo write FIdePeriodo;
  end;

  TInfoPerAnt = class(TPersistent)
  private
    FIdeADC: TIdeADCCollection;
  public
    constructor Create;
    destructor Destroy; override;
    property ideADC: TIdeADCCollection read FIdeADC write FIdeADC;
  end;

  TInfoPerApur = class(TPersistent)
  private
    FIdeEstab: TIdeEstabCollection;
  public
    constructor Create;
    destructor Destroy; override;
    property ideEstab: TIdeEstabCollection read FIdeEstab write FIdeEstab;
  end;

  TeS1202IdeTrabalhador = class(TideTrabalhador2)
  private
    FQtdDepFP: integer;
    FProcJudTrab: TProcJudTrabCollection;
    function getProcJudTrab: TProcJudTrabCollection;
  public
    constructor Create;
    destructor Destroy; override;
    function procJudTrabInst: boolean;

    property qtdDepFP: Integer read FQtdDepFP write FQtdDepFP;
    property procJudTrab: TProcJudTrabCollection read getProcJudTrab write FProcJudTrab;
  end;

implementation


{ TRemunPer1202Collection }
function TRemunPer1202Collection.Add: TRemunPer1202CollectionItem;
begin
  Result := TRemunPer1202CollectionItem(inherited Add);
  Result.Create;
end;

constructor TRemunPer1202Collection.Create();
begin
  inherited Create(TRemunPer1202CollectionItem);
end;

function TRemunPer1202Collection.GetItem(Index: integer): TRemunPer1202CollectionItem;
begin
  Result := TRemunPer1202CollectionItem(inherited GetItem(Index));
end;

procedure TRemunPer1202Collection.SetItem(Index: integer; Value: TRemunPer1202CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TIdeEstabCollectionItem }

constructor TIdeEstabCollectionItem.Create;
begin
  FRemunPerApur := TRemunPer1202Collection.Create;
  FRemunPerAnt := TRemunPer1202Collection.Create;
end;

destructor TIdeEstabCollectionItem.Destroy;
begin
  FRemunPerApur.Free;
  FRemunPerAnt.Free;
  inherited;
end;

{ TIdeEstabCollection }
function TIdeEstabCollection.Add: TIdeEstabCollectionItem;
begin
  Result := TIdeEstabCollectionItem(inherited Add);
  Result.Create;
end;

constructor TIdeEstabCollection.Create;
begin
  inherited Create(TIdeEstabCollectionItem);
end;

function TIdeEstabCollection.GetItem(Index: integer): TIdeEstabCollectionItem;
begin
  Result := TIdeEstabCollectionItem(inherited GetItem(Index));
end;

procedure TIdeEstabCollection.SetItem(Index: integer;
  Value: TIdeEstabCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TIdePeriodoCollectionItem }
constructor TIdePeriodoCollectionItem.Create;
begin
  FIdeEstab := TIdeEstabCollection.Create;
end;

destructor TIdePeriodoCollectionItem.Destroy;
begin
  FIdeEstab.Free;
  inherited;
end;

{ TIdePeriodoCollection }
function TIdePeriodoCollection.Add: TIdePeriodoCollectionItem;
begin
  Result := TIdePeriodoCollectionItem(inherited Add);
  Result.Create;
end;

constructor TIdePeriodoCollection.Create;
begin
  inherited Create(TIdePeriodoCollectionItem);
end;

function TIdePeriodoCollection.GetItem(Index: integer): TIdePeriodoCollectionItem;
begin
  Result := TIdePeriodoCollectionItem(inherited GetItem(Index));
end;

procedure TIdePeriodoCollection.SetItem(Index: integer;
  Value: TIdePeriodoCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TIdeADCCollectionItem }
constructor TIdeADCCollectionItem.Create;
begin
  FIdePeriodo := TIdePeriodoCollection.Create;
end;


{ TIdeADCCollection }
function TIdeADCCollection.add: TIdeADCCollectionItem;
begin
  Result := TIdeADCCollectionItem(inherited add);
  Result.Create;
end;

constructor TIdeADCCollection.Create;
begin
  inherited Create(TIdeADCCollectionItem);
end;

function TIdeADCCollection.GetItem(Index: integer): TIdeADCCollectionItem;
begin
  Result := TIdeADCCollectionItem(inherited GetItem(Index));
end;

procedure TIdeADCCollection.SetItem(Index: integer; Value: TIdeADCCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TInfoPerAnt }
constructor TInfoPerAnt.Create;
begin
  inherited;
  FIdeADC := TIdeADCCollection.Create;
end;

destructor TInfoPerAnt.Destroy;
begin
  FIdeADC.Free;
  inherited;
end;

{ TInfoPerApur }
constructor TInfoPerApur.Create;
begin
  inherited;
  FIdeEstab := TIdeEstabCollection.Create;
end;

destructor TInfoPerApur.Destroy;
begin
  FIdeEstab.Free;
  inherited;
end;

{ TideTrabalhador }
constructor TeS1202IdeTrabalhador.Create;
begin
  FProcJudTrab := nil;
end;

destructor TeS1202IdeTrabalhador.Destroy;
begin
  FreeAndNil(FProcJudTrab);
  inherited;
end;

function TeS1202IdeTrabalhador.getProcJudTrab: TProcJudTrabCollection;
begin
  if not Assigned(FProcJudTrab) then
    FProcJudTrab := TProcJudTrabCollection.Create;
  Result := FProcJudTrab;
end;

function TeS1202IdeTrabalhador.procJudTrabInst: boolean;
begin
  result := Assigned(FProcJudTrab);
end;

{ TDMDevCollection }

constructor TDMDevCollection.Create;
begin
  inherited Create(TDMDevCollectionItem);
end;

function TDMDevCollection.Add: TDMDevCollectionItem;
begin
  Result := TDMDevCollectionItem(inherited add());
  Result.Create;
end;

function TDMDevCollection.GetItem(Index: integer): TDMDevCollectionItem;
begin
  Result := TDMDevCollectionItem(inherited GetItem(Index));
end;

procedure TDMDevCollection.SetItem(Index: integer; Value: TDMDevCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TDMDevCollectionItem }

constructor TDMDevCollectionItem.Create;
begin
  FInfoPerApur := nil;
  FInfoPerAnt := nil;
end;

destructor TDMDevCollectionItem.Destroy;
begin
  FreeAndNil(FInfoPerApur);
  FreeAndNil(FInfoPerAnt);
  inherited;
end;

function TDMDevCollectionItem.getInfoPerApur: TInfoPerApur;
begin
  if not (Assigned(FInfoPerApur)) then
    FInfoPerApur := TInfoPerApur.Create;
  Result := FInfoPerApur;
end;

function TDMDevCollectionItem.infoPerApurInst: boolean;
begin
  Result := Assigned(FInfoPerApur);
end;

function TDMDevCollectionItem.getInfoPerAnt: TInfoPerAnt;
begin
  if not (Assigned(FInfoPerAnt)) then
    FInfoPerAnt := TInfoPerAnt.Create;
  Result := FInfoPerAnt;
end;


function TDMDevCollectionItem.infoPerAntInst: boolean;
begin
  Result := Assigned(FInfoPerAnt);
end;

{ TEvtRemunRPPS }
constructor TEvtRemunRPPS.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeTrabalhador := TeS1202IdeTrabalhador.Create;
  FDMDev := TDMDevCollection.Create;
end;

destructor TEvtRemunRPPS.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeTrabalhador.Free;
  FDMDev.Free;
  inherited;
end;

procedure TEvtRemunRPPS.GerarIdeADC(objIdeADC: TideADCCollection);
var
  iIdeADC: integer;
begin
  for iIdeADC := 0 to objIdeADC.Count - 1 do
  begin
    Gerador.wGrupo('ideADC');
    Gerador.wCampo(tcDat, '', 'dtLei', 0, 0, 0, objIdeADC.Items[iIdeADC].DtLei);
    Gerador.wCampo(tcStr, '', 'nrLei', 0, 0, 0, objIdeADC.Items[iIdeADC].nrLei);
    Gerador.wCampo(tcDat, '', 'dtEf', 0, 0, 0, objIdeADC.Items[iIdeADC].DtEf);
    GerarIdePeriodo(objIdeADC.Items[iIdeADC].idePeriodo);
    Gerador.wGrupo('/ideADC');
  end;
end;

procedure TEvtRemunRPPS.GerarIdeEstab(objIdeEstab: TIdeEstabCollection;
  nomeRemunPer: string = 'remunPerApur');
var
  iIdeEstab: integer;
begin
  for iIdeEstab := 0 to objIdeEstab.Count - 1 do
  begin
    Gerador.wGrupo('ideEstab');
    Gerador.wCampo(tcInt, '', 'tpInsc', 0, 0, 0,
      eSTpInscricaoToStr(objIdeEstab.Items[iIdeEstab].tpInsc));
    Gerador.wCampo(tcStr, '', 'nrInsc', 0, 0, 0,
      objIdeEstab.Items[iIdeEstab].nrInsc);
    if nomeRemunPer = 'remunPerApur' then
      GerarRemunPer(objIdeEstab.Items[iIdeEstab].remunPerApur, nomeRemunPer)
    else
      GerarRemunPer(objIdeEstab.Items[iIdeEstab].remunPerAnt, nomeRemunPer);
    Gerador.wGrupo('/ideEstab');
  end;
end;

procedure TEvtRemunRPPS.GerarIdePeriodo(objIdePeriodo: TIdePeriodoCollection);
var
  iIdePeriodo: integer;
begin
  for iIdePeriodo := 0 to objIdePeriodo.Count - 1 do
  begin
    Gerador.wGrupo('idePeriodo');
    Gerador.wCampo(tcStr, '', 'perRef', 0, 0, 0,
      objIdePeriodo.Items[iIdePeriodo].perRef);
    GerarIdeEstab(objIdePeriodo.Items[iIdePeriodo].ideEstab, 'remunPerAnt');
    Gerador.wGrupo('/idePeriodo');
  end;
end;

procedure TEvtRemunRPPS.GerarIdeTrabalhador;
begin
  Gerador.wGrupo('ideTrabalhador');
  Gerador.wCampo(tcStr, '', 'cpfTrab', 0, 0, 0, ideTrabalhador.cpfTrab);
  Gerador.wCampo(tcStr, '', 'nisTrab', 0, 0, 0, ideTrabalhador.nisTrab);
  Gerador.wCampo(tcInt, '', 'qtdDepFP', 0, 0, 0, ideTrabalhador.qtdDepFP);
  if ideTrabalhador.procJudTrabInst() then
    GerarProcJudTrab(ideTrabalhador.procJudTrab);
  Gerador.wGrupo('/ideTrabalhador');
end;

procedure TEvtRemunRPPS.GerarInfoPerAnt(pInfoPerAnt: TInfoPerAnt);
begin
  Gerador.wGrupo('infoPerAnt');
  GerarIdeADC(pInfoPerAnt.ideADC);
  Gerador.wGrupo('/infoPerAnt');
end;

procedure TEvtRemunRPPS.GerarDmDev;
var
  i: integer;
begin
  for i := 0 to dmDev.Count - 1 do
  begin
    Gerador.wGrupo('dmDev');
      Gerador.wCampo(tcStr, '', 'ideDmDev', 0, 0, 0, dmDev[i].ideDmDev);
      if (dmDev[i].infoPerApurInst()) then
        GerarInfoPerApur(dmDev[i].infoPerApur);
      if (dmDev[i].infoPerAntInst()) then
        GerarInfoPerAnt(dmDev[i].infoPerAnt);
    Gerador.wGrupo('/dmDev');
  end;
end;

procedure TEvtRemunRPPS.GerarInfoPerApur(pInfoPerApur: TInfoPerApur);
begin
  Gerador.wGrupo('infoPerApur');
    GerarIdeEstab(pInfoPerApur.ideEstab);
  Gerador.wGrupo('/infoPerApur');
end;

procedure TEvtRemunRPPS.GerarRemunPer(objRemunPer: TRemunPer1202Collection;
  nomeRemunPer: string = 'remunPerApur');
var
  iRemunPer: integer;
begin
  for iRemunPer := 0 to objRemunPer.Count - 1 do
  begin
    Gerador.wGrupo(nomeRemunPer);
    Gerador.wCampo(tcStr, '', 'matricula', 0, 0, 0,
      objRemunPer.Items[iRemunPer].matricula);
    Gerador.wCampo(tcInt, '', 'codCateg', 0, 0, 0,
      objRemunPer.Items[iRemunPer].codCateg);
    GerarItensRemun(objRemunPer.Items[iRemunPer].itensRemun, 'itensRemun');
    if (nomeRemunPer = 'remunPerApur') then
    begin
      if objRemunPer.Items[iRemunPer].infoSaudeColetInst() then
        GerarInfoSaudeColet(objRemunPer.Items[iRemunPer].infoSaudeColet);
    end;
    Gerador.wGrupo('/' + nomeRemunPer);
  end;
end;

function TEvtRemunRPPS.GerarXML: boolean;
begin
  try
    GerarCabecalho('evtRmnRPPS');
    Gerador.wGrupo('evtRmnRPPS Id="' + GerarChaveEsocial(now,
      self.ideEmpregador.NrInsc, 0) + '"');
    GerarIdeEvento3(Self.IdeEvento);
    GerarIdeEmpregador(Self.ideEmpregador);
    GerarIdeTrabalhador();
    GerarDmDev();
    Gerador.wGrupo('/evtRmnRPPS');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtRmnRPPS');
    Validar('evtRmnRPPS');
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '');
end;

{ TS1202CollectionItem }
constructor TS1202CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1202;
  FEvtRmnRPPS := TEvtRemunRPPS.Create(AOwner);
end;

destructor TS1202CollectionItem.Destroy;
begin
  FEvtRmnRPPS.Free;
  inherited;
end;

procedure TS1202CollectionItem.seTEvtRemunRPPS(const Value: TEvtRemunRPPS);
begin
  FEvtRmnRPPS.Assign(Value);
end;

{ TS1202Collection }
function TS1202Collection.Add: TS1202CollectionItem;
begin
  Result := TS1202CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1202Collection.GetItem(Index: integer): TS1202CollectionItem;
begin
  Result := TS1202CollectionItem(inherited GetItem(Index));
end;

procedure TS1202Collection.SetItem(Index: integer; Value: TS1202CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

end.
