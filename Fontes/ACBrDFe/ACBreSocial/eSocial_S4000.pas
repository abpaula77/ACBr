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

unit eSocial_S4000;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS4000Collection = class;
  TS4000CollectionItem = class;
  TEvtSolicTotal = class;
  TInfoSolicitacao = class;


  TS4000Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS4000CollectionItem;
    procedure SetItem(Index: Integer; Value: TS4000CollectionItem);
  public
    function Add: TS4000CollectionItem;
    property Items[Index: Integer]: TS4000CollectionItem read GetItem write SetItem; default;
  end;

  TS4000CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtSolicTotal: TEvtSolicTotal;
    procedure setEvtSolicTotal(const Value: TEvtSolicTotal);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtSolicTotal: TEvtSolicTotal read FEvtSolicTotal write setEvtSolicTotal;
  end;

  TEvtSolicTotal = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento;
    FIdeEmpregador: TIdeEmpregador;
    FInfoSolicitacao: TInfoSolicitacao;

    {Geradores espec�ficos da classe}
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;

    property IdeEvento: TIdeEvento read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property InfoSolicitacao: TInfoSolicitacao read FInfoSolicitacao write FInfoSolicitacao;
  end;

  TInfoSolicitacao = class
  private
    FopcConsult: tpOpcConsult;
    FperSolicit: string;
    FcpfTrab: string;
  public
    property perSolicit: string read FperSolicit write FperSolicit;
    property cpfTrab: string read FcpfTrab write FcpfTrab;
    property opcConsult: tpOpcConsult read FopcConsult write FopcConsult;
  end;


implementation

uses
  eSocial_NaoPeriodicos;

{ TS4000Collection }

function TS4000Collection.Add: TS4000CollectionItem;
begin
  Result := TS4000CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS4000Collection.GetItem(Index: Integer): TS4000CollectionItem;
begin
  Result := TS4000CollectionItem(inherited GetItem(Index));
end;

procedure TS4000Collection.SetItem(Index: Integer;
  Value: TS4000CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS4000CollectionItem }

constructor TS4000CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS4000;
  FEvtSolicTotal := TEvtSolicTotal.Create(AOwner);
end;

destructor TS4000CollectionItem.Destroy;
begin
  FEvtSolicTotal.Free;
  inherited;
end;

procedure TS4000CollectionItem.setEvtSolicTotal(const Value: TEvtSolicTotal);
begin
  FEvtSolicTotal.Assign(Value);
end;

{ TEvtSolicTotal }

constructor TEvtSolicTotal.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FInfoSolicitacao := TInfoSolicitacao.Create;
end;

destructor TEvtSolicTotal.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FInfoSolicitacao.Free;
  inherited;
end;

function TEvtSolicTotal.GerarXML: boolean;
begin
  try
    GerarCabecalho('');
      Gerador.wGrupo('evtSolicTotal Id="'+GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0)+'"');
        //gerarIdVersao(self);
        GerarIdeEvento(self.IdeEvento);
        gerarIdeEmpregador(self.IdeEmpregador);
        Gerador.wGrupo('infoSolicitacao');
          Gerador.wCampo(tcStr, '', 'opcConsult', 0, 0, 0, eStpOpcConsultToStr(self.InfoSolicitacao.opcConsult));
          Gerador.wCampo(tcStr, '', 'perSolicit', 0, 0, 0, self.InfoSolicitacao.perSolicit);
          Gerador.wCampo(tcStr, '', 'cpfTrab', 0, 0, 0, self.InfoSolicitacao.cpfTrab);
        Gerador.wGrupo('/infoSolicitacao');
      Gerador.wGrupo('/evtSolicTotal');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtSolicTotal');
    Validar('evtSolicTotal');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

end.
