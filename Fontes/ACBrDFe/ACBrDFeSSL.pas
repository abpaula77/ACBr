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

unit ACBrDFeSSL;

interface

uses
  Classes, SysUtils;

type


  { TDFeSSLClass }

  TSSLTipoCertificado = (tpcA1, tpcA3);

  TDFeSSL = class;

  TDFeSSLClass = class
  private
  protected
    FpDFeSSL: TDFeSSL;
    FpCertificadoLido: Boolean;

    function GetCertDataVenc: TDateTime; virtual;
    function GetCertNumeroSerie: String; virtual;
    function GetCertSubjectName: String; virtual;
    function GetCertCNPJ: String; virtual;
    function GetHTTPResultCode: Integer; virtual;
    function GetInternalErrorCode: Integer; virtual;
    function GetCertTipo: TSSLTipoCertificado; virtual;

    function SignatureElement(const URI: String; AddX509Data: Boolean;
      IdSignature: String = ''): String;
      virtual;
    function AdicionarSignatureElement( ConteudoXML: String; AddX509Data: Boolean;
      docElement, IdSignature: String): String;
    function AjustarXMLAssinado(const ConteudoXML: String): String;
  public
    constructor Create(ADFeSSL: TDFeSSL); virtual;

    function Assinar(const ConteudoXML, docElement, infElement: String;
      SignatureNode: String = ''; SelectionNamespaces: String = '';
      IdSignature: String = ''): String; virtual;
    function Enviar(const ConteudoXML: String; const URL: String;
      const SoapAction: String; const MimeType: String = ''): String; virtual;
    function Validar(const ConteudoXML, ArqSchema: String;
      out MsgErro: String): Boolean; virtual;
    function VerificarAssinatura(const ConteudoXML: String; out MsgErro: String;
      const infElement: String; SignatureNode: String = '';
      SelectionNamespaces: String = ''): Boolean; virtual;

    procedure CarregarCertificado; virtual;
    procedure DescarregarCertificado; virtual;
    function SelecionarCertificado: String; virtual;

    property CertificadoLido: Boolean read FpCertificadoLido;

    property CertNumeroSerie: String read GetCertNumeroSerie;
    property CertDataVenc: TDateTime read GetCertDataVenc;
    property CertSubjectName: String read GetCertSubjectName;
    property CertCNPJ: String read GetCertCNPJ;
    property CertTipo: TSSLTipoCertificado read GetCertTipo;

    property HTTPResultCode: Integer read GetHTTPResultCode;
    property InternalErrorCode: Integer read GetInternalErrorCode;
  end;

  TSSLLib = (libNone, libOpenSSL, libCapicom, libCapicomDelphiSoap);

  { TDFeSSL }

  TDFeSSL = class
  private
    FArquivoPFX: String;
    FDadosPFX: AnsiString;
    FNameSpaceURI: String;
    FNumeroSerie: String;
    FProxyHost: String;
    FProxyPass: String;
    FProxyPort: String;
    FProxyUser: String;
    FSenha: AnsiString;
    FK: String;
    FSSLClass: TDFeSSLClass;
    FSSLLib: TSSLLib;
    FTimeOut: Integer;
    FUseCertificate: Boolean;
    FUseSSL: Boolean;

    function GetCertCNPJ: String;
    function GetCertDataVenc: TDateTime;
    function GetCertificadoLido: Boolean;
    function GetCertNumeroSerie: String;
    function GetCertSubjectName: String;
    function GetHTTPResultCode: Integer;
    function GetInternalErrorCode: Integer;
    function GetSenha: AnsiString;

    procedure SetArquivoPFX(AValue: String);
    procedure SetDadosPFX(AValue: AnsiString);
    procedure SetNumeroSerie(AValue: String);
    procedure SetSenha(AValue: AnsiString);

    procedure SetSSLLib(ASSLLib: TSSLLib);
    function GetCertTipo: TSSLTipoCertificado;

  public
    constructor Create;
    procedure Clear;
    destructor Destroy; override;

    // Nota: ConteudoXML, DEVE estar em UTF8 //
    function Assinar(const ConteudoXML, docElement, infElement: String;
      SignatureNode: String = ''; SelectionNamespaces: String = '';
      IdSignature: String = ''): String;
    // Envia por SoapAction o ConteudoXML para URL. Retorna a resposta do Servico //
    function Enviar(var ConteudoXML: String; const URL: String;
      const SoapAction: String; const MimeType: String = ''): String;
    // Valida um Arquivo contra o seu Schema. Retorna True se OK, preenche MsgErro se False //
    function Validar(const ConteudoXML: String; ArqSchema: String;
      out MsgErro: String): Boolean;
    // Verifica se assinatura de um XML � v�lida. Retorna True se OK, preenche MsgErro se False //
    function VerificarAssinatura(const ConteudoXML: String; out MsgErro: String;
      const infElement: String; SignatureNode: String = '';
      SelectionNamespaces: String = ''): Boolean;

    procedure CarregarCertificado;
    procedure DescarregarCertificado;
    function SelecionarCertificado: String;

    procedure ValidarCNPJCertificado(CNPJDocumento: String);

    property CertificadoLido: Boolean read GetCertificadoLido;

    property CertNumeroSerie: String read GetCertNumeroSerie;
    property CertDataVenc: TDateTime read GetCertDataVenc;
    property CertSubjectName: String read GetCertSubjectName;
    property CertCNPJ: String read GetCertCNPJ;
    property CertTipo: TSSLTipoCertificado read GetCertTipo;

    property HTTPResultCode: Integer read GetHTTPResultCode;
    property InternalErrorCode: Integer read GetInternalErrorCode;

  published
    property SSLLib: TSSLLib read FSSLLib write SetSSLLib;
    property SSLClass: TDFeSSLClass read FSSLClass;

    property ArquivoPFX: String read FArquivoPFX write SetArquivoPFX;
    property DadosPFX: AnsiString read FDadosPFX write SetDadosPFX;
    property NumeroSerie: String read FNumeroSerie write SetNumeroSerie;
    property Senha: AnsiString read GetSenha write SetSenha;

    property ProxyHost: String read FProxyHost write FProxyHost;
    property ProxyPort: String read FProxyPort write FProxyPort;
    property ProxyUser: String read FProxyUser write FProxyUser;
    property ProxyPass: String read FProxyPass write FProxyPass;

    property TimeOut: Integer read FTimeOut write FTimeOut default 5000;
    property NameSpaceURI: String read FNameSpaceURI write FNameSpaceURI;

    property UseCertificate: Boolean read FUseCertificate write FUseCertificate;
    property UseSSL: Boolean read FUseSSL Write FUseSSL;
  end;


implementation

uses strutils,
  ACBrDFeUtil, ACBrValidador, ACBrUtil, ACBrDFeException
  {$IFNDEF DFE_SEM_OPENSSL}
   ,ACBrDFeOpenSSL
  {$ENDIF}
  {$IFNDEF DFE_SEM_CAPICOM}
   ,ACBrDFeCapicom
   {$IFNDEF FPC}
    ,ACBrDFeCapicomDelphiSoap
   {$ENDIF}
  {$ENDIF};

{ TDFeSSL }

constructor TDFeSSL.Create;
begin
  inherited Create;

  Clear;
end;

procedure TDFeSSL.Clear;
begin
  FArquivoPFX  := '';
  FDadosPFX    := '';
  FNumeroSerie := '';
  FProxyHost   := '';
  FProxyPass   := '';
  FProxyPort   := '';
  FProxyUser   := '';
  FSenha       := '';
  FK           := '';
  FSSLLib      := libNone;
  FTimeOut     := 5000;
  FNameSpaceURI:= '';

  // Para emiss�o de NFS-e essas propriedades podem ter valores diferentes dos
  // atribuidos abaixo, dependendo do provedor...
  FUseCertificate := True;
  FUseSSL := True;

  if Assigned(FSSLClass) then
    FSSLClass.Free;

  FSSLClass := TDFeSSLClass.Create(Self);
end;

destructor TDFeSSL.Destroy;
begin
  if Assigned(FSSLClass) then
  begin
    DescarregarCertificado;
    FreeAndNil(FSSLClass);
  end;

  inherited Destroy;
end;

function TDFeSSL.Assinar(const ConteudoXML, docElement, infElement: String;
  SignatureNode: String; SelectionNamespaces: String; IdSignature: String
  ): String;
Var
  XmlAss, xmlHeaderAntes, xmlHeaderDepois: String;
  I: integer;
begin
  // Nota: ConteudoXML, DEVE estar em UTF8 //
  // Lendo Header antes de assinar //
  xmlHeaderAntes := '';
  I := pos('?>', ConteudoXML);
  if I > 0 then
    xmlHeaderAntes := copy(ConteudoXML, 1, I + 1);

  XmlAss := FSSLClass.Assinar( ConteudoXML, docElement, infElement,
                               SignatureNode, SelectionNamespaces, IdSignature);

  // Verificando se modificou o Header do XML assinado, e voltando para o anterior //
  if xmlHeaderAntes <> '' then
  begin
    I := pos('?>', XmlAss);
    if I > 0 then
    begin
      xmlHeaderDepois := copy(XmlAss, 1, I + 1);
      if xmlHeaderAntes <> xmlHeaderDepois then
        XmlAss := StuffString(XmlAss, 1, length(xmlHeaderDepois), xmlHeaderAntes);
    end
    else
      XmlAss := xmlHeaderAntes + XmlAss;
  end;

  //remover um cabe�alho vazio que estava ficando na inutiliza��o
  XmlAss := StringReplace(XmlAss, '<?xml version="1.0"?>', '', []);

  Result := XmlAss;
end;

function TDFeSSL.Enviar(var ConteudoXML: String; const URL: String;
  const SoapAction: String; const MimeType: String): String;
begin
  // Nota: ConteudoXML, DEVE estar em UTF8 //
  Result := FSSLClass.Enviar(ConteudoXML, URL, SoapAction, MimeType);
end;

function TDFeSSL.Validar(const ConteudoXML: String; ArqSchema: String;
  out MsgErro: String): Boolean;
begin
  if EstaVazio(ArqSchema) then
    raise EACBrDFeException.Create('Arquivo de Schema n�o especificado');

  // ArqSchema deve vir com o Path Completo
  if not FileExists(ArqSchema) then
    raise EACBrDFeException.Create('Arquivo ' + sLineBreak + ArqSchema +
      sLineBreak + 'N�o encontrado');

  Result := FSSLClass.Validar(ConteudoXML, ArqSchema, MsgErro);
end;

function TDFeSSL.VerificarAssinatura(const ConteudoXML: String; out
  MsgErro: String; const infElement: String; SignatureNode: String;
  SelectionNamespaces: String): Boolean;
begin
  Result := FSSLClass.VerificarAssinatura(ConteudoXML, MsgErro,
                              infElement, SignatureNode, SelectionNamespaces);
end;

procedure TDFeSSL.CarregarCertificado;
begin
  FSSLClass.CarregarCertificado;
end;

procedure TDFeSSL.DescarregarCertificado;
begin
  FSSLClass.DescarregarCertificado;
end;

function TDFeSSL.SelecionarCertificado: String;
begin
  Result := FSSLClass.SelecionarCertificado;

  if NaoEstaVazio(Result) then
    FSSLClass.CarregarCertificado;
end;

{ Verifica se o "CNPJDocumento", � da mesma raiz do CNPJ do Certificado }
procedure TDFeSSL.ValidarCNPJCertificado(CNPJDocumento: String);
var
  ErroCNPJ, CNPJCertificado: String;
begin
  CNPJDocumento := OnlyNumber(CNPJDocumento);
  if (CNPJDocumento = '') or              // Informou vazio
     (Length(CNPJDocumento) <> 14) then   // N�o � CNPJ
    exit;

  CNPJCertificado := OnlyNumber(CertCNPJ);  // Lendo CNPJ do Certificado...
  if (CNPJCertificado = '') or              // N�o foi capaz de ler CNPJ do Certificado (Senha, NumSerie, Path... h� algo errado na configura��o)
     (Length(CNPJCertificado) <> 14) then   // N�o � CNPJ (estranho.. pode ser um eCPF)
    exit;

  ErroCNPJ := ValidarCNPJ(CNPJDocumento);
  if (ErroCNPJ <> '') then
    raise EACBrDFeException.CreateDef('Erro CNPJ Documento: '+ErroCNPJ);

  { Deve verificar somente os 8 primeiros digitos, para evitar problemas quando
    a filial estiver utilizando o certificado da matriz }
  if (Copy(CNPJDocumento, 1, 8) <> Copy(CNPJCertificado, 1, 8)) then
    raise EACBrDFeException.Create('O CNPJ do Documento � diferente do CNPJ do Certificado Digital' );
end;

function TDFeSSL.GetCertDataVenc: TDateTime;
begin
  Result := FSSLClass.CertDataVenc;
end;

function TDFeSSL.GetCertificadoLido: Boolean;
begin
  Result := FSSLClass.CertificadoLido;
end;

function TDFeSSL.GetCertCNPJ: String;
begin
  Result := FSSLClass.CertCNPJ;
end;

function TDFeSSL.GetCertNumeroSerie: String;
begin
  Result := FSSLClass.CertNumeroSerie;
end;

function TDFeSSL.GetCertSubjectName: String;
begin
  Result := FSSLClass.CertSubjectName;
end;

function TDFeSSL.GetCertTipo: TSSLTipoCertificado;
begin
  Result := FSSLClass.GetCertTipo;
end;

function TDFeSSL.GetHTTPResultCode: Integer;
begin
  Result := FSSLClass.HTTPResultCode;
end;

function TDFeSSL.GetInternalErrorCode: Integer;
begin
  Result := FSSLClass.InternalErrorCode;
end;

function TDFeSSL.GetSenha: AnsiString;
begin
  Result := StrCrypt(FSenha, FK)  // Descritografa a Senha
end;

procedure TDFeSSL.SetArquivoPFX(AValue: String);
begin
  if FArquivoPFX = AValue then Exit;
  FArquivoPFX := AValue;
  FDadosPFX := '';   // For�a a releitura de DadosPFX;
  DescarregarCertificado;
end;

procedure TDFeSSL.SetDadosPFX(AValue: AnsiString);
begin
  if FDadosPFX = AValue then Exit;
  FDadosPFX := AValue;
  DescarregarCertificado;
end;

procedure TDFeSSL.SetNumeroSerie(AValue: String);
begin
  if FNumeroSerie = AValue then Exit;
  FNumeroSerie := Trim(UpperCase(StringReplace(AValue, ' ', '', [rfReplaceAll])));
  DescarregarCertificado;
end;

procedure TDFeSSL.SetSenha(AValue: AnsiString);
begin
  if (FK <> '') and (FSenha = StrCrypt(AValue, FK)) then
    Exit;

  FK := FormatDateTime('hhnnsszzz',Now);
  FSenha := StrCrypt(AValue, FK);  // Salva Senha de forma Criptografada, para evitar "Inspect"

  DescarregarCertificado;
end;

procedure TDFeSSL.SetSSLLib(ASSLLib: TSSLLib);
begin
  if ASSLLib = FSSLLib then
    exit;

  if Assigned(FSSLClass) then
    FreeAndNil(FSSLClass);

  {$IFNDEF DFE_SEM_CAPICOM}
  case ASSLLib of
    libCapicom:
      FSSLClass := TDFeCapicom.Create(Self);

    libOpenSSL:
    begin
      {$IFNDEF DFE_SEM_OPENSSL}
       FSSLClass := TDFeOpenSSL.Create(Self);
      {$ELSE}
       raise EACBrDFeException.Create('Suporte a libOpenSSL foi desativado por compila��o {$DEFINE DFE_SEM_OPENSSL}');
      {$ENDIF}
    end;

    libCapicomDelphiSoap:
    begin
      {$IFNDEF FPC}
       FSSLClass := TDFeCapicomDelphiSoap.Create(Self);
      {$ELSE}
       FSSLClass := TDFeCapicom.Create(Self);
      {$ENDIF}
    end
  else
    FSSLClass := TDFeSSLClass.Create(Self);
  end;
  {$ELSE}
  case ASSLLib of
    libOpenSSL, libCapicom, libCapicomDelphiSoap:
      FSSLClass := TDFeOpenSSL.Create(Self);
  else
    FSSLClass := TDFeSSLClass.Create(Self);
  end;
  {$ENDIF}

  FSSLLib := ASSLLib;
end;

{ TDFeSSLClass }

constructor TDFeSSLClass.Create(ADFeSSL: TDFeSSL);
begin
  FpDFeSSL := ADFeSSL;
  FpCertificadoLido := False;
end;

function TDFeSSLClass.Assinar(const ConteudoXML, docElement,
  infElement: String; SignatureNode: String; SelectionNamespaces: String;
  IdSignature: String): String;
begin
  Result := '';
  raise EACBrDFeException.Create(ClassName + '.Assinar, n�o implementado');
end;

function TDFeSSLClass.Enviar(const ConteudoXML: String; const URL: String;
  const SoapAction: String; const MimeType: String): String;
begin
  Result := '';
  raise EACBrDFeException.Create(ClassName + '.Enviar n�o implementado');
end;

function TDFeSSLClass.Validar(const ConteudoXML, ArqSchema: String;
  out MsgErro: String): Boolean;
begin
  Result := False;
  raise EACBrDFeException.Create('"Validar" n�o suportado em: ' + ClassName);
end;

function TDFeSSLClass.VerificarAssinatura(const ConteudoXML: String; out
  MsgErro: String; const infElement: String; SignatureNode: String;
  SelectionNamespaces: String): Boolean;
begin
  Result := False;
  raise EACBrDFeException.Create('"ValidarAssinatura" n�o suportado em: ' + ClassName);
end;

function TDFeSSLClass.SelecionarCertificado: String;
begin
  Result := '';
  raise EACBrDFeException.Create('"SelecionarCertificado" n�o suportado em: ' +
    ClassName);
end;

procedure TDFeSSLClass.CarregarCertificado;
begin
  { nada aqui, m�todo virtual}
end;

procedure TDFeSSLClass.DescarregarCertificado;
begin
  { nada aqui, m�todo virtual}
end;

function TDFeSSLClass.GetHTTPResultCode: Integer;
begin
  Result := 0;
end;

function TDFeSSLClass.GetInternalErrorCode: Integer;
begin
  Result := 0;
end;

function TDFeSSLClass.GetCertDataVenc: TDateTime;
begin
  Result := 0;
end;

function TDFeSSLClass.GetCertNumeroSerie: String;
begin
  Result := '';
end;

function TDFeSSLClass.GetCertSubjectName: String;
begin
  Result := '';
end;

function TDFeSSLClass.GetCertTipo: TSSLTipoCertificado;
begin
  Result := tpcA1;
end;

function TDFeSSLClass.GetCertCNPJ: String;
begin
  Result := '';
end;

function TDFeSSLClass.SignatureElement(const URI: String; AddX509Data: Boolean;
  IdSignature: String): String;
begin
  {(*}
  Result :=
  '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#"' + IdSignature + '>' +
    '<SignedInfo>' +
      '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' +
      '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />' +
      '<Reference URI="' + IfThen(URI = '', '', '#' + URI) + '">' +
        '<Transforms>' +
          '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />' +
          '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' +
        '</Transforms>' +
        '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />' +
        '<DigestValue></DigestValue>' +
      '</Reference>' +
    '</SignedInfo>' +
    '<SignatureValue></SignatureValue>' +
    '<KeyInfo>' +
    IfThen(AddX509Data,
      '<X509Data>' +
        '<X509Certificate></X509Certificate>' +
      '</X509Data>',
      '')+
    '</KeyInfo>'+
  '</Signature>';
  {*)}
end;

function TDFeSSLClass.AdicionarSignatureElement(ConteudoXML: String;
  AddX509Data: Boolean; docElement, IdSignature: String): String;
var
  URI, TagEndDocElement: String;
  I: Integer;
begin
  URI := ExtraiURI(ConteudoXML);

  TagEndDocElement := '</' + docElement + '>';
  I := PosLast(TagEndDocElement, ConteudoXML);
  if I = 0 then
    raise EACBrDFeException.Create('N�o encontrei final do elemento: ' + TagEndDocElement);

  Result := copy(ConteudoXML, 1, I - 1) +
            SignatureElement(URI, AddX509Data, IdSignature) + TagEndDocElement;
end;

function TDFeSSLClass.AjustarXMLAssinado(const ConteudoXML: String): String;
var
  XmlAss: String;
  PosIni, PosFim: Integer;
begin
  XmlAss := ConteudoXML;

  // Removendo quebras de linha //
  XmlAss := StringReplace(XmlAss, #10, '', [rfReplaceAll]);
  XmlAss := StringReplace(XmlAss, #13, '', [rfReplaceAll]);

  // Removendo espa�os desnecess�rios, do Elemento da Assinatura //
  PosIni := PosLast('<SignatureValue>', XmlAss) + length('<SignatureValue>');
  XmlAss := copy(XmlAss, 1, PosIni - 1) + StringReplace(
    copy(XmlAss, PosIni, length(XmlAss)), ' ', '', [rfReplaceAll]);

  // Considerando apenas o �ltimo Certificado X509, da assinatura //
  PosIni := PosEx('<X509Certificate>', XmlAss, PosIni) - 1;
  PosFim := PosLast('<X509Certificate>', XmlAss);
  XmlAss := copy(XmlAss, 1, PosIni) + copy(XmlAss, PosFim, length(XmlAss));

  Result := XmlAss;
end;

end.

