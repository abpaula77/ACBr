{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }

{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
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

unit ACBrDFeWebService;

interface

uses Classes, SysUtils,
  {$IFNDEF NOGUI}
   {$IFDEF CLX} QDialogs,{$ELSE} Dialogs,{$ENDIF}
  {$ENDIF}
  ACBrDFeConfiguracoes, ACBrDFe;

type

  { TDFeWebService }

  TDFeWebService = class
  private
    function GetRetornoWS: String;
    function GetRetWS: String;
  protected
    FPSoapVersion: String;
    FPSoapEnvelopeAtributtes: String;
    FPHeaderElement: String;
    FPBodyElement: String;

    FPCabMsg: String;
    FPDadosMsg: String;
    FPEnvelopeSoap: String;
    FPRetornoWS: String;
    FPRetWS: String;
    FPMsg: String;
    FPURL: String;
    FPVersaoServico: String;
    FPConfiguracoes: TConfiguracoes;
    FPDFeOwner: TACBrDFe;
    FPArqEnv: String;
    FPArqResp: String;
    FPServico: String;
    FPSoapAction: String;
    FPMimeType: String;
  protected
    procedure FazerLog(Msg: String; Exibir: Boolean = False); virtual;
    procedure GerarException(Msg: String; E: Exception = nil); virtual;

    procedure InicializarServico; virtual;
    procedure DefinirServicoEAction; virtual;
    procedure DefinirURL; virtual;
    procedure DefinirDadosMsg; virtual;
    procedure DefinirEnvelopeSoap; virtual;
    procedure SalvarEnvio; virtual;
    procedure EnviarDados; virtual;
    function TratarResposta: Boolean; virtual;
    procedure SalvarResposta; virtual;
    procedure FinalizarServico; virtual;

    function GetUrlWsd: String;

    procedure AssinarXML(const AXML, docElement, infElement: String;
      MsgErro: String; SignatureNode: String = '';
      SelectionNamespaces: String = ''; IdSignature: String = '' ); virtual;

    function GerarMsgLog: String; virtual;
    function GerarMsgErro(E: Exception): String; virtual;
    function GerarCabecalhoSoap: String; virtual;
    function GerarVersaoDadosSoap: String; virtual;
    function GerarUFSoap: String; virtual;
    function GerarPrefixoArquivo: String; virtual;
  public
    constructor Create(AOwner: TACBrDFe); virtual;
    procedure Clear; virtual;

    function Executar: Boolean; virtual;

    property SoapVersion: String read FPSoapVersion;
    property SoapEnvelopeAtributtes: String read FPSoapEnvelopeAtributtes;

    property HeaderElement: String read FPHeaderElement;
    property BodyElement: String read FPBodyElement;

    property Servico: String read FPServico;
    property SoapAction: String read FPSoapAction;
    property MimeType: String read FPMimeType;
    property URL: String read FPURL;
    property VersaoServico: String read FPVersaoServico;
    property CabMsg: String read FPCabMsg;
    property DadosMsg: String read FPDadosMsg;
    property EnvelopeSoap: String read FPEnvelopeSoap;
    property RetornoWS: String read GetRetornoWS;
    property RetWS: String read GetRetWS;
    property Msg: String read FPMsg;
    property ArqEnv: String read FPArqEnv;
    property ArqResp: String read FPArqResp;
  end;

implementation

uses
  ACBrDFeUtil, ACBrDFeException, ACBrUtil, pcnGerador;

{ TDFeWebService }

constructor TDFeWebService.Create(AOwner: TACBrDFe);
begin
  FPDFeOwner := AOwner;
  FPConfiguracoes := AOwner.Configuracoes;

  FPSoapVersion := 'soap12';
  FPHeaderElement := 'nfeCabecMsg';
  FPBodyElement := 'nfeDadosMsg';
  FPSoapEnvelopeAtributtes :=
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
    'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' +
    'xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"';

  FPCabMsg := '';
  FPURL := '';
  FPVersaoServico := '';
  FPArqEnv := '';
  FPArqResp := '';
  FPServico := '';
  FPSoapAction := '';
  FPMimeType := '';  // Vazio, usar� por default: 'application/soap+xml'

  Clear;
end;

procedure TDFeWebService.Clear;
begin
  FPDadosMsg := '';
  FPRetornoWS := '';
  FPRetWS := '';
  FPMsg := '';
end;

function TDFeWebService.Executar: Boolean;
var
  ErroMsg: String;
begin
  { Sobrescrever apenas se realmente necess�rio }

  InicializarServico;
  try
    DefinirDadosMsg;
    DefinirEnvelopeSoap;
    SalvarEnvio;

    try
      EnviarDados;
      Result := TratarResposta;
      FazerLog(GerarMsgLog, True);
      SalvarResposta;
    except
      on E: Exception do
      begin
        Result := False;
        ErroMsg := GerarMsgErro(E);
        GerarException(ErroMsg, E);
      end;
    end;
  finally
    FinalizarServico;
  end;
end;

procedure TDFeWebService.InicializarServico;
begin
  { Sobrescrever apenas se necess�rio }
  Clear;

  DefinirURL;
  if URL = '' then
    GerarException( ACBrStr('URL n�o definida para: ') + ClassName);

  DefinirServicoEAction;
  if Servico = '' then
    GerarException( ACBrStr('Servico n�o definido para: ')+ ClassName);

  if SoapAction = '' then
    GerarException( ACBrStr('SoapAction n�o definido para: ') + ClassName);
end;

procedure TDFeWebService.DefinirServicoEAction;
begin
  { sobrescrever, OBRIGATORIAMENTE }

  FPServico := '';
  FPSoapAction := '';

  GerarException(ACBrStr('DefinirServicoEAction n�o implementado para: ') + ClassName);
end;

procedure TDFeWebService.DefinirURL;
begin
  { sobrescrever OBRIGATORIAMENTE.
    Voc� tamb�m pode mudar apenas o valor de "FLayoutServico" na classe
    filha e chamar: Inherited;     }

  GerarException(ACBrStr('DefinirURL n�o implementado para: ') + ClassName);
end;


procedure TDFeWebService.DefinirDadosMsg;
begin
  { sobrescrever, OBRIGATORIAMENTE }

  FPDadosMsg := '';

  GerarException(ACBrStr('DefinirDadosMsg n�o implementado para: ') + ClassName);
end;


procedure TDFeWebService.DefinirEnvelopeSoap;
var
  Texto: String;
begin
  { Sobrescrever apenas se necess�rio }

  {$IFDEF FPC}
   Texto := '<' + ENCODING_UTF8 + '>';    // Envelope j� est� sendo montado em UTF8
  {$ELSE}
   Texto := '';  // Isso for�ar� a convers�o para UTF8, antes do envio
  {$ENDIF}

  Texto := Texto + '<' + FPSoapVersion + ':Envelope ' + FPSoapEnvelopeAtributtes + '>';
  if NaoEstaVazio(FPHeaderElement) then
  begin
    Texto := Texto + '<' + FPSoapVersion + ':Header>';
    Texto := Texto + '<' + FPHeaderElement + ' xmlns="' + Servico + '">';
    Texto := Texto + GerarCabecalhoSoap;
    Texto := Texto + '</' + FPHeaderElement + '>';
    Texto := Texto + '</' + FPSoapVersion + ':Header>';
  end;
  Texto := Texto + '<' + FPSoapVersion + ':Body>';
  Texto := Texto + '<' + FPBodyElement + ' xmlns="' + Servico + '">';
  Texto := Texto + DadosMsg;
  Texto := Texto + '</' + FPBodyElement + '>';
  Texto := Texto + '</' + FPSoapVersion + ':Body>';
  Texto := Texto + '</' + FPSoapVersion + ':Envelope>';

  FPEnvelopeSoap := Texto;
end;

function TDFeWebService.GerarUFSoap: String;
begin
  Result := '<cUF>' + IntToStr(FPConfiguracoes.WebServices.UFCodigo) + '</cUF>';
end;

function TDFeWebService.GerarVersaoDadosSoap: String;
begin
  { sobrescrever, OBRIGATORIAMENTE }

  Result := '';
  GerarException(ACBrStr('GerarVersaoDadosSoap n�o implementado para: ') + ClassName);
end;

procedure TDFeWebService.EnviarDados;
Var
  Tentar, Tratado: Boolean;
begin
  { Sobrescrever apenas se necess�rio }

  FPRetWS := '';
  FPRetornoWS := '';

  { Verifica se precisa converter o Envelope para UTF8 antes de ser enviado.
     Entretanto o Envelope pode j� ter sido convertido antes, como por exemplo,
     para assinatura.
     Se o XML est� assinado, n�o deve modificar o conte�do }
  if not XmlEstaAssinado(FPEnvelopeSoap) then
    FPEnvelopeSoap := ConverteXMLtoUTF8(FPEnvelopeSoap);

  Tentar := True;
  while Tentar do
  begin
    Tentar := False;
    Tratado := False;

    if (FPConfiguracoes.Certificados.NumeroSerie <> '') then  // Tem Certificado carregado ?
      if FPConfiguracoes.Certificados.VerificarValidade then
         if (FPDFeOwner.SSL.CertDataVenc < Now) then
           raise EACBrDFeException.Create('Data de Validade do Certificado j� expirou: '+
                                          FormatDateBr(FPDFeOwner.SSL.CertDataVenc));

    try
      FPRetornoWS := FPDFeOwner.SSL.Enviar(FPEnvelopeSoap, FPURL, FPSoapAction, FPMimeType);
    except
      if Assigned(FPDFeOwner.OnTransmitError) then
        FPDFeOwner.OnTransmitError( FPDFeOwner.SSL.HTTPResultCode,
                                    FPDFeOwner.SSL.InternalErrorCode,
                                    FPURL, FPEnvelopeSoap, FPSoapAction,
                                    Tentar, Tratado) ;

      if not (Tentar or Tratado) then
        raise;
    end;
  end;

  { Resposta sempre � UTF8, ParseTXT chamar� DecodetoString, que converter�
    de UTF8 para o formato nativo de  String usada pela IDE }
  FPRetornoWS := ParseText(FPRetornoWS, True, True);
end;

function TDFeWebService.GerarPrefixoArquivo: String;
begin
  Result := FormatDateTime('yyyymmddhhnnss', Now);
end;

procedure TDFeWebService.SalvarEnvio;
var
  Prefixo, ArqEnv: String;
begin
  { Sobrescrever apenas se necess�rio }

  if FPArqEnv = '' then
    exit;

  Prefixo := GerarPrefixoArquivo;

  if FPConfiguracoes.Geral.Salvar then
  begin
    ArqEnv := Prefixo + '-' + FPArqEnv + '.xml';
    FPDFeOwner.Gravar(ArqEnv, FPDadosMsg);
  end;

  if FPConfiguracoes.WebServices.Salvar then
  begin
    ArqEnv := Prefixo + '-' + FPArqEnv + '-soap.xml';
    FPDFeOwner.Gravar(ArqEnv, FPEnvelopeSoap);
  end;
end;

procedure TDFeWebService.SalvarResposta;
var
  Prefixo, ArqResp: String;
begin
  { Sobrescrever apenas se necess�rio }

  if FPArqResp = '' then
    exit;

  Prefixo := GerarPrefixoArquivo;

  if FPConfiguracoes.Geral.Salvar then
  begin
    ArqResp := Prefixo + '-' + FPArqResp + '.xml';
    FPDFeOwner.Gravar(ArqResp, RetWS);  // Converte para UTF8 se necessas�rio
  end;

  if FPConfiguracoes.WebServices.Salvar then
  begin
    ArqResp := Prefixo + '-' + FPArqResp + '-soap.xml';
    FPDFeOwner.Gravar(ArqResp, RetornoWS );    // Converte para UTF8 se necessas�rio
  end;
end;

function TDFeWebService.GerarMsgLog: String;
begin
  { sobrescrever, se quiser Logar }

  Result := '';
end;

function TDFeWebService.TratarResposta: Boolean;
begin
  { sobrescrever, OBRIGATORIAMENTE }

  Result := False;
  GerarException(ACBrStr('TratarResposta n�o implementado para: ') + ClassName);
end;

procedure TDFeWebService.FazerLog(Msg: String; Exibir: Boolean);
var
  Tratado: Boolean;
begin
  if (Msg <> '') then
  begin
    FPDFeOwner.FazerLog(Msg, Tratado);

    if Tratado then
      exit;

    {$IFNDEF NOGUI}
    if Exibir and FPConfiguracoes.WebServices.Visualizar then
      ShowMessage(Msg);
    {$ENDIF}
  end;
end;

procedure TDFeWebService.GerarException(Msg: String; E: Exception);
begin
  FPDFeOwner.GerarException(Msg, E);
end;

function TDFeWebService.GerarMsgErro(E: Exception): String;
begin
  { Sobrescrever com mensagem adicional, se desejar }

  Result := '';
end;

function TDFeWebService.GerarCabecalhoSoap: String;
begin
  { Sobrescrever apenas se necess�rio }

  Result := GerarUFSoap + GerarVersaoDadosSoap;
end;

procedure TDFeWebService.FinalizarServico;
begin
  { Sobrescrever apenas se necess�rio }

end;

function TDFeWebService.GetRetornoWS: String;
begin
  { FPRetornoWS, foi convertido de UTF8 para a String nativa da IDE no final
    de "EnviarDados", ap�s o tratamento de ParseText..
    Convertendo para UTF8 novamente, se no inicio do XML contiver tag de UTF8 }
  if XmlEhUTF8(FPRetornoWS) then
    Result := ACBrStrToUTF8(FPRetornoWS)
  else
    Result := FPRetornoWS;
end;

function TDFeWebService.GetRetWS: String;
begin
  { FPRetornoWS e FPRetWS, foram convertidos de UTF8 para a String nativa da IDE
    Convertendo para UTF8 novamente, se no inicio do XML contiver tag de UTF8 }
  if XmlEhUTF8(FPRetWS) then
    Result := ACBrStrToUTF8(FPRetWS)
  else
    Result := FPRetWS;
end;

function TDFeWebService.GetUrlWsd: String;
begin
  Result := FPDFeOwner.GetNameSpaceURI+'/wsdl/';
end;

procedure TDFeWebService.AssinarXML(const AXML, docElement, infElement: String;
  MsgErro: String; SignatureNode: String; SelectionNamespaces: String;
  IdSignature: String);
begin
  try
    FPDadosMsg := FPDFeOwner.SSL.Assinar(AXML, docElement, infElement,
                     SignatureNode, SelectionNamespaces, IdSignature);
  except
    On E: Exception do
    begin
      if NaoEstaVazio(MsgErro) then
        MsgErro := MsgErro + sLineBreak ;

      MsgErro := MsgErro + E.Message;
      GerarException(MsgErro);
    end
  end;
end;

end.

