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

unit ACBrReinfUtils;

interface

uses
  SysUtils, TypInfo, pcnConversaoReinf;

type

  TReinfUtils = class
  public
    class function StrToZero(const AString: string; ATamanho : Integer; AEsquerda: Boolean = true): string;
  end;

function eSSimNaoToStr(AValue: tpSimNao): string;

implementation

function eSSimNaoToStr(AValue: tpSimNao): string;
begin
  if AValue = tpSim then
    Result := 'S'
  else
    Result := 'N';
end;

{ TReinfUtils }

class function TReinfUtils.StrToZero(const AString: string; ATamanho: Integer; AEsquerda: Boolean): string;
var
  Str: string;
begin
  Str := AString;
  while Length(Str) < ATamanho do
  begin
    if AEsquerda then
      Str := '0' + Str
    Else
      Str := Str + '0';
  end;
  Result := Str;
end;

end.

