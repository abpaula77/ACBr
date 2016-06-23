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
    function PrepararCmd(aCmd: Integer; aParams: AnsiString = ''): AnsiString;
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
    function ComandoOnline: AnsiString; override;
    function ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString; override;

    function InterpretarResposta(aRecebido: AnsiString): AnsiString; override;
  end;

implementation

{ TACBrMTerPMTG }

function TACBrMTerPMTG.PrepararCmd(aCmd: Integer; aParams: AnsiString): AnsiString;
var
  wTamParams: Integer;
begin
  wTamParams := Length(aParams);
  Result     := IntToLEStr(aCmd) + IntToLEStr(wTamParams) + aParams;
end;

constructor TACBrMTerPMTG.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'PMTG';
end;

function TACBrMTerPMTG.ComandoBackSpace: AnsiString;
begin
  Result := PrepararCmd(33);
end;

function TACBrMTerPMTG.ComandoBoasVindas: AnsiString;
begin
  Result := PrepararCmd(3) + ComandoOnline;
end;

function TACBrMTerPMTG.ComandoBeep: AnsiString;
begin
  // Liga Beep
  Result := PrepararCmd(93, IntToLEStr(1, 4));

  // Desliga Beep
  Result := Result + ComandoOnline + PrepararCmd(93, IntToLEStr(0, 4));
end;

function TACBrMTerPMTG.ComandoDeslocarCursor(aValue: Integer): AnsiString;
begin
  Result := PrepararCmd(43, NUL + IntToLEStr(aValue));
end;

function TACBrMTerPMTG.ComandoDeslocarLinha(aValue: Integer): AnsiString;
begin
  Result := PrepararCmd(43, PadRight(IntToLEStr(aValue, 1), 3, NUL));
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

function TACBrMTerPMTG.ComandoEnviarParaParalela(aDados: AnsiString): AnsiString;
begin
  { Apenas GE750 possui porta Paralela }
  Result := PrepararCmd(73, aDados);
end;

function TACBrMTerPMTG.ComandoEnviarParaSerial(aDados: AnsiString;
  aSerial: Byte): AnsiString;
begin
  { Portas COM disponíveis:
    - GE750: 1 e 2;
    - GE760: 1;
    - MT740: 1, 2, 3 e 4;
    - MT720: 1, 2 e 3 }
  Result := PrepararCmd(63, AnsiChr(aSerial-1) + aDados);
end;

function TACBrMTerPMTG.ComandoEnviarTexto(aTexto: AnsiString): AnsiString;
begin
  Result := PrepararCmd(51, PadRight(aTexto, 29, NUL));
end;

function TACBrMTerPMTG.ComandoLimparDisplay: AnsiString;
begin
  Result := PrepararCmd(39);
end;

function TACBrMTerPMTG.ComandoLimparLinha(aLinha: Integer): AnsiString;
begin
  Result := PrepararCmd(55, IntToLEStr(aLinha));
end;

function TACBrMTerPMTG.ComandoOnline: AnsiString;
begin
  Result := PrepararCmd(1);
end;

function TACBrMTerPMTG.ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString;
var
  wLinhaStr, wColunaStr: String;
begin
  wLinhaStr  := IntToLEStr(aLinha, 1);
  wColunaStr := IntToLEStr(aColuna);

  Result := PrepararCmd(41, wLinhaStr + wColunaStr);
end;

function TACBrMTerPMTG.InterpretarResposta(aRecebido: AnsiString): AnsiString;
var
  wCmd, wLenParams, wLen, wPosCmd: Integer;
begin
  Result  := '';
  wLen    := Length(aRecebido);
  wPosCmd := 1;

  while (wPosCmd < wLen) do
  begin
    wCmd       := LEStrToInt(Copy(aRecebido, wPosCmd, 2));
    wLenParams := LEStrToInt(Copy(aRecebido, wPosCmd + 2, 2));

    if (wCmd = 29) then
      Result := Result + Copy(aRecebido, wPosCmd + 4, wLenParams);

    wPosCmd := wPosCmd + wLenParams + 4;
  end;
end;

end.

