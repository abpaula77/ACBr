{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }

{ Direitos Autorais Reservados (c) 2015 Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }

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

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}

{$I ACBr.inc}

unit ACBrDFeCapicomDelphiSoap;

interface

uses
  Classes, SysUtils,
  ACBrDFeCapicom, ACBrDFeSSL,
  SoapHTTPClient, SOAPHTTPTrans;

const
  INTERNET_OPTION_CLIENT_CERT_CONTEXT = 84;      

type
  { TDFeCapicomDelphiSoap }

  TDFeCapicomDelphiSoap = class(TDFeCapicom)
  private
    FIndyReqResp: THTTPReqResp;
    FURL: String;

    procedure OnBeforePost(const HTTPReqResp: THTTPReqResp; Data: Pointer);
  protected
    procedure ConfiguraReqResp(const URL, SoapAction: String); override;
    procedure Executar(const ConteudoXML: String; Resp: TStream); override;

  public
    constructor Create(ADFeSSL: TDFeSSL);
    destructor Destroy; override;
  end;

implementation

uses
  strutils, WinInet, SOAPConst,
  ACBrCAPICOM_TLB, JwaWinCrypt,
  ACBrUtil, ACBrDFeUtil, ACBrDFe, ACBrDFeException;

{ TDFeCapicomDelphiSoap }

constructor TDFeCapicomDelphiSoap.Create(ADFeSSL: TDFeSSL);
begin
  inherited Create(ADFeSSL);

  FIndyReqResp := THTTPReqResp.Create(nil);
end;

destructor TDFeCapicomDelphiSoap.Destroy;
begin
  FIndyReqResp.Free;

  inherited Destroy;
end;

procedure TDFeCapicomDelphiSoap.OnBeforePost(const HTTPReqResp: THTTPReqResp;
  Data: Pointer);
var
  CertContext: ICertContext;
  PCertContext: Pointer;
  ContentHeader: String;
begin
  if (FpDFeSSL.UseCertificate) then
  begin
    CertContext := Certificado as ICertContext;
    CertContext.Get_CertContext(integer(PCertContext));
  end;

  with FpDFeSSL do
  begin
    if (UseCertificate) then
      if not InternetSetOption(Data, INTERNET_OPTION_CLIENT_CERT_CONTEXT,
        PCertContext, SizeOf(CERT_CONTEXT)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_CLIENT_CERT_CONTEXT: ' +
                                       IntToStr(GetLastError));

    if trim(ProxyUser) <> '' then
      if not InternetSetOption(Data, INTERNET_OPTION_PROXY_USERNAME,
        PChar(ProxyUser), Length(ProxyUser)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_PROXY_USERNAME: ' +
                                       IntToStr(GetLastError));

    if trim(ProxyPass) <> '' then
      if not InternetSetOption(Data, INTERNET_OPTION_PROXY_PASSWORD,
        PChar(ProxyPass), Length(ProxyPass)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_PROXY_PASSWORD: ' +
                                       IntToStr(GetLastError));

    ContentHeader := Format(ContentTypeTemplate, [FMimeType+'; charset=utf-8']);
    HttpAddRequestHeaders(Data, PChar(ContentHeader), Length(ContentHeader),
                            HTTP_ADDREQ_FLAG_REPLACE);
  end;

  FIndyReqResp.CheckContentType;
end;

procedure TDFeCapicomDelphiSoap.ConfiguraReqResp(const URL, SoapAction: String);
begin
  with FpDFeSSL do
  begin
    if ProxyHost <> '' then
    begin
      FIndyReqResp.Proxy := ProxyHost + ':' + ProxyPort;
      FIndyReqResp.UserName := ProxyUser;
      FIndyReqResp.Password := ProxyPass;
    end;

    FIndyReqResp.ConnectTimeout := TimeOut;
    FIndyReqResp.SendTimeout    := TimeOut;
    FIndyReqResp.ReceiveTimeout := TimeOut;
  end;

  FIndyReqResp.OnBeforePost := OnBeforePost;
  FIndyReqResp.UseUTF8InHeader := True;
  FIndyReqResp.SoapAction := SoapAction;
  FIndyReqResp.URL := URL;
  FURL := URL;
end;

procedure TDFeCapicomDelphiSoap.Executar(const ConteudoXML: String;
  Resp: TStream);
begin
  // Enviando, dispara exceptions no caso de erro //
  FIndyReqResp.Execute(ConteudoXML, Resp);
end;


end.
