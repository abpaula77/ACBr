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
|*  - Primeira Versao ACBrMTerStxEtx
******************************************************************************}

{$I ACBr.inc}

unit ACBrMTerStxEtx;

interface

uses
  Classes, SysUtils, ACBrMTerClass, ACBrConsts, ACBrUtil;

type

  { TACBrMTerStxEtx }

  TACBrMTerStxEtx = class(TACBrMTerClass)
  private
    { Private declarations }
  public
    constructor Create(aOwner: TComponent);

    function ComandoBackSpace: AnsiString; override;
    function ComandoBeep: AnsiString; override;
    function ComandoBoasVindas: AnsiString; override;
    function ComandoDeslocarCursor(aValue: Integer): AnsiString; override;
    function ComandoDeslocarLinha(aValue: Integer): AnsiString; override;
    function ComandoEnviarParaParalela(aDados: AnsiString): AnsiString; override;
    function ComandoEnviarParaSerial(aDados: AnsiString; aSerial: Byte = 0): AnsiString; override;
    function ComandoEnviarTexto(aTexto: AnsiString): AnsiString; override;
    function ComandoLimparLinha(aLinha: Integer): AnsiString; override;
    function ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString; override;
    function ComandoLimparDisplay: AnsiString; override;

    function InterpretarResposta(aRecebido: AnsiString): AnsiString; override;
  end;

implementation

{ TACBrMTerStxEtx }

constructor TACBrMTerStxEtx.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'STX-ETX';
end;

function TACBrMTerStxEtx.ComandoBackSpace: AnsiString;
begin
  Result := STX + 'D' + BS + ETX;
end;

function TACBrMTerStxEtx.ComandoBeep: AnsiString;
begin
  //Result := STX + #90 + '9' + ETX;
  //Result := STX + 'D' + BELL + ETX;
  Result := '';  //TODO:
end;

function TACBrMTerStxEtx.ComandoBoasVindas: AnsiString;
begin
  Result := '';
end;

function TACBrMTerStxEtx.ComandoDeslocarCursor(aValue: Integer): AnsiString;
begin
  Result := '';

  while (aValue > 0) do
  begin
    Result := STX + 'O' + DC4 + ETX;
    aValue := aValue - 1;
  end;
end;

function TACBrMTerStxEtx.ComandoDeslocarLinha(aValue: Integer): AnsiString;
begin
  case aValue of
    -1, 1: Result := STX + 'C000' + ETX;
     2:    Result := STX + 'C100' + ETX;
  end;
end;

function TACBrMTerStxEtx.ComandoEnviarParaParalela(aDados: AnsiString
  ): AnsiString;
var
  I: Integer;
begin
  for I := 1 to Length(aDados) do
    Result := Result + STX + 'P' + aDados[I] + ETX;
end;

function TACBrMTerStxEtx.ComandoEnviarParaSerial(aDados: AnsiString;
  aSerial: Byte): AnsiString;
var
  wPorta: String;
  I: Integer;
begin
  if (aSerial = 1) then
    wPorta := 'R'        // Seleciona porta serial 1
  else
    wPorta := 'S';       // Seleciona porta serial padrão(0)

  for I := 1 to Length(aDados) do
    Result := Result + STX + wPorta + aDados[I] + ETX;
end;

function TACBrMTerStxEtx.ComandoEnviarTexto(aTexto: AnsiString): AnsiString;
begin
  Result := STX + 'D' + aTexto + ETX;
end;

function TACBrMTerStxEtx.ComandoLimparLinha(aLinha: Integer): AnsiString;
begin
  //Result := inherited ComandoLimparLinha(aLinha);
  Result := '';
end;

function TACBrMTerStxEtx.ComandoPosicionarCursor(aLinha, aColuna: Integer
  ): AnsiString;
begin
  Result := STX + 'C' + IntToStr(aLinha-1) + IntToStrZero(aColuna-1, 2) + ETX;
end;

function TACBrMTerStxEtx.ComandoLimparDisplay: AnsiString;
begin
  Result := STX + 'L' + ETX;
end;

function TACBrMTerStxEtx.InterpretarResposta(aRecebido: AnsiString): AnsiString;
begin
  { É Comando? Retorna vazio... }
  if (aRecebido[1] = STX) and (aRecebido[Length(aRecebido)] = ETX) then
    Result := ''
  { É espaço? Retorna espaço }
  else if (Length(aRecebido) = 1) and (aRecebido[1] = #32) then
    Result := aRecebido
  else
    Result := Trim(TiraAcentos(aRecebido));
end;

end.

