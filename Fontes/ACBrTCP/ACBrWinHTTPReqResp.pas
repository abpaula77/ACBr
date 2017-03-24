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

{$I ACBr.inc}
{.$Define DEBUG_WINHTTP}

unit ACBrWinHTTPReqResp;

interface

{$IfDef MSWINDOWS}
uses
  {$IFDEF DELPHIXE4_UP}
  AnsiStrings,
  {$ENDIF}
  Windows, Classes, SysUtils,
  ACBrWinReqRespClass,
  ACBr_WinCrypt, ACBr_WinHttp,
  blcksock;

type

  { TACBrWinHTTPReqResp }

  TACBrWinHTTPReqResp = class(TACBrWinReqResp)
  protected
    procedure UpdateErrorCodes(ARequest: HINTERNET); override;
  public
    procedure Execute(Resp: TStream); override;
  end;

implementation

uses synautil;

{ TACBrWinHTTPReqResp }

procedure TACBrWinHTTPReqResp.UpdateErrorCodes(ARequest: HINTERNET);
Var
  bufLen: DWORD;
  aBuffer: array [0..512] of AnsiChar;
begin
  FpInternalErrorCode := GetLastError;
  FpHTTPResultCode := 0;

  if Assigned(ARequest) then
  begin
    bufLen := Length(aBuffer);
    if not WinHttpQueryHeaders( ARequest,
                                WINHTTP_QUERY_STATUS_CODE,
                                WINHTTP_HEADER_NAME_BY_INDEX,
                                @aBuffer, @bufLen, WINHTTP_NO_HEADER_INDEX ) then
      FpHTTPResultCode := 4
    else
      FpHTTPResultCode := StrToIntDef( {$IFDEF DELPHIXE4_UP}AnsiStrings.{$ENDIF}StrPas(aBuffer), 0);
  end;
end;

procedure TACBrWinHTTPReqResp.Execute(Resp: TStream);
var
  aBuffer: array[0..4096] of AnsiChar;
  BytesRead, BytesWrite: cardinal;
  UseSSL, UseCertificate: Boolean;
  flags: Integer;
  ANone, AHost, AProt, APort, APath, AMethod, Header: String;
  wHeader: WideString;
  ConnectPort: WORD;
  RequestFlags, AccessType, flagsLen: DWORD;
  pSession, pConnection, pRequest: HINTERNET;
  HttpProxyName, HttpProxyPass: LPCWSTR;
  OpenRequestAcceptTypes: Pointer;
  {$IfDef DEBUG_WINHTTP}
   LogFile:String;
  {$EndIf}
begin
  {$IfDef DEBUG_WINHTTP}
  LogFile := 'c:\temp\winhttpreqresp.log';
  {$EndIf}

  AProt := '';
  AHost := '';
  APort := '';
  APath := '';
  ANone := '';
  AMethod := 'POST';

  ParseURL(Url, AProt, ANone, ANone, AHost, APort, APath, ANone);

  UseSSL := (UpperCase(AProt) = 'HTTPS');
  UseCertificate := UseSSL and Assigned( CertContext );

  if ProxyHost <> '' then
  begin
    AccessType := WINHTTP_ACCESS_TYPE_NAMED_PROXY;
    if (ProxyPort <> '') and (ProxyPort <> '0') then
      HttpProxyName := LPCWSTR( WideString(ProxyHost + ':' + ProxyPort) )
    else
      HttpProxyName := LPCWSTR( WideString(ProxyHost) );

    HttpProxyPass := LPCWSTR( WideString(ProxyPass) );
  end
  else
  begin
    AccessType := WINHTTP_ACCESS_TYPE_DEFAULT_PROXY;
    HttpProxyName := WINHTTP_NO_PROXY_NAME;
    HttpProxyPass := WINHTTP_NO_PROXY_BYPASS;
  end;

  {$IfDef DEBUG_WINHTTP}
   WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo sess�o');
  {$EndIf}

  pSession := WinHttpOpen( 'WinHTTP ACBr/1.0',
                           AccessType,
                           HttpProxyName,
                           HttpProxyPass,
                           0 );

  try
    if not Assigned(pSession) then
    begin
      UpdateErrorCodes(nil);
      raise EACBrWinReqResp.Create('Falha abrindo HTTP ou Proxy. Erro:' + GetWinInetError(FpInternalErrorCode));
    end;

    if (TimeOut > 0) then
    begin
      {$IfDef DEBUG_WINHTTP}
       WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Ajustando TimeOut: '+IntToStr(TimeOut));
      {$EndIf}
      if not WinHttpSetOption( pSession,
                               WINHTTP_OPTION_CONNECT_TIMEOUT,
                               @TimeOut,
                               SizeOf(TimeOut)) then
        raise EACBrWinReqResp.Create('Falha ajustando WINHTTP_OPTION_CONNECT_TIMEOUT. Erro:' + GetWinInetError(GetLastError));
    end;

    if UseSSL then
    begin
      case SSLType of
        LT_SSLv2:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_SSL2;
        LT_SSLv3:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_SSL3;
        LT_TLSv1:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_TLS1;
        LT_TLSv1_1:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1;
        LT_TLSv1_2:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2;
      else
        flags := WINHTTP_FLAG_SECURE_PROTOCOL_ALL;
      end;

      flagsLen := SizeOf(flags);
      if not WinHttpSetOption(pSession, WINHTTP_OPTION_SECURE_PROTOCOLS, @flags, flagsLen) then
        raise EACBrWinReqResp.Create('Falha ajustando WINHTTP_OPTION_SECURE_PROTOCOLS. Erro:' + GetWinInetError(GetLastError));
    end;

    if APort = '' then
    begin
      if (UseSSL) then
        ConnectPort := INTERNET_DEFAULT_HTTPS_PORT
      else
        ConnectPort := INTERNET_DEFAULT_HTTP_PORT;
    end
    else
      ConnectPort := StrToInt(APort);

    //Debug, TimeOut Test
    //AHost := 'www.google.com';
    //port := 81;

    {$IfDef DEBUG_WINHTTP}
     WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo Conex�o: '+AHost+':'+APort);
    {$EndIf}
    pConnection := WinHttpConnect( pSession,
                                   LPCWSTR(WideString(AHost)),
                                   ConnectPort,
                                   0);
    UpdateErrorCodes(Nil);
    if not Assigned(pConnection) then
      raise EACBrWinReqResp.Create('Falha ao conectar no Host. Erro:' + GetWinInetError(GetLastError));

    try
      if UseSSL then
        RequestFlags := WINHTTP_FLAG_SECURE
      else
        RequestFlags := 0;

      if Self.MimeType = '' then
        OpenRequestAcceptTypes := WINHTTP_DEFAULT_ACCEPT_TYPES
      else
        OpenRequestAcceptTypes := @Self.MimeType;

      {$IfDef DEBUG_WINHTTP}
       WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Fazendo POST: '+APath);
      {$EndIf}
      pRequest := WinHttpOpenRequest( pConnection,
                                      LPCWSTR(WideString(AMethod)),
                                      LPCWSTR(WideString(APath)),
                                      Nil,
                                      WINHTTP_NO_REFERER,
                                      OpenRequestAcceptTypes,
                                      RequestFlags);
      UpdateErrorCodes(pRequest);

      if not Assigned(pRequest) then
        raise EACBrWinReqResp.Create('Falha ao fazer requisi��o POST. Erro:' + GetWinInetError(GetLastError));

      try
        if (UseCertificate) then
        begin
          if not WinHttpSetOption(pRequest, WINHTTP_OPTION_CLIENT_CERT_CONTEXT,
                                   CertContext, SizeOf(CERT_CONTEXT)) then
            raise EACBrWinReqResp.Create('Falha ajustando WINHTTP_OPTION_CLIENT_CERT_CONTEXT. Erro:' + GetWinInetError(GetLastError))
        end;

        // Ignorando alguns erros de conex�o //
        flags := 0;
        flagsLen := SizeOf(flags);
        if not WinHttpQueryOption(pRequest, WINHTTP_OPTION_SECURITY_FLAGS, @flags, @flagsLen) then
          raise EACBrWinReqResp.Create('Falha lendo WINHTTP_OPTION_SECURITY_FLAGS. Erro:' + GetWinInetError(GetLastError));

        flags := flags or SECURITY_FLAG_IGNORE_UNKNOWN_CA or
                          SECURITY_FLAG_IGNORE_CERT_DATE_INVALID or
                          SECURITY_FLAG_IGNORE_CERT_CN_INVALID;
        if not WinHttpSetOption(pRequest, WINHTTP_OPTION_SECURITY_FLAGS, @flags, flagsLen) then
          raise EACBrWinReqResp.Create('Falha ajustando WINHTTP_OPTION_SECURITY_FLAGS. Erro:' + GetWinInetError(GetLastError));

        if EncodeDataToUTF8 then
          Self.Data := UTF8Encode(Self.Data);

        if ( (APort <> IntToStr(INTERNET_DEFAULT_HTTP_PORT)) and (not UseSSL) ) or
           ( (APort <> IntToStr(INTERNET_DEFAULT_HTTPS_PORT)) and (UseSSL) ) then
          AHost := AHost +':'+ APort;

        Header := 'Host: ' + AHost + sLineBreak +
                  'Content-Type: ' + Self.MimeType + '; charset='+Charsets + SLineBreak +
                  'Accept-Charset: ' + Charsets + SLineBreak;

        if Self.SOAPAction <> '' then
          Header := Header +'SOAPAction: "' + Self.SOAPAction + '"' +SLineBreak;

        wHeader := WideString(Header);

        {$IfDef DEBUG_WINHTTP}
         WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Fazendo Requisi��o: '+APath);
         WriteToTXT(LogFile, Header);
        {$EndIf}
        Resp.Size := 0;
        if not WinHttpSendRequest( pRequest,
                                   LPCWSTR(wHeader), Length(wHeader),
                                   WINHTTP_NO_REQUEST_DATA, 0,
                                   Length(Self.Data), 0) then
        begin
          UpdateErrorCodes(pRequest);
          raise EACBrWinReqResp.Create('Falha no Envio da Requisi��o.'+sLineBreak+
                                       GetWinInetError(FpInternalErrorCode));
        end;

        {$IfDef DEBUG_WINHTTP}
         WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Escrevendo Dados.');
         WriteToTXT(LogFile, Self.Data);
        {$EndIf}
        BytesWrite := 0;
        if not WinHttpWriteData( pRequest, PAnsiChar(Self.Data), Length(Self.Data), @BytesWrite) then
        begin
          UpdateErrorCodes(pRequest);
          raise EACBrWinReqResp.Create('Falha Enviando Dados. Erro:' + GetWinInetError(FpInternalErrorCode));
        end;

        {$IfDef DEBUG_WINHTTP}
         WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Lendo Dados');
        {$EndIf}
        if not WinHttpReceiveResponse( pRequest, nil) then
        begin
          UpdateErrorCodes(pRequest);
          raise EACBrWinReqResp.Create('Falha Recebendo Dados. Erro:' + GetWinInetError(FpInternalErrorCode));
        end;

        repeat
          BytesRead := 0;
          if not WinHttpReadData(pRequest, @aBuffer, SizeOf(aBuffer), @BytesRead) then
          begin
            UpdateErrorCodes(pRequest);
            raise EACBrWinReqResp.Create('Falha Lendo dados. Erro:' + GetWinInetError(FpInternalErrorCode));
          end;

          {$IfDef DEBUG_WINHTTP}
           WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Bytes Lido: '+IntToStr(BytesRead));
          {$EndIf}
          if (BytesRead > 0) then
            Resp.Write(aBuffer, BytesRead);
        until (BytesRead <= 0);

        if Resp.Size > 0 then
        begin
          Resp.Position := 0;
          {$IfDef DEBUG_WINHTTP}
           WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Total Lido: '+IntToStr(Resp.Size));
           Resp.Position := 0;
           Data := ReadStrFromStream(Resp, Resp.Size);
           Resp.Position := 0;
           WriteToTXT(LogFile, Data);
          {$EndIf}
        end;

        {$IfDef DEBUG_WINHTTP}
         WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+
            ' - Erro WinHTTP: '+IntToStr(InternalErrorCode)+' HTTP: '+IntToStr(HTTPResultCode));
        {$EndIf}
      finally
        WinHttpCloseHandle(pRequest);
      end;
    finally
      WinHttpCloseHandle(pConnection);
    end;
  finally
    WinHttpCloseHandle(pSession);
  end;
end;

{$Else}
implementation

{$EndIf}

end.

