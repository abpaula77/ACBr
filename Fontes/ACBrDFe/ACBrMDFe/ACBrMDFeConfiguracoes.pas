{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|* Historico
|*
|* 01/08/2012: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrMDFeConfiguracoes;

interface

uses
  Classes, SysUtils, ACBrDFeConfiguracoes, pcnConversao, pcnConversaoMDFe;

type

  { TGeralConfMDFe }

  TGeralConfMDFe = class(TGeralConf)
  private
    FVersaoDF: TpcnVersaoDF;
    FAtualizarXMLCancelado: Boolean;

    procedure SetVersaoDF(const Value: TpcnVersaoDF);
  public
    constructor Create(AOwner: TConfiguracoes); override;
  published
    property VersaoDF: TpcnVersaoDF read FVersaoDF write SetVersaoDF default ve200;
    property AtualizarXMLCancelado: Boolean
      read FAtualizarXMLCancelado write FAtualizarXMLCancelado default True;
  end;

  { TArquivosConfMDFe }

  TArquivosConfMDFe = class(TArquivosConf)
  private
    FEmissaoPathMDFe: boolean;
    FSalvarEvento: boolean;
    FSalvarApenasMDFeProcessados: boolean;
    FPathMDFe: String;
    FPathEvento: String;
  public
    constructor Create(AOwner: TConfiguracoes); override;

    function GetPathMDFe(Data: TDateTime = 0; CNPJ: String = ''): String;
    function GetPathEvento(tipoEvento: TpcnTpEvento; CNPJ: String = ''): String;
  published
    property EmissaoPathMDFe: boolean read FEmissaoPathMDFe
      write FEmissaoPathMDFe default False;
    property SalvarEvento: boolean read FSalvarEvento write FSalvarEvento default False;
    property SalvarApenasMDFeProcessados: boolean
      read FSalvarApenasMDFeProcessados write FSalvarApenasMDFeProcessados default False;
    property PathMDFe: String read FPathMDFe write FPathMDFe;
    property PathEvento: String read FPathEvento write FPathEvento;
  end;

  { TConfiguracoesMDFe }

  TConfiguracoesMDFe = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfMDFe;
    function GetGeral: TGeralConfMDFe;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;

  published
    property Geral: TGeralConfMDFe read GetGeral;
    property Arquivos: TArquivosConfMDFe read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
 ACBrUtil, DateUtils;

{ TConfiguracoesMDFe }


constructor TConfiguracoesMDFe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TConfiguracoesMDFe.GetArquivos: TArquivosConfMDFe;
begin
  Result := TArquivosConfMDFe(FPArquivos);
end;

function TConfiguracoesMDFe.GetGeral: TGeralConfMDFe;
begin
  Result := TGeralConfMDFe(FPGeral);
end;

procedure TConfiguracoesMDFe.CreateGeralConf;
begin
  FPGeral := TGeralConfMDFe.Create(Self);
end;

procedure TConfiguracoesMDFe.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfMDFe.Create(self);
end;

{ TGeralConfMDFe }

constructor TGeralConfMDFe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := ve100;
  FAtualizarXMLCancelado := True;
end;

procedure TGeralConfMDFe.SetVersaoDF(const Value: TpcnVersaoDF);
begin
  FVersaoDF := Value;
end;

{ TArquivosConfMDFe }

constructor TArquivosConfMDFe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmissaoPathMDFe := False;
  FSalvarEvento := False;
  FSalvarApenasMDFeProcessados := False;
  FPathMDFe := '';
  FPathEvento := '';
end;

function TArquivosConfMDFe.GetPathEvento(tipoEvento: TpcnTpEvento;
  CNPJ: String = ''): String;
var
  Dir, Evento: String;
begin
  Dir := GetPath(FPathEvento, 'Evento', CNPJ);

  if AdicionarLiteral then
  begin
    case tipoEvento of
      teEncerramento    : Evento := 'Encerramento';
      teCancelamento    : Evento := 'Cancelamento';
      teInclusaoCondutor: Evento := 'IncCondutor';
    end;

    Dir := PathWithDelim(Dir) + Evento;
  end;

  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);

  Result := Dir;
end;

function TArquivosConfMDFe.GetPathMDFe(Data: TDateTime = 0; CNPJ: String = ''): String;
begin
  Result := GetPath(FPathMDFe, 'MDFe', CNPJ, Data);
end;

end.
