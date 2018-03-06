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

unit pcnReinfR1070;

interface

uses
  Classes, Sysutils, pcnGerador, pcnConversaoReinf, ACBrReinfEventosBase,
  pcnReinfClasses, pcnReinfR1070_Class;

type

  TR1070 = class(TEventoReinf)
  private
    FinfoProcesso: TinfoProcesso;
  protected
    procedure GerarEventoXML; override;
    procedure GerarInfoSusp;
    procedure GerarDadosProcJud;
    procedure GerarinfoProcesso; virtual;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property infoProcesso: TinfoProcesso read FinfoProcesso write FinfoProcesso;
  end;

implementation

uses
  pcnAuxiliar, ACBrUtil, pcnConversao, DateUtils;

{ TR1070 }

procedure TR1070.AfterConstruction;
begin
  inherited;
  SetSchema(schevtTabProcesso);
  FinfoProcesso := TinfoProcesso.Create;
end;

procedure TR1070.BeforeDestruction;
begin
  inherited;
  FinfoProcesso.Free;
end;

procedure TR1070.GerarEventoXML;
begin
  Gerador.wGrupo('infoProcesso');

  GerarModoAbertura(Self.TipoOperacao);
  GerarinfoProcesso;

  if (Self.TipoOperacao = toAlteracao) and (Self.NovaValidade.IniValid <> EmptyStr) then
    GerarIdePeriodo(novaValidade,'novaValidade');

  GerarModoFechamento(Self.TipoOperacao);

  Gerador.wGrupo('/infoProcesso');
end;

procedure TR1070.GerarinfoProcesso;
begin
  Gerador.wGrupo('ideProcesso');

  Gerador.wCampo(tcStr, '', 'tpProc',   1,  1, 1, TpProcToStr(Self.FinfoProcesso.IdeProcesso.tpProc));
  Gerador.wCampo(tcStr, '', 'nrProc',   1, 21, 1, Self.FinfoProcesso.IdeProcesso.nrProc);
  Gerador.wCampo(tcStr, '', 'iniValid', 7,  7, 1, Self.FinfoProcesso.IdePeriodo.IniValid);
  Gerador.wCampo(tcStr, '', 'fimValid', 7,  7, 0, Self.FinfoProcesso.IdePeriodo.FimValid);

  if ( Self.TipoOperacao <> toExclusao ) then
  begin
    Gerador.wCampo(tcStr, '', 'indAutoria', 1, 1, 1, indAutoriaToStr(FinfoProcesso.IdeProcesso.DadosProcJud.indAutoria));
    GerarInfoSusp;
    GerarDadosProcJud;
  end;

  Gerador.wGrupo('/ideProcesso');
end;

procedure TR1070.GerarInfoSusp;
var
  InfoSusp: TinfoSusp;
  i: Integer;
begin
  for i:=0 to FinfoProcesso.IdeProcesso.infoSusps.Count - 1 do
  begin
    InfoSusp := FinfoProcesso.IdeProcesso.infoSusps.Items[i];

    Gerador.wGrupo('infoSusp');

    if StrToInt64Def(InfoSusp.codSusp, -1) > 0 then
      Gerador.wCampo(tcStr, '', 'codSusp', 14, 14, 0, Poem_Zeros(InfoSusp.codSusp, 14));

    Gerador.wCampo(tcStr, '', 'indSusp',      2,  2, 1, IndSuspToStr(InfoSusp.indSusp));
    Gerador.wCampo(tcDat, '', 'dtDecisao',   10, 10, 1, InfoSusp.dtDecisao);
    Gerador.wCampo(tcStr, '', 'indDeposito',  1,  1, 1, SimNaoToStr(InfoSusp.indDeposito));

    Gerador.wGrupo('/infoSusp');
  end;
end;

procedure TR1070.GerarDadosProcJud;
begin
  Gerador.wGrupo('dadosProcJud');

  Gerador.wCampo(tcStr, '', 'ufVara',   2, 2, 1, FinfoProcesso.IdeProcesso.DadosProcJud.UfVara);
  Gerador.wCampo(tcInt, '', 'codMunic', 7, 7, 1, FinfoProcesso.IdeProcesso.DadosProcJud.codMunic);
  Gerador.wCampo(tcStr, '', 'idVara',   2, 2, 1, Poem_Zeros(FinfoProcesso.IdeProcesso.DadosProcJud.idVara, 2));

  Gerador.wGrupo('/dadosProcJud');
end;

end.
