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

unit pcnReinfR2030;

interface

uses
  Classes, Sysutils, pcnGerador, pcnConversaoReinf, ACBrReinfEventosBase,
  pcnReinfClasses, pcnReinfR2030_Class;

type

  TR2030 = class(TEventoReinfRet)
  private
    FideEstab : TideEstab;
  protected
    procedure GerarEventoXML; override;
    procedure GerarinfoideEstab;
    procedure GerarrecursosRec(Items: TrecursosRecs);
    procedure GerarinfoRecurso(Items: TinfoRecursos);
    procedure GerarinfoProc(Items: TinfoProcs);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property ideEstab: TideEstab read FideEstab;
  end;

implementation

uses
  pcnAuxiliar, ACBrUtil, pcnConversao, DateUtils;

{ TR2030 }

procedure TR2030.AfterConstruction;
begin
  inherited;
  SetSchema(schevtAssocDespRec);
  FideEstab := TideEstab.Create;
end;

procedure TR2030.BeforeDestruction;
begin
  inherited;
  FideEstab.Free;
end;

procedure TR2030.GerarEventoXML;
begin
  GerarinfoideEstab;
end;

procedure TR2030.GerarinfoideEstab;
begin
  Gerador.wGrupo('ideEstab');

  Gerador.wCampo(tcStr, '', 'tpInscEstab', 1,  1, 1, TpInscricaoToStr( Self.FideEstab.tpInscEstab ));
  Gerador.wCampo(tcStr, '', 'nrInscEstab', 1, 14, 1, Self.FideEstab.nrInscEstab);

  GerarrecursosRec(Self.FideEstab.recursosRecs);

  Gerador.wGrupo('/ideEstab');
end;

procedure TR2030.GerarrecursosRec(Items: TrecursosRecs);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('recursosRec');

      Gerador.wCampo(tcStr, '', 'cnpjOrigRecurso', 14, 14, 1, cnpjOrigRecurso);
      Gerador.wCampo(tcDe2, '', 'vlrTotalRec',      1, 14, 1, vlrTotalRec);
      Gerador.wCampo(tcDe2, '', 'vlrTotalRet',      1, 14, 1, vlrTotalRet);
      Gerador.wCampo(tcDe2, '', 'vlrTotalNRet',     1, 14, 0, vlrTotalNRet);

      GerarinfoRecurso(infoRecursos);
      GerarinfoProc(infoProcs);

      Gerador.wGrupo('/recursosRec');
    end;
end;

procedure TR2030.GerarinfoRecurso(Items: TinfoRecursos);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('infoRecurso');

      Gerador.wCampo(tcStr, '', 'tpRepasse',   1,  1, 1, tpRepasseToStr( tpRepasse ));
      Gerador.wCampo(tcStr, '', 'descRecurso', 1, 20, 1, descRecurso);
      Gerador.wCampo(tcDe2, '', 'vlrBruto',    1, 14, 1, vlrBruto);
      Gerador.wCampo(tcDe2, '', 'vlrRetApur',  1, 14, 1, vlrRetApur);

      Gerador.wGrupo('/infoRecurso');
    end;
end;

procedure TR2030.GerarinfoProc(Items: TinfoProcs);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('infoProc');

      Gerador.wCampo(tcStr, '', 'tpProc',  1,  1, 1, TpProcToStr( tpProc ));
      Gerador.wCampo(tcStr, '', 'nrProc',  1, 21, 1, nrProc);
      Gerador.wCampo(tcStr, '', 'codSusp', 1, 14, 0, codSusp);
      Gerador.wCampo(tcDe2, '', 'vlrNRet', 1, 14, 1, vlrNRet);

      Gerador.wGrupo('/infoProc');
    end;
end;

end.
