{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2016 Elias César Vieira                     }
{                                                                              }
{ Colaboradores nesse arquivo: Daniel Simões de Almeida                        }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{ Esse arquivo usa a classe  SynaSer   Copyright (c)2001-2003, Lukas Gebauer   }
{  Project : Ararat Synapse     (Found at URL: http://www.ararat.cz/synapse/)  }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Praça Anita Costa, 34 - Tatuí - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 11/05/2016: Elias César Vieira
|*  - Primeira Versao ACBrMTer
******************************************************************************}

{$I ACBr.inc}

unit ACBrMTer;

interface

uses
  Classes, SysUtils, Controls, ACBrBase, ACBrUtil, ACBrConsts, ACBrSocket,
  ACBrMTerClass, blcksock;

type

  TACBrMTerModelo = (mtrNenhum, mtrVT100, mtrStxEtx, mtrPMTG);

  { Evento disparado quando Conecta }
  TACBrMTerConecta = procedure(const IP: AnsiString) of object;

  { Evento disparado quando Desconecta }
  TACBrMTerDesconecta = procedure(const IP: AnsiString; Erro: Integer;
    ErroDesc: AnsiString) of object;

  { Evento disparado quando Recebe Dados }
  TACBrMTerRecebeDados = procedure(const IP: AnsiString; var
    Recebido: AnsiString) of object;

  { TACBrMTer }

  TACBrMTer = class(TACBrComponent)
  private
    fArqLog: String;
    fCmdEnviado: AnsiString;
    fModeloStr: String;
    fMTer: TACBrMTerClass;
    fModelo: TACBrMTerModelo;
    fEcoAuto: Boolean;
    fOnConecta: TACBrMTerConecta;
    fOnDesconecta: TACBrMTerDesconecta;
    fOnGravarLog: TACBrGravarLog;
    fOnRecebeDados: TACBrMTerRecebeDados;
    fTCPServer: TACBrTCPServer;
    function GetAtivo: Boolean;
    function GetIP: String;
    function GetPort: String;
    function GetTerminador: String;
    function GetTimeOut: Integer;
    procedure SetAtivo(AValue: Boolean);
    procedure SetIP(AValue: String);
    procedure SetModelo(AValue: TACBrMTerModelo);
    procedure SetPort(AValue: String);
    procedure SetTerminador(AValue: String);
    procedure SetTimeOut(AValue: Integer);

    procedure DoConecta(const TCPBlockSocket: TTCPBlockSocket;
      var Enviar: AnsiString);
    procedure DoDesconecta(const TCPBlockSocket: TTCPBlockSocket;
      Erro: Integer; ErroDesc: String);
    procedure DoRecebeDados(const TCPBlockSocket: TTCPBlockSocket;
      const Recebido: AnsiString; var Enviar: AnsiString);

    procedure EnviarComando(ASocket: TTCPBlockSocket; const ACmd: AnsiString); overload;
    function LerResposta(ASocket: TTCPBlockSocket; const aTimeOut: Integer;
      NumBytes: Integer = 0; Terminador: AnsiString = ''): AnsiString; overload;

    function BuscarPorIP(aIP: String): TTCPBlockSocket;
    function EncontrarConexao(aIP: String = ''): TTCPBlockSocket;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Ativar;
    procedure Desativar;
    procedure VerificarAtivo;

    procedure EnviarComando(const aIP: String; const ACmd: AnsiString); overload;
    function LerResposta(const aIP: String; const aTimeOut: Integer;
      NumBytes: Integer = 0; Terminador: AnsiString = ''): AnsiString; overload;

    procedure GravaLog(aString: String; Traduz: Boolean = False);

    procedure BackSpace(aIP: String);
    procedure Beep(aIP: String);
    procedure DeslocarCursor(aIP: String; aValue: Integer);
    procedure DeslocarLinha(aIP: String; aValue: Integer);
    procedure EnviarParaParalela(aIp, aDados: String);
    procedure EnviarParaSerial(aIP, aDados: String; aSerial: Integer);
    procedure EnviarTexto(aIP: String; aTexto: String);
    procedure LimparDisplay(aIP: String);
    procedure LimparLinha(aIP: String; aLinha: Integer);
    procedure PosicionarCursor(aIP: String; aLinha, aColuna: Integer);
    function Online(aIP: String): Boolean;

    property Ativo     : Boolean        read GetAtivo write SetAtivo;
    property CmdEnviado: AnsiString     read fCmdEnviado;
    property MTer      : TACBrMTerClass read fMTer;
    property ModeloStr : String         read fModeloStr;
    property TCPServer : TACBrTCPServer read fTCPServer;

  published
    property ArqLog    : String          read fArqLog       write fArqLog;
    property EcoAuto   : Boolean         read fEcoAuto      write fEcoAuto default False;
    property IP        : String          read GetIP         write SetIP;
    property Port      : String          read GetPort       write SetPort;
    property Terminador: String          read GetTerminador write SetTerminador;
    property TimeOut   : Integer         read GetTimeOut    write SetTimeOut;
    property Modelo    : TACBrMTerModelo read fModelo       write SetModelo default mtrNenhum;

    property OnConecta    : TACBrMTerConecta     read fOnConecta     write fOnConecta;
    property OnDesconecta : TACBrMTerDesconecta  read fOnDesconecta  write fOnDesconecta;
    property OnRecebeDados: TACBrMTerRecebeDados read fOnRecebeDados write fOnRecebeDados;
    property OnGravarLog  : TACBrGravarLog       read fOnGravarLog   write fOnGravarLog;
  end;


implementation

uses ACBrMTerVT100, ACBrMTerPMTG, ACBrMTerStxEtx;

{ TACBrMTer }

procedure TACBrMTer.SetPort(AValue: String);
begin
  if (fTCPServer.Port = AValue) then
    Exit;

  VerificarAtivo;
  fTCPServer.Port := AValue;
end;

procedure TACBrMTer.SetTerminador(AValue: String);
begin
  if (fTCPServer.Terminador = AValue) then
    Exit;

  VerificarAtivo;
  fTCPServer.Terminador := AValue;
end;

procedure TACBrMTer.SetTimeOut(AValue: Integer);
begin
  if (fTCPServer.TimeOut = AValue) then
    Exit;

  VerificarAtivo;
  fTCPServer.TimeOut := AValue;
end;

procedure TACBrMTer.DoConecta(const TCPBlockSocket: TTCPBlockSocket;
  var Enviar: AnsiString);
var
  wIP: String;
begin
  wIP := TCPBlockSocket.GetRemoteSinIP;

  GravaLog('Terminal: ' + wIP + ' Conectou');

  TCPBlockSocket.SendString(fMTer.ComandoBoasVindas);

  if Assigned(fOnConecta) then
    OnConecta(wIP);
end;

procedure TACBrMTer.DoDesconecta(const TCPBlockSocket: TTCPBlockSocket;
  Erro: Integer; ErroDesc: String);
var
  wIP: String;
begin
  wIP := TCPBlockSocket.GetRemoteSinIP;

  GravaLog('Terminal: ' + wIP + ' Desconectou');

  if Assigned(fOnDesconecta) then
    OnDesconecta(wIP, Erro, ErroDesc);
end;

procedure TACBrMTer.DoRecebeDados(const TCPBlockSocket: TTCPBlockSocket;
  const Recebido: AnsiString; var Enviar: AnsiString);
var
  wIP, wRecebido: AnsiString;
begin
  wIP := TCPBlockSocket.GetRemoteSinIP;

  GravaLog('Terminal: ' + wIP + ' - RecebeDados: ' + Recebido);

  wRecebido := fMTer.InterpretarResposta(Recebido);

  if (wRecebido = '') then
    Exit;

  if Assigned(fOnRecebeDados) then
    OnRecebeDados(wIP, wRecebido);

  if (EcoAuto) then
    Enviar := fMTer.ComandoEco(wRecebido);
end;

procedure TACBrMTer.EnviarComando(const aIP: String; const ACmd: AnsiString);
begin
  EnviarComando(EncontrarConexao(aIP), ACmd);
end;

procedure TACBrMTer.EnviarComando(ASocket: TTCPBlockSocket;
  const ACmd: AnsiString);
begin
  if Length(ACmd) < 1 then
    Exit;

  if (not Ativo) then
    raise Exception.Create(ACBrStr('Componente ACBrMTer não está ATIVO'));

  fCmdEnviado := ACmd;
  GravaLog('Terminal: ' + ASocket.GetRemoteSinIP + ' - Comando enviado: ' + ACmd);
  ASocket.SendString(ACmd);
end;

function TACBrMTer.LerResposta(const aIP: String; const aTimeOut: Integer;
  NumBytes: Integer; Terminador: AnsiString): AnsiString;
var
  aSocket: TTCPBlockSocket;
begin
  Result := LerResposta( EncontrarConexao(aIP), aTimeOut, NumBytes, Terminador );
end;

function TACBrMTer.LerResposta(ASocket: TTCPBlockSocket;
  const aTimeOut: Integer; NumBytes: Integer; Terminador: AnsiString
  ): AnsiString;
begin
  if NumBytes > 0 then
     Result := ASocket.RecvBufferStr( NumBytes, aTimeOut)
  else if Terminador <> '' then
     Result := ASocket.RecvTerminated( aTimeOut, Terminador)
  else
     Result := ASocket.RecvPacket( aTimeOut );
end;

function TACBrMTer.BuscarPorIP(aIP: String): TTCPBlockSocket;
var
  wIP: String;
  I: Integer;
begin
  // Procura IP nas conexões ativas.
  Result := Nil;
  wIP    :=  '';

  with fTCPServer.ThreadList.LockList do
  try
    for I := 0 to (Count - 1) do
    begin
      with TACBrTCPServerThread(Items[I]) do
      begin
        wIP := TCPBlockSocket.GetRemoteSinIP;

        if (aIP = wIP) or (aIP = OnlyNumber(wIP)) then
        begin
          Result := TCPBlockSocket;
          Break;
        end;
      end;
    end;
  finally
    fTCPServer.ThreadList.UnlockList;
  end;
end;

function TACBrMTer.EncontrarConexao(aIP: String): TTCPBlockSocket;
begin
  Result := Nil;
  aIP    := Trim(aIP);

  if (aIP = '') then
    Exit;

  Result := BuscarPorIP(aIP);

  if not Assigned(Result) then
    raise Exception.Create(ACBrStr('Terminal '+ QuotedStr(aIP) +' não encontrado'));
end;

procedure TACBrMTer.SetAtivo(AValue: Boolean);
begin
  if AValue then
    Ativar
  else
    Desativar;
end;

procedure TACBrMTer.SetIP(AValue: String);
begin
  if (fTCPServer.IP = AValue) then
    Exit;

  VerificarAtivo;
  fTCPServer.IP := AValue;
end;

procedure TACBrMTer.SetModelo(AValue: TACBrMTerModelo);
begin
  if (fModelo = AValue) then
    Exit;

  VerificarAtivo;
  FreeAndNil(fMTer);

  case AValue of
    mtrPMTG  : fMTer := TACBrMTerPMTG.Create(Self);
    mtrVT100 : fMTer := TACBrMTerVT100.Create(Self);
    mtrStxEtx: fMTer := TACBrMTerStxEtx.Create(Self);
  else
    fMTer := TACBrMTerClass.Create(Self);
  end;

  fModelo := AValue;
end;

function TACBrMTer.GetAtivo: Boolean;
begin
  Result := fTCPServer.Ativo;
end;

function TACBrMTer.GetIP: String;
begin
  Result := fTCPServer.IP;
end;

function TACBrMTer.GetPort: String;
begin
  Result := fTCPServer.Port;
end;

function TACBrMTer.GetTerminador: String;
begin
  Result := fTCPServer.Terminador;
end;

function TACBrMTer.GetTimeOut: Integer;
begin
  Result := fTCPServer.TimeOut;
end;

constructor TACBrMTer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Modelo  := mtrNenhum;
  EcoAuto := False;

  { Instanciando TACBrTCPServer }
  fTCPServer := TACBrTCPServer.Create(Self);
  fTCPServer.OnConecta     := DoConecta;
  fTCPServer.OnDesConecta  := DoDesconecta;
  fTCPServer.OnRecebeDados := DoRecebeDados;

  { Instanciando fMTer com modelo genérico }
  fMTer := TACBrMTerClass.Create(Self);
end;

destructor TACBrMTer.Destroy;
begin
  Desativar;

  if Assigned(fTCPServer) then
    FreeAndNil(fTCPServer);

  if Assigned(fMTer) then
    FreeAndNil(fMTer);

  inherited Destroy;
end;

procedure TACBrMTer.Ativar;
begin
  if Ativo then
    Exit;

  GravaLog(sLineBreak + StringOfChar('-', 80) + sLineBreak +
           'ATIVAR - ' + FormatDateTime('dd/mm/yy hh:nn:ss:zzz', Now) +
           ' - Modelo: ' + ModeloStr + ' - Porta: ' + fTCPServer.Port +
           ' - Terminador: ' + fTCPServer.Terminador +
           ' - Timeout: ' + IntToStr(fTCPServer.TimeOut) +
           sLineBreak + StringOfChar('-', 80) + sLineBreak);

  fTCPServer.Ativar;
end;

procedure TACBrMTer.Desativar;
begin
  if (not Ativo) then
    Exit;

  fTCPServer.Desativar;
end;

procedure TACBrMTer.VerificarAtivo;
begin
  if Ativo then
    raise Exception.Create(ACBrStr('Não é possível modificar as propriedades ' +
                                   'com ACBrMTer Ativo'));
end;

procedure TACBrMTer.GravaLog(aString: String; Traduz: Boolean);
var
  Tratado: Boolean;
begin
  Tratado := False;

  if Traduz then
    aString := TranslateUnprintable(aString);

  if Assigned(fOnGravarLog) then
    fOnGravarLog(aString, Tratado);

  if (not Tratado) then
    WriteLog(fArqLog, ' -- ' + FormatDateTime('dd/mm hh:nn:ss:zzz', Now) +
                      ' -- ' + aString);
end;

procedure TACBrMTer.BackSpace(aIP: String);
begin
  EnviarComando(aIP, fMTer.ComandoBackSpace);
end;

procedure TACBrMTer.Beep(aIP: String);
begin
  EnviarComando(aIP, fMTer.ComandoBeep);
end;

procedure TACBrMTer.DeslocarCursor(aIP: String; aValue: Integer);
begin
  // Desloca Cursor a partir da posição atual (Permite valores negativos)
  EnviarComando(aIP, fMTer.ComandoDeslocarCursor(aValue));
end;

procedure TACBrMTer.DeslocarLinha(aIP: String; aValue: Integer);
begin
  // Desloca Linha a partir da posição atual(Valores: 1 ou -1)
  EnviarComando(aIP, fMTer.ComandoDeslocarLinha(aValue));
end;

procedure TACBrMTer.EnviarParaParalela(aIp, aDados: String);
begin
  // Envia String para Porta Paralela
  EnviarComando(aIP, fMTer.ComandoEnviarParaParalela(aDados));
end;

procedure TACBrMTer.EnviarParaSerial(aIP, aDados: String; aSerial: Integer);
begin
  // Envia String para Porta Serial
  EnviarComando(aIP, fMTer.ComandoEnviarParaSerial(aDados, aSerial));
end;

procedure TACBrMTer.EnviarTexto(aIP: String; aTexto: String);
begin
  // Envia String para o Display
  EnviarComando(aIP, fMTer.ComandoEnviarTexto(aTexto));
end;

procedure TACBrMTer.LimparDisplay(aIP: String);
begin
  // Limpa Display e posiciona cursor em 0,0
  EnviarComando(aIP, fMTer.ComandoLimparDisplay);
end;

procedure TACBrMTer.LimparLinha(aIP: String; aLinha: Integer);
begin
  // Apaga Linha, mantendo cursor na posição atual
  EnviarComando(aIP, fMTer.ComandoLimparLinha(aLinha));
end;

procedure TACBrMTer.PosicionarCursor(aIP: String; aLinha, aColuna: Integer);
begin
  // Posiciona cursor na posição informada
  EnviarComando(aIP, fMTer.ComandoPosicionarCursor(aLinha, aColuna));
end;

function TACBrMTer.Online(aIP: String): Boolean;
var
  aSocket: TTCPBlockSocket;
  CmdOnLine, Resp: AnsiString;
begin
  Result := True;
  CmdOnLine := fMTer.ComandoOnline;

  if CmdOnLine = '' then   // protocolo não suporta comando OnLine
    Exit;

  aSocket := BuscarPorIP(aIP);
  // Desliga a Thread desta coenxão, para ler a resposta manualmente
  if aSocket.Owner is TACBrTCPServerThread then
    TACBrTCPServerThread(aSocket.Owner).Enabled := False;

  try
    EnviarComando(aSocket, CmdOnLine);
    Resp := LerResposta(aSocket, TimeOut, 0, TCPServer.Terminador);
  finally
    if aSocket.Owner is TACBrTCPServerThread then
      TACBrTCPServerThread(aSocket.Owner).Enabled := True;
  end;

  Result := (Resp <> '');
end;

end.


