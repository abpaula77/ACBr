{******************************************************************************}
{ Projeto: Componente ACBrReinf                                                }
{  Biblioteca multiplataforma de componentes Delphi para envio de eventos do   }
{ Reinf                                                                        }

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

unit pcnReinfR2030_Class;

interface

uses
  Classes, Sysutils, pcnConversaoReinf, Controls, Contnrs;

type
  TrecursosRecs = class;
  TinfoRecursos = class;
  TinfoProcs = class;

  { TinfoProc }
  TinfoProc = class
  private
    FtpProc  : tpTpProc;
    FnrProc  : String;
    FcodSusp : String;
    FvlrNRet : double;
  public
    property tpProc : tpTpProc read FtpProc write FtpProc;
    property nrProc : String read FnrProc write FnrProc;
    property codSusp : String read FcodSusp write FcodSusp;
    property vlrNRet : double read FvlrNRet write FvlrNRet;
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

  { TinfoRecurso }
  TinfoRecurso = class
  private
    FtpRepasse   : TtpRepasse;
    FdescRecurso : String;
    FvlrBruto    : double;
    FvlrRetApur  : double;
  public
    property tpRepasse : TtpRepasse read FtpRepasse write FtpRepasse;
    property descRecurso : String read FdescRecurso write FdescRecurso;
    property vlrBruto : double read FvlrBruto write FvlrBruto;
    property vlrRetApur : double read FvlrRetApur write FvlrRetApur;
  end;

  { TinfoRecursos }
  TinfoRecursos = class(TObjectList)
  private
    function GetItem(Index: Integer): TinfoRecurso;
    procedure SetItem(Index: Integer; const Value: TinfoRecurso);
  public
    function New: TinfoRecurso;

    property Items[Index: Integer]: TinfoRecurso read GetItem write SetItem;
  end;

  { TrecursosRec }
  TrecursosRec = class
  private
    FcnpjOrigRecurso : String;
    FvlrTotalRec     : double;
    FvlrTotalRet     : double;
    FvlrTotalNRet    : double;
    FinfoRecursos    : TinfoRecursos;
    FinfoProcs       : TinfoProcs;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property cnpjOrigRecurso : String read FcnpjOrigRecurso write FcnpjOrigRecurso;
    property vlrTotalRec : double read FvlrTotalRec write FvlrTotalRec;
    property vlrTotalRet : double read FvlrTotalRet write FvlrTotalRet;
    property vlrTotalNRet : double read FvlrTotalNRet write FvlrTotalNRet;
    property infoRecursos : TinfoRecursos read FinfoRecursos;
    property infoProcs : TinfoProcs read FinfoProcs;
  end;

  { TrecursosRecs }
  TrecursosRecs = class(TObjectList)
  private
    function GetItem(Index: Integer): TrecursosRec;
    procedure SetItem(Index: Integer; const Value: TrecursosRec);
  public
    function New: TrecursosRec;

    property Items[Index: Integer]: TrecursosRec read GetItem write SetItem;
  end;

  { TideEstab }
  TideEstab = class
  private
    FtpInscEstab  : tpTpInsc;
    FnrInscEstab  : String;
    FrecursosRecs : TrecursosRecs;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property tpInscEstab : tpTpInsc read FtpInscEstab write FtpInscEstab;
    property nrInscEstab : String read FnrInscEstab write FnrInscEstab;
    property recursosRecs : TrecursosRecs read FrecursosRecs;
  end;

implementation

{ TideEstab }

procedure TideEstab.AfterConstruction;
begin
  inherited;
  FrecursosRecs := TrecursosRecs.Create;
end;

procedure TideEstab.BeforeDestruction;
begin
  inherited;
  FrecursosRecs.Free;
end;

{ TrecursosRec }

procedure TrecursosRec.AfterConstruction;
begin
  inherited;
  FinfoRecursos := TinfoRecursos.Create;
  FinfoProcs    := TinfoProcs.Create;
end;

procedure TrecursosRec.BeforeDestruction;
begin
  inherited;
  FinfoRecursos.Free;
  FinfoProcs.Free;
end;

{ TrecursosRecs }

function TrecursosRecs.GetItem(Index: Integer): TrecursosRec;
begin
  Result := TrecursosRec(Inherited Items[Index]);
end;

function TrecursosRecs.New: TrecursosRec;
begin
  Result := TrecursosRec.Create;
  Add(Result);
end;

procedure TrecursosRecs.SetItem(Index: Integer; const Value: TrecursosRec);
begin
  Put(Index, Value);
end;

{ TinfoRecursos }

function TinfoRecursos.GetItem(Index: Integer): TinfoRecurso;
begin
  Result := TinfoRecurso(Inherited Items[Index]);
end;

function TinfoRecursos.New: TinfoRecurso;
begin
  Result := TinfoRecurso.Create;
  Add(Result);
end;

procedure TinfoRecursos.SetItem(Index: Integer; const Value: TinfoRecurso);
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

