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
|*  - Alterado o nome de valida��o do XSD
******************************************************************************}
{$I ACBr.inc}

unit pcesS2190;

interface

uses
  SysUtils, Classes,
  pcnConversao,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS2190Collection = class;
  TS2190CollectionItem = class;
  TEvtAdmPrelim = class;
  TInfoRegPrelim = class;

  TS2190Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS2190CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2190CollectionItem);
  public
    function Add: TS2190CollectionItem;
    property Items[Index: Integer]: TS2190CollectionItem read GetItem write SetItem; default;
  end;

  TS2190CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtAdmPrelim: TEvtAdmPrelim;

    procedure setEvtAdmPrelim(const Value: TEvtAdmPrelim);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtAdmPrelim: TEvtAdmPrelim read FEvtAdmPrelim write setEvtAdmPrelim;
  end;

  TEvtAdmPrelim = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento;
    FIdeEmpregador: TIdeEmpregador;
    FInfoRegPrelim: TInfoRegPrelim;

    procedure GerarInfoRegPrelim;
  public
    constructor Create(AACBreSocial: TObject);
    destructor Destroy; override;

    function GerarXML(ASequencial: Integer; ATipoEmpregador: TEmpregador): boolean; override;

    property IdeEvento: TIdeEvento read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property InfoRegPrelim: TInfoRegPrelim read FInfoRegPrelim write FInfoRegPrelim;
  end;

  TInfoRegPrelim = class(TPersistent)
  private
    FcpfTrab: string;
    FdtNascto: TDateTime; //FdtNascto: TDate;
    FdtAdm: TDateTime; //FdtAdm: TDate
  public
    property cpfTrab: string read FcpfTrab write FcpfTrab;
    property dtNascto: TDateTime read FdtNascto write FdtNascto;
    property dtAdm: TDateTime read FdtAdm write FdtAdm;
  end;

implementation

{ TS2190Collection }
function TS2190Collection.Add: TS2190CollectionItem;
begin
  Result := TS2190CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS2190Collection.GetItem(Index: Integer): TS2190CollectionItem;
begin
  Result := TS2190CollectionItem(inherited GetItem(Index));
end;

procedure TS2190Collection.SetItem(Index: Integer;
  Value: TS2190CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS2190CollectionItem }
constructor TS2190CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS2190;
  FEvtAdmPrelim := TEvtAdmPrelim.Create(AOwner);
end;

destructor TS2190CollectionItem.Destroy;
begin
  FEvtAdmPrelim.Free;

  inherited;
end;

procedure TS2190CollectionItem.setEvtAdmPrelim(const Value: TEvtAdmPrelim);
begin
  FEvtAdmPrelim.Assign(Value);
end;

{ TEvtAdmissao }
constructor TEvtAdmPrelim.create;
begin
  inherited;

  FIdeEvento := TIdeEvento.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FInfoRegPrelim := TInfoRegPrelim.Create;
end;

destructor TEvtAdmPrelim.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FInfoRegPrelim.Free;

  inherited;
end;

procedure TEvtAdmPrelim.GerarInfoRegPrelim;
begin
  Gerador.wGrupo('infoRegPrelim');

  Gerador.wCampo(tcStr, '', 'cpfTrab',  11, 11, 1, InfoRegPrelim.cpfTrab);
  Gerador.wCampo(tcDat, '', 'dtNascto', 10, 10, 1, InfoRegPrelim.dtNascto);
  Gerador.wCampo(tcDat, '', 'dtAdm',    10, 10, 1, InfoRegPrelim.dtAdm);

  Gerador.wGrupo('/infoRegPrelim');
end;

function TEvtAdmPrelim.GerarXML(ASequencial: Integer; ATipoEmpregador: TEmpregador): boolean;
begin
  try
    GerarCabecalho('evtAdmPrelim');
    Gerador.wGrupo('evtAdmPrelim Id="' +
      GerarChaveEsocial(now, self.ideEmpregador.NrInsc, ASequencial, ATipoEmpregador) + '"');

    GerarIdeEvento(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarInfoRegPrelim;

    Gerador.wGrupo('/evtAdmPrelim');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtAdmPrelim');

    Validar('evtAdmPrelim');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

end.
