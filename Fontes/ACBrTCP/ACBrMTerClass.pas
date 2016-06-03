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
|*  - Primeira Versao ACBrMTerClass
******************************************************************************}

{$I ACBr.inc}

unit ACBrMTerClass;

interface

uses
  Classes, SysUtils;

type

  { Classe generica de MicroTerminal, nao implementa nenhum modelo especifico,
  apenas declara a Classe. NAO DEVE SER INSTANCIADA. Usada apenas como base para
  as demais Classes de ACBrMTer, como por exemplo a classe TACBrMTerVT100 }

  { TACBrMTerClass }

  TACBrMTerClass = class
  private
    procedure DisparaErroNaoImplementado( NomeMetodo: String );

  protected
    fpModeloStr: String;

  public
    constructor Create(aOwner: TComponent);

    function ComandoBackSpace: AnsiString; virtual;
    function ComandoBeep: AnsiString; virtual;
    function ComandoBoasVindas: AnsiString; virtual;
    function ComandoDeslocarCursor(aValue: Integer): AnsiString; virtual;
    function ComandoDeslocarLinha(aValue: Integer): AnsiString; virtual;
    function ComandoEco(aValue: AnsiString): AnsiString; virtual;
    function ComandoEnviarParaParalela(aDados: AnsiString): AnsiString; virtual;
    function ComandoEnviarParaSerial(aDados: AnsiString; aSerial: Byte = 0): AnsiString; virtual;
    function ComandoEnviarTexto(aTexto: AnsiString): AnsiString; virtual;
    function ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString; virtual;
    function ComandoLimparDisplay: AnsiString; virtual;
    function ComandoLimparLinha(aLinha: Integer): AnsiString; virtual;
    function InterpretarResposta(aRecebido: AnsiString): AnsiString; virtual;

    property ModeloStr: String read fpModeloStr;
  end;


implementation

uses ACBrMTer, ACBrUtil;

{ TACBrMTerClass }

procedure TACBrMTerClass.DisparaErroNaoImplementado(NomeMetodo: String);
begin
  raise Exception.Create(ACBrStr('Metodo: '+NomeMetodo+', não implementada em: '+ModeloStr));
end;

constructor TACBrMTerClass.Create(aOwner: TComponent);
begin
  if not (aOwner is TACBrMTer) then
    raise Exception.Create(ACBrStr('Essa Classe deve ser instanciada por TACBrMTer'));

  fpModeloStr := 'Não Definido';
end;

function TACBrMTerClass.ComandoBackSpace: AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoBackSpace');
end;

function TACBrMTerClass.ComandoBeep: AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoBeep');
end;

function TACBrMTerClass.ComandoBoasVindas: AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoBoasVindas');
end;

function TACBrMTerClass.ComandoDeslocarCursor(aValue: Integer): AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoDeslocarCursor');
end;

function TACBrMTerClass.ComandoDeslocarLinha(aValue: Integer): AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoDeslocarCursor');
end;

function TACBrMTerClass.ComandoEco(aValue: AnsiString): AnsiString;
begin
  Result := ComandoEnviarTexto(aValue);
end;

function TACBrMTerClass.ComandoEnviarParaParalela(aDados: AnsiString
  ): AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoEnviarParaParalela');
end;

function TACBrMTerClass.ComandoEnviarParaSerial(aDados: AnsiString;
  aSerial: Byte): AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoEnviarParaSerial');
end;

function TACBrMTerClass.ComandoEnviarTexto(aTexto: AnsiString): AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoEnviarTexto');
end;

function TACBrMTerClass.ComandoPosicionarCursor(aLinha, aColuna: Integer
  ): AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoPosicionarCursor');
end;

function TACBrMTerClass.ComandoLimparDisplay: AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoLimparDisplay');
end;

function TACBrMTerClass.ComandoLimparLinha(aLinha: Integer): AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('ComandoLimparLinha');
end;

function TACBrMTerClass.InterpretarResposta(aRecebido: AnsiString): AnsiString;
begin
  Result := '';
  DisparaErroNaoImplementado('InterpretarResposta');
end;

end.

