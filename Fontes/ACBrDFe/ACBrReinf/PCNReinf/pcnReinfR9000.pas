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

unit pcnReinfR9000;

interface

uses
  Classes, Sysutils, pcnGerador, pcnConversaoReinf, ACBrReinfEventosBase,
  pcnReinfClasses, pcnReinfR9000_Class;

type

  TR9000 = class(TEventoReinf)
  private
    FinfoExclusao: TinfoExclusao;
  protected
    procedure GerarEventoXML; override;
  public
    property infoExclusao: TinfoExclusao read FinfoExclusao;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

uses
  pcnAuxiliar, ACBrUtil, pcnConversao, DateUtils;


{ TR9000 }

procedure TR9000.AfterConstruction;
begin
  inherited;
  SetSchema(schevtExclusao);
  FinfoExclusao := TinfoExclusao.Create;
end;

procedure TR9000.BeforeDestruction;
begin
  inherited;
  FinfoExclusao.Free;
end;

procedure TR9000.GerarEventoXML;
begin
  Gerador.wGrupo('infoExclusao');

  Gerador.wCampo(tcStr, '', 'tpEvento', 6,  6, 1, FinfoExclusao.tpEvento);
  Gerador.wCampo(tcStr, '', 'nrRecEvt', 1, 52, 1, FinfoExclusao.nrRecEvt);
  Gerador.wCampo(tcStr, '', 'perApur',  7, 10, 1, FinfoExclusao.perApur);

  Gerador.wGrupo('/infoExclusao');
end;

end.
