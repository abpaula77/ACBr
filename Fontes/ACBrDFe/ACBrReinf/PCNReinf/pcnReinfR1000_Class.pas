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

unit pcnReinfR1000_Class;

interface

uses
  Classes, Sysutils, pcnConversaoReinf, Controls, Contnrs, pcnReinfClasses;

type
  TInfoCadastro = class;
  TContato = class;
  TSoftwareHouse = class;
  TinfoEFR = class;

  TinfoContri = class
  private
    FInfoCadastro: TInfoCadastro;
    FidePeriodo: TIdePeriodo;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property IdePeriodo: TIdePeriodo read FidePeriodo write FidePeriodo;
    property InfoCadastro: TInfoCadastro read FInfoCadastro;
  end;

  TInfoCadastro = class
   private
    FClassTrib: string;
    FindEscrituracao: TindEscrituracao;
    FindDesoneracao: TindDesoneracao;
    FindAcordoIsenMulta: TindAcordoIsenMulta;
    FindSitPJ: TindSitPJ;
    FContato: TContato;
    FSoftwareHouse: TSoftwareHouse;
    FinfoEFR: TinfoEFR;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property ClassTrib: string read FClassTrib write FClassTrib;
    property indEscrituracao: TindEscrituracao read FindEscrituracao write FindEscrituracao default ieNaoObrig;
    property indDesoneracao: TindDesoneracao read FindDesoneracao write FindDesoneracao default idNaoAplic;
    property indAcordoIsenMulta: TindAcordoIsenMulta read FindAcordoIsenMulta write FindAcordoIsenMulta default aiSemAcordo;
    property indSitPJ: TindSitPJ read FindSitPJ write FindSitPJ default spNormal;
    property Contato: TContato read FContato;
    property SoftwareHouse: TSoftwareHouse read FSoftwareHouse;
    property infoEFR: TinfoEFR read FinfoEFR;
  end;

  TContato = class(TPersistent)
  private
    FNmCtt: string;
    FCpfCtt: string;
    FFoneFixo: string;
    FFoneCel: string;
    FEmail: string;
  public
    property NmCtt: string read FNmCtt write FNmCtt;
    property CpfCtt: string read FCpfCtt write FCpfCtt;
    property FoneFixo: string read FFoneFixo write FFoneFixo;
    property FoneCel: string read FFoneCel write FFoneCel;
    property Email: string read FEmail write FEmail;
  end;

  TSoftwareHouse = class
   private
    FCnpjSoftHouse: string;
    FNmRazao: string;
    FNmCont: string;
    FTelefone: string;
    Femail: string;
  public
    property CnpjSoftHouse: string read FCnpjSoftHouse write FCnpjSoftHouse;
    property NmRazao: string read FNmRazao write FNmRazao;
    property NmCont: string read FNmCont write FNmCont;
    property Telefone: string read FTelefone write FTelefone;
    property email: string read Femail write Femail;
  end;

  TinfoEFR = class
  private
    FideEFR: TtpSimNao;
    FcnpjEFR: string;
  public
    property ideEFR: TtpSimNao read FideEFR write FideEFR;
    property cnpjEFR: string read FcnpjEFR write FcnpjEFR;
  end;

implementation

{ TinfoContri }

procedure TinfoContri.AfterConstruction;
begin
  inherited;
  FInfoCadastro := TInfoCadastro.Create;
  FidePeriodo := TIdePeriodo.Create;
end;

procedure TinfoContri.BeforeDestruction;
begin
  inherited;
  FInfoCadastro.Free;
  FidePeriodo.Free;
end;

{ TInfoCadastro }

procedure TInfoCadastro.AfterConstruction;
begin
  inherited;
  FContato := TContato.Create;
  FSoftwareHouse := TSoftwareHouse.Create;
  FinfoEFR := TinfoEFR.Create;
end;

procedure TInfoCadastro.BeforeDestruction;
begin
  inherited;
  FContato.Free;
  FSoftwareHouse.Free;
  FinfoEFR.Free;
end;

end.

