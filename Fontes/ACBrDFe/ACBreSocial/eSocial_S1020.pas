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
|*  - Passado o namespace para gera��o no cabe�alho
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S1020;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS1020Collection = class;
  TS1020CollectionItem = class;
  TevtTabLotacao = class;
  TIdeLotacao = class;
  TFPasLotacao = class;
  TInfoEmprParcial = class;
  TDadosLotacao = class;
  TInfoLotacao = class;
  TProcJudTerceiroCollectionItem = class;
  TProcJudTerceiroCollection = class;
  TInfoProcJudTerceiros = class;

  TS1020Collection = class(TOwnedCollection)
   private
    function GetItem(Index: Integer): TS1020CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1020CollectionItem);
  public
    function Add: TS1020CollectionItem;
    property Items[Index: Integer]: TS1020CollectionItem read GetItem write SetItem; default;
  end;

  TS1020CollectionItem = class(TCollectionItem)
   private
    FTipoEvento: TTipoEvento;
    FEvtTabLotacao: TevtTabLotacao;
    procedure setevtTabLotacao(const Value: TevtTabLotacao);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtTabLotacao: TevtTabLotacao read FEvtTabLotacao write setevtTabLotacao;
  end;

  TInfoProcJudTerceiros = class(TPersistent)
   private
    FProcJudTerceiro: TProcJudTerceiroCollection;
  public
    constructor create;
    destructor Destroy; override;

    property procJudTerceiro: TProcJudTerceiroCollection read FProcJudTerceiro write FProcJudTerceiro;
  end;

  TProcJudTerceiroCollection = class(TCollection)
   private
    function GetItem(Index: Integer): TProcJudTerceiroCollectionItem;
    procedure SetItem(Index: Integer; Value: TProcJudTerceiroCollectionItem);
  public
    constructor create(); reintroduce;

    function Add: TProcJudTerceiroCollectionItem;
    property Items[Index: Integer]: TProcJudTerceiroCollectionItem read GetItem write SetItem; 
  end;

  TProcJudTerceiroCollectionItem = class(TProcesso)
   private
    FCodTerc: string;
  public
    constructor create; reintroduce;

    property codTerc: string read FCodTerc write FCodTerc;
    property nrProcJud: string read FNrProc write FNrProc;
  end;

  TevtTabLotacao = class(TeSocialEvento)
   private
    FModoLancamento: TModoLancamento;
    fIdeEvento: TIdeEvento;
    fIdeEmpregador: TIdeEmpregador;
    fInfoLotacao: TInfoLotacao;

    {Geradores espec�ficos da classe}
    procedure gerarIdeLotacao();    
    procedure gerarInfoEmprParcial();
    procedure gerarInfoProcJudTerceiros();
    procedure gerarFPasLotacao();
    procedure gerarDadosLotacao();
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor Destroy; override;

    function GerarXML: boolean; override;

    property ModoLancamento: TModoLancamento read FModoLancamento write FModoLancamento;
    property IdeEvento: TIdeEvento read FIdeEvento write FIdeEvento;
    property ideEmpregador: TIdeEmpregador read FideEmpregador write FideEmpregador;
    property infoLotacao: TInfoLotacao read fInfoLotacao write fInfoLotacao;
  end;

  TIdeLotacao = class(TPersistent)
   private
    FCodLotacao: string;
    FIniValid: string;
    FFimValid: string;
  public
    property codLotacao: string read fCodLotacao write fCodLotacao;
    property iniValid: string read FIniValid write FIniValid;
    property fimValid: string read FFimValid write FFimValid;
  end;

  TFPasLotacao = class(TPersistent)
   private
    fFpas: string;
    FCodTercs: string;
    FCodTercsSusp: string;
    FInfoProcJudTerceiros: TInfoProcJudTerceiros;
    function getInfoProcJudTerceiros(): TInfoProcJudTerceiros;
  public
    constructor create;
    destructor Destroy; override;
    function infoProcJudTerceirosInst(): Boolean;

    property Fpas: string read fFpas write fFpas;
    property codTercs: string read FCodTercs write FCodTercs;
    property codTercsSusp: string read FCodTercsSusp write FCodTercsSusp;
    property infoProcJudTerceiros: TInfoProcJudTerceiros read getInfoProcJudTerceiros write FInfoProcJudTerceiros;
  end;

  TInfoEmprParcial = class(TPersistent)
   private
    FTpInscContrat: TptpInscContratante;
    FNrInscContrat: string;
    FTpInscProp: TpTpInscProp;
    FNrInscProp: string;
  public
    property tpInscContrat: TptpInscContratante read FTpInscContrat write FTpInscContrat;
    property NrInscContrat: string read FNrInscContrat write FNrInscContrat;
    property tpInscProp: TpTpInscProp read FTpInscProp write FTpInscProp;
    property nrInscProp: string read FNrInscProp write FNrInscProp;
  end;

  TDadosLotacao = class(TPersistent)
   private
    FTpLotacao: string;
    FTpInsc: tpTpInsc;
    FNrInsc: string;   
    fFPasLotacao: TFPasLotacao;
    fInfoEmprParcial: TinfoEmprParcial;
  public
    constructor create;
    destructor Destroy; override;
    property tpLotacao: string read FTpLotacao write FTpLotacao;
    property tpInsc: tpTpInsc read FTpInsc write FTpInsc;
    property nrInsc: string read FNrInsc write FNrInsc;
    property fPasLotacao: TFPasLotacao read ffPasLotacao write ffPasLotacao;
    property infoEmprParcial: TInfoEmprParcial read fInfoEmprParcial write fInfoEmprParcial;
  end;

  TInfoLotacao = class(TPersistent)
   private
    fIdeLotacao: TIdeLotacao;
    fDadosLotacao: TDadosLotacao;
    fNovaValidade: TidePeriodo;
    function getDadosLotacao(): TDadosLotacao;
    function getNovaValidade(): TIdePeriodo;
  public
    constructor create;
    destructor Destroy; override;
    function ideLotacaoInst(): Boolean;
    function dadosLotacaoInst(): Boolean;
    function novaValidadeInst(): Boolean;

    property ideLotacao: TIdeLotacao read fIdeLotacao write fIdeLotacao;
    property dadosLotacao: TDadosLotacao read getDadosLotacao write fDadosLotacao;
    property novaValidade: TidePeriodo read getNovaValidade write fNovaValidade;
  end;

implementation

uses
  eSocial_Tabelas;

{ TS1020Collection }

function TS1020Collection.Add: TS1020CollectionItem;
begin
  Result := TS1020CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1020Collection.GetItem(Index: Integer): TS1020CollectionItem;
begin
  Result := TS1020CollectionItem(inherited GetItem(Index));
end;

procedure TS1020Collection.SetItem(Index: Integer;
  Value: TS1020CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS1020CollectionItem }

constructor TS1020CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1020;
  FEvtTabLotacao := TevtTabLotacao.Create(AOwner);
end;

destructor TS1020CollectionItem.Destroy;
begin
  FEvtTabLotacao.Free;
  inherited;
end;

procedure TS1020CollectionItem.setevtTabLotacao(
  const Value: TevtTabLotacao);
begin
  FEvtTabLotacao.Assign(Value);
end;

{ TevtTabLotacao }

constructor TevtTabLotacao.Create(AACBreSocial: TObject);
begin
  inherited;
  fIdeEvento := TIdeEvento.Create;
  fIdeEmpregador := TIdeEmpregador.Create;
  fInfoLotacao := TInfoLotacao.Create;
end;

destructor TevtTabLotacao.destroy;
begin
  fIdeEvento.Free;
  fIdeEmpregador.Free;
  fInfoLotacao.Free;
  inherited;
end;

procedure TevtTabLotacao.gerarDadosLotacao;
begin
  Gerador.wGrupo('dadosLotacao');
    Gerador.wCampo(tcStr, '', 'tpLotacao', 0, 0, 0, self.infoLotacao.DadosLotacao.tpLotacao);

    if (StrToInt(self.infoLotacao.DadosLotacao.tpLotacao) in [3, 4, 5, 6, 8, 9, 21, 23]) then
      Gerador.wCampo(tcStr, '', 'tpInsc', 0, 0, 0, ord(self.infoLotacao.DadosLotacao.tpInsc) + 1);

    Gerador.wCampo(tcStr, '', 'nrInsc', 0, 0, 0, self.infoLotacao.DadosLotacao.nrInsc);    
    gerarFPasLotacao();
    gerarInfoEmprParcial();
  Gerador.wGrupo('/dadosLotacao');
end;

procedure TevtTabLotacao.gerarFPasLotacao;
begin
  Gerador.wGrupo('fpasLotacao');
    Gerador.wCampo(tcStr, '', 'fpas', 0, 0, 0, self.infoLotacao.DadosLotacao.fPasLotacao.Fpas);
    Gerador.wCampo(tcStr, '', 'codTercs', 0, 0, 0, self.infoLotacao.DadosLotacao.fPasLotacao.codTercs);
    if self.infoLotacao.DadosLotacao.fPasLotacao.codTercsSusp <> '' then
      Gerador.wCampo(tcStr, '', 'codTercsSusp', 0, 0, 0, self.infoLotacao.DadosLotacao.fPasLotacao.codTercsSusp);
    gerarInfoProcJudTerceiros();
  Gerador.wGrupo('/fpasLotacao');
end;

procedure TevtTabLotacao.gerarIdeLotacao;
begin
  Gerador.wGrupo('ideLotacao');
    Gerador.wCampo(tcStr, '', 'codLotacao', 0, 0, 0, self.infoLotacao.IdeLotacao.codLotacao);
    Gerador.wCampo(tcStr, '', 'iniValid', 0, 0, 0, self.infoLotacao.IdeLotacao.iniValid);
    Gerador.wCampo(tcStr, '', 'fimValid', 0, 0, 0, self.infoLotacao.IdeLotacao.fimValid);
  Gerador.wGrupo('/ideLotacao');
end;

procedure TevtTabLotacao.gerarInfoEmprParcial;
begin
  if infoLotacao.DadosLotacao.InfoEmprParcial.nrInscContrat <> '' then
  begin
    Gerador.wGrupo('infoEmprParcial');
      Gerador.wCampo(tcStr, '', 'tpInscContrat', 0, 0, 0, eStpInscContratanteToStr(infoLotacao.DadosLotacao.InfoEmprParcial.tpInscContrat));
      Gerador.wCampo(tcStr, '', 'nrInscContrat', 0, 0, 0, infoLotacao.DadosLotacao.InfoEmprParcial.nrInscContrat);
      Gerador.wCampo(tcStr, '', 'tpInscProp', 0, 0, 0, eSTpInscPropToStr(infoLotacao.DadosLotacao.InfoEmprParcial.tpInscProp));
      Gerador.wCampo(tcStr, '', 'nrInscProp', 0, 0, 0, infoLotacao.DadosLotacao.InfoEmprParcial.nrInscProp);
    Gerador.wGrupo('/infoEmprParcial');
  end;
end;

procedure TevtTabLotacao.gerarInfoProcJudTerceiros;
  var
      iInfoProcJudTerceiros: Integer;
      objProcJudTer: TProcJudTerceiroCollectionItem;
begin
  if (infoLotacao.dadosLotacao.fPasLotacao.infoProcJudTerceiros.procJudTerceiro.Count > 0) then
  begin
    objProcJudTer := infoLotacao.dadosLotacao.fPasLotacao.infoProcJudTerceiros.procJudTerceiro.Items[0];
    if objProcJudTer.codTerc <> EmptyStr then
    begin
      Gerador.wGrupo('infoProcJudTerceiros');
      for iInfoProcJudTerceiros := 1 to infoLotacao.dadosLotacao.fPasLotacao.infoProcJudTerceiros.procJudTerceiro.Count - 1 do
      begin
        objProcJudTer := infoLotacao.dadosLotacao.fPasLotacao.infoProcJudTerceiros.procJudTerceiro.Items[iInfoProcJudTerceiros];
        Gerador.wGrupo('procJudTerceiro');
          Gerador.wCampo(tcStr, '', 'codTerc', 0, 0, 0, objProcJudTer.codTerc);
          Gerador.wCampo(tcStr, '', 'nrProcJud', 0, 0, 0, objProcJudTer.nrProcJud);
          if trim(objProcJudTer.codSusp) <> '' then
            Gerador.wCampo(tcInt, '', 'codSusp', 0, 0, 0, objProcJudTer.codSusp);
        Gerador.wGrupo('/procJudTerceiro');
      end;
      Gerador.wGrupo('/infoProcJudTerceiros');
    end;
  end;
end;

function TevtTabLotacao.GerarXML: boolean;
begin
  try
    gerarCabecalho('evtTabLotacao');
      Gerador.wGrupo('evtTabLotacao Id="'+ GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0) +'"');
      //gerarIdVersao(self);
      gerarIdeEvento(self.IdeEvento);
      gerarIdeEmpregador(self.ideEmpregador);
      Gerador.wGrupo('infoLotacao');
        gerarModoAbertura(Self.ModoLancamento);
          gerarIdeLotacao;
          if Self.ModoLancamento <> mlExclusao then
          begin            
            gerarDadosLotacao;
            if Self.ModoLancamento = mlAlteracao then
              if (infoLotacao.novaValidadeInst()) then
                GerarIdePeriodo(self.infoLotacao.NovaValidade, 'novaValidade');
          end;
        gerarModoFechamento(ModoLancamento);
      Gerador.wGrupo('/infoLotacao');
    Gerador.wGrupo('/evtTabLotacao');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtTabLotacao');
    Validar('evtTabLotacao');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

{ TDadosLotacao }

constructor TDadosLotacao.create;
begin
  fFPasLotacao := TFPasLotacao.Create;
  fInfoEmprParcial := TinfoEmprParcial.Create;
end;

destructor TDadosLotacao.destroy;
begin
  fFPasLotacao.Free;
  FinfoEmprParcial.Free;
  inherited;
end;

{ TInfoLotacao }

constructor TInfoLotacao.create;
begin
  fIdeLotacao := TIdeLotacao.Create;
  fDadosLotacao := nil;
  fNovaValidade := nil;
end;

function TInfoLotacao.dadosLotacaoInst: Boolean;
begin
  Result := Assigned(fDadosLotacao);
end;

destructor TInfoLotacao.destroy;
begin
  fIdeLotacao.Free;
  FreeAndNil(fDadosLotacao);
  FreeAndNil(fNovaValidade);
  inherited;
end;

function TInfoLotacao.getDadosLotacao: TDadosLotacao;
begin  
  if Not(Assigned(fDadosLotacao)) then
    fDadosLotacao := TDadosLotacao.create;
  Result := fDadosLotacao;
end;

function TInfoLotacao.getNovaValidade: TIdePeriodo;
begin                             
  if Not(Assigned(fNovaValidade)) then
    fNovaValidade := TIdePeriodo.Create;
  Result := fNovaValidade;
end;

function TInfoLotacao.ideLotacaoInst: Boolean;
begin                               
  Result := Assigned(fIdeLotacao);
end;

function TInfoLotacao.novaValidadeInst: Boolean;
begin     
  Result := Assigned(fNovaValidade);
end;

{ TProcJudTerceiroCollectionItem }

constructor TProcJudTerceiroCollectionItem.create;
begin
end;

{ TProcJudTerceiroCollection }

function TProcJudTerceiroCollection.Add: TProcJudTerceiroCollectionItem;
begin
  Result := TProcJudTerceiroCollectionItem(inherited Add());
  Result.Create;
end;

constructor TProcJudTerceiroCollection.create;
begin
  inherited create(TProcJudTerceiroCollectionItem);
end;

function TProcJudTerceiroCollection.GetItem(
  Index: Integer): TProcJudTerceiroCollectionItem;
begin
  Result := TProcJudTerceiroCollectionItem(Inherited GetItem(Index));
end;

procedure TProcJudTerceiroCollection.SetItem(Index: Integer;
  Value: TProcJudTerceiroCollectionItem);
begin
  Inherited SetItem(Index, Value);
end;

{ TInfoProcJudTerceiros }

constructor TInfoProcJudTerceiros.create;
begin
  FProcJudTerceiro := TProcJudTerceiroCollection.create;
  FProcJudTerceiro.Add();
end;

destructor TInfoProcJudTerceiros.destroy;
begin
  FProcJudTerceiro.Free;
  inherited;
end;

{ TFPasLotacao }

constructor TFPasLotacao.create;
begin
  FInfoProcJudTerceiros := nil;
end;

destructor TFPasLotacao.destroy;
begin
  FreeAndNil(FInfoProcJudTerceiros);
  inherited;
end;

function TFPasLotacao.getInfoProcJudTerceiros: TInfoProcJudTerceiros;
begin
  if Not(Assigned(FInfoProcJudTerceiros)) then
    FInfoProcJudTerceiros := TInfoProcJudTerceiros.create;
  Result := FInfoProcJudTerceiros;
end;

function TFPasLotacao.infoProcJudTerceirosInst: Boolean;
begin
  Result := Assigned(FInfoProcJudTerceiros);
end;

end.
