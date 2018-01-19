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

unit ACBrReinfR2099;

interface

uses Classes, Sysutils, pcnGerador, pcnConversaoReinf, ACBrReinfEventosBase,
  ACBrReinfClasses, ACBrReinfR2099_Class;

type

  TR2099 = class(TEventoReinfR)
  private
    FideRespInf: TideRespInf;
    FinfoFech: TinfoFech;
  protected
    procedure GerarEventoXML; override;
  public
    property ideRespInf: TideRespInf read FideRespInf;
    property infoFech: TinfoFech read FinfoFech;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

uses pcnAuxiliar, ACBrUtil, ACBrReinfUtils, pcnConversao, DateUtils;

{ TR2099 }

procedure TR2099.AfterConstruction;
begin
  inherited;
  SetSchema(rsevtFechaEvPer);
  FideRespInf := TideRespInf.Create;
  FinfoFech := TinfoFech.Create;
end;

procedure TR2099.BeforeDestruction;
begin
  inherited;
  FideRespInf.Free;
  FinfoFech.Free;
end;

procedure TR2099.GerarEventoXML;
begin
  if (FideRespInf.nmResp <> EmptyStr) and (FideRespInf.cpfResp <> EmptyStr) then
  begin
    Gerador.wGrupo('ideRespInf');
    Gerador.wCampo(tcStr, '', 'nmResp',   0, 0, 1, FideRespInf.nmResp);
    Gerador.wCampo(tcStr, '', 'cpfResp',  0, 0, 1, FideRespInf.cpfResp);
    Gerador.wCampo(tcStr, '', 'telefone', 0, 0, 0, FideRespInf.telefone);
    Gerador.wCampo(tcStr, '', 'email',    0, 0, 0, FideRespInf.email);
    Gerador.wGrupo('/ideRespInf');
  end;

  Gerador.wGrupo('infoFech');
  Gerador.wCampo(tcStr, '', 'evtServTm',     0, 0, 1, eSSimNaoToStr(FinfoFech.evtServTm));
  Gerador.wCampo(tcStr, '', 'evtServPr',     0, 0, 1, eSSimNaoToStr(FinfoFech.evtServPr));
  Gerador.wCampo(tcStr, '', 'evtAssDespRec', 0, 0, 1, eSSimNaoToStr(FinfoFech.evtAssDespRec));
  Gerador.wCampo(tcStr, '', 'evtAssDespRep', 0, 0, 1, eSSimNaoToStr(FinfoFech.evtAssDespRep));
  Gerador.wCampo(tcStr, '', 'evtComProd',    0, 0, 1, eSSimNaoToStr(FinfoFech.evtComProd));
  Gerador.wCampo(tcStr, '', 'evtCPRB',       0, 0, 1, eSSimNaoToStr(FinfoFech.evtCPRB));
  Gerador.wCampo(tcStr, '', 'evtPgtos',      0, 0, 1, eSSimNaoToStr(FinfoFech.evtPgtos));
  Gerador.wCampo(tcStr, '', 'evtServTm',     0, 0, 0, FinfoFech.compSemMovto);
  Gerador.wGrupo('/infoFech');
end;

end.
