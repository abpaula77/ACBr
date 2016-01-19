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

unit pnfsCancNfseResposta;

interface

uses
  SysUtils, Classes, Forms, 
  pcnAuxiliar, pcnConversao, pcnLeitor,
  pnfsConversao, pnfsNFSe;

type

 TMsgRetornoCancCollection = class;
 TMsgRetornoCancCollectionItem = class;
 TNotasCanceladasCollection = class;
 TNotasCanceladasCollectionItem = class;

 TInfCanc = class(TPersistent)
  private
    FPedido: TPedidoCancelamento;
    FDataHora: TDateTime;
    FConfirmacao: String;
    FSucesso: String;
    FMsgCanc: String;
    FMsgRetorno: TMsgRetornoCancCollection;
    FNotasCanceladas: TNotasCanceladasCollection;

    procedure SetMsgRetorno(Value: TMsgRetornoCancCollection);
    procedure SetNotasCanceladas(const Value: TNotasCanceladasCollection);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property Pedido: TPedidocancelamento           read FPedido      write FPedido;
    property DataHora: TDateTime                   read FDataHora    write FDataHora;
    property Confirmacao: String                   read FConfirmacao write FConfirmacao;
    property Sucesso: String                       read FSucesso     write FSucesso;
    property MsgCanc: String                       read FMsgCanc     write FMsgCanc;
    property MsgRetorno: TMsgRetornoCancCollection read FMsgRetorno  write SetMsgRetorno;

    property NotasCanceladas: TNotasCanceladasCollection read FNotasCanceladas write SetNotasCanceladas;
  end;

 TMsgRetornoCancCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TMsgRetornoCancCollectionItem;
    procedure SetItem(Index: Integer; Value: TMsgRetornoCancCollectionItem);
  public
    constructor Create(AOwner: TInfCanc);
    function Add: TMsgRetornoCancCollectionItem;
    property Items[Index: Integer]: TMsgRetornoCancCollectionItem read GetItem write SetItem; default;
  end;

 TMsgRetornoCancCollectionItem = class(TCollectionItem)
  private
    FCodigo: String;
    FMensagem: String;
    FCorrecao: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Codigo: String   read FCodigo   write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property Correcao: String read FCorrecao write FCorrecao;
  end;

 TNotasCanceladasCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TNotasCanceladasCollectionItem;
    procedure SetItem(Index: Integer; Value: TNotasCanceladasCollectionItem);
  public
    constructor Create(AOwner: TInfCanc);
    function Add: TNotasCanceladasCollectionItem;
    property Items[Index: Integer]: TNotasCanceladasCollectionItem read GetItem write SetItem; default;
  end;

 TNotasCanceladasCollectionItem = class(TCollectionItem)
  private
    FNumeroNota: String;
    FCodigoVerficacao: String;
    FInscricaoMunicipalPrestador: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property NumeroNota: String       read FNumeroNota       write FNumeroNota;
    property CodigoVerficacao: String read FCodigoVerficacao write FCodigoVerficacao;
    property InscricaoMunicipalPrestador: String read FInscricaoMunicipalPrestador write FInscricaoMunicipalPrestador;
  end;

 TretCancNFSe = class(TPersistent)
  private
    FLeitor: TLeitor;
    FInfCanc: TInfCanc;
    FProvedor: TnfseProvedor;
    FVersaoXML: String;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;
    function LerXml_ABRASF: Boolean;
    function LerXml_proISSDSF: Boolean;
    function LerXML_proEquiplano: Boolean;
    function LerXml_proInfisc: Boolean;
    function LerXml_proEL: Boolean;
    function LerXml_proNFSeBrasil: Boolean;

  published
    property Leitor: TLeitor         read FLeitor   write FLeitor;
    property InfCanc: TInfCanc       read FInfCanc  write FInfCanc;
    property Provedor: TnfseProvedor read FProvedor write FProvedor;
    property VersaoXML: String       read FVersaoXML write FVersaoXML;
  end;

implementation

{ TInfCanc }

constructor TInfCanc.Create;
begin
  FPedido          := TPedidoCancelamento.Create;
  FMsgRetorno      := TMsgRetornoCancCollection.Create(Self);
  FNotasCanceladas := TNotasCanceladasCollection.Create(Self);
end;

destructor TInfCanc.Destroy;
begin
  FPedido.Free;
  FMsgRetorno.Free;
  FNotasCanceladas.Free;

  inherited;
end;

procedure TInfCanc.SetMsgRetorno(Value: TMsgRetornoCancCollection);
begin
  FMsgRetorno.Assign(Value);
end;

procedure TInfCanc.SetNotasCanceladas(const Value: TNotasCanceladasCollection);
begin
  FNotasCanceladas.Assign(Value);
end;

{ TMsgRetornoCancCollection }

function TMsgRetornoCancCollection.Add: TMsgRetornoCancCollectionItem;
begin
  Result := TMsgRetornoCancCollectionItem(inherited Add);
  Result.create;
end;

constructor TMsgRetornoCancCollection.Create(AOwner: TInfCanc);
begin
  inherited Create(TMsgRetornoCancCollectionItem);
end;

function TMsgRetornoCancCollection.GetItem(
  Index: Integer): TMsgRetornoCancCollectionItem;
begin
  Result := TMsgRetornoCancCollectionItem(inherited GetItem(Index));
end;

procedure TMsgRetornoCancCollection.SetItem(Index: Integer;
  Value: TMsgRetornoCancCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TMsgRetornoCancCollectionItem }

constructor TMsgRetornoCancCollectionItem.Create;
begin

end;

destructor TMsgRetornoCancCollectionItem.Destroy;
begin

  inherited;
end;

{ TNotasCanceladasCollection }

function TNotasCanceladasCollection.Add: TNotasCanceladasCollectionItem;
begin
  Result := TNotasCanceladasCollectionItem(inherited Add);
  Result.create;
end;

constructor TNotasCanceladasCollection.Create(AOwner: TInfCanc);
begin
  inherited Create(TNotasCanceladasCollectionItem);
end;

function TNotasCanceladasCollection.GetItem(
  Index: Integer): TNotasCanceladasCollectionItem;
begin
  Result := TNotasCanceladasCollectionItem(inherited GetItem(Index));
end;

procedure TNotasCanceladasCollection.SetItem(Index: Integer;
  Value: TNotasCanceladasCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TNotasCanceladasCollectionItem }

constructor TNotasCanceladasCollectionItem.Create;
begin

end;

destructor TNotasCanceladasCollectionItem.Destroy;
begin

  inherited;
end;

{ TretCancNFSe }

constructor TretCancNFSe.Create;
begin
  FLeitor  := TLeitor.Create;
  FInfCanc := TInfCanc.Create;
end;

destructor TretCancNFSe.Destroy;
begin
  FLeitor.Free;
  FInfCanc.Free;
  inherited;
end;

function TretCancNFSe.LerXml: Boolean;
begin
 case Provedor of
   proISSDSF:     Result := LerXml_proISSDSF;
   proEquiplano:  Result := LerXML_proEquiplano;
   proInfIsc:     Result := LerXml_proInfisc;
   proEL:         Result := LerXml_proEL;
   proNFSeBrasil: Result := LerXml_proNFSeBrasil;
 else
   Result := LerXml_ABRASF;
 end;
end;

function TretCancNFSe.LerXml_ABRASF: Boolean;
var
  i: Integer;
begin
  Result := True;

  try
    Leitor.Arquivo := RemoverNameSpace(RetirarPrefixos(Leitor.Arquivo));
    Leitor.Grupo   := Leitor.Arquivo;

    if Provedor = proGinfes then
    begin
      if (leitor.rExtrai(1, 'CancelarNfseResposta') <> '') then
      begin
        if AnsiLowerCase(Leitor.rCampo(tcStr, 'Sucesso')) = 'true' then
        begin
          infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHora');
          InfCanc.Sucesso  := Leitor.rCampo(tcStr,    'Sucesso');
          InfCanc.MsgCanc  := Leitor.rCampo(tcStr,    'Mensagem');
        end
        else
          infCanc.DataHora := 0;

        InfCanc.FPedido.InfID.ID           := '';
        InfCanc.FPedido.CodigoCancelamento := '';

        if Leitor.rExtrai(1, 'MensagemRetorno') <> '' then
        begin
          if Pos('cancelada com sucesso', AnsiLowerCase(Leitor.rCampo(tcStr, 'Mensagem'))) = 0 then
          begin
            InfCanc.FMsgRetorno.Add;
            InfCanc.FMsgRetorno[0].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
            InfCanc.FMsgRetorno[0].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
            InfCanc.FMsgRetorno[0].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');
          end;
        end;
      end;
    end
    else
    begin
      if (leitor.rExtrai(1, 'CancelarNfseResposta') <> '') or
         (leitor.rExtrai(1, 'Cancelarnfseresposta') <> '') or
         (leitor.rExtrai(1, 'CancelarNfseReposta') <> '') or
         (leitor.rExtrai(1, 'CancelarNfseResult') <> '') then
      begin
        infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHora');
        if infCanc.DataHora = 0 then
          infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHoraCancelamento');
        InfCanc.FConfirmacao := Leitor.rAtributo('Confirmacao Id=');
        InfCanc.Sucesso := Leitor.rCampo(tcStr, 'Sucesso');

        InfCanc.FPedido.InfID.ID := Leitor.rAtributo('InfPedidoCancelamento Id=');
        if InfCanc.FPedido.InfID.ID = '' then
          InfCanc.FPedido.InfID.ID := Leitor.rAtributo('InfPedidoCancelamento id=');

        InfCanc.FPedido.CodigoCancelamento := Leitor.rCampo(tcStr, 'CodigoCancelamento');
        If Provedor = proSimpliss then
          InfCanc.Sucesso := InfCanc.FPedido.CodigoCancelamento;

        if Leitor.rExtrai(2, 'IdentificacaoNfse') <> '' then
        begin
          InfCanc.FPedido.IdentificacaoNfse.Numero             := Leitor.rCampo(tcStr, 'Numero');
          InfCanc.FPedido.IdentificacaoNfse.Cnpj               := Leitor.rCampo(tcStr, 'Cnpj');
          InfCanc.FPedido.IdentificacaoNfse.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
          InfCanc.FPedido.IdentificacaoNfse.CodigoMunicipio    := Leitor.rCampo(tcStr, 'CodigoMunicipio');
        end;

        Leitor.Grupo := Leitor.Arquivo;

        InfCanc.FPedido.signature.URI             := Leitor.rAtributo('Reference URI=');
        InfCanc.FPedido.signature.DigestValue     := Leitor.rCampo(tcStr, 'DigestValue');
        InfCanc.FPedido.signature.SignatureValue  := Leitor.rCampo(tcStr, 'SignatureValue');
        InfCanc.FPedido.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');

        if (leitor.rExtrai(2, 'ListaMensagemRetorno') <> '') then
        begin
          i := 0;
          while Leitor.rExtrai(3, 'MensagemRetorno', '', i + 1) <> '' do
          begin
            InfCanc.FMsgRetorno.Add;
            InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
            InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
            InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');

            inc(i);
          end;
        end;

        if (leitor.rExtrai(1, 'ListaMensagemRetorno') <> '') then
        begin
           InfCanc.FMsgRetorno.Add;
           InfCanc.FMsgRetorno[0].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
           InfCanc.FMsgRetorno[0].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
           InfCanc.FMsgRetorno[0].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');
        end;

      end;
    end;

    i := 0;
    while (Leitor.rExtrai(1, 'Fault', '', i + 1) <> '') do
    begin
      InfCanc.FMsgRetorno.Add;
      InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'faultcode');
      InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'faultstring');
      InfCanc.FMsgRetorno[i].FCorrecao := '';

      inc(i);
    end;

  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proISSDSF: Boolean; //falta homologar
var
  i: Integer;
begin
  Result := False;

  try
    Leitor.Arquivo := RetirarPrefixos(Leitor.Arquivo);
    Leitor.Grupo   := Leitor.Arquivo;

    if leitor.rExtrai(1, 'RetornoCancelamentoNFSe') <> '' then
    begin
      if (leitor.rExtrai(2, 'Cabecalho') <> '') then
        FInfCanc.FSucesso := Leitor.rCampo(tcStr, 'Sucesso');

      i := 0;
      if (leitor.rExtrai(2, 'NotasCanceladas') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Nota', '', i + 1) <> '') do
        begin
          FInfCanc.FNotasCanceladas.Add;
          FInfCanc.FNotasCanceladas[i].InscricaoMunicipalPrestador := Leitor.rCampo(tcStr, 'InscricaoMunicipalPrestador');
          FInfCanc.FNotasCanceladas[i].NumeroNota                  := Leitor.rCampo(tcStr, 'NumeroNota');
          FInfCanc.FNotasCanceladas[i].CodigoVerficacao            := Leitor.rCampo(tcStr,'CodigoVerificacao');
          inc(i);
        end;
      end;

      i := 0;
      if (leitor.rExtrai(2, 'Alertas') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Alerta', '', i + 1) <> '') do
        begin
          InfCanc.FMsgRetorno.Add;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Descricao');
          InfCanc.FMsgRetorno[i].FCorrecao := '';
          inc(i);
        end;
      end;

      i := 0;
      if (leitor.rExtrai(2, 'Erros') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Erro', '', i + 1) <> '') do
        begin
          InfCanc.FMsgRetorno.Add;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Descricao');
          InfCanc.FMsgRetorno[i].FCorrecao := '';
          inc(i);
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXML_proEquiplano: Boolean;
var
  i: Integer;
begin
  try
    Leitor.Arquivo := RetirarPrefixos(Leitor.Arquivo);
    Leitor.Grupo   := Leitor.Arquivo;

    InfCanc.FSucesso  := Leitor.rCampo(tcStr, 'Sucesso');
    InfCanc.FDataHora := Leitor.rCampo(tcDatHor, 'dtCancelamento');

    if leitor.rExtrai(1, 'mensagemRetorno') <> '' then
    begin
      i := 0;
      if (leitor.rExtrai(2, 'listaErros') <> '') then
      begin
        while Leitor.rExtrai(3, 'erro', '', i + 1) <> '' do
        begin
          InfCanc.FMsgRetorno.Add;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'cdMensagem');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'dsMensagem');
          InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'dsCorrecao');
          inc(i);
        end;
      end;

      if (leitor.rExtrai(2, 'listaAlertas') <> '') then
      begin
        while Leitor.rExtrai(3, 'alerta', '', i + 1) <> '' do
        begin
          InfCanc.FMsgRetorno.Add;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'cdMensagem');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'dsMensagem');
          InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'dsCorrecao');
          inc(i);
        end;
      end;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proInfisc: Boolean;
var
  sMotCod, sMotDes, sCancelaAnula: String;
begin
  Result := False;
  try
    Leitor.Arquivo := RetirarPrefixos(Leitor.Arquivo);
    Leitor.Grupo   := Leitor.Arquivo;

    if VersaoXML = '1.1' then
      sCancelaAnula := 'resCancelaNFSe' // Caxias do Sul Vers�o XML 1.1
    else
      sCancelaAnula := 'resAnulaNFSe';  // Demais Cidades

    if leitor.rExtrai(1, sCancelaAnula) <> '' then
    begin
      InfCanc.FSucesso := Leitor.rCampo(tcStr, 'sit');
      if (InfCanc.FSucesso = '100') then // 100-Aceito
      begin
         InfCanc.FPedido.IdentificacaoNfse.Cnpj   := Leitor.rCampo(tcStr, 'CNPJ');
         InfCanc.FPedido.IdentificacaoNfse.Numero := Leitor.rCampo(tcStr, 'chvAcessoNFS-e');
         InfCanc.FDataHora                        := Leitor.rCampo(tcDatHor, 'dhRecbto');
      end
      else if (InfCanc.FSucesso = '200') then // 200-Rejeitado
      begin
        sMotDes := Leitor.rCampo(tcStr, 'mot');
        if Pos('Error', sMotDes) > 0 then
          sMotCod := SomenteNumeros(copy(sMotDes, 1, Pos(' ', sMotDes)))
        else
          sMotCod := '';
        InfCanc.MsgRetorno.Add;
        InfCanc.MsgRetorno[0].FCodigo   := sMotCod;
        InfCanc.MsgRetorno[0].FMensagem := sMotDes + ' ' +
                                          'CNPJ ' + Leitor.rCampo(tcStr, 'CNPJ') + ' ' +
                                          'DATA ' + Leitor.rCampo(tcStr, 'dhRecbto');
        InfCanc.MsgRetorno[0].FCorrecao := '';
      end;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proEL: Boolean;
begin
  Result := False;
end;

function TretCancNFSe.LerXml_proNFSeBrasil: Boolean;
//var
  //ok: Boolean;
  //i, Item, posI, count: Integer;
  //VersaoXML: String;
  //strAux,strAux2, strItem: AnsiString;
  //leitorAux, leitorItem:TLeitor;
begin
  Result := False;
  (*
   // Luiz Bai�o 2014.12.03 
  try
    Leitor.Arquivo := RetirarPrefixos(Leitor.Arquivo);
    VersaoXML      := '1';
    Leitor.Grupo   := Leitor.Arquivo;

    strAux := leitor.rExtrai_NFSEBrasil(1, 'RespostaLoteRps');

    strAux := leitor.rExtrai_NFSEBrasil(1, 'erros');
    if ( strAux <> emptystr) then begin
    
        posI := 1;
        i := 0 ;
        while ( posI > 0 ) do begin
             count := pos('</erro>', strAux) + 7;

             LeitorAux := TLeitor.Create;
             leitorAux.Arquivo := copy(strAux, PosI, count);
             leitorAux.Grupo   := leitorAux.Arquivo;
             strAux2 := leitorAux.rExtrai_NFSEBrasil(1,'erro');
             strAux2 := Leitor.rCampo(tcStr, 'erro');
             InfCanc.FMsgRetorno.Add;
             InfCanc.FMsgRetorno.Items[i].Mensagem := Leitor.rCampo(tcStr, 'erro')+#13;
             inc(i);
             LeitorAux.free;
             Delete(strAux, PosI, count);
             posI := pos('<erro>', strAux);
        end;
    end;

    strAux := leitor.rExtrai_NFSEBrasil(1, 'confirmacoes');
    if ( strAux <> emptystr) then begin

        posI := 1;
        // i := 0 ;
        while ( posI > 0 ) do begin
        
           count := pos('</confirmacao>', strAux) + 7;
           LeitorAux := TLeitor.Create;
           leitorAux.Arquivo := copy(strAux, PosI, count);
           leitorAux.Grupo   := leitorAux.Arquivo;
           strAux2 := leitorAux.rExtrai_NFSEBrasil(1,'confirmacao');
           strAux2 := Leitor.rCampo(tcStr, 'confirmacao');
           InfCanc.FMsgRetorno.Add;
           InfCanc.FMsgRetorno.Items[i].Mensagem := Leitor.rCampo(tcStr, 'confirmacao')+#13;
           inc(i);
           LeitorAux.free;
           Delete(strAux, PosI, count);
           posI := pos('<confirmacao>', strAux);
        end;
    end;

    Result := True;
  except
    result := False;
  end;
  *)
end;

end.

