{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

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
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}
{******************************************************************************
|* Historico
|*
|* 04/12/2017: Renato Rubinho
|*  - Implementados registros que faltavam e isoladas as respectivas classes 
*******************************************************************************}

unit ACBrReinfR2050_Class;

interface

uses Classes, Sysutils, pcnConversaoReinf, Controls, Contnrs;

type
  TtipoComs = class;
  TinfoProcs = class;

  { TinfoProc }
  TinfoProc = class
  private
    FtpProc       : tpTpProc;
    FnrProc       : String;
    FcodSusp      : String;
    FvlrCPSusp    : double;
    FvlrRatSusp   : double;
    FvlrSenarSusp : double;
  public
    property tpProc : tpTpProc read FtpProc write FtpProc;
    property nrProc : String read FnrProc write FnrProc;
    property codSusp : String read FcodSusp write FcodSusp;
    property vlrCPSusp : double read FvlrCPSusp write FvlrCPSusp;
    property vlrRatSusp : double read FvlrRatSusp write FvlrRatSusp;
    property vlrSenarSusp : double read FvlrSenarSusp write FvlrSenarSusp;
  end;

  { TinfoProcs }
  TinfoProcs = class(TObjectList)
  private
    function GetItem(Index: Integer): TinfoProc;
    procedure SetItem(Index: Integer; const Value: TinfoProc);
  public
    function New: TinfoProc;

    property Items[Index: Integer]: TinfoProc read GetItem write SetItem;
  end;

  { TtipoCom }
  TtipoCom = class
  private
    FindCom      : TindCom;
    FvlrRecBruta : double;
    FinfoProcs   : TinfoProcs;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property indCom : TindCom read FindCom write FindCom;
    property vlrRecBruta : double read FvlrRecBruta write FvlrRecBruta;
    property infoProcs : TinfoProcs read FinfoProcs;
  end;

  { TtipoComs }
  TtipoComs = class(TObjectList)
  private
    function GetItem(Index: Integer): TtipoCom;
    procedure SetItem(Index: Integer; const Value: TtipoCom);
  public
    function New: TtipoCom;

    property Items[Index: Integer]: TtipoCom read GetItem write SetItem;
  end;

  { TideEstab }
  TideEstab = class
  private
    FtpInscEstab       : tpTpInsc;
    FnrInscEstab       : String;
    FvlrRecBrutaTotal  : double;
    FvlrCPApur         : double;
    FvlrRatApur        : double;
    FvlrSenarApur      : double;
    FvlrCPSuspTotal    : double;
    FvlrRatSuspTotal   : double;
    FvlrSenarSuspTotal : double;
    FtipoComs          : TtipoComs;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property tpInscEstab : tpTpInsc read FtpInscEstab write FtpInscEstab;
    property nrInscEstab : String read FnrInscEstab write FnrInscEstab;
    property vlrRecBrutaTotal : double read FvlrRecBrutaTotal write FvlrRecBrutaTotal;
    property vlrCPApur : double read FvlrCPApur write FvlrCPApur;
    property vlrRatApur : double read FvlrRatApur write FvlrRatApur;
    property vlrSenarApur : double read FvlrSenarApur write FvlrSenarApur;
    property vlrCPSuspTotal : double read FvlrCPSuspTotal write FvlrCPSuspTotal;
    property vlrRatSuspTotal : double read FvlrRatSuspTotal write FvlrRatSuspTotal;
    property vlrSenarSuspTotal : double read FvlrSenarSuspTotal write FvlrSenarSuspTotal;
    property tipoComs : TtipoComs read FtipoComs;
  end;

  { TinfoComProd }
  TinfoComProd = class
  private
    FideEstab : TideEstab;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property ideEstab : TideEstab read FideEstab write FideEstab;
  end;

implementation

{ TinfoComProd }

procedure TinfoComProd.AfterConstruction;
begin
  inherited;
  FideEstab := TideEstab.Create;
end;

procedure TinfoComProd.BeforeDestruction;
begin
  inherited;
  FideEstab.Free;
end;

{ TideEstab }

procedure TideEstab.AfterConstruction;
begin
  inherited;
  FtipoComs := TtipoComs.Create;
end;

procedure TideEstab.BeforeDestruction;
begin
  inherited;
  FtipoComs.Free;
end;

{ TtipoCom }

procedure TtipoCom.AfterConstruction;
begin
  inherited;
  FinfoProcs := TinfoProcs.Create;
end;

procedure TtipoCom.BeforeDestruction;
begin
  inherited;
  FinfoProcs.Free;
end;

{ TtipoComs }

function TtipoComs.GetItem(Index: Integer): TtipoCom;
begin
  Result := TtipoCom(Inherited Items[Index]);
end;

function TtipoComs.New: TtipoCom;
begin
  Result := TtipoCom.Create;
  Add(Result);
end;

procedure TtipoComs.SetItem(Index: Integer; const Value: TtipoCom);
begin
  Put(Index, Value);
end;

{ TinfoProcs }

function TinfoProcs.GetItem(Index: Integer): TinfoProc;
begin
  Result := TinfoProc(Inherited Items[Index]);
end;

function TinfoProcs.New: TinfoProc;
begin
  Result := TinfoProc.Create;
  Add(Result);
end;

procedure TinfoProcs.SetItem(Index: Integer; const Value: TinfoProc);
begin
  Put(Index, Value);
end;

end.

