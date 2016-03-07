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

unit pmdfeConversaoMDFe;

interface

uses
  SysUtils, StrUtils, Classes;

type
  TTpEmitenteMDFe = (teTransportadora, teTranspCargaPropria);
  TModalMDFe      = (moRodoviario, moAereo, moAquaviario, moFerroviario);
  TVersaoMDFe     = (ve100, ve100a);

  TLayOutMDFe     = (LayMDFeRecepcao, LayMDFeRetRecepcao, LayMDFeConsulta,
                     LayMDFeStatusServico, LayMDFeEvento, LayMDFeConsNaoEnc,
                     LayMDFeDistDFeInt);

  TSchemaMDFe     = (schErro, schMDFe, schEventoMDFe,
                     schresMDFe, schresEvento, schprocMDFe, schprocEventoMDFe,
                     schconsReciMDFe, schconsSitMDFe, schconsStatServ,
                     schmdfeModalAereo, schmdfeModalAquaviario,
                     schmdfeModalFerroviario, schmdfeModalRodoviario,
                     schevCancMDFe, schevEncMDFe, schevIncCondutorMDFe,
                     schdistDFeInt, schconsMDFeNaoEnc);

  TStatusACBrMDFe = (stMDFeIdle, stMDFeStatusServico, stMDFeRecepcao, stMDFeRetRecepcao,
                     stMDFeConsulta, stMDFeRecibo, stMDFeEmail, stMDFeEvento,
                     stMDFeDistDFeInt, stMDFeEnvioWebService);

const

  MDFeModalRodo    = '1.00';
  MDFeModalAereo   = '1.00';
  MDFeModalAqua    = '1.00';
  MDFeModalFerro   = '1.00';
  MDFeModalDuto    = '1.00';

  DSC_NMDF        = 'N�mero do Manifesto';
  DSC_CMDF        = 'C�digo num�rico que comp�e a Chave de Acesso';
  DSC_TPEMIT      = 'Tipo do Emitente';
  DSC_CMUNCARREGA = 'C�digo do Munic�pio de Carregamento';
  DSC_XMUNCARREGA = 'Nome do Munic�pio de Carregamento';
  DSC_UFPER       = 'Sigla da UF do percurso do ve�culo';
  DSC_SEGCODBARRA = 'Segundo c�digo de barras';
  DSC_NCT         = 'N�mero do CT';
  DSC_SUBSERIE    = 'Subs�rie do CT';
  DSC_PIN         = 'PIN SUFRAMA';
  DSC_QCTE        = 'Quantidade total de CTe relacionados no Manifesto';
  DSC_QCT         = 'Quantidade total de CT relacionados no Manifesto';
  DSC_QNFE        = 'Quantidade total de NFe relacionados no Manifesto';
  DSC_QNF         = 'Quantidade total de NF relacionados no Manifesto';
  DSC_QCARGA      = 'Peso Bruto Total da Carga / Mercadoria Transportada';
  DSC_DHINIVIAGEM = 'Data e Hora previstas de Inicio da Viagem';

  // Rodovi�rio
  DSC_CIOT        = 'C�digo Identificador da Opera��o de Transporte';
  DSC_CINTV       = 'C�digo interno do ve�culo';
  DSC_TARA        = 'Tara em KG';
  DSC_CAPKG       = 'Capacidade em KG';
  DSC_CAPM3       = 'Capacidade em m3';
  DSC_CNPJFORN    = 'CNPJ da empresa fornecedora do Vale-Ped�gio';
  DSC_CNPJPG      = 'CNPJ do respons�vel pelo pagamento do Vale-Ped�gio';
  DSC_NCOMPRA     = 'N�mero do comprovante de compra';
  DSC_CODAGPORTO  = 'C�digo de Agendamento no Porto';

  // A�reo
  DSC_NAC         = 'Marca da Nacionalidade da Aeronave';
  DSC_MATR        = 'Marca da Matricula da Aeronave';
  DSC_NVOO        = 'N�mero do V�o';
  DSC_CAEREMB     = 'Aer�dromo de Embarque';
  DSC_CAERDES     = 'Aer�dromo de Destino';
  DSC_DVOO        = 'Data do V�o';

  // Aquavi�rio
  DSC_CNPJAGENAV  = 'CNPJ da Ag�ncia de Navega��o';
  DSC_TPEMB       = 'Tipo de Embarca��o';
  DSC_CEMBAR      = 'C�digo da Embarca��o';
  DSC_XEMBAR      = 'Nome da Embarca��o';
  DSC_NVIAG       = 'N�mero da Viagem';
  DSC_CPRTEMB     = 'C�digo do Porto de Embarque';
  DSC_CPRTDEST    = 'C�digo do Porto de Destino';
  DSC_CTERMCARREG = 'C�digo do Terminal de Carregamento';
  DSC_XTERMCARREG = 'Nome do Terminal de Carregamento';
  DSC_CTERMDESCAR = 'C�digo do Terminal de Descarregamento';
  DSC_XTERMDESCAR = 'Nome do Terminal de Descarregamento';
  DSC_CEMBCOMB    = 'C�digo da Embarca��o do comboio';
  
  // Ferrovi�rio
  DSC_XPREF       = 'Prefixo do Trem';
  DSC_DHTREM      = 'Data e Hora de libera��o do Trem na origem';
  DSC_XORI        = 'Origem do Trem';
  DSC_XDEST       = 'Destino do Trem';
  DSC_QVAG        = 'Quantidade de vag�es carregados';
  DSC_NVAG        = 'N�mero de Identifica��o do vag�o';
  DSC_NSEQ        = 'Sequ�ncia do vag�o na composi��o';
  DSC_TU          = 'Tonelada �til';


function StrToEnumerado(out ok: boolean; const s: string; const AString: array of string;
  const AEnumerados: array of variant): variant;
function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;

function TpEmitenteToStr(const t: TTpEmitenteMDFe): String;
function StrToTpEmitente(out ok: Boolean; const s: String): TTpEmitenteMDFe;

function LayOutToSchema(const t: TLayOutMDFe): TSchemaMDFe;

function ModalToStr(const t: TModalMDFe): String;
function StrToModal(out ok: Boolean; const s: String): TModalMDFe;

function GetVersaoModalMDFe(AVersaoDF: TVersaoMDFe; AModal: TModalMDFe): string;

function LayOutToServico(const t: TLayOutMDFe): String;
function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutMDFe;

function SchemaMDFeToStr(const t: TSchemaMDFe): String;
function StrToSchemaMDFe(out ok: Boolean; const s: String): TSchemaMDFe;

function StrToVersaoMDFe(out ok: Boolean; const s: String): TVersaoMDFe;
function VersaoMDFeToStr(const t: TVersaoMDFe): String;

function DblToVersaoMDFe(out ok: Boolean; const d: Double): TVersaoMDFe;
function VersaoMDFeToDbl(const t: TVersaoMDFe): Double;

implementation

uses
  pcnConversao, typinfo;

function StrToEnumerado(out ok: boolean; const s: string; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := -1;
  for i := Low(AString) to High(AString) do
    if AnsiSameText(s, AString[i]) then
      result := AEnumerados[i];
  ok := result <> -1;
  if not ok then
    result := AEnumerados[0];
end;

function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := '';
  for i := Low(AEnumerados) to High(AEnumerados) do
    if t = AEnumerados[i] then
      result := AString[i];
end;

// Tipo de Emitente*************************************************************

function TpEmitenteToStr(const t: TTpEmitenteMDFe): String;
begin
  result := EnumeradoToStr(t,
                           ['1', '2'],
                           [teTransportadora, teTranspCargaPropria]);
end;

function StrToTpEmitente(out ok: Boolean; const s: String): TTpEmitenteMDFe;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2'],
                           [teTransportadora, teTranspCargaPropria]);
end;

function LayOutToSchema(const t: TLayOutMDFe): TSchemaMDFe;
begin
  case t of
    LayMDFeRecepcao:       Result := schMDFe;
    LayMDFeRetRecepcao:    Result := schconsReciMDFe;
    LayMDFeConsulta:       Result := schconsSitMDFe;
    LayMDFeStatusServico:  Result := schconsStatServ;
    LayMDFeEvento:         Result := schEventoMDFe;
    LayMDFeConsNaoEnc:     Result := schconsMDFeNaoEnc;
    LayMDFeDistDFeInt:     Result := schdistDFeInt;
  else
    Result := schErro;
  end;
end;

// Modal************************************************************************

function ModalToStr(const t: TModalMDFe): String;
begin
  result := EnumeradoToStr(t,
                           ['1', '2', '3', '4'],
                           [moRodoviario, moAereo, moAquaviario, moFerroviario]);
end;

function StrToModal(out ok: Boolean; const s: String): TModalMDFe;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2', '3', '4'],
                           [moRodoviario, moAereo, moAquaviario, moFerroviario]);
end;

function GetVersaoModalMDFe(AVersaoDF: TVersaoMDFe; AModal: TModalMDFe): string;
begin
  result := '';

  case AVersaoDF of
    ve100,
    ve100a: begin
              case AModal of
                moRodoviario:  result := '1.00';
                moAereo:       result := '1.00';
                moAquaviario:  result := '1.00';
                moFerroviario: result := '1.00';
              end;
            end;
  end;
end;

function LayOutToServico(const t: TLayOutMDFe): String;
begin
  Result := EnumeradoToStr(t,
    ['MDFeRecepcao', 'MDFeRetRecepcao', 'MDFeConsultaProtocolo',
     'MDFeStatusServico', 'RecepcaoEvento', 'MDFeConsNaoEnc',
     'MDFeDistDFeInt'],
    [ LayMDFeRecepcao, LayMDFeRetRecepcao, LayMDFeConsulta,
      LayMDFeStatusServico, LayMDFeEvento, LayMDFeConsNaoEnc,
      LayMDFeDistDFeInt ] );
end;

function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutMDFe;
begin
  Result := StrToEnumerado(ok, s,
  ['MDFeRecepcao', 'MDFeRetRecepcao', 'MDFeConsultaProtocolo',
   'MDFeStatusServico', 'RecepcaoEvento', 'MDFeConsNaoEnc',
   'MDFeDistDFeInt'],
  [ LayMDFeRecepcao, LayMDFeRetRecepcao, LayMDFeConsulta,
    LayMDFeStatusServico, LayMDFeEvento, LayMDFeConsNaoEnc,
    LayMDFeDistDFeInt ] );
end;

function SchemaMDFeToStr(const t: TSchemaMDFe): String;
begin
  Result := GetEnumName(TypeInfo(TSchemaMDFe), Integer( t ) );
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaMDFe(out ok: Boolean; const s: String): TSchemaMDFe;
var
  P: Integer;
  SchemaStr: String;
begin
  P := pos('_', s);
  if P > 0 then
    SchemaStr := copy(s, 1, P-1)
  else
    SchemaStr := s;

  if LeftStr(SchemaStr, 3) <> 'sch' then
    SchemaStr := 'sch' + SchemaStr;

  Result := TSchemaMDFe( GetEnumValue(TypeInfo(TSchemaMDFe), SchemaStr ) );
end;

function StrToVersaoMDFe(out ok: Boolean; const s: String): TVersaoMDFe;
begin
  Result := StrToEnumerado(ok, s, ['1.00', '1.00'], [ve100, ve100a]);
end;

function VersaoMDFeToStr(const t: TVersaoMDFe): String;
begin
  Result := EnumeradoToStr(t, ['1.00', '1.00'], [ve100, ve100a]);
end;

function DblToVersaoMDFe(out ok: Boolean; const d: Double): TVersaoMDFe;
begin
  ok := True;

  if d = 1.0 then
    Result := ve100
  else
  begin
    Result := ve100;
    ok := False;
  end;
end;

function VersaoMDFeToDbl(const t: TVersaoMDFe): Double;
begin
  case t of
    ve100: Result := 1.0;
    ve100a: Result := 1.0;
  else
    Result := 0;
  end;
end;

end.

