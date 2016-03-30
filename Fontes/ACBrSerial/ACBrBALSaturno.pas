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

{******************************************************************************
|* Historico
|*
|* 29/03/2016: Wislei de Brito Fernandes
|*  - Primeira Versao ACBrBALSaturno
******************************************************************************}

{$I ACBr.inc}

unit ACBrBALSaturno;

interface
uses ACBrBALClass,
     Classes;

type
 TACBrBALSaturno = class( TACBrBALClass )
  public
    constructor Create(AOwner: TComponent);
    function LePeso( MillisecTimeOut : Integer = 3000) :Double; override;
    procedure LeSerial( MillisecTimeOut : Integer = 500) ; override ;
  end ;

implementation
Uses ACBrUtil, ACBrConsts,
     {$IFDEF COMPILER6_UP} DateUtils, StrUtils {$ELSE} synaser, Windows{$ENDIF},
     SysUtils, Math, ACBrDevice,dialogs ;

{ TACBrBALSaturno }

constructor TACBrBALSaturno.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'Saturno' ;
end;

function TACBrBALSaturno.LePeso( MillisecTimeOut : Integer) : Double;
begin
  fpUltimoPesoLido := 0 ;
  fpUltimaResposta := '' ;

  GravaLog('- '+FormatDateTime('hh:nn:ss:zzz',now)+' TX -> '+#05 );
  fpDevice.Limpar;                  { Limpa a Porta }
  fpDevice.EnviaString( #05 );      { Envia comando solicitando o Peso }
  sleep(200) ;

  LeSerial( MillisecTimeOut );

  Result := fpUltimoPesoLido ;
end;

procedure TACBrBALSaturno.LeSerial(MillisecTimeOut: Integer);
Var
  Resposta : AnsiString ;
  bAchouE_O: Boolean;
  posicaoE_O : Integer ;
begin
  fpUltimoPesoLido := 0 ;
  fpUltimaResposta := '' ;
  Try
    fpUltimaResposta := trim(fpDevice.Serial.RecvPacket( MillisecTimeOut));
    bAchouE_O := False;

    // Se encontrar a letra 'E' (Est�vel) ou 'O' (Oscilante), captura o peso da
    // posi��o 1 a 7 da string
    if (Pos('E',UpperCase(fpUltimaResposta)) > 0) or (Pos('O',UpperCase(fpUltimaResposta)) > 0) then
    begin
      if Pos('E',UpperCase(fpUltimaResposta)) > 0 then
        posicaoE_O := Pos('E',UpperCase(fpUltimaResposta))
      else
        posicaoE_O := Pos('O',UpperCase(fpUltimaResposta));

      bAchouE_O := True;

      Resposta := Copy(fpUltimaResposta,0 , posicaoE_O - 1);
    end;

    // Removendo caracteres especiais, caso encontre algum
    if bAchouE_O then
    begin
      Resposta := StringReplace(Resposta, '�', '0', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '1', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '2', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '3', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '4', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '5', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '6', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '7', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '8', [rfReplaceAll]);
      Resposta := StringReplace(Resposta, '�', '9', [rfReplaceAll]);
    end;

    if Length(Resposta) > 0 then
    begin
      try
        fpUltimoPesoLido := StrToFloat(Resposta);
      except
        case Resposta[1] of
          'I' : fpUltimoPesoLido := -1  ;  { Instavel }
          'N' : fpUltimoPesoLido := -2  ;  { Peso Negativo }
          'S' : fpUltimoPesoLido := -10 ;  { Sobrecarga de Peso }
        else
          fpUltimoPesoLido := 0 ;
        end;
      end;
    end
    else
      fpUltimoPesoLido := 0 ;
  except
    { Peso n�o foi recebido (TimeOut) }
    fpUltimoPesoLido := -9 ;
  end ;
end;

end.

