<?php
/* {******************************************************************************}
// { Projeto: Componentes ACBr                                                    }
// {  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
// { mentos de Automação Comercial utilizados no Brasil                           }
// {                                                                              }
// { Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
// {                                                                              }
// { Colaboradores nesse arquivo: Renato Rubinho                                  }
// {                                                                              }
// {  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
// { Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
// {                                                                              }
// {  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
// { sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
// { Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
// { qualquer versão posterior.                                                   }
// {                                                                              }
// {  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
// { NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
// { ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
// { do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
// {                                                                              }
// {  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
// { com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
// { no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
// { Você também pode obter uma copia da licença em:                              }
// { http://www.opensource.org/licenses/lgpl-license.php                          }
// {                                                                              }
// { Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
// {       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
// {******************************************************************************}
*/
header('Content-Type: application/json; charset=UTF-8');

include 'ACBrNFeMT.php';
include '../../ACBrComum/ACBrComum.php';

$nomeLib = "ACBrNFe";
$metodo = $_POST['metodo'];

if (ValidaFFI() != 0)
    exit;

$dllPath = CarregaDll(__DIR__, $nomeLib);

if ($dllPath == -10)
    exit;

$importsPath = CarregaImports(__DIR__, $nomeLib, 'MT');

if ($importsPath == -10)
    exit;

$iniPath = CarregaIniPath(__DIR__, $nomeLib);

$processo = "file_get_contents";
$ffi = CarregaContents($importsPath, $dllPath);
$handle = FFI::new("uintptr_t");

try {
    $resultado = "";
    $processo = "Inicializar";

    $processo = "NFE_Inicializar";
    if (Inicializar($handle, $ffi, $iniPath) != 0)
        exit;

    if ($metodo == "salvarConfiguracoes") {
        $processo = $metodo . "/" . "NFE_ConfigGravarValor";

        if (ConfigGravarValor($handle, $ffi, "NFe", "AtualizarXMLCancelado", $_POST['atualizarXml']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "ExibirErroSchema", $_POST['exibirErroSchema']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "FormatoAlerta", $_POST['formatoAlerta']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "FormaEmissao", $_POST['formaEmissao']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "ModeloDF", $_POST['modeloDF']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "VersaoDF", $_POST['versaoDF']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "RetirarAcentos", $_POST['retirarAcentos']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "SalvarGer", $_POST['SalvarGer']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "PathSalvar", $_POST['pathSalvar']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "PathSchemas", $_POST['pathSchemas']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "IdCSRT", $_POST['idCSRT']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "CSRT", $_POST['CSRT']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "SSLType", $_POST['SSLType']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "Timeout", $_POST['timeout']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "Ambiente", $_POST['ambiente']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "Visualizar", $_POST['visualizar']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "SalvarWS", $_POST['SalvarWS']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "AjustaAguardaConsultaRet", $_POST['ajustaAguardaConsultaRet']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "AguardarConsultaRet", $_POST['aguardarConsultaRet']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "Tentativas", $_POST['tentativas']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "IntervaloTentativas", $_POST['intervaloTentativas']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "SalvarArq", $_POST['SalvarArq']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "SepararPorMes", $_POST['SepararPorMes']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "AdicionarLiteral", $_POST['AdicionarLiteral']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "EmissaoPathNFe", $_POST['EmissaoPathNFe']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "SalvarEvento", $_POST['SalvarEvento']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "SepararPorCNPJ", $_POST['SepararPorCNPJ']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "SepararPorModelo", $_POST['SepararPorModelo']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "PathNFe", $_POST['PathNFe']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "PathInu", $_POST['PathInu']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "NFe", "PathEvento", $_POST['PathEvento']) != 0) exit;

        if (ConfigGravarValor($handle, $ffi, "Proxy", "Servidor", $_POST['proxyServidor']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Proxy", "Porta", $_POST['proxyPorta']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Proxy", "Usuario", $_POST['proxyUsuario']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Proxy", "Senha", $_POST['proxySenha']) != 0) exit;

        if (ConfigGravarValor($handle, $ffi, "DFe", "UF", $_POST['UF']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "DFe", "SSLCryptLib", $_POST['SSLCryptLib']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "DFe", "SSLHttpLib", $_POST['SSLHttpLib']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "DFe", "SSLXmlSignLib", $_POST['SSLXmlSignLib']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "DFe", "ArquivoPFX", $_POST['ArquivoPFX']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "DFe", "DadosPFX", $_POST['DadosPFX']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "DFe", "Senha", $_POST['senhaCertificado']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "DFe", "NumeroSerie", $_POST['NumeroSerie']) != 0) exit;

        if (ConfigGravarValor($handle, $ffi, "DANFE", "PathLogo", $_POST['PathLogo']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "DANFE", "TipoDANFE", $_POST['TipoDANFE']) != 0) exit;
        // Mesmo caminho da pasta para salvar aquivos da NFe
        if (ConfigGravarValor($handle, $ffi, "DANFE", "PathPDF", $_POST['PathNFe']) != 0) exit;

        if (ConfigGravarValor($handle, $ffi, "DANFENFCe", "TipoRelatorioBobina", $_POST['TipoRelatorioBobina']) != 0) exit;

        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "Modelo", $_POST['PosPrinterModelo']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "PaginaDeCodigo", $_POST['PaginaDeCodigo']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "Porta", $_POST['PosPrinterPorta']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "ColunasFonteNormal", $_POST['ColunasFonteNormal']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "EspacoEntreLinhas", $_POST['EspacoEntreLinhas']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "LinhasBuffer", $_POST['LinhasBuffer']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "LinhasEntreCupons", $_POST['LinhasEntreCupons']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "ControlePorta", $_POST['ControlePorta']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "TraduzirTags", $_POST['TraduzirTags']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "CortaPapel", $_POST['CortaPapel']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "PosPrinter", "IgnorarTags", $_POST['IgnorarTags']) != 0) exit;

        if (ConfigGravarValor($handle, $ffi, "Email", "Nome", $_POST['emailNome']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Email", "Conta", $_POST['emailConta']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Email", "Servidor", $_POST['emailServidor']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Email", "Porta", $_POST['emailPorta']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Email", "SSL", $_POST['emailSSL']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Email", "TLS", $_POST['emailTLS']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Email", "Usuario", $_POST['emailUsuario']) != 0) exit;
        if (ConfigGravarValor($handle, $ffi, "Email", "Senha", $_POST['emailSenha']) != 0) exit;

        $resultado = "Configurações salvas com sucesso.";
    }

    if ($metodo == "carregarConfiguracoes") {
        $processo = $metodo . "/" . "NFE_ConfigLer";

        if (ConfigLerValor($handle, $ffi, "NFe", "AtualizarXMLCancelado", $atualizarXml) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "ExibirErroSchema", $exibirErroSchema) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "FormatoAlerta", $formatoAlerta) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "FormaEmissao", $formaEmissao) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "ModeloDF", $modeloDF) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "VersaoDF", $versaoDF) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "RetirarAcentos", $retirarAcentos) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "SalvarGer", $SalvarGer) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "PathSalvar", $pathSalvar) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "PathSchemas", $pathSchemas) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "IdCSRT", $idCSRT) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "CSRT", $CSRT) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "SSLType", $SSLType) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "Timeout", $timeout) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "Ambiente", $ambiente) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "Visualizar", $visualizar) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "SalvarWS", $SalvarWS) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "AjustaAguardaConsultaRet", $ajustaAguardaConsultaRet) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "AguardarConsultaRet", $aguardarConsultaRet) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "Tentativas", $tentativas) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "IntervaloTentativas", $intervaloTentativas) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "SalvarArq", $SalvarArq) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "SepararPorMes", $SepararPorMes) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "AdicionarLiteral", $AdicionarLiteral) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "EmissaoPathNFe", $EmissaoPathNFe) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "SalvarEvento", $SalvarEvento) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "SepararPorCNPJ", $SepararPorCNPJ) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "SepararPorModelo", $SepararPorModelo) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "PathNFe", $PathNFe) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "PathInu", $PathInu) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "NFe", "PathEvento", $PathEvento) != 0) exit;

        if (ConfigLerValor($handle, $ffi, "Proxy", "Servidor", $proxyServidor) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Proxy", "Porta", $proxyPorta) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Proxy", "Usuario", $proxyUsuario) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Proxy", "Senha", $proxySenha) != 0) exit;

        if (ConfigLerValor($handle, $ffi, "DFe", "UF", $UF) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "DFe", "SSLCryptLib", $SSLCryptLib) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "DFe", "SSLHttpLib", $SSLHttpLib) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "DFe", "SSLXmlSignLib", $SSLXmlSignLib) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "DFe", "ArquivoPFX", $ArquivoPFX) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "DFe", "DadosPFX", $DadosPFX) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "DFe", "Senha", $senhaCertificado) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "DFe", "NumeroSerie", $NumeroSerie) != 0) exit;

        if (ConfigLerValor($handle, $ffi, "DANFE", "PathLogo", $PathLogo) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "DANFE", "TipoDANFE", $TipoDANFE) != 0) exit;

        if (ConfigLerValor($handle, $ffi, "DANFENFCe", "TipoRelatorioBobina", $TipoRelatorioBobina) != 0) exit;

        if (ConfigLerValor($handle, $ffi, "PosPrinter", "Modelo", $PosPrinterModelo) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "PaginaDeCodigo", $PaginaDeCodigo) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "Porta", $PosPrinterPorta) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "ColunasFonteNormal", $ColunasFonteNormal) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "EspacoEntreLinhas", $EspacoEntreLinhas) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "LinhasBuffer", $LinhasBuffer) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "LinhasEntreCupons", $LinhasEntreCupons) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "ControlePorta", $ControlePorta) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "TraduzirTags", $TraduzirTags) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "CortaPapel", $CortaPapel) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "PosPrinter", "IgnorarTags", $IgnorarTags) != 0) exit;

        if (ConfigLerValor($handle, $ffi, "Email", "Nome", $emailNome) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Email", "Conta", $emailConta) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Email", "Servidor", $emailServidor) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Email", "Porta", $emailPorta) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Email", "SSL", $emailSSL) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Email", "TLS", $emailTLS) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Email", "Usuario", $emailUsuario) != 0) exit;
        if (ConfigLerValor($handle, $ffi, "Email", "Senha", $emailSenha) != 0) exit;

        $processo = $metodo . "/" . "responseData";
        $responseData = [
            'dados' => [
                'atualizarXml' => $atualizarXml ?? '',
                'exibirErroSchema' => $exibirErroSchema ?? '',
                'formatoAlerta' => $formatoAlerta ?? '',
                'formaEmissao' => $formaEmissao ?? '',
                'modeloDF' => $modeloDF ?? '',
                'versaoDF' => $versaoDF ?? '',
                'retirarAcentos' => $retirarAcentos ?? '',
                'SalvarGer' => $SalvarGer ?? '',
                'pathSalvar' => $pathSalvar ?? '',
                'pathSchemas' => $pathSchemas ?? '',
                'idCSRT' => $idCSRT ?? '',
                'CSRT' => $CSRT ?? '',
                'SSLType' => $SSLType ?? '',
                'timeout' => $timeout ?? '',
                'ambiente' => $ambiente ?? '',
                'visualizar' => $visualizar ?? '',
                'SalvarWS' => $SalvarWS ?? '',
                'ajustaAguardaConsultaRet' => $ajustaAguardaConsultaRet ?? '',
                'aguardarConsultaRet' => $aguardarConsultaRet ?? '',
                'tentativas' => $tentativas ?? '',
                'intervaloTentativas' => $intervaloTentativas ?? '',
                'SalvarArq' => $SalvarArq ?? '',
                'SepararPorMes' => $SepararPorMes ?? '',
                'AdicionarLiteral' => $AdicionarLiteral ?? '',
                'EmissaoPathNFe' => $EmissaoPathNFe ?? '',
                'SalvarEvento' => $SalvarEvento ?? '',
                'SepararPorCNPJ' => $SepararPorCNPJ ?? '',
                'SepararPorModelo' => $SepararPorModelo ?? '',
                'PathNFe' => $PathNFe ?? '',
                'PathInu' => $PathInu ?? '',
                'PathEvento' => $PathEvento ?? '',

                'proxyServidor' => $proxyServidor ?? '',
                'proxyPorta' => $proxyPorta ?? '',
                'proxyUsuario' => $proxyUsuario ?? '',
                'proxySenha' => $proxySenha ?? '',

                'UF' => $UF ?? '',
                'SSLCryptLib' => $SSLCryptLib ?? '',
                'SSLHttpLib' => $SSLHttpLib ?? '',
                'SSLXmlSignLib' => $SSLXmlSignLib ?? '',
                'ArquivoPFX' => $ArquivoPFX ?? '',
                'DadosPFX' => $DadosPFX ?? '',
                'senhaCertificado' => $senhaCertificado ?? '',
                'NumeroSerie' => $NumeroSerie ?? '',

                'PathLogo' => $PathLogo ?? '',
                'TipoDANFE' => $TipoDANFE ?? '',

                'TipoRelatorioBobina' => $TipoRelatorioBobina ?? '',

                'PosPrinterModelo' => $PosPrinterModelo ?? '',
                'PaginaDeCodigo' => $PaginaDeCodigo ?? '',
                'PosPrinterPorta' => $PosPrinterPorta ?? '',
                'ColunasFonteNormal' => $ColunasFonteNormal ?? '',
                'EspacoEntreLinhas' => $EspacoEntreLinhas ?? '',
                'LinhasBuffer' => $LinhasBuffer ?? '',
                'LinhasEntreCupons' => $LinhasEntreCupons ?? '',
                'ControlePorta' => $ControlePorta ?? '',
                'TraduzirTags' => $TraduzirTags ?? '',
                'CortaPapel' => $CortaPapel ?? '',
                'IgnorarTags' => $IgnorarTags ?? '',

                'emailNome' => $emailNome ?? '',
                'emailConta' => $emailConta ?? '',
                'emailServidor' => $emailServidor ?? '',
                'emailPorta' => $emailPorta ?? '',
                'emailSSL' => $emailSSL ?? '',
                'emailTLS' => $emailTLS ?? '',
                'emailUsuario' => $emailUsuario ?? '',
                'emailSenha' => $emailSenha ?? ''
            ]
        ];
    }

    if ($metodo == "statusServico") {
        $processo = "NFE_StatusServico";

        if (StatusServico($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "OpenSSLInfo") {
        $processo = "NFE_OpenSSLInfo";

        if (OpenSSLInfo($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "CarregarXmlNfe") {
        $processo = "NFE_CarregarXml";

        if (CarregarXmlNfe($handle, $ffi, $_POST['conteudoArquivo01'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "CarregarIniNfe") {
        $processo = "NFE_CarregarINI";

        if (CarregarINI($handle, $ffi, $_POST['conteudoArquivo01'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "CarregarEventoXML") {
        $processo = "NFE_CarregarEventoXml";

        if (CarregarEventoXML($handle, $ffi, $_POST['conteudoArquivo01'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "LimparListaNfe") {
        $processo = "NFE_LimparListaNfe";

        if (LimparListaNfe($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "LimparListaEventos") {
        $processo = "NFE_LimparListaEventos";

        if (LimparListaEventos($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "AssinarNFe") {
        $processo = "NFE_AssinarNFe";

        if (AssinarNFe($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ValidarNFe") {
        $processo = "NFE_ValidarNFe";

        if (ValidarNFe($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ValidarRegrasdeNegocios") {
        $processo = "NFE_CarregarXml";

        if (CarregarXmlNfe($handle, $ffi, $_POST['AeArquivoXmlNFe'], $resultado) != 0) {
            exit;
        }

        $processo = "NFE_ValidarRegrasdeNegocios";

        if (ValidarRegrasdeNegocios($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "GerarChave") {
        $processo = "NFE_GerarChave";

        if (GerarChave(
            $handle,
            $ffi,
            $_POST['ACodigoUF'],
            $_POST['ACodigoNumerico'],
            $_POST['AModelo'],
            $_POST['ASerie'],
            $_POST['ANumero'],
            $_POST['ATpEmi'],
            $_POST['AEmissao'],
            $_POST['ACNPJCPF'],
            $resultado
        ) != 0) {
            exit;
        }
    }

    if ($metodo == "Consultar") {
        $processo = "NFE_Consultar";

        if (Consultar($handle, $ffi, $_POST['eChaveOuNFe'], $_POST['AExtrairEventos'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "Inutilizar") {
        $processo = "NFE_Inutilizar";

        if (Inutilizar(
            $handle,
            $ffi,
            $_POST['ACNPJ'],
            $_POST['AJustificativa'],
            $_POST['AAno'],
            $_POST['AModelo'],
            $_POST['ASerie'],
            $_POST['ANumeroInicial'],
            $_POST['ANumeroFinal'],
            $resultado
        ) != 0) {
            exit;
        }
    }

    if ($metodo == "Enviar") {
        if ($_POST['tipoArquivo'] == "xml") {
            $processo = "NFE_CarregarXml";

            if (CarregarXmlNfe($handle, $ffi, $_POST['AeArquivoNFe'], $resultado) != 0) {
                exit;
            }
        } else {
            $processo = "NFE_CarregarINI";

            if (CarregarINI($handle, $ffi, $_POST['AeArquivoNFe'], $resultado) != 0) {
                exit;
            }
        }

        $processo = "NFE_AssinarNFe";

        if (AssinarNFe($handle, $ffi, $resultado) != 0) {
            exit;
        }

        $processo = "NFE_Enviar";

        if (Enviar(
            $handle,
            $ffi,
            $_POST['ALote'],
            $_POST['AImprimir'],
            $_POST['ASincrono'],
            $_POST['AZipado'],
            $resultado
        ) != 0) {
            exit;
        }
    }

    if ($metodo == "ConsultarRecibo") {
        $processo = "NFE_ConsultarRecibo";

        if (ConsultarRecibo($handle, $ffi, $_POST['ARecibo'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "Cancelar") {
        $processo = "NFE_Cancelar";

        if (Cancelar($handle, $ffi, $_POST['AeChave'], $_POST['AeJustificativa'], $_POST['AeCNPJCPF'], $_POST['ALote'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "EnviarEvento") {
        $processo = "NFE_CarregarXml";

        if (CarregarXmlNfe($handle, $ffi, $_POST['AeArquivoXmlNFe'], $resultado) != 0) {
            exit;
        }

        $processo = "NFE_CarregarEventoXml";

        if (CarregarEventoXML($handle, $ffi, $_POST['AeArquivoXmlEvento'], $resultado) != 0) {
            exit;
        }

        $processo = "NFE_EnviarEvento";

        if (EnviarEvento($handle, $ffi, $_POST['AidLote'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ConsultaCadastro") {
        $processo = "NFE_ConsultaCadastro";

        if (ConsultaCadastro($handle, $ffi, $_POST['AcUF'], $_POST['AnDocumento'], $_POST['AnIE'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "DistribuicaoDFePorUltNSU") {
        $processo = "NFE_DistribuicaoDFePorUltNSU";

        if (DistribuicaoDFePorUltNSU($handle, $ffi, $_POST['AcUFAutor'], $_POST['AeCNPJCPF'], $_POST['AeultNSU'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "DistribuicaoDFePorNSU") {
        $processo = "NFE_DistribuicaoDFePorNSU";

        if (DistribuicaoDFePorNSU($handle, $ffi, $_POST['AcUFAutor'], $_POST['AeCNPJCPF'], $_POST['AeNSU'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "DistribuicaoDFePorChave") {
        $processo = "NFE_DistribuicaoDFePorChave";

        if (DistribuicaoDFePorChave($handle, $ffi, $_POST['AcUFAutor'], $_POST['AeCNPJCPF'], $_POST['AechNFe'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "EnviarEmail") {
        $processo = "NFE_CarregarXml";

        if (CarregarXmlNfe($handle, $ffi, $_POST['AeArquivoXmlNFe'], $resultado) != 0) {
            exit;
        }

        $processo = "NFE_EnviarEmail";

        if (EnviarEmail($handle, $ffi, $_POST['AePara'], $_POST['AeChaveNFe'], $_POST['AEnviaPDF'], $_POST['AeAssunto'], $_POST['AeCC'], $_POST['AeAnexos'], $_POST['AeMensagem'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "EnviarEmailEvento") {
        $processo = "NFE_EnviarEmailEvento";

        if (EnviarEmailEvento($handle, $ffi, $_POST['AePara'], $_POST['AeChaveEvento'], $_POST['AeChaveNFe'], $_POST['AEnviaPDF'], $_POST['AeAssunto'], $_POST['AeCC'], $_POST['AeAnexos'], $_POST['AeMensagem'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ImprimirPDF") {
        $processo = "NFE_CarregarXml";

        if (CarregarXmlNfe($handle, $ffi, $_POST['AeArquivoXmlNFe'], $resultado) != 0) {
            exit;
        }

        $processo = "NFE_ImprimirPDF";

        if (ImprimirPDF($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "SalvarPDF") {
        $processo = "NFE_CarregarXml";

        if (CarregarXmlNfe($handle, $ffi, $_POST['AeArquivoXmlNFe'], $resultado) != 0) {
            exit;
        }

        $processo = "NFE_SalvarPDF";

        if (SalvarPDF($handle, $ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ImprimirEventoPDF") {
        $processo = "NFE_ImprimirEventoPDF";

        if (ImprimirEventoPDF($handle, $ffi, $_POST['AeArquivoXmlNFe'], $_POST['AeArquivoXmlEvento'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "SalvarEventoPDF") {
        $processo = "NFE_SalvarEventoPDF";

        if (SalvarEventoPDF($handle, $ffi, $_POST['AeArquivoXmlNFe'], $_POST['AeArquivoXmlEvento'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ImprimirInutilizacaoPDF") {
        $processo = "NFE_ImprimirInutilizacaoPDF";

        if (ImprimirInutilizacaoPDF($handle, $ffi, $_POST['AeArquivoXml'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "SalvarInutilizacaoPDF") {
        $processo = "NFE_SalvarInutilizacaoPDF";

        if (SalvarInutilizacaoPDF($handle, $ffi, $_POST['AeArquivoXml'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo != "carregarConfiguracoes") {
        $processo = "responseData";
        $responseData = [
            'mensagem' => $resultado
        ];
    }
} catch (Exception $e) {
    $erro = $e->getMessage();
    echo json_encode(["mensagem" => "Exceção[$processo]: $erro"]);
    exit;
}

try {
    if ($processo != "NFE_Inicializar") {
        $processo = "NFE_Finalizar";
        if (Finalizar($handle, $ffi) != 0)
            exit;
    }
} catch (Exception $e) {
    $erro = $e->getMessage();
    echo json_encode(["mensagem" => "Exceção[$processo]: $erro"]);
    exit;
}

echo json_encode($responseData);