{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
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

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 29/02/2015: Guilherme Costa
|*  - n�o estava sendo gerada a tag "tpProc"
******************************************************************************}

{$I ACBr.inc}

unit pcesRetornoClass;

interface

uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnLeitor,
  pcesCommon, pcesConversaoeSocial;

type
  TOcorrenciasCollection = class;
  TOcorrenciasCollectionItem = class;
  TStatus = class;
  TOcorrenciasProcCollection = class;
  TOcorrenciasProcCollectionItem = class;
  TProcessamento = class;

  TOcorrenciasCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TOcorrenciasCollectionItem;
    procedure SetItem(Index: Integer; Value: TOcorrenciasCollectionItem);
  public
    constructor create(AOwner: TStatus);

    function Add: TOcorrenciasCollectionItem;
    property Items[Index: Integer]: TOcorrenciasCollectionItem read GetItem write SetItem;
  end;

  TOcorrenciasCollectionItem = class(TCollectionItem)
  private
    FCodigo: Integer;
    FDescricao: String;
    FTipo: Byte;
    FLocalizacao: String;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Tipo: Byte read FTipo write FTipo;
    property Localizacao: String read FLocalizacao write FLocalizacao;
  end;

  TStatus = class
  private
    FcdResposta: Integer;
    FdescResposta: string;
    FtempoEstimadoConclusao: Integer;
    FOcorrencias: TOcorrenciasCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property cdResposta: Integer read FcdResposta write FcdResposta;
    property descResposta: string read FdescResposta write FdescResposta;
    property tempoEstimadoConclusao: Integer read FtempoEstimadoConclusao write FtempoEstimadoConclusao;
    property Ocorrencias: TOcorrenciasCollection read FOcorrencias write FOcorrencias;
  end;

  TDadosRecepcaoLote = class
  private
    FdhRecepcao: TDateTime;
    FversaoAplicRecepcao: String;
    FProtocolo: String;
  public
    property dhRecepcao: TDateTime read FdhRecepcao write FdhRecepcao;
    property versaoAplicRecepcao: String read FversaoAplicRecepcao
      write FversaoAplicRecepcao;
    property Protocolo: String read FProtocolo write FProtocolo;
  end;

  TdadosProcLote = class
  private
    FversaoAplicProcLote: String;
  public
    property versaoAplicProcLote: String read FversaoAplicProcLote
      write FversaoAplicProcLote;
  end;

  TRecepcao = class
  private
    FtpAmb: TptpAmb;
    FdhRecepcao: TDateTime;
    FversaoAplicRecepcao: String;
    FProtocolo: String;
  public
    property tpAmb: TptpAmb read FtpAmb write FtpAmb;
    property dhRecepcao: TDateTime read FdhRecepcao write FdhRecepcao;
    property versaoAplicRecepcao: String read FversaoAplicRecepcao write FversaoAplicRecepcao;
    property Protocolo: String read FProtocolo write FProtocolo;
  end;

  TOcorrenciasProcCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TOcorrenciasProcCollectionItem;
    procedure SetItem(Index: Integer; Value: TOcorrenciasProcCollectionItem);
  public
    constructor create(AOwner: TProcessamento);

    function Add: TOcorrenciasProcCollectionItem;
    property Items[Index: Integer]: TOcorrenciasProcCollectionItem read GetItem write SetItem;
  end;

  TOcorrenciasProcCollectionItem = class(TCollectionItem)
  private
    FCodigo: Integer;
    FDescricao: String;
    FTipo: Byte;
    FLocalizacao: String;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Tipo: Byte read FTipo write FTipo;
    property Localizacao: String read FLocalizacao write FLocalizacao;
  end;

  TProcessamento = class
  private
    FcdResposta: Integer;
    FdescResposta: string;
    FversaoAplicProcLote: string;
    FdhProcessamento: TDateTime;
    FOcorrencias: TOcorrenciasProcCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property cdResposta: Integer read FcdResposta write FcdResposta;
    property descResposta: string read FdescResposta write FdescResposta;
    property versaoAplicProcLote: string read FversaoAplicProcLote write FversaoAplicProcLote;
    property dhProcessamento: TDateTime read FdhProcessamento write FdhProcessamento;
    property Ocorrencias: TOcorrenciasProcCollection read FOcorrencias write FOcorrencias;
  end;

  TRecibo = class
  private
    FnrRecibo: String;
    FHash: String;
  public
    property nrRecibo: string read FnrRecibo write FnrRecibo;
    property Hash: string read FHash write FHash;
  end;

  //////////////////////// Classes a serem checadas

  TStatusRetorno = class
  private
    FcdResposta: Integer;
    FdescResposta: String;
  public
    property cdResposta: Integer read FcdResposta write FcdResposta;
    property descResposta: String read FdescResposta write FdescResposta;
  end;

  TStatusEnvLote = class(TStatusRetorno);

  TStatusProcLote = class(TStatusRetorno)
  private
    FTmpConclusao: Integer;
  public
    property TmpConclusao: Integer read FTmpConclusao write FTmpConclusao;
  end;

////////////////////////////////////////////////////////////////////////////////

implementation

{ TOcorrenciasCollection }

function TOcorrenciasCollection.Add: TOcorrenciasCollectionItem;
begin
  Result := TOcorrenciasCollectionItem(inherited Add());
end;

constructor TOcorrenciasCollection.create(AOwner: TStatus);
begin
  inherited create(TOcorrenciasCollectionItem);
end;

function TOcorrenciasCollection.GetItem(
  Index: Integer): TOcorrenciasCollectionItem;
begin
  Result := TOcorrenciasCollectionItem(Inherited GetItem(Index));
end;

procedure TOcorrenciasCollection.SetItem(Index: Integer;
  Value: TOcorrenciasCollectionItem);
begin
  Inherited SetItem(Index, Value);
end;

{ TStatus }

constructor TStatus.Create;
begin
  FOcorrencias := TOcorrenciasCollection.create(Self);
end;

destructor TStatus.Destroy;
begin
  FOcorrencias.Free;

  inherited;
end;

{ TOcorrenciasProcCollection }

function TOcorrenciasProcCollection.Add: TOcorrenciasProcCollectionItem;
begin
  Result := TOcorrenciasProcCollectionItem(inherited Add());
end;

constructor TOcorrenciasProcCollection.create(AOwner: TProcessamento);
begin
  inherited create(TOcorrenciasProcCollectionItem);
end;

function TOcorrenciasProcCollection.GetItem(
  Index: Integer): TOcorrenciasProcCollectionItem;
begin
  Result := TOcorrenciasProcCollectionItem(Inherited GetItem(Index));
end;

procedure TOcorrenciasProcCollection.SetItem(Index: Integer;
  Value: TOcorrenciasProcCollectionItem);
begin
  Inherited SetItem(Index, Value);
end;

{ TProcessamento }

constructor TProcessamento.Create;
begin
  FOcorrencias := TOcorrenciasProcCollection.create(Self);
end;

destructor TProcessamento.Destroy;
begin
  FOcorrencias.Free;
  
  inherited;
end;

end.

