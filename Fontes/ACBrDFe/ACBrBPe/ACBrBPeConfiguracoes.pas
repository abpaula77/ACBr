{******************************************************************************}
{ Projeto: Componente ACBrBPe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Bilhete de }
{ Passagem Eletr�nica - BPe                                                    }
{                                                                              }
{ Direitos Autorais Reservados (c) 2017                                        }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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
|* 20/06/2017: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrBPeConfiguracoes;

interface

uses
  Classes, SysUtils, ACBrDFeConfiguracoes, pcnConversao, pcnConversaoBPe;

type

  { TGeralConfBPe }

  TGeralConfBPe = class(TGeralConf)
  private
    FVersaoDF: TVersaoBPe;

    procedure SetVersaoDF(const Value: TVersaoBPe);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfBPe: TGeralConfBPe); reintroduce;

  published
    property VersaoDF: TVersaoBPe read FVersaoDF write SetVersaoDF default ve100;
  end;

  { TDownloadConfBPe }

  TDownloadConfBPe = class(TPersistent)
  private
    FPathDownload: String;
    FSepararPorNome: Boolean;
  public
    Constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property PathDownload: String read FPathDownload write FPathDownload;
    property SepararPorNome: Boolean read FSepararPorNome write FSepararPorNome default False;
  end;

  { TArquivosConfBPe }

  TArquivosConfBPe = class(TArquivosConf)
  private
    FEmissaoPathBPe: boolean;
    FSalvarEvento: boolean;
    FSalvarApenasBPeProcessadas: boolean;
    FPathBPe: String;
    FPathEvento: String;
    FDownloadBPe: TDownloadConfBPe;
  public
    constructor Create(AOwner: TConfiguracoes); override;
    destructor Destroy; override;
    procedure Assign(DeArquivosConfBPe: TArquivosConfBPe); reintroduce;

    function GetPathBPe(Data: TDateTime = 0; CNPJ: String = ''): String;
    function GetPathEvento(tipoEvento: TpcnTpEvento; CNPJ: String = ''; Data: TDateTime = 0): String;
    function GetPathDownload(xNome: String = ''; CNPJ: String = ''; Data: TDateTime = 0): String;
  published
    property EmissaoPathBPe: boolean read FEmissaoPathBPe
      write FEmissaoPathBPe default False;
    property SalvarEvento: boolean read FSalvarEvento
      write FSalvarEvento default False;
    property SalvarApenasBPeProcessadas: boolean
      read FSalvarApenasBPeProcessadas write FSalvarApenasBPeProcessadas default False;
    property PathBPe: String read FPathBPe write FPathBPe;
    property PathEvento: String read FPathEvento write FPathEvento;
    property DownloadBPe: TDownloadConfBPe read FDownloadBPe write FDownloadBPe;
  end;

  { TConfiguracoesBPe }

  TConfiguracoesBPe = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfBPe;
    function GetGeral: TGeralConfBPe;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoesBPe: TConfiguracoesBPe); reintroduce;

  published
    property Geral: TGeralConfBPe read GetGeral;
    property Arquivos: TArquivosConfBPe read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
  ACBrUtil, ACBrBPe,
  DateUtils;

{ TConfiguracoesBPe }

constructor TConfiguracoesBPe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  WebServices.ResourceName := 'ACBrBPeServicos';
end;

procedure TConfiguracoesBPe.Assign(DeConfiguracoesBPe: TConfiguracoesBPe);
begin
  Geral.Assign(DeConfiguracoesBPe.Geral);
  WebServices.Assign(DeConfiguracoesBPe.WebServices);
  Certificados.Assign(DeConfiguracoesBPe.Certificados);
  Arquivos.Assign(DeConfiguracoesBPe.Arquivos);
end;

function TConfiguracoesBPe.GetArquivos: TArquivosConfBPe;
begin
  Result := TArquivosConfBPe(FPArquivos);
end;

function TConfiguracoesBPe.GetGeral: TGeralConfBPe;
begin
  Result := TGeralConfBPe(FPGeral);
end;

procedure TConfiguracoesBPe.CreateGeralConf;
begin
  FPGeral := TGeralConfBPe.Create(Self);
end;

procedure TConfiguracoesBPe.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfBPe.Create(self);
end;

{ TGeralConfBPe }

constructor TGeralConfBPe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := ve100;
end;

procedure TGeralConfBPe.Assign(DeGeralConfBPe: TGeralConfBPe);
begin
  inherited Assign(DeGeralConfBPe);

  VersaoDF := DeGeralConfBPe.VersaoDF;
end;

procedure TGeralConfBPe.SetVersaoDF(const Value: TVersaoBPe);
begin
  FVersaoDF := Value;
end;

{ TDownloadConfBPe }

procedure TDownloadConfBPe.Assign(Source: TPersistent);
begin
  if Source is TDownloadConfBPe then
  begin
    FPathDownload := TDownloadConfBPe(Source).PathDownload;
    FSepararPorNome := TDownloadConfBPe(Source).SepararPorNome;
  end
  else
    inherited Assign(Source);
end;

constructor TDownloadConfBPe.Create;
begin
  FPathDownload := '';
  FSepararPorNome := False;
end;

{ TArquivosConfBPe }

constructor TArquivosConfBPe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FDownloadBPe := TDownloadConfBPe.Create;
  FEmissaoPathBPe := False;
  FSalvarEvento := False;
  FSalvarApenasBPeProcessadas := False;
  FPathBPe := '';
  FPathEvento := '';
end;

destructor TArquivosConfBPe.Destroy;
begin
  FDownloadBPe.Free;

  inherited;
end;

procedure TArquivosConfBPe.Assign(DeArquivosConfBPe: TArquivosConfBPe);
begin
  inherited Assign(DeArquivosConfBPe);

  EmissaoPathBPe             := DeArquivosConfBPe.EmissaoPathBPe;
  SalvarEvento               := DeArquivosConfBPe.SalvarEvento;
  SalvarApenasBPeProcessadas := DeArquivosConfBPe.SalvarApenasBPeProcessadas;
  PathBPe                    := DeArquivosConfBPe.PathBPe;
  PathEvento                 := DeArquivosConfBPe.PathEvento;

  FDownloadBPe.Assign(DeArquivosConfBPe.DownloadBPe);
end;

function TArquivosConfBPe.GetPathEvento(tipoEvento: TpcnTpEvento; CNPJ: String;
  Data: TDateTime): String;
var
  Dir: String;
begin
  Dir := GetPath(FPathEvento, 'Evento', CNPJ, Data);

  if AdicionarLiteral then
    Dir := PathWithDelim(Dir) + TpEventoToDescStr(tipoEvento);

  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);

  Result := Dir;
end;

function TArquivosConfBPe.GetPathBPe(Data: TDateTime = 0; CNPJ: String = ''): String;
begin
  Result := GetPath(FPathBPe, ModeloDF, CNPJ, Data, ModeloDF);
end;

function TArquivosConfBPe.GetPathDownload(xNome, CNPJ: String;
  Data: TDateTime): String;
var
  rPathDown: String;
begin
  rPathDown := '';
  if EstaVazio(FDownloadBPe.PathDownload) then
     FDownloadBPe.PathDownload := PathSalvar;

  if (FDownloadBPe.SepararPorNome) and (NaoEstaVazio(xNome)) then
     rPathDown := rPathDown + PathWithDelim(FDownloadBPe.PathDownload) + TiraAcentos(xNome)
  else
     rPathDown := FDownloadBPe.PathDownload;

  Result := GetPath(rPathDown, 'Down', CNPJ, Data);
end;

end.
