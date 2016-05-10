{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Fabio Farias                           }
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

unit ACBrBALGenerica;

interface
uses ACBrBALClass, ACBrConsts,
     Classes;

type

  TACBrBALGenerica = class( TACBrBALClass )
  public
    constructor Create(AOwner: TComponent);
    function LePeso( MillisecTimeOut : Integer = 3000) :Double; override;
    procedure LeSerial( MillisecTimeOut : Integer = 500) ; override ;
  end ;

implementation
Uses ACBrUtil,
     {$IFDEF COMPILER6_UP} DateUtils, StrUtils {$ELSE} ACBrD5, Windows{$ENDIF},
     SysUtils, Math ;

{ TACBrBALGenerica }

constructor TACBrBALGenerica.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'Gen�rica' ;
end;

function TACBrBALGenerica.LePeso( MillisecTimeOut : Integer) : Double;
Var
  TempoFinal : TDateTime ;
begin
   Result := 0;
   fpUltimoPesoLido := 0 ;
   fpUltimaResposta := '' ;
   TempoFinal := IncMilliSecond(now, MillisecTimeOut) ;

   GravaLog('- '+FormatDateTime('hh:nn:ss:zzz',now)+' TX -> '+#05 );
   
   while (Result <= 0) and (TempoFinal > now) do
   begin
      fpDevice.Limpar ;                 { Limpa a Porta }
      fpDevice.EnviaString( #05 );      { Envia comando solicitando o Peso }
      Sleep(200) ;
      MillisecTimeOut := MilliSecondsBetween(Now, TempoFinal) ;

      LeSerial( MillisecTimeOut );

      Result := fpUltimoPesoLido ;
   end;
end;

procedure TACBrBALGenerica.LeSerial( MillisecTimeOut : Integer);
Var 
  Resposta : AnsiString ;
  Decimais : Integer ;
begin
   fpUltimoPesoLido := 0 ;
   fpUltimaResposta := '' ;

  Decimais := 1000 ;
   Try
     fpUltimaResposta := fpDevice.LeString( MillisecTimeOut );
      GravaLog('- '+FormatDateTime('hh:nn:ss:zzz',now)+' RX <- '+fpUltimaResposta );

      Resposta := Trim( Copy( fpUltimaResposta, fpPosIni, fpPosFim)) ;

      { Ajustando o separador de Decimal corretamente }
      Resposta := StringReplace(Resposta, '.', DecimalSeparator, [rfReplaceAll]);
      Resposta := StringReplace(Resposta, ',', DecimalSeparator, [rfReplaceAll]);

      try
        if pos(DecimalSeparator,Resposta) > 0 then  { J� existe ponto decimal ? }
            fpUltimoPesoLido := StrToFloat(Resposta)
         else
           fpUltimoPesoLido := StrToInt(Resposta) / Decimais ;
      except
        case Resposta[1] of
            'I' : fpUltimoPesoLido := -1  ;  { Instavel }
            'N' : fpUltimoPesoLido := -2  ;  { Peso Negativo }
            'S' : fpUltimoPesoLido := -10 ;  { Sobrecarga de Peso }
         else
            fpUltimoPesoLido := 0 ;
         end;
      end;
   except
      { Peso n�o foi recebido (TimeOut) }
      fpUltimoPesoLido := -9 ;
   end ;

  GravaLog('              UltimoPesoLido: '+FloatToStr(fpUltimoPesoLido)+' , Resposta: '+Resposta );
end;

end.
