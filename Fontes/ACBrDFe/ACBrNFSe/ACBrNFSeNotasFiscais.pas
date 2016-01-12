{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{  de Servi�o eletr�nica - NFSe                                                }

{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }

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

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}

{$I ACBr.inc}

unit ACBrNFSeNotasFiscais;

interface

uses
  Classes, SysUtils, Dialogs, Forms, StrUtils,
  ACBrNFSeConfiguracoes, ACBrDFeUtil,
  pnfsNFSe, pnfsNFSeR, pnfsNFSeW, pcnConversao, pcnAuxiliar, pcnLeitor;

type

  { NotaFiscal }

  NotaFiscal = class(TCollectionItem)
  private
    FNFSe: TNFSe;
    FNFSeW: TNFSeW;
    FNFSeR: TNFSeR;

    FXMLNFSe: String;
    FXMLAssinado: String;
    FXMLOriginal: String;
    FAlertas: String;
    FErroRegrasdeNegocios: String;
    FNomeArq: String;

    FConfirmada: Boolean;
    function GetProcessada: Boolean;

    function GetMsg: String;
    function GetNumID: String;
    function CalcularNomeArquivo: String;
    function CalcularPathArquivo: String;
    function CalcularNomeArquivoCompleto(NomeArquivo: String = '';
      PathArquivo: String = ''): String;

    procedure Assinar(Assina: Boolean);
    function GetXMLAssinado: String;
    procedure SetXML(const Value: String);
    procedure SetXMLOriginal(const Value: String);
  public
    constructor Create(Collection2: TCollection); override;
    destructor Destroy; override;
    procedure Imprimir;
    procedure ImprimirPDF;

    function VerificarAssinatura: Boolean;
    function ValidarRegrasdeNegocios: Boolean;

    function LerXML(AXML: AnsiString): Boolean;

    function GerarXML: String;
    function GravarXML(NomeArquivo: String = ''; PathArquivo: String = ''): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil);

    property NomeArq: String read FNomeArq write FNomeArq;

    property NFSe: TNFSe read FNFSe;

    // Atribuir a "XML", faz o componente transferir os dados lido para as propriedades internas e "XMLAssinado"
    property XML: String         read FXMLOriginal   write SetXML;
    // Atribuir a "XMLOriginal", reflete em XMLAssinado, se existir a tag de assinatura
    property XMLOriginal: String read FXMLOriginal   write SetXMLOriginal;
    property XMLAssinado: String read GetXMLAssinado write FXMLAssinado;

    property XMLNFSe: String read FXMLNFSe write FXMLNFSe;

    property Confirmada: Boolean read FConfirmada write FConfirmada;
    property Processada: Boolean read GetProcessada;
    property Msg: String read GetMsg;
    property NumID: String read GetNumID;

    property Alertas: String read FAlertas;
    property ErroRegrasdeNegocios: String read FErroRegrasdeNegocios;

  end;

  { TNotasFiscais }

  TNotasFiscais = class(TOwnedCollection)
  private
    FTransacao: Boolean;
    FNumeroLote: String;
    FACBrNFSe: TComponent;
    FConfiguracoes: TConfiguracoesNFSe;
    FXMLLoteOriginal: String;
    FXMLLoteAssinado: String;
    FErroValidacao: String;
    FErroValidacaoCompleto: String;
    FAlertas: String;

    function GetItem(Index: integer): NotaFiscal;
    procedure SetItem(Index: integer; const Value: NotaFiscal);

    procedure VerificarDANFSE;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);

    procedure GerarNFSe;
    function VerificarAssinatura(out Erros: String): Boolean;
    function ValidarRegrasdeNegocios(out Erros: String): Boolean;

    procedure Assinar(Assina: Boolean);
    function AssinarLote(XMLLote, docElemento, infElemento: String;
      Assina: Boolean; SignatureNode: String = ''; SelectionNamespaces: String = '';
      IdSignature: String = ''  ): String;
    procedure ValidarLote(const XMLLote, NomeArqSchema: String);
    procedure Imprimir;
    procedure ImprimirPDF;

    function Add: NotaFiscal;
    function Insert(Index: integer): NotaFiscal;

    property Items[Index: integer]: NotaFiscal read GetItem write SetItem; default;

    function GetNamePath: String; override;
    // Incluido o Parametro AGerarNFSe que determina se ap�s carregar os dados da NFSe
    // para o componente, ser� gerado ou n�o novamente o XML da NFSe.
    function LoadFromFile(CaminhoArquivo: String; AGerarNFSe: Boolean = True): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarNFSe: Boolean = True): Boolean;
    function LoadFromString(AXMLString: String; AGerarNFSe: Boolean = True): Boolean;
    function GravarXML(PathNomeArquivo: String = ''): Boolean;

    property XMLLoteOriginal: String read FXMLLoteOriginal write FXMLLoteOriginal;
    property XMLLoteAssinado: String read FXMLLoteAssinado write FXMLLoteAssinado;
    property ErroValidacao: String read FErroValidacao;
    property ErroValidacaoCompleto: String read FErroValidacaoCompleto;
    property Alertas: String read FAlertas;
    property NumeroLote: String read FNumeroLote write FNumeroLote;
    property Transacao: Boolean read FTransacao write FTransacao;
    property ACBrNFSe: TComponent read FACBrNFSe;
  end;

implementation

uses
  ACBrNFSe, ACBrUtil, pnfsConversao, synautil;

{ NotaFiscal }

constructor NotaFiscal.Create(Collection2: TCollection);
begin
  inherited Create(Collection2);
  FNFSe := TNFSe.Create;
  FNFSeW := TNFSeW.Create(FNFSe);
  FNFSeR := TNFSeR.Create(FNFSe);
end;

destructor NotaFiscal.Destroy;
begin
  FNFSeW.Free;
  FNFSeR.Free;
  FNFSe.Free;
  inherited Destroy;
end;

procedure NotaFiscal.Imprimir;
begin
  with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
  begin
    DANFSE.Provedor := FNFSeR.Provedor;
    if not Assigned(DANFSE) then
      raise EACBrNFSeException.Create('Componente DANFSE n�o associado.')
    else
      DANFSE.ImprimirDANFSE(NFSe);
  end;
end;

procedure NotaFiscal.ImprimirPDF;
begin
  with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
  begin
    DANFSE.Provedor := FNFSeR.Provedor;
    if not Assigned(DANFSE) then
      raise EACBrNFSeException.Create('Componente DANFSE n�o associado.')
    else
      DANFSE.ImprimirDANFSEPDF(NFSe);
  end;
end;

procedure NotaFiscal.Assinar(Assina: Boolean);
var
  XMLStr, CNPJEmitente, CNPJCertificado, InfElemento: String;
  XMLUTF8: AnsiString;
  Leitor: TLeitor;
  Ok: Boolean;
begin
  // Verificando se pode assinar esse XML (O XML tem o mesmo CNPJ do Certificado ??)
  CNPJEmitente    := OnlyNumber(NFSe.Prestador.CNPJ);
  CNPJCertificado := OnlyNumber(TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe).SSL.CertCNPJ);

  // Verificar somente os 8 primeiros digitos, para evitar problemas quando
  // a filial estiver utilizando o certificado da matriz,
  // Mas faz a verifica��o s� se for ambiente de produ��o.
  if TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe).Configuracoes.WebServices.Ambiente = taProducao then
    if (CNPJCertificado <> '') and (Copy(CNPJEmitente, 1, 8) <> Copy(CNPJCertificado, 1, 8)) then
      raise EACBrNFSeException.Create('Erro ao Assinar. O XML informado possui CNPJ diferente do Certificado Digital' );

  // Gera novamente, para processar propriedades que podem ter sido modificadas
  XMLStr := GerarXML;

  // XML j� deve estar em UTF8, para poder ser assinado //
  XMLUTF8 := ConverteXMLtoUTF8(XMLStr);
  FXMLOriginal := XMLUTF8;

  with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
  begin
    case StrToVersaoNFSe(Ok, Configuracoes.Geral.ConfigXML.VersaoXML) of
      ve201,
      ve200,
      ve110: InfElemento := Configuracoes.Geral.ConfigGeral.Prefixo4 + 'InfDeclaracaoPrestacaoServico';

    // Os RPS vers�o 1.00 tem como InfElement = InfRps
    else
      InfElemento := Configuracoes.Geral.ConfigGeral.Prefixo4 + 'InfRps';
    end;

    if Assina then
      FXMLAssinado := SSL.Assinar(String(XMLUTF8), 'Rps', InfElemento)
    else
      FXMLAssinado := XMLOriginal;

    Leitor := TLeitor.Create;
    try
      leitor.Grupo := FXMLAssinado;
      NFSe.signature.URI := Leitor.rAtributo('Reference URI=');
      NFSe.signature.DigestValue := Leitor.rCampo(tcStr, 'DigestValue');
      NFSe.signature.SignatureValue := Leitor.rCampo(tcStr, 'SignatureValue');
      NFSe.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');
    finally
      Leitor.Free;
    end;

    if Configuracoes.Arquivos.Salvar then
      Gravar(CalcularNomeArquivoCompleto(), ifThen(Assina, FXMLAssinado, FXMLOriginal));
  end;
end;

function NotaFiscal.VerificarAssinatura: Boolean;
//var
//  Erro, AXML: String;
//  AssEhValida: Boolean;
begin
(*
  AXML := FXMLOriginal;

  if EstaVazio(AXML) then
  begin

    AXML := FXMLAssinado;
  end;

  with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
  begin
    AssEhValida := SSL.VerificarAssinatura(AXML, Erro);

    if not AssEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o da assinatura da nota: ') +
        NFSe.IdentificacaoRps.Numero + sLineBreak + Erro;
    end;
  end;

  Result := AssEhValida;
*)
  Result := True;  
end;

function NotaFiscal.ValidarRegrasdeNegocios: Boolean;
var
  Erros: String;

  procedure AdicionaErro(const Erro: String);
  begin
    Erros := Erros + Erro + sLineBreak;
  end;

begin
  with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
  begin
    Erros := '';
    (*
      if (NFSe.Ide.indPres = pcEntregaDomicilio) then //B25b-10
        AdicionaErro('794-Rejei��o: NF-e com indicativo de NFC-e com entrega a domic�lio');
    *)
  end;

  Result := EstaVazio(Erros);

  if not Result then
  begin
    Erros := ACBrStr('Erro(s) nas Regras de neg�cios da nota: '+
                     NFSe.IdentificacaoRps.Numero + sLineBreak +
                     Erros);
  end;

  FErroRegrasdeNegocios := Erros;
end;

function NotaFiscal.LerXML(AXML: AnsiString): Boolean;
begin
  FNFSeR.Leitor.Arquivo := AXML;
  FNFSeR.ProvedorConf   := TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe).Configuracoes.Geral.Provedor;
  FNFSeR.PathIniCidades := TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe).Configuracoes.Geral.PathIniCidades;
  FNFSeR.LerXml;

  FXMLOriginal := String(AXML);

  Result := True;
end;

function NotaFiscal.GravarXML(NomeArquivo: String; PathArquivo: String): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);
  Result := TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe).Gravar(FNomeArq, FXMLOriginal);
end;

function NotaFiscal.GravarStream(AStream: TStream): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  AStream.Size := 0;
  WriteStrToStream(AStream, AnsiString(FXMLOriginal));
  Result := True;
end;

procedure NotaFiscal.EnviarEmail(sPara, sAssunto: String; sMensagem: TStrings;
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings);
var
  NomeArq : String;
  AnexosEmail:TStrings;
  StreamNFSe : TMemoryStream;
begin
  if not Assigned(TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe).MAIL) then
    raise EACBrNFSeException.Create('Componente ACBrMail n�o associado');

  AnexosEmail := TStringList.Create;
  StreamNFSe := TMemoryStream.Create;
  try
    AnexosEmail.Clear;
    if Assigned(Anexos) then
      AnexosEmail.Assign(Anexos);

    with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
    begin
      GravarStream(StreamNFSe);

      if (EnviaPDF) then
      begin
        if Assigned(DANFSE) then
        begin
          DANFSE.ImprimirDANFSEPDF(FNFSe);
          NomeArq := PathWithDelim(DANFSE.PathPDF) + NumID + '-nfse.pdf';
          AnexosEmail.Add(NomeArq);
        end;
      end;

      EnviarEmail( sPara, sAssunto, sMensagem, sCC, AnexosEmail, StreamNFSe,
                   NumID +'-nfse.xml');
    end;
  finally
    AnexosEmail.Free;
    StreamNFSe.Free;
  end;
end;

function NotaFiscal.GerarXML: String;
var
  Ok: Boolean;
begin
  with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
  begin
    FNFSeW.LayOutXML := ProvedorToLayoutXML(Configuracoes.Geral.Provedor);

    FNFSeW.NFSeWClass.Provedor      := Configuracoes.Geral.Provedor;
    FNFSeW.NFSeWClass.Prefixo4      := Configuracoes.Geral.ConfigGeral.Prefixo4;
    FNFSeW.NFSeWClass.Identificador := Configuracoes.Geral.ConfigGeral.Identificador;
    FNFSeW.NFSeWClass.QuebradeLinha := Configuracoes.Geral.ConfigGeral.QuebradeLinha;
    FNFSeW.NFSeWClass.URL           := Configuracoes.Geral.ConfigXML.NameSpace;
    FNFSeW.NFSeWClass.VersaoNFSe    := StrToVersaoNFSe(Ok, Configuracoes.Geral.ConfigXML.VersaoXML);
    FNFSeW.NFSeWClass.DefTipos      := Configuracoes.Geral.ConfigSchemas.DefTipos;
    FNFSeW.NFSeWClass.ServicoEnviar := Configuracoes.Geral.ConfigSchemas.ServicoEnviar;

    FNFSeW.NFSeWClass.Gerador.Opcoes.FormatoAlerta := Configuracoes.Geral.FormatoAlerta;
    FNFSeW.NFSeWClass.Gerador.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
  end;

  FNFSeW.GerarXml;
  XMLOriginal := FNFSeW.NFSeWClass.Gerador.ArquivoFormatoXML;
  FXMLAssinado := '';

  FAlertas := FNFSeW.NFSeWClass.Gerador.ListaDeAlertas.Text;
  Result := XMLOriginal;
end;

function NotaFiscal.CalcularNomeArquivo: String;
var
  xID: String;
begin
  xID := Self.NumID;

  if EstaVazio(xID) then
    raise EACBrNFSeException.Create('ID Inv�lido. Imposs�vel Salvar XML');

  Result := xID + '-rps.xml';
end;

function NotaFiscal.CalcularPathArquivo: String;
var
  Data: TDateTime;
begin
  with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
  begin
    if Configuracoes.Arquivos.EmissaoPathNFSe then
      Data := FNFSe.DataEmissaoRps
    else
      Data := Now;

    Result := PathWithDelim(Configuracoes.Arquivos.GetPathRPS(Data, FNFSe.Prestador.Cnpj));
  end;
end;

function NotaFiscal.CalcularNomeArquivoCompleto(NomeArquivo: String;
  PathArquivo: String): String;
begin
  if EstaVazio(NomeArquivo) then
    NomeArquivo := CalcularNomeArquivo;

  if EstaVazio(PathArquivo) then
    PathArquivo := CalcularPathArquivo
  else
    PathArquivo := PathWithDelim(PathArquivo);

  Result := PathArquivo + NomeArquivo;
end;

function NotaFiscal.GetProcessada: Boolean;
begin
//  Result := TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe).CstatProcessado(
//    FNFSe.procNFSe.cStat);
  Result := True;
end;

function NotaFiscal.GetMsg: String;
begin
//  Result := FNFSe.procNFSe.xMotivo;
  Result := '';
end;

function NotaFiscal.GetNumID: String;
var
  NumDoc: String;
begin
  with TACBrNFSe(TNotasFiscais(Collection).ACBrNFSe) do
  begin
    if NFSe.Numero = '' then
      NumDoc := NFSe.IdentificacaoRps.Numero
    else
      NumDoc := NFSe.Numero;

    if Configuracoes.Arquivos.NomeLongoNFSe then
      Result := GerarNomeNFSe(UFparaCodigo(NFSe.PrestadorServico.Endereco.UF),
                              NFSe.DataEmissao,
                              NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj,
                              StrToIntDef(NumDoc, 0))
    else
      Result := NumDoc + NFSe.IdentificacaoRps.Serie;
  end;
end;

function NotaFiscal.GetXMLAssinado: String;
begin
//  if EstaVazio(FXMLAssinado) then
//    Assinar;

  Result := FXMLAssinado;
end;

procedure NotaFiscal.SetXML(const Value: String);
begin
  LerXML(Value);
end;

procedure NotaFiscal.SetXMLOriginal(const Value: String);
begin
  FXMLOriginal := Value;

  if XmlEstaAssinado(FXMLOriginal) then
    FXMLAssinado := FXMLOriginal
  else
    FXMLAssinado := '';
end;

{ TNotasFiscais }

constructor TNotasFiscais.Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
begin
  if not (AOwner is TACBrNFSe) then
    raise EACBrNFSeException.Create('AOwner deve ser do tipo TACBrNFSe');

  inherited;

  FACBrNFSe := TACBrNFSe(AOwner);
  FConfiguracoes := TACBrNFSe(FACBrNFSe).Configuracoes;
end;


function TNotasFiscais.Add: NotaFiscal;
begin
  Result := NotaFiscal(inherited Add);
end;

procedure TNotasFiscais.Assinar(Assina: Boolean);
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Assinar(Assina);
end;

function TNotasFiscais.AssinarLote(XMLLote, docElemento, infElemento: String;
  Assina: Boolean; SignatureNode: String; SelectionNamespaces: String;
  IdSignature: String): String;
var
  XMLAss, ArqXML: String;
begin
  // XMLLote j� deve estar em UTF8, para poder ser assinado //
  ArqXML := ConverteXMLtoUTF8(XMLLote);
  FXMLLoteOriginal := ArqXML;
  Result := FXMLLoteOriginal;

  with TACBrNFSe(FACBrNFSe) do
  begin
    if Assina then
    begin
      XMLAss := SSL.Assinar(ArqXML, docElemento, infElemento,
                            SignatureNode, SelectionNamespaces, IdSignature);
      FXMLLoteAssinado := XMLAss;
      Result := FXMLLoteAssinado;
    end;
  end;
end;

procedure TNotasFiscais.ValidarLote(const XMLLote, NomeArqSchema: String);
var
  Erro, AXML: String;
  NotaEhValida: Boolean;
begin
  AXML := XMLLote;

  with TACBrNFSe(FACBrNFSe) do
  begin
    NotaEhValida := SSL.Validar(AXML, NomeArqSchema, Erro);

    if not NotaEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o dos dados do lote: ') +
        NumeroLote + sLineBreak + FAlertas ;
      FErroValidacaoCompleto := FErroValidacao + sLineBreak + Erro;

      raise EACBrNFSeException.CreateDef(
        IfThen(Configuracoes.Geral.ExibirErroSchema, ErroValidacaoCompleto,
        ErroValidacao));
    end;
  end;
end;

procedure TNotasFiscais.GerarNFSe;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].GerarXML;
end;

function TNotasFiscais.GetItem(Index: integer): NotaFiscal;
begin
  Result := NotaFiscal(inherited Items[Index]);
end;

function TNotasFiscais.GetNamePath: String;
begin
  Result := 'NotaFiscal';
end;

procedure TNotasFiscais.VerificarDANFSE;
begin
  if not Assigned(TACBrNFSe(FACBrNFSe).DANFSE) then
    raise EACBrNFSeException.Create('Componente DANFSE n�o associado.');
end;

procedure TNotasFiscais.Imprimir;
begin
  VerificarDANFSE;
  TACBrNFSe(FACBrNFSe).DANFSE.ImprimirDANFSE(nil);
end;

procedure TNotasFiscais.ImprimirPDF;
begin
  VerificarDANFSE;
  TACBrNFSe(FACBrNFSe).DANFSE.ImprimirDANFSEPDF(nil);
end;

function TNotasFiscais.Insert(Index: integer): NotaFiscal;
begin
  Result := NotaFiscal(inherited Insert(Index));
end;

procedure TNotasFiscais.SetItem(Index: integer; const Value: NotaFiscal);
begin
  Items[Index].Assign(Value);
end;

function TNotasFiscais.VerificarAssinatura(out Erros: String): Boolean;
//var
//  i: integer;
//  Erro: String;
begin
  Result := True;
  (*
  Erros := '';

  for i := 0 to Self.Count - 1 do
  begin
    if not Self.Items[i].VerificarAssinatura then
    begin
      Result := False;
      Erros := Erros + Self.Items[i].ErroValidacao + sLineBreak;
    end;
  end;
*)  
end;

function TNotasFiscais.ValidarRegrasdeNegocios(out Erros: String): Boolean;
var
  i: integer;
begin
  Result := True;
  Erros := '';

  for i := 0 to Self.Count - 1 do
  begin
    if not Self.Items[i].ValidarRegrasdeNegocios then
    begin
      Result := False;
      Erros := Erros + Self.Items[i].ErroRegrasdeNegocios + sLineBreak;
    end;
  end;
end;

function TNotasFiscais.LoadFromFile(CaminhoArquivo: String;
  AGerarNFSe: Boolean = True): Boolean;
var
  XMLStr: String;
  XMLUTF8: AnsiString;
  i: integer;
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.LoadFromFile(CaminhoArquivo);
    XMLUTF8 := ReadStrFromStream(MS, MS.Size);
  finally
    MS.Free;
  end;

  // Converte de UTF8 para a String nativa da IDE //
  XMLStr := DecodeToString(XMLUTF8, True);
  LoadFromString(XMLStr, AGerarNFSe);

  for i := 0 to Self.Count - 1 do
    Self.Items[i].NomeArq := CaminhoArquivo;

  Result := True;
end;

function TNotasFiscais.LoadFromStream(AStream: TStringStream;
  AGerarNFSe: Boolean = True): Boolean;
var
  AXML: AnsiString;
begin
  AStream.Position := 0;
  AXML := ReadStrFromStream(AStream, AStream.Size);

  Result := Self.LoadFromString(String(AXML), AGerarNFSe);
end;

function TNotasFiscais.LoadFromString(AXMLString: String;
  AGerarNFSe: Boolean = True): Boolean;
var
  VersaoNFSe: TVersaoNFSe;
  Ok: Boolean;
  AXML: AnsiString;
  N: integer;

  function PosNFSe: Integer;
  begin
    Result := Pos('</Nfse>', AXMLString);
  end;

  function PosRPS: Integer;
  begin
    if VersaoNFSe < ve200 then
      Result := Pos('</Rps>', AXMLString)
    else
    begin
      // Se a vers�o do XML do RPS for 2.00 ou posterior existem 2 TAGs <Rps>,
      // neste caso devemos buscar a posi��o da segunda.
      Result := Pos('</Rps>', AXMLString);
      Result := PosEx('</Rps>', AXMLString, Result + 1);
    end;
  end;

begin
  VersaoNFSe := StrToVersaoNFSe(Ok, TACBrNFSe(FACBrNFSe).Configuracoes.Geral.ConfigXML.VersaoXML);

  AXMLString := StringReplace(StringReplace( AXMLString, '&lt;', '<', [rfReplaceAll]), '&gt;', '>', [rfReplaceAll]);
  AXMLString := RetirarPrefixos(AXMLString);
(*
  // Converte de UTF8 para a String nativa da IDE //
  AXMLString := RetirarPrefixos(DecodeToString(AXMLString, True));
*)
  Result := False;
  N := PosNFSe;
  if N > 0 then
  begin
    // Ler os XMLs das NFS-e
    while N > 0 do
    begin
      AXML := copy(AXMLString, 1, N + 6);
      AXMLString := Trim(copy(AXMLString, N + 7, length(AXMLString)));

      with Self.Add do
      begin
        LerXML(AXML);

        if AGerarNFSe then // Recalcula o XML
          GerarXML;
      end;

      N := PosNFSe;
    end;
  end
  else begin
    N := PosRPS;
    // Ler os XMLs dos RPS
    while N > 0 do
    begin
      AXML := copy(AXMLString, 1, N + 5);
      AXMLString := Trim(copy(AXMLString, N + 6, length(AXMLString)));
      with Self.Add do
      begin
        LerXML(AXML);

        if AGerarNFSe then // Recalcula o XML
          GerarXML;
      end;

      N := PosRPS;
    end;
  end;
end;

function TNotasFiscais.GravarXML(PathNomeArquivo: String): Boolean;
var
  i: integer;
  NomeArq, PathArq : String;
begin
  Result := True;
  i := 0;
  while Result and (i < Self.Count) do
  begin
    PathArq := ExtractFilePath(PathNomeArquivo);
    NomeArq := ExtractFileName(PathNomeArquivo);
    Result := Self.Items[i].GravarXML(NomeArq, PathArq);
    Inc(i);
  end;
end;

end.
