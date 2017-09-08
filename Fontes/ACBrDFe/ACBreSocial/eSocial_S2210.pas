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
|*  - Alterado alguns atributos e nome de tag
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S2210;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS2210Collection = class;
  TS2210CollectionItem = class;
  TEvtCAT = class;
  TCat = class;
  TCatOrigem = class;
  TAtestado = class;
  TAgenteCausadorColecao = class;
  TAgenteCausadorItem = class;
  TParteAtingidaColecao = class;
  TParteAtingidaItem = class;
  TLocalAcidente = class;
  TIdeRegistrador = class;


  TS2210Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS2210CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2210CollectionItem);
  public
    function Add: TS2210CollectionItem;
    property Items[Index: Integer]: TS2210CollectionItem read GetItem write SetItem; default;
  end;

  TS2210CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtCAT: TEvtCAT;

    procedure setEvtCAT(const Value: TEvtCAT);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtCAT: TEvtCAT read FEvtCAT write setEvtCAT;
  end;

  TEvtCAT = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento2;
    FIdeRegistrador: TIdeRegistrador;
    FIdeEmpregador: TIdeEmpregador;
    FIdeTrabalhador: TideTrabalhador2;
    FCat: TCat;
    procedure GerarIdeRegistrador;
    procedure GerarCAT;
    procedure GerarLocalAcidente;
    procedure GerarParteAtingida;
    procedure GerarAgenteCausador;
    procedure GerarAtestado;
    procedure GerarCatOrigem;
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor Destroy; override;

    function GerarXML: boolean; override;

    property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeRegistrador: TIdeRegistrador read FIdeRegistrador write FIdeRegistrador;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeTrabalhador: TideTrabalhador2 read FIdeTrabalhador write FIdeTrabalhador;
    property Cat: TCat read FCat write FCat;
  end;

  TIdeRegistrador = class
  private
    FtpRegistrador: tpTpRegistrador;
    FtpInsc: tpTpInsc;
    FnrInsc: string;
  public
    property tpRegistrador: tpTpRegistrador read FtpRegistrador write FtpRegistrador;
    property tpInsc: tpTpInsc read FtpInsc write FtpInsc;
    property nrInsc: string read FnrInsc write FnrInsc;
  end;

  TCat = class(TPersistent)
  private
    FdtAcid: TDateTime;
    FTpAcid: string;
    FhrAcid: string;
    FhrsTrabAntesAcid: string;
    FtpCat: tpTpCat;
    FindCatObito: tpSimNao;
    FDtObito: TDate;
    FindComunPolicia: tpSimNao;
    FcodSitGeradora: integer;
    FiniciatCAT: tpIniciatCAT;
    Fobservacao: string;

    FLocalAcidente: TLocalAcidente;
    FParteAtingida: TParteAtingidaColecao;
    FAgenteCausador: TAgenteCausadorColecao;
    FAtestado: TAtestado;
    FCatOrigem: TCatOrigem;
  public
    constructor create;
    destructor Destroy; override;

    property dtAcid: TDateTime read FdtAcid write FdtAcid;
    property TpAcid: string read FTpAcid write FTpAcid;
    property hrAcid: string read FhrAcid write FhrAcid;
    property hrsTrabAntesAcid: string read FhrsTrabAntesAcid write FhrsTrabAntesAcid;
    property tpCat: tpTpCat read FtpCat write FtpCat;
    property indCatObito: tpSimNao read FindCatObito write FindCatObito;
    property dtOBito: TDate read FDtObito write FDtObito;
    property indComunPolicia: tpSimNao read FindComunPolicia write FindComunPolicia;
    property codSitGeradora: integer read FcodSitGeradora write FcodSitGeradora;
    property iniciatCAT: tpIniciatCAT read FiniciatCAT write FiniciatCAT;
    property observacao: string read Fobservacao write Fobservacao;

    property LocalAcidente: TLocalAcidente read FLocalAcidente write FLocalAcidente;
    property ParteAtingida: TParteAtingidaColecao read FParteAtingida write FParteAtingida;
    property AgenteCausador: TAgenteCausadorColecao read FAgenteCausador write FAgenteCausador;
    property Atestado: TAtestado read FAtestado write FAtestado;
    property CatOrigem: TCatOrigem read FCatOrigem write FCatOrigem;
  end;

  TAtestado = class
  private
    FcodCNES: String;
    FdtAtendimento: TDateTime;
    FhrAtendimento: string;
    FindInternacao: tpSimNao;
    FdurTrat: integer;
    FindAfast: tpSimNao;
    FdscLesao: integer;
    FdscCompLesao: string;
    FdiagProvavel: string;
    FcodCID: string;
    Fobservacao: string;

    FEmitente: TEmitente;
  public
    constructor create;
    destructor Destroy; override;

    property codCNES: String read FcodCNES write FcodCNES;
    property dtAtendimento: TDateTime read FdtAtendimento write FdtAtendimento;
    property hrAtendimento: string read FhrAtendimento write FhrAtendimento;
    property indInternacao: tpSimNao read FindInternacao write FindInternacao;
    property durTrat: integer read FdurTrat write FdurTrat;
    property indAfast: tpSimNao read FindAfast write FindAfast;
    property dscLesao: integer read FdscLesao write FdscLesao;
    property dscCompLesao: string read FdscCompLesao write FdscCompLesao;
    property diagProvavel: string read FdiagProvavel write FdiagProvavel;
    property codCID: string read FcodCID write FcodCID;
    property observacao: string read Fobservacao write Fobservacao;
    property Emitente: TEmitente read FEmitente write FEmitente;
  end;

  TCatOrigem = class
  private
    FdtCatOrig: TDateTime;
    FnrCatOrig: string;
  public
    property dtCatOrig: TDateTime read FdtCatOrig write FdtCatOrig;
    property nrCatOrig: string read FnrCatOrig write FnrCatOrig;
  end;

  TAgenteCausadorItem = class(TCollectionItem)
  private
    FcodAgntCausador: Integer;
  published
    property codAgntCausador: Integer read FcodAgntCausador write FcodAgntCausador;
  end;

  TAgenteCausadorColecao = class(TCollection)
  private
    function GetItem(Index: Integer): TAgenteCausadorItem;
    procedure SetItem(Index: Integer; const Value: TAgenteCausadorItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TAgenteCausadorItem;
    property Items[Index: Integer]: TAgenteCausadorItem read GetItem write SetItem;
  end;

  TParteAtingidaItem = class(TCollectionItem)
  private
    FcodParteAting: Integer;
    Flateralidade: tpLateralidade;
  published
    property codParteAting: Integer read FcodParteAting write FcodParteAting;
    property lateralidade: tpLateralidade read Flateralidade write Flateralidade;
  end;

  TParteAtingidaColecao = class(TCollection)
  private
    function GetItem(Index: Integer): TParteAtingidaItem;
    procedure SetItem(Index: Integer; const Value: TParteAtingidaItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TParteAtingidaItem;
    property Items[Index: Integer]: TParteAtingidaItem read GetItem write SetItem;
  end;

  TLocalAcidente = class
  private
    FtpLocal: tpTpLocal;
    FdscLocal: string;
    FdscLograd: string;
    FnrLograd: string;
    FcodMunic: Integer;
    Fuf: tpuf;
    FcnpjLocalAcid: string;
    FPais: string;
    FCodPostal: string;
  public
    property tpLocal: tpTpLocal read FtpLocal write FtpLocal;
    property dscLocal: string read FdscLocal write FdscLocal;
    property dscLograd: string read FdscLograd write FdscLograd;
    property nrLograd: string read FnrLograd write FnrLograd;
    property codMunic: Integer read FcodMunic write FcodMunic;
    property uf: tpuf read Fuf write Fuf;
    property cnpjLocalAcid: string read FcnpjLocalAcid write FcnpjLocalAcid;
    property pais: string read FPais write FPais;
    property codPostal: string read FCodPostal write FCodPostal;
  end;

implementation

uses
  eSocial_NaoPeriodicos;

{ TS2210Collection }

function TS2210Collection.Add: TS2210CollectionItem;
begin
  Result := TS2210CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS2210Collection.GetItem(Index: Integer): TS2210CollectionItem;
begin
  Result := TS2210CollectionItem(inherited GetItem(Index));
end;

procedure TS2210Collection.SetItem(Index: Integer;
  Value: TS2210CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS2210CollectionItem }

constructor TS2210CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento      := teS2210;
  FEvtCAT := TEvtCAT.Create(AOwner);
end;

destructor TS2210CollectionItem.Destroy;
begin
  FEvtCAT.Free;
  inherited;
end;

procedure TS2210CollectionItem.setEvtCAT(const Value: TEvtCAT);
begin
  FEvtCAT.Assign(Value);
end;

{ TAtestado }

constructor TAtestado.create;
begin
  FEmitente := TEmitente.Create;
end;

destructor TAtestado.destroy;
begin
  FEmitente.Free;
  inherited;
end;

{ TAgenteCausadorColecao }

function TAgenteCausadorColecao.Add: TAgenteCausadorItem;
begin
  Result := TAgenteCausadorItem(inherited Add);
end;

constructor TAgenteCausadorColecao.Create(AOwner: TPersistent);
begin
  inherited Create(TAgenteCausadorItem);
end;

function TAgenteCausadorColecao.GetItem(
  Index: Integer): TAgenteCausadorItem;
begin
  Result := TAgenteCausadorItem(inherited GetItem(Index));
end;

procedure TAgenteCausadorColecao.SetItem(Index: Integer;
  const Value: TAgenteCausadorItem);
begin
  inherited SetItem(Index, Value);
end;

{ TParteAtingidaColecao }

function TParteAtingidaColecao.Add: TParteAtingidaItem;
begin
  Result := TParteAtingidaItem(inherited Add);
end;

constructor TParteAtingidaColecao.Create(AOwner: TPersistent);
begin
  inherited Create(TParteAtingidaItem);
end;

function TParteAtingidaColecao.GetItem(Index: Integer): TParteAtingidaItem;
begin
  Result := TParteAtingidaItem(inherited GetItem(Index));
end;

procedure TParteAtingidaColecao.SetItem(Index: Integer;
  const Value: TParteAtingidaItem);
begin
  inherited SetItem(Index, Value);
end;

{ TEvtCAT }

constructor TEvtCAT.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento2.Create;
  FIdeRegistrador := TIdeRegistrador.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeTrabalhador := TideTrabalhador2.Create;
  FCat := TCat.Create;
end;

destructor TEvtCAT.destroy;
begin
  FIdeEvento.Free;
  FIdeRegistrador.Free;
  FIdeEmpregador.Free;
  FIdeTrabalhador.Free;
  FCat.Free;
  inherited;
end;

procedure TEvtCAT.GerarAgenteCausador;
var
  iContador: integer;
begin
  for iCOntador:= 0 to self.Cat.AgenteCausador.Count-1 do
  begin
    Gerador.wGrupo('agenteCausador');
      Gerador.wCampo(tcStr, '', 'codAgntCausador  ', 0, 0, 0, self.Cat.AgenteCausador.Items[iContador].codAgntCausador);
    Gerador.wGrupo('/agenteCausador');
  end;
end;

procedure TEvtCAT.GerarAtestado;
begin
  if self.Cat.Atestado.dtAtendimento > 0 then
  begin
    Gerador.wGrupo('atestado');
      Gerador.wCampo(tcStr, '', 'codCNES  ', 0, 0, 0, self.Cat.Atestado.codCNES);
      Gerador.wCampo(tcDat, '', 'dtAtendimento  ', 0, 0, 0, self.Cat.Atestado.dtAtendimento);
      Gerador.wCampo(tcStr, '', 'hrAtendimento  ', 0, 0, 0, self.Cat.Atestado.hrAtendimento);
      Gerador.wCampo(tcStr, '', 'indInternacao  ', 0, 0, 0, eSSimNaoToStr(self.Cat.Atestado.indInternacao));
      Gerador.wCampo(tcStr, '', 'durTrat  ', 0, 0, 0, self.Cat.Atestado.durTrat);
      Gerador.wCampo(tcStr, '', 'indAfast  ', 0, 0, 0, eSSimNaoToStr(self.Cat.Atestado.indAfast));
      Gerador.wCampo(tcStr, '', 'dscLesao  ', 0, 0, 0, self.Cat.Atestado.dscLesao);
      Gerador.wCampo(tcStr, '', 'dscCompLesao  ', 0, 0, 0, self.Cat.Atestado.dscCompLesao);
      Gerador.wCampo(tcStr, '', 'diagProvavel  ', 0, 0, 0, self.Cat.Atestado.diagProvavel);
      Gerador.wCampo(tcStr, '', 'codCID  ', 0, 0, 0, self.Cat.Atestado.codCID);
      Gerador.wCampo(tcStr, '', 'observacao  ', 0, 0, 0, self.Cat.Atestado.observacao);

      gerarEmitente(self.Cat.Atestado.Emitente);
    Gerador.wGrupo('/atestado');
  end;
end;

procedure TEvtCAT.GerarCAT;
begin
  Gerador.wGrupo('cat');
    Gerador.wCampo(tcDat, '', 'dtAcid', 0, 0, 0, self.Cat.dtAcid);
    Gerador.wCampo(tcStr, '', 'tpAcid', 0, 0, 0, self.Cat.tpAcid);
    Gerador.wCampo(tcStr, '', 'hrAcid', 0, 0, 0, self.Cat.hrAcid);
    Gerador.wCampo(tcStr, '', 'hrsTrabAntesAcid', 0, 0, 0, self.Cat.hrsTrabAntesAcid);
    Gerador.wCampo(tcStr, '', 'tpCat', 0, 0, 0, eSTpCatToStr(self.Cat.tpCat));
    Gerador.wCampo(tcStr, '', 'indCatObito', 0, 0, 0, eSSimNaoToStr(self.Cat.indCatObito));
    Gerador.wCampo(tcDat, '', 'dtObito', 0, 0, 0, self.Cat.dtOBito);
    Gerador.wCampo(tcStr, '', 'indComunPolicia', 0, 0, 0, eSSimNaoToStr(self.Cat.indComunPolicia));
    Gerador.wCampo(tcStr, '', 'codSitGeradora', 0, 0, 0, self.Cat.codSitGeradora);
    Gerador.wCampo(tcStr, '', 'iniciatCAT', 0, 0, 0, eSIniciatCATToStr(self.Cat.iniciatCAT));
    Gerador.wCampo(tcStr, '', 'observacao', 0, 0, 0, self.Cat.observacao);

    GerarLocalAcidente;
    GerarParteAtingida;
    GerarAgenteCausador;
    GerarAtestado;
    GerarCatOrigem;
  Gerador.wGrupo('/cat');
end;

procedure TEvtCAT.GerarCatOrigem;
begin
  if self.Cat.CatOrigem.dtCatOrig > 0 then
  begin
    Gerador.wGrupo('catOrigem');
      Gerador.wCampo(tcDat, '', 'dtCatOrig', 0, 0, 0, self.Cat.CatOrigem.dtCatOrig);
      Gerador.wCampo(tcStr, '', 'nrCatOrig', 0, 0, 0, self.Cat.CatOrigem.nrCatOrig);
    Gerador.wGrupo('/catOrigem');
  end;
end;

procedure TEvtCAT.GerarIdeRegistrador;
begin
  Gerador.wGrupo('ideRegistrador');
    Gerador.wCampo(tcStr, '', 'tpRegistrador', 0, 0, 0, eSTpRegistradorToStr(self.ideRegistrador.tpRegistrador));
    Gerador.wCampo(tcStr, '', 'tpInsc', 0, 0, 0, eSTpInscricaoToStr(self.ideRegistrador.tpInsc));
    Gerador.wCampo(tcStr, '', 'nrInsc', 0, 0, 0, self.ideRegistrador.nrInsc);
  Gerador.wGrupo('/ideRegistrador');
end;

procedure TEvtCAT.GerarLocalAcidente;
begin
  Gerador.wGrupo('localAcidente');
    Gerador.wCampo(tcStr, '', 'tpLocal', 0, 0, 0, eSTpLocalToStr(self.Cat.LocalAcidente.tpLocal));
    Gerador.wCampo(tcStr, '', 'dscLocal', 0, 0, 0, self.Cat.LocalAcidente.dscLocal);
    Gerador.wCampo(tcStr, '', 'dscLograd', 0, 0, 0, self.Cat.LocalAcidente.dscLograd);
    Gerador.wCampo(tcStr, '', 'nrLograd', 0, 0, 0, self.Cat.LocalAcidente.nrLograd);
    Gerador.wCampo(tcStr, '', 'codMunic', 0, 0, 0, self.Cat.LocalAcidente.codMunic);
    Gerador.wCampo(tcStr, '', 'uf', 0, 0, 0, eSufToStr(self.Cat.LocalAcidente.uf));
    Gerador.wCampo(tcStr, '', 'cnpjLocalAcid', 0, 0, 0, self.Cat.LocalAcidente.cnpjLocalAcid);
    Gerador.wCampo(tcStr, '', 'pais', 0, 0, 0, self.Cat.LocalAcidente.pais);
    Gerador.wCampo(tcStr, '', 'codPostal', 0, 0, 0, self.Cat.LocalAcidente.codPostal);
  Gerador.wGrupo('/localAcidente');
end;

procedure TEvtCAT.GerarParteAtingida;
var
  iContador: integer;
begin
  for iCOntador:= 0 to self.Cat.ParteAtingida.Count-1 do
  begin
    Gerador.wGrupo('parteAtingida');
      Gerador.wCampo(tcStr, '', 'codParteAting  ', 0, 0, 0, self.Cat.ParteAtingida.Items[iContador].codParteAting);
      Gerador.wCampo(tcStr, '', 'lateralidade  ', 0, 0, 0, eSLateralidadeToStr(self.Cat.ParteAtingida.Items[iContador].lateralidade));
    Gerador.wGrupo('/parteAtingida');
  end;
end;

function TEvtCAT.GerarXML: boolean;
begin
  try
    GerarCabecalho('evtCAT');
      Gerador.wGrupo('evtCAT Id="'+GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0)+'"');
        //gerarIdVersao(self);
        gerarIdeEvento2(self.IdeEvento);
        GerarIdeRegistrador;
        gerarIdeEmpregador(self.IdeEmpregador);
        gerarIdeTrabalhador2(self.IdeTrabalhador, True);
        GerarCAT;
      Gerador.wGrupo('/evtCAT');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtCAT');
    Validar('evtCAT');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

{ TCat }

constructor TCat.create;
begin
  inherited;
  FLocalAcidente := TLocalAcidente.Create;
  FParteAtingida := TParteAtingidaColecao.Create(self);
  FAgenteCausador := TAgenteCausadorColecao.Create(self);
  FAtestado := TAtestado.Create;
  FCatOrigem := TCatOrigem.Create;
end;

destructor TCat.destroy;
begin
  FLocalAcidente.Free;
  FParteAtingida.Free;
  FAgenteCausador.Free;
  FAtestado.Free;
  FCatOrigem.Free;
  inherited;
end;

end.
