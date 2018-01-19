{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

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
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}
{******************************************************************************
|* Historico
|*
|* 24/10/2017: Renato Rubinho
|*  - Compatibilizado Fonte com Delphi 7
*******************************************************************************}

{$I ACBr.inc}

unit ACBrReinf;

interface

uses Classes, SysUtils, TypInfo, ACBrDFe, ACBrDFeException, ACBrDFeConfiguracoes, ACBrReinfConfiguracoes,
  pcnConversao, ACBrUtil, pcnConversaoReinf, ACBrReinfClasses, ACBrReinfEventos, ACBrReinfWebServices;

const
  REINF_NAMESPACE = 'http://sped.fazenda.gov.br/RecepcaoLoteReinf';
  URL_REINF_ENVIO = 'https://preprodefdreinf.receita.fazenda.gov.br/RecepcaoLoteReinf.svc';
  URL_REINF_CONSULTA = 'https://preprodefdreinf.receita.fazenda.gov.br/ConsultasReinf.svc';

const
  CErroAmbienteDiferente = 'Ambiente do XML (tpAmb) � diferente do configurado no Componente (Configuracoes.WebServices.Ambiente)';

type

  EACBReinfException = class(EACBrDFeException);

  TXmlSender = procedure(const Axml: string) of object;

  TACBrReinf = class(TACBrDFe)
  private
    FConfiguracoes: TConfiguracoesReinf;
    FContribuinte: TIdeContribuinte;
    FIdeEvento: TIdeEvento;
    FEventos: TEventos;
    FWebServices: TWebServices;
    FOnAfterEnviar: TXmlSender;
    FOnBeforeEnviar: TXmlSender;
    function GetConfiguracoes: TConfiguracoesReinf;
    procedure SetConfiguracoes(const Value: TConfiguracoesReinf);
    function GetVersao: string;
  protected
  public
    procedure LerServicoDeParams(ALayOutReinf: TLayReinf; var URL: String); reintroduce;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Enviar: Boolean;
    function GetNameSpaceURI: string; override;
    property ideContri: TIdeContribuinte read FContribuinte;
    property ideEvento: TIdeEvento read FIdeEvento write FIdeEvento;
    property Eventos: TEventos read FEventos;
    property WebServices: TWebServices read FWebServices write FWebServices;
  published
    property Configuracoes: TConfiguracoesReinf read GetConfiguracoes write SetConfiguracoes;
    property OnBeforeEnviar: TXmlSender read FOnBeforeEnviar write FOnBeforeEnviar;
    property OnAfterEnviar: TXmlSender read FOnAfterEnviar write FOnAfterEnviar;
    property Versao: string read GetVersao;
  end;

implementation

uses
  DateUtils, pcnGerador, ACBrDFeSSL;

{ TACBrReinf }

type
  THackEventos = class(TEventos);

procedure TACBrReinf.AfterConstruction;
begin
  inherited;
  SSL.SSLDgst := dgstSHA256;
  FEventos := TEventos.Create(Self);
  FConfiguracoes := TConfiguracoesReinf.Create(Self);
  FContribuinte := TIdeContribuinte.Create;
  FIdeEvento := TIdeEvento.Create;
  FWebServices := TWebServices.Create(Self);

  {Crypt SHA 256 apenas compativel com libOpenSSL e httpIndy\httpWinHttp}
  // FConfiguracoes.Geral.SSLLib := libOpenSSL;
  // FConfiguracoes.Geral.SSLHttpLib := httpIndy;
end;

procedure TACBrReinf.BeforeDestruction;
begin
  inherited;
  FConfiguracoes.Free;
  FContribuinte.Free;
  FIdeEvento.Free;
  FEventos.Free;
  FWebServices.Free;
end;

function TACBrReinf.Enviar: Boolean;
var
  xml: string;
begin
  if SSL.SSLXmlSignLib in [xsXmlSec, xsLibXml2] then
  begin
    xml := Eventos.GetXml;
    if Assigned(FOnBeforeEnviar) then
      FOnBeforeEnviar(xml);
    Result := FWebServices.Enviar(xml);
    if Result and Assigned(FOnAfterEnviar) then
      FOnAfterEnviar(FWebServices.EnvioLote.RetornoWS);
  end
  else
    raise EACBReinfException.Create('Necess�rio DigestMethod Algorithm = sha256 -> SSLLib = libOpenSSL');
end;

function TACBrReinf.GetConfiguracoes: TConfiguracoesReinf;
begin
  Result := FConfiguracoes;
end;

function TACBrReinf.GetNameSpaceURI: string;
begin
  Result := REINF_NAMESPACE;
end;

function TACBrReinf.GetVersao: string;
begin
  Result := GetEnumName(TypeInfo(TpcnVersaoReinf), integer(FConfiguracoes.VersaoReinf) )
end;

procedure TACBrReinf.LerServicoDeParams(ALayOutReinf: TLayReinf; var URL: String);
begin
  case ALayOutReinf of
    orLayENVIO:    URL := URL_REINF_ENVIO;
    orLayConsulta: URL := URL_REINF_CONSULTA;
  end;
end;

procedure TACBrReinf.SetConfiguracoes(const Value: TConfiguracoesReinf);
begin
  FConfiguracoes := Value;
end;

end.
