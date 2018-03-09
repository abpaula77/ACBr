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

unit pcesS2205;

interface

uses
  SysUtils, Classes,
  pcnConversao,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS2205Collection = class;
  TS2205CollectionItem = class;
  TEvtAltCadastral = class;

  TS2205Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS2205CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2205CollectionItem);
  public
    function Add: TS2205CollectionItem;
    property Items[Index: Integer]: TS2205CollectionItem read GetItem write SetItem; default;
  end;

  TS2205CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtAltCadastral: TEvtAltCadastral;
    procedure setEvtAltCadastral(const Value: TEvtAltCadastral);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtAltCadastral: TEvtAltCadastral read FEvtAltCadastral write setEvtAltCadastral;
  end;

  TEvtAltCadastral = class(TeSocialEvento)
  private
    FdtAlteracao: TDateTime;
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FTrabalhador: TTrabalhador;
    FVinculo: TVinculo;
    FIdeTrabalhador: TideTrabalhador;
    FACBreSocial: TObject;

    procedure GerarInfoAltCadastral;
  public
    constructor Create(AACBreSocial: TObject);
    destructor destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property dtAlteracao: TDateTime read FdtAlteracao write FdtAlteracao;
    property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property Trabalhador: TTrabalhador read FTrabalhador write FTrabalhador;
    property Vinculo: TVinculo read FVinculo write FVinculo;
    property IdeTrabalhador: TideTrabalhador read FIdeTrabalhador write FIdeTrabalhador;
  end;

implementation

uses
  IniFiles,
  ACBreSocial, ACBrDFeUtil;

{ TS2205Collection }

function TS2205Collection.Add: TS2205CollectionItem;
begin
  Result := TS2205CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS2205Collection.GetItem(Index: Integer): TS2205CollectionItem;
begin
  Result := TS2205CollectionItem(inherited GetItem(Index));
end;

procedure TS2205Collection.SetItem(Index: Integer;
  Value: TS2205CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS2205CollectionItem }

constructor TS2205CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS2205;
  FEvtAltCadastral := TEvtAltCadastral.Create(AOwner);
end;

destructor TS2205CollectionItem.Destroy;
begin
  FEvtAltCadastral.Free;

  inherited;
end;

procedure TS2205CollectionItem.setEvtAltCadastral(
  const Value: TEvtAltCadastral);
begin
  FEvtAltCadastral.Assign(Value);
end;

{ TEvtAltCadastral }

constructor TEvtAltCadastral.Create(AACBreSocial: TObject);
begin
  inherited;

  FACBreSocial := AACBreSocial;
  FIdeEvento := TIdeEvento2.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FTrabalhador := TTrabalhador.Create;
  FVinculo := TVinculo.Create;
  FIdeTrabalhador := TideTrabalhador.Create;
end;

destructor TEvtAltCadastral.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FTrabalhador.Free;
  FVinculo.Free;
  FIdeTrabalhador.Free;

  inherited;
end;

procedure TEvtAltCadastral.GerarInfoAltCadastral;
begin
  GerarModoAbertura(mlAlteracao);

  Gerador.wCampo(tcDat, '', 'dtAlteracao', 10, 10, 1, self.dtAlteracao);

  GerarTrabalhador(self.Trabalhador, 'dadosTrabalhador');

  GerarModoFechamento(mlAlteracao);
end;

function TEvtAltCadastral.GerarXML: boolean;
begin
  try
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtAltCadastral');
    Gerador.wGrupo('evtAltCadastral Id="' + Self.Id + '"');

    GerarIdeEvento2(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarIdeTrabalhador(self.IdeTrabalhador, True);
    GerarInfoAltCadastral;

    Gerador.wGrupo('/evtAltCadastral');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtAltCadastral');

    Validar(schevtAltCadastral);
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtAltCadastral.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao, sFim: String;
  I: Integer;
begin
  Result := False;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      // Falta Implementar
    end;

    GerarXML;

    Result := True;
  finally
     INIRec.Free;
  end;
end;

end.
