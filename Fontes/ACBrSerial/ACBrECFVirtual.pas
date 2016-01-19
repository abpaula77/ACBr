{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
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
{ http://www.opensource.org/licenses/gpl-license.php                           }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrECFVirtual ;
{ Implementa a l�gica e mem�ria necess�ria para emular uma Impressora Fiscal,
  por�m n�o possui propriedade ou metodos para Impress�o.
  Deve ser herdado para a cria��o de um componente que implemente Impress�o e
  outras funcionalidades }

interface
uses
  Classes, Contnrs, Math, SysUtils, IniFiles,
  {$IFDEF COMPILER6_UP} DateUtils, StrUtils {$ELSE} ACBrD5, Windows{$ENDIF},
  ACBrBase, ACBrECFClass, ACBrDevice;

type

{ TACBrECFVirtualClassItemCupom }

TACBrECFVirtualClassItemCupom = class
  private
    fsCodDepartamento: Integer;
    fsDescricao: String;
    fsSequencia: Integer;
    fsUnidade: String;
    fsValorUnit: Double;
    fsQtd: Double;
    fsPosAliq: Integer;
    fsCodigo: String;
    fsBaseICMS: Double;
    fsDescAcres :Double;
    function GetAsString: String;
    procedure SetAsString(AValue: String);
  public
    property Sequencia : Integer  read fsSequencia write fsSequencia ;
    property Codigo    : String  read fsCodigo    write fsCodigo    ;
    property Descricao : String  read fsDescricao write fsDescricao ;
    property Qtd       : Double  read fsQtd       write fsQtd       ;
      { Se Qtd = 0 Item foi cancelado }
    property ValorUnit : Double  read fsValorUnit write fsValorUnit ;
    property PosAliq   : Integer read fsPosAliq   write fsPosAliq   ;
    property BaseICMS  : Double  read fsBaseICMS  write fsBaseICMS  ;
    property DescAcres : Double  read fsDescAcres write fsDescAcres ;
    property Unidade   : String  read fsUnidade   write fsUnidade ;
    property CodDepartamento : Integer read fsCodDepartamento write fsCodDepartamento ;

    property AsString : String read GetAsString write SetAsString;
end;

{ TACBrECFVirtualClassItensCupom }

TACBrECFVirtualClassItensCupom = class(TObjectList)
  protected
    procedure SetObject (Index: Integer; Item: TACBrECFVirtualClassItemCupom);
    function GetObject (Index: Integer): TACBrECFVirtualClassItemCupom;
  public
    function New: TACBrECFVirtualClassItemCupom;
    function Add (Obj: TACBrECFVirtualClassItemCupom): Integer;
    procedure Insert (Index: Integer; Obj: TACBrECFVirtualClassItemCupom);
    property Objects [Index: Integer]: TACBrECFVirtualClassItemCupom
      read GetObject write SetObject; default;
end;

{ TACBrECFVirtualClassPagamentoCupom }

TACBrECFVirtualClassPagamentoCupom = class
  private
    fsObservacao: String;
    fsValorPago: Double;
    fsPosFPG: Integer;
    function GetAsString: String;
    procedure SetAsString(AValue: String);
  public
    property PosFPG    : Integer read fsPosFPG     write fsPosFPG;
    property ValorPago : Double  read fsValorPago  write fsValorPago;
    property Observacao: String  read fsObservacao write fsObservacao;

    property AsString : String read GetAsString write SetAsString;
end;

{ TACBrECFVirtualClassPagamentosCupom }

TACBrECFVirtualClassPagamentosCupom = class(TObjectList)
  protected
    procedure SetObject (Index: Integer; Item: TACBrECFVirtualClassPagamentoCupom);
    function GetObject (Index: Integer): TACBrECFVirtualClassPagamentoCupom;
  public
    function New: TACBrECFVirtualClassPagamentoCupom;
    function Add (Obj: TACBrECFVirtualClassPagamentoCupom): Integer;
    procedure Insert (Index: Integer; Obj: TACBrECFVirtualClassPagamentoCupom);
    property Objects [Index: Integer]: TACBrECFVirtualClassPagamentoCupom
      read GetObject write SetObject; default;
end;

{ TACBrECFVirtualClassCNFCupom }

TACBrECFVirtualClassCNFCupom = class
  private
    fsValor  : Double;
    fsPosCNF : Integer;
    function GetAsString: String;
    procedure SetAsString(AValue: String);
  public
    property PosCNF : Integer read fsPosCNF write fsPosCNF   ;
    property Valor  : Double  read fsValor  write fsValor;

    property AsString : String read GetAsString write SetAsString;
end;

{ TACBrECFVirtualClassCNFsCupom }

TACBrECFVirtualClassCNFsCupom = class(TObjectList)
  protected
    procedure SetObject (Index: Integer; Item: TACBrECFVirtualClassCNFCupom);
    function GetObject (Index: Integer): TACBrECFVirtualClassCNFCupom;
  public
    function New: TACBrECFVirtualClassCNFCupom;
    function Add (Obj: TACBrECFVirtualClassCNFCupom): Integer;
    procedure Insert (Index: Integer; Obj: TACBrECFVirtualClassCNFCupom);
    property Objects [Index: Integer]: TACBrECFVirtualClassCNFCupom
      read GetObject write SetObject; default;
end;

TACBrECFVirtualClass = class;
TACBrECFVirtualLerGravarINI = procedure(ConteudoINI: TStrings; var Tratado: Boolean) of object;

{ TACBrECFVirtual }

TACBrECFVirtual = class( TACBrComponent )
  private
    fsECF: TACBrComponent;
    function GetCNPJ: String;
    function GetColunas: Integer;
    function GetIE: String;
    function GetIM: String;
    function GetNomeArqINI: String;
    function GetNumCRO: Integer;
    function GetNumECF: Integer;
    function GetNumSerie: String;
    function GetQuandoGravarArqINI: TACBrECFVirtualLerGravarINI;
    function GetQuandoLerArqINI: TACBrECFVirtualLerGravarINI;
    procedure SetCNPJ(AValue: String);
    procedure SetColunas(AValue: Integer);
    procedure SetIE(AValue: String);
    procedure SetIM(AValue: String);
    procedure SetNomeArqINI(AValue: String);
    procedure SetNumCRO(AValue: Integer);
    procedure SetNumECF(AValue: Integer);
    procedure SetNumSerie(AValue: String);
    procedure SetQuandoGravarArqINI(AValue: TACBrECFVirtualLerGravarINI);
    procedure SetQuandoLerArqINI(AValue: TACBrECFVirtualLerGravarINI);
  protected
    fpECFVirtualClass: TACBrECFVirtualClass;

    procedure SetECF(AValue: TACBrComponent); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure CreateVirtualClass ; virtual ;
  public
    constructor Create( AOwner : TComponent) ; override ;
    destructor Destroy ; override ;

    procedure LeArqINI ;
    procedure GravaArqINI ;

    property ECFVirtualClass : TACBrECFVirtualClass read fpECFVirtualClass ;

    property Colunas    : Integer read GetColunas    write SetColunas;
    property NomeArqINI : String  read GetNomeArqINI write SetNomeArqINI;
    property NumSerie   : String  read GetNumSerie   write SetNumSerie;
    property NumECF     : Integer read GetNumECF     write SetNumECF;
    property NumCRO     : Integer read GetNumCRO     write SetNumCRO;
    property CNPJ       : String  read GetCNPJ       write SetCNPJ;
    property IE         : String  read GetIE         write SetIE;
    property IM         : String  read GetIM         write SetIM;
  published
    property ECF : TACBrComponent read fsECF write SetECF ;

    property QuandoGravarArqINI : TACBrECFVirtualLerGravarINI read GetQuandoGravarArqINI
      write SetQuandoGravarArqINI ;
    property QuandoLerArqINI : TACBrECFVirtualLerGravarINI read GetQuandoLerArqINI
      write SetQuandoLerArqINI ;
end ;

{ Classe filha de TACBrECFClass com implementa�ao para Virtual }

{ TACBrECFVirtualClass }

TACBrECFVirtualClass = class( TACBrECFClass )
  private
    fsECFVirtualOwner: TACBrECFVirtual;
    fsQuandoGravarArqINI: TACBrECFVirtualLerGravarINI;
    fsQuandoLerArqINI: TACBrECFVirtualLerGravarINI;

    procedure SetColunas(AValue: Integer);
    procedure SetDevice(AValue: TACBrDevice);
    procedure SetNumCRO(AValue: Integer);
    procedure SetNumECF(AValue: Integer);
    procedure SetNumSerie(AValue: String);
    procedure Zera ;
    procedure ZeraCupom ;
    function CalculaNomeArqINI: String ;

  protected
    fpNomeArqINI : String;
    fpNumSerie   : String ;
    fpNumECF     : Integer ;
    fpIE         : String ;
    fpCNPJ       : String ;
    fpPAF        : String ;
    fpIM         : String ;
    fpVerao      : Boolean ;
    fpDia        : TDateTime ;
    fpReducoesZ  : Integer ;
    fpLeiturasX  : Integer ;
    fpCuponsCancelados : Integer ;
    fpCuponsCanceladosTotal : Double;
    fpCuponsCanceladosNaoTransmitidos : Integer ;
    fpCuponsCanceladosTotalNaoTransmitidos : Double;
    fpCOOInicial : Integer ;
    fpCOOFinal   : Integer ;
    fpNumCRO     : Integer ;
    fpNumCupom   : Integer ;
    fpChaveCupom : String;
    fpNumGNF     : Integer ;
    fpNumGRG     : Integer ;
    fpNumCDC     : Integer ;
    fpNumCER     : Integer ;
    fpGrandeTotal: Double ;
    fpVendaBruta : Double ;
    fpTotalDescontos  : Double ;
    fpTotalAcrescimos : Double ;
    fpNumCCF     : Integer ;
    fpSubTotal   : Double ;
    fpTotalPago  : Double ;
    fpEXEName    : String ;

    fpItensCupom      : TACBrECFVirtualClassItensCupom ;
    fpPagamentosCupom : TACBrECFVirtualClassPagamentosCupom ;
    fpCNFCupom        : TACBrECFVirtualClassCNFsCupom ;

    function GetDevice: TACBrDevice; virtual;
    function GetColunas: Integer; virtual;

    procedure AtivarVirtual ; virtual ;
    procedure INItoClass( ConteudoINI: TStrings ); virtual ;
    procedure ClasstoINI( ConteudoINI: TStrings ); virtual ;
    procedure CriarMemoriaInicial; virtual;
    procedure LeArqINIVirtual( ConteudoINI: TStrings ) ; virtual;
    procedure GravaArqINIVirtual( ConteudoINI: TStrings ) ; virtual ;

    Procedure AbreDia; virtual ;
    Procedure AbreDocumento ; virtual;
    Procedure AbreDocumentoVirtual ; virtual;
    Procedure VendeItemVirtual( ItemCupom: TACBrECFVirtualClassItemCupom ) ; virtual ;
    Procedure CancelaItemVendidoVirtual( NumItem : Integer ) ; virtual ;
    Procedure DescontoAcrescimoItemAnteriorVirtual(
      ItemCupom: TACBrECFVirtualClassItemCupom; PorcDesc: Double) ; virtual ;
    Procedure SubtotalizaCupomVirtual( DescontoAcrescimo : Double = 0;
       MensagemRodape : AnsiString  = '' ) ; virtual ;
    Procedure EfetuaPagamentoVirtual( Pagto  : TACBrECFVirtualClassPagamentoCupom ) ; virtual ;
    Procedure FechaCupomVirtual( Observacao : AnsiString = ''; IndiceBMP : Integer = 0) ; virtual ;
    procedure VerificaPodeCancelarCupom; virtual;
    Procedure CancelaCupomVirtual ; virtual ;

    Procedure LeituraXVirtual ; virtual ;
    Procedure ReducaoZVirtual(DataHora : TDateTime = 0 ) ; virtual ;

    Procedure AbreRelatorioGerencialVirtual(Indice: Integer = 0) ; virtual ;
    procedure AbreCupomVinculadoVirtual(COO: String; FPG: TACBrECFFormaPagamento;
      CodComprovanteNaoFiscal: String; SubtotalCupomAnterior, ValorFPG: Double ); virtual;
    Procedure FechaRelatorioVirtual ; virtual ;

    Procedure AbreNaoFiscalVirtual( CPF_CNPJ: String = ''; Nome: String = '';
       Endereco: String = '' ) ; virtual ;
    Procedure RegistraItemNaoFiscalVirtual( CNF : TACBrECFComprovanteNaoFiscal;
       Valor : Double; Obs : AnsiString = '') ; virtual ;

    Procedure EnviaConsumidorVirtual ; virtual;

  protected
    function GetDataHora: TDateTime; override ;
    function GetNumCupom: String; override ;
    function GetNumGNF: String; override ;
    function GetNumGRG: String; override ;
    function GetNumCDC: String; override ;
    function GetNumCCF: String; override ;
    function GetGrandeTotal: Double; override ;
    function GetVendaBruta: Double; override ;
    function GetTotalSubstituicaoTributaria: Double; override ;
    function GetTotalNaoTributado: Double; override ;
    function GetTotalIsencao: Double; override ;
    function GetNumReducoesZRestantes: String; override ;
    function GetTotalCancelamentosNaoTransmitidos: Double; override ;
    function GetTotalCancelamentos: Double; override ;
    function GetTotalAcrescimos: Double; override ;
    function GetTotalDescontos: Double; override ;


    function GetNumECF: String; override ;
    function GetCNPJ: String; override ;
    function GetIE: String; override ;
    function GetIM: String; override ;
    function GetPAF: String; override ;
    function GetUsuarioAtual: String; override ;
    function GetDataHoraSB: TDateTime; override ;
    function GetSubModeloECF: String ; override ;
    function GetNumCRO: String; override ;
    function GetNumCRZ: String; override ;
    function GetNumSerie: String; override ;
    function GetNumVersao: String; override ;
    function GetSubTotal: Double; override ;
    function GetTotalPago: Double; override ;

    function GetEstado: TACBrECFEstado; override ;
    function GetHorarioVerao: Boolean; override ;
    function GetArredonda : Boolean; override ;

    function GetDataMovimento: TDateTime; override;
 public
    Constructor Create( AECFVirtual : TACBrECFVirtual );
    Destructor Destroy  ; override ;

    procedure LeArqINI ;
    procedure GravaArqINI ;

    property QuandoGravarArqINI : TACBrECFVirtualLerGravarINI read fsQuandoGravarArqINI
      write fsQuandoGravarArqINI ;
    property QuandoLerArqINI    : TACBrECFVirtualLerGravarINI read fsQuandoLerArqINI
      write fsQuandoLerArqINI ;

    property ECFVirtual : TACBrECFVirtual read fsECFVirtualOwner ;
    property Device     : TACBrDevice     read GetDevice write SetDevice;

    property NomeArqINI : String read  fpNomeArqINI  write fpNomeArqINI ;
    Property Colunas    : Integer read GetColunas     write SetColunas;

    property NumSerie   : String read  fpNumSerie    write SetNumSerie;
    property NumECF     : Integer read fpNumECF      write SetNumECF;
    property NumCRO     : Integer read fpNumCRO      write SetNumCRO;
    property CNPJ       : String read  fpCNPJ        write fpCNPJ;
    property IE         : String read  fpIE          write fpIE;
    property IM         : String read  fpIM          write fpIM;

    property ChaveCupom : String read fpChaveCupom   write fpChaveCupom;

    procedure Ativar ; override ;
    procedure Desativar ; override ;

    Procedure AbreCupom ; override ;
    Procedure VendeItem( Codigo, Descricao : String; AliquotaECF : String;
       Qtd : Double ; ValorUnitario : Double; ValorDescontoAcrescimo : Double = 0;
       Unidade : String = ''; TipoDescontoAcrescimo : String = '%';
       DescontoAcrescimo : String = 'D'; CodDepartamento: Integer = -1 ) ; override ;
    Procedure DescontoAcrescimoItemAnterior( ValorDescontoAcrescimo : Double = 0;
       DescontoAcrescimo : String = 'D'; TipoDescontoAcrescimo : String = '%';
       NumItem : Integer = 0 ) ;  override ;
    Procedure CancelaItemVendido( NumItem : Integer ) ; override ;
    Procedure SubtotalizaCupom( DescontoAcrescimo : Double = 0;
       MensagemRodape : AnsiString  = '' ) ; override ;
    Procedure EfetuaPagamento( CodFormaPagto : String; Valor : Double;
       Observacao : AnsiString = ''; ImprimeVinculado : Boolean = false;
       CodMeioPagamento: Integer = 0) ; override ;
    Procedure FechaCupom( Observacao : AnsiString = ''; IndiceBMP : Integer = 0) ; override ;
    Procedure CancelaCupom( NumCOOCancelar: Integer = 0 ) ; override ;

    Procedure LeituraX ; override ;
    Procedure ReducaoZ(DataHora : TDateTime = 0 ) ; override ;

    Procedure AbreRelatorioGerencial(Indice: Integer = 0) ; override ;
    Procedure LinhaRelatorioGerencial( Linha : AnsiString; IndiceBMP: Integer = 0 ) ; override ;
    Procedure AbreCupomVinculado(COO, CodFormaPagto, CodComprovanteNaoFiscal :
       String; Valor : Double) ; override ;
    Procedure LinhaCupomVinculado( Linha : AnsiString ) ; override ;
    Procedure FechaRelatorio ; override ;
    Procedure CortaPapel( const CorteParcial : Boolean = false) ; override ;

    { Procedimentos de Cupom N�o Fiscal }
    Procedure AbreNaoFiscal( CPF_CNPJ: String = ''; Nome: String = '';
       Endereco: String = '' ) ; override ;
    Procedure RegistraItemNaoFiscal( CodCNF : String; Valor : Double;
       Obs : AnsiString = '') ; override ;

    Procedure MudaHorarioVerao  ; overload ; override ;
    Procedure MudaHorarioVerao( EHorarioVerao : Boolean ) ; overload ; override ;

    procedure CarregaAliquotas ; override ;
    procedure LerTotaisAliquota ; override ;
    Procedure ProgramaAliquota( Aliquota : Double; Tipo : Char = 'T';
       Posicao : String = '') ; override ;
    function AchaICMSAliquota( var AliquotaICMS : String ) :
       TACBrECFAliquota ;  overload ; override ;

    procedure CarregaFormasPagamento ; override ;
    procedure LerTotaisFormaPagamento ; override ;
    Procedure ProgramaFormaPagamento( var Descricao: String;
       PermiteVinculado : Boolean = true; Posicao : String = '' ) ; override ;

    procedure CarregaRelatoriosGerenciais ; override ;
    procedure LerTotaisRelatoriosGerenciais ; override ;
    Procedure ProgramaRelatorioGerencial( var Descricao: String;
       Posicao : String = '') ; override ;

    procedure CarregaComprovantesNaoFiscais ; override ;
    procedure LerTotaisComprovanteNaoFiscal ; override ;
    Procedure ProgramaComprovanteNaoFiscal( var Descricao: String;
       Tipo : String = ''; Posicao : String = '') ; override ;

    Procedure IdentificaOperador(Nome : String); override;
    Procedure IdentificaPAF( NomeVersao, MD5 : String) ; override;

    function TraduzirTag(const ATag: AnsiString): AnsiString; override;
    function TraduzirTagBloco(const ATag, Conteudo: AnsiString): AnsiString; override;
 end ;

implementation

Uses
  typinfo,
  ACBrECF, ACBrUtil, ACBrConsts;

{ TACBrECFVirtualClassCNFsCupom }

procedure TACBrECFVirtualClassCNFsCupom.SetObject(Index: Integer;
  Item: TACBrECFVirtualClassCNFCupom);
begin
  inherited SetItem (Index, Item) ;
end;

function TACBrECFVirtualClassCNFsCupom.GetObject(Index: Integer
  ): TACBrECFVirtualClassCNFCupom;
begin
  Result := inherited GetItem(Index) as TACBrECFVirtualClassCNFCupom ;
end;

function TACBrECFVirtualClassCNFsCupom.New: TACBrECFVirtualClassCNFCupom;
begin
  Result := TACBrECFVirtualClassCNFCupom.Create;
  Add(Result);
end;

function TACBrECFVirtualClassCNFsCupom.Add(Obj: TACBrECFVirtualClassCNFCupom
  ): Integer;
begin
  Result := inherited Add(Obj) ;
end;

procedure TACBrECFVirtualClassCNFsCupom.Insert(Index: Integer;
  Obj: TACBrECFVirtualClassCNFCupom);
begin
  inherited Insert(Index, Obj);
end;

{ TACBrECFVirtualClassPagamentosCupom }

procedure TACBrECFVirtualClassPagamentosCupom.SetObject(Index: Integer;
  Item: TACBrECFVirtualClassPagamentoCupom);
begin
  inherited SetItem (Index, Item) ;
end;

function TACBrECFVirtualClassPagamentosCupom.GetObject(Index: Integer
  ): TACBrECFVirtualClassPagamentoCupom;
begin
  Result := inherited GetItem(Index) as TACBrECFVirtualClassPagamentoCupom ;
end;

function TACBrECFVirtualClassPagamentosCupom.New: TACBrECFVirtualClassPagamentoCupom;
begin
  Result := TACBrECFVirtualClassPagamentoCupom.Create;
  Add(Result);
end;

function TACBrECFVirtualClassPagamentosCupom.Add(
  Obj: TACBrECFVirtualClassPagamentoCupom): Integer;
begin
  Result := inherited Add(Obj) ;
end;

procedure TACBrECFVirtualClassPagamentosCupom.Insert(Index: Integer;
  Obj: TACBrECFVirtualClassPagamentoCupom);
begin
  inherited Insert(Index, Obj);
end;

{ TACBrECFVirtualClassItensCupom }

procedure TACBrECFVirtualClassItensCupom.SetObject(Index: Integer;
  Item: TACBrECFVirtualClassItemCupom);
begin
  inherited SetItem (Index, Item) ;
end;

function TACBrECFVirtualClassItensCupom.GetObject(Index: Integer
  ): TACBrECFVirtualClassItemCupom;
begin
  Result := inherited GetItem(Index) as TACBrECFVirtualClassItemCupom ;
end;

function TACBrECFVirtualClassItensCupom.New: TACBrECFVirtualClassItemCupom;
begin
  Result := TACBrECFVirtualClassItemCupom.Create;
  Add(Result);
end;

function TACBrECFVirtualClassItensCupom.Add(Obj: TACBrECFVirtualClassItemCupom
  ): Integer;
begin
  Result := inherited Add(Obj) ;
end;

procedure TACBrECFVirtualClassItensCupom.Insert(Index: Integer;
  Obj: TACBrECFVirtualClassItemCupom);
begin
  inherited Insert(Index, Obj);
end;

{ TACBrECFVirtualClassCNFCupom }

function TACBrECFVirtualClassCNFCupom.GetAsString: String;
begin
  Result := IntToStr( PosCNF )  + '|' +
            FloatToStr( Valor ) + '|' ;
end;

procedure TACBrECFVirtualClassCNFCupom.SetAsString(AValue: String);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := StringReplace(AValue,'|',sLineBreak,[rfReplaceAll]);

    if SL.Count < 2 then exit ;

    PosCNF := StrToInt( SL[0] );
    Valor  := StrToFloat( SL[1] );
  finally
    SL.Free;
  end;
end;

{ TACBrECFVirtualClassPagamentoCupom }

function TACBrECFVirtualClassPagamentoCupom.GetAsString: String;
begin
   Result := IntToStr( PosFPG )      + '|' +
             FloatToStr( ValorPago ) + '|' +
             Observacao              + '|' ;
end;

procedure TACBrECFVirtualClassPagamentoCupom.SetAsString(AValue: String);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := StringReplace(AValue,'|',sLineBreak,[rfReplaceAll]);

    if SL.Count < 3 then exit ;

    PosFPG     := StrToInt( SL[0] );
    ValorPago  := StrToFloat( SL[1] );
    Observacao := SL[2];
  finally
    SL.Free;
  end;
end;

{ TACBrECFVirtualClassItemCupom }

function TACBrECFVirtualClassItemCupom.GetAsString: String;
begin
  Result := IntToStr( Sequencia )       + '|' +
            Codigo                      + '|' +
            Descricao                   + '|' +
            FloatToStr( Qtd )           + '|' +
            FloatToStr( ValorUnit )     + '|' +
            IntToStr( PosAliq )         + '|' +
            FloatToStr( BaseICMS )      + '|' +
            FloatToStr( DescAcres )     + '|' +
            Unidade                     + '|' +
            IntToStr( CodDepartamento ) + '|' ;
end;

procedure TACBrECFVirtualClassItemCupom.SetAsString(AValue: String);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := StringReplace(AValue,'|',sLineBreak,[rfReplaceAll]);

    if SL.Count < 10 then exit ;

    Sequencia       := StrToInt( SL[0] );
    Codigo          := SL[1];
    Descricao       := SL[2];
    Qtd             := StrToFloat( SL[3] );
    ValorUnit       := StrToFloat( SL[4] );
    PosAliq         := StrToInt( SL[5] );
    BaseICMS        := StrToFloat( SL[6] );
    DescAcres       := StrToFloat( SL[7] );
    Unidade         := SL[8];
    CodDepartamento := StrToInt( SL[9] );
  finally
    SL.Free;
  end;
end;

{ ---------------------------- TACBrECFVirtual ------------------------------- }

constructor TACBrECFVirtual.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fsECF := nil ;
  CreateVirtualClass;
end;

procedure TACBrECFVirtual.CreateVirtualClass;
begin
  fpECFVirtualClass := TACBrECFVirtualClass.create( self );
end;

destructor TACBrECFVirtual.Destroy;
begin
  if Assigned( fsECF ) then
  begin
    if TACBrECF(fsECF).ECF = fpECFVirtualClass then
    begin
      TACBrECF(fsECF).Desativar;
      TACBrECF(fsECF).Modelo := ecfNenhum;
    end;
  end;

  fpECFVirtualClass.Free;

  inherited Destroy;
end;

procedure TACBrECFVirtual.SetECF(AValue: TACBrComponent);
Var
  OldValue : TACBrECF ;
begin
  if AValue <> fsECF then
    if AValue <> nil then
      if not (AValue is TACBrECF) then
        raise Exception.Create(ACBrStr('ACBrVirtual.ECF deve ser do tipo TACBrECF')) ;

   if Assigned(fsECF) then
     fsECF.RemoveFreeNotification(Self);

   OldValue := TACBrECF(fsECF) ;   // Usa outra variavel para evitar Loop Infinito
   fsECF := AValue;                // na remo��o da associa��o dos componentes

   if Assigned(OldValue) then
     if Assigned(OldValue.ECFVirtual) then
       OldValue.ECFVirtual := nil ;

   if AValue <> nil then
   begin
     AValue.FreeNotification(self);
     TACBrECF(AValue).ECFVirtual := Self ;
     // Passa referencia de ACBrECF.Device para self.ECFVirtualClass.Device
     ECFVirtualClass.Device := TACBrECF(AValue).Device;
   end ;
end ;

procedure TACBrECFVirtual.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (fsECF <> nil) and (AComponent is TACBrECF) then
    fsECF := nil ;
end;

function TACBrECFVirtual.GetCNPJ: String;
begin
  Result := fpECFVirtualClass.CNPJ;
end;

function TACBrECFVirtual.GetColunas: Integer;
begin
  Result := fpECFVirtualClass.Colunas;
end;

function TACBrECFVirtual.GetIE: String;
begin
  Result := fpECFVirtualClass.IE;
end;

function TACBrECFVirtual.GetIM: String;
begin
  Result := fpECFVirtualClass.IM;
end;

function TACBrECFVirtual.GetNomeArqINI: String;
begin
  Result := fpECFVirtualClass.NomeArqINI;

  if Result = '' then
     if not (csDesigning in Self.ComponentState) then
        Result := fpECFVirtualClass.CalculaNomeArqINI ;
end;

function TACBrECFVirtual.GetNumCRO: Integer;
begin
  Result := fpECFVirtualClass.NumCRO;
end;

function TACBrECFVirtual.GetNumECF: Integer;
begin
  Result := fpECFVirtualClass.NumECF;
end;

function TACBrECFVirtual.GetNumSerie: String;
begin
  Result := fpECFVirtualClass.NumSerie;
end;

function TACBrECFVirtual.GetQuandoGravarArqINI: TACBrECFVirtualLerGravarINI;
begin
  Result := fpECFVirtualClass.QuandoGravarArqINI;
end;

function TACBrECFVirtual.GetQuandoLerArqINI: TACBrECFVirtualLerGravarINI;
begin
  Result := fpECFVirtualClass.QuandoLerArqINI;
end;

procedure TACBrECFVirtual.SetCNPJ(AValue: String);
begin
  fpECFVirtualClass.CNPJ := AValue;
end;

procedure TACBrECFVirtual.SetColunas(AValue: Integer);
begin
  fpECFVirtualClass.Colunas := AValue;
end;

procedure TACBrECFVirtual.SetIE(AValue: String);
begin
  fpECFVirtualClass.IE := AValue;
end;

procedure TACBrECFVirtual.SetIM(AValue: String);
begin
  fpECFVirtualClass.IM := AValue;
end;

procedure TACBrECFVirtual.SetNomeArqINI(AValue: String);
begin
  fpECFVirtualClass.NomeArqINI := AValue;
end;

procedure TACBrECFVirtual.SetNumCRO(AValue: Integer);
begin
  fpECFVirtualClass.NumCRO := AValue;
end;

procedure TACBrECFVirtual.SetNumECF(AValue: Integer);
begin
  fpECFVirtualClass.NumECF := AValue;
end;

procedure TACBrECFVirtual.SetNumSerie(AValue: String);
begin
  fpECFVirtualClass.NumSerie := AValue;
end;

procedure TACBrECFVirtual.SetQuandoGravarArqINI(AValue: TACBrECFVirtualLerGravarINI);
begin
  fpECFVirtualClass.QuandoGravarArqINI := AValue;
end;

procedure TACBrECFVirtual.SetQuandoLerArqINI(AValue: TACBrECFVirtualLerGravarINI);
begin
  fpECFVirtualClass.QuandoLerArqINI := AValue;
end;

procedure TACBrECFVirtual.LeArqINI;
begin
  fpECFVirtualClass.LeArqINI;
end;

procedure TACBrECFVirtual.GravaArqINI;
begin
  fpECFVirtualClass.GravaArqINI;
end;

{ --------------------------- TACBrECFVirtualClass --------------------------- }

constructor TACBrECFVirtualClass.Create(AECFVirtual: TACBrECFVirtual);
begin
  inherited create( AECFVirtual ) ;

  fpIdentificaConsumidorRodape := True ;
  fsECFVirtualOwner := AECFVirtual;
  fpItensCupom      := TACBrECFVirtualClassItensCupom.Create( true );
  fpPagamentosCupom := TACBrECFVirtualClassPagamentosCupom.Create( true );
  fpCNFCupom        := TACBrECFVirtualClassCNFsCupom.Create( true );

  Zera ;
end;

destructor TACBrECFVirtualClass.Destroy;
begin
  fpItensCupom.Free ;
  fpPagamentosCupom.Free ;
  fpCNFCupom.Free ;

  inherited Destroy ;
end;

procedure TACBrECFVirtualClass.Zera ;
begin
  { Variaveis internas dessa classe }
  fpNomeArqINI := '' ;
  fpNumSerie   := '' ;
  fpNumECF     := 1 ;
  fpIE         := '012.345.678.90' ;
  fpCNPJ       := '01.234.567/0001-22' ;
  fpPAF        := '' ;
  Operador     := '' ;
  fpIM         := '1234-0' ;
  fpModeloStr  := 'ECFVirtual' ;
  fpEXEName    := ParamStr(0) ;
  fpVerao      := false ;
  fpDia        := now ;
  fpNumCRO     := 1 ;
  fpReducoesZ  := 0 ;
  fpLeiturasX  := 0 ;
  fpCOOInicial := 0 ;
  fpCOOFinal   := 0 ;
  fpNumCupom   := 0 ;
  fpChaveCupom := '';
  fpNumGNF     := 0 ;
  fpNumGRG     := 0 ;
  fpNumCDC     := 0 ;
  fpNumCER     := 0 ;
  fpNumCCF     := 0 ;
  fpGrandeTotal:= 0 ;
  fpVendaBruta := 0 ;
  fpCuponsCancelados      := 0 ;
  fpCuponsCanceladosTotal := 0 ;
  fpCuponsCanceladosNaoTransmitidos      := 0 ;
  fpCuponsCanceladosTotalNaoTransmitidos := 0 ;

  ZeraCupom;
end ;

procedure TACBrECFVirtualClass.ZeraCupom ;
begin
  fpItensCupom.Clear ;
  fpPagamentosCupom.Clear ;
  fpCNFCupom.Clear ;
  fpTotalPago := 0 ;
  fpSubTotal  := 0 ;
end ;

procedure TACBrECFVirtualClass.Ativar;
begin
  if not Assigned(ECFVirtual) then
    inherited Ativar;

  try
    LeArqINI ;

    AtivarVirtual;
  except
    Desativar ;
    raise ;
  end ;
end;

procedure TACBrECFVirtualClass.AtivarVirtual;
begin
  fpMFD := True;
end;

procedure TACBrECFVirtualClass.Desativar;
begin
  inherited Desativar ;
end;

procedure TACBrECFVirtualClass.AbreDia ;
begin
  GravaLog('AbreDia');
  fpDia        := now ;
  fpCOOInicial := fpNumCupom ;
end ;

procedure TACBrECFVirtualClass.AbreDocumento ;
begin
  GravaLog('AbreDocumento');

  if fpDia > now then
    raise EACBrECFERRO.create(ACBrStr('Erro ! A Data: '+DateToStr(fpDia)+
                                      '� maior do que a Data atual: '+DateToStr(now))) ;

  try
    fpNumCupom := fpNumCupom + 1 ;
    fpCOOFinal := fpNumCupom ;

    if (CompareDate(fpDia, now) > 0) then
      AbreDia;

    AbreDocumentoVirtual;

    GravaArqINI;   // Grava estado do ECF
  except
    LeArqINI;
    raise;
  end;
end;

procedure TACBrECFVirtualClass.AbreDocumentoVirtual;
begin
  {}
end;

function TACBrECFVirtualClass.GetNumCupom: String;
begin
  Result := IntToStrZero( fpNumCupom, 6 ) ;
  GravaLog('GetNumCupom: '+Result);
end;

function TACBrECFVirtualClass.GetNumGNF: String;
begin
  Result := IntToStrZero( fpNumGNF, 6 ) ;
  GravaLog('GetNumGNF: '+Result);
end;

function TACBrECFVirtualClass.GetNumGRG: String;
begin
  Result := IntToStrZero( fpNumGRG, 6 ) ;
  GravaLog('GetNumGRG: '+Result);
end;

function TACBrECFVirtualClass.GetNumCDC: String;
begin
  Result := IntToStrZero( fpNumCDC, 6 ) ;
  GravaLog('GetNumCDC: '+Result);
end;

function TACBrECFVirtualClass.GetNumCCF: String;
begin
  Result := IntToStrZero( fpNumCCF, 6 ) ;
  GravaLog('GetNumCCF: '+Result);
end;

function TACBrECFVirtualClass.GetGrandeTotal: Double;
begin
  Result := RoundTo( fpGrandeTotal, -2) ;
  GravaLog('GetGrandeTotal: '+FloatToStr(Result));
end;

function TACBrECFVirtualClass.GetVendaBruta: Double;
begin
  Result := RoundTo( fpVendaBruta, -2) ;
  GravaLog('GetVendaBruta: '+FloatToStr(Result));
end;

function TACBrECFVirtualClass.GetTotalSubstituicaoTributaria: Double;
begin
  Result := RoundTo( fpAliquotas[0].Total, -2 ) ;
  GravaLog('GetTotalSubstituicaoTributaria: '+FloatToStr(Result));
end;

function TACBrECFVirtualClass.GetTotalNaoTributado: Double;
begin
  Result := RoundTo( fpAliquotas[1].Total,-2 ) ;
  GravaLog('GetTotalNaoTributado: '+FloatToStr(Result));
end;

function TACBrECFVirtualClass.GetTotalAcrescimos: Double;
begin
   result := RoundTO(fpTotalAcrescimos,-2);
   GravaLog('GetTotalAcrescimos: '+FloatToStr(Result));

end;

function TACBrECFVirtualClass.GetTotalCancelamentos: Double;
begin
   result := RoundTo(fpCuponsCanceladosTotal,-2);
   GravaLog('GetTotalCancelamentos: '+FloatToStr(Result));

end;

function TACBrECFVirtualClass.GetTotalCancelamentosNaoTransmitidos: Double;
begin
   result := RoundTo(fpCuponsCanceladosTotalNaoTransmitidos,-2);
   GravaLog('GetTotalCancelamentosNaoTransmitidos: '+FloatToStr(Result));
end;

function TACBrECFVirtualClass.GetTotalDescontos: Double;
begin
   result := RoundTO(fpTotalDescontos,-2);
   GravaLog('GetTotalDescontos: '+FloatToStr(Result));
end;

function TACBrECFVirtualClass.GetTotalIsencao: Double;
begin
  Result := RoundTo( fpAliquotas[2].Total, -2 ) ;
  GravaLog('GetTotalIsencao: '+FloatToStr(Result));
end;

function TACBrECFVirtualClass.GetNumReducoesZRestantes: String;
begin
  Result:= '9999';
  GravaLog('GetNumReducoesZRestantes: '+Result);
end;

function TACBrECFVirtualClass.GetNumECF: String;
begin
  Result := IntToStrZero(fpNumECF,3) ;
  GravaLog('GetNumECF: '+Result);
end;

function TACBrECFVirtualClass.GetCNPJ: String;
begin
  Result := fpCNPJ ;
  GravaLog('GetCNPJ: '+Result);
end;

function TACBrECFVirtualClass.GetIE: String;
begin
  Result := fpIE ;
  GravaLog('GetIE: '+Result);
end;

function TACBrECFVirtualClass.GetIM: String;
begin
  Result := fpIM ;
  GravaLog('GetIM: '+Result);
end;

function TACBrECFVirtualClass.GetPAF: String;
begin
  Result := fpPAF ;
  GravaLog('GetPAF: '+Result);
end;

function TACBrECFVirtualClass.GetUsuarioAtual: String;
begin
  Result := '0001' ;
  GravaLog('GetUsuarioAtual: '+Result);
end;

function TACBrECFVirtualClass.GetDataHora: TDateTime;
begin
  Result := now;
  GravaLog('GetDataHora: '+DateTimeToStr(Result));
end;

function TACBrECFVirtualClass.GetDataHoraSB: TDateTime;
begin
  Result := EncodeDateTime(2013,12,30,11,12,00,00);
  GravaLog('GetDataHoraSB: '+DateTimeToStr(Result));
end;

function TACBrECFVirtualClass.GetDataMovimento: TDateTime;
begin
  Result := fpDia ;
  GravaLog('GetDataMovimento: '+DateTimeToStr(Result));
end;

function TACBrECFVirtualClass.GetSubModeloECF: String;
begin
  Result := 'Virtual' ;
  GravaLog('GetSubModeloECF: '+Result);
end;

function TACBrECFVirtualClass.GetNumSerie: String;
begin
  Result := fpNumSerie ;
  GravaLog('GetNumSerie: '+Result);
end;

function TACBrECFVirtualClass.GetNumCRO: String;
begin
  Result := IntToStrZero(fpNumCRO, 3) ;
  GravaLog('GetNumCRO: '+Result);
end;

function TACBrECFVirtualClass.GetNumCRZ: String;
begin
  Result := IntToStrZero(fpReducoesZ, 6);
  GravaLog('GetNumCRZ: '+Result);
end;

function TACBrECFVirtualClass.GetNumVersao: String ;
begin
  Result := ACBR_VERSAO ;
  GravaLog('GetNumVersao: '+Result);
end;

function TACBrECFVirtualClass.GetTotalPago: Double;
begin
  Result := RoundTo( fpTotalPago, -2) ;
  GravaLog('GetTotalPago: '+FloatToStr(Result));
end;

function TACBrECFVirtualClass.GetSubTotal: Double;
begin
  Result := RoundTo( fpSubTotal, -2) ;
  GravaLog('GetSubTotal: '+FloatToStr(Result));
end;

procedure TACBrECFVirtualClass.MudaHorarioVerao ;
begin
  GravaLog('MudaHorarioVerao');
  fpVerao := not fpVerao ;

  try
    GravaArqINI ;
  except
    fpVerao := not fpVerao ;
    raise ;
  end ;
end;

procedure TACBrECFVirtualClass.MudaHorarioVerao(EHorarioVerao: Boolean);
begin
  GravaLog( ComandoLOG );
  if EHorarioVerao <> HorarioVerao then
    MudaHorarioVerao ;
end;

procedure TACBrECFVirtualClass.EnviaConsumidorVirtual;
begin
  Consumidor.Enviado := True ;
end;

procedure TACBrECFVirtualClass.VerificaPodeCancelarCupom;
begin
  GravaLog('VerificaPodeCancelarCupom');
  if ((fpItensCupom.Count = 0) and (Estado <> estVenda) ) and
     ((fpCNFCupom.Count   = 0) and (Estado <> estNaoFiscal) ) then
    raise EACBrECFERRO.Create(ACBrStr('�ltimo Documento n�o � Cupom')) ;
end;

procedure TACBrECFVirtualClass.AbreCupom ;
begin
  GravaLog('AbreCupom');
  TestaPodeAbrirCupom ;

  try
    ZeraCupom;

    fpEstado := estVenda ;
    fpNumCCF := fpNumCCF + 1 ;

    EnviaConsumidorVirtual;
    AbreDocumento ;
    //Sleep(7000) ;   // Simulando um atraso //
  except
    LeArqINI ;
    raise ;
  end ;
end;

procedure TACBrECFVirtualClass.VendeItem(Codigo, Descricao : String ;
  AliquotaECF : String ; Qtd : Double ; ValorUnitario : Double ;
  ValorDescontoAcrescimo : Double ; Unidade : String ;
  TipoDescontoAcrescimo : String ; DescontoAcrescimo : String ;
  CodDepartamento : Integer) ;
Var
  Aliq : TACBrECFAliquota ;
  ItemCupom : TACBrECFVirtualClassItemCupom ;
  StrDescAcre : String ;
  PorcDesc, ValDesc, Total : Double ;
  ValItem:Double;
begin
  GravaLog( ComandoLOG );

  if Estado <> estVenda then
    raise EACBrECFERRO.create(ACBrStr('O Estado nao � "VENDA" Cupom n�o Aberto')) ;

  if (Qtd <= 0) or (ValorUnitario <= 0) or (Descricao = '') or (Codigo = '') then
    raise EACBrECFERRO.create(ACBrStr('Erro. Par�metros inv�lidos.')) ;

  Aliq := AchaICMSIndice( AliquotaECF );
  if Aliq = nil then
    raise EACBrECFERRO.create(ACBrStr('Aliquota '+AliquotaECF+' Inv�lida')) ;

  Total    := RoundABNT( Qtd * ValorUnitario, -2) ;
  ValDesc  := 0 ;
  PorcDesc := 0 ;
  if ValorDescontoAcrescimo > 0 then
  begin
    if TipoDescontoAcrescimo = '%' then
    begin
      PorcDesc := -ValorDescontoAcrescimo ;
      ValDesc  := -RoundTo(Total * (ValorDescontoAcrescimo / 100), -3) ;
    end
    else
    begin
      PorcDesc := -RoundTo( (ValorDescontoAcrescimo / Total) * 100, -2) ;
      ValDesc  := -ValorDescontoAcrescimo ;
    end ;

    StrDescAcre := 'DESCONTO' ;
    if DescontoAcrescimo <> 'D' then  // default, DescontoAcrescimo = 'D'
    begin
      ValDesc     := -ValDesc ;
      PorcDesc    := -PorcDesc ;
      StrDescAcre := 'ACRESCIMO' ;
    end ;

    if Abs(PorcDesc) >= 100 then
      raise EACBrECFERRO.create(ACBrStr(StrDescAcre+' maior do que 99,99%'));
  end ;

  if ValorDescontoAcrescimo > 0 then
     Total := RoundTo(Total + ValDesc, -2) ;

  //Sleep(1000) ;   // Simulando um atraso //

  try
    { Adcionando o Item Vendido no ObjectList }
    ItemCupom := TACBrECFVirtualClassItemCupom.Create ;
    ItemCupom.Sequencia := fpItensCupom.Count + 1;
    ItemCupom.Codigo    := Codigo ;
    ItemCupom.Descricao := Descricao ;
    ItemCupom.Qtd       := Qtd ;
    ItemCupom.ValorUnit := ValorUnitario ;
    ItemCupom.PosAliq   := Aliq.Sequencia-1 ;
    ItemCupom.BaseICMS  := Total ;
    ItemCupom.DescAcres := ValDesc;
    ItemCupom.Unidade   := Unidade ;
    ItemCupom.CodDepartamento := CodDepartamento;
    fpItensCupom.Add( ItemCupom ) ;

    ValItem := RoundTo( (Qtd * ValorUnitario),-2) ;

    fpGrandeTotal := RoundTo( ValItem + fpGrandeTotal,-2) ;
    fpVendaBruta  := fpVendaBruta + ValItem ;
    Aliq.Total    := RoundTo( Aliq.Total + Total,-2) ; { Soma na aliquota }
    fpSubTotal    := RoundTo( SubTotal   + Total,-2) ; { Soma no Subtotal }

    VendeItemVirtual( ItemCupom );

    GravaArqINI;
  except
    LeArqINI ;
    raise;
  end ;
end ;

procedure TACBrECFVirtualClass.VendeItemVirtual(
  ItemCupom: TACBrECFVirtualClassItemCupom);
begin
  {}
end;

procedure TACBrECFVirtualClass.DescontoAcrescimoItemAnterior( ValorDescontoAcrescimo : Double = 0;
       DescontoAcrescimo : String = 'D'; TipoDescontoAcrescimo : String = '%';
       NumItem : Integer = 0 ) ;
var
  ValorItem, ValDesc, PorcDesc: Double;
  StrDescAcre : String ;
begin
  GravaLog( ComandoLOG );

  if Estado <> estVenda then
    raise EACBrECFERRO.create(ACBrStr('O Estado nao � "VENDA"')) ;

  if fpItensCupom.Count = 0 then
    raise EACBrECFERRO.create(ACBrStr('Nenhum Item foi vendido ainda')) ;

  if NumItem = 0 then
    NumItem := fpItensCupom.Count;

  if (NumItem < 1) or (NumItem > fpItensCupom.Count) then
    raise EACBrECFERRO.create(ACBrStr('Item ('+IntToStrZero(NumItem,3)+') fora da Faixa.')) ;

  if fpItensCupom[NumItem-1].DescAcres > 0 then
    raise EACBrECFERRO.create(ACBrStr('Item ('+IntToStrZero(NumItem,3)+') j� recebeu Acrescimo.')) ;

  if fpItensCupom[NumItem-1].DescAcres < 0 then
    raise EACBrECFERRO.create(ACBrStr('Item ('+IntToStrZero(NumItem,3)+') j� recebeu Desconto.')) ;

  ValDesc  := 0 ;
  PorcDesc := 0 ;
  with fpItensCupom[NumItem-1] do
    ValorItem := RoundABNT(Qtd * ValorUnit, -2) ;

  if TipoDescontoAcrescimo = '%' then
  begin
    PorcDesc := -ValorDescontoAcrescimo ;
    ValDesc  := -RoundTo(ValorItem * (ValorDescontoAcrescimo / 100), -3) ;
  end
  else
  begin
    PorcDesc := -RoundTo( (ValorDescontoAcrescimo / ValorItem) * 100, -2) ;
    ValDesc  := -ValorDescontoAcrescimo ;
  end ;

  StrDescAcre := 'DESCONTO' ;
  if DescontoAcrescimo <> 'D' then  // default, DescontoAcrescimo = 'D'
  begin
    ValDesc     := -ValDesc ;
    PorcDesc    := -PorcDesc ;
    StrDescAcre := 'ACRESCIMO' ;
  end ;

  if Abs(PorcDesc) >= 100 then
    raise EACBrECFERRO.create(ACBrStr(StrDescAcre+' maior do que 99,99%'));

  if ValorDescontoAcrescimo > 0 then
    ValorItem := RoundTo(ValorItem + ValDesc, -2) ;

  try
    fpSubTotal   := RoundTo(fpSubTotal   + ValDesc,-2);  // Atualiza SubTotal Cupom
    fpVendaBruta := RoundTo(fpVendaBruta + ValDesc,-2);  // Atualiza a venda bruta

    with fpItensCupom[NumItem-1] do
    begin
      DescAcres := ValDesc;

      with fpAliquotas[PosAliq] do
      begin
        Total    := max( RoundTo(Total    + ValDesc, -2), 0) ;
        BaseICMS := max( RoundTo(BaseICMS + ValDesc, -2), 0) ;
      end ;
    end ;

    DescontoAcrescimoItemAnteriorVirtual( fpItensCupom[NumItem-1], PorcDesc );

    GravaArqINI;
  except
    LeArqINI ;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.CancelaItemVendido(NumItem: Integer);
var 
  ValorItem:Double;
begin
  GravaLog( ComandoLOG );

  if Estado <> estVenda then
    raise EACBrECFERRO.create(ACBrStr('O Estado nao � "VENDA"')) ;

  if fpItensCupom.Count = 0 then
    raise EACBrECFERRO.create(ACBrStr('Nenhum Item foi vendido ainda')) ;

  if (NumItem < 1) or (NumItem > fpItensCupom.Count) then
    raise EACBrECFERRO.create(ACBrStr('Item ('+IntToStrZero(NumItem,3)+') fora da Faixa.')) ;

  if fpItensCupom[NumItem-1].Qtd = 0 then
    raise EACBrECFERRO.create(ACBrStr('Item ('+IntToStrZero(NumItem,3)+') j� foi cancelado.')) ;

  try
    CancelaItemVendidoVirtual( NumItem );

    with fpItensCupom[NumItem-1] do
    begin
      ValorItem  := RoundABNT( Qtd * ValorUnit,-2) + DescAcres;
      fpSubTotal := RoundTo(Subtotal - ValorItem,-2);
      fpCuponsCanceladosTotalNaoTransmitidos := RoundTo(fpCuponsCanceladosTotalNaoTransmitidos + ValorItem,-2);
      fpVendaBruta := RoundTo(fpVendaBruta - ValorItem,-2);  // retira o cancelado e nao transmitido da venda bruta
      Qtd := 0;

      with fpAliquotas[ PosAliq ] do
      begin
        Total    := max( RoundTo(Total - BaseICMS,-2), 0) ;
        BaseICMS := 0 ;
      end ;
    end ;

    GravaArqINI;
  except
    LeArqINI ;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.CancelaItemVendidoVirtual(NumItem: Integer);
begin
  {}
end;

procedure TACBrECFVirtualClass.DescontoAcrescimoItemAnteriorVirtual(
  ItemCupom: TACBrECFVirtualClassItemCupom; PorcDesc: Double);
begin
  {}
end;

procedure TACBrECFVirtualClass.SubtotalizaCupom(DescontoAcrescimo: Double;
       MensagemRodape : AnsiString );
Var
  Taxa, ValTaxa : Double ;
  A, AjusteSinal: Integer ;
begin
  GravaLog( ComandoLOG );

  if not (Estado in [estVenda, estNaoFiscal]) then
    raise EACBrECFERRO.create(ACBrStr('O Estado nao � "VENDA" Cupom n�o Aberto')) ;

  if SubTotal <= 0 then
    raise EACBrECFERRO.create(ACBrStr('Nenhum Item foi vendido ainda')) ;

  Taxa := 0 ;
  if DescontoAcrescimo <> 0 then
    Taxa := abs(DescontoAcrescimo) / SubTotal ;

  AjusteSinal := IfThen(DescontoAcrescimo < 0, -1, 1);

  try
    if Taxa <> 0 then  // Aplicando DESCONTO/ACRECIMO em ALIQUOTAS por %
    begin
      For A := 0 to fpItensCupom.Count - 1 do
      begin
        with fpItensCupom[A] do
        begin
	  ValTaxa := ( Qtd * ValorUnit * Taxa * AjusteSinal ) ;

          BaseICMS := RoundTo(BaseICMS + ValTaxa,-2) ;
          with fpAliquotas[ PosAliq ] do
          begin
            Total := RoundTo(Total + ValTaxa,-2) ;
          end ;
        end ;
      end ;
    end ;

    fpSubTotal  := RoundTo( SubTotal + DescontoAcrescimo,-2) ;
    fpEstado    := estPagamento ;
    fpTotalPago := 0 ;

    if DescontoAcrescimo < 0 then
      fpTotalDescontos := fpTotalDescontos + (-DescontoAcrescimo)
    else
      fpTotalAcrescimos := fpTotalAcrescimos + DescontoAcrescimo;

    SubtotalizaCupomVirtual( DescontoAcrescimo, MensagemRodape );

    GravaArqINI ;
  except
    LeArqINI ;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.SubtotalizaCupomVirtual(
  DescontoAcrescimo: Double; MensagemRodape: AnsiString);
begin
  {}
end;

procedure TACBrECFVirtualClass.EfetuaPagamento(CodFormaPagto: String; Valor: Double;
  Observacao: AnsiString; ImprimeVinculado: Boolean; CodMeioPagamento: Integer);
Var
  FPG : TACBrECFFormaPagamento ;
  Troco : Double ;
  Pagto, PagtoTroco : TACBrECFVirtualClassPagamentoCupom ;
begin
  GravaLog( ComandoLOG );

  if Estado <> estPagamento then
    raise EACBrECFERRO.create(ACBrStr('O Estado nao � "PAGAMENTO"')) ;

  if TotalPago >= SubTotal then
    raise EACBrECFERRO.create(ACBrStr('Total pago j� foi atingido Cupom deve ser '+
                                      'encerrado')) ;

  FPG := AchaFPGIndice( CodFormaPagto ) ;
  if FPG = nil then
    raise EACBrECFERRO.create(ACBrStr('Forma de Pagamento '+CodFormaPagto+' Inv�lida')) ;

  try
    fpTotalPago := RoundTo(TotalPago + Valor,-2) ;
    FPG.Total   := RoundTo(FPG.Total + Valor,-2) ;

    Pagto := TACBrECFVirtualClassPagamentoCupom.Create ;
    Pagto.PosFPG    := StrToInt( FPG.Indice ) - 1 ;
    Pagto.ValorPago := Valor ;
    Pagto.Observacao:= Observacao ;
    fpPagamentosCupom.Add( Pagto ) ;

    { Se tiver Troco, remove de 01 - DINHEIRO (indice = 0) }
    Troco := -1 ;
    if TotalPago >= SubTotal then  { Tem TROCO ? }
      Troco := RoundTo(TotalPago - SubTotal,-2) ;

    if Troco > 0 then
    begin
      FPG := fpFormasPagamentos[ 0 ] ;

      FPG.Total := RoundTo(FPG.Total - Troco,-2) ;

      { Lan�ando o Troco como um pagamento no Cupom, por�m negativo, com isso
        o Cancelamento de Cupom conseguir desfaze-lo }
      PagtoTroco := TACBrECFVirtualClassPagamentoCupom.Create ;
      PagtoTroco.PosFPG    := 0 ;
      PagtoTroco.ValorPago := -Troco ;
      PagtoTroco.Observacao:= 'TROCO';
      fpPagamentosCupom.Add( PagtoTroco ) ;
    end ;

    EfetuaPagamentoVirtual( Pagto );

    GravaArqINI ;
  except
    LeArqINI ;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.EfetuaPagamentoVirtual(
  Pagto: TACBrECFVirtualClassPagamentoCupom);
begin
  {}
end;

procedure TACBrECFVirtualClass.FechaCupom(Observacao: AnsiString; IndiceBMP : Integer);
begin
  GravaLog( ComandoLOG );

  if Estado <> estPagamento then
    raise EACBrECFERRO.create(ACBrStr('O Estado nao � "PAGAMENTO", n�o houve SubTotal')) ;

  if TotalPago < SubTotal then
    raise EACBrECFERRO.create(ACBrStr('Total Pago � inferior ao Total do Cupom')) ;

  Observacao := StringReplace( Observacao, #10, CRLF, [rfReplaceAll] ) ;

  try
    EnviaConsumidorVirtual;
    FechaCupomVirtual( Observacao, IndiceBMP);

    fpEstado    := estLivre ;
    fpTotalPago := 0;

    GravaArqINI ;
  except
    LeArqINI;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.FechaCupomVirtual(Observacao: AnsiString;
  IndiceBMP: Integer);
begin
  {}
end;

procedure TACBrECFVirtualClass.CancelaCupom(NumCOOCancelar: Integer);
Var
  A : Integer ;
begin
  GravaLog( ComandoLOG );

  //TODO: Criar evento para recuperar dados do cupom a ser cancelado, se n�o for o �ltimo

  VerificaPodeCancelarCupom;
  try
    if not (Estado in [estVenda, estPagamento, estNaoFiscal] ) then
      fpNumCupom := fpNumCupom + 1 ;

    CancelaCupomVirtual;

    if Estado in estCupomAberto then
    begin
      fpCuponsCanceladosNaoTransmitidos      := fpCuponsCanceladosNaoTransmitidos + 1 ;
      fpCuponsCanceladosTotalNaoTransmitidos := fpCuponsCanceladosTotalNaoTransmitidos + Subtotal;
      fpVendaBruta := fpVendaBruta - SubTotal;
    end
    else
    begin
      fpCuponsCancelados      := fpCuponsCancelados + 1 ;
      fpCuponsCanceladosTotal := fpCuponsCanceladosTotal + Subtotal;
    end;

    { Removendo do TotalDiario por Aliquotas }
    For A := 0 to fpItensCupom.Count - 1 do
      with fpItensCupom[A] do
        with fpAliquotas[ PosAliq ] do
          Total := RoundTo(Total - BaseICMS,-2) ;

    { Removendo do TotalDiario por Pagamento }
    For A := 0 to fpPagamentosCupom.Count - 1 do
      with fpPagamentosCupom[A] do
        with fpFormasPagamentos[ PosFPG ] do
          Total := RoundTo(Total - ValorPago,-2) ;

    { Removendo do TotalDiario por CNF }
    For A := 0 to fpCNFCupom.Count - 1 do
      with fpCNFCupom[A] do
        with fpComprovantesNaoFiscais[ PosCNF ] do
          Total := RoundTo(Total - Valor,-2) ;

    ZeraCupom;
    fpEstado := estLivre;

    GravaArqINI ;
  except
    LeArqINI ;
    raise ;
  end ;
end;

procedure TACBrECFVirtualClass.CancelaCupomVirtual;
begin
  {}
end;

procedure TACBrECFVirtualClass.LeituraX ;
var
  AbrirDia : Boolean ;
begin
  GravaLog( ComandoLOG );

  if Estado <> estRequerX then
    TestaPodeAbrirCupom ;

  AbrirDia := ( Estado in [estRequerX, estRequerZ] ) ;

  try
    ZeraCupom ;
    fpLeiturasX := fpLeiturasX + 1 ;
    fpEstado    := estLivre ;

    if AbrirDia then
      AbreDia;

    LeituraXVirtual;
    AbreDocumento ;
  except
    LeArqINI ;
    raise ;
  end ;
end;

procedure TACBrECFVirtualClass.LeituraXVirtual;
begin
  {}
end;

procedure TACBrECFVirtualClass.ReducaoZ(DataHora : TDateTime) ;
var
  A: Integer ;
begin
  GravaLog( ComandoLOG );

  if Estado = estBloqueada then
    raise EACBrECFERRO.Create(ACBrStr('Dia j� foi fechado. Redu��o Z j� emitida')) ;

  if not (Estado in [estLivre,estRequerZ]) then
    raise EACBrECFERRO.create(ACBrStr('O Estado n�o � "LIVRE" Cancele o �ltimo Documento')) ;

  try
    ZeraCupom;
    ReducaoZVirtual( DataHora );

    fpReducoesZ := fpReducoesZ + 1 ;

    if fpEstado = estRequerZ then
    begin
      fpEstado := estLivre ;
      fpDia    := now ;
    end
    else
      fpEstado := estBloqueada ;

    fpCuponsCancelados      := 0 ;
    fpCuponsCanceladosTotal := 0;
    fpCuponsCanceladosNaoTransmitidos      := 0 ;
    fpCuponsCanceladosTotalNaoTransmitidos := 0;
    fpTotalDescontos  := 0;
    fpTotalAcrescimos := 0;
    fpVendaBruta      := 0 ;
    fpNumCER          := 0 ;

    For A := 0 to fpAliquotas.Count - 1 do
      fpAliquotas[A].Total := 0 ;

    For A := 0 to fpFormasPagamentos.Count - 1 do
      fpFormasPagamentos[A].Total := 0 ;

    For A := 0 to fpComprovantesNaoFiscais.Count - 1 do
      fpComprovantesNaoFiscais[A].Total := 0 ;

    AbreDia;
    AbreDocumento ;
  except
    LeArqINI ;
    raise ;
  end ;
end;

procedure TACBrECFVirtualClass.ReducaoZVirtual(DataHora: TDateTime);
begin
  {}
end;

procedure TACBrECFVirtualClass.AbreRelatorioGerencial(Indice : Integer) ;
var
  IndiceStr: String;
  RG: TACBrECFRelatorioGerencial;
begin
  GravaLog( ComandoLOG );

  if not (Estado in [estLivre,estRequerZ,estRequerX])  then
    raise EACBrECFERRO.Create(ACBrStr('O Estado n�o � "LIVRE"'));

  Indice := max(Indice,1);
  IndiceStr := IntToStrZero( Indice, 2 );
  RG := AchaRGIndice(IndiceStr);
  if RG = Nil then
    raise EACBrECFERRO.create(ACBrStr('Relat�rio Gerencial '+IndiceStr+' Inv�lido')) ;

  try
    fpNumGNF := fpNumGNF + 1 ;
    fpNumGRG := fpNumGRG + 1 ;
    fpNumCER := fpNumCER + 1 ;
    RG.Contador := RG.Contador + 1;

    ZeraCupom;
    fpEstado := estRelatorio ;

    AbreRelatorioGerencialVirtual( Indice );
    AbreDocumento ;

    GravaArqINI;
  except
    LeArqINI ;
    raise ;
  end ;
end;

procedure TACBrECFVirtualClass.AbreRelatorioGerencialVirtual(Indice: Integer);
begin
  {}
end;

procedure TACBrECFVirtualClass.LinhaRelatorioGerencial(Linha: AnsiString; IndiceBMP: Integer);
begin
  GravaLog( ComandoLOG );
end;

procedure TACBrECFVirtualClass.AbreCupomVinculado(COO, CodFormaPagto,
  CodComprovanteNaoFiscal: String; Valor: Double);
Var
  FPG : TACBrECFFormaPagamento ;
  A, PosFPG : Integer ;
  UsouPagamento : Boolean ;
  SubTotalCupomAnterior: Double;
begin
  GravaLog( ComandoLOG );

  if COO = '' then
    raise EACBrECFERRO.create(ACBrStr('COO inv�lido'));

  if Estado <> estLivre  then
    raise EACBrECFERRO.Create(ACBrStr('O Estado n�o � "LIVRE"')) ;

  if fpPagamentosCupom.Count < 1 then
    raise EACBrECFERRO.Create(ACBrStr('Ultimo Documento n�o � Cupom')) ;

  COO := Poem_Zeros(COO,6) ;

  FPG := AchaFPGIndice( CodFormaPagto ) ;
  if FPG = Nil then
    raise EACBrECFERRO.Create(ACBrStr('Posi��o de Pagamento: '+CodFormaPagto+' inv�lida'));

  UsouPagamento := False ;
  A := 0 ;
  while (not UsouPagamento) and (A < fpPagamentosCupom.Count) do
  begin
    PosFPG := fpPagamentosCupom[A].PosFPG ;
    UsouPagamento := (fpFormasPagamentos[ PosFPG ].Indice = FPG.Indice ) ;
    Inc( A ) ;
  end ;

  if not UsouPagamento then
    raise EACBrECFERRO.create(ACBrStr('Forma de Pagamento: '+FPG.Descricao+
                                      ' n�o foi utilizada no Cupom anterior')) ;

  try
    fpNumGNF := fpNumGNF + 1 ;
    fpNumCDC := fpNumCDC + 1 ;
    SubTotalCupomAnterior := Subtotal;

    //ZeraCupom;  // N�o Zera Dados, para permitir chamar "CancelaCupom" ap�s Vinculado
    fpEstado := estRelatorio ;

    AbreCupomVinculadoVirtual(COO, FPG, CodComprovanteNaoFiscal, SubTotalCupomAnterior, Valor);
    AbreDocumento ;
  except
     LeArqINI ;
     raise ;
  end ;
end;

procedure TACBrECFVirtualClass.AbreCupomVinculadoVirtual(COO: String;
  FPG: TACBrECFFormaPagamento; CodComprovanteNaoFiscal: String;
  SubtotalCupomAnterior, ValorFPG: Double);
begin
  {}
end;

procedure TACBrECFVirtualClass.LinhaCupomVinculado(Linha: AnsiString);
begin
  GravaLog( ComandoLOG );
  LinhaRelatorioGerencial( Linha );
end;

procedure TACBrECFVirtualClass.FechaRelatorio;
begin
  GravaLog( 'FechaRelatorio' );

  if Estado <> estRelatorio then exit ;

  try
    fpEstado := estLivre ;
    FechaRelatorioVirtual;

    GravaArqINI ;
  except
    LeArqINI;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.FechaRelatorioVirtual;
begin
  {}
end;

procedure TACBrECFVirtualClass.CortaPapel(const CorteParcial : Boolean) ;
begin
  GravaLog( ComandoLOG );
end ;

procedure TACBrECFVirtualClass.AbreNaoFiscal(CPF_CNPJ : String ; Nome : String ;
  Endereco : String) ;
begin
  GravaLog( ComandoLOG );
  TestaPodeAbrirCupom ;

  try
    ZeraCupom;

    fpEstado := estNaoFiscal ;

    AbreNaoFiscalVirtual(CPF_CNPJ, Nome);
    AbreDocumento ;
  except
    LeArqINI ;
    raise ;
  end ;
end;

procedure TACBrECFVirtualClass.AbreNaoFiscalVirtual(CPF_CNPJ: String;
  Nome: String; Endereco: String);
begin
  {}
end;

procedure TACBrECFVirtualClass.RegistraItemNaoFiscal(CodCNF : String ;
  Valor : Double ; Obs : AnsiString) ;
Var
  CNFCupom : TACBrECFVirtualClassCNFCupom ;
  CNF      : TACBrECFComprovanteNaoFiscal ;
  PosCNF   : Integer ;
begin
  GravaLog( ComandoLOG );
  if Estado <> estNaoFiscal then
    raise EACBrECFERRO.create(ACBrStr('Comprovante N�o Fiscal n�o foi aberto')) ;

  if (Valor <= 0) then
    raise EACBrECFERRO.create(ACBrStr('Erro. Par�metros inv�lidos.')) ;

  CNF := AchaCNFIndice( CodCNF );
  if CNF = Nil then
    raise EACBrECFERRO.create(ACBrStr('Comprovante N�o Fiscal '+CodCNF+' Inv�lido')) ;

  PosCNF := fpComprovantesNaoFiscais.IndexOf( CNF );

  try
    fpSubTotal := RoundTo( Subtotal + Valor,-2) ;      { Soma no Subtotal }
    CNF.Total  := RoundTo(CNF.Total + Valor,-2) ;

    CNFCupom := TACBrECFVirtualClassCNFCupom.Create ;
    CNFCupom.PosCNF := PosCNF  ;
    CNFCupom.Valor  := Valor ;
    fpCNFCupom.Add( CNFCupom ) ;

    RegistraItemNaoFiscalVirtual( CNF, Valor, Obs);

    GravaArqINI ;
  except
    LeArqINI ;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.RegistraItemNaoFiscalVirtual(
  CNF: TACBrECFComprovanteNaoFiscal; Valor: Double; Obs: AnsiString);
begin
  {}
end;

procedure TACBrECFVirtualClass.LeArqINI;
Var
  SL      : TStringList ;
  Tratado : Boolean;
begin
  GravaLog('LeArqINI');

  if fpNomeArqINI = '' then
    fpNomeArqINI := CalculaNomeArqINI;

  Tratado := false;
  SL      := TStringList.Create() ;
  try
    if Assigned( fsQuandoLerArqINI ) then
      fsQuandoLerArqINI( SL, Tratado );

    if not Tratado then
      LeArqINIVirtual( SL );

    INItoClass( SL );
  finally
    SL.Free;
  end;
end;

procedure TACBrECFVirtualClass.LeArqINIVirtual(ConteudoINI: TStrings);
begin
  if not FileExists( fpNomeArqINI ) then
  begin
    CriarMemoriaInicial;
  end ;

  ConteudoINI.LoadFromFile( fpNomeArqINI );
end;

procedure TACBrECFVirtualClass.INItoClass(ConteudoINI: TStrings);
Var
  Ini : TMemIniFile;
  A   : Integer ;
  S,T : String ;
  ItemCupom          : TACBrECFVirtualClassItemCupom ;
  PagamentoCupom     : TACBrECFVirtualClassPagamentoCupom ;
  CNFCupom           : TACBrECFVirtualClassCNFCupom ;
  AliqICMS           : TACBrECFAliquota;
  FormaPagamento     : TACBrECFFormaPagamento;
  ComprovanteVirtual : TACBrECFComprovanteNaoFiscal;
  RelatGerencial     : TACBrECFRelatorioGerencial;
begin
  GravaLog('INItoClass');
  Ini := TMemIniFile.Create( '' ) ;
  try
    Ini.Clear;
    Ini.SetStrings(ConteudoINI);

    fpEstado      := TACBrECFEstado( Ini.ReadInteger('Variaveis','Estado',
                                   Integer( fpEstado) ) ) ;
    fpNumCupom    := Ini.ReadInteger('Variaveis','NumCupom',fpNumCupom) ;
    fpChaveCupom  := Ini.ReadString('Variaveis','ChaveCupom',fpChaveCupom) ;
    fpNumGNF      := Ini.ReadInteger('Variaveis','NumGNF',fpNumGNF) ;
    fpNumGRG      := Ini.ReadInteger('Variaveis','NumGRG',fpNumGRG) ;
    fpNumCDC      := Ini.ReadInteger('Variaveis','NumCDC',fpNumCDC) ;
    fpNumCER      := Ini.ReadInteger('Variaveis','NumCER',fpNumCER) ;
    fpGrandeTotal := Ini.ReadFloat('Variaveis','GrandeTotal',fpGrandeTotal) ;
    fpVendaBruta  := Ini.ReadFloat('Variaveis','VendaBruta',fpVendaBruta) ;
    fpNumCCF      := Ini.ReadInteger('Variaveis','NumCCF',fpNumCCF) ;
    fpDia         := Ini.ReadDate('Variaveis','DiaMovimento',fpDia) ;
    fpVerao       := Ini.ReadBool('Variaveis','HorarioVerao',fpVerao) ;
    fpReducoesZ   := Ini.ReadInteger('Variaveis','ReducoesZ',fpReducoesZ) ;
    fpLeiturasX   := Ini.ReadInteger('Variaveis','LeiturasX',fpLeiturasX) ;
    fpCOOInicial  := Ini.ReadInteger('Variaveis','COOInicial',fpCOOInicial) ;
    fpCOOFinal    := Ini.ReadInteger('Variaveis','COOFinal',fpCOOFinal) ;
    fpSubTotal    := Ini.ReadFloat('Variaveis','SubTotal',fpSubTotal) ;
    fpTotalPago   := Ini.ReadFloat('Variaveis','TotalPago',fpTotalPago) ;
    Operador      := Ini.ReadString('Variaveis','Operador',Operador) ;
    fpPAF         := Ini.ReadString('Variaveis','PAF',fpPAF) ;
    fpCuponsCancelados      := Ini.ReadInteger('Variaveis','CuponsCancelados',
                                               fpCuponsCancelados) ;
    fpCuponsCanceladosTotal := Ini.ReadFloat('Variaveis', 'CuponsCanceladosTotal',
                                             fpCuponsCanceladosTotal);

    fpCuponsCanceladosNaoTransmitidos      := Ini.ReadInteger('Variaveis','CuponsCanceladosNaoTransmitidos',
                                               fpCuponsCanceladosNaoTransmitidos) ;
    fpCuponsCanceladosTotalNaoTransmitidos := Ini.ReadFloat('Variaveis', 'CuponsCanceladosTotalNaoTransmitidos',
                                             fpCuponsCanceladosTotalNaoTransmitidos);

    fpTotalDescontos := Ini.ReadFloat('Variaveis', 'TotalDescontos',fpTotalDescontos);
    fpTotalAcrescimos :=Ini.ReadFloat('Variaveis', 'TotalAcrescimos',fpTotalAcrescimos);

    fpItensCupom.Clear ;
    S := 'Items_Cupom';
    A := 0 ;
    while true do
    begin
      T := Ini.ReadString( S, IntToStrZero(A,3), '*FIM*') ;
      if T = '*FIM*' then break ;

      ItemCupom := TACBrECFVirtualClassItemCupom.Create ;
      ItemCupom.AsString := T ;

      fpItensCupom.Add( ItemCupom ) ;
      A := A + 1 ;
    end ;

    fpPagamentosCupom.Clear ;
    S := 'Pagamentos_Cupom';
    A := 0 ;
    while true do
    begin
      T := Ini.ReadString( S, IntToStrZero(A,2), '*FIM*') ;
      if T = '*FIM*' then break ;

      PagamentoCupom := TACBrECFVirtualClassPagamentoCupom.Create ;
      PagamentoCupom.AsString := T ;

      fpPagamentosCupom.Add( PagamentoCupom ) ;
      A := A + 1 ;
    end ;

    fpCNFCupom.Clear ;
    S := 'Comprovantes_Nao_Fiscais_Cupom';
    A := 0 ;
    while true do
    begin
      T := Ini.ReadString( S, IntToStrZero(A,2), '*FIM*') ;
      if T = '*FIM*' then break ;

      CNFCupom := TACBrECFVirtualClassCNFCupom.Create ;
      CNFCupom.AsString := T ;

      fpCNFCupom.Add( CNFCupom ) ;
      A := A + 1 ;
    end ;

    inherited CarregaAliquotas ;   { Cria fpAliquotas }
    S := 'Aliquotas';
    A := 0 ;
    while true do
    begin
      T := Ini.ReadString( S, IntToStrZero(A,2), '*FIM*') ;
      if T = '*FIM*' then break ;

      AliqICMS := TACBrECFAliquota.Create ;
      AliqICMS.AsString := T ;

      fpAliquotas.Add( AliqICMS ) ;
      A := A + 1 ;
    end ;

    inherited CarregaFormasPagamento ;   { Cria fpFormasPagamentos }
    A := 0 ;
    S := 'Formas_Pagamento';
    while true do
    begin
      T := Ini.ReadString( S, IntToStrZero(A,2), '*FIM*') ;
      if T = '*FIM*' then break ;

      FormaPagamento := TACBrECFFormaPagamento.Create ;
      FormaPagamento.AsString := T ;

      fpFormasPagamentos.Add( FormaPagamento ) ;
      A := A + 1 ;
    end ;

    inherited CarregaRelatoriosGerenciais ;   { Cria fpRelatoriosGerenciais }
    A := 0 ;
    S := 'Relatorios_Gerenciais';
    while true do
    begin
      T := Ini.ReadString( S, IntToStrZero(A,2), '*FIM*') ;
      if T = '*FIM*' then break ;

      RelatGerencial := TACBrECFRelatorioGerencial.Create ;
      RelatGerencial.AsString := T ;

      fpRelatoriosGerenciais.Add( RelatGerencial ) ;
      A := A + 1 ;
    end ;

    inherited CarregaComprovantesNaoFiscais ;   { Cria fpComprovantesNaoFiscais }
    A := 0 ;
    S := 'Comprovantes_nao_Fiscais';
    while true do
    begin
      T := Ini.ReadString( S, IntToStrZero(A,2), '*FIM*') ;
      if T = '*FIM*' then break ;

      ComprovanteVirtual := TACBrECFComprovanteNaoFiscal.Create ;
      ComprovanteVirtual.AsString := T ;

      fpComprovantesNaoFiscais.Add( ComprovanteVirtual ) ;
      A := A + 1 ;
    end ;
  finally
    Ini.Free ;
  end ;
end;

procedure TACBrECFVirtualClass.CriarMemoriaInicial;
Var
  AliqICMS            : TACBrECFAliquota ;
  FormaPagamento      : TACBrECFFormaPagamento ;
  ComprovanteNaoFiscal: TACBrECFComprovanteNaoFiscal;
  RG: TACBrECFRelatorioGerencial;
begin
  GravaLog('CriarMemoriaInicial');
  try
     if fpNumSerie = '' then
       fpNumSerie := 'ACBR01NF'+ FormatDateTime( 'ddmmyyhhnnss', now ) +  ' ' ;
  except
  end ;

  FreeAndNil( fpAliquotas ) ;
  inherited CarregaAliquotas;

  AliqICMS := TACBrECFAliquota.create ;
  AliqICMS.Indice   := 'FF' ;
  AliqICMS.Tipo     := 'T' ;
  fpAliquotas.Add( AliqICMS ) ;

  AliqICMS := TACBrECFAliquota.create ;
  AliqICMS.Indice   := 'II' ;
  AliqICMS.Tipo     := 'T' ;
  fpAliquotas.Add( AliqICMS ) ;

  AliqICMS := TACBrECFAliquota.create ;
  AliqICMS.Indice   := 'NN' ;
  AliqICMS.Tipo     := 'T' ;
  fpAliquotas.Add( AliqICMS ) ;

  FreeAndNil( fpFormasPagamentos ) ;
  inherited CarregaFormasPagamento;

  FormaPagamento := TACBrECFFormaPagamento.create ;
  FormaPagamento.Indice    := '01' ;
  FormaPagamento.Descricao := 'DINHEIRO' ;
  fpFormasPagamentos.Add( FormaPagamento ) ;

  FreeAndNil( fpRelatoriosGerenciais ) ;
  inherited CarregaRelatoriosGerenciais;

  FreeAndNil( fpComprovantesNaoFiscais ) ;
  inherited CarregaComprovantesNaoFiscais;

  ComprovanteNaoFiscal := TACBrECFComprovanteNaoFiscal.create ;
  ComprovanteNaoFiscal.Indice    := '01' ;
  ComprovanteNaoFiscal.Descricao := 'SANGRIA' ;
  fpComprovantesNaoFiscais.Add( ComprovanteNaoFiscal ) ;

  ComprovanteNaoFiscal := TACBrECFComprovanteNaoFiscal.create ;
  ComprovanteNaoFiscal.Indice    := '02' ;
  ComprovanteNaoFiscal.Descricao := 'SUPRIMENTO' ;
  fpComprovantesNaoFiscais.Add( ComprovanteNaoFiscal ) ;

  RG := TACBrECFRelatorioGerencial.create;
  RG.Indice := '01';
  RG.Descricao := 'DIVERSOS';
  fpRelatoriosGerenciais.Add( RG );

  GravaArqINI ;
end ;

procedure TACBrECFVirtualClass.GravaArqINI;
var
  Tratado: Boolean;
  SL: TStringList;
begin
  GravaLog('GravaArqINI');

  if fpNomeArqINI = '' then
    fpNomeArqINI := CalculaNomeArqINI;

  Tratado := false;
  SL      := TStringList.Create() ;
  try
    ClasstoINI( SL );

    if Assigned( fsQuandoGravarArqINI ) then
      fsQuandoGravarArqINI( SL, Tratado );

    if not Tratado then
      GravaArqINIVirtual( SL );
  finally
    SL.Free;
  end;
end;

procedure TACBrECFVirtualClass.GravaArqINIVirtual(ConteudoINI: TStrings);
begin
   ConteudoINI.SaveToFile( fpNomeArqINI );
end;

procedure TACBrECFVirtualClass.ClasstoINI(ConteudoINI: TStrings);
Var
  Ini : TMemIniFile ;
  A   : Integer ;
  S   : String ;
begin
  GravaLog('ClasstoINI');
  Ini := TMemIniFile.Create( '' ) ;
  try
    Ini.Clear;
    Ini.SetStrings( ConteudoINI );

    Ini.WriteInteger('Variaveis','Estado',Integer( fpEstado) ) ;
    Ini.WriteInteger('Variaveis','NumCupom',fpNumCupom) ;
    Ini.WriteString('Variaveis','ChaveCupom',fpChaveCupom) ;
    Ini.WriteInteger('Variaveis','NumGNF',fpNumGNF) ;
    Ini.WriteInteger('Variaveis','NumGRG',fpNumGRG) ;
    Ini.WriteInteger('Variaveis','NumCDC',fpNumCDC) ;
    Ini.WriteInteger('Variaveis','NumCER',fpNumCER) ;
    Ini.WriteFloat('Variaveis','GrandeTotal',fpGrandeTotal) ;
    Ini.WriteFloat('Variaveis','VendaBruta',fpVendaBruta) ;
    Ini.WriteInteger('Variaveis','NumCCF',fpNumCCF) ;
    Ini.WriteDate('Variaveis','DiaMovimento',fpDia) ;
    Ini.WriteBool('Variaveis','HorarioVerao',fpVerao) ;
    Ini.WriteInteger('Variaveis','ReducoesZ',fpReducoesZ) ;
    Ini.WriteInteger('Variaveis','LeiturasX',fpLeiturasX) ;
    Ini.WriteInteger('Variaveis','COOInicial',fpCOOInicial) ;
    Ini.WriteInteger('Variaveis','COOFinal',fpCOOFinal) ;
    Ini.WriteFloat('Variaveis','SubTotal',SubTotal) ;
    Ini.WriteFloat('Variaveis','TotalPago',TotalPago) ;
    Ini.WriteInteger('Variaveis','CuponsCancelados',fpCuponsCancelados) ;
    Ini.WriteFloat('Variaveis', 'CuponsCanceladosTotal', fpCuponsCanceladosTotal);
    Ini.WriteInteger('Variaveis','CuponsCanceladosNaoTransmitidos',fpCuponsCanceladosNaoTransmitidos) ;
    Ini.WriteFloat('Variaveis', 'CuponsCanceladosTotalNaoTransmitidos', fpCuponsCanceladosTotalNaoTransmitidos);
    Ini.WriteFloat('Variaveis', 'TotalDescontos',fpTotalDescontos);
    Ini.WriteFloat('Variaveis', 'TotalAcrescimos',fpTotalAcrescimos);
    Ini.WriteString('Variaveis','Operador',Operador) ;
    Ini.WriteString('Variaveis','PAF',fpPAF) ;

    S := 'Items_Cupom';
    for A := 0 to fpItensCupom.Count - 1 do
    begin
      with fpItensCupom[A] do
        Ini.WriteString( S, IntToStrZero(A,3), AsString );
    end ;

    S := 'Pagamentos_Cupom';
    for A := 0 to fpPagamentosCupom.Count - 1 do
    begin
      with fpPagamentosCupom[A] do
        Ini.WriteString( S ,IntToStrZero( A, 2), AsString ) ;
    end ;

    S := 'Comprovantes_Nao_Fiscais_Cupom';
    for A := 0 to fpCNFCupom.Count - 1 do
    begin
      with fpCNFCupom[A] do
        Ini.WriteString( S ,IntToStrZero( A, 2), AsString ) ;
    end ;

    S := 'Formas_Pagamento';
    for A := 0 to fpFormasPagamentos.Count - 1 do
    begin
      with fpFormasPagamentos[A] do
        Ini.WriteString( S ,IntToStrZero( A, 2), AsString ) ;
    end ;

    S := 'Relatorios_Gerenciais';
    for A := 0 to fpRelatoriosGerenciais.Count - 1 do
    begin
      with fpRelatoriosGerenciais[A] do
        Ini.WriteString( S ,IntToStrZero( A, 2), AsString ) ;
    end ;

    S := 'Comprovantes_nao_Fiscais';
    for A := 0 to fpComprovantesNaoFiscais.Count - 1 do
    begin
      with fpComprovantesNaoFiscais[A] do
        Ini.WriteString( S ,IntToStrZero( A, 2), AsString ) ;
    end ;

    S := 'Aliquotas';
    for A := 0 to fpAliquotas.Count - 1 do
    begin
      with fpAliquotas[A]  do
        Ini.WriteString( S ,IntToStrZero( A, 2), AsString ) ;
    end ;

    ConteudoINI.Clear;
    Ini.GetStrings( ConteudoINI );
  finally
    Ini.Free ;
  end ;
end;

function TACBrECFVirtualClass.CalculaNomeArqINI : String ;
begin
  Result := ExtractFilePath(fpEXEName)+'acbrecf'+GetNumECF+'.ini';
end ;

procedure TACBrECFVirtualClass.SetNumECF(AValue: Integer);
begin
  if fpNumECF = AValue then Exit;
  fpNumECF := min( max( AValue, 1), 999);
end;

procedure TACBrECFVirtualClass.SetNumSerie(AValue: String);
begin
  if fpNumSerie = AValue then Exit;
  fpNumSerie := AValue;
end;

procedure TACBrECFVirtualClass.SetNumCRO(AValue: Integer);
begin
  if fpNumCRO = AValue then Exit;
  fpNumCRO := min( max( AValue, 1), 999);
end;

procedure TACBrECFVirtualClass.SetColunas(AValue: Integer);
begin
  if fpColunas = AValue then Exit;
  fpColunas := AValue;
end;

function TACBrECFVirtualClass.GetColunas: Integer;
begin
    Result := fpColunas;
end;

function TACBrECFVirtualClass.GetDevice: TACBrDevice;
begin
  Result := fpDevice;
end;

procedure TACBrECFVirtualClass.SetDevice(AValue: TACBrDevice);
begin
  fpDevice := AValue;
end;

function TACBrECFVirtualClass.GetEstado: TACBrECFEstado;
Var estAnterior : TACBrECFEstado ;
begin
  estAnterior := fpEstado ;

  if not (fpEstado in [estNaoInicializada,estDesconhecido]) then
  begin
    if (CompareDate( now, fpDia) > 0) and
       ( not (fpEstado in [estBloqueada,estRequerX])) then
      fpEstado := estRequerZ ;

    if (fpEstado = estBloqueada) and (CompareDate( now, fpDia) > 0) then
      fpEstado := estRequerX ;
  end ;

  if fpEstado in [estDesconhecido, estNaoInicializada] then
    fpEstado := estLivre ;

  if fpEstado <> estAnterior then
    GravaArqINI ;

  Result := fpEstado ;
  GravaLog('GetEstado '+GetEnumName(TypeInfo(TACBrECFEstado), integer( fpEstado ) ));
end ;

function TACBrECFVirtualClass.GetArredonda: Boolean;
begin
  Result := true  ;  { Virtual sempre arredonda }
  GravaLog('GetArredonda: '+BoolToStr(Result));
end;

function TACBrECFVirtualClass.GetHorarioVerao: Boolean;
begin
  Result := fpVerao ;
  GravaLog('GetHorarioVerao: '+BoolToStr(Result));
end;

procedure TACBrECFVirtualClass.CarregaFormasPagamento;
begin
  GravaLog('CarregaFormasPagamento');
  LeArqINI;
end;

procedure TACBrECFVirtualClass.LerTotaisFormaPagamento;
begin
  GravaLog('LerTotaisFormaPagamento');
  CarregaFormasPagamento ;
end;

procedure TACBrECFVirtualClass.ProgramaFormaPagamento( var Descricao: String;
   PermiteVinculado : Boolean; Posicao : String ) ;
Var
  FPagto : TACBrECFFormaPagamento ;
  A : Integer ;
begin
  GravaLog( ComandoLOG );
  Descricao := LeftStr(Trim(Descricao),20) ;         { Ajustando tamanho final }

  if not Assigned(fpFormasPagamentos) then
    CarregaFormasPagamento;

  { Verificando se a Descri�ao j� foi programada antes (ja existe ?) }
  For A := 0 to fpFormasPagamentos.Count -1 do
    if trim(UpperCase( fpFormasPagamentos[A].Descricao )) = UpperCase(Descricao) then
      exit ;

  try
    FPagto := TACBrECFFormaPagamento.create ;
    FPagto.Indice           := IntToStrZero( fpFormasPagamentos.Count+1, 2 );
    FPagto.Descricao        := Descricao ;
    FPagto.PermiteVinculado := PermiteVinculado ;
    fpFormasPagamentos.Add( FPagto ) ;

    GravaArqINI ;
  except
    LeArqINI ;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.CarregaRelatoriosGerenciais;
begin
  GravaLog('CarregaRelatoriosGerenciais');
  LeArqINI;
end;

procedure TACBrECFVirtualClass.LerTotaisRelatoriosGerenciais;
begin
  GravaLog('LerTotaisRelatoriosGerenciais');
  CarregaRelatoriosGerenciais;
end;

procedure TACBrECFVirtualClass.ProgramaRelatorioGerencial(
  var Descricao: String; Posicao: String);
Var
  RelGer : TACBrECFRelatorioGerencial ;
  A : Integer ;
begin
  GravaLog( ComandoLOG );

  Descricao := LeftStr(Trim(Descricao),20) ;         { Ajustando tamanho final }

  if not Assigned(fpRelatoriosGerenciais) then
    CarregaRelatoriosGerenciais;

  { Verificando se a Descri�ao j� foi programada antes (ja existe ?) }
  For A := 0 to fpRelatoriosGerenciais.Count -1 do
    if trim(UpperCase( fpRelatoriosGerenciais[A].Descricao )) = UpperCase(Descricao) then
      exit ;

  try
    RelGer := TACBrECFRelatorioGerencial.create ;
    RelGer.Indice           := IntToStrZero( fpRelatoriosGerenciais.Count+1, 2 );
    RelGer.Descricao        := Descricao ;
    fpRelatoriosGerenciais.Add( RelGer ) ;

    GravaArqINI ;
  except
    LeArqINI ;
    raise;
  end ;
end;


procedure TACBrECFVirtualClass.CarregaAliquotas;
begin
  GravaLog('CarregaAliquotas');
  LeArqINI;
end;

procedure TACBrECFVirtualClass.LerTotaisAliquota;
begin
  GravaLog('LerTotaisAliquota');
  CarregaAliquotas ;
end;

function TACBrECFVirtualClass.AchaICMSAliquota(var AliquotaICMS: String):
   TACBrECFAliquota;
Var
  AliquotaStr : String ;
  I: Integer;
begin
  GravaLog( ComandoLOG );

  Result      := nil ;
  AliquotaStr := ''  ;

  case AliquotaICMS[1] of
    'F' : AliquotaStr := 'FF' ;
    'N' : AliquotaStr := 'NN' ;
    'I' : AliquotaStr := 'II' ;
  end;

  if AliquotaStr <> '' then
  begin
    AliquotaICMS := AliquotaStr ;

    if Assigned(fpAliquotas) then
    begin
      For I := 0 to fpAliquotas.Count-1 do
      begin
        if fpAliquotas[I].Indice = AliquotaStr then
        begin
          Result := fpAliquotas[I] ;
          Break;
        end;
      end;
    end ;
  end
  else
    Result := inherited AchaICMSAliquota( AliquotaICMS )
end;

procedure TACBrECFVirtualClass.ProgramaAliquota( Aliquota : Double; Tipo : Char;
   Posicao : String) ;
Var
  Aliq : TACBrECFAliquota ;
  A    : Integer ;
begin
  GravaLog( ComandoLOG );

  Tipo := UpCase(Tipo) ;

  if not Assigned( fpAliquotas ) then
    CarregaAliquotas;

  { Verificando se a Aliquota j� foi programada antes (ja existe ?) }
  For A := 0 to fpAliquotas.Count -1 do
    if (fpAliquotas[A].Aliquota = Aliquota) and
       (fpAliquotas[A].Tipo     = Tipo) then
      exit ;

  try
    Aliq := TACBrECFAliquota.create ;
    Aliq.Indice   := IntToStrZero( fpAliquotas.Count+1,2) ;
    Aliq.Aliquota := Aliquota ;
    Aliq.Tipo     := Tipo ;
    fpAliquotas.Add( Aliq ) ;

    GravaArqINI ;
  except
    LeArqINI ;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.CarregaComprovantesNaoFiscais;
begin
  GravaLog( 'CarregaComprovantesNaoFiscais' );
  LeArqINI;
end;

procedure TACBrECFVirtualClass.LerTotaisComprovanteNaoFiscal ;
begin
  GravaLog( 'LerTotaisComprovanteNaoFiscal' );
  CarregaComprovantesNaoFiscais ;
end;

procedure TACBrECFVirtualClass.ProgramaComprovanteNaoFiscal(var Descricao : String ;
  Tipo : String ; Posicao : String) ;
Var
  CNF : TACBrECFComprovanteNaoFiscal ;
  A : Integer ;
begin
  GravaLog( ComandoLOG );

  if not Assigned( fpComprovantesNaoFiscais ) then
    CarregaComprovantesNaoFiscais;

  Descricao := LeftStr(Trim(Descricao),20) ;         { Ajustando tamanho final }
  Tipo      := UpperCase( Tipo ) ;
  if Tipo = '' then
    Tipo := 'V' ;

  { Verificando se a Descri�ao j� foi programada antes (ja existe ?) }
  For A := 0 to fpComprovantesNaoFiscais.Count -1 do
    if trim( UpperCase( fpComprovantesNaoFiscais[A].Descricao ) ) = UpperCase( Descricao ) then
      exit ;

  try
    CNF := TACBrECFComprovanteNaoFiscal.create ;
    CNF.Indice    := IntToStrZero( fpComprovantesNaoFiscais.Count+1, 2 )  ;
    CNF.Descricao := Descricao ;
    CNF.PermiteVinculado := (Tipo =  'V') ;
    fpComprovantesNaoFiscais.Add( CNF ) ;

    GravaArqINI ;
  except
    LeArqINI ;
    raise;
  end ;
end;

procedure TACBrECFVirtualClass.IdentificaOperador(Nome: String);
begin
  GravaLog( ComandoLOG );
  Operador := Nome;
end;

procedure TACBrECFVirtualClass.IdentificaPAF(NomeVersao, MD5: String);
begin
  GravaLog( ComandoLOG );

  fpPAF := '';
  if NomeVersao <> '' then
    fpPAF := NomeVersao ;

  if (MD5 <> '') then
  begin
    if (fpPAF <> '') then
      fpPAF := fpPAF + '|' ;

    fpPAF := fpPAF + MD5 ;
  end;
end;

function TACBrECFVirtualClass.TraduzirTag(const ATag: AnsiString): AnsiString;
begin
  // N�o Traduz... pois tradu��o ser� feita por TACBrPosPrinter
  Result := ATag;
end;

function TACBrECFVirtualClass.TraduzirTagBloco(const ATag, Conteudo: AnsiString
  ): AnsiString;
begin
  // N�o Traduz... pois tradu��o ser� feita por TACBrPosPrinter
  Result := ATag + Conteudo +
            TraduzirTag( '</'+copy(ATag,2,Length(ATag)) );
end;

end.

