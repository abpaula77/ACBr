{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
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

{$I ACBr.inc}

unit pnfsNFSeW_CONAM;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  synacode, ACBrConsts,
  pnfsNFSeW,
  pcnAuxiliar, pcnConversao, pcnGerador,
  pnfsNFSe, pnfsConversao;

type
  { TNFSeW_CONAM }

  TNFSeW_CONAM = class(TNFSeWClass)
  private
  protected

    procedure GerarIdentificacaoRPS;
    procedure GerarListaServicos;
    procedure GerarValoresServico;

    procedure GerarXML_CONAM;

  public
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrUtil;

{==============================================================================}
{ Essa unit tem por finalidade exclusiva de gerar o XML do RPS segundo o       }
{ layout do CONAM.                                                             }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_CONAM }

constructor TNFSeW_CONAM.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);

end;

function TNFSeW_CONAM.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

procedure TNFSeW_CONAM.GerarIdentificacaoRPS;
begin
  Gerador.wCampoNFSe(tcStr, '', 'Ano'    , 01, 04, 0, FormatDateTime('yyyy', FNFSe.DataEmissaoRps) , '');
  Gerador.wCampoNFSe(tcStr, '', 'Mes'    , 01, 02, 0, FormatDateTime('mm', FNFSe.DataEmissaoRps) , '');
  Gerador.wCampoNFSe(tcStr, '', 'CPFCNPJ', 01, 14, 0, FNFSe.Prestador.Cnpj , '');
  Gerador.wCampoNFSe(tcStr, '', 'DTIni'  , 01, 10, 0, FormatDateTime('dd/mm/yyyy', FNFSe.DataEmissaoRps) , '');
  Gerador.wCampoNFSe(tcStr, '', 'DTFin'  , 01, 10, 0, FormatDateTime('dd/mm/yyyy', FNFSe.DataEmissaoRps) , '');

  if FNFSe.OptanteSimplesNacional = snSim then
  begin
    Gerador.wCampoNFSe(tcInt, '', 'TipoTrib'   , 01, 01, 0, 4 , '');
    Gerador.wCampoNFSe(tcStr, '', 'DtAdeSN'    , 01, 10, 0, FormatDateTime('dd/mm/yyyy', NFSe.DataOptanteSimplesNacional) , ''); //data de adesao ao simples nacional
    Gerador.wCampoNFSe(tcStr, '', 'AlqIssSN_IP', 01, 06, 0, FormatFloat('##0.00', NFSe.ValoresNfse.Aliquota) , '');
  end
  else begin
    case FNFSe.Servico.ExigibilidadeISS of
      exiExigivel:                       Gerador.wCampoNFSe(tcInt, '', 'TipoTrib', 001, 1, 0, 1 , '');
      exiNaoIncidencia:                  Gerador.wCampoNFSe(tcInt, '', 'TipoTrib', 001, 1, 0, 2 , '');
      exiIsencao:                        Gerador.wCampoNFSe(tcInt, '', 'TipoTrib', 001, 1, 0, 2 , '');
      exiExportacao:                     Gerador.wCampoNFSe(tcInt, '', 'TipoTrib', 001, 1, 0, 5 , '');
      exiImunidade:                      Gerador.wCampoNFSe(tcInt, '', 'TipoTrib', 001, 1, 0, 2 , '');
      exiSuspensaDecisaoJudicial:        Gerador.wCampoNFSe(tcInt, '', 'TipoTrib', 001, 1, 0, 3 , '');
      exiSuspensaProcessoAdministrativo: Gerador.wCampoNFSe(tcInt, '', 'TipoTrib', 001, 1, 0, 3 , '');
    end;

    Gerador.wCampoNFSe(tcStr, '', 'DtAdeSN'    , 01, 10, 0, '', ''); //data de adesao ao simples nacional
    Gerador.wCampoNFSe(tcStr, '', 'AlqIssSN_IP', 01, 06, 0, '' , '');
  end;

  if FNFSe.RegimeEspecialTributacao = retMicroempresarioIndividual then
    Gerador.wCampoNFSe(tcStr, '', 'AlqIssSN_IP', 001, 6, 0, '' , '');

  Gerador.wCampoNFSe(tcStr, '', 'Versao', 001, 4, 0, '2.00' , '');
end;

procedure TNFSeW_CONAM.GerarListaServicos;
var
  i: Integer;
  CpfCnpj: String;
begin
  Gerador.wGrupoNFSe('Reg20');
  Gerador.wGrupoNFSe('Reg20Item');
  if FNFSe.IdentificacaoRps.Tipo = trRPS then
    Gerador.wCampoNFSe(tcStr, '', 'TipoNFS', 01, 3, 1, 'RPS' , '')
  else
    Gerador.wCampoNFSe(tcStr, '', 'TipoNFS', 01, 3, 1, 'RPC' , '');

  Gerador.wCampoNFSe(tcStr, '', 'NumRps', 01, 9, 1, FNFSe.IdentificacaoRps.Numero , '');

  if NFSe.IdentificacaoRps.Serie = '' then
    Gerador.wCampoNFSe(tcStr, '', 'SerRps', 01, 03, 1, '001', '')
  else
    Gerador.wCampoNFSe(tcStr, '', 'SerRps', 01, 03, 1, NFSe.IdentificacaoRps.Serie, '');

  Gerador.wCampoNFSe(tcStr, '', 'DtEmi', 01, 10, 1, FormatDateTime('dd/mm/yyyy',NFse.DataEmissaoRps), '');

  if NFSe.Servico.Valores.IssRetido = stNormal then
    Gerador.wCampoNFSe(tcStr, '', 'RetFonte', 01, 03, 1, 'NAO', '')
  else
    Gerador.wCampoNFSe(tcStr, '', 'RetFonte', 01, 03, 1, 'SIM', '');

  Gerador.wCampoNFSe(tcStr, '', 'CodSrv'   , 01,   05, 1, NFSe.Servico.ItemListaServico, '');
  Gerador.wCampoNFSe(tcStr, '', 'DiscrSrv' , 01, 4000, 1, StringReplace( NFSe.Servico.Discriminacao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');
  Gerador.wCampoNFSe(tcStr, '', 'VlNFS'    , 01,   16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.ValorServicos), '');
  Gerador.wCampoNFSe(tcStr, '', 'VlDed'    , 01,   16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.ValorDeducoes), '');
  Gerador.wCampoNFSe(tcStr, '', 'DiscrDed' , 01, 4000, 1,StringReplace( NFSe.Servico.Valores.JustificativaDeducao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');
  Gerador.wCampoNFSe(tcStr, '', 'VlBasCalc', 01,   16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.BaseCalculo), '');
  Gerador.wCampoNFSe(tcStr, '', 'AlqIss'   , 01,   05, 2, FormatFloat('############0.00', NFSe.Servico.Valores.Aliquota), '');
  Gerador.wCampoNFSe(tcStr, '', 'VlIss'    , 01,   16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.ValorIss), '');
  Gerador.wCampoNFSe(tcStr, '', 'VlIssRet' , 01,   16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.ValorIssRetido), '');

  CpfCnpj := UpperCase(StringReplace(StringReplace(StringReplace(NFSe.Tomador.IdentificacaoTomador.CpfCnpj, '.', '', [rfReplaceAll]), '-', '', [rfReplaceAll]), '/', '', [rfReplaceAll]));

  Gerador.wCampoNFSe(tcStr, '', 'CpfCnpTom'  , 01, 14, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), '');
  Gerador.wCampoNFSe(tcStr, '', 'RazSocTom'  , 01, 60, 1, NFSe.Tomador.RazaoSocial, '');
  Gerador.wCampoNFSe(tcStr, '', 'TipoLogtom' , 01, 10, 1, NFSe.Tomador.Endereco.TipoLogradouro, '');
  Gerador.wCampoNFSe(tcStr, '', 'LogTom'     , 01, 60, 1, NFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr, '', 'NumEndTom'  , 01, 10, 1, NFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr, '', 'ComplEndTom', 01, 60, 0, NFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampoNFSe(tcStr, '', 'BairroTom'  , 01, 60, 1, NFSe.Tomador.Endereco.Bairro, '');

  if CpfCnpj='CONSUMIDOR'  then
   begin
    Gerador.wCampoNFSe(tcStr, '', 'MunTom'    , 01, 60, 1, NFSe.PrestadorServico.Endereco.xMunicipio, '');
    Gerador.wCampoNFSe(tcStr, '', 'SiglaUFTom', 01, 02, 1, NFSe.PrestadorServico.Endereco.UF, '');
   end
  else
   begin
    Gerador.wCampoNFSe(tcStr, '', 'MunTom'    , 01, 60, 1, NFSe.Tomador.Endereco.xMunicipio, '');
    Gerador.wCampoNFSe(tcStr, '', 'SiglaUFTom', 01, 02, 1, NFSe.Tomador.Endereco.UF, '');
   end;

  Gerador.wCampoNFSe(tcStr, '', 'CepTom'            , 01, 08, 1, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');
  Gerador.wCampoNFSe(tcStr, '', 'Telefone'          , 00, 10, 1, RightStr(OnlyNumber(NFSe.Tomador.Contato.Telefone),8), '');
  Gerador.wCampoNFSe(tcStr, '', 'InscricaoMunicipal', 01, 20, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '');

  {Todo: por : mauroasl
   Se o local que for prestado o servi�o for no endere�o do tomador, ent�o preencher com os dados do tomador,
  caso contratio, preencher com os dados do prestador do servi�o.
  Exemplo pratico � um estacionamento, quando � solicitado uma nfse de servi�o. Servi�o prestado no prestador.
  }

  Gerador.wCampoNFSe(tcStr, '', 'TipoLogLocPre' , 01, 10, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.TipoLogradouro, NFSe.PrestadorServico.Endereco.TipoLogradouro), '');
  Gerador.wCampoNFSe(tcStr, '', 'LogLocPre'     , 01, 60, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.Endereco, NFSe.PrestadorServico.Endereco.Endereco), '');
  Gerador.wCampoNFSe(tcStr, '', 'NumEndLocPre'  , 01, 10, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.Numero, NFSe.PrestadorServico.Endereco.Numero), '');
  Gerador.wCampoNFSe(tcStr, '', 'ComplEndLocPre', 01, 60, 0, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.Complemento, NFSe.PrestadorServico.Endereco.Complemento), '');
  Gerador.wCampoNFSe(tcStr, '', 'BairroLocPre'  , 01, 60, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.Bairro, NFSe.PrestadorServico.Endereco.Bairro), '');
  Gerador.wCampoNFSe(tcStr, '', 'MunLocPre'     , 01, 60, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.xMunicipio, NFSe.PrestadorServico.Endereco.xMunicipio), '');
  Gerador.wCampoNFSe(tcStr, '', 'SiglaUFLocpre' , 01, 02, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.UF, NFSe.PrestadorServico.Endereco.UF), '');
  Gerador.wCampoNFSe(tcStr, '', 'CepLocPre'     , 01, 08, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, OnlyNumber(NFSe.Tomador.Endereco.CEP), OnlyNumber(NFSe.PrestadorServico.Endereco.CEP)), '');

  Gerador.wCampoNFSe(tcStr, '', 'Email1', 01, 120, 1, NFSe.Tomador.Contato.Email, '');

  for i:= 0 to NFSe.email.Count - 1 do
    Gerador.wCampoNFSe(tcStr, '', 'Email' + IntToStr(i+2), 01, 120,  1, NFSe.email.Items[i].emailCC, '');

  Gerador.wGrupoNFSe('/Reg20Item');
  Gerador.wGrupoNFSe('/Reg20');
end;

procedure TNFSeW_CONAM.GerarValoresServico;
begin
  Gerador.wGrupoNFSe('Reg90');

  Gerador.wCampoNFSe(tcStr, '', 'QtdRegNormal'  , 01, 05, 1, '1', '');
  Gerador.wCampoNFSe(tcStr, '', 'ValorNFS'      , 01, 02, 1, FormatFloat('############0.00', NFSe.Servico.Valores.ValorServicos), '');
  Gerador.wCampoNFSe(tcStr, '', 'ValorISS'      , 01, 02, 1, FormatFloat('############0.00', NFSe.Servico.Valores.ValorIss), '');
  Gerador.wCampoNFSe(tcStr, '', 'ValorDed'      , 01, 02, 1, FormatFloat('############0.00', NFSe.Servico.Valores.ValorDeducoes), '');
  Gerador.wCampoNFSe(tcStr, '', 'ValorIssRetTom', 01, 02, 1, FormatFloat('############0.00', NFSe.Servico.Valores.ValorIssRetido), '');
  Gerador.wCampoNFSe(tcStr, '', 'QtdReg30'      , 01, 05, 1, '0', '');
  Gerador.wCampoNFSe(tcStr, '', 'ValorTributos' , 01, 02, 1, '0,00', '');

  Gerador.wGrupoNFSe('/Reg90');
end;

function TNFSeW_CONAM.GerarXml: Boolean;
begin
  GerarXML_CONAM;

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TNFSeW_CONAM.GerarXML_CONAM;
begin
(*
  Gerador.Opcoes.RetirarEspacos := False;
  Gerador.Opcoes.DecimalChar := ',';
  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;
*)
  Gerador.wGrupoNFSe('SDTRPS');
  GerarIdentificacaoRPS;
  GerarListaServicos;
  GerarValoresServico;
  Gerador.wGrupoNFSe('/SDTRPS');
end;

end.

