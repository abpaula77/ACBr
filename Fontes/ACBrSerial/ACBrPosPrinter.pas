{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

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
{ http://www.opensource.org/licenses/gpl-license.php                           }

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 20/04/2013:  Daniel Sim�es de Almeida
|*   Inicio do desenvolvimento
******************************************************************************}

{$I ACBr.inc}

unit ACBrPosPrinter;

interface

uses
  Classes, SysUtils,
  ACBrDevice, ACBrBase;

type

  EPosPrinterException = class(Exception);

  { TACBrPosComandos }

  TACBrPosComandos = class
  private
    FAbreGaveta: AnsiString;
    FBeep: AnsiString;
    FAlinhadoCentro: AnsiString;
    FAlinhadoDireita: AnsiString;
    FAlinhadoEsquerda: AnsiString;
    FCorteParcial: AnsiString;
    FDesligaInvertido: AnsiString;
    FEspacoEntreLinhasPadrao: AnsiString;
    FLigaInvertido: AnsiString;
    FFonteNormal: AnsiString;
    FLigaCondensado: AnsiString;
    FCorteTotal: AnsiString;
    FEspacoEntreLinhas: AnsiString;
    FLigaExpandido: AnsiString;
    FDesligaCondensado: AnsiString;
    FDesligaExpandido: AnsiString;
    FDesligaItalico: AnsiString;
    FDesligaNegrito: AnsiString;
    FDesligaSublinhado: AnsiString;
    FFonteA: AnsiString;
    FFonteB: AnsiString;
    FLigaItalico: AnsiString;
    FLigaNegrito: AnsiString;
    FLigaSublinhado: AnsiString;
    FZera: AnsiString;
  public
    property Zera: AnsiString read FZera write FZera;
    property EspacoEntreLinhas: AnsiString read FEspacoEntreLinhas
      write FEspacoEntreLinhas;
    property EspacoEntreLinhasPadrao: AnsiString
      read FEspacoEntreLinhasPadrao write FEspacoEntreLinhasPadrao;

    property LigaNegrito: AnsiString read FLigaNegrito write FLigaNegrito;
    property DesligaNegrito: AnsiString read FDesligaNegrito write FDesligaNegrito;
    property LigaExpandido: AnsiString read FLigaExpandido write FLigaExpandido;
    property DesligaExpandido: AnsiString read FDesligaExpandido write FDesligaExpandido;
    property LigaSublinhado: AnsiString read FLigaSublinhado write FLigaSublinhado;
    property DesligaSublinhado: AnsiString read FDesligaSublinhado
      write FDesligaSublinhado;
    property LigaItalico: AnsiString read FLigaItalico write FLigaItalico;
    property DesligaItalico: AnsiString read FDesligaItalico write FDesligaItalico;
    property LigaCondensado: AnsiString read FLigaCondensado write FLigaCondensado;
    property DesligaCondensado: AnsiString read FDesligaCondensado
      write FDesligaCondensado;
    property LigaInvertido: AnsiString read FLigaInvertido write FLigaInvertido;
    property DesligaInvertido: AnsiString read FDesligaInvertido write FDesligaInvertido;

    property FonteNormal: AnsiString read FFonteNormal write FFonteNormal;
    property FonteA: AnsiString read FFonteA write FFonteA;
    property FonteB: AnsiString read FFonteB write FFonteB;

    property AlinhadoEsquerda: AnsiString read FAlinhadoEsquerda write FAlinhadoEsquerda;
    property AlinhadoDireita: AnsiString read FAlinhadoDireita write FAlinhadoDireita;
    property AlinhadoCentro: AnsiString read FAlinhadoCentro write FAlinhadoCentro;

    property Beep: AnsiString read FBeep write FBeep;
    property AbreGaveta: AnsiString read FAbreGaveta write FAbreGaveta;
    property CorteTotal: AnsiString read FCorteTotal write FCorteTotal;
    property CorteParcial: AnsiString read FCorteParcial write FCorteParcial;
  end;

  TACBrPosTipoFonte = (ftNormal, ftCondensado, ftExpandido, ftNegrito,
    ftSublinhado, ftInvertido, ftItalico, ftFonteB);
  TACBrPosFonte = set of TACBrPosTipoFonte;

  TACBrPosTipoAlinhamento = (alEsquerda, alCentro, alDireita);
  TACBrPosPaginaCodigo = (pcNone, pc437, pc850, pc852, pc860, pcUTF8, pc1252);

  TACBrPosTipoStatus = (stErro, stNaoSerial, stPoucoPapel, stSemPapel,
                        stGavetaAberta, stImprimindo, stOffLine, stTampaAberta);
  TACBrPosPrinterStatus = set of TACBrPosTipoStatus;

  { TACBrPosRazaoColunaFonte }

  TACBrPosRazaoColunaFonte = class
  private
    FCondensada: Double;
    FExpandida: Double;
  public
    constructor Create;
  published
    property Condensada: Double read FCondensada write FCondensada;
    property Expandida: Double read FExpandida write FExpandida;
  end;

  TACBrPosPrinter = class;

  TACBrPosPrinterModelo = (ppTexto, ppEscPosEpson, ppEscBematech, ppEscDaruma);

  { TACBrPosPrinterClass }

  TACBrPosPrinterClass = class
  private
    FCmd: TACBrPosComandos;
    FRazaoColunaFonte: TACBrPosRazaoColunaFonte;
  protected
    fpModeloStr: String;
    fpPosPrinter: TACBrPosPrinter;

  public
    function TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString): AnsiString;
      virtual;
    function ComandoCodBarras(const ATag: String; ACodigo: AnsiString): AnsiString;
      virtual;
    function ComandoQrCode(ACodigo: AnsiString): AnsiString; virtual;
    function ComandoEspacoEntreLinhas(Espacos: byte): AnsiString; virtual;
    function ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString; virtual;
    function ComandoLogo: AnsiString; virtual;

    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); virtual;
    function LerInfo: String; virtual;

    constructor Create(AOwner: TACBrPosPrinter);
    destructor Destroy; override;

    property RazaoColunaFonte: TACBrPosRazaoColunaFonte read FRazaoColunaFonte;
    property Cmd: TACBrPosComandos read FCmd;
    property ModeloStr: String read fpModeloStr;
  end;

  { TACBrConfigQRCode }

  TACBrConfigQRCode = class(TPersistent)
    private
      FErrorLevel: Integer;
      FLarguraModulo: Integer;
      FTipo: Integer;
      procedure SetErrorLevel(AValue: Integer);
      procedure SetLarguraModulo(AValue: Integer);
      procedure SetTipo(AValue: Integer);
    public
      constructor Create;

    published
      property Tipo: Integer read FTipo write SetTipo;
      property LarguraModulo: Integer read FLarguraModulo write SetLarguraModulo;
      property ErrorLevel: Integer read FErrorLevel write SetErrorLevel;
  end;

  { TACBrConfigLogo }

  TACBrConfigLogo = class(TPersistent)
    private
      FFatorX: Byte;
      FFatorY: Byte;
      FKeyCode1: Byte;
      FKeyCode2: Byte;
    public
      constructor Create;

    published
      property KeyCode1: Byte read FKeyCode1 write FKeyCode1 default 32;
      property KeyCode2: Byte read FKeyCode2 write FKeyCode2 default 32;
      property FatorX: Byte read FFatorX write FFatorX default 1;
      property FatorY: Byte read FFatorY write FFatorY default 1;
  end;

  { TACBrPosPrinter }

  TACBrPosPrinter = class(TACBrComponent)
  private
    FColunasFonteNormal: Integer;
    FConfigBarras: TACBrECFConfigBarras;
    FConfigLogo: TACBrConfigLogo;
    FConfigQRCode: TACBrConfigQRCode;
    FControlePorta: Boolean;
    FDevice: TACBrDevice;
    FEspacoEntreLinhas: byte;
    FEspacoEntreLinhasAtual: byte;
    FGavetaSinalInvertido: Boolean;
    FModelo: TACBrPosPrinterModelo;
    FOnGravarLog: TACBrGravarLog;
    FTagProcessor: TACBrTagProcessor;

    FCortaPapel: Boolean;
    FLinhasBuffer: Integer;
    FLinhasEntreCupons: Integer;
    FPaginaDeCodigo: TACBrPosPaginaCodigo;
    FPaginaDeCodigoAtual: TACBrPosPaginaCodigo;
    FArqLog: String;

    FPosPrinterClass: TACBrPosPrinterClass;
    FBuffer: TStringList;
    FTipoAlinhamento: TACBrPosTipoAlinhamento;
    FFonteStatus: TACBrPosFonte;

    function GetAtivo: Boolean;
    function GetColunasFonteCondensada: Integer;
    function GetColunasFonteExpandida: Integer;
    function GetNumeroPaginaDeCodigo(APagCod: TACBrPosPaginaCodigo): word;
    function CodificarPaginaDeCodigo(ATexto: AnsiString): AnsiString;

    procedure DoLinesChange(Sender: TObject);
    function GetColunas: Integer;
    function GetIgnorarTags: Boolean;
    function GetPorta: String;
    function GetTraduzirTags: Boolean;
    procedure SetAtivo(AValue: Boolean);
    procedure SetIgnorarTags(AValue: Boolean);
    procedure SetPorta(AValue: String);
    procedure SetTraduzirTags(AValue: Boolean);
    procedure SetModelo(AValue: TACBrPosPrinterModelo);

    procedure ConfigurarEspacoEntreLinhas;
    procedure ConfigurarPaginaDeCodigo;

  protected
    procedure EnviarStringDevice(const AString: AnsiString);
    procedure TraduzirTag(const ATag: AnsiString; var TagTraduzida: AnsiString);
    procedure TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString;
      var BlocoTraduzido: AnsiString);

    procedure AtivarPorta;
    procedure DesativarPorta;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Ativar;
    procedure Desativar;
    property Ativo: Boolean read GetAtivo write SetAtivo;

    procedure Imprimir(AString: AnsiString = ''; PulaLinha: Boolean = False;
      DecodificarTags: Boolean = True; CodificarPagina: Boolean = True;
      Copias: Integer = 1);
    procedure ImprimirLinha(AString: AnsiString);
    procedure ImprimirCmd(AString: AnsiString);
    procedure GravarLog(AString: AnsiString; Traduz: Boolean = False;
      AdicionaTempo: Boolean = True);

    function TxRx(ACmd: AnsiString; BytesToRead: Byte = 1;
      ATimeOut: Integer = 500; WaitForTerminator: Boolean = False): AnsiString;

    procedure RetornarTags(AStringList: TStrings; IncluiAjuda: Boolean = True);
    procedure ImprimirTags;

    procedure Zerar;

    procedure PularLinhas(NumLinhas: Integer = 0);
    procedure CortarPapel(Parcial: Boolean = False);
    procedure AbrirGaveta;

    function LerStatusImpressora: TACBrPosPrinterStatus;
    function LerInfoImpressora: String;

    property Device: TACBrDevice read FDevice;
    property Buffer: TStringList read FBuffer;

    property Colunas: Integer read GetColunas;
    property ColunasFonteExpandida: Integer read GetColunasFonteExpandida;
    property ColunasFonteCondensada: Integer read GetColunasFonteCondensada;

    property FonteStatus: TACBrPosFonte read FFonteStatus;
    property Alinhamento: TACBrPosTipoAlinhamento read FTipoAlinhamento;

  published
    property Modelo: TACBrPosPrinterModelo read FModelo write SetModelo default ppTexto;
    property Porta: String read GetPorta write SetPorta;

    property PaginaDeCodigo: TACBrPosPaginaCodigo
      read FPaginaDeCodigo write FPaginaDeCodigo default pc850;
    property ColunasFonteNormal: Integer read FColunasFonteNormal
      write FColunasFonteNormal default 48;
    property EspacoEntreLinhas: byte read FEspacoEntreLinhas
      write FEspacoEntreLinhas default 0;

    property ConfigBarras: TACBrECFConfigBarras read FConfigBarras write FConfigBarras;
    property ConfigQRCode: TACBrConfigQRCode read FConfigQRCode write FConfigQRCode;
    property ConfigLogo: TACBrConfigLogo read FConfigLogo write FConfigLogo;
    property GavetaSinalInvertido: Boolean read FGavetaSinalInvertido
      write FGavetaSinalInvertido default False;

    property LinhasEntreCupons: Integer read FLinhasEntreCupons
      write FLinhasEntreCupons default 21;
    property CortaPapel: Boolean read FCortaPapel write FCortaPapel;

    property TraduzirTags: Boolean read GetTraduzirTags
      write SetTraduzirTags default True;
    property IgnorarTags: Boolean read GetIgnorarTags write SetIgnorarTags default False;
    property LinhasBuffer: Integer read FLinhasBuffer write FLinhasBuffer default 0;
    property ControlePorta: Boolean
      read FControlePorta write FControlePorta default False;

    property OnGravarLog: TACBrGravarLog read FOnGravarLog write FOnGravarLog;
    property ArqLOG: String read FArqLog write FArqLog;
  end;

implementation

uses
  strutils, Math, typinfo,
  ACBrUtil, ACBrConsts,
  ACBrEscPosEpson, ACBrEscBematech, ACBrEscDaruma;

{ TACBrConfigLogo }

constructor TACBrConfigLogo.Create;
begin
  FKeyCode1 := 32;
  FKeyCode2 := 32;
  FFatorX := 1;
  FFatorY := 1;
end;

{ TACBrConfigQRCode }

constructor TACBrConfigQRCode.Create;
begin
  inherited;

  FTipo := 2;
  FLarguraModulo := 4;
  FErrorLevel := 0;
end;

procedure TACBrConfigQRCode.SetLarguraModulo(AValue: Integer);
begin
  FLarguraModulo := max(min(AValue,16),1);
end;

procedure TACBrConfigQRCode.SetErrorLevel(AValue: Integer);
begin
  FErrorLevel := max(min(AValue,3),0);
end;

procedure TACBrConfigQRCode.SetTipo(AValue: Integer);
begin
  FTipo := max(min(AValue,2),1);
end;

{ TACBrPosRazaoColunaFonte }

constructor TACBrPosRazaoColunaFonte.Create;
begin
  FCondensada := 0.75;
  FExpandida := 2;
end;

{ TACBrPosPrinterClass }

constructor TACBrPosPrinterClass.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create;

  fpModeloStr := 'Texto';
  fpPosPrinter := AOwner;

  FCmd := TACBrPosComandos.Create;
  FRazaoColunaFonte := TACBrPosRazaoColunaFonte.Create;
end;

destructor TACBrPosPrinterClass.Destroy;
begin
  FCmd.Free;
  FRazaoColunaFonte.Free;

  inherited;
end;

function TACBrPosPrinterClass.TraduzirTagBloco(
  const ATag, ConteudoBloco: AnsiString): AnsiString;
begin
  Result := ConteudoBloco;
end;

function TACBrPosPrinterClass.ComandoCodBarras(const ATag: String;
  ACodigo: AnsiString): AnsiString;
begin
  Result := ACodigo;
end;

function TACBrPosPrinterClass.ComandoQrCode(ACodigo: AnsiString): AnsiString;
begin
  Result := '';
end;

function TACBrPosPrinterClass.ComandoEspacoEntreLinhas(Espacos: byte): AnsiString;
begin
  Result := '';
end;

function TACBrPosPrinterClass.ComandoPaginaCodigo(
  APagCodigo: TACBrPosPaginaCodigo): AnsiString;
begin
  Result := '';
end;

function TACBrPosPrinterClass.ComandoLogo: AnsiString;
begin
  Result := '';
end;

procedure TACBrPosPrinterClass.LerStatus(var AStatus: TACBrPosPrinterStatus);
begin
  {nada aqui, m�todo virtual}
end;

function TACBrPosPrinterClass.LerInfo: String;
begin
  Result := '';
end;

{ TACBrPosPrinter }

constructor TACBrPosPrinter.Create(AOwner: TComponent);
const
  CTAGS_TIPOFONTE: array[0..6] of String =
    (cTagFonteA, cTagFonteB, cTagLigaInvertido, cTagDesligaInvertido,
     cTagFonteAlinhadaEsquerda, cTagfonteAlinhadaCentro, cTagFonteAlinhadaDireita);
  CTAGS_TIPOFONTE_HELP: array[0..6] of String =
    ('Liga Fonte Tipo A (normal)',
     'Liga Fonte Tipo B (condensada)',
     'Liga Fonte Invertida (Fundo Preto)', 'Desliga Fonte Invertida',
     'Liga Alinhamento a Esquerda',
     'Liga Alinhamento ao Centro',
     'Liga Alinhamento a Direita');
begin
  inherited Create(AOwner);

  FDevice := TACBrDevice.Create(Self);
  FPosPrinterClass := TACBrPosPrinterClass.Create(Self);
  FModelo := ppTexto;
  FTipoAlinhamento := alEsquerda;
  FFonteStatus := [ftNormal];

  FConfigBarras := TACBrECFConfigBarras.Create;
  FConfigQRCode := TACBrConfigQRCode.Create;
  FConfigLogo   := TACBrConfigLogo.Create;

  FTagProcessor := TACBrTagProcessor.Create;
  FTagProcessor.AddTags(cTAGS_CARACTER, cTAGS_CARACTER_HELP, False);
  FTagProcessor.AddTags(CTAGS_TIPOFONTE, CTAGS_TIPOFONTE_HELP, False);
  FTagProcessor.AddTags(cTAGS_LINHAS, cTAGS_LINHAS_HELP, False);
  FTagProcessor.AddTags(cTAGS_FUNCOES, cTAGS_FUNCOES_HELP, False);
  FTagProcessor.AddTags(cTAGS_ALINHAMENTO, cTAGS_ALINHAMENTO_HELP, True);
  FTagProcessor.AddTags(cTAGS_BARRAS, cTAGS_BARRAS_HELP, True);
  with FTagProcessor.Tags.New do
  begin
    Nome := cTagQRCode;
    Ajuda := 'Imprime QRCode de acordo com "ConfigQRCode"';
    EhBloco := True;
  end;
  with FTagProcessor.Tags.New do
  begin
    Nome := cTagIgnorarTags;
    Ajuda := 'Ignora todas as Tags contidas no Bloco';
    EhBloco := True;
  end;
  FTagProcessor.OnTraduzirTag := TraduzirTag;
  FTagProcessor.OnTraduzirTagBloco := TraduzirTagBloco;

  FBuffer := TStringList.Create;
  FBuffer.OnChange := DoLinesChange;

  FColunasFonteNormal := 48;
  FPaginaDeCodigo := pc850;
  FPaginaDeCodigoAtual := pcNone;
  FEspacoEntreLinhas := 0;
  FEspacoEntreLinhasAtual := 0;
  FControlePorta := False;
  FGavetaSinalInvertido := False;

  FArqLog := '';
  FOnGravarLog := nil;
end;

destructor TACBrPosPrinter.Destroy;
begin
  FPosPrinterClass.Free;
  FBuffer.Free;
  FTagProcessor.Free;
  FConfigBarras.Free;
  FConfigQRCode.Free;
  FConfigLogo.Free;
  FDevice.Free;

  inherited Destroy;
end;

procedure TACBrPosPrinter.AbrirGaveta;
begin
  GravarLog('AbrirGaveta');
  ImprimirCmd(FPosPrinterClass.Cmd.AbreGaveta);
  Sleep(500);
end;

procedure TACBrPosPrinter.Ativar;
var
  DadosDevice: String;
begin
  if FDevice.Ativo then
    exit;

{(*}
  if FDevice.IsTXTFilePort then
    DadosDevice := '  - Arquivo: '+FDevice.Porta
  else if FDevice.IsDLLPort then
    DadosDevice := '  - DLL....: '+FDevice.Porta
  else if FDevice.IsSerialPort then
    DadosDevice := '  - Serial.: '+FDevice.Porta+' - '+FDevice.DeviceToString(False)
  else
    DadosDevice := '  - Porta..: '+FDevice.Porta;

  GravarLog(sLineBreak + StringOfChar('-', 80) + sLineBreak +
            'ATIVAR - ' + FormatDateTime('dd/mm/yy hh:nn:ss:zzz', now) + sLineBreak +
            '  - Modelo.: ' + FPosPrinterClass.ModeloStr + sLineBreak +
            '  - TimeOut: ' + IntToStr(FDevice.TimeOut) + sLineBreak +
            DadosDevice + sLineBreak +
            StringOfChar('-', 80) + sLineBreak,
            False, False);
  {*)}

  FDevice.Ativar;
end;

procedure TACBrPosPrinter.Desativar;
begin
  GravarLog(sLineBreak + StringOfChar('-', 80) + sLineBreak +
    'DESATIVAR - ' + FormatDateTime('dd/mm/yy hh:nn:ss:zzz', now) +
    sLineBreak + StringOfChar('-', 80) + sLineBreak,
    False, False);

  FDevice.Desativar;
end;

procedure TACBrPosPrinter.SetModelo(AValue: TACBrPosPrinterModelo);
begin
  if FModelo = AValue then
    Exit;

  GravarLog('SetModelo(' + GetEnumName(TypeInfo(TACBrPosPrinterModelo),
    integer(AValue)) + ')');

  FPosPrinterClass.Free;

  case AValue of
    ppEscPosEpson: FPosPrinterClass := TACBrEscPosEpson.Create(Self);
    ppEscBematech: FPosPrinterClass := TACBrEscBematech.Create(Self);
    ppEscDaruma : FPosPrinterClass := TACBrEscDaruma.Create(Self);
  else
    FPosPrinterClass := TACBrPosPrinterClass.Create(Self);
  end;

  FModelo := AValue;
end;


procedure TACBrPosPrinter.DoLinesChange(Sender: TObject);
begin
  if (FLinhasBuffer > 0) and (FBuffer.Count > FLinhasBuffer) then
  begin
    GravarLog('Esvaziando Buffer: ' + IntToStr(FBuffer.Count) + ' linhas');
    Imprimir;
  end;
end;

function TACBrPosPrinter.GetColunas: Integer;
begin
  if (ftCondensado in FFonteStatus) then
    Result := ColunasFonteCondensada
  else if (ftExpandido in FFonteStatus) then
    Result := ColunasFonteExpandida
  else
    Result := ColunasFonteNormal;
end;

function TACBrPosPrinter.GetColunasFonteCondensada: Integer;
begin
  Result := trunc(ColunasFonteNormal / FPosPrinterClass.RazaoColunaFonte.Condensada)
end;

function TACBrPosPrinter.GetColunasFonteExpandida: Integer;
begin
  Result := trunc(ColunasFonteNormal / FPosPrinterClass.RazaoColunaFonte.Expandida)
end;


procedure TACBrPosPrinter.TraduzirTag(const ATag: AnsiString;
  var TagTraduzida: AnsiString);
begin
  TagTraduzida := '';

  if ATag = cTagLigaExpandido then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.LigaExpandido;
    FFonteStatus := FFonteStatus + [ftExpandido];
  end

  else if ATag = cTagDesligaExpandido then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.DesligaExpandido;
    FFonteStatus := FFonteStatus - [ftExpandido];
  end

  else if ATag = cTagLigaNegrito then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.LigaNegrito;
    FFonteStatus := FFonteStatus + [ftNegrito];
  end

  else if ATag = cTagDesligaNegrito then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.DesligaNegrito;
    FFonteStatus := FFonteStatus - [ftNegrito];
  end

  else if ATag = cTagLigaSublinhado then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.LigaSublinhado;
    FFonteStatus := FFonteStatus + [ftSublinhado];
  end

  else if ATag = cTagDesligaSublinhado then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.DesligaSublinhado;
    FFonteStatus := FFonteStatus - [ftSublinhado];
  end

  else if ATag = cTagLigaCondensado then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.LigaCondensado;
    FFonteStatus := FFonteStatus + [ftCondensado];
  end

  else if ATag = cTagDesligaCondensado then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.DesligaCondensado;
    FFonteStatus := FFonteStatus - [ftCondensado];
  end

  else if ATag = cTagLigaItalico then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.LigaItalico;
    FFonteStatus := FFonteStatus + [ftItalico];
  end

  else if ATag = cTagDesligaItalico then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.DesligaItalico;
    FFonteStatus := FFonteStatus - [ftItalico];
  end

  else if ATag = cTagFonteNormal then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.FonteNormal;
    FFonteStatus := FFonteStatus - [ftCondensado, ftExpandido, ftNegrito,
      ftSublinhado, ftItalico, ftInvertido];
  end

  else if ATag = cTagZera then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.Zera +
                    FPosPrinterClass.ComandoEspacoEntreLinhas(FEspacoEntreLinhas) +
                    FPosPrinterClass.ComandoPaginaCodigo(FPaginaDeCodigo);

    FFonteStatus := FFonteStatus - [ftCondensado, ftExpandido, ftNegrito,
      ftSublinhado, ftItalico, ftInvertido];
  end

  else if ATag = cTagLigaInvertido then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.LigaInvertido;
    FFonteStatus := FFonteStatus + [ftInvertido];
  end

  else if ATag = cTagDesligaInvertido then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.DesligaInvertido;
    FFonteStatus := FFonteStatus - [ftInvertido];
  end

  else if ATag = cTagFonteA then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.FonteA;
    FFonteStatus := FFonteStatus - [ftFonteB];
  end

  else if ATag = cTagFonteB then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.FonteB;
    FFonteStatus := FFonteStatus + [ftFonteB];
  end

  else if ATag = cTagLinhaSimples then
    TagTraduzida := StringOfChar('-', Colunas)

  else if ATag = cTagLinhaDupla then
    TagTraduzida := StringOfChar('=', Colunas)

  else if ATag = cTagPuloDeLinhas then
    TagTraduzida := StringOfChar(LF,LinhasEntreCupons)

  else if ATag = cTagCorteParcial then
    TagTraduzida := StringOfChar(LF,LinhasEntreCupons) + FPosPrinterClass.Cmd.CorteParcial

  else if ATag = cTagCorteTotal then
    TagTraduzida := StringOfChar(LF,LinhasEntreCupons) + FPosPrinterClass.Cmd.CorteTotal

  else if ATag = cTagAbreGaveta then
    TagTraduzida := FPosPrinterClass.Cmd.AbreGaveta

  else if ATag = cTagBeep then
    TagTraduzida := FPosPrinterClass.Cmd.Beep

  else if ATag = cTagLogotipo then
    TagTraduzida := FPosPrinterClass.ComandoLogo

  else if ATag = cTagPulodeLinha then
    TagTraduzida := LF

  else if ATag = cTagRetornoDeCarro then
    TagTraduzida := CR

  else if ATag = cTagFonteAlinhadaEsquerda then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.AlinhadoEsquerda;
    FTipoAlinhamento := alEsquerda;
  end

  else if ATag = cTagFonteAlinhadaDireita then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.AlinhadoDireita;
    FTipoAlinhamento := alDireita;
  end

  else if ATag = cTagfonteAlinhadaCentro then
  begin
    TagTraduzida := FPosPrinterClass.Cmd.AlinhadoCentro;
    FTipoAlinhamento := alCentro;
  end;


  GravarLog('TraduzirTag(' + ATag + ') -> ' + TagTraduzida, True);
end;

procedure TACBrPosPrinter.TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString;
  var BlocoTraduzido: AnsiString);
var
  ACodBar: String;
begin
  BlocoTraduzido := FPosPrinterClass.TraduzirTagBloco(ATag, ConteudoBloco);

  if ConteudoBloco = BlocoTraduzido then  // N�o traduziu...
  begin
    if ATag = cTagAlinhadoEsquerda then
      BlocoTraduzido := PadRight(ConteudoBloco,Colunas)

    else if ATag = cTagAlinhadoDireita then
      BlocoTraduzido := PadLeft(ConteudoBloco,Colunas)

    else if ATag = cTagAlinhadoCentro then
      BlocoTraduzido := PadCenter(ConteudoBloco,Colunas)

    else if ATag = cTagQRCode then
    begin
      BlocoTraduzido := FPosPrinterClass.ComandoQrCode(ConteudoBloco);
    end

    else if (AnsiIndexText(ATag, cTAGS_BARRAS) >= 0) then
    begin

      // Ajustando os C�digos de Barras, conforme regras do Tipo do C�digo //
      if (ATag = cTagBarraUPCA) then
        // Apenas n�meros, sempre 11 digitos, e 1 digito verificador
        ACodBar := PadLeft(OnlyNumber(ConteudoBloco), 11, '0')

      else if ATag = cTagBarraEAN13 then
        // Apenas n�meros, sempre 12 digitos, e 1 digito verificador
        ACodBar := PadLeft(OnlyNumber(ConteudoBloco), 12, '0')

      else if ATag = cTagBarraEAN8 then
        // Apenas n�meros, sempre 7 digitos, e 1 digito verificador
        ACodBar := PadLeft(OnlyNumber(ConteudoBloco), 7, '0')

      else if ATag = cTagBarraCode39 then
        // Qualquer tamanho.. Aceita: 0~9, A~Z, ' ', '$', '%', '*', '+', '-', '.', '/'
        ACodBar := OnlyCharsInSet(ConteudoBloco,
          ['0'..'9', 'A'..'Z', ' ', '$', '%', '*', '+', '-', '.', '/'])

      else if ATag = cTagBarraCode93 then
        // Qualquer tamanho.. Aceita: 0~9, A~Z, '-', '.', ' ', '$', '/', '+', '%'
        ACodBar := OnlyCharsInSet(ConteudoBloco,
          ['0'..'9', 'A'..'Z', '-', '.', ' ', '$', '/', '+', '%'])

      else if ATag = cTagBarraInter then
      begin
        // Interleaved 2of5. Somente n�meros, Tamanho deve ser PAR
        ACodBar := OnlyNumber(ConteudoBloco);

        if (Length(ACodBar) mod 2) <> 0 then  // Tamanho � Par ?
          ACodBar := '0' + ACodBar;
      end

      else if ATag = cTagBarraStd then
        // Apenas n�meros, Sem d�gito verificador
        ACodBar := OnlyNumber(ConteudoBloco)

      else if ATag = cTagBarraCodaBar then
        // Qualquer tamanho.. Aceita: 0~9, A~D, a~d, $, +, -, ., /, :
        ACodBar := OnlyCharsInSet(ConteudoBloco,
          ['0'..'9', 'A'..'D', 'a'..'d', '$', '+', '-', '.', '/', ':'])

      else if ATag = cTagBarraCode11 then
        // Apenas n�meros, Qualquer tamanho, dois d�gitos verificador
        ACodBar := OnlyNumber(ConteudoBloco)

      else if ATag = cTagBarraMSI then
        // Apenas n�meros, 1 d�gito verificador
        ACodBar := OnlyNumber(ConteudoBloco)

      else
        ACodBar := ConteudoBloco;

      ACodBar := LeftStr(ACodBar, 255);  // Tamanho m�ximo para Cod.Barras � 255 caracteres

      BlocoTraduzido := FPosPrinterClass.ComandoCodBarras(ATag, ACodBar);
    end;
  end;

  GravarLog('TraduzirTagBloco(' + ATag + ', ' + ConteudoBloco + ') -> ' + BlocoTraduzido, True);
end;

procedure TACBrPosPrinter.AtivarPorta;
begin
  if not FDevice.Ativo then
  begin
    GravarLog('Ativando a porta: ' + FDevice.Porta);
    FDevice.Ativar;
  end;
end;

procedure TACBrPosPrinter.DesativarPorta;
begin
  if FDevice.Ativo then
  begin
    GravarLog('Desativando a porta: ' + FDevice.Porta);
    FDevice.Desativar;
  end;
end;

procedure TACBrPosPrinter.ConfigurarEspacoEntreLinhas;
begin
  if FEspacoEntreLinhas <> FEspacoEntreLinhasAtual then
  begin
    GravarLog('ConfigurarEspacoEntreLinhas: ' + IntToStr(FEspacoEntreLinhas));
    ImprimirCmd(FPosPrinterClass.ComandoEspacoEntreLinhas(FEspacoEntreLinhas));
    FEspacoEntreLinhasAtual := FEspacoEntreLinhas;
  end;
end;

procedure TACBrPosPrinter.ConfigurarPaginaDeCodigo;
begin
  if FPaginaDeCodigo <> FPaginaDeCodigoAtual then
  begin
    GravarLog('ConfigurarPaginaDeCodigo: ' + GetEnumName(
      TypeInfo(TACBrPosPaginaCodigo), integer(FPaginaDeCodigo)));

    ImprimirCmd(FPosPrinterClass.ComandoPaginaCodigo(FPaginaDeCodigo));
    FPaginaDeCodigoAtual := FPaginaDeCodigo;
  end;
end;

procedure TACBrPosPrinter.EnviarStringDevice(const AString: AnsiString);
begin
  if AString = '' then
    exit;

  AtivarPorta;

  GravarLog('EnviarStringDevice( ' + AString + ')', True);
  FDevice.EnviaString(AString);

  if ControlePorta then
    DesativarPorta;
end;

procedure TACBrPosPrinter.GravarLog(AString: AnsiString; Traduz: Boolean;
  AdicionaTempo: Boolean);
var
  Tratado: Boolean;
begin
  Tratado := False;

  if Traduz then
    AString := TranslateUnprintable(AString);

  if Assigned(FOnGravarLog) then
    FOnGravarLog(AString, Tratado);

  if not Tratado then
  begin
    if AdicionaTempo then
      AString := '-- ' + FormatDateTime('dd/mm hh:nn:ss:zzz', now) + ' - ' + AString;

    WriteLog(FArqLog, AString);
  end;
end;

procedure TACBrPosPrinter.RetornarTags(AStringList: TStrings;
  IncluiAjuda: Boolean);
begin
  FTagProcessor.RetornarTags(AStringList, IncluiAjuda);
end;

procedure TACBrPosPrinter.ImprimirTags;
begin
  FTagProcessor.RetornarTags(FBuffer);
  FBuffer.Insert(0,'</zera><c><ignorar_tags>');
  FBuffer.Add('</ignorar_tags>');
  FBuffer.Add('</corte_total>');

  Imprimir;
end;

function TACBrPosPrinter.TxRx(ACmd: AnsiString; BytesToRead: Byte;
  ATimeOut: Integer; WaitForTerminator: Boolean): AnsiString;
begin
  GravarLog('TX -> '+ACmd, True);
  FDevice.EnviaString( ACmd );

  if WaitForTerminator then
    Result := FDevice.Serial.RecvTerminated(ATimeOut, chr(BytesToRead))
  else
  begin
    if BytesToRead < 1 then
      Result := FDevice.Serial.RecvPacket(ATimeOut)
    else
      Result := FDevice.Serial.RecvBufferStr(BytesToRead, ATimeOut);
  end;

  GravarLog('RX <- '+Result, True);
end;

function TACBrPosPrinter.GetIgnorarTags: Boolean;
begin
  Result := FTagProcessor.IgnorarTags;
end;

function TACBrPosPrinter.GetPorta: String;
begin
  Result := FDevice.Porta;
end;

function TACBrPosPrinter.LerStatusImpressora: TACBrPosPrinterStatus;
begin
  Result := [];

  if not FDevice.IsSerialPort then
    Result := Result + [stNaoSerial];

  if Result = [] then
  begin
    FPosPrinterClass.LerStatus( Result );

    if (stGavetaAberta in Result) and GavetaSinalInvertido then
      Result := Result - [stGavetaAberta];
  end;
end;

function TACBrPosPrinter.LerInfoImpressora: String;
begin
  Result := '';
  if not FDevice.IsSerialPort then
    raise EPosPrinterException.Create('Leitura de Informa��es s� disponivel em Portas Seriais');

  Result := FPosPrinterClass.LerInfo;
end;

function TACBrPosPrinter.GetTraduzirTags: Boolean;
begin
  Result := FTagProcessor.TraduzirTags;
end;

procedure TACBrPosPrinter.SetAtivo(AValue: Boolean);
begin
  if AValue then
    FDevice.Ativar
  else
    FDevice.Desativar;
end;

procedure TACBrPosPrinter.SetIgnorarTags(AValue: Boolean);
begin
  FTagProcessor.IgnorarTags := AValue;
end;

procedure TACBrPosPrinter.SetPorta(AValue: String);
begin
  FDevice.Porta := AValue;
end;

procedure TACBrPosPrinter.SetTraduzirTags(AValue: Boolean);
begin
  FTagProcessor.TraduzirTags := AValue;
end;

procedure TACBrPosPrinter.Imprimir(AString: AnsiString; PulaLinha: Boolean;
  DecodificarTags: Boolean; CodificarPagina: Boolean; Copias: Integer);
var
  i: Integer;
  StrToPrint: AnsiString;
begin
  if not (FDevice.Ativo or ControlePorta) then
    raise EPosPrinterException.Create('N�o est� Ativo');

  StrToPrint := '';
  if FBuffer.Count > 0 then
  begin
    For i := 0 to FBuffer.Count-1 do
      StrToPrint := StrToPrint + FBuffer[i] + CRLF;
  end;
  FBuffer.Clear;

  StrToPrint := StrToPrint + AString;

  GravarLog('Imprimir, Copias:' + IntToStr(Copias)+
            ', DecodificarTags:'+IfThen(DecodificarTags,'SIM','NAO')+
            ', TraduzirTags:'+IfThen(TraduzirTags,'SIM','NAO') );
  GravarLog( StrToPrint );

  ConfigurarEspacoEntreLinhas;
  ConfigurarPaginaDeCodigo;

  if CodificarPagina then
    StrToPrint := CodificarPaginaDeCodigo(StrToPrint);

  //DEBUG
  //WriteLog('c:\temp\teste2.txt', StrToPrint, True);

  if DecodificarTags then
    StrToPrint := FTagProcessor.DecodificarTagsFormatacao(StrToPrint);

  if PulaLinha then
    StrToPrint := StrToPrint + LF;

  //DEBUG
  //WriteLog('c:\temp\teste3.txt', StrToPrint, True);

  For i := 1 to Copias do
    EnviarStringDevice(StrToPrint);
end;

procedure TACBrPosPrinter.ImprimirLinha(AString: AnsiString);
begin
  Imprimir(AString, True);
end;

procedure TACBrPosPrinter.ImprimirCmd(AString: AnsiString);
begin
  if FBuffer.Count > 0 then
    Imprimir;

  if AString = '' then
    exit;

  EnviarStringDevice(AString);
end;

procedure TACBrPosPrinter.Zerar;
begin
  GravarLog('Zerar');
  ImprimirCmd(FPosPrinterClass.Cmd.Zera);

  FEspacoEntreLinhasAtual := 0;
  ConfigurarEspacoEntreLinhas;

  FPaginaDeCodigoAtual := pcNone;
  ConfigurarPaginaDeCodigo;
end;

function TACBrPosPrinter.GetNumeroPaginaDeCodigo(APagCod: TACBrPosPaginaCodigo): word;
begin
  case APagCod of
    pc437: Result := 437;
    pc850: Result := 850;
    pc852: Result := 852;
    pc860: Result := 860;
    pc1252: Result := 1252;
    pcUTF8: Result := 65001;
    else
      Result := 0;
  end;
end;

function TACBrPosPrinter.GetAtivo: Boolean;
begin
  Result := FDevice.Ativo;
end;

function TACBrPosPrinter.CodificarPaginaDeCodigo(ATexto: AnsiString
  ): AnsiString;
var
  NumPagCod: word;
begin
  NumPagCod := GetNumeroPaginaDeCodigo(FPaginaDeCodigo);
  //GravarLog('CodificarPaginaDeCodigo: '+IntToStr(NumPagCod) );

  if NumPagCod > 0 then
    Result := TranslateString(ACBrStrToAnsi(ATexto), NumPagCod)
  else
    Result := TiraAcentos(ATexto);
end;

procedure TACBrPosPrinter.PularLinhas(NumLinhas: Integer);
begin
  GravarLog('PularLinhas(' + IntToStr(NumLinhas) + ')');

  if NumLinhas = 0 then
    NumLinhas := LinhasEntreCupons;

  ImprimirCmd( StringOfChar(LF, NumLinhas) );
end;

procedure TACBrPosPrinter.CortarPapel(Parcial: Boolean);
begin
  GravarLog('CortarPapel(' + IfThen(Parcial, 'Parcial', 'Total') + ')');

  if Parcial then
    ImprimirCmd(FPosPrinterClass.Cmd.CorteParcial)
  else
    ImprimirCmd(FPosPrinterClass.Cmd.CorteTotal);

  Sleep(500);
end;

end.
