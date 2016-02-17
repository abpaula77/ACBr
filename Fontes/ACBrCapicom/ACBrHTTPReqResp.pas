{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Classe para Lazarus/Free Pascal e Delphi para requisi��es SOAP com suporte  }
{ certificados A1 e A3 usando as bibliotecas WinINet e CAPICOM                 }
{ Direitos Autorais Reservados (c) 2014 Jean Patrick Figueiredo dos Santos     }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{ Colaboradores nesse arquivo:                                                 }
{                                       Juliomar Marchetti                     }
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

{******************************************************************************
|* Historico
|*
|* 15/01/2014: Jean Patrick Figueiredo dos Santos
|*  - Contribui��o da classe para o Projeto ACBr
******************************************************************************}

{$I ACBr.inc}

unit ACBrHTTPReqResp;

interface

uses
  Windows, Classes, SysUtils, wininet, ACBrCAPICOM_TLB;

type

  { EACBrHTTPReqResp }

  EACBrHTTPReqResp = class(Exception)
  public
    constructor Create(const Msg: String);
  end;

  { TACBrHTTPReqResp }

  TACBrHTTPReqResp = class
  private
    FCertificate: ICertificate2;
    FCertSerialNumber: String;
    FCertStoreName: String;
    FEncodeDataToUTF8: Boolean;
    FInternalErrorCode: Integer;
    FSOAPAction: String;
    FMimeType: String;
    // (ex.: 'application/soap+xml' ou 'text/xml' - que � o Content-Type)
    FCharsets: String; //  (ex.: 'ISO-8859-1,utf-8' - que � o Accept-Charset)
    FData: AnsiString;
    FProxyHost: String;
    FProxyPass: String;
    FProxyPort: String;
    FProxyUser: String;
    FHTTPResultCode: Integer;
    FTimeOut: Integer;
    FUrl: String;
    FUseCertificate: Boolean;
    FShowCertStore: Boolean;
    FUseSSL: Boolean;

    function GetWinInetError(ErrorCode: cardinal): String;
    function OpenCertStore: String;

    procedure UpdateErrorCodes(ARequest: HINTERNET);
  protected

  public
    constructor Create;

    property SOAPAction: String read FSOAPAction write FSOAPAction;
    property MimeType: String read FMimeType write FMimeType;
    property Charsets: String read FCharsets write FCharsets;
    property Url: String read FUrl write FUrl;
    property Data: AnsiString read FData write FData;
    property ProxyHost: String read FProxyHost write FProxyHost;
    property ProxyPort: String read FProxyPort write FProxyPort;
    property ProxyUser: String read FProxyUser write FProxyUser;
    property ProxyPass: String read FProxyPass write FProxyPass;
    property CertStoreName: String read FCertStoreName write FCertStoreName;
    property UseCertificate: Boolean read FUseCertificate write FUseCertificate;
    property UseSSL: Boolean read FUseSSL write FUseSSL;
    property ShowCertStore: Boolean read FShowCertStore write FShowCertStore;
    property EncodeDataToUTF8: Boolean read FEncodeDataToUTF8 write FEncodeDataToUTF8;
    property TimeOut: Integer read FTimeOut write FTimeOut;

    property HTTPResultCode: Integer read FHTTPResultCode;
    property InternalErrorCode: Integer read FInternalErrorCode;

    procedure SetCertificate(pCertSerialNumber: String); overload;
    procedure SetCertificate(pCertificate: ICertificate2); overload;
    procedure Execute(Resp: TStream); overload;
    procedure Execute(const DataMsg: String; Resp: TStream); overload;
  end;

  {$EXTERNALSYM CERT_CONTEXT}
  _CERT_CONTEXT = record
    dwCertEncodingType: longword;
    pbCertEncoded: ^byte;
    cbCertEncoded: longword;
    pCertInfo: Pointer;
    hCertStore: Pointer;
  end;

  {$EXTERNALSYM _CERT_CONTEXT}
  CERT_CONTEXT = _CERT_CONTEXT;

implementation

uses StrUtils, ACBrUtil, synautil;

{ EACBrHTTPReqResp }

constructor EACBrHTTPReqResp.Create(const Msg: String);
begin
  inherited Create(ACBrStr(Msg));
end;

{ TACBrHTTPReqResp }

function TACBrHTTPReqResp.GetWinInetError(ErrorCode: cardinal): String;
const
  winetdll = 'wininet.dll';
var
  Len: integer;
  Buffer: PChar;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM or
    FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, Pointer(GetModuleHandle(winetdll)),
    ErrorCode, 0, @Buffer, SizeOf(Buffer), nil);
  try
    while (Len > 0) and
     {$IFDEF DELPHI12_UP}
      (CharInSet(Buffer[Len - 1], [#0..#32, '.']))
     {$ELSE}
      (Buffer[Len - 1] in [#0..#32, '.'])
     {$ENDIF}
      do
    begin
      Dec(Len);
    end;

    SetString(Result, Buffer, Len);
  finally
    LocalFree(HLOCAL(Buffer));
  end;
end;

function TACBrHTTPReqResp.OpenCertStore: String;
var
  Store: IStore3;
  Certs: ICertificates2;
  Certs2: ICertificates2;
  Cert: ICertificate2;
  FNumeroSerie: WideString;
begin
  Store := CoStore.Create;
  try
    Store.Open(CAPICOM_CURRENT_USER_STORE, FCertStoreName, CAPICOM_STORE_OPEN_READ_ONLY);

    Certs := Store.Certificates as ICertificates2;

    Certs2 := Certs.Select(ACBrStr('Certificado(s) Digital(is) dispon�vel(is)'),
      'Selecione o Certificado Digital para uso no aplicativo', False);

    if not (Certs2.Count = 0) then
    begin
      Cert := IInterface(Certs2.Item[1]) as ICertificate2;
      FNumeroSerie := Cert.SerialNumber;
    end;
  finally
    FreeAndNil(Store);
  end;

  Result := FNumeroSerie;
end;

procedure TACBrHTTPReqResp.UpdateErrorCodes(ARequest: HINTERNET);
Var
  dummy, bufLen: DWORD;
  aBuffer: array [0..512] of AnsiChar;
begin
  FInternalErrorCode := GetLastError;

  dummy := 0;
  bufLen := Length(aBuffer);
  if not HttpQueryInfo(ARequest, HTTP_QUERY_STATUS_CODE, @aBuffer, bufLen, dummy ) then
    FHTTPResultCode := 4
  else
    FHTTPResultCode := StrToIntDef( StrPas(aBuffer), 0);
end;

procedure TACBrHTTPReqResp.SetCertificate(pCertSerialNumber: String);
begin
  if FCertSerialNumber = pCertSerialNumber then
    Exit;
  FCertSerialNumber := pCertSerialNumber;
  FCertificate := nil;
end;

procedure TACBrHTTPReqResp.SetCertificate(pCertificate: ICertificate2);
begin
  if FCertificate = pCertificate then
    Exit;
  FCertificate := pCertificate;
  FCertSerialNumber := '';
end;

procedure TACBrHTTPReqResp.Execute(const DataMsg: String; Resp: TStream);
begin
  Data := DataMsg;
  Execute(Resp);
end;

procedure TACBrHTTPReqResp.Execute(Resp: TStream);
var
  aBuffer: array[0..4096] of AnsiChar;
  BytesRead: cardinal;
  pSession: HINTERNET;
  pConnection: HINTERNET;
  pRequest: HINTERNET;
  flags: longword;

  Store: IStore;
  Certs: ICertificates;
  Cert: ICertificate2;
  Cert2: ICertificate2;
  CertContext: ICertContext;
  PCertContext: Pointer;

  Ok: Boolean;
  i, AccessType: Integer;
  ANone, AHost, AProt, APort, APath, pProxy, Header: String;
begin

  if (FUseCertificate) then
    FUseSSL := True;

  AProt := '';
  APort := '';
  APath := '';

  ParseURL(FUrl, AProt, ANone, ANone, AHost, APort, APath, ANone);

  if ((ShowCertStore) or ((FCertSerialNumber = '') and (FCertificate = nil))) then
  begin
    FCertSerialNumber := OpenCertStore;
    if FCertSerialNumber <> '' then
      FCertificate := nil;
  end;

  if FCertSerialNumber <> '' then
  begin
    Store := CoStore.Create;
    Store.Open(CAPICOM_CURRENT_USER_STORE, FCertStoreName, CAPICOM_STORE_OPEN_READ_ONLY);

    Certs := Store.Certificates as ICertificates2;

    if Certs.Count > 0 then
    begin
      for i := 1 to Certs.Count do
      begin
        Cert2 := IInterface(Certs.Item[i]) as ICertificate2;
        if Cert2.SerialNumber = FCertSerialNumber then
        begin
          Cert := Cert2;
          break;
        end;
      end;

      CertContext := Cert as ICertContext;
    end;
  end
  else
  begin
    CertContext := FCertificate as ICertContext;
  end;

  if FProxyHost <> '' then
  begin
    AccessType := INTERNET_OPEN_TYPE_PROXY;
    if (FProxyPort <> '') and (FProxyPort <> '0') then
      pProxy := FProxyHost + ':' + FProxyPort
    else
      pProxy := FProxyHost;
  end
  else
    AccessType := INTERNET_OPEN_TYPE_PRECONFIG;

  //DEBUG
  //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo sess�o');

  CertContext.Get_CertContext(integer(PCertContext));
  pSession := InternetOpen(PChar('Borland SOAP 1.2'), AccessType, PChar(pProxy), nil, 0);

  try
    if not Assigned(pSession) then
      raise EACBrHTTPReqResp.Create('Erro: Internet Open or Proxy');

    //DEBUG
    //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Ajustando TimeOut: '+IntToStr(FTimeOut));

    if not InternetSetOption(pSession, INTERNET_OPTION_CONNECT_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise EACBrHTTPReqResp.Create('Erro ao definir TimeOut de Conex�o');

    if not InternetSetOption(pSession, INTERNET_OPTION_SEND_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise EACBrHTTPReqResp.Create('Erro ao definir TimeOut de Envio');

    if not InternetSetOption(pSession, INTERNET_OPTION_DATA_SEND_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise EACBrHTTPReqResp.Create('Erro ao definir TimeOut de Envio');

    if not InternetSetOption(pSession, INTERNET_OPTION_RECEIVE_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise EACBrHTTPReqResp.Create('Erro ao definir TimeOut de Recebimento');

    if not InternetSetOption(pSession, INTERNET_OPTION_DATA_RECEIVE_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise EACBrHTTPReqResp.Create('Erro ao definir TimeOut de Recebimento');

    if APort = '' then
    begin
      if (FUseSSL) then
        APort := IntToStr(INTERNET_DEFAULT_HTTPS_PORT)
      else
        APort := IntToStr(INTERNET_DEFAULT_HTTP_PORT);
    end;

    //Debug, TimeOut Test
    //AHost := 'www.google.com';
    //port := 81;

    //DEBUG
    //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo Conex�o: '+AHost+':'+APort);

    pConnection := InternetConnect(pSession, PChar(AHost), StrToInt(APort),
      PChar(FProxyUser), PChar(FProxyPass), INTERNET_SERVICE_HTTP, 0, 0{cardinal(Self)});
    if not Assigned(pConnection) then
      raise EACBrHTTPReqResp.Create('Erro: Internet Connect or Host');

    try
      if (FUseSSL) then
      begin
        flags := INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_NO_CACHE_WRITE;
        flags := flags or INTERNET_FLAG_SECURE;

        if (FUseCertificate) then
          flags := flags or (INTERNET_FLAG_IGNORE_CERT_CN_INVALID or
            INTERNET_FLAG_IGNORE_CERT_DATE_INVALID);
      end
      else
        flags := INTERNET_SERVICE_HTTP;

      //DEBUG
      //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Fazendo POST: '+APath);

      pRequest := HttpOpenRequest(pConnection, PChar('POST'),
        PChar(APath), nil, nil, nil, flags, 0);

      if not Assigned(pRequest) then
        raise EACBrHTTPReqResp.Create('Erro: Open Request');

      UpdateErrorCodes(pRequest);

      try
        if ( (APort <> IntToStr(INTERNET_DEFAULT_HTTP_PORT)) and (UpperCase(AProt) = 'HTTP') ) or
           ( (APort <> IntToStr(INTERNET_DEFAULT_HTTPS_PORT)) and (UpperCase(AProt) = 'HTTPS') ) then
          AHost := AHost +':'+ APort;

        Header := 'Host: ' + AHost + sLineBreak +
                  'Content-Type: ' + FMimeType + '; charset='+FCharsets + SLineBreak +
                  'Accept-Charset: ' + FCharsets + SLineBreak +
                  'SOAPAction: "' + FSOAPAction + '"' +SLineBreak;

        if (FUseCertificate) then
          if not InternetSetOption(pRequest, {$IFDEF FPC}INTERNET_OPTION_CLIENT_CERT_CONTEXT{$ELSE}84{$ENDIF},
            PCertContext, SizeOf(CERT_CONTEXT)) then
            raise EACBrHTTPReqResp.Create('Erro: Problema ao inserir o certificado');

        if trim(FProxyUser) <> '' then
          if not InternetSetOption(pRequest, INTERNET_OPTION_PROXY_USERNAME,
            PChar(FProxyUser), Length(FProxyUser)) then
            raise EACBrHTTPReqResp.Create('Erro: Proxy User');

        if trim(FProxyPass) <> '' then
          if not InternetSetOption(pRequest, INTERNET_OPTION_PROXY_PASSWORD,
            PChar(FProxyPass), Length(FProxyPass)) then
            raise EACBrHTTPReqResp.Create('Erro: Proxy Password');

        HttpAddRequestHeaders(pRequest, PChar(Header), Length(Header),
          HTTP_ADDREQ_FLAG_ADD);

        if FEncodeDataToUTF8 then
          FData := UTF8Encode(FData);

        //DEBUG
        //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Enviando Dados: '+APath);
        //WriteToTXT('c:\temp\httpreqresp.log', FData);

        Ok := False;
        Resp.Size := 0;
        if HttpSendRequest(pRequest, nil, 0, Pointer(FData), Length(FData)) then
        begin
          BytesRead := 0;
          //DEBUG
          //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Lendo Dados');

          while InternetReadFile(pRequest, @aBuffer, SizeOf(aBuffer), BytesRead) do
          begin
            //DEBUG
            //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Bytes Lido: '+IntToStr(BytesRead));

            if (BytesRead = 0) then
              Break;

            Resp.Write(aBuffer, BytesRead);
          end;

          if Resp.Size > 0 then
          begin
            Resp.Position := 0;

            //DEBUG
            //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Total Lido: '+IntToStr(Resp.Size));
            //Resp.Position := 0;
            //FData := ReadStrFromStream(Resp, Resp.Size);
            //Resp.Position := 0;
            //WriteToTXT('c:\temp\httpreqresp.log', FData);

            Ok := True;
          end;
        end;

        if not OK then
        begin
          UpdateErrorCodes(pRequest);

          //DEBUG
          //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+
          //   ' - Erro WinNetAPI: '+IntToStr(InternalErrorCode)+' HTTP: '+IntToStr(HTTPResultCode));

          raise EACBrHTTPReqResp.Create('Erro: Requisi��o n�o enviada.' +
            sLineBreak + IntToStr(InternalErrorCode) + ' - ' + GetWinInetError(InternalErrorCode));
        end;
      finally

        InternetCloseHandle(pRequest);
      end;
    finally
      InternetCloseHandle(pConnection);
    end;
  finally
    InternetCloseHandle(pSession);
    CertContext.FreeContext(integer(PCertContext));
  end;
end;

constructor TACBrHTTPReqResp.Create;
begin
  FMimeType := 'application/soap+xml';
  FCharsets := 'utf-8';
  FCertStoreName := 'My';
  FCertSerialNumber := '';
  FCertificate := nil;
  FUseCertificate := True;
  FUseSSL := True;
  FShowCertStore := False;
  FHTTPResultCode := 0;
  FEncodeDataToUTF8 := False;
end;

end.
