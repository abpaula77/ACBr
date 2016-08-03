{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
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

{******************************************************************************
|* Historico
|*
******************************************************************************}

{$I ACBr.inc}

unit ACBrGNReGuiaRL;

interface

uses
Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pgnreConversao,pgnreGNRERetorno,pgnreGNRE, ACBrGNRE2,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts,
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB;

type

  { TfrlGuiaRL }

  TfrlGuiaRL = class(TForm)
  dsItens: TDatasource;
  RLGNRe: TRLReport;
  RLPDFFilter1: TRLPDFFilter;
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    FACBrGNRe: TACBrGNRE;
    FGNRe: TGNRERetorno;
    FEmail: string;
    FFax: string;
    FNumCopias: integer;
    FSistema: string;
    FSite: string;
    FUsuario: string;
    AfterPreview: boolean;
    ChangedPos: boolean;
    FSemValorFiscal: boolean;
    FMargemSuperior: double;
    FMargemInferior: double;
    FMargemEsquerda: double;
    FMargemDireita: double;
    FImpressora: string;
    cdsItens:  {$IFDEF BORLAND} TClientDataSet {$ELSE} TBufDataset{$ENDIF};
    procedure ConfigDataSet;
  public
    { Public declarations }
    class procedure Imprimir(AOwner: TComponent;
      AGNRe: TGNRERetorno;
      AEmail: string = '';
      AFax: string = '';
      ANumCopias: integer = 1;
      ASistema: string = '';
      ASite: string = '';
      AUsuario: string = '';
      APreview: boolean = True;
      AMargemSuperior: double = 0.8;
      AMargemInferior: double = 0.8;
      AMargemEsquerda: double = 0.6;
      AMargemDireita: double = 0.51;
      AImpressora: string = '';
      APrintDialog  : Boolean = True  );

    class procedure SavePDF(AOwner: TComponent;
      AFile: string;
      AGNRe: TGNRERetorno;
      AEmail: string = '';
      AFax: string = '';
      ANumCopias: integer = 1;
      ASistema: string = '';
      ASite: string = '';
      AUsuario: string = '';
      AMargemSuperior: double = 0.8;
      AMargemInferior: double = 0.8;
      AMargemEsquerda: double = 0.6;
      AMargemDireita: double = 0.51);
  end;

implementation

uses
  MaskUtils, ACBrUtil;

{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

class procedure TfrlGuiaRL.Imprimir(AOwner: TComponent;
  AGNRe: TGNRERetorno;
  AEmail: string = '';
  AFax: string = '';
  ANumCopias: integer = 1;
  ASistema: string = '';
  ASite: string = '';
  AUsuario: string = '';
  APreview: boolean = True;
  AMargemSuperior: double = 0.8;
  AMargemInferior: double = 0.8;
  AMargemEsquerda: double = 0.6;
  AMargemDireita: double = 0.51;
  AImpressora: string = '';
  APrintDialog: Boolean = True);
begin
  with Create(AOwner) do
    //with TfrlGuiaRL do
    try
      FGNRe := AGNRe;
      FEmail := AEmail;
      FNumCopias := ANumCopias;
      FMargemSuperior := AMargemSuperior;
      FMargemInferior := AMargemInferior;
      FMargemEsquerda := AMargemEsquerda;
      FMargemDireita := AMargemDireita;
      FImpressora := AImpressora;

      if FImpressora > '' then
        RLPrinter.PrinterName := FImpressora;

      if FNumCopias > 0 then
        RLPrinter.Copies := FNumCopias
      else
        RLPrinter.Copies := 1;

      RLGNRe.PrintDialog := APrintDialog;
      if APreview = True then
        RLGNRe.PreviewModal
      else
        RLGNRe.Print;
    finally
      Free;
    end;
end;

class procedure TfrlGuiaRL.SavePDF(AOwner: TComponent;
  AFile: string;
  AGNRe: TGNRERetorno;
  AEmail: string = '';
  AFax: string = '';
  ANumCopias: integer = 1;
  ASistema: string = '';
  ASite: string = '';
  AUsuario: string = '';
  AMargemSuperior: double = 0.8;
  AMargemInferior: double = 0.8;
  AMargemEsquerda: double = 0.6;
  AMargemDireita: double = 0.51);
begin
  with Create(AOwner) do
    //with TfrlGuiaRL do
    try
      FGNRe := AGNRe;
      FEmail := AEmail;
      FFax := AFax;
      FNumCopias := ANumCopias;
      FSistema := ASistema;
      FSite := ASite;
      FUsuario := AUsuario;
      FMargemSuperior := AMargemSuperior;
      FMargemInferior := AMargemInferior;
      FMargemEsquerda := AMargemEsquerda;
      FMargemDireita := AMargemDireita;

      with RLPDFFilter1.DocumentInfo do
      begin
//        Title := ACBrStr('Guia - GNRe n� ') +  FGNRe.
        //KeyWords := ACBrStr('N�mero:') + FGNRe.c42_identificadorGuia;
          //ACBrStr('; Data de emiss�o: ') + FormatDateTime('dd/mm/yyyy', FGNRe.Ide.dhEmi) +'; CNPJ: ' + FGNRe.emit.CNPJ;
      end;

      RLGNRe.SaveToFile(AFile);
    finally
      Free;
    end;
end;

procedure TfrlGuiaRL.FormDestroy(Sender: TObject);
begin
     RLGNRe.Free;
     FreeAndNil(dsItens);
end;

procedure TfrlGuiaRL.FormCreate(Sender: TObject);
begin
  ConfigDataSet;
end;

procedure TfrlGuiaRL.ConfigDataSet;
begin
  if not Assigned(cdsItens) then
    cdsItens := {$IFDEF BORLAND}  TClientDataSet.create(nil)  {$ELSE} TBufDataset.Create(nil){$ENDIF};

  if cdsItens.Active then
  begin
 {$IFDEF BORLAND}
  if cdsItens is TClientDataSet then
  TClientDataSet(cdsItens).EmptyDataSet;
 {$ENDIF}
    cdsItens.Active := False;
  end;

 {$IFDEF BORLAND}
 if cdsItens is TClientDataSet then
  begin
  TClientDataSet(cdsItens).StoreDefs := False;
  TClientDataSet(cdsItens).IndexDefs.Clear;
  TClientDataSet(cdsItens).IndexFieldNames := '';
  TClientDataSet(cdsItens).IndexName := '';
  TClientDataSet(cdsItens).Aggregates.Clear;
  TClientDataSet(cdsItens).AggFields.Clear;
  end;
 {$ELSE}
  if cdsItens is TBufDataset then
  begin
    TBufDataset(cdsItens).IndexDefs.Clear;
    TBufDataset(cdsItens).IndexFieldNames := '';
    TBufDataset(cdsItens).IndexName := '';
  end;
 {$ENDIF}

  with cdsItens do
    if FieldCount = 0 then
    begin
      FieldDefs.Clear;
      Fields.Clear;
      FieldDefs.Add('CHAVE1', ftString, 84);
      FieldDefs.Add('CHAVE2', ftString, 84);

   {$IFDEF BORLAND}
    if cdsItens is TClientDataSet then
    TClientDataSet(cdsItens).CreateDataSet;
   {$ELSE}
      if cdsItens is TBufDataset then
        TBufDataset(cdsItens).CreateDataSet;
   {$ENDIF}
    end;

 {$IFDEF BORLAND}
  if cdsItens is TClientDataSet then
  TClientDataSet(cdsItens).StoreDefs := False;
 {$ENDIF}

  if not cdsItens.Active then
    cdsItens.Active := True;

  {$IFDEF BORLAND}
   if cdsItens is TClientDataSet then
   if cdsItens.Active then
   TClientDataSet(cdsItens).LogChanges := False;
 {$ENDIF}

  dsItens.dataset := cdsItens;
end;

end.
