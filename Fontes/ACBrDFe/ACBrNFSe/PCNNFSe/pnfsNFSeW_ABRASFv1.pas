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

unit pnfsNFSeW_ABRASFv1;

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
  { TNFSeW_ABRASFv1 }

  TNFSeW_ABRASFv1 = class(TNFSeWClass)
  private
  protected

    procedure GerarIdentificacaoRPS; override;
    procedure GerarRPSSubstituido; override;

    procedure GerarPrestador; override;
    procedure GerarTomador; override;
    procedure GerarIntermediarioServico; override;

    procedure GerarServicoValores; override;
    procedure GerarListaServicos; override;
    procedure GerarValoresServico; override;

    procedure GerarConstrucaoCivil; override;
    procedure GerarCondicaoPagamento; override;

    procedure GerarXML_ABRASF_V1;

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
{ layout da vers�o 1.xx da ABRASF.                                             }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_ABRASFv1 }

constructor TNFSeW_ABRASFv1.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);

  //  FNFSe := AOwner;
end;

function TNFSeW_ABRASFv1.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

procedure TNFSeW_ABRASFv1.GerarIdentificacaoRPS;
begin
//  inherited;
  Gerador.wGrupoNFSe('IdentificacaoRps');
  Gerador.wCampoNFSe(tcStr, '#1', 'Numero', 01, 15, 1, OnlyNumber(NFSe.IdentificacaoRps.Numero), '');
  Gerador.wCampoNFSe(tcStr, '#2', 'Serie ', 01, 05, 1, NFSe.IdentificacaoRps.Serie, '');
  Gerador.wCampoNFSe(tcStr, '#3', 'Tipo  ', 01, 01, 1, TipoRPSToStr(NFSe.IdentificacaoRps.Tipo), '');
  Gerador.wGrupoNFSe('/IdentificacaoRps');
end;

procedure TNFSeW_ABRASFv1.GerarRPSSubstituido;
begin
//  inherited;
  if NFSe.RpsSubstituido.Numero <> '' then
  begin
    Gerador.wGrupoNFSe('RpsSubstituido');
    Gerador.wCampoNFSe(tcStr, '#10', 'Numero', 01, 15, 1, OnlyNumber(NFSe.RpsSubstituido.Numero), '');
    Gerador.wCampoNFSe(tcStr, '#11', 'Serie ', 01, 05, 1, NFSe.RpsSubstituido.Serie, '');
    Gerador.wCampoNFSe(tcStr, '#12', 'Tipo  ', 01, 01, 1, TipoRPSToStr(NFSe.RpsSubstituido.Tipo), '');
    Gerador.wGrupoNFSe('/RpsSubstituido');
  end;
end;

procedure TNFSeW_ABRASFv1.GerarPrestador;
begin
  Gerador.wGrupoNFSe('Prestador');

  case FProvedor of
    proISSNet: begin
                 Gerador.wGrupoNFSe('CpfCnpj');
                 if length(OnlyNumber(NFSe.Prestador.Cnpj)) <= 11 then
                   Gerador.wCampoNFSe(tcStr, '#34', 'Cpf ', 11, 11, 1, OnlyNumber(NFSe.Prestador.Cnpj), '')
                 else
                   Gerador.wCampoNFSe(tcStr, '#34', 'Cnpj', 14, 14, 1, OnlyNumber(NFSe.Prestador.Cnpj), '');
                 Gerador.wGrupoNFSe('/CpfCnpj');
               end;
  else
    Gerador.wCampoNFSe(tcStr, '#34', 'Cnpj', 14, 14, 1, OnlyNumber(NFSe.Prestador.Cnpj), '');
  end;

  Gerador.wCampoNFSe(tcStr, '#35', 'InscricaoMunicipal', 01, 15, 0, NFSe.Prestador.InscricaoMunicipal, '');

  Gerador.wGrupoNFSe('/Prestador');
end;

procedure TNFSeW_ABRASFv1.GerarTomador;
begin
  if (NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '') or
     (NFSe.Tomador.RazaoSocial <> '') or
     (NFSe.Tomador.Endereco.Endereco <> '') or
     (NFSe.Tomador.Contato.Telefone <> '') or
     (NFSe.Tomador.Contato.Email <>'') then
  begin
    Gerador.wGrupoNFSe('Tomador');
(*
    if (VersaoNFSe = ve100) or
       (FProvedor in [proNFSeBrasil, proEReceita]) then
      Gerador.wGrupoNFSe('Tomador')
    else
      Gerador.wGrupoNFSe('TomadorServico');
*)
    if (NFSe.Tomador.Endereco.UF <> 'EX') then
    begin
      Gerador.wGrupoNFSe('IdentificacaoTomador');
      Gerador.wGrupoNFSe('CpfCnpj');

      if Length(OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)) <= 11 then
        Gerador.wCampoNFSe(tcStr, '#36', 'Cpf ', 11, 11, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), '')
      else
        Gerador.wCampoNFSe(tcStr, '#36', 'Cnpj', 14, 14, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), '');

      Gerador.wGrupoNFSe('/CpfCnpj');
      Gerador.wCampoNFSe(tcStr, '#37', 'InscricaoMunicipal', 01, 15, 0, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '');

      if FProvedor in [proBetha, proSimplISS] then
        Gerador.wCampoNFSe(tcStr, '#38', 'InscricaoEstadual', 01, 20, 0, NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, '');

      Gerador.wGrupoNFSe('/IdentificacaoTomador');
    end;

    Gerador.wCampoNFSe(tcStr, '#38', 'RazaoSocial', 001, 115, 0, NFSe.Tomador.RazaoSocial, '');

    Gerador.wGrupoNFSe('Endereco');
    Gerador.wCampoNFSe(tcStr, '#39', 'Endereco', 001, 125, 0, NFSe.Tomador.Endereco.Endereco, '');
    Gerador.wCampoNFSe(tcStr, '#40', 'Numero  ', 001, 010, 0, NFSe.Tomador.Endereco.Numero, '');

    if FProvedor <> proNFSeBrasil then
      Gerador.wCampoNFSe(tcStr, '#41', 'Complemento', 001, 060, 0, NFSe.Tomador.Endereco.Complemento, '')
    else
      Gerador.wCampoNFSe(tcStr, '#41', 'Complemento', 001, 060, 1, NFSe.Tomador.Endereco.Complemento, '');

    Gerador.wCampoNFSe(tcStr, '#42', 'Bairro', 001, 060, 0, NFSe.Tomador.Endereco.Bairro, '');

    if FProvedor in [proISSNet] then
    begin
      Gerador.wCampoNFSe(tcStr, '#43', 'Cidade', 007, 007, 0, OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio), '');
      Gerador.wCampoNFSe(tcStr, '#44', 'Estado', 002, 002, 0, NFSe.Tomador.Endereco.UF, '');
    end
    else begin
      Gerador.wCampoNFSe(tcStr, '#43', 'CodigoMunicipio', 7, 7, 0, OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio), '');
      Gerador.wCampoNFSe(tcStr, '#44', 'Uf             ', 2, 2, 0, NFSe.Tomador.Endereco.UF, '');
    end;

    Gerador.wCampoNFSe(tcStr, '#45', 'Cep', 008, 008, 0, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');
    Gerador.wGrupoNFSe('/Endereco');

    case FProvedor of
      proNFSeBrasil: begin
                       Gerador.wCampoNFSe(tcStr, '#47', 'Email   ', 01, 80, 1, NFSe.Tomador.Contato.Email, '');
                       Gerador.wCampoNFSe(tcStr, '#46', 'Telefone', 01, 11, 1, OnlyNumber(NFSe.Tomador.Contato.Telefone), '');
                     end;
    else begin
           if (NFSe.Tomador.Contato.Telefone <> '') or (NFSe.Tomador.Contato.Email <> '') then
           begin
             Gerador.wGrupoNFSe('Contato');
             Gerador.wCampoNFSe(tcStr, '#46', 'Telefone', 01, 11, 0, OnlyNumber(NFSe.Tomador.Contato.Telefone), '');
             Gerador.wCampoNFSe(tcStr, '#47', 'Email   ', 01, 80, 0, NFSe.Tomador.Contato.Email, '');
             Gerador.wGrupoNFSe('/Contato');
           end;
         end;
    end;
(*
    if (VersaoNFSe = ve100) or
       (FProvedor in [proNFSeBrasil, proEReceita]) then
      Gerador.wGrupoNFSe('/Tomador')
    else
      Gerador.wGrupoNFSe('/TomadorServico');
*)
    Gerador.wGrupoNFSe('/Tomador');
  end
  else begin
         Gerador.wCampoNFSe(tcStr, '#', 'Tomador', 0, 1, 1, '', '');
(*
         // Gera a TAG vazia quando nenhum dado do tomador for informado.
         if (VersaoNFSe = ve100) or (FProvedor in [proEReceita]) then
           Gerador.wCampoNFSe(tcStr, '#', 'Tomador', 0, 1, 1, '', '')
         else
           Gerador.wCampoNFSe(tcStr, '#', 'TomadorServico', 0, 1, 1, '', '');
*)
  end;
end;

procedure TNFSeW_ABRASFv1.GerarIntermediarioServico;
begin
//  inherited;
  if (NFSe.IntermediarioServico.RazaoSocial <> '') or
     (NFSe.IntermediarioServico.CpfCnpj <> '') then
  begin
    Gerador.wGrupoNFSe('IntermediarioServico');
    Gerador.wCampoNFSe(tcStr, '#48', 'RazaoSocial', 001, 115, 0, NFSe.IntermediarioServico.RazaoSocial, '');
    Gerador.wGrupoNFSe('CpfCnpj');

    if Length(OnlyNumber(NFSe.IntermediarioServico.CpfCnpj)) <= 11 then
      Gerador.wCampoNFSe(tcStr, '#49', 'Cpf ', 11, 11, 1, OnlyNumber(NFSe.IntermediarioServico.CpfCnpj), '')
    else
      Gerador.wCampoNFSe(tcStr, '#49', 'Cnpj', 14, 14, 1, OnlyNumber(NFSe.IntermediarioServico.CpfCnpj), '');

    Gerador.wGrupoNFSe('/CpfCnpj');
    Gerador.wCampoNFSe(tcStr, '#50', 'InscricaoMunicipal', 01, 15, 0, NFSe.IntermediarioServico.InscricaoMunicipal, '');
    Gerador.wGrupoNFSe('/IntermediarioServico');
  end;
end;

procedure TNFSeW_ABRASFv1.GerarServicoValores;
var
  i: Integer;
begin
//  inherited;
  Gerador.wGrupoNFSe('Servico');
  Gerador.wGrupoNFSe('Valores');
  Gerador.wCampoNFSe(tcDe2, '#13', 'ValorServicos', 01, 15, 1, NFSe.Servico.Valores.ValorServicos, '');

  if FProvedor in [proRecife, proPronim, proISSNET, proNFSeBrasil, proGinfes] then
  begin
    Gerador.wCampoNFSe(tcDe2, '#14', 'ValorDeducoes', 01, 15, 1, NFSe.Servico.Valores.ValorDeducoes, '');
    Gerador.wCampoNFSe(tcDe2, '#15', 'ValorPis     ', 01, 15, 1, NFSe.Servico.Valores.ValorPis, '');
    Gerador.wCampoNFSe(tcDe2, '#16', 'ValorCofins  ', 01, 15, 1, NFSe.Servico.Valores.ValorCofins, '');
    Gerador.wCampoNFSe(tcDe2, '#17', 'ValorInss    ', 01, 15, 1, NFSe.Servico.Valores.ValorInss, '');
    Gerador.wCampoNFSe(tcDe2, '#18', 'ValorIr      ', 01, 15, 1, NFSe.Servico.Valores.ValorIr, '');
    Gerador.wCampoNFSe(tcDe2, '#19', 'ValorCsll    ', 01, 15, 1, NFSe.Servico.Valores.ValorCsll, '');
    Gerador.wCampoNFSe(tcStr, '#20', 'IssRetido    ', 01, 01, 1, SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), '');
    Gerador.wCampoNFSe(tcDe2, '#21', 'ValorIss     ', 01, 15, 1, NFSe.Servico.Valores.ValorIss, '');
  end
  else begin
    Gerador.wCampoNFSe(tcDe2, '#14', 'ValorDeducoes', 01, 15, 0, NFSe.Servico.Valores.ValorDeducoes, '');
    Gerador.wCampoNFSe(tcDe2, '#15', 'ValorPis     ', 01, 15, 0, NFSe.Servico.Valores.ValorPis, '');
    Gerador.wCampoNFSe(tcDe2, '#16', 'ValorCofins  ', 01, 15, 0, NFSe.Servico.Valores.ValorCofins, '');
    Gerador.wCampoNFSe(tcDe2, '#17', 'ValorInss    ', 01, 15, 0, NFSe.Servico.Valores.ValorInss, '');
    Gerador.wCampoNFSe(tcDe2, '#18', 'ValorIr      ', 01, 15, 0, NFSe.Servico.Valores.ValorIr, '');
    Gerador.wCampoNFSe(tcDe2, '#19', 'ValorCsll    ', 01, 15, 0, NFSe.Servico.Valores.ValorCsll, '');
    Gerador.wCampoNFSe(tcStr, '#20', 'IssRetido    ', 01, 01, 1, SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), '');
    Gerador.wCampoNFSe(tcDe2, '#21', 'ValorIss     ', 01, 15, 0, NFSe.Servico.Valores.ValorIss, '');
  end;

  if not (FProvedor in [proPronim, proBetha, proGovBr]) then
    Gerador.wCampoNFSe(tcDe2, '#22', 'ValorIssRetido', 01, 15, 0, NFSe.Servico.Valores.ValorIssRetido, '');

  if FProvedor in [proPronim, proNFSeBrasil] then
    Gerador.wCampoNFSe(tcDe2, '#23', 'OutrasRetencoes', 01, 15, 1, NFSe.Servico.Valores.OutrasRetencoes, '')
  else
    Gerador.wCampoNFSe(tcDe2, '#23', 'OutrasRetencoes', 01, 15, 0, NFSe.Servico.Valores.OutrasRetencoes, '');

  if FProvedor <> proNFSeBrasil then
  begin
    if FProvedor = proPronim then
      Gerador.wCampoNFSe(tcDe2, '#24', 'BaseCalculo', 01, 15, 1, NFSe.Servico.Valores.BaseCalculo, '')
    else
      Gerador.wCampoNFSe(tcDe2, '#24', 'BaseCalculo', 01, 15, 0, NFSe.Servico.Valores.BaseCalculo, '');
  end;

  case FProvedor of
    proSimplISS: Gerador.wCampoNFSe(tcDe2, '#25', 'Aliquota', 01, 05, 0, NFSe.Servico.Valores.Aliquota, '');

    proGINFES:   Gerador.wCampoNFSe(tcDe4, '#25', 'Aliquota', 01, 05, 0, (NFSe.Servico.Valores.Aliquota / 100), '');

    proGovBR,
    proPronim,
    proISSNet:   Gerador.wCampoNFSe(tcDe4, '#25', 'Aliquota', 01, 05, 1, NFSe.Servico.Valores.Aliquota, '');

    proNFSEBrasil: Gerador.wCampoNFSe(tcDe2, '#25', 'Aliquota', 01, 05, 1, (NFSe.Servico.Valores.Aliquota * 100), '');

    proRecife:   if NFSe.OptanteSimplesNacional = snSim then
                   Gerador.wCampoNFSe(tcDe2, '#25', 'Aliquota', 01, 05, 0, NFSe.Servico.Valores.Aliquota, '')
                 else
                   Gerador.wCampoNFSe(tcDe2, '#25', 'Aliquota', 01, 05, 1, NFSe.Servico.Valores.Aliquota, '');

  else
    Gerador.wCampoNFSe(tcDe4, '#25', 'Aliquota', 01, 05, 0, NFSe.Servico.Valores.Aliquota, '');
  end;

  if FProvedor <> proNFSEBrasil then
  begin
    Gerador.wCampoNFSe(tcDe2, '#26', 'ValorLiquidoNfse', 01, 15, 0, NFSe.Servico.Valores.ValorLiquidoNfse, '');

    if (FProvedor in [proPronim, proBetha, proGovBr]) then
      Gerador.wCampoNFSe(tcDe2, '#22', 'ValorIssRetido', 01, 15, 0, NFSe.Servico.Valores.ValorIssRetido, '');
  end;

  if FProvedor in [proNFSeBrasil] then
  begin
    Gerador.wCampoNFSe(tcDe2, '#27', 'DescontoIncondicionado', 01, 15, 1, NFSe.Servico.Valores.DescontoIncondicionado, '');
    Gerador.wCampoNFSe(tcDe2, '#28', 'DescontoCondicionado  ', 01, 15, 1, NFSe.Servico.Valores.DescontoCondicionado, '');
  end
  else begin
    Gerador.wCampoNFSe(tcDe2, '#27', 'DescontoIncondicionado', 01, 15, 0, NFSe.Servico.Valores.DescontoIncondicionado, '');
    Gerador.wCampoNFSe(tcDe2, '#28', 'DescontoCondicionado  ', 01, 15, 0, NFSe.Servico.Valores.DescontoCondicionado, '');
  end;

  Gerador.wGrupoNFSe('/Valores');

  if FProvedor <> proNFSeBrasil then
  begin
    if FProvedor in [proISSNet, proWebISS, proIssCuritiba, proAbaco, proRecife, proBetha] then
      Gerador.wCampoNFSe(tcStr, '#29', 'ItemListaServico', 01, 05, 1, OnlyNumber(NFSe.Servico.ItemListaServico), '')
    else
      Gerador.wCampoNFSe(tcStr, '#29', 'ItemListaServico', 01, 05, 1, NFSe.Servico.ItemListaServico, '');
  end;

  if FProvedor = proNFSeBrasil then
  begin
    Gerador.wCampoNFSe(tcStr, '#31', 'CodigoTributacaoMunicipio', 01, 0020, 0, NFSe.Servico.CodigoTributacaoMunicipio, '');
    Gerador.wCampoNFSe(tcStr, '#30', 'CodigoCnae', 01, 0007, 1, SomenteNumeros(NFSe.Servico.CodigoCnae), '');
  end;

  if not (FProvedor in [proPublica, proNFSeBrasil]) then
  begin
    Gerador.wCampoNFSe(tcStr, '#30', 'CodigoCnae', 01, 0007, 0, OnlyNumber(NFSe.Servico.CodigoCnae), '');
    Gerador.wCampoNFSe(tcStr, '#31', 'CodigoTributacaoMunicipio', 01, 0020, 0, NFSe.Servico.CodigoTributacaoMunicipio, '');
  end;

  Gerador.wCampoNFSe(tcStr, '#32', 'Discriminacao', 01, 2000, 1,
                     StringReplace(FNFSe.Servico.Discriminacao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');

  if FProvedor = proISSNet then
    Gerador.wCampoNFSe(tcStr, '#33', 'MunicipioPrestacaoServico', 01, 0007, 1, OnlyNumber(NFSe.Servico.CodigoMunicipio), '')
  else
    Gerador.wCampoNFSe(tcStr, '#33', 'CodigoMunicipio          ', 01, 0007, 1, OnlyNumber(NFSe.Servico.CodigoMunicipio), '');

  if FProvedor = proSimplISS  then
  begin
    for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
    begin
      Gerador.wGrupo('ItensServico');
      Gerador.wCampo(tcStr, '#33a', 'Descricao    ', 01, 100, 1, NFSe.Servico.ItemServico[i].Descricao, '');
      Gerador.wCampo(tcDe2, '#33b', 'Quantidade   ', 01, 015, 1, NFSe.Servico.ItemServico[i].Quantidade, '');
      Gerador.wCampo(tcDe2, '#33c', 'ValorUnitario', 01, 015, 1, NFSe.Servico.ItemServico[i].ValorUnitario, '');
      Gerador.wGrupo('/ItensServico');
    end;
    if NFSe.Servico.ItemServico.Count > 10 then
      Gerador.wAlerta('#33a', 'ItensServico', 'Itens de Servico', ERR_MSG_MAIOR_MAXIMO + '10');
  end;

  Gerador.wGrupoNFSe('/Servico');
end;

procedure TNFSeW_ABRASFv1.GerarListaServicos;
var
  i: Integer;
begin
  if FProvedor <> proSystemPro then
    Gerador.wGrupoNFSe('ListaServicos');

  for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Gerador.wGrupoNFSe('Servico');
    Gerador.wGrupoNFSe('Valores');
    Gerador.wCampoNFSe(tcDe2, '#13', 'ValorServicos         ', 01, 15, 1, NFSe.Servico.ItemServico[i].ValorServicos, '');
    Gerador.wCampoNFSe(tcDe2, '#14', 'ValorDeducoes         ', 01, 15, 1, NFSe.Servico.ItemServico[i].ValorDeducoes, '');
    Gerador.wCampoNFSe(tcDe2, '#21', 'ValorIss              ', 01, 15, 1, NFSe.Servico.ItemServico[i].ValorIss, '');
    Gerador.wCampoNFSe(tcDe2, '#25', 'Aliquota              ', 01, 05, 1, NFSe.Servico.ItemServico[i].Aliquota, '');
    Gerador.wCampoNFSe(tcDe2, '#24', 'BaseCalculo           ', 01, 15, 1, NFSe.Servico.ItemServico[i].BaseCalculo, '');
    Gerador.wCampoNFSe(tcDe2, '#27', 'DescontoIncondicionado', 01, 15, 0, NFSe.Servico.ItemServico[i].DescontoIncondicionado, '');
    Gerador.wCampoNFSe(tcDe2, '#28', 'DescontoCondicionado  ', 01, 15, 0, NFSe.Servico.ItemServico[i].DescontoCondicionado, '');

    if FProvedor=proSystemPro then
    begin
      Gerador.wCampoNFSe(tcDe2, '#15', 'ValorPis     ', 01, 15, 1, NFSe.Servico.ItemServico[i].ValorPis, '');
      Gerador.wCampoNFSe(tcDe2, '#16', 'ValorCofins  ', 01, 15, 1, NFSe.Servico.ItemServico[i].ValorCofins, '');
      Gerador.wCampoNFSe(tcDe2, '#17', 'ValorInss    ', 01, 15, 1, NFSe.Servico.ItemServico[i].ValorInss, '');
      Gerador.wCampoNFSe(tcDe2, '#18', 'ValorIr      ', 01, 15, 1, NFSe.Servico.ItemServico[i].ValorIr, '');
      Gerador.wCampoNFSe(tcDe2, '#19', 'ValorCsll    ', 01, 15, 1, NFSe.Servico.ItemServico[i].ValorCsll, '');
    end;

    Gerador.wGrupoNFSe('/Valores');
    Gerador.wCampoNFSe(tcStr, '#20', 'IssRetido                ', 01, 01,   1, SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), '');
    Gerador.wCampoNFSe(tcStr, '#29', 'ItemListaServico         ', 01, 0005, 1, NFSe.Servico.ItemListaServico, '');
    Gerador.wCampoNFSe(tcStr, '#30', 'CodigoCnae               ', 01, 0007, 0, OnlyNumber(NFSe.Servico.CodigoCnae), '');
    Gerador.wCampoNFSe(tcStr, '#31', 'CodigoTributacaoMunicipio', 01, 0020, 0, OnlyNumber(NFSe.Servico.CodigoTributacaoMunicipio), '');
    Gerador.wCampoNFSe(tcStr, '#32', 'Discriminacao', 01, 2000, 1,
                    StringReplace( NFSe.Servico.ItemServico[i].Discriminacao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');
    Gerador.wCampoNFSe(tcStr, '#33', 'CodigoMunicipio          ', 01, 0007, 1, OnlyNumber(NFSe.Servico.CodigoMunicipio), '');
    Gerador.wCampoNFSe(tcInt, '#34', 'CodigoPais               ', 04, 04,   0, NFSe.Servico.CodigoPais, '');
    Gerador.wCampoNFSe(tcStr, '#35', 'ExigibilidadeISS         ', 01, 01,   1, ExigibilidadeISSToStr(NFSe.Servico.ExigibilidadeISS), '');
    Gerador.wCampoNFSe(tcInt, '#36', 'MunicipioIncidencia      ', 07, 07,   0, NFSe.Servico.MunicipioIncidencia, '');
    Gerador.wCampoNFSe(tcStr, '#37', 'NumeroProcesso           ', 01, 30,   0, NFSe.Servico.NumeroProcesso, '');

    if (NFSe.Servico.Valores.IssRetido <> stNormal) and (FProvedor = proSystemPro) then
      Gerador.wCampoNFSe(tcStr, '#21', 'ResponsavelRetencao', 01, 01, 1, ResponsavelRetencaoToStr(NFSe.Servico.ResponsavelRetencao), '');
    Gerador.wGrupoNFSe('/Servico');
  end;

  if FProvedor <> proSystemPro then
    Gerador.wGrupoNFSe('/ListaServicos');
end;

procedure TNFSeW_ABRASFv1.GerarValoresServico;
begin
//  inherited;
(*
  Gerador.wGrupoNFSe('ValoresServico');
  Gerador.wCampoNFSe(tcDe2, '#15', 'ValorPis        ', 01, 15, 0, NFSe.Servico.Valores.ValorPis, '');
  Gerador.wCampoNFSe(tcDe2, '#16', 'ValorCofins     ', 01, 15, 0, NFSe.Servico.Valores.ValorCofins, '');
  Gerador.wCampoNFSe(tcDe2, '#17', 'ValorInss       ', 01, 15, 0, NFSe.Servico.Valores.ValorInss, '');
  Gerador.wCampoNFSe(tcDe2, '#18', 'ValorIr         ', 01, 15, 0, NFSe.Servico.Valores.ValorIr, '');
  Gerador.wCampoNFSe(tcDe2, '#19', 'ValorCsll       ', 01, 15, 0, NFSe.Servico.Valores.ValorCsll, '');
  Gerador.wCampoNFSe(tcDe2, '#21', 'ValorIss        ', 01, 15, 1, NFSe.Servico.Valores.ValorIss, '');
  Gerador.wCampoNFSe(tcDe2, '#13', 'ValorLiquidoNfse', 01, 15, 1, NFSe.Servico.Valores.ValorLiquidoNfse, '');
  Gerador.wCampoNFSe(tcDe2, '#13', 'ValorServicos   ', 01, 15, 1, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wGrupoNFSe('/ValoresServico');
*)
end;

procedure TNFSeW_ABRASFv1.GerarConstrucaoCivil;
begin
//  inherited;
  if (NFSe.ConstrucaoCivil.CodigoObra <> '') then
  begin
    Gerador.wGrupoNFSe('ConstrucaoCivil');
    Gerador.wCampoNFSe(tcStr, '#51', 'CodigoObra', 01, 15, 1, NFSe.ConstrucaoCivil.CodigoObra, '');
    Gerador.wCampoNFSe(tcStr, '#52', 'Art       ', 01, 15, 1, NFSe.ConstrucaoCivil.Art, '');
    Gerador.wGrupoNFSe('/ConstrucaoCivil');
  end;
end;

procedure TNFSeW_ABRASFv1.GerarCondicaoPagamento;
var
  i: Integer;
begin
  if (NFSe.CondicaoPagamento.QtdParcela > 0) then
  begin
    Gerador.wGrupoNFSe('CondicaoPagamento');
    Gerador.wCampoNFSe(tcStr, '#53', 'Condicao  ', 01, 15, 1, CondicaoToStr(NFSe.CondicaoPagamento.Condicao), '');
    Gerador.wCampoNFSe(tcInt, '#54', 'QtdParcela', 01, 3, 1, NFSe.CondicaoPagamento.QtdParcela, '');
    for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
    begin
      Gerador.wGrupoNFSe('Parcelas');
      Gerador.wCampoNFSe(tcInt, '#55', 'Parcela', 01, 03, 1, NFSe.CondicaoPagamento.Parcelas.Items[i].Parcela, '');
      Gerador.wCampoNFSe(tcDatVcto, '#55', 'DataVencimento', 19, 19, 1, NFSe.CondicaoPagamento.Parcelas.Items[i].DataVencimento, DSC_DVENC);
      Gerador.wCampoNFSe(tcDe2, '#55', 'Valor', 01, 18, 1, NFSe.CondicaoPagamento.Parcelas.Items[i].Valor, '');
      Gerador.wGrupoNFSe('/Parcelas');
    end;
    Gerador.wGrupoNFSe('/CondicaoPagamento');
  end;
end;

function TNFSeW_ABRASFv1.GerarXml: Boolean;
var
  Gerar: Boolean;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;

  if (FProvedor in [pro4R, proActcon, proAgili, proCoplan, proDigifred, profintelISS,
                    proFiorilli, proGoiania, proGovDigital, proISSDigital, proLink3,
                    proProdata, proPVH, proSaatri, proSisPMJP, proSystemPro,
                    proTecnos, proVirtual, proVitoria, proBHISS, proNatal,
                    proProdemge, proPronim, proTinus, proNFSEBrasil]) then
    FDefTipos := FServicoEnviar;

  if (RightStr(FURL, 1) <> '/') and (FDefTipos <> '')
    then FDefTipos := '/' + FDefTipos;

  if Trim(FPrefixo4) <> ''
    then Atributo := ' xmlns:' + StringReplace(Prefixo4, ':', '', []) + '="' + FURL + FDefTipos + '"'
    else Atributo := ' xmlns="' + FURL + FDefTipos + '"';

  if (FProvedor = proISSDigital) and (NFSe.NumeroLote <> '')
    then Atributo := ' Id="' +  (NFSe.IdentificacaoRps.Numero) + '"';

  if (FProvedor in [proBetha]) then
    Gerador.wGrupo('Rps')
  else
    Gerador.wGrupo('Rps' + Atributo);

  case FProvedor of
    proDigifred,
    proFiorilli,
    proISSe,
    proSisPMJP,
    proPVH,
    proMitra:     NFSe.InfID.ID := 'rps' +
                                   OnlyNumber(FNFSe.IdentificacaoRps.Numero) +
                                   FNFSe.IdentificacaoRps.Serie;

    proISSDigital: FNFSe.InfID.ID := 'rps' + ChaveAcesso(FNFSe.Prestador.cUF,
                                                 FNFSe.DataEmissao,
                                                 OnlyNumber(FNFSe.Prestador.Cnpj),
                                                 0, // Serie
                                                 StrToInt(OnlyNumber(FNFSe.IdentificacaoRps.Numero)),
                                                 StrToInt(OnlyNumber(FNFSe.IdentificacaoRps.Numero)));

    proTecnos: FNFSe.InfID.ID := '1' + //Fixo - Lote Sincrono
//                                 FormatDateTime('yyyy', FNFSe.DataEmissao) +
                                 OnlyNumber(FNFSe.Prestador.Cnpj) +
                                 IntToStrZero(StrToIntDef(FNFSe.IdentificacaoRps.Numero, 1), 16);

    proSystemPro: FNFSe.InfID.ID := FNFSe.InfID.ID;

    proRecife: FNFSe.InfID.ID := 'RPS' + OnlyNumber(FNFSe.IdentificacaoRps.Numero);

    proGovDigital: FNFSe.InfID.ID := 'Rps' + OnlyNumber(FNFSe.IdentificacaoRps.Numero);

    proVirtual: FNFSe.InfID.ID := '';

  else
    FNFSe.InfID.ID := OnlyNumber(FNFSe.IdentificacaoRps.Numero) +
                      FNFSe.IdentificacaoRps.Serie;
  end;

  GerarXML_ABRASF_V1;

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

  Gerador.wGrupo('/Rps');

  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TNFSeW_ABRASFv1.GerarXML_ABRASF_V1;
begin
  if (FIdentificador = '') then
    Gerador.wGrupoNFSe('InfRps')
  else
    Gerador.wGrupoNFSe('InfRps ' + FIdentificador + '="' + NFSe.InfID.ID + '"');

  GerarIdentificacaoRPS;

  Gerador.wCampoNFSe(tcDatHor, '#4', 'DataEmissao     ', 19, 19, 1, NFSe.DataEmissao, DSC_DEMI);
  Gerador.wCampoNFSe(tcStr,    '#5', 'NaturezaOperacao', 01, 01, 1, NaturezaOperacaoToStr(NFSe.NaturezaOperacao), '');

  if not (FProvedor in [proPublica, proDBSeller]) then
  begin
    if (NFSe.RegimeEspecialTributacao <> retNenhum) then
      Gerador.wCampoNFSe(tcStr, '#6', 'RegimeEspecialTributacao', 01, 01, 0, RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao), '');
  end;

  Gerador.wCampoNFSe(tcStr, '#7', 'OptanteSimplesNacional', 01, 01, 1, SimNaoToStr(NFSe.OptanteSimplesNacional), '');
  Gerador.wCampoNFSe(tcStr, '#8', 'IncentivadorCultural  ', 01, 01, 1, SimNaoToStr(NFSe.IncentivadorCultural), '');
  Gerador.wCampoNFSe(tcStr, '#9', 'Status                ', 01, 01, 1, StatusRPSToStr(NFSe.Status), '');

  if FProvedor in [proBetha, proFISSLex, proSimplISS] then
    Gerador.wCampoNFSe(tcStr, '#11', 'OutrasInformacoes', 001, 255, 0, NFSe.OutrasInformacoes, '');

  GerarRPSSubstituido;

  GerarServicoValores;
  GerarPrestador;
  GerarTomador;
  GerarIntermediarioServico;
  GerarConstrucaoCivil;
  if (FProvedor = proBetha) then
    GerarCondicaoPagamento;

  Gerador.wGrupoNFSe('/InfRps');
end;

end.
