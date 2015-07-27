{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                          }

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

unit ACBrDFeUtil;

interface

uses
  Classes, StrUtils, SysUtils;

function FormatarNumeroDocumentoFiscal(AValue: String): String;
function FormatarNumeroDocumentoFiscalNFSe(AValue: String): String;
function GerarChaveAcesso(AUF:Integer; ADataEmissao:TDateTime; ACNPJ:String; ASerie:Integer;
                           ANumero,ACodigo: Integer; AModelo:Integer=55): String;
function FormatarChaveAcesso(AValue: String): String;

function ValidaUFCidade(const UF, Cidade: integer): Boolean; overload;
procedure ValidaUFCidade(const UF, Cidade: integer; const AMensagem: String); overload;
function ValidaDIDSI(AValue: String): Boolean;
function ValidaDIRE(AValue: String): Boolean;
function ValidaRE(AValue: String): Boolean;
function ValidaDrawback(AValue: String): Boolean;
function ValidaSUFRAMA(AValue: String): Boolean;
function ValidaRECOPI(AValue: String): Boolean;
function ValidaNVE(AValue: string): Boolean;

function XmlEstaAssinado(const AXML: String): Boolean;
function ExtraiURI(const AXML: String): String;


implementation

uses
  Variants, DateUtils,
  pcnGerador,
  ACBrConsts, ACBrDFeException, ACBrUtil, ACBrValidador ;

function FormatarNumeroDocumentoFiscal(AValue: String): String;
begin
  AValue := Poem_Zeros(AValue, 9);
  Result := copy(AValue, 1, 3) + '.' + copy(AValue, 4, 3) + '.' + copy(AValue, 7, 3);
end;

function FormatarNumeroDocumentoFiscalNFSe(AValue: String): String;
begin
  AValue := Poem_Zeros(AValue, 15);
  Result := copy(AValue, 1, 4) + '.' + copy(AValue, 5, 12);
end;

function ValidaUFCidade(const UF, Cidade: integer): Boolean;
begin
  Result := (Copy(IntToStr(UF), 1, 2) = Copy(IntToStr(Cidade), 1, 2));
end;

procedure ValidaUFCidade(const UF, Cidade: integer; const AMensagem: String);
begin
  if not (ValidaUFCidade(UF, Cidade)) then
    raise EACBrDFeException.Create(AMensagem);
end;

function GerarChaveAcesso(AUF: Integer; ADataEmissao: TDateTime; ACNPJ: String;
  ASerie: Integer; ANumero, ACodigo: Integer; AModelo: Integer): String;
var
  vUF, vDataEmissao, vSerie, vNumero, vCodigo, vModelo: String;
begin
  vUF          := Poem_Zeros(AUF, 2);
  vDataEmissao := FormatDateTime('YYMM', ADataEmissao);
  vModelo      := Poem_Zeros(AModelo, 2);
  vSerie       := Poem_Zeros(ASerie, 3);
  vNumero      := Poem_Zeros(ANumero, 9);
  vCodigo      := Poem_Zeros(ACodigo, 9);

  Result := vUF + vDataEmissao + ACNPJ + vModelo + vSerie + vNumero + vCodigo;
  Result := Result + Modulo11(Result);
end;

function FormatarChaveAcesso(AValue: String): String;
var
  I: Integer;
begin
  AValue := OnlyNumber(AValue);
  I := 1;
  Result := '';
  while I < Length(AValue) do
  begin
    Result := Result+copy(AValue,I,4)+' ';
    Inc( I, 4);
  end;

  Result := Trim(Result);
end;

function ValidaDIDSI(AValue: String): Boolean;
var
  ano: integer;
  sValue: String;
begin
  // AValue = TAANNNNNNND
  // Onde: T Identifica o tipo de documento ( 2 = DI e 4 = DSI )
  //       AA Ano corrente da gera��o do documento
  //       NNNNNNN N�mero sequencial dentro do Ano ( 7 ou 8 d�gitos )
  //       D D�gito Verificador, M�dulo 11, Pesos de 2 a 9
  AValue := OnlyNumber(AValue);
  ano := StrToInt(Copy(IntToStr(YearOf(Date)), 3, 2));

  if (length(AValue) < 11) or (length(AValue) > 12) then
    Result := False
  else if (copy(Avalue, 1, 1) <> '2') and (copy(Avalue, 1, 1) <> '4') then
    Result := False
  else if not ((StrToInt(copy(Avalue, 2, 2)) >= ano - 1) and
    (StrToInt(copy(Avalue, 2, 2)) <= ano + 1)) then
    Result := False
  else
  begin
    sValue := copy(AValue, 1, length(AValue) - 1);
    Result := copy(AValue, length(AValue), 1) = Modulo11(sValue);
  end;
end;

function ValidaDIRE(AValue: String): Boolean;
var
  ano: integer;
begin
  // AValue = AANNNNNNNNNN
  // Onde: AA Ano corrente da gera��o do documento
  //       NNNNNNNNNN N�mero sequencial dentro do Ano ( 10 d�gitos )
  AValue := OnlyNumber(AValue);
  ano := StrToInt(Copy(IntToStr(YearOf(Date)), 3, 2));

  if length(AValue) <> 12 then
    Result := False
  else
    Result := (StrToInt(copy(Avalue, 1, 2)) >= ano - 1) and
      (StrToInt(copy(Avalue, 1, 2)) <= ano + 1);
end;

function ValidaRE(AValue: String): Boolean;
var
  ano: integer;
begin
  // AValue = AANNNNNNNSSS
  // Onde: AA Ano corrente da gera��o do documento
  //       NNNNNNN N�mero sequencial dentro do Ano ( 7 d�gitos )
  //       SSS Serie do RE (001, 002, ...)
  AValue := OnlyNumber(AValue);
  ano := StrToInt(Copy(IntToStr(YearOf(Date)), 3, 2));

  if length(AValue) <> 12 then
    Result := False
  else if not ((StrToInt(copy(Avalue, 1, 2)) >= ano - 1) and
    (StrToInt(copy(Avalue, 1, 2)) <= ano + 1)) then
    Result := False
  else
    Result := (StrToInt(copy(Avalue, 10, 3)) >= 1) and
      (StrToInt(copy(Avalue, 10, 3)) <= 999);
end;

function ValidaDrawback(AValue: String): Boolean;
var
  ano: integer;
begin
  // AValue = AAAANNNNNND
  // Onde: AAAA Ano corrente do registro
  //       NNNNNN N�mero sequencial dentro do Ano ( 6 d�gitos )
  //       D D�gito Verificador, M�dulo 11, Pesos de 2 a 9
  AValue := OnlyNumber(AValue);
  ano := StrToInt(Copy(IntToStr(YearOf(Date)), 3, 2));
  if length(AValue) = 11 then
    AValue := copy(AValue, 3, 9);

  if length(AValue) <> 9 then
    Result := False
  else if not ((StrToInt(copy(Avalue, 1, 2)) >= ano - 1) and
    (StrToInt(copy(Avalue, 1, 2)) <= ano + 1)) then
    Result := False
  else
    Result := copy(AValue, 9, 1) = Modulo11(copy(AValue, 1, 8));
end;

function ValidaSUFRAMA(AValue: String): Boolean;
var
  SS, LL: integer;
begin
  // AValue = SSNNNNLLD
  // Onde: SS C�digo do setor de atividade da empresa ( 01, 02, 10, 11, 20 e 60 )
  //       NNNN N�mero sequencial ( 4 d�gitos )
  //       LL C�digo da localidade da Unidade Administrativa da Suframa ( 01 = Manaus, 10 = Boa Vista e 30 = Porto Velho )
  //       D D�gito Verificador, M�dulo 11, Pesos de 2 a 9
  AValue := OnlyNumber(AValue);
  if length(AValue) < 9 then
    AValue := '0' + AValue;
  if length(AValue) <> 9 then
    Result := False
  else
  begin
    SS := StrToInt(copy(Avalue, 1, 2));
    LL := StrToInt(copy(Avalue, 7, 2));
    if not (SS in [01, 02, 10, 11, 20, 60]) then
      Result := False
    else if not (LL in [01, 10, 30]) then
      Result := False
    else
      Result := copy(AValue, 9, 1) = Modulo11(copy(AValue, 1, 8));
  end;
end;

function ValidaRECOPI(AValue: String): Boolean;
begin
  // AValue = aaaammddhhmmssffffDD
  // Onde: aaaammdd Ano/Mes/Dia da autoriza��o
  //       hhmmssffff Hora/Minuto/Segundo da autoriza��o com mais 4 digitos da fra��o de segundo
  //       DD D�gitos Verificadores, M�dulo 11, Pesos de 1 a 18 e de 1 a 19
  AValue := OnlyNumber(AValue);
  if length(AValue) <> 20 then
    Result := False
  else if copy(AValue, 19, 1) <> Modulo11(copy(AValue, 1, 18), 1, 18) then
    Result := False
  else
    Result := copy(AValue, 20, 1) = Modulo11(copy(AValue, 1, 19), 1, 19);
end;

function ValidaNVE(AValue: string): Boolean;
begin
  //TODO:
  Result := True;
end;

function ExtraiURI(const AXML: String): String;
var
  I, J: integer;
begin
  I := PosEx('Id=', AXML, 6);
  if I = 0 then
    raise EACBrDFeException.Create('N�o encontrei inicio do URI: Id=');

  I := PosEx('"', AXML, I + 2);
  if I = 0 then
    raise EACBrDFeException.Create('N�o encontrei inicio do URI: aspas inicial');

  J := PosEx('"', AXML, I + 1);
  if J = 0 then
    raise EACBrDFeException.Create('N�o encontrei inicio do URI: aspas final');

  Result := copy(AXML, I + 1, J - I - 1);
end;

function XmlEstaAssinado(const AXML: String): Boolean;
begin
  Result := (pos('<signature', lowercase(AXML)) > 0);
end;

end.
(*

///  TODO: REMOVER ??


class function TrataString(const AValue: String): String;overload;
class function TrataString(const AValue: String; const ATamanho: Integer): String;overload;

class function TrataString(const AValue: String;
  const ATamanho: Integer): String;
begin
  Result := TrataString(LeftStr(AValue, ATamanho));
end;

class function TrataString(const AValue: String): String;
var
  A : Integer ;
begin
  Result := '' ;
  For A := 1 to length(AValue) do
  begin
    case Ord(AValue[A]) of
      60  : Result := Result + '&lt;';  //<
      62  : Result := Result + '&gt;';  //>
      38  : Result := Result + '&amp;'; //&
      34  : Result := Result + '&quot;';//"
      39  : Result := Result + '&#39;'; //'
      32  : begin          // Retira espa�os duplos
              if ( Ord(AValue[Pred(A)]) <> 32 ) then
                 Result := Result + ' ';
            end;
      193 : Result := Result + 'A';//�
      224 : Result := Result + 'a';//�
      226 : Result := Result + 'a';//�
      234 : Result := Result + 'e';//�
      244 : Result := Result + 'o';//�
      251 : Result := Result + 'u';//�
      227 : Result := Result + 'a';//�
      245 : Result := Result + 'o';//�
      225 : Result := Result + 'a';//�
      233 : Result := Result + 'e';//�
      237 : Result := Result + 'i';//�
      243 : Result := Result + 'o';//�
      250 : Result := Result + 'u';//�
      231 : Result := Result + 'c';//�
      252 : Result := Result + 'u';//�
      192 : Result := Result + 'A';//�
      194 : Result := Result + 'A';//�
      202 : Result := Result + 'E';//�
      212 : Result := Result + 'O';//�
      219 : Result := Result + 'U';//�
      195 : Result := Result + 'A';//�
      213 : Result := Result + 'O';//�
      201 : Result := Result + 'E';//�
      205 : Result := Result + 'I';//�
      211 : Result := Result + 'O';//�
      218 : Result := Result + 'U';//�
      199 : Result := Result + 'C';//�
      220 : Result := Result + 'U';//�
    else
      Result := Result + AValue[A];
    end;
  end;
  Result := Trim(Result);
end;

class function CollateBr(Str: String): String;
var
   i, wTamanho: integer;
   wChar, wResultado: Char;
begin
   result   := '';
   wtamanho := Length(Str);
   i        := 1;
   while (i <= wtamanho) do
   begin
      wChar := Str[i];
      case wChar of
         '�', '�', '�', '�', '�', '�',
         '�', '�', '�', '�', '�', '�': wResultado := 'A';
         '�', '�', '�', '�',
         '�', '�', '�', '�': wResultado := 'E';
         '�', '�', '�', '�',
         '�', '�', '�', '�': wResultado := 'I';
         '�', '�', '�', '�', '�',
         '�', '�', '�', '�', '�': wResultado := 'O';
         '�', '�', '�', '�',
         '�', '�', '�', '�': wResultado := 'U';
         '�', '�': wResultado := 'C';
         '�', '�': wResultado := 'N';
         '�', '�', '�', 'Y': wResultado := 'Y';
      else
         wResultado := wChar;
      end;
      i      := i + 1;
      Result := Result + wResultado;
   end;
   Result := UpperCase(Result);
end;


class function UpperCase2(Str: String): String;
var
   i, wTamanho: integer;
   wChar, wResultado: Char;
begin
   result   := '';
   wtamanho := Length(Str);
   i        := 1;
   while (i <= wtamanho) do
   begin
      wChar := Str[i];
      case wChar of
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�','�': wResultado := '�';
         '�', '�': wResultado := '�';
         '�', '�': wResultado := '�';
         '�', '�', '�', 'Y': wResultado := 'Y';
      else
         wResultado := wChar;
      end;
      i      := i + 1;
      Result := Result + wResultado;
   end;
   Result := UpperCase(Result);
end;


class function FormatDate(const AString: string): String;
var
  vTemp: TDateTime;
{$IFDEF VER140} //D6
{$ELSE}
  vFormatSettings : TFormatSettings;
{$ENDIF}
begin
  try
{$IFDEF VER140} //D6
    DateSeparator := '/';
    ShortDateFormat := 'dd/mm/yyyy';
{$ELSE}
    vFormatSettings.DateSeparator   := '-';
    vFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
//    vTemp := StrToDate(AString, FFormato);
{$ENDIF}
    vTemp := StrToDate(AString);
    if vTemp = 0 then
      Result := ''
    else
      Result := DateToStr(vTemp);
  except
    Result := '';
  end;
end;

class function FormatDate(const AData: TDateTime): String;
var
  vTemp: String;
{$IFDEF VER140} //delphi6
{$ELSE}
  FFormato : TFormatSettings;
{$ENDIF}
begin
  try
{$IFDEF VER140} //delphi6
    DateSeparator := '/';
    ShortDateFormat := 'dd/mm/yyyy';
{$ELSE}
    FFormato.DateSeparator   := '-';
    FFormato.ShortDateFormat := 'yyyy-mm-dd';
{$ENDIF}
  vTemp := DateToStr(AData);

    if AData = 0 then
      Result := ''
    else
      Result := vTemp;
  except
    Result := '';
  end;
end;

class function FormatDateTime(const AString: string): string;
var
  vTemp : TDateTime;
{$IFDEF VER140} //delphi6
{$ELSE}
vFormatSettings: TFormatSettings;
{$ENDIF}
begin
  try
{$IFDEF VER140} //delphi6
    DateSeparator   := '/';
    ShortDateFormat := 'dd/mm/yyyy';
    ShortTimeFormat := 'hh:nn:ss';
{$ELSE}
    vFormatSettings.DateSeparator   := '-';
    vFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
    //    vTemp := StrToDate(AString, FFormato);
{$ENDIF}
    vTemp := StrToDateTime(AString);
    if vTemp = 0 then
      Result := ''
    else
      Result := DateTimeToStr(vTemp);
  except
    Result := '';
  end;
end;

class function FormatFloat(AValue: Extended;
  const AFormat: string): String;
{$IFDEF VER140} //D6
{$ELSE}
var
vFormatSettings: TFormatSettings;
{$ENDIF}
begin
{$IFDEF VER140} //D6
  DecimalSeparator  := ',';
  ThousandSeparator := '.';
  Result := SysUtils.FormatFloat(AFormat, AValue);
{$ELSE}
  vFormatSettings.DecimalSeparator  := ',';
  vFormatSettings.ThousandSeparator := '.';
  Result := SysUtils.FormatFloat(AFormat, AValue, vFormatSettings);
{$ENDIF}
end;

class function StringToDate(const AString: string): TDateTime;
begin
  if (AString = '0') or (AString = '') then
     Result := 0
  else
     Result := StrToDate(AString);
end;

class function StringToTime(const AString: string): TDateTime;
begin
  if (AString = '0') or (AString = '') then
     Result := 0
  else
     Result := StrToTime(AString);
end;


class function Modulo11(Valor: string; Peso: Integer = 2; Base: Integer = 9): String;

*)
