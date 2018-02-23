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

unit pcnReinfR3010;


interface

uses
  Classes, Sysutils, pcnGerador, pcnConversaoReinf, ACBrReinfEventosBase,
  pcnReinfClasses, pcnReinfR3010_Class;

type

  TR3010 = class(TEventoReinfRet)
  private
    FideEstabs: TideEstabs;
  protected
    procedure GerarEventoXML; override;
    procedure GerarinfoideEstab(Items: TideEstabs);
    procedure Gerarboletim(Items: Tboletins);
    procedure GerarreceitaIngressos(Items: TreceitaIngressoss);
    procedure GeraroutrasReceitas(Items: ToutrasReceitass);
    procedure GerarreceitaTotal(Item: TreceitaTotal);
    procedure GerarinfoProc(Items: TinfoProcs);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property ideEstabs: TideEstabs read FideEstabs;
  end;

implementation

uses
  pcnAuxiliar, ACBrUtil, pcnConversao, DateUtils;


{ TR3010 }

procedure TR3010.AfterConstruction;
begin
  inherited;
  SetSchema(rsevtEspDesportivo);
  FideEstabs := TideEstabs.Create;
end;

procedure TR3010.BeforeDestruction;
begin
  inherited;
  FideEstabs.Free;
end;

procedure TR3010.GerarEventoXML;
begin
  GerarinfoideEstab(Self.FideEstabs);
end;

procedure TR3010.GerarinfoideEstab(Items: TideEstabs);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('ideEstab');
      Gerador.wCampo(tcInt, '', 'tpInscEstab',  0, 0, 1, Ord( tpInscEstab ));
      Gerador.wCampo(tcStr, '', 'nrInscEstab',  0, 0, 1, nrInscEstab);
      Gerarboletim(boletins);
      GerarreceitaTotal(receitaTotal);
      Gerador.wGrupo('/ideEstab');
    end;
end;

procedure TR3010.Gerarboletim(Items: Tboletins);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('boletim');
      Gerador.wCampo(tcStr, '', 'nrBoletim',       0, 0, 1, nrBoletim);
      Gerador.wCampo(tcInt, '', 'tpCompeticao',    0, 0, 1, Ord( tpCompeticao ));
      Gerador.wCampo(tcInt, '', 'categEvento',     0, 0, 1, Ord( categEvento ));
      Gerador.wCampo(tcStr, '', 'modDesportiva',   0, 0, 1, modDesportiva);
      Gerador.wCampo(tcStr, '', 'nomeCompeticao',  0, 0, 1, nomeCompeticao);
      Gerador.wCampo(tcStr, '', 'cnpjMandante',    0, 0, 1, cnpjMandante);
      Gerador.wCampo(tcStr, '', 'cnpjVisitante',   0, 0, 0, cnpjVisitante);
      Gerador.wCampo(tcStr, '', 'nomeVisitante',   0, 0, 0, nomeVisitante);
      Gerador.wCampo(tcStr, '', 'pracaDesportiva', 0, 0, 1, pracaDesportiva);
      Gerador.wCampo(tcStr, '', 'codMunic',        0, 0, 0, codMunic);
      Gerador.wCampo(tcStr, '', 'uf',              0, 0, 1, uf);
      Gerador.wCampo(tcInt, '', 'qtdePagantes',    0, 0, 1, qtdePagantes);
      Gerador.wCampo(tcInt, '', 'qtdeNaoPagantes', 0, 0, 1, qtdeNaoPagantes);
      GerarreceitaIngressos(receitaIngressoss);
      GeraroutrasReceitas(outrasReceitass);
      Gerador.wGrupo('/boletim');
    end;
end;

procedure TR3010.GerarreceitaIngressos(Items: TreceitaIngressoss);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('receitaIngressos');
      Gerador.wCampo(tcInt, '', 'tpIngresso',       0, 0, 1, Ord( tpIngresso ));
      Gerador.wCampo(tcStr, '', 'descIngr',         0, 0, 1, descIngr);
      Gerador.wCampo(tcInt, '', 'qtdeIngrVenda',    0, 0, 1, qtdeIngrVenda);
      Gerador.wCampo(tcInt, '', 'qtdeIngrVendidos', 0, 0, 1, qtdeIngrVendidos);
      Gerador.wCampo(tcInt, '', 'qtdeIngrDev',      0, 0, 1, qtdeIngrDev);
      Gerador.wCampo(tcDe2, '', 'precoIndiv',       0, 0, 1, precoIndiv);
      Gerador.wCampo(tcDe2, '', 'vlrTotal',         0, 0, 1, vlrTotal);
      Gerador.wGrupo('/receitaIngressos');
    end;
end;

procedure TR3010.GeraroutrasReceitas(Items: ToutrasReceitass);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('outrasReceitas');
      Gerador.wCampo(tcInt, '', 'tpReceita',   0, 0, 1, Ord( tpReceita ));
      Gerador.wCampo(tcDe2, '', 'vlrReceita',  0, 0, 1, vlrReceita);
      Gerador.wCampo(tcStr, '', 'descReceita', 0, 0, 1, descReceita);
      Gerador.wGrupo('/outrasReceitas');
    end;
end;

procedure TR3010.GerarreceitaTotal(Item: TreceitaTotal);
begin
  Gerador.wGrupo('receitaTotal');
  Gerador.wCampo(tcDe2, '', 'vlrReceitaTotal',  0, 0, 1, Item.vlrReceitaTotal);
  Gerador.wCampo(tcDe2, '', 'vlrCP',            0, 0, 1, Item.vlrCP);
  Gerador.wCampo(tcDe2, '', 'vlrCPSuspTotal',   0, 0, 0, Item.vlrCPSuspTotal);
  Gerador.wCampo(tcDe2, '', 'vlrReceitaClubes', 0, 0, 1, Item.vlrReceitaClubes);
  Gerador.wCampo(tcDe2, '', 'vlrRetParc',       0, 0, 1, Item.vlrRetParc);
  GerarinfoProc(item.infoProcs);
  Gerador.wGrupo('/receitaTotal');
end;

procedure TR3010.GerarinfoProc(Items: TinfoProcs);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('infoProc');
      Gerador.wCampo(tcInt, '', 'tpProc',    0, 0, 1, Ord( tpProc ));
      Gerador.wCampo(tcStr, '', 'nrProc',    0, 0, 1, nrProc);
      Gerador.wCampo(tcStr, '', 'codSusp',   0, 0, 0, codSusp);
      Gerador.wCampo(tcDe2, '', 'vlrCPSusp', 0, 0, 1, vlrCPSusp);
      Gerador.wGrupo('/infoProc');
    end;
end;

end.
