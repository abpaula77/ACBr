{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }

{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }

{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/gpl-license.php                           }

{ Daniel Simões de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Praça Anita Costa, 34 - Tatuí - SP - 18270-410                  }

{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 20/04/2013:  Daniel Simões de Almeida
|*   Inicio do desenvolvimento
******************************************************************************}

{$I ACBr.inc}

unit ACBrEscDiebold;

interface

uses
  Classes, SysUtils, ACBrPosPrinter, ACBrEscPosEpson;

type

  { TACBrEscDiebold }

  TACBrEscDiebold = class(TACBrEscPosEpson)
  private
  public
    constructor Create(AOwner: TACBrPosPrinter);

    function ComandoCodBarras(const ATag: String; ACodigo: AnsiString): AnsiString;
      override;
    function ComandoQrCode(ACodigo: AnsiString): AnsiString; override;
    function ComandoLogo: AnsiString; override;
    function ComandoFonte(TipoFonte: TACBrPosTipoFonte; Ligar: Boolean): AnsiString; override;

    function LerInfo: String; override;
  end;


implementation

uses
  strutils, math,
  ACBrConsts, ACBrUtil;

{ TACBrEscDiebold }

constructor TACBrEscDiebold.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscDiebold';

{(*}
  with Cmd  do
  begin
    DesligaExpandido  := ESC + '!' + #0;
    LigaItalico       := ESC + '4';
    DesligaItalico    := ESC + '5';
  end;
  {*)}

  TagsNaoSuportadas.Add( cTagBarraCode128c );
end;

function TACBrEscDiebold.ComandoCodBarras(const ATag: String;
  ACodigo: AnsiString): AnsiString;
var
  P: Integer;
  BTag: String;
begin
  // EscDiebold não suporta Code128C
  if (ATag = cTagBarraCode128a) or
     (ATag = cTagBarraCode128b) or
     (ATag = cTagBarraCode128c) then
    BTag := cTagBarraCode128
  else
    BTag := ATag;

  Result := inherited ComandoCodBarras(BTag, ACodigo);

  // EscDiebold não suporta notação para COD128 A, B e C do padrão EscPos
  if (BTag = cTagBarraCode128) then
  begin
    P := pos('{',Result);
    if P > 0 then
    begin
      Delete(Result,P,2);
      //Alterando o caracter que contém o tamanho do código de barras
      Result[P-1] := AnsiChr(Length(ACodigo));
    end;
  end;
end;

function TACBrEscDiebold.ComandoQrCode(ACodigo: AnsiString): AnsiString;
begin
  with fpPosPrinter.ConfigQRCode do
  begin
    if fpPosPrinter.Alinhamento = alEsquerda then
      Result := GS + '(k' + #3 + #0 + '1B0'   // A esquerda
    else
      Result := GS + '(k' + #3 + #0 + '1B1';  // Centralizar

     Result := Result +
               GS + '(k' + #3 + #0 + '1C' + AnsiChr(LarguraModulo) +   // Largura Modulo
               GS + '(k' + #3 + #0 + '1E' + IntToStr(ErrorLevel) + // Error Level
               GS + '(k' + IntToLEStr(length(ACodigo)+3)+'1P0' + ACodigo +  // Codifica
               GS + '(k' + #3 + #0 +'1Q0';  // Imprime
  end;
end;

function TACBrEscDiebold.ComandoLogo: AnsiString;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    Result := GS + '09' + AnsiChr( min(StrToIntDef( chr(KeyCode1) + chr(KeyCode2), 0), 9));
  end;
end;

function TACBrEscDiebold.ComandoFonte(TipoFonte: TACBrPosTipoFonte;
  Ligar: Boolean): AnsiString;
var
  NovoFonteStatus: TACBrPosFonte;
  AByte: Byte;
begin
  Result := '';
  NovoFonteStatus := fpPosPrinter.FonteStatus;
  if Ligar then
    NovoFonteStatus := NovoFonteStatus + [TipoFonte]
  else
    NovoFonteStatus := NovoFonteStatus - [TipoFonte];

  if TipoFonte in [ftCondensado, ftNegrito, ftExpandido, ftSublinhado] then
  begin
    AByte := 0;

    if ftCondensado in NovoFonteStatus then
      AByte := AByte + 1;

    if ftNegrito in NovoFonteStatus then
      AByte := AByte + 8;

    if ftExpandido in NovoFonteStatus then
      AByte := AByte + 32;

    if ftSublinhado in NovoFonteStatus then
      AByte := AByte + 128;

    Result := ESC + '!' + AnsiChr(AByte);

    // ESC ! desliga Invertido, enviando o comando novamente
    if ftInvertido in NovoFonteStatus then
      Result := Result + Cmd.LigaInvertido;

    if ftItalico in NovoFonteStatus then
      Result := Result + Cmd.LigaItalico;
  end
  else
    Result := inherited ComandoFonte(TipoFonte, Ligar);

end;

function TACBrEscDiebold.LerInfo: String;
var
  //Ret: AnsiString;
  Info: String;
  //B: Byte;

  Procedure AddInfo( Titulo: String; AInfo: AnsiString);
  begin
    Info := Info + Titulo+'='+AInfo + sLineBreak;
  end;

begin
  Info := '';

  AddInfo('Fabricante', 'Diebold');

  // Aparentemente, Diebold não tem comandos para retornar Informações sobre o equipamento
  //
  //Ret := fpPosPrinter.TxRx( GS + 'IA', 0, 500, True );
  //AddInfo('Firmware', Ret);
  //
  //Ret := fpPosPrinter.TxRx( GS + 'IC', 0, 500, True );
  //AddInfo('Modelo', Ret);
  //
  //Ret := fpPosPrinter.TxRx( GS + 'I1', 1, 500 );
  //B := Ord(Ret[1]);
  //Info := Info + 'Guilhotina='+IfThen(TestBit(B, 1),'1','0') + sLineBreak ;

  Result := Info;
end;

end.

