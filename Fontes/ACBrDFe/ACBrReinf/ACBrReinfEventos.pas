{******************************************************************************}
{ Projeto: Componente ACBrReinf                                                }
{  Biblioteca multiplataforma de componentes Delphi para envio de eventos do   }
{ Reinf                                                                        }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

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
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}
{******************************************************************************
|* Historico
|*
|* 24/10/2017: Renato Rubinho
|*  - Compatibilizado Fonte com Delphi 7
*******************************************************************************}

{$I ACBr.inc}

unit ACBrReinfEventos;

interface

uses
  SysUtils, Classes, synautil,
  pcnGerador, pcnEventosReinf, pcnConversaoReinf;

type
  TEventos = class(TComponent)
  private
    FReinfEventos: TReinfEventos;
    FTipoContribuinte: TContribuinte;

    procedure SetReinfEventos(const Value: TReinfEventos);
    function GetCount: integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;//verificar se ser� necess�rio, se TReinfEventos for TComponent;

    procedure GerarXMLs;
    procedure SaveToFiles;
    procedure Clear;

    function LoadFromFile(CaminhoArquivo: String; ArqXML: Boolean = True): Boolean;
    function LoadFromStream(AStream: TStringStream): Boolean;
    function LoadFromString(AXMLString: String): Boolean;
    function LoadFromStringINI(AINIString: String): Boolean;
    function LoadFromIni(AIniString: String): Boolean;

    property Count:        Integer           read GetCount;
    property ReinfEventos: TReinfEventos     read FReinfEventos     write SetReinfEventos;
    property TipoContribuinte: TContribuinte read FTipoContribuinte write FTipoContribuinte;
  end;

implementation

uses
  dateutils,
  ACBrUtil, ACBrDFeUtil, ACBrReinf;

{ TEventos }

procedure TEventos.Clear;
begin
  FReinfEventos.Clear;
end;

constructor TEventos.Create(AOwner: TComponent);
begin
  inherited;

  FReinfEventos := TReinfEventos.Create(AOwner);
end;

destructor TEventos.Destroy;
begin
  FReinfEventos.Free;

  inherited;
end;

procedure TEventos.GerarXMLs;
begin
  FTipoContribuinte := TACBrReinf(Self.Owner).Configuracoes.Geral.TipoContribuinte;
  Self.ReinfEventos.GerarXMLs;
end;

function TEventos.GetCount: integer;
begin
  Result :=  Self.ReinfEventos.Count;
end;

procedure TEventos.SaveToFiles;
begin
  Self.ReinfEventos.SaveToFiles;
end;

procedure TEventos.SetReinfEventos(const Value: TReinfEventos);
begin
  FReinfEventos.Assign(Value);
end;

function TEventos.LoadFromFile(CaminhoArquivo: String; ArqXML: Boolean = True): Boolean;
var
  ArquivoXML: TStringList;
  XML: String;
  XMLOriginal: AnsiString;
begin
  Result := False;
  
  ArquivoXML := TStringList.Create;
  try
    ArquivoXML.LoadFromFile(CaminhoArquivo);
    XMLOriginal := ArquivoXML.Text;

    // Converte de UTF8 para a String nativa da IDE //
    XML := DecodeToString(XMLOriginal, True);

    if ArqXML then
      Result := LoadFromString(XML)
    else
      Result := LoadFromStringINI(XML);

  finally
    ArquivoXML.Free;
  end;
end;

function TEventos.LoadFromStream(AStream: TStringStream): Boolean;
var
  XMLOriginal: AnsiString;
begin
  AStream.Position := 0;
  XMLOriginal := ReadStrFromStream(AStream, AStream.Size);

  Result := Self.LoadFromString(String(XMLOriginal));
end;

function TEventos.LoadFromString(AXMLString: String): Boolean;
var
  AXML: AnsiString;
  P, N: integer;

  function PosReinf: integer;
  begin
    Result := pos('</Reinf>', AXMLString);
  end;

begin
  Result := False;
  N := PosReinf;

  while N > 0 do
  begin
    P := pos('</Reinf>', AXMLString);

    if P > 0 then
    begin
      AXML := copy(AXMLString, 1, P + 9);
      AXMLString := Trim(copy(AXMLString, P + 10, length(AXMLString)));
    end
    else
    begin
      AXML := copy(AXMLString, 1, N + 6);
      AXMLString := Trim(copy(AXMLString, N + 6, length(AXMLString)));
    end;

    Result := Self.ReinfEventos.LoadFromString(AXML);

    N := PosReinf;
  end;
end;

function TEventos.LoadFromStringINI(AINIString: String): Boolean;
begin
  Result := Self.ReinfEventos.LoadFromIni(AIniString);
  SaveToFiles;
end;

function TEventos.LoadFromIni(AIniString: String): Boolean;
begin
  // O valor False no segundo par�metro indica que o conteudo do arquivo n�o �
  // um XML.
  Result := LoadFromFile(AIniString, False);
end;

end.
