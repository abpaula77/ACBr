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
|*  - Altera��es para valida��o com o XSD
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S2230;

interface

uses
  SysUtils, Classes,
  pcnConversao,
  eSocial_Common, eSocial_Conversao, eSocial_Consts, eSocial_Gerador;

type
  TS2230Collection = class;
  TS2230CollectionItem = class;
  TEvtAfastTemp = class;
  TinfoAfastamento = class;
  TiniAfastamento = class;
  TaltAfastamento = class;
  TAltEmpr = class;
  TfimAfastamento = class;
  TinfoAtestado = class;
  TinfoAtestadoItem = class;
  TinfoCessao = class;
  TinfoMandSind = class;

  TS2230Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS2230CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2230CollectionItem);
  public
    function Add: TS2230CollectionItem;
    property Items[Index: Integer]: TS2230CollectionItem read GetItem write SetItem; default;
  end;

  TS2230CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtAfastTemp: TEvtAfastTemp;

    procedure setEvtAfastTemp(const Value: TEvtAfastTemp);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtAfastTemp: TEvtAfastTemp read FEvtAfastTemp write setEvtAfastTemp;
  end;

  TEvtAfastTemp = class(TeSocialEvento)
    private
      FIdeEvento : TIdeEvento2;
      FIdeEmpregador : TIdeEmpregador;
      FIdeVinculo : TIdeVinculo;
      FinfoAfastamento : TinfoAfastamento;

      procedure GerarInfoAfastamento(objInfoAfast: TinfoAfastamento);
      procedure GerarInfoAtestado(objInfoAtestado: TinfoAtestado);
      procedure GerarInfoCessao(objInfoCessao: TinfoCessao);
      procedure GerarInfoMandSind(objInfoMandSind: TInfoMandSind);
      procedure GerarAltAfast(objAltAfast: TaltAfastamento);
      procedure GerarAltEmpr(pAltEmpr: TAltEmpr);
      procedure GerarFimAfast(objFimAfast: TfimAfastamento);
    public
      constructor Create(AACBreSocial: TObject);overload;
      destructor  Destroy; override;

      function GerarXML: boolean; override;

      property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
      property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
      property IdeVinculo: TIdeVinculo read FIdeVinculo write FIdeVinculo;
      property infoAfastamento: TinfoAfastamento read FinfoAfastamento write FinfoAfastamento;
  end;

  TinfoAfastamento = class(TPersistent)
    private
      FiniAfastamento : TiniAfastamento;
      FaltAfastamento : TaltAfastamento;
      FfimAfastamento : TfimAfastamento;
    public
      constructor create;
      destructor  destroy; override;

      property iniAfastamento: TiniAfastamento read FiniAfastamento write FiniAfastamento;
      property altAfastamento: TaltAfastamento read FaltAfastamento write FaltAfastamento;
      property fimAfastamento: TfimAfastamento read FfimAfastamento write FfimAfastamento;
  end;

  tiniAfastamento = class(TAfastamento)
    private
      FInfoMesmoMtv: tpSimNao;
      FtpAcidTransito: tpTpAcidTransito;
      FObservacao: String;
      FinfoAtestado: TinfoAtestado;
      FinfoCessao: TinfoCessao;
      FinfoMandSind: TinfoMandSind;

      function getInfoAtestado: TinfoAtestado;
    public
      constructor create;
      destructor  destroy; override;

      function infoAtestadoInst: boolean;

      property infoMesmoMtv: tpSimNao read FInfoMesmoMtv write FInfoMesmoMtv;
      property tpAcidTransito: tpTpAcidTransito read FtpAcidTransito write FtpAcidTransito;
      property Observacao: String read FObservacao write FObservacao;
      property infoAtestado: TinfoAtestado read getInfoAtestado write FinfoAtestado;
      property infoCessao: TinfoCessao read FinfoCessao write FinfoCessao;
      property infoMandSind : TinfoMandSind read FinfoMandSind write FinfoMandSind;
  end;

  TinfoAtestado = class(TCollection)
  private
    function GetItem(Index: Integer): TinfoAtestadoItem;
    procedure SetItem(Index: Integer; Value: TinfoAtestadoItem);
  public
    constructor create(); reintroduce;
    function Add: TinfoAtestadoItem;
    property Items[Index: Integer]: TinfoAtestadoItem read GetItem write SetItem; default;
  end;

  TinfoAtestadoItem = class(TCollectionItem)
    private
      FcodCID : String;
      FqtDiasAfast : Integer;
      FEmitente : TEmitente;

      function getEmitente: TEmitente;
    public
      constructor create;
      destructor  destroy; override;

      function emitenteInst: boolean;

      property codCID: String read FCodCId write FcodCID;
      property qtDiasAfast: Integer read FqtDiasAfast write FqtDiasAfast;
      property Emitente: TEmitente read getEmitente write FEmitente;
  end;

  TinfoCessao = class(TPersistent)
    private
      FcnpjCess : String;
      FinfOnus : tpInfOnus;
    public
      property cnpjCess: String read FcnpjCess write FcnpjCess;
      property infOnus: tpInfOnus read FinfOnus write FinfOnus;
  end;

  TinfoMandSind = class(TPersistent)
    private
      FcnpjSind : String;
      FinfOnusRemun: tpOnusRemun;
    public
      property cnpjSind: String read FcnpjSind write FcnpjSind;
      property infOnusRemun: tpOnusRemun read FinfOnusRemun write FinfOnusRemun;
  end;

  TAltEmpr = class(TPersistent)
  private
    FCodCID: string;
    FQtdDiasAfast: Integer;
    FNmEmit: string;
    FIdeOC: tpIdeOC;
    FNrOc: string;
    FUfOc: tpuf;
  public
    property codCID: String read FCodCID write FCodCID;
    property qtdDiasAfast: integer read FQtdDiasAfast write FQtdDiasAfast;
    property nmEmit: string read FNmEmit write FNmEmit;
    property ideOC: tpIdeOC read FIdeOC write FIdeOC;
    property nrOc: String read FNrOc write FNrOc;
    property ufOC: tpuf read FUfOc write FUfOc;
  end;

  TaltAfastamento = class(TPersistent) //altera��o do motivo do afastamento
    private
      FdtAltMot: TDateTime;
      FcodMotAnt : String;
      FcodMotAfast: String;
      FInfoMesmoMtv: tpSimNao;
      FindEfRetroativo: tpSimNao;
      FOrigAlt: tpOrigemAltAfast;
      FNrProcJud: string;
      FAltEmpr: TAltEmpr;

      function getAltEmpr: TAltEmpr;
    public
      constructor Create; reintroduce;
      destructor Destroy; override;
      function altEmprInst: boolean;

      property dtAltMot: TDateTime read FdtAltMot write FdtAltMot;
      property codMotAnt: String read FcodMotAnt write FcodMotAnt;
      property codMotAfast: String read FcodMotAfast write FcodMotAfast;
      property infoMesmoMtv: tpSimNao read FInfoMesmoMtv write FInfoMesmoMtv;
      property indEfRetroativo: tpSimNao read FindEfRetroativo write FindEfRetroativo;
      property origAlt: tpOrigemAltAfast read FOrigAlt write FOrigAlt;
      property nrProcJud: string read FNrProcJud write FNrProcJud;
      property altEmpr: TAltEmpr read getAltEmpr write FAltEmpr;
  end;

  TfimAfastamento = class(TPersistent)
    private
      FdtTermAfast : TDateTime;
      FcodMotAfast : String;
      FInfoMesmoMtv  : tpSimNao;
    public
      property dtTermAfast: TDateTime read FdtTermAfast write FdtTermAfast;
      property codMotAfast: String read FcodMotAfast write FcodMotAfast;
      property infoMesmoMtv: tpSimNao read FInfoMesmoMtv write FInfoMesmoMtv;
  end;


implementation

uses
  eSocial_NaoPeriodicos;

{ TS2230Collection }

function TS2230Collection.Add: TS2230CollectionItem;
begin
  Result := TS2230CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS2230Collection.GetItem(Index: Integer): TS2230CollectionItem;
begin
  Result := TS2230CollectionItem(inherited GetItem(Index));
end;

procedure TS2230Collection.SetItem(Index: Integer; Value: TS2230CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS2230CollectionItem }

constructor TS2230CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS2230;
  FEvtAfastTemp := TEvtAfastTemp.Create(AOwner);
end;

destructor TS2230CollectionItem.Destroy;
begin
  FEvtAfastTemp.Free;
  inherited;
end;

procedure TS2230CollectionItem.setEvtAfastTemp(const Value: TEvtAfastTemp);
begin
  FEvtAfastTemp.Assign(Value);
end;

{ TEvtAfastTemp }

constructor TEvtAfastTemp.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento2.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeVinculo := TIdeVinculo.Create;
  FinfoAfastamento := TinfoAfastamento.Create;
end;

destructor TEvtAfastTemp.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FideVinculo.Free;
  FinfoAfastamento.Free;
  inherited;
end;

procedure TEvtAfastTemp.GerarInfoAfastamento(objInfoAfast: TinfoAfastamento);
begin
  Gerador.wGrupo('infoAfastamento');
    Gerador.wGrupo('iniAfastamento');
      Gerador.wCampo(tcDat, '', 'dtIniAfast', 0,0,0, objInfoAfast.iniAfastamento.DtIniAfast);
      Gerador.wCampo(tcStr, '', 'codMotAfast', 0,0,0, objInfoAfast.iniAfastamento.codMotAfast);
      Gerador.wCampo(tcStr, '', 'infoMesmoMtv', 0,0,0, eSSimNaoToStr(objInfoAfast.iniAfastamento.infoMesmoMtv));
      Gerador.wCampo(tcStr, '', 'tpAcidTransito', 0,0,0, objInfoAfast.iniAfastamento.tpAcidTransito);
      Gerador.wCampo(tcStr, '', 'observacao', 0,0,0, objInfoAfast.iniAfastamento.Observacao);
      if objInfoAfast.iniAfastamento.infoAtestadoInst then
        GerarInfoAtestado(objInfoAfast.iniAfastamento.infoAtestado);
      if Assigned(objInfoAfast.iniAfastamento.infoCessao) then
        GerarInfoCessao(objInfoAfast.iniAfastamento.infoCessao);
      if Assigned(objInfoAfast.iniAfastamento.infoMandSind) then
        GerarInfoMandSind(objInfoAfast.iniAfastamento.infoMandSind);
    Gerador.wGrupo('/iniAfastamento');
    GerarAltAfast(objInfoAfast.altAfastamento);
    GerarFimAfast(objInfoAfast.fimAfastamento);
  Gerador.wGrupo('/infoAfastamento');
end;

procedure TEvtAfastTemp.GerarInfoAtestado(objInfoAtestado: TinfoAtestado);
var
  i: Integer;
begin
  for i := 0 to objInfoAtestado.Count - 1 do
  begin
    Gerador.wGrupo('infoAtestado');
      Gerador.wCampo(tcStr, '', 'codCID', 0,0,0, objInfoAtestado[i].codCID);
      Gerador.wCampo(tcInt, '', 'qtdDiasAfast', 0,0,0, objInfoAtestado[i].qtDiasAfast);
      if objInfoAtestado[i].emitenteInst then
        gerarEmitente(objInfoAtestado[i].Emitente);
    Gerador.wGrupo('/infoAtestado');
  end;
end;

procedure TEvtAfastTemp.GerarInfoCessao(objInfoCessao: TinfoCessao);
begin
  if objInfoCessao.cnpjCess <> EmptyStr then
  begin
    Gerador.wGrupo('infoCessao');
      Gerador.wCampo(tcStr, '', 'cnpjCess', 0,0,0, objInfoCessao.cnpjCess);
      Gerador.wCampo(tcStr, '', 'infOnus', 0,0,0, objInfoCessao.infOnus);
    Gerador.wGrupo('/infoCessao');
  end;
end;

procedure TEvtAfastTemp.GerarInfoMandSind(objInfoMandSind: TInfoMandSind);
begin
  if objInfoMandSind.cnpjSind <> '' then
  begin
    Gerador.wGrupo('infoMandSind');
      Gerador.wCampo(tcStr, '', 'cnpjSind', 0,0,0, objInfoMandSind.cnpjSind);
      Gerador.wCampo(tcStr, '', 'infOnusRemun', 0,0,0, objInfoMandSind.infOnusRemun);
    Gerador.wGrupo('/infoMandSind');
  end;
end;

function TEvtAfastTemp.GerarXML: boolean;
begin
  try
    GerarCabecalho('evtAfastTemp');
      Gerador.wGrupo('evtAfastTemp Id="'+GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0)+'"');
        //gerarIdVersao(self);
        gerarIdeEvento2(self.IdeEvento);
        gerarIdeEmpregador(self.IdeEmpregador);
        gerarIdeVinculo(self.IdeVinculo);
        GerarInfoAfastamento(FinfoAfastamento);
      Gerador.wGrupo('/evtAfastTemp');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtAfastTemp');
    Validar('evtAfastTemp');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

procedure TEvtAfastTemp.GerarAltEmpr(pAltEmpr: TAltEmpr);
begin
  Gerador.wGrupo('altEmpr');
    Gerador.wCampo(tcStr, '', 'codCID', 0,0,0, pAltEmpr.codCID);
    Gerador.wCampo(tcInt, '', 'qtdDiasAfast', 0,0,0, pAltEmpr.qtdDiasAfast);
    Gerador.wCampo(tcStr, '', 'nmEmit', 0,0,0, pAltEmpr.nmEmit);
    Gerador.wCampo(tcInt, '', 'ideOC', 0,0,0, eSIdeOCToStr(pAltEmpr.ideOC));
    Gerador.wCampo(tcStr, '', 'nrOc', 0,0,0, pAltEmpr.nrOc);
    Gerador.wCampo(tcStr, '', 'ufOC', 0,0,0, eSufToStr(pAltEmpr.ufOC));
  Gerador.wGrupo('/altEmpr');
end;

procedure TEvtAfastTemp.GerarAltAfast(objAltAfast: TaltAfastamento);
begin
  if (Assigned(objAltAfast)) then
  begin
    if objAltAfast.dtAltMot > 0 then
    begin
      Gerador.wGrupo('altAfastamento');
        Gerador.wCampo(tcDat, '', 'dtAltMot', 0,0,0, objAltAfast.dtAltMot);
        Gerador.wCampo(tcStr, '', 'codMotAnt', 0,0,0, objAltAfast.codMotAnt);
        Gerador.wCampo(tcStr, '', 'codMotAfast', 0,0,0, objAltAfast.codMotAfast);
        Gerador.wCampo(tcStr, '', 'infoMesmoMtv', 0,0,0, eSSimNaoToStr(objAltAfast.infoMesmoMtv));
        Gerador.wCampo(tcStr, '', 'indEfRetroativo', 0,0,0, eSSimNaoToStr(objAltAfast.indEfRetroativo));
        Gerador.wCampo(tcInt, '', 'origAlt', 0,0,0, eSTpOrigemAltAfastToStr(objAltAfast.origAlt));
        Gerador.wCampo(tcStr, '', 'nrProcJud', 0,0,0, objAltAfast.nrProcJud);
        if objAltAfast.altEmprInst then
          GerarAltEmpr(objAltAfast.altEmpr);
      Gerador.wGrupo('/altAfastamento');
    end;
  end;
end;

procedure TEvtAfastTemp.GerarFimAfast(objFimAfast: TfimAfastamento);
begin
  if (Assigned(objFimAfast)) then
    begin
      if objFimAfast.dtTermAfast > 0 then
      begin
        Gerador.wGrupo('fimAfastamento');
          Gerador.wCampo(tcDat, '', 'dtTermAfast', 0,0,0, objFimAfast.dtTermAfast);
          Gerador.wCampo(tcStr, '', 'codMotAfast', 0,0,0, objFimAfast.codMotAfast);
          Gerador.wCampo(tcStr, '', 'infoMesmoMtv', 0,0,0, eSSimNaoToStr(objFimAfast.infoMesmoMtv));
        Gerador.wGrupo('/fimAfastamento');
      end;
    end;
end;

{ TinfoAfastamento }

constructor TinfoAfastamento.create;
begin
  inherited;
  FiniAfastamento := TiniAfastamento.Create;
  FaltAfastamento := TaltAfastamento.Create;
  FfimAfastamento := TfimAfastamento.Create;
end;

destructor TinfoAfastamento.destroy;
begin
   FiniAfastamento.Free;
   FaltAfastamento.Free;
   FfimAfastamento.Free;
   inherited;
end;

{ tiniAfastamento }

constructor tiniAfastamento.create;
begin
  inherited;
  FinfoAtestado := nil;
  FinfoCessao := TinfoCessao.Create;
  FinfoMandSind := TinfoMandSind.Create;
end;

destructor tiniAfastamento.destroy;
begin
  FreeAndNil(FInfoAtestado);
  FinfoCessao.Free;
  FinfoMandSind.Free;
  inherited;
end;

function tiniAfastamento.getInfoAtestado: TinfoAtestado;
begin
  if not Assigned(FinfoAtestado) then
    FinfoAtestado := TinfoAtestado.create;
  Result := FinfoAtestado;
end;

function tiniAfastamento.infoAtestadoInst: boolean;
begin
  result := Assigned(FinfoAtestado);
end;

{ TinfoAtestado }

function TinfoAtestado.Add: TinfoAtestadoItem;
begin
  Result := TinfoAtestadoItem(inherited add());
  Result.Create;
end;

constructor TinfoAtestado.create;
begin
  Inherited create(TinfoAtestadoItem);
end;

function TinfoAtestado.GetItem(
  Index: Integer): TinfoAtestadoItem;
begin
  Result := TinfoAtestadoItem(inherited GetItem(Index));
end;

procedure TinfoAtestado.SetItem(Index: Integer;
  Value: TinfoAtestadoItem);
begin
  inherited SetItem(Index, Value);
end;

{ TinfoAtestadoItem }

constructor TinfoAtestadoItem.create;
begin
  FEmitente := nil;
end;

destructor TinfoAtestadoItem.destroy;
begin
  FreeAndNil(FEmitente);
  inherited;
end;

function TinfoAtestadoItem.getEmitente: TEmitente;
begin
  if not assigned(FEmitente) then
    FEmitente := TEmitente.Create;
  Result := FEmitente;
end;

function TinfoAtestadoItem.emitenteInst: boolean;
begin
  result := Assigned(FEmitente);
end;

{ TaltAfastamento }

constructor TaltAfastamento.Create;
begin
  inherited;
  FAltEmpr := nil;
end;

destructor TaltAfastamento.Destroy;
begin
  FreeAndNil(FAltEmpr);
  inherited;
end;

function TaltAfastamento.getAltEmpr: TAltEmpr;
begin
  if not Assigned(FAltEmpr) then
    FAltEmpr := TAltEmpr.Create;
  Result := FAltEmpr;
end;

function TaltAfastamento.altEmprInst: boolean;
begin
  result := Assigned(FAltEmpr);
end;

end.
