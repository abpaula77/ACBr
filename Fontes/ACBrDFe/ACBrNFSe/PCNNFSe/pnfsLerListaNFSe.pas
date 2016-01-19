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

unit pnfsLerListaNFSe;

interface

uses
  SysUtils, Classes, Forms,
  ACBrUtil,
  pcnConversao, pcnLeitor,
  pnfsConversao, pnfsNFSe, pnfsNFSeR;

type

 TLerListaNFSeCollection = class;
 TLerListaNFSeCollectionItem = class;
 TMsgRetornoNFSeCollection = class;
 TMsgRetornoNFSeCollectionItem = class;

 TListaNFSe = class(TPersistent)
  private
    FCompNFSe: TLerListaNFSeCollection;
    FMsgRetorno: TMsgRetornoNFSeCollection;
    procedure SetCompNFSe(Value: TLerListaNFSeCollection);
    procedure SetMsgRetorno(Value: TMsgRetornoNFSeCollection);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property CompNFSe: TLerListaNFSeCollection     read FCompNFSe   write SetCompNFSe;
    property MsgRetorno: TMsgRetornoNFSeCollection read FMsgRetorno write SetMsgRetorno;
  end;

 TLerListaNFSeCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TLerListaNFSeCollectionItem;
    procedure SetItem(Index: Integer; Value: TLerListaNFSeCollectionItem);
  public
    constructor Create(AOwner: TListaNFSe);
    function Add: TLerListaNFSeCollectionItem;
    property Items[Index: Integer]: TLerListaNFSeCollectionItem read GetItem write SetItem; default;
  end;

 TLerListaNFSeCollectionItem = class(TCollectionItem)
  private
    FNFSe: TNFSe;
    FNFSeCancelamento: TConfirmacaoCancelamento;
    FNFSeSubstituicao: TSubstituicaoNFSe;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property NFSe: TNFSe                                read FNFSe             write FNFSe;
    property NFSeCancelamento: TConfirmacaoCancelamento read FNFSeCancelamento write FNFSeCancelamento;
    property NFSeSubstituicao: TSubstituicaoNFSe        read FNFSeSubstituicao write FNFSeSubstituicao;
  end;

 TMsgRetornoNFSeCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TMsgRetornoNFSeCollectionItem;
    procedure SetItem(Index: Integer; Value: TMsgRetornoNFSeCollectionItem);
  public
    constructor Create(AOwner: TListaNFSe);
    function Add: TMsgRetornoNFSeCollectionItem;
    property Items[Index: Integer]: TMsgRetornoNFSeCollectionItem read GetItem write SetItem; default;
  end;

 TMsgRetornoNFSeIdentificacaoRps = class(TPersistent)
  private
    FNumero: String;
    FSerie: String;
    FTipo: TNFSeTipoRps;
  published
    property Numero: String     read FNumero write FNumero;
    property Serie: String      read FSerie  write FSerie;
    property Tipo: TNFSeTipoRps read FTipo   write FTipo;
  end;

 TMsgRetornoNFSeCollectionItem = class(TCollectionItem)
  private
    FIdentificacaoRps: TMsgRetornoNFSeIdentificacaoRps;
    FCodigo: String;
    FMensagem: String;
    FCorrecao: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property IdentificacaoRps: TMsgRetornoNFSeIdentificacaoRps read FIdentificacaoRps write FIdentificacaoRps;
    property Codigo: String   read FCodigo   write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property Correcao: String read FCorrecao write FCorrecao;
  end;

 TRetornoNFSe = class(TPersistent)
  private
    FLeitor: TLeitor;
    FListaNFSe: TListaNFSe;
    FProvedor: TNFSeProvedor;
    FTabServicosExt: Boolean;
    FProtocolo: String;
    FPathIniCidades: String;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor         read FLeitor         write FLeitor;
    property ListaNFSe: TListaNFSe   read FListaNFSe      write FListaNFSe;
    property Provedor: TNFSeProvedor read FProvedor       write FProvedor;
    property TabServicosExt: Boolean read FTabServicosExt write FTabServicosExt;
    property Protocolo: String       read FProtocolo      write FProtocolo;
    property PathIniCidades: String  read FPathIniCidades write FPathIniCidades;
  end;

implementation

{ TListaNFSe }

constructor TListaNFSe.Create;
begin
  FCompNfse   := TLerListaNFSeCollection.Create(Self);
  FMsgRetorno := TMsgRetornoNFSeCollection.Create(Self);
end;

destructor TListaNFSe.Destroy;
begin
  FCompNfse.Free;
  FMsgRetorno.Free;

  inherited;
end;

procedure TListaNFSe.SetCompNFSe(Value: TLerListaNFSeCollection);
begin
  FCompNfse.Assign(Value);
end;

procedure TListaNFSe.SetMsgRetorno(Value: TMsgRetornoNFSeCollection);
begin
  FMsgRetorno.Assign(Value);
end;

{ TLerListaNFSeCollection }

function TLerListaNFSeCollection.Add: TLerListaNFSeCollectionItem;
begin
  Result := TLerListaNFSeCollectionItem(inherited Add);
  Result.create;
end;

constructor TLerListaNFSeCollection.Create(AOwner: TListaNFSe);
begin
  inherited Create(TLerListaNFSeCollectionItem);
end;

function TLerListaNFSeCollection.GetItem(
  Index: Integer): TLerListaNFSeCollectionItem;
begin
  Result := TLerListaNFSeCollectionItem(inherited GetItem(Index));
end;

procedure TLerListaNFSeCollection.SetItem(Index: Integer;
  Value: TLerListaNFSeCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TLerListaNFSeCollectionItem }

constructor TLerListaNFSeCollectionItem.Create;
begin
  FNfse             := TNFSe.Create;
  FNfseCancelamento := TConfirmacaoCancelamento.Create;
  FNfseSubstituicao := TSubstituicaoNfse.Create;
end;

destructor TLerListaNFSeCollectionItem.Destroy;
begin
  FNfse.Free;
  FNfseCancelamento.Free;
  FNfseSubstituicao.Free;

  inherited;
end;

{ TMsgRetornoNFSeCollection }

function TMsgRetornoNFSeCollection.Add: TMsgRetornoNFSeCollectionItem;
begin
  Result := TMsgRetornoNFSeCollectionItem(inherited Add);
  Result.create;
end;

constructor TMsgRetornoNFSeCollection.Create(AOwner: TListaNFSe);
begin
  inherited Create(TMsgRetornoNFSeCollectionItem);
end;

function TMsgRetornoNFSeCollection.GetItem(
  Index: Integer): TMsgRetornoNFSeCollectionItem;
begin
  Result := TMsgRetornoNFSeCollectionItem(inherited GetItem(Index));
end;

procedure TMsgRetornoNFSeCollection.SetItem(Index: Integer;
  Value: TMsgRetornoNFSeCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TMsgRetornoNFSeCollectionItem }

constructor TMsgRetornoNFSeCollectionItem.Create;
begin
  FIdentificacaoRps       := TMsgRetornoNFSeIdentificacaoRps.Create;
  FIdentificacaoRps.FTipo := trRPS;
end;

destructor TMsgRetornoNFSeCollectionItem.Destroy;
begin
  FIdentificacaoRps.Free;

  inherited;
end;

{ TRetornoNFSe }

constructor TRetornoNFSe.Create;
begin
  FLeitor    := TLeitor.Create;
  FListaNfse := TListaNfse.Create;
end;

destructor TRetornoNFSe.Destroy;
begin
  FLeitor.Free;
  FListaNfse.Free;

  inherited;
end;

function TRetornoNFSe.LerXml: Boolean;
var
  NFSe: TNFSe;
  NFSeLida: TNFSeR;
  VersaodoXML: String;
  ProtocoloTemp, NumeroLoteTemp, SituacaoTemp: String;
  DataRecebimentoTemp: TDateTime;
  i, j, Nivel: Integer;
  Nivel1: Boolean;
begin
  Result := True;

  try
    Leitor.Arquivo := RetirarPrefixos(Leitor.Arquivo);
    Leitor.Arquivo := StringReplace(Leitor.Arquivo, ' xmlns=""', '', [rfReplaceAll]);
    Leitor.Arquivo := StringReplace(Leitor.Arquivo, ' xmlns="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"' , '', [rfReplaceAll]);
    VersaodoXML    := VersaoXML(Leitor.Arquivo);
    Leitor.Grupo   := Leitor.Arquivo;

    Nivel1 := (leitor.rExtrai(1, 'GerarNfseResposta') <> '');
    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'GerarNfseResponse') <> '');

    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'RecepcionarLoteRpsResult') <> '');

    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'EnviarLoteRpsSincronoResposta') <> '');

    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'ConsultarLoteRpsResposta') <> '');
    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'ConsultarLoteRpsResult') <> '');

    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'ConsultarNfseRpsResposta') <> '');
    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'ConsultarNfsePorRpsResult') <> '');

    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'ConsultarNfseResposta') <> '');
    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'ConsultarNfseFaixaResposta') <> '');
    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'ConsultarNfseServicoPrestadoResponse') <> '');

    if not Nivel1 then
      Nivel1 := (leitor.rExtrai(1, 'CancelarNfseResult') <> '');

    if Nivel1 then
    begin
      // =======================================================================
      // Extrai a Lista de Notas
      // =======================================================================

      NumeroLoteTemp:= Leitor.rCampo(tcStr, 'NumeroLote');
      if trim(NumeroLoteTemp) = '' then
        NumeroLoteTemp := '0';

      DataRecebimentoTemp:= Leitor.rCampo(tcDatHor, 'DataRecebimento');

      ProtocoloTemp:= Leitor.rCampo(tcStr, 'Protocolo');
      if trim(ProtocoloTemp) = '' then
        ProtocoloTemp := '0';

      SituacaoTemp:= Leitor.rCampo(tcStr, 'Situacao');
      if trim(SituacaoTemp) = '' then
        SituacaoTemp := '4';

      // Ler a Lista de NFSe
      if leitor.rExtrai(2, 'ListaNfse') <> '' then
        Nivel := 3
      else
        Nivel := 2;

      i := 0;
      while (Leitor.rExtrai(Nivel, 'CompNfse', '', i + 1) <> '') or
            (Leitor.rExtrai(Nivel, 'ComplNfse', '', i + 1) <> '') or
            ((Provedor in [proActcon]) and (Leitor.rExtrai(Nivel + 1, 'Nfse', '', i + 1) <> '')) do
      begin
        NFSe := TNFSe.Create;
        NFSeLida := TNFSeR.Create(NFSe);
        try
          NFSeLida.VersaoXML      := VersaodoXML;
          NFSeLida.Provedor       := Provedor;
          NFSeLida.TabServicosExt := TabServicosExt;
          NFSeLida.PathIniCidades := PathIniCidades;

          NFSeLida.Leitor.Arquivo := Leitor.Grupo;

          Result := NFSeLida.LerXml;

          if Result then
          begin
            with ListaNFSe.FCompNFSe.Add do
            begin
              // Armazena o XML da NFS-e
              FNFSe.XML := Leitor.Grupo;

              // Retorno do EnviarLoteRpsSincrono
              FNFSe.NumeroLote    := NumeroLoteTemp;
              FNFSe.dhRecebimento := DataRecebimentoTemp;
              FNFSe.Protocolo     := ProtocoloTemp;

              // Retorno do ConsultarLoteRps
              FNFSe.Situacao := SituacaoTemp;

              FNFSe.InfID.ID          := NFSeLida.NFSe.InfID.ID;
              FNFSe.Numero            := NFSeLida.NFSe.Numero;
              FNFSe.CodigoVerificacao := NFSeLida.NFSe.CodigoVerificacao;
              FNFSe.DataEmissao       := NFSeLida.NFSe.DataEmissao;
              FNFSe.dhRecebimento     := NFSeLida.NFSe.dhRecebimento;

              FNFSe.NaturezaOperacao         := NFSeLida.NFSe.NaturezaOperacao;
              FNFSe.RegimeEspecialTributacao := NFSeLida.NFSe.RegimeEspecialTributacao;
              FNFSe.OptanteSimplesNacional   := NFSeLida.NFSe.OptanteSimplesNacional;
              FNFSe.IncentivadorCultural     := NFSeLida.NFSe.IncentivadorCultural;

              FNFSe.Competencia       := NFSeLida.NFSe.Competencia;
              FNFSe.NFSeSubstituida   := NFSeLida.NFSe.NFSeSubstituida;
              FNFSe.OutrasInformacoes := NFSeLida.NFSe.OutrasInformacoes;
              FNFSe.ValorCredito      := NFSeLida.NFSe.ValorCredito;

              FNFSe.IdentificacaoRps.Numero := NFSeLida.NFSe.IdentificacaoRps.Numero;
              FNFSe.IdentificacaoRps.Serie  := NFSeLida.NFSe.IdentificacaoRps.Serie;
              FNFSe.IdentificacaoRps.Tipo   := NFSeLida.NFSe.IdentificacaoRps.Tipo;

              FNFSe.RpsSubstituido.Numero := NFSeLida.NFSe.RpsSubstituido.Numero;
              FNFSe.RpsSubstituido.Serie  := NFSeLida.NFSe.RpsSubstituido.Serie;
              FNFSe.RpsSubstituido.Tipo   := NFSeLida.NFSe.RpsSubstituido.Tipo;

              FNFSe.Servico.ItemListaServico          := NFSeLida.NFSe.Servico.ItemListaServico;
              FNFSe.Servico.xItemListaServico         := NFSeLida.NFSe.Servico.xItemListaServico;
              FNFSe.Servico.CodigoCnae                := NFSeLida.NFSe.Servico.CodigoCnae;
              FNFSe.Servico.CodigoTributacaoMunicipio := NFSeLida.NFSe.Servico.CodigoTributacaoMunicipio;
              FNFSe.Servico.Discriminacao             := NFSeLida.NFSe.Servico.Discriminacao;
              FNFSe.Servico.CodigoMunicipio           := NFSeLida.NFSe.Servico.CodigoMunicipio;

              FNFSe.Servico.Valores.ValorServicos          := NFSeLida.NFSe.Servico.Valores.ValorServicos;
              FNFSe.Servico.Valores.ValorDeducoes          := NFSeLida.NFSe.Servico.Valores.ValorDeducoes;
              FNFSe.Servico.Valores.ValorPis               := NFSeLida.NFSe.Servico.Valores.ValorPis;
              FNFSe.Servico.Valores.ValorCofins            := NFSeLida.NFSe.Servico.Valores.ValorCofins;
              FNFSe.Servico.Valores.ValorInss              := NFSeLida.NFSe.Servico.Valores.ValorInss;
              FNFSe.Servico.Valores.ValorIr                := NFSeLida.NFSe.Servico.Valores.ValorIr;
              FNFSe.Servico.Valores.ValorCsll              := NFSeLida.NFSe.Servico.Valores.ValorCsll;
              FNFSe.Servico.Valores.IssRetido              := NFSeLida.NFSe.Servico.Valores.IssRetido;
              FNFSe.Servico.Valores.ValorIss               := NFSeLida.NFSe.Servico.Valores.ValorIss;
              FNFSe.Servico.Valores.OutrasRetencoes        := NFSeLida.NFSe.Servico.Valores.OutrasRetencoes;
              FNFSe.Servico.Valores.BaseCalculo            := NFSeLida.NFSe.Servico.Valores.BaseCalculo;
              FNFSe.Servico.Valores.Aliquota               := NFSeLida.NFSe.Servico.Valores.Aliquota;
              FNFSe.Servico.Valores.ValorLiquidoNFSe       := NFSeLida.NFSe.Servico.Valores.ValorLiquidoNFSe;
              FNFSe.Servico.Valores.ValorIssRetido         := NFSeLida.NFSe.Servico.Valores.ValorIssRetido;
              FNFSe.Servico.Valores.DescontoCondicionado   := NFSeLida.NFSe.Servico.Valores.DescontoCondicionado;
              FNFSe.Servico.Valores.DescontoIncondicionado := NFSeLida.NFSe.Servico.Valores.DescontoIncondicionado;

              FNFSe.Prestador.Cnpj               := NFSeLida.NFSe.Prestador.Cnpj;
              FNFSe.Prestador.InscricaoMunicipal := NFSeLida.NFSe.Prestador.InscricaoMunicipal;

              FNFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := NFSeLida.NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj;
              FNFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := NFSeLida.NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal;

              FNFSe.PrestadorServico.RazaoSocial  := NFSeLida.NFSe.PrestadorServico.RazaoSocial;
              FNFSe.PrestadorServico.NomeFantasia := NFSeLida.NFSe.PrestadorServico.NomeFantasia;

              FNFSe.PrestadorServico.Endereco.Endereco    := NFSeLida.NFSe.PrestadorServico.Endereco.Endereco;
              FNFSe.PrestadorServico.Endereco.Numero      := NFSeLida.NFSe.PrestadorServico.Endereco.Numero;
              FNFSe.PrestadorServico.Endereco.Complemento := NFSeLida.NFSe.PrestadorServico.Endereco.Complemento;
              FNFSe.PrestadorServico.Endereco.Bairro      := NFSeLida.NFSe.PrestadorServico.Endereco.Bairro;

              FNFSe.PrestadorServico.Endereco.CodigoMunicipio := NFSeLida.NFSe.PrestadorServico.Endereco.CodigoMunicipio;
              FNFSe.PrestadorServico.Endereco.xMunicipio := NFSeLida.NFSe.PrestadorServico.Endereco.xMunicipio;

              FNFSe.PrestadorServico.Endereco.UF  := NFSeLida.NFSe.PrestadorServico.Endereco.UF;
              FNFSe.PrestadorServico.Endereco.CEP := NFSeLida.NFSe.PrestadorServico.Endereco.CEP;

              FNFSe.PrestadorServico.Contato.Telefone := NFSeLida.NFSe.PrestadorServico.Contato.Telefone;
              FNFSe.PrestadorServico.Contato.Email    := NFSeLida.NFSe.PrestadorServico.Contato.Email;

              FNFSe.Tomador.IdentificacaoTomador.CpfCnpj := NFSeLida.NFSe.Tomador.IdentificacaoTomador.CpfCnpj;
              FNFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := NFSeLida.NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal;

              FNFSe.Tomador.RazaoSocial := NFSeLida.NFSe.Tomador.RazaoSocial;

              FNFSe.Tomador.Endereco.Endereco    := NFSeLida.NFSe.Tomador.Endereco.Endereco;
              FNFSe.Tomador.Endereco.Numero      := NFSeLida.NFSe.Tomador.Endereco.Numero;
              FNFSe.Tomador.Endereco.Complemento := NFSeLida.NFSe.Tomador.Endereco.Complemento;
              FNFSe.Tomador.Endereco.Bairro      := NFSeLida.NFSe.Tomador.Endereco.Bairro;

              FNFSe.Tomador.Endereco.CodigoMunicipio := NFSeLida.NFSe.Tomador.Endereco.CodigoMunicipio;
              FNFSe.Tomador.Endereco.xMunicipio      := NFSeLida.NFSe.Tomador.Endereco.xMunicipio;
              FNFSe.Tomador.Endereco.UF              := NFSeLida.NFSe.Tomador.Endereco.UF;

              FNFSe.Tomador.Endereco.CEP := NFSeLida.NFSe.Tomador.Endereco.CEP;

              FNFSe.Tomador.Contato.Telefone := NFSeLida.NFSe.Tomador.Contato.Telefone;
              FNFSe.Tomador.Contato.Email    := NFSeLida.NFSe.Tomador.Contato.Email;

              FNFSe.IntermediarioServico.CpfCnpj := NFSeLida.NFSe.IntermediarioServico.CpfCnpj;
              FNFSe.IntermediarioServico.InscricaoMunicipal := NFSeLida.NFSe.IntermediarioServico.InscricaoMunicipal;
              FNFSe.IntermediarioServico.RazaoSocial := NFSeLida.NFSe.IntermediarioServico.RazaoSocial;

              FNFSe.OrgaoGerador.CodigoMunicipio := NFSeLida.NFSe.OrgaoGerador.CodigoMunicipio;
              FNFSe.OrgaoGerador.Uf              := NFSeLida.NFSe.OrgaoGerador.Uf;

              FNFSe.ConstrucaoCivil.CodigoObra := NFSeLida.NFSe.ConstrucaoCivil.CodigoObra;
              FNFSe.ConstrucaoCivil.Art        := NFSeLida.NFSe.ConstrucaoCivil.Art;

              FNFSe.CondicaoPagamento.Condicao   := NFSeLida.NFSe.CondicaoPagamento.Condicao;
              FNFSe.CondicaoPagamento.QtdParcela := NFSeLida.NFSe.CondicaoPagamento.QtdParcela;

              FNFSe.NFSeCancelamento.DataHora := NFSeLida.NFSe.NFSeCancelamento.DataHora;

              FNFSe.NFSeSubstituidora := NFSeLida.NFSe.NFSeSubstituidora;
            end;

            for j := 0 to NFSeLida.NFSe.CondicaoPagamento.Parcelas.Count -1 do
            begin
              with ListaNFSe.FCompNFSe[i].FNFSe.CondicaoPagamento.Parcelas.Add do
              begin
                Parcela        := NFSeLida.NFSe.CondicaoPagamento.Parcelas.Items[j].Parcela;
                DataVencimento := NFSeLida.NFSe.CondicaoPagamento.Parcelas.Items[j].DataVencimento;
                Valor          := NFSeLida.NFSe.CondicaoPagamento.Parcelas.Items[j].Valor;
              end;
            end;
          end;
        finally
           NFSeLida.Free;
           NFSe.Free;
        end;

        inc(i); // Incrementa o contador de notas.
      end;
    end;

    // =======================================================================
    // Extrai a Lista de Mensagens de Erro
    // =======================================================================

    if (leitor.rExtrai(1, 'ListaMensagemRetorno') <> '') or
       (leitor.rExtrai(1, 'ListaMensagemRetornoLote') <> '') then
    begin
      i := 0;
      while Leitor.rExtrai(2, 'MensagemRetorno', '', i + 1) <> '' do
      begin
        ListaNFSe.FMsgRetorno.Add;
        ListaNFSe.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
        ListaNFSe.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
        ListaNFSe.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');

        inc(i);
      end;
    end;

    i := 0;
    while (Leitor.rExtrai(1, 'Fault', '', i + 1) <> '') do
    begin
      ListaNFSe.FMsgRetorno.Add;
      ListaNFSe.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'faultcode');
      ListaNFSe.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'faultstring');
      ListaNFSe.FMsgRetorno[i].FCorrecao := '';

      inc(i);
    end;

    if (Leitor.rExtrai(1, 'EmitirResponse') <> '') then
    begin
      if Leitor.rCampo(tcStr, 'Erro') <> 'false' then
      begin
        with ListaNFSe.FCompNFSe.Add do
        begin
          FNFSe.Numero    := Leitor.rCampo(tcStr, 'b:Numero');
          Protocolo       := Leitor.rCampo(tcStr, 'b:Autenticador');
          FNFSe.Protocolo := Protocolo;
        end;
      end;
    end;

  except
    Result := False;
  end;
end;

end.
