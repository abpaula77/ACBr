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
|* 17/05/2016: Elias César Vieira
|*  - Primeira Versao ACBrMTerPMTG
******************************************************************************}

{$I ACBr.inc}

unit ACBrMTerPMTG;

interface

uses
  Classes, SysUtils, ACBrMTerClass, ACBrConsts, ACBrUtil;

type

  { TACBrMTerPMTG }

  TACBrMTerPMTG = class(TACBrMTerClass)
  private
    { Private declarations }
  public
    constructor Create(aOwner: TComponent);

    function ComandoBackSpace: AnsiString; override;
    function ComandoBoasVindas: AnsiString; override;
    function ComandoBeep: AnsiString; override;
    function ComandoDeslocarCursor(aValue: Integer): AnsiString; override;
    function ComandoDeslocarLinha(aValue: Integer): AnsiString; override;
    function ComandoEco(aValue: AnsiString): AnsiString; override;
    function ComandoEnviarParaParalela(aDados: AnsiString): AnsiString; override;
    function ComandoEnviarParaSerial(aDados: AnsiString; aSerial: Byte = 0): AnsiString; override;
    function ComandoEnviarTexto(aTexto: AnsiString): AnsiString; override;
    function ComandoLimparDisplay: AnsiString; override;
    function ComandoLimparLinha(aLinha: Integer): AnsiString; override;
    function ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString; override;

    function InterpretarResposta(aRecebido: AnsiString): AnsiString; override;
  end;

implementation

{ TACBrMTerPMTG }

constructor TACBrMTerPMTG.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'PMTG';
end;

function TACBrMTerPMTG.ComandoBackSpace: AnsiString;
begin
  Result := HexToAscii('21') + NUL;
end;

function TACBrMTerPMTG.ComandoBoasVindas: AnsiString;
begin
  Result := ETX + NUL;
end;

function TACBrMTerPMTG.ComandoBeep: AnsiString;
begin
  Result := HexToAscii('5D') + NUL + SOH;
end;

function TACBrMTerPMTG.ComandoDeslocarCursor(aValue: Integer): AnsiString;
var
  wColunaStr: String;
begin
  wColunaStr := HexToAscii(IntToStrZero(aValue, 2));

  Result := HexToAscii('2B') + NUL + IntToLEStr(2) + NUL + wColunaStr;
end;

function TACBrMTerPMTG.ComandoDeslocarLinha(aValue: Integer): AnsiString;
begin
  Result := '';

  while (aValue > 0) do
  begin
    Result := Result + HexToAscii('25') + NUL;
    Dec(aValue, 1);
  end;
end;

function TACBrMTerPMTG.ComandoEco(aValue: AnsiString): AnsiString;
var
  I: Integer;
  C: AnsiChar;
begin
  Result := '';

  for I := 1 to Length(aValue) do
  begin
    C := aValue[I];
    case C of
      BS: Result := Result + ComandoBackSpace; // É backspace ?
    else
      Result := Result + ComandoEnviarTexto(C);
    end;
  end;
end;

function TACBrMTerPMTG.ComandoEnviarParaParalela(aDados: AnsiString
  ): AnsiString;
var
  wTam: Integer;
begin
  { MT740 não possui porta Paralela }
  wTam   := Length(aDados);
  Result := HexToAscii('49') + NUL + IntToLEStr(wTam, 2) + aDados;
end;

function TACBrMTerPMTG.ComandoEnviarParaSerial(aDados: AnsiString; aSerial: Byte
  ): AnsiString;
var
  wTam: Integer;
begin
  { Portas COM disponíveis:
    - GE750: 1 e 2;
    - GE760: 1;
    - MT740: 1, 2, 3 e 4;
    - MT720: 1, 2 e 3 }

  wTam := Length(aDados) + 1;

  Result := HexToAscii('3F') + NUL + IntToLEStr(wTam, 2)+ AnsiChr(aSerial-1) + aDados;
end;

function TACBrMTerPMTG.ComandoEnviarTexto(aTexto: AnsiString): AnsiString;
var
  wTam: Integer;
begin
  wTam := Length(aTexto);

  Result := HexToAscii('33') + NUL + IntToLEStr(wTam, 2) + aTexto;
end;

function TACBrMTerPMTG.ComandoLimparDisplay: AnsiString;
begin
  Result := HexToAscii('27') + NUL;
end;

function TACBrMTerPMTG.ComandoLimparLinha(aLinha: Integer): AnsiString;
begin
  Result := '';
end;

function TACBrMTerPMTG.ComandoPosicionarCursor(aLinha, aColuna: Integer
  ): AnsiString;
var
  wLinhaStr, wColunaStr: String;
begin
  wLinhaStr  := HexToAscii(IntToStrZero(aLinha, 2));
  wColunaStr := HexToAscii(IntToStrZero(aColuna,2));

  Result := HexToAscii('29') + NUL + IntToLEStr(2) + wLinhaStr + wColunaStr;
end;

function TACBrMTerPMTG.InterpretarResposta(aRecebido: AnsiString): AnsiString;
begin
  if (Pos(GS, aRecebido) <= 0) then
    Exit;

  if (Pos(#8, aRecebido) > 0) then        // É Backspace ?
    Result := #8
  else if (Pos(#13, aRecebido) > 0) then  // É Enter ?
    Result := #13
  else if (Pos(#32, aRecebido) > 0) then  // É Espaço ?
    Result := #32
  else
    Result := Trim(TiraAcentos(aRecebido));
end;

end.

