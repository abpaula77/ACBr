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

unit eSocial_S1299;

interface

uses
  SysUtils, Classes,
  pcnConversao,
  eSocial_Common, eSocial_Conversao, eSocial_Gerador;

type
  TS1299Collection = class;
  TS1299CollectionItem = class;
  TEvtFechaEvPer = class;
  TInfoFech= class;

  TS1299Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1299CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1299CollectionItem);
  public
    function Add: TS1299CollectionItem;
    property Items[Index: Integer]: TS1299CollectionItem read GetItem write SetItem; default;
  end;

  TS1299CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtFechaEvPer: TEvtFechaEvPer;
    procedure setEvtFechaEvPer(const Value: TEvtFechaEvPer);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtFechaEvPer: TEvtFechaEvPer read FEvtFechaEvPer write setEvtFechaEvPer;
  end;

  TEvtFechaEvPer = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FIdeRespInf : TIdeRespInf;
    FInfoFech: TInfoFech;

    {Geradores espec�ficos da classe}
    procedure GerarInfoFech;
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;

    property IdeEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeRespInf: TIdeRespInf read FIdeRespInf write FIdeRespInf;
    property InfoFech: TInfoFech read FInfoFech write FInfoFech;
  end;

  TInfoFech = class
  private
    FevtRemun: TpSimNao;
    FevtPgtos: TpSimNao;
    FevtAqProd: TpSimNao;
    FevtComProd: TpSimNao;
    FevtContratAvNP: TpSimNao;
    FevtInfoComplPer: TpSimNao;
    FcompSemMovto : string;
  public
    constructor create;
    destructor destroy; override;

    property evtRemun: TpSimNao read FevtRemun write FevtRemun;
    property evtPgtos: TpSimNao read FevtPgtos write FevtPgtos;
    property evtAqProd: TpSimNao read FevtAqProd write FevtAqProd;
    property evtComProd: TpSimNao read FevtComProd write FevtComProd;
    property evtContratAvNP: TpSimNao read FevtContratAvNP write FevtContratAvNP;
    property evtInfoComplPer: TpSimNao read FevtInfoComplPer write FevtInfoComplPer;
    property compSemMovto : string read FcompSemMovto write FcompSemMovto;
  end;

implementation

uses
  eSocial_Periodicos;

{ TS1299Collection }
function TS1299Collection.Add: TS1299CollectionItem;
begin
  Result := TS1299CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1299Collection.GetItem(Index: Integer): TS1299CollectionItem;
begin
  Result := TS1299CollectionItem(inherited GetItem(Index));
end;

procedure TS1299Collection.SetItem(Index: Integer; Value: TS1299CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{TS1299CollectionItem}
constructor TS1299CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1299;
  FEvtFechaEvPer := TEvtFechaEvPer.Create(AOwner);
end;

destructor TS1299CollectionItem.Destroy;
begin
  FEvtFechaEvPer.Free;
  inherited;
end;

procedure TS1299CollectionItem.setEvtFechaEvPer(const Value: TEvtFechaEvPer);
begin
  FEvtFechaEvPer.Assign(Value);
end;

{ TEvtSolicTotal }
constructor TEvtFechaEvPer.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeRespInf := TIdeRespInf.Create;
  FInfoFech := TInfoFech.Create;
end;

destructor TEvtFechaEvPer.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeRespInf.Free;
  FInfoFech.Free;
  inherited;
end;

procedure TEvtFechaEvPer.GerarInfoFech;
begin
  Gerador.wGrupo('infoFech');
    Gerador.wCampo(tcStr, '', 'evtRemun', 0, 0, 0, eSSimNaoToStr(self.InfoFech.evtRemun));
    Gerador.wCampo(tcStr, '', 'evtPgtos', 0, 0, 0, eSSimNaoToStr(self.InfoFech.evtPgtos));
    Gerador.wCampo(tcStr, '', 'evtAqProd', 0, 0, 0, eSSimNaoToStr(self.InfoFech.evtAqProd));
    Gerador.wCampo(tcStr, '', 'evtComProd', 0, 0, 0, eSSimNaoToStr(self.InfoFech.evtComProd));
    Gerador.wCampo(tcStr, '', 'evtContratAvNP', 0, 0, 0, eSSimNaoToStr(self.InfoFech.evtContratAvNP));
    Gerador.wCampo(tcStr, '', 'evtInfoComplPer', 0, 0, 0, eSSimNaoToStr(self.InfoFech.evtInfoComplPer));

    if ((eSSimNaoToStr(self.InfoFech.evtRemun)        = 'N') and
        (eSSimNaoToStr(self.InfoFech.evtPgtos)        = 'N') and
        (eSSimNaoToStr(self.InfoFech.evtAqProd)       = 'N') and
        (eSSimNaoToStr(self.InfoFech.evtComProd)      = 'N') and
        (eSSimNaoToStr(self.InfoFech.evtContratAvNP)  = 'N') and
        (eSSimNaoToStr(self.InfoFech.evtInfoComplPer) = 'N')) then
      Gerador.wCampo(tcStr, '', 'compSemMovto', 0, 0, 0, self.InfoFech.compSemMovto);
  Gerador.wGrupo('/infoFech');
end;

function TEvtFechaEvPer.GerarXML: boolean;
begin
  try
    GerarCabecalho('evtFechaEvPer');
      Gerador.wGrupo('evtFechaEvPer Id="'+GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0)+'"');
        //gerarIdVersao(self);
        GerarIdeEvento3(self.IdeEvento, False);
        gerarIdeEmpregador(self.IdeEmpregador);
        GerarIdeRespInf(Self.IdeRespInf);
        GerarInfoFech;
      Gerador.wGrupo('/evtFechaEvPer');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtFechaEvPer');
    Validar('evtFechaEvPer');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

{ TInfoFech }

constructor TInfoFech.create;
begin
  inherited;
end;

destructor TInfoFech.destroy;
begin
  inherited;
end;

end.
