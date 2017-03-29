{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
{ Biblioteca multiplataforma de componentes Delphi                             }
{                                                                              }
{ Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr      }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{ Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la  }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{ Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto }
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{ Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                               }
{                                                                              }
{******************************************************************************}
{******************************************************************************
  |* Historico
  |*
  |* 18/10/2013: Jeanny Paiva Lopes
  |*  - Inicio do desenvolvimento DAMDFE FastReport
 ******************************************************************************}

{$I ACBr.inc}

unit ACBrMDFeDAMDFEFR;

interface

uses
  SysUtils, Classes, ACBrMDFeDAMDFeClass, ACBrMDFeDAMDFEFRDM,
  pcnConversao, pmdfeMDFe, frxClass, ACBrDFeUtil;

type
  EACBrMDFeDAMDFEFR = class(Exception);

  TACBrMDFeDAMDFEFR = class(TACBrMDFeDAMDFEClass)
  private
    FdmDAMDFe:            TDMACBrMDFeDAMDFEFR;
    FFastFile:            string;
    FFastFileEvento:      string;
    FEspessuraBorda:      Integer;
    FSelecionaImpressora: Boolean;
    FTamanhoCanhoto:      Extended;
    FAlturaEstampaFiscal: Extended;
    function GetPreparedReport: TfrxReport;
    function GetPreparedReportEvento: TfrxReport;
    function PrepareReport(MDFe: TMDFe = nil): Boolean;
    function PrepareReportEvento: Boolean;
  public
    VersaoDAMDFe: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDAMDFe(MDFe: TMDFe = nil); override;
    procedure ImprimirDAMDFePDF(MDFe: TMDFe = nil); override;
    procedure ImprimirEVENTO(MDFe: TMDFe = nil); override;
    procedure ImprimirEVENTOPDF(MDFe: TMDFe = nil); override;
  published
    property FastFile:             string read FFastFile write FFastFile;
    property FastFileEvento:       string read FFastFileEvento write FFastFileEvento;
    property SelecionaImpressora:  Boolean read FSelecionaImpressora write FSelecionaImpressora;
    property dmDAMDFe:             TDMACBrMDFeDAMDFEFR read FdmDAMDFe write FdmDAMDFe;
    property EspessuraBorda:       Integer read FEspessuraBorda write FEspessuraBorda;
    property TamanhoCanhoto:       Extended read FTamanhoCanhoto write FTamanhoCanhoto;
    property AlturaEstampaFiscal:  Extended read FAlturaEstampaFiscal write FAlturaEstampaFiscal;
    property PreparedReport:       TfrxReport read GetPreparedReport;
    property PreparedReportEvento: TfrxReport read GetPreparedReportEvento;
  end;

implementation

uses ACBrMDFe, ACBrUtil, StrUtils;

constructor TACBrMDFeDAMDFEFR.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FdmDAMDFe       := TDMACBrMDFeDAMDFEFR.Create(Self);
  FFastFile       := '';
  FEspessuraBorda := 1;
end;

destructor TACBrMDFeDAMDFEFR.Destroy;
begin
  dmDAMDFe.Free;
  inherited Destroy;
end;

function TACBrMDFeDAMDFEFR.GetPreparedReport: TfrxReport;
begin
  if Trim(FFastFile) = '' then
    Result := nil
  else
  begin
    if PrepareReport(nil) then
      Result := dmDAMDFe.frxReport
    else
      Result := nil;
  end;
end;

function TACBrMDFeDAMDFEFR.GetPreparedReportEvento: TfrxReport;
begin
  if Trim(FFastFileEvento) = '' then
    Result := nil
  else
  begin
    if PrepareReportEvento then
      Result := dmDAMDFe.frxReport
    else
      Result := nil;
  end;
end;

procedure TACBrMDFeDAMDFEFR.ImprimirDAMDFe(MDFe: TMDFe);
begin
  if PrepareReport(MDFe) then
  begin
    if MostrarPreview then
      dmDAMDFe.frxReport.ShowPreparedReport
    else
    begin
      dmDAMDFe.frxReport.PrintOptions.ShowDialog := SelecionaImpressora;
      dmDAMDFe.frxReport.PrintOptions.Copies     := NumCopias;
	    dmDAMDFe.frxReport.PreviewOptions.AllowEdit := False;
      dmDAMDFe.frxReport.Print;
    end;
  end;
end;

procedure TACBrMDFeDAMDFEFR.ImprimirDAMDFePDF(MDFe: TMDFe);
var
  I:          Integer;
  TITULO_PDF: string;
  OldShowDialog : Boolean;
begin
  if PrepareReport(MDFe) then
  begin
    for I := 0 to TACBrMDFe(ACBrMDFe).Manifestos.Count - 1 do
    begin
      TITULO_PDF := OnlyNumber(TACBrMDFe(ACBrMDFe).Manifestos.Items[i].MDFe.infMDFe.ID);

      dmDAMDFe.frxPDFExport.Author     := Sistema;
      dmDAMDFe.frxPDFExport.Creator    := Sistema;
      dmDAMDFe.frxPDFExport.Producer   := Sistema;
      dmDAMDFe.frxPDFExport.Title      := TITULO_PDF;
      dmDAMDFe.frxPDFExport.Subject    := TITULO_PDF;
      dmDAMDFe.frxPDFExport.Keywords   := TITULO_PDF;
      OldShowDialog := dmDAMDFe.frxPDFExport.ShowDialog;
	    try
        dmDAMDFe.frxPDFExport.ShowDialog := False;
        dmDAMDFe.frxPDFExport.FileName   := IncludeTrailingPathDelimiter(PathPDF) + TITULO_PDF + '-mdfe.pdf';

        if not DirectoryExists(ExtractFileDir(dmDAMDFe.frxPDFExport.FileName)) then
          ForceDirectories(ExtractFileDir(dmDAMDFe.frxPDFExport.FileName));

        dmDAMDFe.frxReport.Export(dmDAMDFe.frxPDFExport);
      finally
        dmDAMDFe.frxPDFExport.ShowDialog := OldShowDialog;
      end;
    end;
  end;
end;

procedure TACBrMDFeDAMDFEFR.ImprimirEVENTO(MDFe: TMDFe);
begin
  if PrepareReportEvento then
  begin
    if MostrarPreview then
      dmDAMDFe.frxReport.ShowPreparedReport
    else
      dmDAMDFe.frxReport.Print;
  end;
end;

procedure TACBrMDFeDAMDFEFR.ImprimirEVENTOPDF(MDFe: TMDFe);
const
  TITULO_PDF = 'Manifesto de Documento Eletr�nico - Evento';
var
  NomeArq      : String;
  OldShowDialog: Boolean;
begin
  if PrepareReportEvento then
  begin
    dmDAMDFe.frxPDFExport.Author   := Sistema;
    dmDAMDFe.frxPDFExport.Creator  := Sistema;
    dmDAMDFe.frxPDFExport.Producer := Sistema;
    dmDAMDFe.frxPDFExport.Title    := TITULO_PDF;
    dmDAMDFe.frxPDFExport.Subject  := TITULO_PDF;
    dmDAMDFe.frxPDFExport.Keywords := TITULO_PDF;
    OldShowDialog := dmDAMDFe.frxPDFExport.ShowDialog;
    try
      dmDAMDFe.frxPDFExport.ShowDialog := False;
      NomeArq                          := StringReplace(TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[0].InfEvento.Id, 'ID', '', [rfIgnoreCase]);
      dmDAMDFe.frxPDFExport.FileName   := IncludeTrailingPathDelimiter(PathPDF) + NomeArq + '-procEventoMDFe.pdf';

      if not DirectoryExists(ExtractFileDir(dmDAMDFe.frxPDFExport.FileName)) then
        ForceDirectories(ExtractFileDir(dmDAMDFe.frxPDFExport.FileName));

      dmDAMDFe.frxReport.Export(dmDAMDFe.frxPDFExport);
    finally
      dmDAMDFe.frxPDFExport.ShowDialog := OldShowDialog;
    end;
  end;
end;

function TACBrMDFeDAMDFEFR.PrepareReport(MDFe: TMDFe): Boolean;
var
  i: Integer;
begin
  Result := False;
  dmDAMDFe.SetDataSetsToFrxReport;
  if Trim(FastFile) <> '' then
  begin
    if FileExists(FastFile) then
      dmDAMDFe.frxReport.LoadFromFile(FastFile)
    else
      raise EACBrMDFeDAMDFEFR.CreateFmt('Caminho do arquivo de impress�o do DAMDFe "%s" inv�lido.', [FastFile]);
  end
  else
    raise EACBrMDFeDAMDFEFR.Create('Caminho do arquivo de impress�o do DAMDFe n�o assinalado.');

  if Assigned(MDFe) then
  begin
    dmDAMDFe.MDFe := MDFe;
    dmDAMDFe.CarregaDados;
    dmDAMDFe.SetDataSetsToFrxReport;
    Result := dmDAMDFe.frxReport.PrepareReport;
  end
  else
  begin
    if Assigned(ACBrMDFe) then
    begin
      for i := 0 to TACBrMDFe(ACBrMDFe).Manifestos.Count - 1 do
      begin
        dmDAMDFe.MDFe := TACBrMDFe(ACBrMDFe).Manifestos.Items[i].MDFe;
        dmDAMDFe.CarregaDados;
        if (i > 0) then
          Result := dmDAMDFe.frxReport.PrepareReport(False)
        else
          Result := dmDAMDFe.frxReport.PrepareReport;
      end;
    end
    else
      raise EACBrMDFeDAMDFEFR.Create('Propriedade ACBrMDFe n�o assinalada.');
  end;
end;

function TACBrMDFeDAMDFEFR.PrepareReportEvento: Boolean;
begin
  if Trim(FastFileEvento) <> '' then
  begin
    if FileExists(FastFileEvento) then
      dmDAMDFe.frxReport.LoadFromFile(FastFileEvento)
    else
      raise EACBrMDFeDAMDFEFR.CreateFmt('Caminho do arquivo de impress�o do EVENTO "%s" inv�lido.', [FastFileEvento]);
  end
  else
    raise EACBrMDFeDAMDFEFR.Create('Caminho do arquivo de impress�o do EVENTO n�o assinalado.');

  dmDAMDFe.frxReport.PrintOptions.Copies := NumCopias;
  dmDAMDFe.frxReport.PreviewOptions.AllowEdit := False;

  // preparar relatorio
  if Assigned(ACBrMDFe) then
  begin
    if assigned(TACBrMDFe(ACBrMDFe).EventoMDFe) then
    begin
      dmDAMDFe.Evento := TACBrMDFe(ACBrMDFe).EventoMDFe;
      dmDAMDFe.CarregaDadosEventos;
    end
    else
      raise EACBrMDFeDAMDFEFR.Create('Evento n�o foi assinalado.');

    if TACBrMDFe(ACBrMDFe).Manifestos.Count > 0 then
    begin
      dmDAMDFe.MDFe := TACBrMDFe(ACBrMDFe).Manifestos.Items[0].MDFe;
      dmDAMDFe.CarregaDados;
    end;

    Result := dmDAMDFe.frxReport.PrepareReport;
  end
  else
    raise EACBrMDFeDAMDFEFR.Create('Propriedade ACBrMDFe n�o assinalada.');
end;

end.
