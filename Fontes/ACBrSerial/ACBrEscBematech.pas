{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

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
{ http://www.opensource.org/licenses/gpl-license.php                           }

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 20/04/2013:  Daniel Sim�es de Almeida
|*   Inicio do desenvolvimento
******************************************************************************}

{$I ACBr.inc}

unit ACBrEscBematech;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrEscPosEpson, ACBrConsts;

type

  { TACBrEscBematech }

  TACBrEscBematech = class(TACBrEscPosEpson)
  private
  public
    constructor Create(AOwner: TACBrPosPrinter);

    function ComandoCodBarras(const ATag: String; ACodigo: AnsiString): AnsiString;
      override;
    function ComandoQrCode(ACodigo: AnsiString): AnsiString; override;
    function ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString;
      override;
    function ComandoLogo: AnsiString; override;

    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); override;
    function LerInfo: String; override;
  end;


implementation

Uses
  strutils,
  ACBrUtil;

{ TACBrEscBematech }

constructor TACBrEscBematech.Create(AOwner: TACBrPosPrinter);
Var
  ModoEscBema: AnsiString;
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscBematech';

  ModoEscBema := GS + #249 + #32 + #0;

{(*}
  with Cmd  do
  begin
    Zera                    := ESC + '@' + ModoEscBema ;
    LigaNegrito             := ESC + 'E';
    DesligaNegrito          := ESC + 'F';
    LigaExpandido           := ESC + 'W' + #1;
    DesligaExpandido        := ESC + 'W' + #0;
    LigaInvertido           := '';  // Modo EscBema n�o suporta
    DesligaInvertido        := '';  // Modo EscBema n�o suporta
    LigaItalico             := ESC + '4';
    DesligaItalico          := ESC + '5';
    LigaCondensado          := ESC + SI;
    DesligaCondensado       := ESC + 'H';
    FonteNormal             := ESC + '!' + #0 + DesligaCondensado + DesligaItalico;
    FonteA                  := DesligaCondensado;
    FonteB                  := LigaCondensado;
    CorteTotal              := ESC + 'w';
    CorteParcial            := ESC + 'm';
    AbreGaveta              := ESC + 'v' + #200;
  end;
  {*)}
end;

function TACBrEscBematech.ComandoCodBarras(const ATag: String;
  ACodigo: AnsiString): AnsiString;
begin
  Result := inherited ComandoCodBarras(ATag, ACodigo);
end;

function TACBrEscBematech.ComandoQrCode(ACodigo: AnsiString): AnsiString;
var
  cTam1, cTam2: Integer;
begin
  if (Length(ACodigo) > 255) then
  begin
    cTam1 := Length(ACodigo) mod 255;
    cTam2 := Length(ACodigo) div 255;
  end
  else
  begin
    cTam1 := Length(ACodigo);
    cTam2 := 0;
  end;

  with fpPosPrinter.ConfigQRCode do
  begin
    Result := GS  + 'kQ' + // Codigo QRCode
              AnsiChr(ErrorLevel) +
              AnsiChr(0) + AnsiChr(LarguraModulo) +
              AnsiChr(Tipo) +
              AnsiChr(cTam1) + AnsiChr(cTam2) + ACodigo;
  end;
end;

function TACBrEscBematech.ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo
  ): AnsiString;
var
  CmdPag: Integer;
begin
  case APagCodigo of
    pc437: CmdPag := 3;
    pc850: CmdPag := 2;
    pc860: CmdPag := 4;
    pcUTF8: CmdPag := 8;
  else
    begin
      Result := '';
      Exit;
    end;
  end;

  Result := ESC + 't' + AnsiChr( CmdPag );
end;

function TACBrEscBematech.ComandoLogo: AnsiString;
var
  m: Integer;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    m := 0;
    if FatorX > 1 then
      m := m + 1;
    if Fatory > 1 then
      m := m + 2;

    Result := FS + 'p' + AnsiChr( StrToIntDef( chr(KeyCode1) + chr(KeyCode2), 1)) + AnsiChr(m);
  end;
end;

procedure TACBrEscBematech.LerStatus(var AStatus: TACBrPosPrinterStatus);
var
  B: Byte;
  OldAtivo: Boolean;
  Ret: AnsiString;
begin
  if not fpPosPrinter.Device.IsSerialPort then exit;

  OldAtivo := fpPosPrinter.Ativo;
  try
    try
      fpPosPrinter.Ativo := True;

      Ret := fpPosPrinter.TxRx( GS + #248 + '1', 5, 500 );
      B := Ord(Ret[1]);

      if TestBit(B, 2) then
        AStatus := AStatus + [stImprimindo];  // Overrun
      if TestBit(B, 3) then
        AStatus := AStatus + [stOffLine];
      if TestBit(B, 4) then
        AStatus := AStatus + [stImprimindo];

      B := Ord(Ret[2]);
      if TestBit(B, 1) then
        AStatus := AStatus + [stPoucoPapel];
      if TestBit(B, 2) then
        AStatus := AStatus + [stSemPapel];
      if not TestBit(B, 4) then
        AStatus := AStatus + [stGavetaAberta];
      if TestBit(B, 5) then
        AStatus := AStatus + [stSemPapel];
      if TestBit(B, 6) then
        AStatus := AStatus + [stErro];
      if not TestBit(B, 7) then
        AStatus := AStatus + [stTampaAberta];
    except
      AStatus := AStatus + [stErro];
    end;
  finally
    fpPosPrinter.Ativo := OldAtivo ;
  end;
end;

function TACBrEscBematech.LerInfo: String;
var
  Ret: AnsiString;
  InfoCmd, Info: String;
  OldAtivo: Boolean;
  B: Byte;

  Procedure AddInfo( Titulo: String; AInfo: AnsiString);
  begin
    Info := Info + Titulo+'='+AInfo + sLineBreak;
  end;

begin
  if not fpPosPrinter.Device.IsSerialPort then exit;

  OldAtivo := fpPosPrinter.Ativo;
  try
    fpPosPrinter.Ativo := True;
    Info := '';

    InfoCmd := GS + #249 + #39;

    Ret := fpPosPrinter.TxRx( InfoCmd + #0, 10, 500 );
    AddInfo('Modelo', Ret);

    Ret := fpPosPrinter.TxRx( InfoCmd + #1, 0, 500 );
    AddInfo('Serial', Ret);

    Ret := fpPosPrinter.TxRx( InfoCmd + #3, 3, 500 );
    AddInfo('Firmware', Ret);

    Ret := fpPosPrinter.TxRx( GS + #248 + '1', 5, 500 );
    B := Ord(Ret[3]);
    Info := Info + 'Guilhotina='+IfThen(TestBit(B, 2),'0','1') + sLineBreak ;

    Result := Info;
  finally
    fpPosPrinter.Ativo := OldAtivo;
  end;
end;

end.

