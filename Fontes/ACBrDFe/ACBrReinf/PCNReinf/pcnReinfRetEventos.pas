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

unit pcnReinfRetEventos;

interface

uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnLeitor,
  pcnReinfClasses, pcnConversaoReinf, pcnReinfR5001, pcnReinfR5011;

type

  TRetEnvioLote = class(TPersistent)
  private
    FLeitor: TLeitor;
    FIdeTransmissor: TIdeTransmissor;
    FStatus: TStatus;
    Fevento: TeventoCollection;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;

    property IdeTransmissor: TIdeTransmissor read FIdeTransmissor write FIdeTransmissor;
    property Status: TStatus read FStatus write FStatus;
    property evento: TeventoCollection read Fevento write Fevento;
  end;

implementation

uses
  ACBrUtil;

{ TRetEnvioLote }

constructor TRetEnvioLote.Create;
begin
  FLeitor := TLeitor.Create;

  FIdeTransmissor := TIdeTransmissor.Create;
  FStatus         := TStatus.Create;
  Fevento         := TeventoCollection.create(Self);
end;

destructor TRetEnvioLote.Destroy;
begin
  FLeitor.Free;

  FIdeTransmissor.Free;
  FStatus.Free;
  Fevento.Free;

  inherited;
end;

function TRetEnvioLote.LerXml: boolean;
var
  i: Integer;
begin
  Result := False;

  try
    Leitor.Grupo := Leitor.Arquivo;
    if leitor.rExtrai(1, 'retornoLoteEventos') <> '' then
    begin
      if leitor.rExtrai(2, 'ideTransmissor') <> '' then
        IdeTransmissor.IdTransmissor := FLeitor.rCampo(tcStr, 'IdTransmissor');

      if leitor.rExtrai(2, 'status') <> '' then
      begin
        Status.cdStatus    := Leitor.rCampo(tcInt, 'cdStatus');
        Status.descRetorno := Leitor.rCampo(tcStr,'descRetorno');

        if leitor.rExtrai(3, 'dadosRegistroOcorrenciaLote') <> '' then
        begin
          i := 0;
          while Leitor.rExtrai(4, 'ocorrencias', '', i + 1) <> '' do
          begin
            Status.Ocorrencias.Add;
            Status.Ocorrencias.Items[i].Tipo        := FLeitor.rCampo(tcInt, 'tipo');
            Status.Ocorrencias.Items[i].Localizacao := FLeitor.rCampo(tcStr, 'localizacaoErroAviso');
            Status.Ocorrencias.Items[i].Codigo      := FLeitor.rCampo(tcInt, 'codigo');
            Status.Ocorrencias.Items[i].Descricao   := FLeitor.rCampo(tcStr, 'descricao');
            inc(i);
          end;
        end;
      end;

      if leitor.rExtrai(2, 'retornoEventos') <> '' then
      begin
        i := 0;
        while Leitor.rExtrai(3, 'evento', '', i + 1) <> '' do
        begin
          evento.Add;
          evento.Items[i].Id           := FLeitor.rAtributo('id', 'evento');
          evento.Items[i].ArquivoReinf := RetornarConteudoEntre(Leitor.Grupo, '>', '</evento');

          if pos('evtTotal', evento.Items[i].ArquivoReinf) > 0 then
          begin
            evento.Items[i].Tipo       := 'R5001';
            evento.Items[i].Evento     := TR5001.Create;
            evento.Items[i].Evento.Xml := evento.Items[i].ArquivoReinf;
          end;

          if pos('evtTotalContrib', evento.Items[i].ArquivoReinf) > 0 then
          begin
            evento.Items[i].Tipo       := 'R5011';
            evento.Items[i].Evento     := TR5011.Create;
            evento.Items[i].Evento.Xml := evento.Items[i].ArquivoReinf;
          end;

          inc(i);
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.
