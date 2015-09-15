{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - NFe - http://www.nfe.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2015 Juliomar Marchetti                     }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

{*******************************************************************************
|* Historico
|*
*******************************************************************************}

{$I ACBr.inc}

unit ACBrNFeDAInutRL;


interface

uses
  SysUtils, Variants, Classes, StrUtils,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}
      Graphics, Controls, Forms, Dialogs, ExtCtrls,
  {$ENDIF}
  pcnNFe, pcnConversao, ACBrNFe, ACBrNFeDANFeRLClass, ACBrUtil,
  ACBrNFeRLCodeBar, Printers,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts,
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB;

type

  { TfrmNFeDAInutRL }

  TfrmNFeDAInutRL = class(TForm)
    DataSource1: TDataSource;
    RLNFeInut: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
    procedure FormDestroy(Sender: TObject);
  private

  protected
    FACBrNFe        : TACBrNFe;
    FNFe            : TNFe;
    FLogo           : String;
    FNumCopias      : Integer;
    FSistema        : String;
    FUsuario        : String;
    FMostrarPreview : Boolean;
    FMargemSuperior : Double;
    FMargemInferior : Double;
    FMargemEsquerda : Double;
    FMargemDireita  : Double;
    FImpressora     : String;

    procedure SetBarCodeImage(ACode: String; RLImage: TRLImage);
  public
    class procedure Imprimir(AACBrNFe: TACBrNFe;
                             ALogo: String = '';
                             ANumCopias: Integer = 1;
                             ASistema: String = '';
                             AUsuario: String = '';
                             AMostrarPreview: Boolean = True;
                             AMargemSuperior: Double = 0.7;
                             AMargemInferior: Double = 0.7;
                             AMargemEsquerda: Double = 0.7;
                             AMargemDireita: Double = 0.7;
                             AImpressora: String = '';
                             ANFe: TNFe = nil);

    class procedure SavePDF(AACBrNFe: TACBrNFe;
                            ALogo: String = '';
                            AFile: String = '';
                            ASistema: String = '';
                            AUsuario: String = '';
                            AMargemSuperior: Double = 0.7;
                            AMargemInferior: Double = 0.7;
                            AMargemEsquerda: Double = 0.7;
                            AMargemDireita: Double = 0.7;
                            ANFe: TNFe = nil);
  end;

implementation

uses
  MaskUtils;


{$R *.dfm}

class procedure TfrmNFeDAInutRL.Imprimir(AACBrNFe: TACBrNFe;
                                         ALogo: String = '';
                                         ANumCopias: Integer = 1;
                                         ASistema: String = '';
                                         AUsuario: String = '';
                                         AMostrarPreview: Boolean = True;
                                         AMargemSuperior: Double = 0.7;
                                         AMargemInferior: Double = 0.7;
                                         AMargemEsquerda: Double = 0.7;
                                         AMargemDireita: Double = 0.7;
                                         AImpressora: String = '';
                                         ANFe: TNFe = nil);
begin
  with Create(nil) do
     try
        FACBrNFe        := AACBrNFe;
        FLogo           := ALogo;
        FNumCopias      := ANumCopias;
        FSistema        := ASistema;
        FUsuario        := AUsuario;
        FMostrarPreview := AMostrarPreview;
        FMargemSuperior := AMargemSuperior;
        FMargemInferior := AMargemInferior;
        FMargemEsquerda := AMargemEsquerda;
        FMargemDireita  := AMargemDireita;
        FImpressora     := AImpressora;

        if ANFe <> nil then
         FNFe := ANFe;

        if FImpressora > '' then
          RLPrinter.PrinterName := FImpressora;

        if FNumCopias > 0 then
          RLPrinter.Copies := FNumCopias
        else
          RLPrinter.Copies := 1;

        if AMostrarPreview then
         begin
           RLNFeInut.Prepare;
           RLNFeInut.Preview;
           Application.ProcessMessages;
         end else
         begin
           FMostrarPreview := True;
           RLNFeInut.Prepare;
           RLNFeInut.Print;
         end;
     finally
        RLNFeInut.Free;
        RLNFeInut := nil;
        Printer.Free;
        Free;
     end;
end;

class procedure TfrmNFeDAInutRL.SavePDF(AACBrNFe: TACBrNFe;
                                        ALogo: String = '';
                                        AFile: String = '';
                                        ASistema: String = '';
                                        AUsuario: String = '';
                                        AMargemSuperior: Double = 0.7;
                                        AMargemInferior: Double = 0.7;
                                        AMargemEsquerda: Double = 0.7;
                                        AMargemDireita: Double = 0.7;
                                        ANFe: TNFe = nil);
var
   i :integer;
begin
  with Create ( nil ) do
     try
        FACBrNFe        := AACBrNFe;
        FLogo           := ALogo;
        FSistema        := ASistema;
        FUsuario        := AUsuario;
        FMargemSuperior := AMargemSuperior;
        FMargemInferior := AMargemInferior;
        FMargemEsquerda := AMargemEsquerda;
        FMargemDireita  := AMargemDireita;

        if ANFe <> nil then
          FNFe := ANFe;

        for i := 0 to ComponentCount -1 do
          begin
            if (Components[i] is TRLDraw) and (TRLDraw(Components[i]).DrawKind = dkRectangle) then
              begin
                TRLDraw(Components[i]).DrawKind := dkRectangle;
                TRLDraw(Components[i]).Pen.Width := 1;
              end;
          end;

        FMostrarPreview := True;
        RLNFeInut.Prepare;

        with RLPDFFilter1.DocumentInfo do
        begin
          Title := ACBrStr('Inutiliza��o - Nota fiscal n� ' +
                                      FormatFloat('000,000,000', FNFe.Ide.nNF));
          KeyWords := ACBrStr('N�mero:' + FormatFloat('000,000,000', FNFe.Ide.nNF) +
                      '; Data de emiss�o: ' + FormatDateTime('dd/mm/yyyy', FNFe.Ide.dEmi) +
                      '; Destinat�rio: ' + FNFe.Dest.xNome +
                      '; CNPJ: ' + FNFe.Dest.CNPJCPF );
        end;

        RLNFeInut.SaveToFile(AFile);
     finally
        Free;
     end;
end;

procedure TfrmNFeDAInutRL.SetBarCodeImage(ACode: String; RLImage: TRLImage);
var
  b: TBarCode128c;
begin
  b := TBarCode128c.Create;
  try
    b.Code := ACode;
    b.PaintCodeToCanvas(ACode, RLImage.Canvas, RLImage.ClientRect);
  finally
    b.free;
  end;
end;

procedure TfrmNFeDAInutRL.FormDestroy(Sender: TObject);
begin
  RLNFeInut.Free;
end;

end.

