{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009   Isaque Pinheiro                      }
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
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 15/07/2015: Carlos H. Marian
|*  - Cria��o e distribui��o da Primeira Versao
*******************************************************************************}

{$I ACBr.inc}

unit ACBrPAF_Z_Class;

interface

uses SysUtils, Classes, ACBrTXTClass,
     ACBrPAF_Z;

type
  /// TPAF_Z -
  TPAF_Z = class(TACBrTXTClass)
  private
    FRegistroZ1: TRegistroZ1;       // FRegistroZ1
    FRegistroZ2: TRegistroZ2;       // FRegistroZ2
    FRegistroZ3: TRegistroZ3;       // FRegistroZ3
    FRegistroZ4: TRegistroZ4List;   // Lista de FRegistroZ4
    FRegistroZ9: TRegistroZ9;       // FRegistroZ9

    procedure CriaRegistros;
    procedure LiberaRegistros;
    function limpaCampo(pValor: String):String;
  public
    constructor Create;/// Create
    destructor Destroy; override; /// Destroy
    procedure LimpaRegistros;

    function WriteRegistroZ1: string;
    function WriteRegistroZ2: string;
    function WriteRegistroZ3: string;
    function WriteRegistroZ4: string;
    function WriteRegistroZ9: string;

    property RegistroZ1: TRegistroZ1 read FRegistroZ1 write FRegistroZ1;
    property RegistroZ2: TRegistroZ2 read FRegistroZ2 write FRegistroZ2;
    property RegistroZ3: TRegistroZ3 read FRegistroZ3 write FRegistroZ3;
    property RegistroZ4: TRegistroZ4List read FRegistroZ4 write FRegistroZ4;
    property RegistroZ9: TRegistroZ9 read FRegistroZ9 write FRegistroZ9;
  end;

implementation

uses ACBrTXTUtils;

{ TPAF_Z }

constructor TPAF_Z.Create;
begin
CriaRegistros;
end;

procedure TPAF_Z.CriaRegistros;
begin
  FRegistroZ1 := TRegistroZ1.Create;
  FRegistroZ2 := TRegistroZ2.Create;
  FRegistroZ3 := TRegistroZ3.Create;
  FRegistroZ4 := TRegistroZ4List.Create;
  FRegistroZ9 := TRegistroZ9.Create;

  FRegistroZ9.TOT_REG := 0;
end;


destructor TPAF_Z.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPAF_Z.LiberaRegistros;
begin
  FRegistroZ1.Free;
  FRegistroZ2.Free;
  FRegistroZ3.Free;
  FRegistroZ4.Free;
  FRegistroZ9.Free;
end;

function TPAF_Z.limpaCampo(pValor: String): String;
begin
  pValor := StringReplace(pValor,'.', '', [rfReplaceAll] );
  pValor := StringReplace(pValor,'-', '', [rfReplaceAll] );
  pValor := StringReplace(pValor,'/', '', [rfReplaceAll] );
  pValor := StringReplace(pValor,',', '', [rfReplaceAll] );
  Result := pValor;
end;

procedure TPAF_Z.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  /// Recriar os Registros Limpos
  CriaRegistros;
end;

function TPAF_Z.WriteRegistroZ1: string;
var
  strRegistroZ01:string;
  strRegistroZ02:string;
  strRegistroZ03:string;
  strRegistroZ04:string;
  strRegistroZ09:string;
begin
  strRegistroZ01 := '';
  strRegistroZ02 := '';
  strRegistroZ03 := '';
  strRegistroZ04 := '';
  strRegistroZ09 := '';
  if Assigned(FRegistroZ1) then
  begin
      with FRegistroZ1 do
      begin
        Check(funChecaCNPJ(CNPJ), '(Z1) IDENTIFICA��O DO USU�RIO DO PAF-ECF: O CNPJ "%s" digitado � inv�lido!', [CNPJ]);
        Check(funChecaIE(IE, UF), '(Z1) IDENTIFICA��O DO USU�RIO DO PAF-ECF: A Inscri��o Estadual "%s" digitada � inv�lida!', [IE]);
        ///
        strRegistroZ01 := LFill('Z1') +
                          LFill(limpaCampo(CNPJ)       , 14) +
                          RFill(limpaCampo(IE)         , 14) +
                          RFill(limpaCampo(IM)         , 14) +
                          RFill(RAZAOSOCIAL, 50) +
                          sLineBreak;
      end;
      strRegistroZ02 := WriteRegistroZ2;
      strRegistroZ03 := WriteRegistroZ3;
      strRegistroZ04 := WriteRegistroZ4;
      strRegistroZ09 := WriteRegistroZ9;
  end;
  Result := strRegistroZ01 +
            strRegistroZ02 +
            strRegistroZ03 +
            strRegistroZ04 +
            strRegistroZ09;
end;

function TPAF_Z.WriteRegistroZ2: string;
begin
  if Assigned(FRegistroZ2) then
  begin
      with FRegistroZ2 do
      begin
        Check(funChecaCNPJ(CNPJ), '(Z2) IDENTIFICA��O DA EMPRESA DESENVOLVEDORA DO PAF-ECF: O CNPJ "%s" digitado � inv�lido!', [CNPJ]);
        Check(funChecaIE(IE, UF), '(Z2) IDENTIFICA��O DA EMPRESA DESENVOLVEDORA DO PAF-ECF: A Inscri��o Estadual "%s" digitada � inv�lida!', [IE]);
        ///
        Result := LFill('Z2') +
                  LFill(limpaCampo(CNPJ)       , 14) +
                  RFill(limpaCampo(IE)         , 14) +
                  RFill(limpaCampo(IM)         , 14) +
                  RFill(RAZAOSOCIAL, 50) +
                  sLineBreak;
      end;
  end;
end;

function TPAF_Z.WriteRegistroZ3: string;
begin
  if Assigned(FRegistroZ3) then
  begin
      with FRegistroZ3 do
      begin
        Result := LFill('Z3') +
                  LFill(LAUDO , 10) +
                  LFill(NOME  , 50) +
                  LFill(VERSAO, 10) +
                  sLineBreak;
      end;
  end;
end;

function TPAF_Z.WriteRegistroZ4: string;
var
  intFor: integer;
  strRegistroZ4: string;
  dataAtual: TDateTime;
begin
  strRegistroZ4 := '';

  if Assigned(FRegistroZ4) then
  begin
     dataAtual:= Now();

     for intFor := 0 to FRegistroZ4.Count - 1 do
     begin
        with FRegistroZ4.Items[intFor] do
        begin
          Check(funChecaCNPJ(CNPJ), '(Z4) Totaliza��o de vendas a CPF/CNPJ: O CNPJ "%s" digitado � inv�lido!', [CNPJ]);
          ///
          strRegistroZ4 := strRegistroZ4 + LFill('Z4') +
                                           LFill(limpaCampo(CNPJ)      , 14) +
                                           LFill(VL_TOTAL  , 12, 2) +
                                           LFill(DATA_INI  , 'yyyymmdd') +
                                           LFill(DATA_FIM  , 'yyyymmdd') +
                                           LFill(dataAtual , 'yyyymmdd') +
                                           LFill(dataAtual , 'hhmmss') +
                                           sLineBreak;
        end;
        ///
        FRegistroZ9.TOT_REG := FRegistroZ9.TOT_REG + 1;
     end;
     Result := strRegistroZ4;
  end;
end;

function TPAF_Z.WriteRegistroZ9: string;
begin
   if Assigned(FRegistroZ9) then
   begin
      with FRegistroZ9 do
      begin
        Check(funChecaCNPJ(FRegistroZ2.CNPJ),             '(Z9) TOTALIZA��O: O CNPJ "%s" digitado � inv�lido!', [FRegistroZ2.CNPJ]);
        Check(funChecaIE(FRegistroZ2.IE, FRegistroZ2.UF), '(Z9) TOTALIZA��O: A Inscri��o Estadual "%s" digitada � inv�lida!', [FRegistroZ2.IE]);
        ///
        Result := LFill('Z9') +
                  LFill(limpaCampo(FRegistroZ2.CNPJ), 14  ) +
                  RFill(limpaCampo(FRegistroZ2.IE)  , 14  ) +
                  LFill(TOT_REG         , 6, 0) +
                  sLineBreak;
      end;
   end;
end;

end.
