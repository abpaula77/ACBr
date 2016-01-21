{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{ Biblioteca multiplataforma de componentes Delphi para                        }
{ Emiss�o de Nota Fiscal de Servi�o                                            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2015 Italo Jurisato Junior                  }
{                                       Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrNFSeDANFSeRLClass;

interface

uses
 Forms, SysUtils, Classes, pnfsNFSe, ACBrNFSeDANFSeClass;

type
  TACBrNFSeDANFSeRL = class( TACBrNFSeDANFSeClass )
   private
   // Augusto Fontana
   protected
     FPrintDialog: Boolean;
   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDANFSe(NFSe : TNFSe = nil); override ;
    procedure ImprimirDANFSePDF(NFSe : TNFSe = nil); override ;
   // Augusto Fontana
   published
     property PrintDialog: Boolean read FPrintDialog write FPrintDialog;
  end;

implementation

uses
 StrUtils, Dialogs, ACBrUtil, ACBrNFSe, ACBrNFSeDANFSeRLRetrato;

constructor TACBrNFSeDANFSeRL.Create(AOwner: TComponent);
begin
  inherited create( AOwner );
  // Augusto Fontana
  FPrintDialog := True;
end;

destructor TACBrNFSeDANFSeRL.Destroy;
begin
  inherited Destroy ;
end;


procedure TACBrNFSeDANFSeRL.ImprimirDANFSe(NFSe : TNFSe = nil);
var
 i : Integer;
 frlDANFSeRLRetrato : TfrlDANFSeRLRetrato;
begin
 frlDANFSeRLRetrato := TfrlDANFSeRLRetrato.Create(Self);

 frlDANFSeRLRetrato.QuebradeLinha(TACBrNFSe(ACBrNFSe).Configuracoes.WebServices.QuebradeLinha);

 if NFSe = nil
  then begin
   for i:= 0 to TACBrNFSe(ACBrNFSe).NotasFiscais.Count-1 do
    begin
     frlDANFSeRLRetrato.Imprimir(Self,
                                 TACBrNFSe(ACBrNFSe).NotasFiscais.Items[i].NFSe
                                 , Logo
                                 , Email
                                 , Fax
                                 , NumCopias
                                 , Sistema
                                 , Site
                                 , Usuario
                                 , MostrarPreview
                                 , MargemSuperior
                                 , MargemInferior
                                 , MargemEsquerda
                                 , MargemDireita
                                 , Impressora
                                 , PrestLogo
                                 , Prefeitura
                                 , RazaoSocial
                                 , Endereco
                                 , Complemento
                                 , Fone
                                 , Municipio
                                 , InscMunicipal
                                 , EMail_Prestador
                                 , UF
                                 , T_InscEstadual
                                 , T_InscMunicipal
                                 , OutrasInformacaoesImp
                                 , Atividade
                                 , T_Fone
                                 , T_Endereco
                                 , T_Complemento
                                 , T_Email
                                 , PrintDialog);
    end;
  end
  else frlDANFSeRLRetrato.Imprimir( Self,
                                    NFSe
                                   , Logo
                                   , Email
                                   , Fax
                                   , NumCopias
                                   , Sistema
                                   , Site
                                   , Usuario
                                   , MostrarPreview
                                   , MargemSuperior
                                   , MargemInferior
                                   , MargemEsquerda
                                   , MargemDireita
                                   , Impressora
                                   , PrestLogo
                                   , Prefeitura
                                   , RazaoSocial
                                   , Endereco
                                   , Complemento
                                   , Fone
                                   , Municipio
                                   , InscMunicipal
                                   , EMail_Prestador
                                   , UF
                                   , T_InscEstadual
                                   , T_InscMunicipal
                                   , OutrasInformacaoesImp
                                   , Atividade
                                   , T_Fone
                                   , T_Endereco
                                   , T_Complemento
                                   , T_Email
                                   , PrintDialog);

 frlDANFSeRLRetrato.Free;
end;

procedure TACBrNFSeDANFSeRL.ImprimirDANFSePDF(NFSe : TNFSe = nil);
var
 NomeArq : String;
 i : Integer;
 frlDANFSeRLRetrato : TfrlDANFSeRLRetrato;
begin
 frlDANFSeRLRetrato := TfrlDANFSeRLRetrato.Create(Self);

 frlDANFSeRLRetrato.QuebradeLinha(TACBrNFSe(ACBrNFSe).Configuracoes.WebServices.QuebradeLinha);

 if NFSe = nil
  then begin
   for i:= 0 to TACBrNFSe(ACBrNFSe).NotasFiscais.Count-1 do
    begin
//     NomeArq :=  trim(TACBrNFSe(ACBrNFSe).NotasFiscais.Items[i].NomeArq);
//     if NomeArq=''
//      then begin
       NomeArq := StringReplace(TACBrNFSe(ACBrNFSe).NotasFiscais.Items[i].NFSe.Numero,'NFSe', '', [rfIgnoreCase]);
       NomeArq := PathWithDelim(Self.PathPDF)+NomeArq+'.pdf';
//      end
//      else NomeArq := StringReplace(NomeArq,'-nfse.xml', '.pdf', [rfIgnoreCase]);

{
class procedure TfrlDANFSeRL.SavePDF(AFile: String; ANFSe: TNFSe; ALogo, AEmail,
  AFax: String; ANumCopias: Integer; ASistema, ASite, AUsuario: String;
  AMargemSuperior, AMargemInferior, AMargemEsquerda, AMargemDireita: Double;
  APrestLogo, APrefeitura, ARazaoSocial, AEndereco, AComplemento, AFone, AMunicipio,
  AInscMunicipal, AEMail_Prestador, AUF, AT_InscEstadual, AT_InscMunicipal,
  AOutrasInformacaoesImp, AAtividade : String);
}

     frlDANFSeRLRetrato.SavePDF( Self
                               , NomeArq
                               , TACBrNFSe(ACBrNFSe).NotasFiscais.Items[i].NFSe
                               , Logo
                               , Email
                               , Fax
                               , NumCopias
                               , Sistema
                               , Site
                               , Usuario
                               , MargemSuperior
                               , MargemInferior
                               , MargemEsquerda
                               , MargemDireita
                               , PrestLogo
                               , Prefeitura
                               , RazaoSocial
                               , Endereco
                               , Complemento
                               , Fone
                               , Municipio
                               , InscMunicipal
                               , EMail_Prestador
                               , UF
                               , T_InscEstadual
                               , T_InscMunicipal
                               , OutrasInformacaoesImp
                               , Atividade
                               , T_Fone
                               , T_Endereco
                               , T_Complemento
                               , T_Email);
    end;
  end
  else begin
   NomeArq := StringReplace(NFSe.Numero,'NFSe', '', [rfIgnoreCase]);
   NomeArq := PathWithDelim(Self.PathPDF)+NomeArq+Trim(NFSe.IdentificacaoRps.Serie)+'-nfse.pdf';

   frlDANFSeRLRetrato.SavePDF( Self
                             , NomeArq
                             , NFSe
                             , Logo
                             , Email
                             , Fax
                             , NumCopias
                             , Sistema
                             , Site
                             , Usuario
                             , MargemSuperior
                             , MargemInferior
                             , MargemEsquerda
                             , MargemDireita
                             , PrestLogo
                             , Prefeitura
                             , RazaoSocial
                             , Endereco
                             , Complemento
                             , Fone
                             , Municipio
                             , InscMunicipal
                             , EMail_Prestador
                             , UF
                             , T_InscEstadual
                             , T_InscMunicipal
                             , OutrasInformacaoesImp
                             , Atividade
                             , T_Fone
                             , T_Endereco
                             , T_Complemento
                             , T_Email);
  end;

 frlDANFSeRLRetrato.Free;
end;

end.
