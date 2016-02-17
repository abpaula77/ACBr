{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Praça Anita Costa, 34 - Tatuí - SP - 18270-410                  }
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

    //procedure GerarIdentificacaoRPS; override;
    //procedure GerarRPSSubstituido; override;

    //procedure GerarPrestador; override;
    //procedure GerarTomador; override;
    //procedure GerarIntermediarioServico; override;

    //procedure GerarServicoValores; override;
    //procedure GerarListaServicos; override;
    //procedure GerarValoresServico; override;

    //procedure GerarConstrucaoCivil; override;
    //procedure GerarCondicaoPagamento; override;

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
{ layout do CONAM.                                                         }
{ Sendo assim só será criado uma nova unit para um novo layout.                }
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

{
procedure TNFSeW_CONAM.GerarIdentificacaoRPS;
begin
  Gerador.wCampoNFSe(tcInt,   '', 'nrRps       ', 01, 15, 1, OnlyNumber(NFSe.IdentificacaoRps.Numero), '');
  Gerador.wCampoNFSe(tcStr,   '', 'nrEmissorRps', 01, 01, 1, NFSe.IdentificacaoRps.Serie, '');
  Gerador.wCampoNFSe(tcDatHor,'', 'dtEmissaoRps', 19, 19, 1, NFSe.DataEmissao, DSC_DEMI);
  Gerador.wCampoNFSe(tcStr,   '', 'stRps       ', 01, 01, 1, '1', '');
  Gerador.wCampoNFSe(tcStr,   '', 'tpTributacao', 01, 01, 1, NaturezaOperacaoToStr(NFSe.NaturezaOperacao), '');
  Gerador.wCampoNFSe(tcStr,   '', 'isIssRetido ', 01, 01, 1, SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), '');
end;


procedure TNFSeW_CONAM.GerarRPSSubstituido;
begin
  inherited;

end;

procedure TNFSeW_CONAM.GerarPrestador;
begin
  inherited;

end;

procedure TNFSeW_CONAM.GerarTomador;
var
  sTpDoc: String;
begin
  if (Trim(NFSe.Tomador.IdentificacaoTomador.DocTomadorEstrangeiro) <> '') then
    sTpDoc := '3'  //Est
  else if (Length(OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)) = 14) then
         sTpDoc := '2'  //CNPJ
       else
         sTpDoc := '1'; //CPF

  Gerador.wGrupoNFSe('tomador');

  Gerador.wGrupoNFSe('documento');
  Gerador.wCampoNFSe(tcStr, '', 'nrDocumento           ', 01, 14,  1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), '');
  Gerador.wCampoNFSe(tcStr, '', 'tpDocumento           ', 01, 01,  1, sTpDoc, '');
  Gerador.wCampoNFSe(tcStr, '', 'dsDocumentoEstrangeiro', 00, 20,  1, NFSe.Tomador.IdentificacaoTomador.DocTomadorEstrangeiro, '');
  Gerador.wGrupoNFSe('/documento');

  Gerador.wCampoNFSe(tcStr, '', 'nmTomador          ', 01, 080, 1, NFSe.Tomador.RazaoSocial, '');
  Gerador.wCampoNFSe(tcStr, '', 'dsEmail            ', 00, 080, 1, NFSe.Tomador.Contato.Email, '');
  Gerador.wCampoNFSe(tcStr, '', 'nrInscricaoEstadual', 00, 020, 0, NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, '');
  Gerador.wCampoNFSe(tcStr, '', 'dsEndereco         ', 00, 040, 1, NFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr, '', 'nrEndereco         ', 00, 010, 1, NFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr, '', 'dsComplemento      ', 00, 060, 1, NFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampoNFSe(tcStr, '', 'nmBairro           ', 00, 025, 1, NFSe.Tomador.Endereco.Bairro, '');
  Gerador.wCampoNFSe(tcStr, '', 'nrCidadeIbge       ', 00, 007, 1, NFSe.Tomador.Endereco.CodigoMunicipio, '');
  Gerador.wCampoNFSe(tcStr, '', 'nmUf               ', 00, 002, 1, NFSe.Tomador.Endereco.UF, '');
  Gerador.wCampoNFSe(tcStr, '', 'nmPais             ', 01, 040, 1, NFSe.Tomador.Endereco.xPais, '');
  Gerador.wCampoNFSe(tcStr, '', 'nrCep              ', 00, 015, 1, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');
  Gerador.wCampoNFSe(tcStr, '', 'nrTelefone         ', 00, 020, 1, NFSe.Tomador.Contato.Telefone, '');
  Gerador.wGrupoNFSe('/tomador');
end;

procedure TNFSeW_CONAM.GerarIntermediarioServico;
begin
  inherited;

end;

procedure TNFSeW_CONAM.GerarServicoValores;
begin
  inherited;

end;

procedure TNFSeW_CONAM.GerarListaServicos;
var
  iAux, iSerItem, iSerSubItem: Integer;
begin
  iAux := StrToInt(OnlyNumber(NFSe.Servico.ItemListaServico)); //Ex.: 1402, 901
  if (iAux > 999) then //Ex.: 1402
  begin
    iSerItem    := StrToInt(Copy(IntToStr(iAux), 1, 2)); //14
    iSerSubItem := StrToInt(Copy(IntToStr(iAux), 3, 2)); //2
  end
  else begin //Ex.: 901
    iSerItem    := StrToInt(Copy(IntToStr(iAux), 1, 1)); //9
    iSerSubItem := StrToInt(Copy(IntToStr(iAux), 2, 2)); //1
  end;

  Gerador.wGrupoNFSe('listaServicos');

  Gerador.wGrupoNFSe('servico');
  Gerador.wCampoNFSe(tcStr, '', 'nrServicoItem   ', 01, 02, 1, iSerItem, '');
  Gerador.wCampoNFSe(tcStr, '', 'nrServicoSubItem', 01, 02, 1, iSerSubItem, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlServico       ', 01, 15, 1, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlAliquota      ', 01, 02, 1, NFSe.Servico.Valores.Aliquota, '');

  if (NFSe.Servico.Valores.ValorDeducoes > 0) then
  begin
    Gerador.wGrupoNFSe('deducao');
    Gerador.wCampoNFSe(tcDe2, '', 'vlDeducao             ', 01, 15, 1, NFSe.Servico.Valores.ValorDeducoes, '');
    Gerador.wCampoNFSe(tcStr, '', 'dsJustificativaDeducao', 01,255, 1, NFSe.Servico.Valores.JustificativaDeducao, '');
    Gerador.wGrupoNFSe('/deducao');
  end;

  Gerador.wCampoNFSe(tcDe2, '', 'vlBaseCalculo         ', 01,  15, 1, NFSe.Servico.Valores.BaseCalculo, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlIssServico          ', 01,  15, 1, NFSe.Servico.Valores.ValorIss, '');
  Gerador.wCampoNFSe(tcStr, '', 'dsDiscriminacaoServico', 01,1024, 1, NFSe.Servico.Discriminacao, '');
  Gerador.wGrupoNFSe('/servico');

  Gerador.wGrupoNFSe('/listaServicos');
end;

procedure TNFSeW_CONAM.GerarValoresServico;
begin
  Gerador.wCampoNFSe(tcDe2, '', 'vlTotalRps  ', 01, 15, 1, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlLiquidoRps', 01, 15, 1, NFSe.Servico.Valores.ValorLiquidoNfse, '');

  Gerador.wGrupoNFSe('retencoes');
  Gerador.wCampoNFSe(tcDe2, '', 'vlCofins        ', 01, 15, 1, NFSe.Servico.Valores.ValorCofins, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlCsll          ', 01, 15, 1, NFSe.Servico.Valores.ValorCsll, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlInss          ', 01, 15, 1, NFSe.Servico.Valores.ValorInss, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlIrrf          ', 01, 15, 1, NFSe.Servico.Valores.ValorIr, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlPis           ', 01, 15, 1, NFSe.Servico.Valores.ValorPis, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlIss           ', 01, 15, 1, NFSe.Servico.Valores.ValorIssRetido, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlAliquotaCofins', 01, 02, 1, NFSe.Servico.Valores.AliquotaCofins, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlAliquotaCsll  ', 01, 02, 1, NFSe.Servico.Valores.AliquotaCsll, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlAliquotaInss  ', 01, 02, 1, NFSe.Servico.Valores.AliquotaInss, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlAliquotaIrrf  ', 01, 02, 1, NFSe.Servico.Valores.AliquotaIr, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vlAliquotaPis   ', 01, 02, 1, NFSe.Servico.Valores.AliquotaPis, '');
  Gerador.wGrupoNFSe('/retencoes');
end;

procedure TNFSeW_CONAM.GerarConstrucaoCivil;
begin
  inherited;

end;

procedure TNFSeW_CONAM.GerarCondicaoPagamento;
begin
  inherited;

end;
}

function TNFSeW_CONAM.GerarXml: Boolean;
var
  Gerar: Boolean;
begin
  Gerador.Opcoes.DecimalChar := ',';
  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;

  if (RightStr(FURL, 1) <> '/') and (FDefTipos <> '')
    then FDefTipos := '/' + FDefTipos;

  if Trim(FPrefixo4) <> ''
    then Atributo := ' xmlns:' + StringReplace(Prefixo4, ':', '', []) + '="' + FURL + FDefTipos + '"'
    else Atributo := ' xmlns="' + FURL + FDefTipos + '"';

  FNFSe.InfID.ID := OnlyNumber(FNFSe.IdentificacaoRps.Numero) +
                      FNFSe.IdentificacaoRps.Serie;

  GerarXML_CONAM;

  if FOpcoes.GerarTagAssinatura <> taNunca then
  begin
    Gerar := true;
    if FOpcoes.GerarTagAssinatura = taSomenteSeAssinada then
      Gerar := ((NFSe.signature.DigestValue <> '') and
                (NFSe.signature.SignatureValue <> '') and
                (NFSe.signature.X509Certificate <> ''));
    if FOpcoes.GerarTagAssinatura = taSomenteParaNaoAssinada then
      Gerar := ((NFSe.signature.DigestValue = '') and
                (NFSe.signature.SignatureValue = '') and
                (NFSe.signature.X509Certificate = ''));
    if Gerar then
    begin
      FNFSe.signature.URI := FNFSe.InfID.ID;
      FNFSe.signature.Gerador.Opcoes.IdentarXML := Gerador.Opcoes.IdentarXML;
      FNFSe.signature.GerarXMLNFSe;
      Gerador.ArquivoFormatoXML := Gerador.ArquivoFormatoXML +
                                   FNFSe.signature.Gerador.ArquivoFormatoXML;
    end;
  end;

  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TNFSeW_CONAM.GerarXML_CONAM;
begin
  //GerarIdentificacaoRPS;
  //GerarTomador;
  //GerarListaServicos;
  //GerarValoresServico;
  Gerador.wGrupoNFSe('Reg20Item');
     Gerador.wCampoNFSe(tcStr, '', 'TipoNFS', 01, 03,  1, 'RPS', '');
     Gerador.wCampoNFSe(tcStr, '', 'NumRps', 01, 09,  1, NFSe.IdentificacaoRps.Numero, '');
     if NFSe.IdentificacaoRps.Serie = '' then
         Gerador.wCampoNFSe(tcStr, '', 'SerRps', 01, 03,  1, 'NFS', '')
     else
         Gerador.wCampoNFSe(tcStr, '', 'SerRps', 01, 03,  1, NFSe.IdentificacaoRps.Serie, '');
     Gerador.wCampoNFSe(tcStr, '', 'DtEmi', 01, 10,  1, FormatDateTime('dd/mm/yyyy',NFse.DataEmissaoRps), '');
     if NFSe.Servico.Valores.IssRetido = stNormal then
         Gerador.wCampoNFSe(tcStr, '', 'RetFonte', 01, 03, 1, 'NAO', '')
     else
         Gerador.wCampoNFSe(tcStr, '', 'RetFonte', 01, 03, 1, 'SIM', '');
     Gerador.wCampoNFSe(tcStr, '', 'CodSrv', 01, 05, 1, NFSe.Servico.ItemListaServico, '');
     Gerador.wCampoNFSe(tcStr, '', 'DiscrSrv', 01, 4000, 1,
                     StringReplace( NFSe.Servico.Discriminacao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');
     Gerador.wCampoNFSe(tcStr, '', 'VlNFS'       , 01, 16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.ValorServicos), '');
     Gerador.wCampoNFSe(tcStr, '', 'VlDed'       , 01, 16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.ValorDeducoes), '');
     //Gerador.wCampoNFSe(tcStr, '', 'DiscrDed', 01, 4000, 1,StringReplace( NFSe.Servico.Discriminacao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');
     Gerador.wCampoNFSe(tcStr, '', 'VlBasCalc'   , 01, 16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.BaseCalculo), '');
     Gerador.wCampoNFSe(tcStr, '', 'AlqIss'      , 01, 05, 2, FormatFloat('############0.00', NFSe.Servico.Valores.Aliquota), '');
     Gerador.wCampoNFSe(tcStr, '', 'VlIss'       , 01, 16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.ValorIss), '');
     Gerador.wCampoNFSe(tcStr, '', 'VlIssRet'    , 01, 16, 2, FormatFloat('############0.00', NFSe.Servico.Valores.ValorIssRetido), '');

     Gerador.wCampoNFSe(tcStr, '', 'CpfCnpTom',    01, 14,  1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), '');
     Gerador.wCampoNFSe(tcStr, '', 'RazSocTom',    01, 60, 1, NFSe.Tomador.RazaoSocial, '');
     Gerador.wCampoNFSe(tcStr, '', 'TipoLogtom',   01, 10,  1, NFSe.Tomador.Endereco.TipoLogradouro, '');
     Gerador.wCampoNFSe(tcStr, '', 'LogTom',       01, 60,  1, NFSe.Tomador.Endereco.Endereco, '');
     Gerador.wCampoNFSe(tcStr, '', 'NumEndTom',    01, 10,  1, NFSe.Tomador.Endereco.Numero, '');
     Gerador.wCampoNFSe(tcStr, '', 'ComplEndTom',  01, 60,  0, NFSe.Tomador.Endereco.Complemento, '');
     Gerador.wCampoNFSe(tcStr, '', 'BairroTom',    01, 60,  1, NFSe.Tomador.Endereco.Bairro, '');
     Gerador.wCampoNFSe(tcStr, '', 'MunTom',       01, 60,  1, NFSe.Tomador.Endereco.xMunicipio, '');
     Gerador.wCampoNFSe(tcStr, '', 'SiglaUFTom',   01, 02,  1, NFSe.Tomador.Endereco.UF, '');
     Gerador.wCampoNFSe(tcStr, '', 'CepTom',       01, 08,  1, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');
     Gerador.wCampoNFSe(tcStr, '', 'Telefone',     00, 10, 1, RightStr(OnlyNumber(NFSe.Tomador.Contato.Telefone),8), '');
     Gerador.wCampoNFSe(tcStr, '', 'InscricaoMunicipal', 01, 20,  1, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '');

     //Gerador.wCampoNFSe(tcStr, '', 'TipoLogLocPre',   01, 10,  1, NFSe.Tomador.Endereco.TipoLogradouro, '');
     //Gerador.wCampoNFSe(tcStr, '', 'LogLocPre',       01, 60,  1, NFSe.Tomador.Endereco.Endereco, '');
     //Gerador.wCampoNFSe(tcStr, '', 'NumEndLocPre',    01, 10,  1, NFSe.Tomador.Endereco.Numero, '');
     //Gerador.wCampoNFSe(tcStr, '', 'ComplEndLocPre',  01, 60,  0, NFSe.Tomador.Endereco.Complemento, '');
     //Gerador.wCampoNFSe(tcStr, '', 'BairroLocPre',    01, 60,  1, NFSe.Tomador.Endereco.Bairro, '');
     //Gerador.wCampoNFSe(tcStr, '', 'MunLocPre',       01, 60,  1, NFSe.Tomador.Endereco.xMunicipio, '');
     //Gerador.wCampoNFSe(tcStr, '', 'SiglaUFLocPre',   01, 02,  1, NFSe.Tomador.Endereco.UF, '');
     //Gerador.wCampoNFSe(tcStr, '', 'CepLocPre',       01, 08,  1, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');

     Gerador.wCampoNFSe(tcStr, '', 'Email1', 01, 120,  1, NFSe.Tomador.Contato.Email, '');
     //Gerador.wCampoNFSe(tcStr, '', 'Email2', 01, 120,  1, NFSe.Tomador.Contato.Email, '');
     //Gerador.wCampoNFSe(tcStr, '', 'Email3', 01, 120,  1, NFSe.Tomador.Contato.Email, '');

     //Gerador.wGrupoNFSe('Reg30');
     //    Gerador.wGrupoNFSe('Reg30Item');
     //    Gerador.wGrupoNFSe('/Reg30Item');
     //Gerador.wGrupoNFSe('/Reg30');

  Gerador.wGrupoNFSe('/Reg20Item');
end;

end.
