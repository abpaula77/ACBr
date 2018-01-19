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
|* 24/10/2017: Renato Rubinho
|*  - Compatibilizado Fonte com Delphi 7
*******************************************************************************}

unit ACBrReinfR1000;

interface

uses Classes, Sysutils, pcnGerador, pcnConversaoReinf, ACBrReinfClasses, ACBrReinfEventosBase,
  ACBrReinfR1000_Class;

type

  TR1000 = class(TEventoReinf)
  private
    FinfoContri: TinfoContri;
  protected
    procedure GerarEventoXML; override;
    procedure GerarInfoCadastro;
    procedure GerarContato;
    procedure GerarSoftwareHouse;
    procedure GerarInfoEFR;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property infoContri: TinfoContri read FinfoContri;
  end;

implementation

{ TR1000 }

uses pcnAuxiliar, ACBrUtil, ACBrReinfUtils, pcnConversao,
  DateUtils;

procedure TR1000.AfterConstruction;
begin
  inherited;
  SetSchema(rsevtInfoContri);
  FinfoContri := TinfoContri.Create;
end;

procedure TR1000.BeforeDestruction;
begin
  inherited;
  FinfoContri.Free;
end;

procedure TR1000.GerarContato;
begin
  Gerador.wGrupo('contato');
    Gerador.wCampo(tcStr, '', 'nmCtt', 0, 0, 0, Self.infoContri.InfoCadastro.Contato.NmCtt);
    Gerador.wCampo(tcStr, '', 'cpfCtt', 0, 0, 0, Self.infoContri.infoCadastro.Contato.CpfCtt);

    if (Self.infoContri.infoCadastro.Contato.FoneFixo <> '') then
      Gerador.wCampo(tcStr, '', 'foneFixo', 0, 0, 0, Self.infoContri.infoCadastro.Contato.FoneFixo);

    if (Self.infoContri.infoCadastro.Contato.FoneCel <> '') then
      Gerador.wCampo(tcStr, '', 'foneCel', 0, 0, 0, Self.infoContri.infoCadastro.Contato.FoneCel);

    if (Self.infoContri.infoCadastro.Contato.email <> '') then
      Gerador.wCampo(tcStr, '', 'email', 0, 0, 0, Self.infoContri.infoCadastro.Contato.email);
  Gerador.wGrupo('/contato');
end;

procedure TR1000.GerarEventoXML;
begin
  Gerador.wGrupo('infoContri');
    GerarModoAbertura(Self.TipoOperacao);
    GerarIdePeriodo(Self.infoContri.idePeriodo);
    if (Self.TipoOperacao <> toExclusao) then
      GerarInfoCadastro;
    if (Self.TipoOperacao = toAlteracao) and (Self.NovaValidade.IniValid <> EmptyStr) then
      GerarIdePeriodo(novaValidade,'novaValidade');
    GerarModoFechamento(Self.TipoOperacao);
  Gerador.wGrupo('/infoContri');
end;

procedure TR1000.GerarInfoCadastro;
begin
  Gerador.wGrupo('infoCadastro');
    Gerador.wCampo(tcStr, '', 'classTrib', 0, 0, 0, Self.infoContri.infoCadastro.ClassTrib);
    Gerador.wCampo(tcStr, '', 'indEscrituracao', 0, 0, 0, ord(Self.infoContri.infoCadastro.indEscrituracao));
    Gerador.wCampo(tcStr, '', 'indDesoneracao', 0, 0, 0, ord(Self.infoContri.infoCadastro.indDesoneracao));
    Gerador.wCampo(tcStr, '', 'indAcordoIsenMulta', 0, 0, 0, ord(Self.infoContri.infoCadastro.indAcordoIsenMulta));
    Gerador.wCampo(tcStr, '', 'indSitPJ', 0, 0, 0, Self.infoContri.infoCadastro.indSitPJ);
    GerarContato;
    GerarSoftwareHouse;
    GerarInfoEFR;
  Gerador.wGrupo('/infoCadastro');
end;

procedure TR1000.GerarInfoEFR;
begin
  if (infoContri.infoCadastro.infoEFR.cnpjEFR <> EmptyStr) then
  begin
    Gerador.wGrupo('infoEFR');
      Gerador.wCampo(tcStr, '', 'ideEFR', 1, 1, 0, eSSimNaoToStr(infoContri.infoCadastro.infoEFR.ideEFR));
      Gerador.wCampo(tcStr, '', 'cnpjEFR', 0, 1, 0, infoContri.infoCadastro.infoEFR.cnpjEFR);
    Gerador.wGrupo('/infoEFR');
  end;
end;

procedure TR1000.GerarSoftwareHouse;
begin
  Gerador.wGrupo('softHouse');
    Gerador.wCampo(tcStr, '', 'cnpjSoftHouse', 0, 0, 0, infoContri.infoCadastro.SoftwareHouse.CnpjSoftHouse);
    Gerador.wCampo(tcStr, '', 'nmRazao', 0, 0, 0, infoContri.infoCadastro.SoftwareHouse.NmRazao);
    Gerador.wCampo(tcStr, '', 'nmCont', 0, 0, 0, infoContri.infoCadastro.SoftwareHouse.NmCont);
    Gerador.wCampo(tcStr, '', 'telefone', 0, 0, 0, infoContri.infoCadastro.SoftwareHouse.Telefone);
    if (infoContri.infoCadastro.SoftwareHouse.email <> '') then
      Gerador.wCampo(tcStr, '', 'email', 0, 0, 0,  infoContri.infoCadastro.SoftwareHouse.email);
  Gerador.wGrupo('/softHouse');
end;

end.
