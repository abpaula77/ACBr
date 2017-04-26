{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2013 Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esse arquivo usa a classe  PCN (c) 2009 - Paulo Casagrande                  }
{  PCN - Projeto Cooperar NFe       (Found at URL:  www.projetocooperar.org)   }
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

unit pcnEnviarPagamentoR;

interface uses

  SysUtils, Classes,
  pcnConversao, pcnLeitor, pcnEnviarPagamento;

type

  TEnviarPagamentoR = class(TPersistent)
  private
    FLeitor: TLeitor;
    FEnviarPagamento: TEnviarPagamento;
  public
    constructor Create(AOwner: TEnviarPagamento);
    destructor Destroy; override;
    function LerXml: boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property EnviarPagamento: TEnviarPagamento read FEnviarPagamento write FEnviarPagamento;
  end;

  ////////////////////////////////////////////////////////////////////////////////

implementation

uses ACBrConsts;

{ TCFeR }

constructor TEnviarPagamentoR.Create(AOwner: TEnviarPagamento);
begin
  FLeitor := TLeitor.Create;
  FEnviarPagamento := AOwner;
end;

destructor TEnviarPagamentoR.Destroy;
begin
  FLeitor.Free;
  inherited Destroy;
end;

function TEnviarPagamentoR.LerXml: boolean;
var
  ok: boolean;
begin
  Result := False;
  EnviarPagamento.Clear;
  ok := true;

  if Leitor.rExtrai(1, 'Integrador') <> '' then
  begin
    EnviarPagamento.Identificador        := Leitor.rCampo(tcStr, 'identificador');
    EnviarPagamento.ChaveAcessoValidador := Leitor.rCampo(tcStr, 'chaveAcessoValidador');
    EnviarPagamento.ChaveRequisicao      := Leitor.rCampo(tcStr, 'chaveRequisicao');
    EnviarPagamento.Estabelecimento      := Leitor.rCampo(tcStr, 'Estabelecimento');
    EnviarPagamento.CNPJ                 := Leitor.rCampo(tcStr, 'CNPJ');
    EnviarPagamento.SerialPOS            := Leitor.rCampo(tcStr, 'SerialPOS');
    EnviarPagamento.ValorOperacaoSujeitaICMS := Leitor.rCampo(tcDe2, 'ValorOperacaoSujeitaICMS');
    EnviarPagamento.ValorTotalVenda      := Leitor.rCampo(tcDe2, 'ValorTotalVenda');
  end ;

  Result := True;
end;

end.
