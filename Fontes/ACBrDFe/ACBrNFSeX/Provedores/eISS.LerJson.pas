{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
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
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit eISS.LerJson;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrUtil.Base, ACBrUtil.Strings,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass,
  ACBrNFSeXConversao, ACBrNFSeXLerXml, ACBrJSON;

type
  { Provedor com layout pr�prio }
  { TNFSeR_eISS }

  TNFSeR_eISS = class(TNFSeRClass)
  protected
    procedure LerNota(aJson: TACBrJSONObject; FRps: Boolean);
    procedure LerSituacaoNfse(aJson: TACBrJSONObject);
    procedure LerIdentificacaoPrestador(aJson: TACBrJSONObject);
    procedure LerPrestador(aJson: TACBrJSONObject);
    procedure LerTomador(aJson: TACBrJSONObject);
    procedure LerEndereco(aJson: TACBrJSONObject; aEndereco: TEndereco);
    procedure LerContato(aJson: TACBrJSONObject; aContato: TContato);
    procedure LerRps(aJson: TACBrJSONObject);
    procedure LerServicos(aJson: TACBrJSONObject);

  public
    function LerXml: Boolean; override;
    function LerJsonNfse(const ArquivoRetorno: String): Boolean;
    function LerJsonRps(const ArquivoRetorno: String): Boolean;
  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o Json do provedor:
//     eISS
//==============================================================================

{ TNFSeR_eISS }

function TNFSeR_eISS.LerXml: Boolean;
begin
  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo Json n�o carregado.');

  if (Pos('DadosNfse', Arquivo) > 0) then
    Result := LerJsonNfse(TiraAcentos(Arquivo))
  else
    Result := LerJsonRps(TiraAcentos(Arquivo));
end;

function TNFSeR_eISS.LerJsonNfse(const ArquivoRetorno: String): Boolean;
var
  jsRet: TACBrJSONObject;
begin
  Result := False;
  tpXML := txmlNFSe;

  try
    jsRet := TACBrJSONObject.Parse(String(ArquivoRetorno));

    if Assigned(jsRet.AsJSONObject['DadosNfse']) then
    begin
      LerNota(jsRet.AsJSONObject['DadosNfse'], False);
      LerPrestador(jsRet.AsJSONObject['DadosNfse']);
      LerTomador(jsRet.AsJSONObject['DadosNfse']);
      LerRps(jsRet.AsJSONObject['DadosNfse']);
      LerServicos(jsRet.AsJSONObject['DadosNfse']);

      Result := True;
    end;
  finally
    jsRet.Free;
  end;
end;

function TNFSeR_eISS.LerJsonRps(const ArquivoRetorno: String): Boolean;
var
  jsRet: TACBrJSONObject;
begin
  Result := False;
  tpXML := txmlRPS;

  try
    jsRet := TACBrJSONObject.Parse(String(ArquivoRetorno));

    if Assigned(jsRet.AsJSONObject['DadosNota']) then
    begin
      LerNota(jsRet.AsJSONObject['DadosNota'], True);
      LerIdentificacaoPrestador(jsRet.AsJSONObject['DadosNota']);
      LerTomador(jsRet.AsJSONObject['DadosNota']);
      LerRps(jsRet.AsJSONObject['DadosNota']);
      LerServicos(jsRet.AsJSONObject['DadosNota']);

      Result := True;
    end;
  finally
    jsRet.Free;
  end;
end;

procedure TNFSeR_eISS.LerRps(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Rps'];

  if Assigned(jsAux) then
  begin
    NFSe.DataEmissaoRps := jsAux.AsISODate['DataEmissao'];

    with NFSe.IdentificacaoRps do
    begin
      Numero := jsAux.AsString['Numero'];
      Serie := jsAux.AsString['Serie'];
    end;
  end;
end;

procedure TNFSeR_eISS.LerNota(aJson: TACBrJSONObject; FRps: Boolean);
var
  jsAux: TACBrJSONObject;
  OK: Boolean;
begin
  if Assigned(aJson) then
  begin
    with NFSe do
    begin
      Servico.CodigoMunicipio := aJson.AsString['MunicipioPrestacao'];

      if (FRps) then
      begin
        NaturezaOperacao := StrToNaturezaOperacao(OK, aJson.AsString['NaturezaOperacao']);
        jsAux := aJson.AsJSONObject['Atividade'];

        if Assigned(jsAux) then
        begin
          with Servico do
          begin
            CodigoTributacaoMunicipio := jsAux.AsString['Codigo'];
            CodigoCnae := jsAux.AsString['CodigoCnae'];
            ItemListaServico := jsAux.AsString['CodigoLc116'];
          end;
        end;
      end
      else
      begin
        Numero := aJson.AsString['NumeroNfse'];
        CodigoVerificacao := aJson.AsString['CodigoValidacao'];
        Link := aJson.AsString['LinkNfse'];
        Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);

        jsAux := aJson.AsJSONObject['Rps'];

        if Assigned(jsAux) then
          SeriePrestacao := jsAux.AsString['Serie'];

        DataEmissao := aJson.AsISODateTime['DataEmissao'];
        Competencia := aJson.AsISODate['Competencia'];

        LerSituacaoNfse(aJson);
      end;

      OutrasInformacoes := aJson.AsString['Observacoes'];
      OutrasInformacoes := StringReplace(OutrasInformacoes, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

      jsAux := aJson.AsJSONObject['Valores'];

      if Assigned(jsAux) then
      begin
        with Servico.Valores do
        begin
          if (aJson.AsString['IssRetido'] = 'N') then
            IssRetido := stNormal
          else
            IssRetido := stRetencao;

          ValorServicos := jsAux.AsFloat['ValorServicos'];
          ValorDeducoes := jsAux.AsFloat['ValorDeducoes'];
          ValorPis := jsAux.AsFloat['ValorPis'];
          ValorCofins := jsAux.AsFloat['ValorCofins'];
          ValorInss := jsAux.AsFloat['ValorInss'];
          ValorIr := jsAux.AsFloat['ValorIr'];
          ValorCsll := jsAux.AsFloat['ValorCsll'];
          OutrasRetencoes := jsAux.AsFloat['OutrasRetencoes'];
          DescontoIncondicionado := jsAux.AsFloat['DescontoIncondicionado'];
          DescontoCondicionado := jsAux.AsFloat['DescontoCondicionado'];
          BaseCalculo := jsAux.AsFloat['BaseCalculo'];
          Aliquota := jsAux.AsFloat['Aliquota'];
          ValorIss := jsAux.AsFloat['ValorIss'];
          ValorTotalTributos := jsAux.AsFloat['ValorTotalTributos'];
          ValorCredito := jsAux.AsFloat['ValorCredito'];

          RetencoesFederais := ValorPis + ValorCofins + ValorInss + ValorIr + ValorCsll;

          ValorLiquidoNfse := ValorServicos -
                              (RetencoesFederais + ValorDeducoes +
                               DescontoCondicionado +
                               DescontoIncondicionado + ValorIssRetido);

          ValorTotalNotaFiscal := ValorServicos - DescontoCondicionado -
                                  DescontoIncondicionado;
        end;
      end;
    end;
  end;
end;

procedure TNFSeR_eISS.LerSituacaoNfse(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Cancelamento'];

  if Assigned(jsAux) then
  begin
    NFSe.Situacao := StrToIntDef(aJson.AsString['SituacaoNfse'], 0);

    case NFSe.Situacao of
      -2:
        begin
          NFSe.SituacaoNfse := snCancelado;
          NFSe.MotivoCancelamento := aJson.AsString['Motivo'];
        end;
      -8: NFSe.SituacaoNfse := snNormal;
    end;
  end;
end;

procedure TNFSeR_eISS.LerIdentificacaoPrestador(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Prestador'];

  if Assigned(jsAux) then
  begin
    with NFSe.Prestador.IdentificacaoPrestador do
      InscricaoMunicipal := jsAux.AsString['InscricaoMunicipal'];
  end;
end;

procedure TNFSeR_eISS.LerPrestador(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Prestador'];

  if Assigned(jsAux) then
  begin
    with NFSe.Prestador do
    begin
      RazaoSocial := jsAux.AsString['RazaoSocial'];
      NomeFantasia := jsAux.AsString['NomeFantasia'];

      with IdentificacaoPrestador do
      begin
        CpfCnpj := OnlyNumber(jsAux.AsString['Cnpj']);
        CpfCnpj := PadLeft(CpfCnpj, 14, '0');
        InscricaoMunicipal := jsAux.AsString['InscricaoMunicipal'];
      end;

      LerEndereco(jsAux, Endereco);
      LerContato(jsAux, Contato);
    end;
  end;
end;

procedure TNFSeR_eISS.LerTomador(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
  aValor: string;
begin
  jsAux := aJson.AsJSONObject['Tomador'];

  if Assigned(jsAux) then
  begin
    with NFSe.Tomador do
    begin
      RazaoSocial := jsAux.AsString['RazaoSocial'];
      NomeFantasia := jsAux.AsString['NomeFantasia'];

      with IdentificacaoTomador do
      begin
        CpfCnpj := OnlyNumber(jsAux.AsString['NrDocumento']);
        aValor  := jsAux.AsString['TipoPessoa'];

        if ((aValor = 'J') or (aValor = '2')) then
        begin
          CpfCnpj := PadLeft(CpfCnpj, 14, '0');
        end
        else
        begin
          CpfCnpj := PadLeft(CpfCnpj, 11, '0');
          Tipo := tpPF;
        end;
      end;

      LerEndereco(jsAux, Endereco);
      LerContato(jsAux, Contato);

      if Endereco.CodigoMunicipio = NFSe.Prestador.Endereco.CodigoMunicipio then
        IdentificacaoTomador.Tipo := tpPJdoMunicipio
      else
        IdentificacaoTomador.Tipo := tpPJforaMunicipio;
    end;
  end;
end;

procedure TNFSeR_eISS.LerEndereco(aJson: TACBrJSONObject; aEndereco: TEndereco);
var
  jsAux: TACBrJSONObject;
  xUF: string;
begin
  jsAux := aJson.AsJSONObject['Endereco'];

  if Assigned(jsAux) then
  begin
    with aEndereco do
    begin
      Endereco := jsAux.AsString['Logradouro'];
      Numero := jsAux.AsString['Numero'];
      Complemento := jsAux.AsString['Complemento'];
      Bairro := jsAux.AsString['Bairro'];

      CodigoMunicipio := jsAux.AsString['Municipio'];

      if length(CodigoMunicipio) < 7 then
        CodigoMunicipio := Copy(CodigoMunicipio, 1, 2) +
            FormatFloat('00000', StrToIntDef(Copy(CodigoMunicipio, 3, 5), 0));

      xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;

      CEP := jsAux.AsString['Cep'];
    end;
  end;
end;

procedure TNFSeR_eISS.LerContato(aJson: TACBrJSONObject; aContato: TContato);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Contato'];

  if Assigned(jsAux) then
  begin
    with aContato do
    begin
      Telefone := jsAux.AsString['Telefone'];
      Email := jsAux.AsString['Email'];
    end;
  end;
end;

procedure TNFSeR_eISS.LerServicos(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
  jsArr: TACBrJSONArray;
  i: Integer;
begin
  jsArr := aJson.AsJSONArray['Servicos'];

  if Assigned(jsArr) then
  begin
    for i := 0 to jsArr.Count - 1 do
    begin
      jsAux := jsArr.ItemAsJSONObject[i];

      NFSe.Servico.ItemServico.New;
      with NFSe.Servico.ItemServico[i] do
      begin
        Unidade := jsAux.AsString['Unidade'];
        Descricao := jsAux.AsString['Descricao'];
        Descricao := StringReplace(Descricao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);
        Quantidade := jsAux.AsFloat['Quantidade'];
        ValorUnitario := jsAux.AsCurrency['ValorUnitario'];
        ValorTotal := ValorUnitario * Quantidade;
      end;
    end;
  end;
end;

end.
