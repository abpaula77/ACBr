{******************************************************************************}
{ Projeto: Componente ACBrBlocoX                                               }
{ Biblioteca multiplataforma de componentes Delphi para Gera��o de arquivos    }
{ do Bloco X                                                                   }
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
{******************************************************************************}

unit ACBrBlocoX_Comum;

interface

uses
  Classes, SysUtils, pcnGerador;

type
  EACBrBlocoXException = class(Exception);

  TACBrBlocoX_TipoCodigo = (tpcGTIN, tpcEAN, tpcProprio);
  TACBrBlocoX_SitTributaria = (stIsento, stN�oTributado, stSubstTributaria, stTributado, stISSQN);
  TACBrBlocoX_Ippt = (ipptProprio, ipptTerceiros);

  TACBrBlocoX_Codigo = class
  private
    FNumero: String;
    FTipo: TACBrBlocoX_TipoCodigo;
  public
    property Tipo: TACBrBlocoX_TipoCodigo read FTipo   write FTipo;
    property Numero: String               read FNumero write FNumero;
  end;

  TACBrBlocoX_Produto = class(TCollectionItem)
  private
    FDescricao: String;
    FCodigo: TACBrBlocoX_Codigo;
    FValorUnitario: Double;
    FIppt: TACBrBlocoX_Ippt;
    FAliquota: Double;
    FUnidade: String;
    FQuantidade: Integer;
    FIndicadorArredondamento: Boolean;
    FSituacaoTributaria: TACBrBlocoX_SitTributaria;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    property Descricao: String read FDescricao write FDescricao;
    property Codigo: TACBrBlocoX_Codigo read FCodigo write FCodigo;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property Unidade: String read FUnidade write FUnidade;
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;
    property SituacaoTributaria: TACBrBlocoX_SitTributaria read FSituacaoTributaria write FSituacaoTributaria;
    property Aliquota: Double read FAliquota write FAliquota;
    property IndicadorArredondamento: Boolean read FIndicadorArredondamento write FIndicadorArredondamento;
    property Ippt: TACBrBlocoX_Ippt read FIppt write FIppt;
  end;

  TACBrBlocoX_Servico = class(TACBrBlocoX_Produto);

  TACBrBlocoX_Base = class(TOwnedCollection)
  protected
    FACBrBlocoX: TComponent;
    FGerador: TGerador;
    FXMLOriginal: String;
    FXMLAssinado: String;
    procedure GerarDadosEstabelecimento;
    procedure GerarDadosPafECF;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
    destructor Destroy; override;

    procedure GerarXML(const Assinar: Boolean = True); virtual;
    procedure SaveToFile(const AXmlFileName: String); virtual;
  end;

  function TipoCodigoToStr(const AValue: TACBrBlocoX_TipoCodigo): String;
  function SituacaoTributariaToStr(const AValue: TACBrBlocoX_SitTributaria): String;
  function IpptToStr(const AValue: TACBrBlocoX_Ippt): String;

  function StrToTipoCodigo(const AValue: String): TACBrBlocoX_TipoCodigo;
  function StrToSituacaoTributaria(const AValue: String): TACBrBlocoX_SitTributaria;
  function StrToIppt(const AValue: String): TACBrBlocoX_Ippt;

implementation

uses
  ACBrBlocoX, ACBrUtil, StrUtils, pcnConversao;

function TipoCodigoToStr(const AValue: TACBrBlocoX_TipoCodigo): String;
begin
  case AValue of
    tpcGTIN    : Result := 'GTIN';
    tpcEAN     : Result := 'EAN';
    tpcProprio : Result := 'Proprio';
  end;
end;

function SituacaoTributariaToStr(const AValue: TACBrBlocoX_SitTributaria): String;
begin
  case AValue of
    stIsento          : Result := 'I';
    stN�oTributado    : Result := 'N';
    stSubstTributaria : Result := 'F';
    stTributado       : Result := 'T';
    stISSQN           : Result := 'S';
  end;
end;

function IpptToStr(const AValue: TACBrBlocoX_Ippt): String;
begin
  case AValue of
    ipptProprio   : Result := 'P';
    ipptTerceiros : Result := 'T';
  end;
end;

function StrToTipoCodigo(const AValue: String): TACBrBlocoX_TipoCodigo;
var
  I: Integer;
begin
  I := IndexText(AValue, ['GTIN', 'EAN', 'Proprio']);
  if I < 0 then
    raise EACBrBlocoXException.CreateFmt('Tipo de c�digo inv�lido "%s", utilize GTIN, EAN ou Proprio', [AValue]);

  Result := TACBrBlocoX_TipoCodigo(I);
end;

function StrToSituacaoTributaria(const AValue: String): TACBrBlocoX_SitTributaria;
var
  I: Integer;
begin
  I := IndexText(AValue, ['I', 'N', 'F', 'T', 'S']);
  if I < 0 then
    raise EACBrBlocoXException.CreateFmt('Situa��o Tribut�ria inv�lida "%s", utilize I, N, F, T ou S', [AValue]);

  Result := TACBrBlocoX_SitTributaria(I);
end;

function StrToIppt(const AValue: String): TACBrBlocoX_Ippt;
var
  I: Integer;
begin
  I := IndexText(AValue, ['P', 'T']);
  if I < 0 then
    raise EACBrBlocoXException.CreateFmt('IPPT inv�lido "%s", utilize P ou T', [AValue]);

  Result := TACBrBlocoX_Ippt(I);
end;

{ TACBrBlocoX_Produto }

constructor TACBrBlocoX_Produto.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FCodigo := TACBrBlocoX_Codigo.Create;
end;

destructor TACBrBlocoX_Produto.Destroy;
begin
  FCodigo.Free;
  inherited;
end;

{ TACBrBlocoX_Base }

constructor TACBrBlocoX_Base.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  if not (AOwner is TACBrBlocoX) then
    raise EACBrBlocoXException.Create('AOwner deve ser do tipo TACBrBlocoX');

  inherited;

  FACBrBlocoX := TACBrBlocoX(AOwner);
  FGerador := TGerador.Create;
end;

destructor TACBrBlocoX_Base.Destroy;
begin
  FGerador.Free;
  inherited;
end;

procedure TACBrBlocoX_Base.GerarDadosEstabelecimento;
begin
  FGerador.wGrupo('Estabelecimento');
  with TACBrBlocoX(FACBrBlocoX) do
  begin
    FGerador.wCampo(tcStr, '', 'Ie', 0, 200, 1, Estabelecimento.Ie);
    FGerador.wCampo(tcStr, '', 'Cnpj', 14, 14, 1, OnlyNumber(Estabelecimento.Cnpj));
    FGerador.wCampo(tcStr, '', 'NomeEmpresarial', 0, 200, 1, Estabelecimento.NomeEmpresarial);
  end;
  FGerador.wGrupo('/Estabelecimento');
end;

procedure TACBrBlocoX_Base.GerarDadosPafECF;
begin
  FGerador.wGrupo('PafEcf');
  with TACBrBlocoX(FACBrBlocoX) do
  begin
    FGerador.wCampo(tcStr, '', 'NumeroCredenciamento', 0, 200, 1, PafECF.NumeroCredenciamento);
    FGerador.wCampo(tcStr, '', 'NomeComercial', 0, 200, 1, PafECF.NomeComercial);
    FGerador.wCampo(tcStr, '', 'Versao', 1, 20, 1, PafECF.Versao);
    FGerador.wCampo(tcStr, '', 'CnpjDesenvolvedor', 14, 14, 1, OnlyNumber(PafECF.CnpjDesenvolvedor));
    FGerador.wCampo(tcStr, '', 'NomeEmpresarialDesenvolvedor', 0, 200, 1, PafECF.NomeEmpresarialDesenvolvedor);
  end;
  FGerador.wGrupo('/PafEcf');
end;

procedure TACBrBlocoX_Base.GerarXML(const Assinar: Boolean = True);
begin
  raise EACBrBlocoXException.Create('M�todo n�o implementado "GerarXML"');
end;

procedure TACBrBlocoX_Base.SaveToFile(const AXmlFileName: String);
begin
  raise EACBrBlocoXException.Create('M�todo n�o implementado "SaveToFileName"');
end;

end.
