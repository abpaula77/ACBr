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

unit ACBrBPe;

interface

uses
  Classes, SysUtils, ACBrBase,
  ACBrDFe, ACBrDFeException, ACBrDFeConfiguracoes,
  ACBrBPeConfiguracoes, ACBrBPeWebServices, ACBrBPeBilhetes, ACBrBPeDABPEClass,
  pcnBPe, pcnConversao, pcnConversaoBPe, pcnEnvEventoBPe, pcnRetDistDFeIntBPe,
  ACBrUtil;

const
  ACBRBPE_VERSAO = '2.0.0a';
  ACBRBPE_NAMESPACE = 'http://www.portalfiscal.inf.br/bpe';
  ACBRBPE_CErroAmbienteDiferente = 'Ambiente do XML (tpAmb) � diferente do ' +
               'configurado no Componente (Configuracoes.WebServices.Ambiente)';

type
  EACBrBPeException = class(EACBrDFeException);

  { TACBrBPe }
	{$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TACBrBPe = class(TACBrDFe)
  private
    FDABPE: TACBrBPeDABPEClass;
    FBilhetes: TBilhetes;
    FEventoBPe: TEventoBPe;
    FRetDistDFeInt: TRetDistDFeInt;
    FStatus: TStatusACBrBPe;
    FWebServices: TWebServices;

    function GetConfiguracoes: TConfiguracoesBPe;
    function Distribuicao(AcUFAutor: integer; ACNPJCPF, AultNSU, ANSU,
      chBPe: String): Boolean;

    procedure SetConfiguracoes(AValue: TConfiguracoesBPe);
    procedure SetDABPE(const Value: TACBrBPeDABPEClass);
  protected
    function CreateConfiguracoes: TConfiguracoes; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function GetAbout: String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure EnviarEmail(sPara, sAssunto: String;
      sMensagem: TStrings = nil; sCC: TStrings = nil; Anexos: TStrings = nil;
      StreamBPe: TStream = nil; NomeArq: String = ''; sReplyTo: TStrings = nil); override;

    function Enviar(ALote: integer; Imprimir: Boolean = True): Boolean; overload;
    function Enviar(ALote: String; Imprimir: Boolean = True): Boolean; overload;

    function GetNomeModeloDFe: String; override;
    function GetNameSpaceURI: String; override;
    function EhAutorizacao(AVersao: TVersaoBPe; AUFCodigo: Integer): Boolean;

    function CstatConfirmada(AValue: integer): Boolean;
    function CstatProcessado(AValue: integer): Boolean;
    function CstatCancelada(AValue: integer): Boolean;

    function Cancelamento(AJustificativa: String; ALote: integer = 0): Boolean;
    function Consultar( AChave: String = ''): Boolean;
    function EnviarEvento(idLote: integer): Boolean;

    function NomeServicoToNomeSchema(const NomeServico: String): String; override;
    procedure LerServicoDeParams(LayOutServico: TLayOutBPe; var Versao: Double;
      var URL: String); reintroduce; overload;
    function LerVersaoDeParams(LayOutServico: TLayOutBPe): String; reintroduce; overload;

    function GetURLConsultaBPe(const CUF: integer;
      const TipoAmbiente: TpcnTipoAmbiente): String;
    function GetURLQRCode(const CUF: integer; const TipoAmbiente: TpcnTipoAmbiente;
      const AChaveBPe: String; const DigestValue: String): String;

    function IdentificaSchema(const AXML: String): TSchemaBPe;
    function GerarNomeArqSchema(const ALayOut: TLayOutBPe; VersaoServico: Double
      ): String;

    property WebServices: TWebServices read FWebServices write FWebServices;
    property Bilhetes: TBilhetes read FBilhetes write FBilhetes;
    property EventoBPe: TEventoBPe read FEventoBPe write FEventoBPe;
    property RetDistDFeInt: TRetDistDFeInt read FRetDistDFeInt write FRetDistDFeInt;
    property Status: TStatusACBrBPe read FStatus;

    procedure SetStatus(const stNewStatus: TStatusACBrBPe);
    procedure ImprimirEvento;
    procedure ImprimirEventoPDF;

    function DistribuicaoDFe(AcUFAutor: integer; ACNPJCPF, AultNSU,
      ANSU: String; AchBPe: String = ''): Boolean;
    function DistribuicaoDFePorUltNSU(AcUFAutor: integer; ACNPJCPF,
      AultNSU: String): Boolean;
    function DistribuicaoDFePorNSU(AcUFAutor: integer; ACNPJCPF,
      ANSU: String): Boolean;
    function DistribuicaoDFePorChaveBPe(AcUFAutor: integer; ACNPJCPF,
      AchBPe: String): Boolean;

    procedure EnviarEmailEvento(sPara, sAssunto: String;
      sMensagem: TStrings = nil; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil);

  published
    property Configuracoes: TConfiguracoesBPe
      read GetConfiguracoes write SetConfiguracoes;
    property DABPE: TACBrBPeDABPEClass read FDABPE write SetDABPE;
  end;

Const
  ModeloDF = 'BPe';
  
implementation

uses
  strutils, dateutils,
  pcnAuxiliar, synacode;

{$IFDEF FPC}
 {$IFDEF CPU64}
  {$R ACBrBPeServicos.res}  // Dificuldades de compilar Recurso em 64 bits
 {$ELSE}
  {$R ACBrBPeServicos.rc}
 {$ENDIF}
{$ELSE}
 {$R ACBrBPeServicos.res}
{$ENDIF}

{ TACBrBPe }

constructor TACBrBPe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FBilhetes := TBilhetes.Create(Self, Bilhete);
  FEventoBPe := TEventoBPe.Create;
  FRetDistDFeInt := TRetDistDFeInt.Create;
  FWebServices := TWebServices.Create(Self);
end;

destructor TACBrBPe.Destroy;
begin
  FBilhetes.Free;
  FEventoBPe.Free;
  FRetDistDFeInt.Free;
  FWebServices.Free;

  inherited;
end;

procedure TACBrBPe.EnviarEmail(sPara, sAssunto: String; sMensagem: TStrings;
  sCC: TStrings; Anexos: TStrings; StreamBPe: TStream; NomeArq: String;
  sReplyTo: TStrings);
begin
  SetStatus( stBPeEmail );

  try
    inherited EnviarEmail(sPara, sAssunto, sMensagem, sCC, Anexos, StreamBPe, NomeArq,
      sReplyTo);
  finally
    SetStatus( stIdleBPe );
  end;
end;

procedure TACBrBPe.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDABPE <> nil) and
    (AComponent is TACBrBPeDABPEClass) then
    FDABPE := nil;
end;

function TACBrBPe.GetAbout: String;
begin
  Result := 'ACBrBPe Ver: ' + ACBRBPe_VERSAO;
end;

function TACBrBPe.CreateConfiguracoes: TConfiguracoes;
begin
  Result := TConfiguracoesBPe.Create(Self);
end;

procedure TACBrBPe.SetDABPE(const Value: TACBrBPeDABPEClass);
var
  OldValue: TACBrBPeDABPEClass;
begin
  if Value <> FDABPE then
  begin
    if Assigned(FDABPE) then
      FDABPE.RemoveFreeNotification(Self);

    OldValue := FDABPE;   // Usa outra variavel para evitar Loop Infinito
    FDABPE := Value;    // na remo��o da associa��o dos componentes

    if Assigned(OldValue) then
      if Assigned(OldValue.ACBrBPe) then
        OldValue.ACBrBPe := nil;

    if Value <> nil then
    begin
      Value.FreeNotification(self);
      Value.ACBrBPe := self;
    end;
  end;
end;

function TACBrBPe.GetNomeModeloDFe: String;
begin
  Result := 'BPe';
end;

function TACBrBPe.GetNameSpaceURI: String;
begin
  Result := ACBRBPe_NAMESPACE;
end;

function TACBrBPe.CstatConfirmada(AValue: integer): Boolean;
begin
  case AValue of
    100, 110, 150, 301, 302, 303: Result := True;
    else
      Result := False;
  end;
end;

function TACBrBPe.CstatProcessado(AValue: integer): Boolean;
begin
  case AValue of
    100, 110, 150, 301, 302, 303: Result := True;
    else
      Result := False;
  end;
end;

function TACBrBPe.CstatCancelada(AValue: integer): Boolean;
begin
  case AValue of
    101, 151, 155: Result := True;
    else
      Result := False;
  end;
end;

function TACBrBPe.EhAutorizacao( AVersao: TVersaoBPe; AUFCodigo: Integer ): Boolean;
begin
  Result := True;
end;

function TACBrBPe.IdentificaSchema(const AXML: String): TSchemaBPe;
var
  lTipoEvento: String;
  I: integer;
begin

  Result := schBPe;
  I := pos('<infBPe', AXML);
  if I = 0 then
  begin
    I := Pos('<infEvento', AXML);
    if I > 0 then
    begin
      lTipoEvento := Trim(RetornarConteudoEntre(AXML, '<tpEvento>', '</tpEvento>'));
      if lTipoEvento = '110111' then
        Result := schEnvEventoCancBPe // Cancelamento
      else if lTipoEvento = '110115' then
        Result := schEnvEventoNaoEmbBPe; // N�o Embarque
    end;
  end;
end;

function TACBrBPe.GerarNomeArqSchema(const ALayOut: TLayOutBPe;
  VersaoServico: Double): String;
var
  NomeServico, NomeSchema, ArqSchema: String;
  Versao: Double;
begin
  // Procura por Vers�o na pasta de Schemas //
  NomeServico := LayOutBPeToServico(ALayOut);
  NomeSchema := NomeServicoToNomeSchema(NomeServico);
  ArqSchema := '';
  if NaoEstaVazio(NomeSchema) then
  begin
    Versao := VersaoServico;
    AchaArquivoSchema( NomeSchema, Versao, ArqSchema );
  end;

  Result := ArqSchema;
end;

function TACBrBPe.GetConfiguracoes: TConfiguracoesBPe;
begin
  Result := TConfiguracoesBPe(FPConfiguracoes);
end;

procedure TACBrBPe.SetConfiguracoes(AValue: TConfiguracoesBPe);
begin
  FPConfiguracoes := AValue;
end;

function TACBrBPe.LerVersaoDeParams(LayOutServico: TLayOutBPe): String;
var
  Versao: Double;
begin
  Versao := LerVersaoDeParams(GetNomeModeloDFe, Configuracoes.WebServices.UF,
    Configuracoes.WebServices.Ambiente, LayOutBPeToServico(LayOutServico),
    VersaoBPeToDbl(Configuracoes.Geral.VersaoDF));

  Result := FloatToString(Versao, '.', '0.00');
end;

procedure TACBrBPe.LerServicoDeParams(LayOutServico: TLayOutBPe;
  var Versao: Double; var URL: String);
var
  AUF: String;
begin
  case Configuracoes.Geral.FormaEmissao of
    teNormal: AUF := Configuracoes.WebServices.UF;
    teSVCAN: AUF := 'SVC-AN';
    teSVCRS: AUF := 'SVC-RS';
  else
    AUF := Configuracoes.WebServices.UF;
  end;

  Versao := VersaoBPeToDbl(Configuracoes.Geral.VersaoDF);
  URL := '';
  LerServicoDeParams(GetNomeModeloDFe, AUF,
    Configuracoes.WebServices.Ambiente, LayOutBPeToServico(LayOutServico),
    Versao, URL);
end;

function TACBrBPe.GetURLConsultaBPe(const CUF: integer;
  const TipoAmbiente: TpcnTipoAmbiente): String;
begin
  Result := LerURLDeParams('BPe', CUFtoUF(CUF), TipoAmbiente, 'URL-ConsultaBPe', 0);
end;

function TACBrBPe.GetURLQRCode(const CUF: integer; const TipoAmbiente: TpcnTipoAmbiente;
  const AChaveBPe: String; const DigestValue: String): String;
var
  Passo1, Passo2, urlUF, idBPe, tpEmis, JSON, Token, fprint: String;
begin
  urlUF := LerURLDeParams('BPe', CUFtoUF(CUF), TipoAmbiente, 'URL-QRCode', 0);
  idBPe := OnlyNumber(AChaveBPe);
  tpEmis := Copy(idBPe, 35, 1);

  if Pos('?', urlUF) > 0 then
    Passo1 := urlUF + '&' + 'chBPe=' + idBPe + '&tpAmb=' + TpAmbToStr(TipoAmbiente)
  else
    Passo1 := urlUF + '?' + 'chBPe=' + idBPe + '&tpAmb=' + TpAmbToStr(TipoAmbiente);

  if tpEmis = '1' then
  begin
    // Tipo de Emiss�o Normal
    Result := Passo1;
  end
  else
  begin
    // Tipo de Emiss�o em Conting�ncia
    JSON := '{' + '"chBPe":"'+ idBPe + '"' +
                  '"tpAmb":' + TpAmbToStr(TipoAmbiente) +
            '}';
    Token := '&jwt=';    // concatenar com o resultado do algoritmo JWS aplicado sobre o objeto JSON
    fprint := '&print='; // concatenar com o resultado da obten��o do Fingerprint do certificado digital
                         // (caso ele tenha caracteres dois pontos �: �, estes devem ser retirados)
    Passo2 := Token + fprint;

    Result := Passo1 + Passo2;
  end;

  (*
  sdhEmi_HEX := AsciiToHex(DateTimeTodh(DataHoraEmissao) +
                GetUTC(CodigoParaUF(CUF), DataHoraEmissao));
  sdigVal_HEX := AsciiToHex(DigestValue);

  cHashQRCode := AsciiToHex(SHA1(sEntrada + sCSC));
  *)
end;

procedure TACBrBPe.SetStatus(const stNewStatus: TStatusACBrBPe);
begin
  if stNewStatus <> FStatus then
  begin
    FStatus := stNewStatus;
    if Assigned(OnStatusChange) then
      OnStatusChange(Self);
  end;
end;

function TACBrBPe.Cancelamento(AJustificativa: String; ALote: integer = 0): Boolean;
var
  i: integer;
begin
  if Bilhetes.Count = 0 then
    GerarException(ACBrStr('ERRO: Nenhum Bilhete Eletr�nico Informado!'));

  for i := 0 to Bilhetes.Count - 1 do
  begin
    WebServices.Consulta.BPeChave := Bilhetes.Items[i].NumID;

    if not WebServices.Consulta.Executar then
      GerarException(WebServices.Consulta.Msg);

    EventoBPe.Evento.Clear;
    with EventoBPe.Evento.Add do
    begin
      infEvento.CNPJ := copy(OnlyNumber(WebServices.Consulta.BPeChave), 7, 14);
      infEvento.cOrgao := StrToIntDef(copy(OnlyNumber(WebServices.Consulta.BPeChave), 1, 2), 0);
      infEvento.dhEvento := now;
      infEvento.tpEvento := teCancelamento;
      infEvento.chBPe := WebServices.Consulta.BPeChave;
      infEvento.detEvento.nProt := WebServices.Consulta.Protocolo;
      infEvento.detEvento.xJust := AJustificativa;
    end;

    try
      EnviarEvento(ALote);
    except
      GerarException(WebServices.EnvEvento.EventoRetorno.xMotivo);
    end;
  end;
  Result := True;
end;

function TACBrBPe.Consultar(AChave: String): Boolean;
var
  i: integer;
begin
  if (Bilhetes.Count = 0) and EstaVazio(AChave) then
    GerarException(ACBrStr('ERRO: Nenhum Bilhete Eletr�nico ou Chave Informada!'));

  if NaoEstaVazio(AChave) then
  begin
    Bilhetes.Clear;
    WebServices.Consulta.BPeChave := AChave;
    WebServices.Consulta.Executar;
  end
  else
  begin
    for i := 0 to Bilhetes.Count - 1 do
    begin
      WebServices.Consulta.BPeChave := Bilhetes.Items[i].NumID;
      WebServices.Consulta.Executar;
    end;
  end;

  Result := True;
end;

function TACBrBPe.Enviar(ALote: integer; Imprimir: Boolean = True): Boolean;
begin
  Result := Enviar(IntToStr(ALote), Imprimir);
end;

function TACBrBPe.Enviar(ALote: String; Imprimir: Boolean): Boolean;
var
  i: integer;
begin
  if Bilhetes.Count <= 0 then
    GerarException(ACBrStr('ERRO: Nenhuma NF-e adicionada ao Lote'));

  if Bilhetes.Count > 50 then
    GerarException(ACBrStr('ERRO: Conjunto de NF-e transmitidas (m�ximo de 50 NF-e)' +
      ' excedido. Quantidade atual: ' + IntToStr(Bilhetes.Count)));

  Bilhetes.Assinar;
  Bilhetes.Validar;

  Result := WebServices.Envia(ALote);

  if DABPE <> nil then
  begin
    for i := 0 to Bilhetes.Count - 1 do
    begin
      if Bilhetes.Items[i].Confirmada and Imprimir then
      begin
        Bilhetes.Items[i].Imprimir;
        if (DABPE.ClassName = 'TACBrBPeDABPERaveCB') then
          Break;
      end;
    end;
  end;
end;

function TACBrBPe.EnviarEvento(idLote: integer): Boolean;
var
  i, j: integer;
  chBPe: String;
begin
  if EventoBPe.Evento.Count <= 0 then
    GerarException(ACBrStr('ERRO: Nenhum Evento adicionado ao Lote'));

  if EventoBPe.Evento.Count > 20 then
    GerarException(ACBrStr('ERRO: Conjunto de Eventos transmitidos (m�ximo de 20) ' +
      'excedido. Quantidade atual: ' + IntToStr(EventoBPe.Evento.Count)));

  WebServices.EnvEvento.idLote := idLote;

  {Atribuir nSeqEvento, CNPJ, Chave e/ou Protocolo quando n�o especificar}
  for i := 0 to EventoBPe.Evento.Count - 1 do
  begin
    if EventoBPe.Evento.Items[i].infEvento.nSeqEvento = 0 then
      EventoBPe.Evento.Items[i].infEvento.nSeqEvento := 1;

    FEventoBPe.Evento.Items[i].infEvento.tpAmb := Configuracoes.WebServices.Ambiente;

    if Bilhetes.Count > 0 then
    begin
      chBPe := OnlyNumber(EventoBPe.Evento.Items[i].infEvento.chBPe);

      // Se tem a chave da BPe no Evento, procure por ela nos bilhetes carregados //
      if NaoEstaVazio(chBPe) then
      begin
        For j := 0 to Bilhetes.Count - 1 do
        begin
          if chBPe = Bilhetes.Items[j].NumID then
            Break;
        end ;

        if j = Bilhetes.Count then
          GerarException( ACBrStr('N�o existe BPe com a chave ['+chBPe+'] carregada') );
      end
      else
        j := 0;

      if trim(EventoBPe.Evento.Items[i].infEvento.CNPJ) = '' then
        EventoBPe.Evento.Items[i].infEvento.CNPJ := Bilhetes.Items[j].BPe.Emit.CNPJ;

      if chBPe = '' then
        EventoBPe.Evento.Items[i].infEvento.chBPe := Bilhetes.Items[j].NumID;

      if trim(EventoBPe.Evento.Items[i].infEvento.detEvento.nProt) = '' then
      begin
        if EventoBPe.Evento.Items[i].infEvento.tpEvento = teCancelamento then
        begin
          EventoBPe.Evento.Items[i].infEvento.detEvento.nProt := Bilhetes.Items[j].BPe.procBPe.nProt;

          if trim(EventoBPe.Evento.Items[i].infEvento.detEvento.nProt) = '' then
          begin
            WebServices.Consulta.BPeChave := EventoBPe.Evento.Items[i].infEvento.chBPe;

            if not WebServices.Consulta.Executar then
              GerarException(WebServices.Consulta.Msg);

            EventoBPe.Evento.Items[i].infEvento.detEvento.nProt := WebServices.Consulta.Protocolo;
          end;
        end;
      end;
    end;
  end;

  Result := WebServices.EnvEvento.Executar;

  if not Result then
    GerarException( WebServices.EnvEvento.Msg );
end;

function TACBrBPe.NomeServicoToNomeSchema(const NomeServico: String): String;
Var
  ok: Boolean;
  ALayout: TLayOutBPe;
begin
  ALayout := ServicoToLayOutBPe(ok, NomeServico);
  if ok then
    Result := SchemaBPeToStr( LayOutToSchema( ALayout ) )
  else
    Result := '';
end;

procedure TACBrBPe.ImprimirEvento;
begin
  if not Assigned(DABPE) then
    GerarException('Componente DABPE n�o associado.')
  else
    DABPE.ImprimirEVENTO(nil);
end;

procedure TACBrBPe.ImprimirEventoPDF;
begin
  if not Assigned(DABPE) then
    GerarException('Componente DABPE n�o associado.')
  else
    DABPE.ImprimirEVENTOPDF(nil);
end;

function TACBrBPe.Distribuicao(AcUFAutor: integer; ACNPJCPF, AultNSU, ANSU,
  chBPe: String): Boolean;
begin
  WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
  WebServices.DistribuicaoDFe.CNPJCPF := ACNPJCPF;
  WebServices.DistribuicaoDFe.ultNSU := AultNSU;
  WebServices.DistribuicaoDFe.NSU := ANSU;
  WebServices.DistribuicaoDFe.chBPe := chBPe;

  Result := WebServices.DistribuicaoDFe.Executar;

  if not Result then
    GerarException( WebServices.DistribuicaoDFe.Msg );
end;

function TACBrBPe.DistribuicaoDFe(AcUFAutor: integer;
  ACNPJCPF, AultNSU, ANSU: String; AchBPe: String = ''): Boolean;
begin
  Result := Distribuicao(AcUFAutor, ACNPJCPF, AultNSU, ANSU, AchBPe);
end;

function TACBrBPe.DistribuicaoDFePorUltNSU(AcUFAutor: integer; ACNPJCPF,
  AultNSU: String): Boolean;
begin
  Result := Distribuicao(AcUFAutor, ACNPJCPF, AultNSU, '', '');
end;

function TACBrBPe.DistribuicaoDFePorNSU(AcUFAutor: integer; ACNPJCPF,
  ANSU: String): Boolean;
begin
  Result := Distribuicao(AcUFAutor, ACNPJCPF, '', ANSU, '');
end;

function TACBrBPe.DistribuicaoDFePorChaveBPe(AcUFAutor: integer; ACNPJCPF,
  AchBPe: String): Boolean;
begin
  Result := Distribuicao(AcUFAutor, ACNPJCPF, '', '', AchBPe);
end;

procedure TACBrBPe.EnviarEmailEvento(sPara, sAssunto: String;
  sMensagem: TStrings; sCC: TStrings; Anexos: TStrings;
  sReplyTo: TStrings);
var
  NomeArq: String;
  AnexosEmail: TStrings;
begin
  AnexosEmail := TStringList.Create;
  try
    AnexosEmail.Clear;

    if Anexos <> nil then
      AnexosEmail.Text := Anexos.Text;

    ImprimirEventoPDF;
    NomeArq := OnlyNumber(EventoBPe.Evento[0].infEvento.Id);
    NomeArq := PathWithDelim(DABPE.PathPDF) + NomeArq + '-procEventoBPe.pdf';
    AnexosEmail.Add(NomeArq);

    EnviarEmail(sPara, sAssunto, sMensagem, sCC, AnexosEmail, nil, '', sReplyTo);
  finally
    AnexosEmail.Free;
  end;
end;

end.

