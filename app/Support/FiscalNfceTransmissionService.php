<?php

namespace App\Support;

use App\Models\NotaFiscal;
use Carbon\Carbon;
use DOMDocument;
use DOMElement;
use DOMXPath;
use RuntimeException;

class FiscalNfceTransmissionService
{
    public function __construct(
        private readonly FiscalCertificateService $fiscalCertificateService,
        private readonly FiscalWebserviceResolverService $fiscalWebserviceResolverService,
    ) {
    }

    public function transmit(NotaFiscal $invoice): NotaFiscal
    {
        $invoice->loadMissing([
            'pagamento.vendas.produto',
            'pagamento.vendas.unidade',
            'configuracaoFiscal',
        ]);

        $configuration = $invoice->configuracaoFiscal;

        if (! $configuration) {
            throw new RuntimeException('A nota nao possui configuracao fiscal vinculada.');
        }

        if ($invoice->tb27_modelo !== 'nfce') {
            throw new RuntimeException('Nesta etapa a transmissao automatica esta disponivel apenas para NFC-e.');
        }

        if (! filled($invoice->tb27_xml_envio)) {
            throw new RuntimeException('A nota ainda nao possui XML assinado para transmissao.');
        }

        try {
            $certificateData = $this->fiscalCertificateService->loadCertificateForConfiguration($configuration);
            $endpoints = $this->fiscalWebserviceResolverService->resolveNfceEndpoints(
                (string) $configuration->tb26_uf,
                (string) $configuration->tb26_ambiente,
            );

            $lotXml = $this->buildBatchXml($invoice->tb27_xml_envio, (int) $invoice->tb4_id);
            $soapEnvelope = $this->buildSoapEnvelope(
                $lotXml,
                (string) $configuration->tb26_codigo_municipio,
            );

            $responseXml = $this->sendSoapRequest(
                $endpoints['authorization'],
                $endpoints['authorization_operation'],
                $soapEnvelope,
                $certificateData,
            );

            $parsed = $this->parseAuthorizationResponse($responseXml);

            $invoice->update([
                'tb27_status' => $parsed['status'],
                'tb27_chave_acesso' => $parsed['access_key'] ?? $invoice->tb27_chave_acesso,
                'tb27_protocolo' => $parsed['protocol'] ?? $invoice->tb27_protocolo,
                'tb27_recibo' => $parsed['receipt'] ?? $invoice->tb27_recibo,
                'tb27_xml_retorno' => $responseXml,
                'tb27_mensagem' => $parsed['message'],
                'tb27_emitida_em' => $parsed['emitted_at'],
                'tb27_ultima_tentativa_em' => now(),
            ]);
        } catch (RuntimeException $exception) {
            $invoice->update([
                'tb27_status' => 'erro_transmissao',
                'tb27_mensagem' => $exception->getMessage(),
                'tb27_ultima_tentativa_em' => now(),
            ]);

            throw $exception;
        }

        return $invoice->fresh();
    }

    private function buildBatchXml(string $signedXml, int $paymentId): string
    {
        $cleanXml = preg_replace('/^\s*<\?xml[^>]+>\s*/', '', trim($signedXml));
        $lotId = str_pad((string) $paymentId, 15, '0', STR_PAD_LEFT);

        return '<?xml version="1.0" encoding="UTF-8"?>'
            . '<enviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">'
            . '<idLote>' . $lotId . '</idLote>'
            . '<indSinc>1</indSinc>'
            . $cleanXml
            . '</enviNFe>';
    }

    private function buildSoapEnvelope(string $lotXml, string $municipalityCode): string
    {
        $cUf = substr(preg_replace('/\D+/', '', $municipalityCode), 0, 2);

        if ($cUf === '') {
            throw new RuntimeException('Codigo do municipio da loja nao informado para transmissao da NFC-e.');
        }

        $lotDocument = new DOMDocument('1.0', 'UTF-8');
        $lotLoaded = @$lotDocument->loadXML($lotXml);

        if (! $lotLoaded || ! $lotDocument->documentElement instanceof DOMElement) {
            throw new RuntimeException('O lote fiscal assinado nao gerou um XML valido para montagem do SOAP.');
        }

        $document = new DOMDocument('1.0', 'UTF-8');
        $document->formatOutput = false;

        $envelope = $document->createElementNS('http://www.w3.org/2003/05/soap-envelope', 'soap12:Envelope');
        $document->appendChild($envelope);
        $envelope->setAttributeNS(
            'http://www.w3.org/2000/xmlns/',
            'xmlns:xsi',
            'http://www.w3.org/2001/XMLSchema-instance'
        );
        $envelope->setAttributeNS(
            'http://www.w3.org/2000/xmlns/',
            'xmlns:xsd',
            'http://www.w3.org/2001/XMLSchema'
        );

        $header = $document->createElement('soap12:Header');
        $envelope->appendChild($header);

        $nfeCabecMsg = $document->createElementNS(
            'http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4',
            'nfeCabecMsg'
        );
        $header->appendChild($nfeCabecMsg);
        $nfeCabecMsg->appendChild($document->createElement('cUF', $cUf));
        $nfeCabecMsg->appendChild($document->createElement('versaoDados', '4.00'));

        $body = $document->createElement('soap12:Body');
        $envelope->appendChild($body);

        $nfeDadosMsg = $document->createElementNS(
            'http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4',
            'nfeDadosMsg'
        );
        $body->appendChild($nfeDadosMsg);
        $nfeDadosMsg->appendChild($document->importNode($lotDocument->documentElement, true));

        return $document->saveXML() ?: throw new RuntimeException('Nao foi possivel montar o envelope SOAP da NFC-e.');
    }

    private function sendSoapRequest(
        string $url,
        string $soapAction,
        string $soapEnvelope,
        array $certificateData,
    ): string {
        $pemPath = $this->writeTemporaryPem(
            (string) $certificateData['certificate_pem'],
            (string) $certificateData['private_key_pem'],
        );

        try {
            $curl = curl_init($url);

            curl_setopt_array($curl, [
                CURLOPT_POST => true,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_TIMEOUT => 45,
                CURLOPT_SSLCERTTYPE => 'PEM',
                CURLOPT_SSLCERT => $pemPath,
                CURLOPT_SSLKEY => $pemPath,
                CURLOPT_POSTFIELDS => $soapEnvelope,
                CURLOPT_HTTPHEADER => [
                    'Content-Type: application/soap+xml; charset=utf-8; action="' . $soapAction . '"',
                    'Content-Length: ' . strlen($soapEnvelope),
                ],
            ]);

            $response = curl_exec($curl);
            $error = curl_error($curl);
            $statusCode = (int) curl_getinfo($curl, CURLINFO_HTTP_CODE);
            curl_close($curl);

            if ($response === false || $error !== '') {
                throw new RuntimeException('Falha de comunicacao com o webservice da SEFAZ: ' . $error);
            }

            if ($statusCode >= 400) {
                throw new RuntimeException('A SEFAZ respondeu com erro HTTP ' . $statusCode . ' durante a autorizacao.');
            }

            return (string) $response;
        } finally {
            @unlink($pemPath);
        }
    }

    private function parseAuthorizationResponse(string $responseXml): array
    {
        $document = new DOMDocument();
        $loaded = @$document->loadXML($responseXml);

        if (! $loaded) {
            throw new RuntimeException('A resposta da SEFAZ nao retornou um XML valido.');
        }

        $xpath = new DOMXPath($document);
        $xpath->registerNamespace('soap', 'http://www.w3.org/2003/05/soap-envelope');
        $xpath->registerNamespace('nfe', 'http://www.portalfiscal.inf.br/nfe');

        $rootStatus = $this->xpathValue($xpath, 'string(//nfe:retEnviNFe/nfe:cStat)');
        $rootMessage = $this->xpathValue($xpath, 'string(//nfe:retEnviNFe/nfe:xMotivo)');
        $receipt = $this->xpathValue($xpath, 'string(//nfe:retEnviNFe/nfe:nRec | //nfe:retEnviNFe/nfe:infRec/nfe:nRec)');
        $protocolStatus = $this->xpathValue($xpath, 'string(//nfe:protNFe/nfe:infProt/nfe:cStat)');
        $protocolMessage = $this->xpathValue($xpath, 'string(//nfe:protNFe/nfe:infProt/nfe:xMotivo)');
        $protocol = $this->xpathValue($xpath, 'string(//nfe:protNFe/nfe:infProt/nfe:nProt)');
        $accessKey = $this->xpathValue($xpath, 'string(//nfe:protNFe/nfe:infProt/nfe:chNFe)');
        $emittedAt = $this->xpathValue($xpath, 'string(//nfe:protNFe/nfe:infProt/nfe:dhRecbto)');
        $soapFaultReason = $this->xpathValue($xpath, 'string(//soap:Fault/soap:Reason/soap:Text)');

        if ($rootStatus === '104' && $protocolStatus === '100') {
            return [
                'status' => 'emitida',
                'message' => $protocolMessage !== '' ? $protocolMessage : 'NFC-e autorizada com sucesso.',
                'receipt' => $receipt !== '' ? $receipt : null,
                'protocol' => $protocol !== '' ? $protocol : null,
                'access_key' => $accessKey !== '' ? $accessKey : null,
                'emitted_at' => $emittedAt !== '' ? Carbon::parse($emittedAt) : now(),
            ];
        }

        $message = $protocolMessage !== '' ? $protocolMessage : $rootMessage;

        if ($message === '' && $soapFaultReason !== '') {
            $message = $soapFaultReason;
        }

        if ($protocolStatus !== '') {
            $message = sprintf('cStat %s - %s', $protocolStatus, $message !== '' ? $message : 'A SEFAZ nao autorizou a NFC-e.');
        } elseif ($rootStatus !== '') {
            $message = sprintf('cStat %s - %s', $rootStatus, $message !== '' ? $message : 'A SEFAZ nao autorizou a NFC-e.');
        }

        return [
            'status' => 'erro_transmissao',
            'message' => $message !== '' ? $message : 'A SEFAZ nao autorizou a NFC-e.',
            'receipt' => $receipt !== '' ? $receipt : null,
            'protocol' => $protocol !== '' ? $protocol : null,
            'access_key' => $accessKey !== '' ? $accessKey : null,
            'emitted_at' => null,
        ];
    }

    private function xpathValue(DOMXPath $xpath, string $expression): string
    {
        return trim((string) $xpath->evaluate($expression));
    }

    private function writeTemporaryPem(string $certificatePem, string $privateKeyPem): string
    {
        $path = tempnam(sys_get_temp_dir(), 'pec_nfce_');

        if ($path === false) {
            throw new RuntimeException('Nao foi possivel criar arquivo temporario para o certificado da loja.');
        }

        $written = file_put_contents($path, $certificatePem . PHP_EOL . $privateKeyPem);

        if ($written === false) {
            @unlink($path);
            throw new RuntimeException('Nao foi possivel preparar o certificado da loja para transmissao.');
        }

        return $path;
    }
}
