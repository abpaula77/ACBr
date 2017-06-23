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

unit ACBrBPeBilhetes;

interface

uses
  Classes, SysUtils, Dialogs, StrUtils,
  ACBrBPeConfiguracoes, ACBrDFeUtil,
  pcnBPe, pcnBPeR, pcnBPeW, pcnConversao, pcnAuxiliar, pcnLeitor;

type

  { Bilhete }

  Bilhete = class(TCollectionItem)
  private
    FBPe: TBPe;
    FBPeW: TBPeW;
    FBPeR: TBPeR;

    FXMLAssinado: String;
    FXMLOriginal: String;
    FAlertas: String;
    FErroValidacao: String;
    FErroValidacaoCompleto: String;
    FErroRegrasdeNegocios: String;
    FNomeArq: String;

    function GetConfirmada: Boolean;
    function GetProcessada: Boolean;
    function GetCancelada: Boolean;

    function GetMsg: String;
    function GetNumID: String;
    function GetXMLAssinado: String;
    procedure SetXML(AValue: String);
    procedure SetXMLOriginal(AValue: String);
    function ValidarConcatChave: Boolean;
    function CalcularNomeArquivo: String;
    function CalcularPathArquivo: String;
  public
    constructor Create(Collection2: TCollection); override;
    destructor Destroy; override;
    procedure Imprimir;
    procedure ImprimirPDF;

    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura: Boolean;
    function ValidarRegrasdeNegocios: Boolean;

    function LerXML(AXML: String): Boolean;

    function GerarXML: String;
    function GravarXML(NomeArquivo: String = ''; PathArquivo: String = ''): Boolean;

    function GerarTXT: String;
    function GravarTXT(NomeArquivo: String = ''; PathArquivo: String = ''): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil);

    property NomeArq: String read FNomeArq write FNomeArq;
    function CalcularNomeArquivoCompleto(NomeArquivo: String = '';
      PathArquivo: String = ''): String;

    property BPe: TBPe read FBPe;

    // Atribuir a "XML", faz o componente transferir os dados lido para as propriedades internas e "XMLAssinado"
    property XML: String         read FXMLOriginal   write SetXML;
    // Atribuir a "XMLOriginal", reflete em XMLAssinado, se existir a tag de assinatura
    property XMLOriginal: String read FXMLOriginal   write SetXMLOriginal;    // Sempre deve estar em UTF8
    property XMLAssinado: String read GetXMLAssinado write FXMLAssinado;      // Sempre deve estar em UTF8
    property Confirmada: Boolean read GetConfirmada;
    property Processada: Boolean read GetProcessada;
    property Cancelada: Boolean read GetCancelada;
    property Msg: String read GetMsg;
    property NumID: String read GetNumID;

    property Alertas: String read FAlertas;
    property ErroValidacao: String read FErroValidacao;
    property ErroValidacaoCompleto: String read FErroValidacaoCompleto;
    property ErroRegrasdeNegocios: String read FErroRegrasdeNegocios;

  end;

  { TBilhetes }

  TBilhetes = class(TOwnedCollection)
  private
    FACBrBPe: TComponent;
    FConfiguracoes: TConfiguracoesBPe;

    function GetItem(Index: integer): Bilhete;
    procedure SetItem(Index: integer; const Value: Bilhete);

    procedure VerificarDABPE;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);

    procedure GerarBPe;
    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura(out Erros: String): Boolean;
    function ValidarRegrasdeNegocios(out Erros: String): Boolean;
    procedure Imprimir;
    procedure ImprimirCancelado;
    procedure ImprimirResumido;
    procedure ImprimirPDF;
    procedure ImprimirResumidoPDF;
    function Add: Bilhete;
    function Insert(Index: integer): Bilhete;

    property Items[Index: integer]: Bilhete read GetItem write SetItem; default;

    function GetNamePath: String; override;
    // Incluido o Parametro AGerarBPe que determina se ap�s carregar os dados da BPe
    // para o componente, ser� gerado ou n�o novamente o XML da BPe.
    function LoadFromFile(CaminhoArquivo: String; AGerarBPe: Boolean = True): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarBPe: Boolean = True): Boolean;
    function LoadFromString(AXMLString: String; AGerarBPe: Boolean = True): Boolean;
    function GravarXML(PathNomeArquivo: String = ''): Boolean;
    function GravarTXT(PathNomeArquivo: String = ''): Boolean;

    property ACBrBPe: TComponent read FACBrBPe;
  end;

implementation

uses
  ACBrBPe, ACBrUtil, pcnConversaoBPe, synautil;

{ Bilhete }

constructor Bilhete.Create(Collection2: TCollection);
begin
  inherited Create(Collection2);
  FBPe := TBPe.Create;
  FBPeW := TBPeW.Create(FBPe);
  FBPeR := TBPeR.Create(FBPe);

  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    FBPe.Ide.modelo := 63;
    FBPe.infBPe.Versao := VersaoBPeToDbl(Configuracoes.Geral.VersaoDF);

    FBPe.Ide.tpBPe := tbNormal;
    FBPe.Ide.verProc := 'ACBrBPe';
    FBPe.Ide.tpAmb := Configuracoes.WebServices.Ambiente;
    FBPe.Ide.tpEmis := Configuracoes.Geral.FormaEmissao;
  end;
end;

destructor Bilhete.Destroy;
begin
  FBPeW.Free;
  FBPeR.Free;
  FBPe.Free;
  inherited Destroy;
end;

procedure Bilhete.Imprimir;
begin
  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    if not Assigned(DABPE) then
      raise EACBrBPeException.Create('Componente DABPE n�o associado.')
    else
      DABPE.ImprimirDABPE(BPe);
  end;
end;

procedure Bilhete.ImprimirPDF;
begin
  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    if not Assigned(DABPE) then
      raise EACBrBPeException.Create('Componente DABPE n�o associado.')
    else
      DABPE.ImprimirDABPEPDF(BPe);
  end;
end;

procedure Bilhete.Assinar;
var
  XMLStr: String;
  XMLUTF8: AnsiString;
  Leitor: TLeitor;
begin
  TACBrBPe(TBilhetes(Collection).ACBrBPe).SSL.ValidarCNPJCertificado( BPe.Emit.CNPJ );

  // Gera novamente, para processar propriedades que podem ter sido modificadas
  XMLStr := GerarXML;

  // XML j� deve estar em UTF8, para poder ser assinado //
  XMLUTF8 := ConverteXMLtoUTF8(XMLStr);

  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    FXMLAssinado := SSL.Assinar(String(XMLUTF8), 'BPe', 'infBPe');
    // SSL.Assinar() sempre responde em UTF8...
    FXMLOriginal := FXMLAssinado;

    Leitor := TLeitor.Create;
    try
      leitor.Grupo := FXMLAssinado;
      BPe.signature.URI := Leitor.rAtributo('Reference URI=');
      BPe.signature.DigestValue := Leitor.rCampo(tcStr, 'DigestValue');
      BPe.signature.SignatureValue := Leitor.rCampo(tcStr, 'SignatureValue');
      BPe.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');
    finally
      Leitor.Free;
    end;

    with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
    begin
      BPe.infBPeSupl.qrCodBPe := GetURLQRCode(BPe.Ide.cUF,
                                              BPe.Ide.tpAmb,
                                              BPe.infBPe.ID,
                                              BPe.signature.DigestValue);

//      BPe.infBPeSupl.boardPassBPe := GetURLConsultaNFCe(BPe.Ide.cUF, BPe.Ide.tpAmb);

      GerarXML;
    end;

    if Configuracoes.Arquivos.Salvar and
       (not Configuracoes.Arquivos.SalvarApenasBPeProcessadas) then
    begin
      if NaoEstaVazio(NomeArq) then
        Gravar(NomeArq, FXMLAssinado)
      else
        Gravar(CalcularNomeArquivoCompleto(), FXMLAssinado);
    end;
  end;
end;

procedure Bilhete.Validar;
var
  Erro, AXML, DeclaracaoXML: String;
  BilheteEhValida: Boolean;
  ALayout: TLayOutBPe;
  VerServ: Real;
begin
  AXML := FXMLAssinado;
  if AXML = '' then
    AXML := XMLOriginal;

  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    VerServ := FBPe.infBPe.Versao;
    ALayout := LayBPeRecepcao;

    // Extraindo apenas os dados da BPe (sem BPeProc)
    DeclaracaoXML := ObtemDeclaracaoXML(AXML);
    AXML := DeclaracaoXML + '<BPe xmlns' +
            RetornarConteudoEntre(AXML, '<BPe xmlns', '</BPe>') +
            '</BPe>';

    BilheteEhValida := SSL.Validar(AXML, GerarNomeArqSchema(ALayout, VerServ), Erro);

    if not BilheteEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o dos dados do Bilhete: ') +
        IntToStr(BPe.Ide.nBP) + sLineBreak + FAlertas ;
      FErroValidacaoCompleto := FErroValidacao + sLineBreak + Erro;

      raise EACBrBPeException.CreateDef(
        IfThen(Configuracoes.Geral.ExibirErroSchema, ErroValidacaoCompleto,
        ErroValidacao));
    end;
  end;
end;

function Bilhete.VerificarAssinatura: Boolean;
var
  Erro, AXML: String;
  AssEhValida: Boolean;
begin
  AXML := FXMLAssinado;
  if AXML = '' then
    AXML := XMLOriginal;

  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    AssEhValida := SSL.VerificarAssinatura(AXML, Erro, 'infBPe');

    if not AssEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o da assinatura do Bilhete: ') +
        IntToStr(BPe.Ide.nBP) + sLineBreak + Erro;
    end;
  end;

  Result := AssEhValida;
end;

function Bilhete.ValidarRegrasdeNegocios: Boolean;
var
  Erros: String;
  I: Integer;
  Agora: TDateTime;

  procedure GravaLog(AString: String);
  begin
    //DEBUG
    //Log := Log + FormatDateTime('hh:nn:ss:zzz',Now) + ' - ' + AString + sLineBreak;
  end;

  procedure AdicionaErro(const Erro: String);
  begin
    Erros := Erros + Erro + sLineBreak;
  end;

begin
  Agora := Now;
  GravaLog('Inicio da Valida��o');

  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    Erros := '';

    GravaLog('Validar: 701-vers�o');
    if BPe.infBPe.Versao < 1.00 then
      AdicionaErro('701-Rejei��o: Vers�o inv�lida');

    for I:=0 to BPe.autXML.Count-1 do
    begin
      GravaLog('Validar: 325-'+IntToStr(I)+'-CPF download');
      if (Length(Trim(OnlyNumber(BPe.autXML[I].CNPJCPF))) <= 11) and
        not ValidarCPF(BPe.autXML[I].CNPJCPF) then
        AdicionaErro('325-Rejei��o: CPF autorizado para download inv�lido');

      GravaLog('Validar: 323-'+IntToStr(I)+'-CNPJ download');
      if (Length(Trim(OnlyNumber(BPe.autXML[I].CNPJCPF))) > 11) and
        not ValidarCNPJ(BPe.autXML[I].CNPJCPF) then
        AdicionaErro('323-Rejei��o: CNPJ autorizado para download inv�lido');
    end;

  end;

  Result := EstaVazio(Erros);

  if not Result then
  begin
    Erros := ACBrStr('Erro(s) nas Regras de neg�cios do Bilhete: '+
                     IntToStr(BPe.Ide.nBP) + sLineBreak +
                     Erros);
  end;

  GravaLog('Fim da Valida��o. Tempo: '+FormatDateTime('hh:nn:ss:zzz', Now - Agora)+sLineBreak+
           'Erros:' + Erros);

  //DEBUG
  //WriteToTXT('c:\temp\Bilhete.txt', Log);

  FErroRegrasdeNegocios := Erros;
end;

function Bilhete.LerXML(AXML: String): Boolean;
var
  XMLStr: String;
begin
  XMLOriginal := AXML;  // SetXMLOriginal() ir� verificar se AXML est� em UTF8

  { Verifica se precisa converter "AXML" de UTF8 para a String nativa da IDE.
    Isso � necess�rio, para que as propriedades fiquem com a acentua��o correta }
  XMLStr := ParseText(AXML, True, XmlEhUTF8(AXML));

  FBPeR.Leitor.Arquivo := XMLStr;
  FBPeR.LerXml;

  Result := True;
end;

function Bilhete.GravarXML(NomeArquivo: String; PathArquivo: String): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);

  Result := TACBrBPe(TBilhetes(Collection).ACBrBPe).Gravar(FNomeArq, FXMLOriginal);
end;

function Bilhete.GravarTXT(NomeArquivo: String; PathArquivo: String): Boolean;
var
  ATXT: String;
begin
  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);
  ATXT := GerarTXT;
  Result := TACBrBPe(TBilhetes(Collection).ACBrBPe).Gravar(
    ChangeFileExt(FNomeArq, '.txt'), ATXT);
end;

function Bilhete.GravarStream(AStream: TStream): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  AStream.Size := 0;
  WriteStrToStream(AStream, AnsiString(FXMLOriginal));
  Result := True;
end;

procedure Bilhete.EnviarEmail(sPara, sAssunto: String; sMensagem: TStrings;
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings; sReplyTo: TStrings);
var
  NomeArq : String;
  AnexosEmail:TStrings;
  StreamBPe : TMemoryStream;
begin
  if not Assigned(TACBrBPe(TBilhetes(Collection).ACBrBPe).MAIL) then
    raise EACBrBPeException.Create('Componente ACBrMail n�o associado');

  AnexosEmail := TStringList.Create;
  StreamBPe := TMemoryStream.Create;
  try
    AnexosEmail.Clear;
    if Assigned(Anexos) then
      AnexosEmail.Assign(Anexos);

    with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
    begin
      GravarStream(StreamBPe);

      if (EnviaPDF) then
      begin
        if Assigned(DABPE) then
        begin
          DABPE.ImprimirDABPEPDF(FBPe);
          NomeArq := PathWithDelim(DABPE.PathPDF) + NumID + '-bpe.pdf';
          AnexosEmail.Add(NomeArq);
        end;
      end;

      EnviarEmail( sPara, sAssunto, sMensagem, sCC, AnexosEmail, StreamBPe,
                   NumID +'-bpe.xml', sReplyTo);
    end;
  finally
    AnexosEmail.Free;
    StreamBPe.Free;
  end;
end;

function Bilhete.GerarXML: String;
var
  IdAnterior : String;
begin
  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    IdAnterior := BPe.infBPe.ID;
    FBPeW.Gerador.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FBPeW.Gerador.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FBPeW.Gerador.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FBPeW.Gerador.Opcoes.IdentarXML := Configuracoes.Geral.IdentarXML;
    pcnAuxiliar.TimeZoneConf.Assign( Configuracoes.WebServices.TimeZoneConf );
  end;

  FBPeW.Opcoes.GerarTXTSimultaneamente := False;

  FBPeW.GerarXml;
  //DEBUG
  //WriteToTXT('c:\temp\Bilhete.xml', FBPeW.Gerador.ArquivoFormatoXML, False, False);

  XMLOriginal := FBPeW.Gerador.ArquivoFormatoXML;  // SetXMLOriginal() ir� converter para UTF8

  { XML gerado pode ter nova Chave e ID, ent�o devemos calcular novamente o
    nome do arquivo, mantendo o PATH do arquivo carregado }
  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FBPe.infBPe.ID)) then
    FNomeArq := CalcularNomeArquivoCompleto('', ExtractFilePath(FNomeArq));

  FAlertas := ACBrStr( FBPeW.Gerador.ListaDeAlertas.Text );
  Result := FXMLOriginal;
end;

function Bilhete.GerarTXT: String;
var
  IdAnterior : String;
begin
  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    IdAnterior := BPe.infBPe.ID;
    FBPeW.Gerador.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FBPeW.Gerador.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FBPeW.Gerador.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FBPeW.Gerador.Opcoes.IdentarXML := Configuracoes.Geral.IdentarXML;
  end;

  FBPeW.Opcoes.GerarTXTSimultaneamente := True;

  FBPeW.GerarXml;
  XMLOriginal := FBPeW.Gerador.ArquivoFormatoXML;

  // XML gerado pode ter nova Chave e ID, ent�o devemos calcular novamente o
  // nome do arquivo, mantendo o PATH do arquivo carregado
  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FBPe.infBPe.ID)) then
    FNomeArq := CalcularNomeArquivoCompleto('', ExtractFilePath(FNomeArq));

  FAlertas := FBPeW.Gerador.ListaDeAlertas.Text;
  Result := FBPeW.Gerador.ArquivoFormatoTXT;
end;

function Bilhete.CalcularNomeArquivo: String;
var
  xID: String;
  NomeXML: String;
begin
  xID := Self.NumID;

  if EstaVazio(xID) then
    raise EACBrBPeException.Create('ID Inv�lido. Imposs�vel Salvar XML');

  NomeXML := '-bpe.xml';

  Result := xID + NomeXML;
end;

function Bilhete.CalcularPathArquivo: String;
var
  Data: TDateTime;
begin
  with TACBrBPe(TBilhetes(Collection).ACBrBPe) do
  begin
    if Configuracoes.Arquivos.EmissaoPathBPe then
      Data := FBPe.Ide.dhEmi
    else
      Data := Now;

    Result := PathWithDelim(Configuracoes.Arquivos.GetPathBPe(Data, FBPe.Emit.CNPJ));
  end;
end;

function Bilhete.CalcularNomeArquivoCompleto(NomeArquivo: String;
  PathArquivo: String): String;
var
  PathNoArquivo: String;
begin
  if EstaVazio(NomeArquivo) then
    NomeArquivo := CalcularNomeArquivo;

  PathNoArquivo := ExtractFilePath(NomeArquivo);
  if EstaVazio(PathNoArquivo) then
  begin
    if EstaVazio(PathArquivo) then
      PathArquivo := CalcularPathArquivo
    else
      PathArquivo := PathWithDelim(PathArquivo);
  end
  else
    PathArquivo := '';

  Result := PathArquivo + NomeArquivo;
end;

function Bilhete.ValidarConcatChave: Boolean;
var
  wAno, wMes, wDia: word;
  chaveBPe : String;
begin
  DecodeDate(BPe.ide.dhEmi, wAno, wMes, wDia);

  chaveBPe := 'BPe'+OnlyNumber(BPe.infBPe.ID);
  {(*}
  Result := not
    ((Copy(chaveBPe, 4, 2) <> IntToStrZero(BPe.Ide.cUF, 2)) or
    (Copy(chaveBPe, 6, 2)  <> Copy(FormatFloat('0000', wAno), 3, 2)) or
    (Copy(chaveBPe, 8, 2)  <> FormatFloat('00', wMes)) or
    (Copy(chaveBPe, 10, 14)<> PadLeft(OnlyNumber(BPe.Emit.CNPJ), 14, '0')) or
    (Copy(chaveBPe, 24, 2) <> IntToStrZero(BPe.Ide.modelo, 2)) or
    (Copy(chaveBPe, 26, 3) <> IntToStrZero(BPe.Ide.serie, 3)) or
    (Copy(chaveBPe, 29, 9) <> IntToStrZero(BPe.Ide.nBP, 9)) or
    (Copy(chaveBPe, 38, 1) <> TpEmisToStr(BPe.Ide.tpEmis)) or
    (Copy(chaveBPe, 39, 8) <> IntToStrZero(BPe.Ide.cBP, 8)));
  {*)}
end;

function Bilhete.GetConfirmada: Boolean;
begin
  Result := TACBrBPe(TBilhetes(Collection).ACBrBPe).CstatConfirmada(
    FBPe.procBPe.cStat);
end;

function Bilhete.GetProcessada: Boolean;
begin
  Result := TACBrBPe(TBilhetes(Collection).ACBrBPe).CstatProcessado(
    FBPe.procBPe.cStat);
end;

function Bilhete.GetCancelada: Boolean;
begin
  Result := TACBrBPe(TBilhetes(Collection).ACBrBPe).CstatCancelada(
    FBPe.procBPe.cStat);
end;

function Bilhete.GetMsg: String;
begin
  Result := FBPe.procBPe.xMotivo;
end;

function Bilhete.GetNumID: String;
begin
  Result := OnlyNumber(BPe.infBPe.ID);
end;

function Bilhete.GetXMLAssinado: String;
begin
  if EstaVazio(FXMLAssinado) then
    Assinar;

  Result := FXMLAssinado;
end;

procedure Bilhete.SetXML(AValue: String);
begin
  LerXML(AValue);
end;

procedure Bilhete.SetXMLOriginal(AValue: String);
var
  XMLUTF8: String;
begin
  { Garante que o XML informado est� em UTF8, se ele realmente estiver, nada
    ser� modificado por "ConverteXMLtoUTF8"  (mantendo-o "original") }
  XMLUTF8 := ConverteXMLtoUTF8(AValue);

  FXMLOriginal := XMLUTF8;

  if XmlEstaAssinado(FXMLOriginal) then
    FXMLAssinado := FXMLOriginal
  else
    FXMLAssinado := '';
end;

{ TBilhetes }

constructor TBilhetes.Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
begin
  if not (AOwner is TACBrBPe) then
    raise EACBrBPeException.Create('AOwner deve ser do tipo TACBrBPe');

  inherited;

  FACBrBPe := TACBrBPe(AOwner);
  FConfiguracoes := TACBrBPe(FACBrBPe).Configuracoes;
end;


function TBilhetes.Add: Bilhete;
begin
  Result := Bilhete(inherited Add);
end;

procedure TBilhetes.Assinar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Assinar;
end;

procedure TBilhetes.GerarBPe;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].GerarXML;
end;

function TBilhetes.GetItem(Index: integer): Bilhete;
begin
  Result := Bilhete(inherited Items[Index]);
end;

function TBilhetes.GetNamePath: String;
begin
  Result := 'Bilhete';
end;

procedure TBilhetes.VerificarDABPE;
begin
  if not Assigned(TACBrBPe(FACBrBPe).DABPE) then
    raise EACBrBPeException.Create('Componente DABPE n�o associado.');
end;

procedure TBilhetes.Imprimir;
begin
  VerificarDABPE;
  TACBrBPe(FACBrBPe).DABPE.ImprimirDABPE(nil);
end;

procedure TBilhetes.ImprimirCancelado;
begin
  VerificarDABPE;
  TACBrBPe(FACBrBPe).DABPE.ImprimirDABPECancelado(nil);
end;

procedure TBilhetes.ImprimirResumido;
begin
  VerificarDABPE;
  TACBrBPe(FACBrBPe).DABPE.ImprimirDABPEResumido(nil);
end;

procedure TBilhetes.ImprimirPDF;
begin
  VerificarDABPE;
  TACBrBPe(FACBrBPe).DABPE.ImprimirDABPEPDF(nil);
end;

procedure TBilhetes.ImprimirResumidoPDF;
begin
  VerificarDABPE;
  TACBrBPe(FACBrBPe).DABPE.ImprimirDABPEResumidoPDF(nil);
end;

function TBilhetes.Insert(Index: integer): Bilhete;
begin
  Result := Bilhete(inherited Insert(Index));
end;

procedure TBilhetes.SetItem(Index: integer; const Value: Bilhete);
begin
  Items[Index].Assign(Value);
end;

procedure TBilhetes.Validar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Validar;   // Dispara exception em caso de erro
end;

function TBilhetes.VerificarAssinatura(out Erros: String): Boolean;
var
  i: integer;
begin
  Result := True;
  Erros := '';

  if Self.Count < 1 then
  begin
    Erros := 'Nenhum BPe carregado';
    Result := False;
    Exit;
  end;

  for i := 0 to Self.Count - 1 do
  begin
    if not Self.Items[i].VerificarAssinatura then
    begin
      Result := False;
      Erros := Erros + Self.Items[i].ErroValidacao + sLineBreak;
    end;
  end;
end;

function TBilhetes.ValidarRegrasdeNegocios(out Erros: String): Boolean;
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

function TBilhetes.LoadFromFile(CaminhoArquivo: String;
  AGerarBPe: Boolean = True): Boolean;
var
  XMLUTF8: AnsiString;
  i, l: integer;
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.LoadFromFile(CaminhoArquivo);
    XMLUTF8 := ReadStrFromStream(MS, MS.Size);
  finally
    MS.Free;
  end;

  l := Self.Count; // Indice da �ltima Bilhete j� existente
  Result := LoadFromString(String(XMLUTF8), AGerarBPe);

  if Result then
  begin
    // Atribui Nome do arquivo a novas Bilhetes inseridas //
    for i := l to Self.Count - 1 do
      Self.Items[i].NomeArq := CaminhoArquivo;
  end;
end;

function TBilhetes.LoadFromStream(AStream: TStringStream;
  AGerarBPe: Boolean = True): Boolean;
var
  AXML: AnsiString;
begin
  AStream.Position := 0;
  AXML := ReadStrFromStream(AStream, AStream.Size);

  Result := Self.LoadFromString(String(AXML), AGerarBPe);
end;

function TBilhetes.LoadFromString(AXMLString: String;
  AGerarBPe: Boolean = True): Boolean;
var
  ABPeXML, XMLStr: AnsiString;
  P, N: integer;

  function PosBPe: integer;
  begin
    Result := pos('</BPe>', XMLStr);
  end;

begin
  // Verifica se precisa Converter de UTF8 para a String nativa da IDE //
  XMLStr := ConverteXMLtoNativeString(AXMLString);

  N := PosBPe;
  while N > 0 do
  begin
    P := pos('</BPeProc>', XMLStr);

    if P <= 0 then
      P := pos('</procBPe>', XMLStr);  // BPe obtida pelo Portal da Receita

    if P > 0 then
    begin
      ABPeXML := copy(XMLStr, 1, P + 10);
      XMLStr := Trim(copy(XMLStr, P + 10, length(XMLStr)));
    end
    else
    begin
      ABPeXML := copy(XMLStr, 1, N + 6);
      XMLStr := Trim(copy(XMLStr, N + 6, length(XMLStr)));
    end;

    with Self.Add do
    begin
      LerXML(ABPeXML);

      if AGerarBPe then // Recalcula o XML
        GerarXML;
    end;

    N := PosBPe;
  end;

  Result := Self.Count > 0;
end;

function TBilhetes.GravarXML(PathNomeArquivo: String): Boolean;
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

function TBilhetes.GravarTXT(PathNomeArquivo: String): Boolean;
var
  SL: TStringList;
  ArqTXT: String;
  I: integer;
begin
  Result := False;
  SL := TStringList.Create;
  try
    SL.Clear;
    for I := 0 to Self.Count - 1 do
    begin
      ArqTXT := Self.Items[I].GerarTXT;
      SL.Add(ArqTXT);
    end;

    if SL.Count > 0 then
    begin
      // Inserindo cabe�alho //
      SL.Insert(0, 'BILHETE|' + IntToStr(Self.Count));

      // Apagando as linhas em branco //
      i := 0;
      while (i <= SL.Count - 1) do
      begin
        if SL[I] = '' then
          SL.Delete(I)
        else
          Inc(i);
      end;

      if EstaVazio(PathNomeArquivo) then
        PathNomeArquivo := PathWithDelim(
          TACBrBPe(FACBrBPe).Configuracoes.Arquivos.PathSalvar) + 'BPe.TXT';

      SL.SaveToFile(PathNomeArquivo);
      Result := True;
    end;
  finally
    SL.Free;
  end;
end;

end.
