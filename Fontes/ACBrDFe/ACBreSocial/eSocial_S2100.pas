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

unit eSocial_S2100;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS2100Collection = class;
  TS2100CollectionItem = class;
  TevtCadInicial = class;

  {Classes espec�ficas deste evento}

  TS2100Collection = class(TOwnedCollection)
  private
    FIniciais : TComponent;
    function GetItem(Index: Integer): TS2100CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2100CollectionItem);
  public
    function Add: TS2100CollectionItem;
    property Items[Index: Integer]: TS2100CollectionItem read GetItem write SetItem; default;
  end;

  TS2100CollectionItem = class(TCollectionItem)
  private
    FIniciais : TComponent;
    FTipoEvento: TTipoEvento;
    FevtCadInicial: TevtCadInicial;
    procedure setevtCadInicial(const Value: TevtCadInicial);
  public
    constructor Create(AIniciais: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtCadInicial: TevtCadInicial read FevtCadInicial write setevtCadInicial;
  end;


  TevtCadInicial = class(TeSocialEvento)
  private
    FIniciais : TComponent;
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FTrabalhador: TTrabalhador;
    FVinculo: TVinculo;

    {Geradores espec�ficos da classe}
  public
    constructor Create(AACBreSocial: TObject); overload;
    destructor Destroy; override;

    function GerarXML: boolean; override;

    property ideEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property ideEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property trabalhador: TTrabalhador read Ftrabalhador write Ftrabalhador;
    property vinculo: TVinculo read FVinculo write FVinculo;
  end;

implementation

uses
  eSocial_Iniciais;

{ TS2100Collection }

function TS2100Collection.Add: TS2100CollectionItem;
begin
  Result := TS2100CollectionItem(inherited Add);
  Result.create(TComponent(Self.Owner));
end;

function TS2100Collection.GetItem(Index: Integer): TS2100CollectionItem;
begin
  Result := TS2100CollectionItem(inherited GetItem(Index));
end;

procedure TS2100Collection.SetItem(Index: Integer;
  Value: TS2100CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS2100CollectionItem }

constructor TS2100CollectionItem.Create(AIniciais: TComponent);
begin
  FIniciais := AIniciais;
  FTipoEvento := teS2100;
  FevtCadInicial := TevtCadInicial.Create(FIniciais);
end;

destructor TS2100CollectionItem.Destroy;
begin
  FevtCadInicial.Free;
  inherited;
end;

procedure TS2100CollectionItem.setevtCadInicial(const Value: TevtCadInicial);
begin
  FevtCadInicial.Assign(Value);
end;

{ TevtCadInicial }

constructor TevtCadInicial.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento:= TIdeEvento2.Create;
  FIdeEmpregador:= TIdeEmpregador.Create;
  FTrabalhador:= TTrabalhador.Create;
  FVinculo:= TVinculo.Create;
end;

destructor TevtCadInicial.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FTrabalhador.Free;
  FVinculo.Free;
  inherited;
end;

function TevtCadInicial.GerarXML: boolean;
begin
  try
    GerarCabecalho('evtCadInicial');
      Gerador.wGrupo('evtCadInicial Id="'+ GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0) +'"');
        GerarIdeEvento2(Self.ideEvento);
        GerarIdeEmpregador(Self.IdeEmpregador);
        GerarTrabalhador(Self.trabalhador);
        GerarVinculo(Self.vinculo);
      Gerador.wGrupo('/evtCadInicial');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtCadInicial');//Gerador.ArquivoFormatoXML;
    Validar('evtCadInicial');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;
  Result := (Gerador.ArquivoFormatoXML <> '')
end;

end.
