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
|* 24/10/2017: Renato Rubinho
|*  - Compatibilizado Fonte com Delphi 7
*******************************************************************************}

unit pcnReinfR2060;

interface

uses
  Classes, Sysutils, pcnGerador, pcnConversaoReinf,
  pcnReinfR2060_Class, ACBrReinfEventosBase;

type

  TR2060 = class(TEventoReinfRet)
  private
    FinfoCPRB: TinfoCPRB;
  protected
    procedure GerarEventoXML; override;
    procedure GerarinfoCPRB;
    procedure GerarideEstab;
    procedure GerartipoCod(Items: TtipoCods);
    procedure GerartipoAjustes(Items: TtipoAjustes);
    procedure GerarinfoProc(Items: TinfoProcs);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property infoCPRB: TinfoCPRB read FinfoCPRB;
  end;

implementation

uses
  pcnAuxiliar, ACBrUtil, pcnConversao, DateUtils;

{ TR2060 }

procedure TR2060.AfterConstruction;
begin
  inherited;
  SetSchema(schevtCPRB);
  FinfoCPRB := TinfoCPRB.Create;
end;

procedure TR2060.BeforeDestruction;
begin
  inherited;
  FinfoCPRB.Free;
end;

procedure TR2060.GerarEventoXML;
begin
  GerarinfoCPRB;
end;

procedure TR2060.GerarinfoCPRB;
begin
  Gerador.wGrupo('infoCPRB');
  GerarideEstab;
  Gerador.wGrupo('/infoCPRB');
end;

procedure TR2060.GerarideEstab;
begin
  Gerador.wGrupo('ideEstab');
  Gerador.wCampo(tcInt, '', 'tpInscEstab',      0, 0, 1, Self.FinfoCPRB.ideEstab.tpInscEstab);
  Gerador.wCampo(tcStr, '', 'nrInscEstab',      0, 0, 1, Self.FinfoCPRB.ideEstab.nrInscEstab);
  Gerador.wCampo(tcDe2, '', 'vlrRecBrutaTotal', 0, 0, 1, Self.FinfoCPRB.ideEstab.vlrRecBrutaTotal);
  Gerador.wCampo(tcDe2, '', 'vlrCPApurTotal',   0, 0, 1, Self.FinfoCPRB.ideEstab.vlrCPApurTotal);
  Gerador.wCampo(tcDe2, '', 'vlrCPRBSuspTotal', 0, 0, 0, Self.FinfoCPRB.ideEstab.vlrCPRBSuspTotal);
  GerartipoCod(Self.FinfoCPRB.ideEstab.tipoCods);
  GerarinfoProc(Self.FinfoCPRB.ideEstab.infoProcs);
  Gerador.wGrupo('/ideEstab');
end;

procedure TR2060.GerartipoCod(Items: TtipoCods);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('tipoCod');
      Gerador.wCampo(tcStr, '', 'codAtivEcon',     0, 0, 1, codAtivEcon);
      Gerador.wCampo(tcDe2, '', 'vlrRecBrutaAtiv', 0, 0, 1, vlrRecBrutaAtiv);
      Gerador.wCampo(tcDe2, '', 'vlrExcRecBruta',  0, 0, 1, vlrExcRecBruta);
      Gerador.wCampo(tcDe2, '', 'vlrAdicRecBruta', 0, 0, 1, vlrAdicRecBruta);
      Gerador.wCampo(tcDe2, '', 'vlrBcCPRB',       0, 0, 1, vlrBcCPRB);
      Gerador.wCampo(tcDe2, '', 'vlrCPRBapur',     0, 0, 0, vlrCPRBapur);
      GerartipoAjustes(tipoAjustes);
      Gerador.wGrupo('/tipoCod');
    end;
end;

procedure TR2060.GerartipoAjustes(Items: TtipoAjustes);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('tipoAjuste');
      Gerador.wCampo(tcInt, '', 'tpAjuste',   0, 0, 1, ord(tpAjuste));
      Gerador.wCampo(tcInt, '', 'codAjuste',  0, 0, 1, ord(codAjuste));
      Gerador.wCampo(tcDe2, '', 'vlrAjuste',  0, 0, 1, vlrAjuste);
      Gerador.wCampo(tcStr, '', 'descAjuste', 0, 0, 1, descAjuste);
      Gerador.wCampo(tcStr, '', 'dtAjuste',   0, 0, 1, dtAjuste);
      Gerador.wGrupo('/tipoAjuste');
    end;
end;

procedure TR2060.GerarinfoProc(Items: TinfoProcs);
var
  i: Integer;
begin
  for i:=0 to Items.Count - 1 do
    with Items.Items[i] do
    begin
      Gerador.wGrupo('infoProc');
      Gerador.wCampo(tcDe2, '', 'vlrCPRBSusp', 0, 0, 1, vlrCPRBSusp);
      Gerador.wCampo(tcInt, '', 'tpProc',      0, 0, 1, ord(tpProc));
      Gerador.wCampo(tcStr, '', 'nrProc',      0, 0, 1, nrProc);
      Gerador.wCampo(tcStr, '', 'codSusp',     0, 0, 0, codSusp);
      Gerador.wGrupo('/infoProc');
    end;
end;

end.

