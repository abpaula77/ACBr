{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 28/08/2017: Leivio Fontenele - leivio@yahoo.com.br
|*  - Implementa��o comunica��o, envelope, status e retorno do componente com webservice.
******************************************************************************}
{$I ACBr.inc}


unit ACBreSocialConfiguracoes;

interface

uses
  Classes, SysUtils, ACBrDFeConfiguracoes, pcnConversao, eSocial_Conversao;

type
  TConfiguracoeseSocial = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConf;
    function GetGeral: TGeralConf;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoeseSocial: TConfiguracoeseSocial); overload;
  published
    property Geral: TGeralConf read GetGeral;
    property Arquivos: TArquivosConf read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
   ACBreSocial, ACBrDFeUtil;


{ TConfiguracoeseSocial }

procedure TConfiguracoeseSocial.Assign(DeConfiguracoeseSocial: TConfiguracoeseSocial);
begin
  Geral.Assign(DeConfiguracoeseSocial.Geral);
  WebServices.Assign(DeConfiguracoeseSocial.WebServices);
  Certificados.Assign(DeConfiguracoeseSocial.Certificados);
  Arquivos.Assign(DeConfiguracoeseSocial.Arquivos);
end;

constructor TConfiguracoeseSocial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WebServices.ResourceName := 'ACBreSocialServices';
end;

procedure TConfiguracoeseSocial.CreateArquivosConf;
begin
  FPArquivos := TArquivosConf.Create(self);
end;

procedure TConfiguracoeseSocial.CreateGeralConf;
begin
  FPGeral := TGeralConf.Create(Self);
end;


function TConfiguracoeseSocial.GetArquivos: TArquivosConf;
begin
  Result := TArquivosConf(FPArquivos);
end;


function TConfiguracoeseSocial.GetGeral: TGeralConf;
begin
  Result := TGeralConf(FPGeral);
end;

end.
