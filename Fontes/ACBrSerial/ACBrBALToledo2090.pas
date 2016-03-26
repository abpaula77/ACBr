{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
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

unit ACBrBALToledo2090;

interface

uses ACBrBALClass, Classes, Dialogs;

type
  TACBrBALToledo2090 = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);
    function LePeso( MillisecTimeOut : Integer = 3000) :Double; override;
    procedure LeSerial( MillisecTimeOut : Integer = 500) ; override ;
  end ;

implementation
Uses ACBrUtil, ACBrConsts,
     {$IFDEF COMPILER6_UP} DateUtils, StrUtils {$ELSE} ACBrD5, synaser, Windows{$ENDIF},
     SysUtils, Math ;

{ TACBrBALToledo }

constructor TACBrBALToledo2090.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'Toledo 2090' ;
end;

function TACBrBALToledo2090.LePeso( MillisecTimeOut : Integer) : Double;
begin
  fpUltimoPesoLido := 0 ;
  fpUltimaResposta := '' ;

  GravaLog('- '+FormatDateTime('hh:nn:ss:zzz',now)+' TX -> '+#05 );
  //fpDevice.Limpar ;                 { Limpa a Porta }
  fpDevice.EnviaString( #05 );      { Envia comando solicitando o Peso }
  sleep(200) ;

  LeSerial( MillisecTimeOut );

  Result := fpUltimoPesoLido ;
end;

procedure TACBrBALToledo2090.LeSerial(MillisecTimeOut: Integer);
Var
  Resposta : String ;
  Decimais : Integer ;
  Protocolo: String;
  lStrListDados : TStringList;
begin
  fpUltimaResposta := '' ;
  Protocolo        := '';
  try
    try
      fpUltimaResposta := fpDevice.LeString( MillisecTimeOut );
      GravaLog('- '+FormatDateTime('hh:nn:ss:zzz',now)+' RX <- '+fpUltimaResposta );

      lStrListDados := TStringList.Create;
      lStrListDados.Text := StringReplace(fpUltimaResposta,#$D,#13, [rfReplaceAll,rfIgnoreCase]);

       {PACOTE DE DADOS INVALIDO PARA PROCESSAR}
      if ((Copy(lStrListDados[1],2,1)  <> #2) and (Copy(lStrListDados[1],1,1) <> #2))
          or ((Length(lStrListDados[1]) <> 17) and (Length(lStrListDados[1]) <> 16)) then
        Exit;

      if Length(lStrListDados[1]) = 16 then
        Decimais := 1000
      else
        Decimais := 100;

      {APENAS BLOCO PROCESSADO}
      fpUltimaResposta := lStrListDados[1];
      Resposta := Copy(lStrListDados[1],5,7);
      fpUltimoPesoLido := 0;

      if Length(Resposta) > 0 then
      begin
        { Ajustando o separador de Decimal corretamente }
        Resposta := StringReplace(Resposta, '.', DecimalSeparator, [rfReplaceAll]);
        Resposta := StringReplace(Resposta, ',', DecimalSeparator, [rfReplaceAll]);
        try
          if pos(DecimalSeparator,Resposta) > 0 then  { J� existe ponto decimal ? }
            fpUltimoPesoLido := StrToFloat(Resposta)
          else
            fpUltimoPesoLido := StrToInt(Resposta) / Decimais ;

          case AnsiIndexText(Copy(lStrListDados[1],3,1),['x','r','s']) of
             0 : fpUltimoPesoLido := fpUltimoPesoLido  ;  { Instavel }
             1 : fpUltimoPesoLido := fpUltimoPesoLido*-1;  { Peso Negativo }
             2 : fpUltimoPesoLido := -10 ;  { Sobrecarga de Peso }
          end;
        except
          fpUltimoPesoLido := 0 ;
        end;
      end;
    finally
    end;
  except
    fpUltimoPesoLido := -9 ;
  end ;

  GravaLog('              UltimoPesoLido: '+FloatToStr(fpUltimoPesoLido)+
     ' , Resposta: '+Resposta+' - '+Protocolo );
end;

end.
