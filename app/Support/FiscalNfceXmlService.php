<?php

namespace App\Support;

use App\Models\ConfiguracaoFiscal;
use App\Models\NotaFiscal;
use App\Models\Produto;
use App\Models\Venda;
use App\Models\VendaPagamento;
use Carbon\Carbon;
use DOMDocument;
use DOMElement;
use RuntimeException;

class FiscalNfceXmlService
{
    public function __construct(
        private readonly FiscalWebserviceResolverService $fiscalWebserviceResolverService,
    ) {
    }

    public function buildSignedXml(
        NotaFiscal $invoice,
        VendaPagamento $payment,
        ConfiguracaoFiscal $configuration,
        array $certificateData,
    ): array {
        if ($invoice->tb27_modelo !== 'nfce') {
            throw new RuntimeException('A geracao automatica de XML assinado nesta etapa esta disponivel apenas para NFC-e.');
        }

        $sales = $payment->vendas;
        $unit = $sales->first()?->unidade;

        if (! $unit) {
            throw new RuntimeException('Nao foi possivel identificar a loja da venda para gerar o XML fiscal.');
        }

        $issueDate = Carbon::now();
        $unitCnpj = $this->onlyDigits($unit->tb2_cnpj);
        $municipalityCode = $this->onlyDigits($configuration->tb26_codigo_municipio);
        $serie = $this->normalizeSerie($invoice->tb27_serie);
        $number = (int) $invoice->tb27_numero;
        $modelCode = '65';
        $cUf = substr((string) $municipalityCode, 0, 2);
        $cNf = $this->generateRandomCode($payment->tb4_id);
        $accessKeyWithoutDigit = $cUf
            . $issueDate->format('ym')
            . $unitCnpj
            . $modelCode
            . str_pad($serie, 3, '0', STR_PAD_LEFT)
            . str_pad((string) $number, 9, '0', STR_PAD_LEFT)
            . '1'
            . $cNf;
        $verifierDigit = $this->calculateAccessKeyDigit($accessKeyWithoutDigit);
        $accessKey = $accessKeyWithoutDigit . $verifierDigit;
        $endpoints = $this->fiscalWebserviceResolverService->resolveNfceEndpoints(
            (string) $configuration->tb26_uf,
            (string) $configuration->tb26_ambiente,
        );

        $document = new DOMDocument('1.0', 'UTF-8');
        $document->preserveWhiteSpace = false;
        $document->formatOutput = false;

        $nfe = $document->createElementNS('http://www.portalfiscal.inf.br/nfe', 'NFe');
        $document->appendChild($nfe);

        $infNfe = $document->createElement('infNFe');
        $infNfe->setAttribute('Id', 'NFe' . $accessKey);
        $infNfe->setAttribute('versao', '4.00');
        $nfe->appendChild($infNfe);

        $this->appendIde($document, $infNfe, $configuration, $issueDate, $cUf, $cNf, $serie, $number, $verifierDigit);
        $this->appendEmitter($document, $infNfe, $configuration, $unitCnpj);
        $this->appendItems($document, $infNfe, $sales, (int) $configuration->tb26_crt);
        $this->appendTotals($document, $infNfe, $sales);
        $this->appendTransport($document, $infNfe);
        $this->appendPayment($document, $infNfe, $payment);
        $this->appendAdditionalInfo($document, $infNfe, $payment, $unit->tb2_nome);
        $this->signDocument($document, $infNfe, $certificateData);
        $this->appendSupplementalInfo($document, $nfe, $configuration, $accessKey, $endpoints);

        return [
            'xml' => $document->saveXML(),
            'access_key' => $accessKey,
        ];
    }

    private function appendIde(
        DOMDocument $document,
        DOMElement $infNfe,
        ConfiguracaoFiscal $configuration,
        Carbon $issueDate,
        string $cUf,
        string $cNf,
        string $serie,
        int $number,
        int $verifierDigit,
    ): void {
        $ide = $document->createElement('ide');
        $infNfe->appendChild($ide);

        $this->appendTextElement($document, $ide, 'cUF', $cUf);
        $this->appendTextElement($document, $ide, 'cNF', $cNf);
        $this->appendTextElement($document, $ide, 'natOp', 'VENDA');
        $this->appendTextElement($document, $ide, 'mod', '65');
        $this->appendTextElement($document, $ide, 'serie', (string) (int) $serie);
        $this->appendTextElement($document, $ide, 'nNF', (string) $number);
        $this->appendTextElement($document, $ide, 'dhEmi', $issueDate->format('Y-m-d\TH:i:sP'));
        $this->appendTextElement($document, $ide, 'tpNF', '1');
        $this->appendTextElement($document, $ide, 'idDest', '1');
        $this->appendTextElement($document, $ide, 'cMunFG', $this->requiredDigits($configuration->tb26_codigo_municipio, 7, 'Codigo do municipio IBGE'));
        $this->appendTextElement($document, $ide, 'tpImp', '4');
        $this->appendTextElement($document, $ide, 'tpEmis', '1');
        $this->appendTextElement($document, $ide, 'cDV', (string) $verifierDigit);
        $this->appendTextElement($document, $ide, 'tpAmb', $configuration->tb26_ambiente === 'producao' ? '1' : '2');
        $this->appendTextElement($document, $ide, 'finNFe', '1');
        $this->appendTextElement($document, $ide, 'indFinal', '1');
        $this->appendTextElement($document, $ide, 'indPres', '1');
        $this->appendTextElement($document, $ide, 'procEmi', '0');
        $this->appendTextElement($document, $ide, 'verProc', 'PEC-RODRIGO 1.0');
    }

    private function appendEmitter(
        DOMDocument $document,
        DOMElement $infNfe,
        ConfiguracaoFiscal $configuration,
        string $unitCnpj,
    ): void {
        $emit = $document->createElement('emit');
        $infNfe->appendChild($emit);

        $this->appendTextElement($document, $emit, 'CNPJ', $unitCnpj);
        $this->appendTextElement($document, $emit, 'xNome', (string) $configuration->tb26_razao_social);
        $this->appendTextElement($document, $emit, 'xFant', (string) ($configuration->tb26_nome_fantasia ?: $configuration->tb26_razao_social));

        $address = $document->createElement('enderEmit');
        $emit->appendChild($address);
        $this->appendTextElement($document, $address, 'xLgr', (string) $configuration->tb26_logradouro);
        $this->appendTextElement($document, $address, 'nro', (string) $configuration->tb26_numero);
        $this->appendOptionalTextElement($document, $address, 'xCpl', $configuration->tb26_complemento);
        $this->appendTextElement($document, $address, 'xBairro', (string) $configuration->tb26_bairro);
        $this->appendTextElement($document, $address, 'cMun', $this->requiredDigits($configuration->tb26_codigo_municipio, 7, 'Codigo do municipio IBGE'));
        $this->appendTextElement($document, $address, 'xMun', (string) $configuration->tb26_municipio);
        $this->appendTextElement($document, $address, 'UF', (string) $configuration->tb26_uf);
        $this->appendTextElement($document, $address, 'CEP', $this->requiredDigits($configuration->tb26_cep, 8, 'CEP'));
        $this->appendTextElement($document, $address, 'cPais', '1058');
        $this->appendTextElement($document, $address, 'xPais', 'BRASIL');
        $this->appendOptionalTextElement($document, $address, 'fone', $this->onlyDigits($configuration->tb26_telefone));

        $this->appendTextElement($document, $emit, 'IE', $this->requiredStateRegistration($configuration->tb26_ie, 'Inscricao estadual'));
        $municipalRegistration = trim((string) $configuration->tb26_im);
        $cnae = trim((string) $configuration->tb26_cnae);

        // Evita schema invalido no emitente: CNAE nao deve ser enviado sozinho sem IM.
        if ($municipalRegistration !== '') {
            $this->appendTextElement($document, $emit, 'IM', $municipalRegistration);
            $this->appendOptionalTextElement($document, $emit, 'CNAE', $cnae);
        }

        $this->appendTextElement($document, $emit, 'CRT', (string) $configuration->tb26_crt);
    }

    private function appendItems(DOMDocument $document, DOMElement $infNfe, $sales, int $crt): void
    {
        foreach ($sales->values() as $index => $sale) {
            /** @var Venda $sale */
            /** @var Produto|null $product */
            $product = $sale->produto;

            if (! $product) {
                throw new RuntimeException(sprintf('Produto %d nao encontrado para montar o XML fiscal.', $sale->tb1_id));
            }

            if ($crt !== 1) {
                throw new RuntimeException('A geracao automatica de XML assinado nesta etapa esta preparada apenas para CRT 1.');
            }

            $allowedCsosn = ['102', '103', '300', '400'];
            $csosn = str_pad((string) $product->tb1_csosn, 3, '0', STR_PAD_LEFT);

            if (! in_array($csosn, $allowedCsosn, true)) {
                throw new RuntimeException(sprintf(
                    'O produto %d (%s) possui CSOSN %s. Nesta etapa o XML automatico suporta somente 102, 103, 300 e 400.',
                    $sale->tb1_id,
                    $sale->produto_nome,
                    $csosn
                ));
            }

            $det = $document->createElement('det');
            $det->setAttribute('nItem', (string) ($index + 1));
            $infNfe->appendChild($det);

            $prod = $document->createElement('prod');
            $det->appendChild($prod);

            $ean = $this->normalizeGtIn($product->tb1_codbar);
            $quantity = number_format((float) $sale->quantidade, 4, '.', '');
            $unitPrice = number_format((float) $sale->valor_unitario, 10, '.', '');
            $total = number_format((float) $sale->valor_total, 2, '.', '');

            $this->appendTextElement($document, $prod, 'cProd', (string) $sale->tb1_id);
            $this->appendTextElement($document, $prod, 'cEAN', $ean);
            $this->appendTextElement($document, $prod, 'xProd', (string) $sale->produto_nome);
            $this->appendTextElement($document, $prod, 'NCM', $this->requiredDigits($product->tb1_ncm, 8, sprintf('NCM do produto %s', $sale->produto_nome)));
            $this->appendOptionalTextElement($document, $prod, 'CEST', $this->optionalDigits($product->tb1_cest, 7));
            $this->appendTextElement($document, $prod, 'CFOP', $this->requiredDigits($product->tb1_cfop, 4, sprintf('CFOP do produto %s', $sale->produto_nome)));
            $this->appendTextElement($document, $prod, 'uCom', (string) $product->tb1_unidade_comercial);
            $this->appendTextElement($document, $prod, 'qCom', $quantity);
            $this->appendTextElement($document, $prod, 'vUnCom', $unitPrice);
            $this->appendTextElement($document, $prod, 'vProd', $total);
            $this->appendTextElement($document, $prod, 'cEANTrib', $ean);
            $this->appendTextElement($document, $prod, 'uTrib', (string) $product->tb1_unidade_tributavel);
            $this->appendTextElement($document, $prod, 'qTrib', $quantity);
            $this->appendTextElement($document, $prod, 'vUnTrib', $unitPrice);
            $this->appendTextElement($document, $prod, 'indTot', '1');

            $imposto = $document->createElement('imposto');
            $det->appendChild($imposto);

            $icms = $document->createElement('ICMS');
            $imposto->appendChild($icms);
            $icmsSimpleNational = $document->createElement('ICMSSN' . $csosn);
            $icms->appendChild($icmsSimpleNational);
            $this->appendTextElement($document, $icmsSimpleNational, 'orig', $this->requiredDigits((string) $product->tb1_origem, 1, sprintf('Origem fiscal do produto %s', $sale->produto_nome)));
            $this->appendTextElement($document, $icmsSimpleNational, 'CSOSN', $csosn);

            $pis = $document->createElement('PIS');
            $imposto->appendChild($pis);
            $pisOther = $document->createElement('PISOutr');
            $pis->appendChild($pisOther);
            $this->appendTextElement($document, $pisOther, 'CST', '99');
            $this->appendTextElement($document, $pisOther, 'vBC', '0.00');
            $this->appendTextElement($document, $pisOther, 'pPIS', '0.00');
            $this->appendTextElement($document, $pisOther, 'vPIS', '0.00');

            $cofins = $document->createElement('COFINS');
            $imposto->appendChild($cofins);
            $cofinsOther = $document->createElement('COFINSOutr');
            $cofins->appendChild($cofinsOther);
            $this->appendTextElement($document, $cofinsOther, 'CST', '99');
            $this->appendTextElement($document, $cofinsOther, 'vBC', '0.00');
            $this->appendTextElement($document, $cofinsOther, 'pCOFINS', '0.00');
            $this->appendTextElement($document, $cofinsOther, 'vCOFINS', '0.00');
        }
    }

    private function appendTotals(DOMDocument $document, DOMElement $infNfe, $sales): void
    {
        $sumProducts = number_format((float) $sales->sum('valor_total'), 2, '.', '');

        $total = $document->createElement('total');
        $infNfe->appendChild($total);

        $icmsTot = $document->createElement('ICMSTot');
        $total->appendChild($icmsTot);
        foreach ([
            'vBC' => '0.00',
            'vICMS' => '0.00',
            'vICMSDeson' => '0.00',
            'vFCP' => '0.00',
            'vBCST' => '0.00',
            'vST' => '0.00',
            'vFCPST' => '0.00',
            'vFCPSTRet' => '0.00',
            'vProd' => $sumProducts,
            'vFrete' => '0.00',
            'vSeg' => '0.00',
            'vDesc' => '0.00',
            'vII' => '0.00',
            'vIPI' => '0.00',
            'vIPIDevol' => '0.00',
            'vPIS' => '0.00',
            'vCOFINS' => '0.00',
            'vOutro' => '0.00',
            'vNF' => $sumProducts,
            'vTotTrib' => '0.00',
        ] as $tag => $value) {
            $this->appendTextElement($document, $icmsTot, $tag, $value);
        }
    }

    private function appendTransport(DOMDocument $document, DOMElement $infNfe): void
    {
        $transport = $document->createElement('transp');
        $infNfe->appendChild($transport);
        $this->appendTextElement($document, $transport, 'modFrete', '9');
    }

    private function appendPayment(DOMDocument $document, DOMElement $infNfe, VendaPagamento $payment): void
    {
        $paymentNode = $document->createElement('pag');
        $infNfe->appendChild($paymentNode);

        $detail = $document->createElement('detPag');
        $paymentNode->appendChild($detail);
        $paymentData = $this->resolvePaymentData((string) $payment->tipo_pagamento);
        $this->appendTextElement($document, $detail, 'tPag', $paymentData['code']);

        if ($paymentData['description'] !== null) {
            $this->appendTextElement($document, $detail, 'xPag', $paymentData['description']);
        }

        $this->appendTextElement($document, $detail, 'vPag', number_format((float) $payment->valor_total, 2, '.', ''));

        if ((float) $payment->troco > 0) {
            $this->appendTextElement($document, $paymentNode, 'vTroco', number_format((float) $payment->troco, 2, '.', ''));
        }
    }

    private function appendAdditionalInfo(
        DOMDocument $document,
        DOMElement $infNfe,
        VendaPagamento $payment,
        ?string $unitName,
    ): void {
        $additional = $document->createElement('infAdic');
        $infNfe->appendChild($additional);
        $this->appendTextElement(
            $document,
            $additional,
            'infCpl',
            sprintf('Pagamento interno %d | Loja %s', (int) $payment->tb4_id, $unitName ?: 'NAO INFORMADA')
        );
    }

    private function appendSupplementalInfo(
        DOMDocument $document,
        DOMElement $nfe,
        ConfiguracaoFiscal $configuration,
        string $accessKey,
        array $endpoints,
    ): void {
        $qrCodeUrl = trim((string) ($endpoints['qr_code_url'] ?? ''));
        $consultationUrl = trim((string) ($endpoints['consultation_url'] ?? ''));

        if ($qrCodeUrl === '' || $consultationUrl === '') {
            throw new RuntimeException('Os enderecos de consulta da NFC-e nao estao configurados para a UF da loja.');
        }

        $supplemental = $document->createElement('infNFeSupl');
        $nfe->appendChild($supplemental);

        $this->appendTextElement(
            $document,
            $supplemental,
            'qrCode',
            $this->buildQrCodeUrl($configuration, $accessKey, $qrCodeUrl)
        );
        $this->appendTextElement($document, $supplemental, 'urlChave', $consultationUrl);
    }

    private function signDocument(DOMDocument $document, DOMElement $infNfe, array $certificateData): void
    {
        $referenceUri = '#' . $infNfe->getAttribute('Id');
        $digestValue = base64_encode(sha1($infNfe->C14N(false, false), true));

        $signatureDocument = new DOMDocument('1.0', 'UTF-8');
        $signatureDocument->preserveWhiteSpace = false;
        $signatureDocument->formatOutput = false;

        $signature = $signatureDocument->createElementNS('http://www.w3.org/2000/09/xmldsig#', 'Signature');
        $signatureDocument->appendChild($signature);

        $signedInfo = $signatureDocument->createElement('SignedInfo');
        $signature->appendChild($signedInfo);

        $canonicalizationMethod = $signatureDocument->createElement('CanonicalizationMethod');
        $canonicalizationMethod->setAttribute('Algorithm', 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315');
        $signedInfo->appendChild($canonicalizationMethod);

        $signatureMethod = $signatureDocument->createElement('SignatureMethod');
        $signatureMethod->setAttribute('Algorithm', 'http://www.w3.org/2000/09/xmldsig#rsa-sha1');
        $signedInfo->appendChild($signatureMethod);

        $reference = $signatureDocument->createElement('Reference');
        $reference->setAttribute('URI', $referenceUri);
        $signedInfo->appendChild($reference);

        $transforms = $signatureDocument->createElement('Transforms');
        $reference->appendChild($transforms);

        $transformEnveloped = $signatureDocument->createElement('Transform');
        $transformEnveloped->setAttribute('Algorithm', 'http://www.w3.org/2000/09/xmldsig#enveloped-signature');
        $transforms->appendChild($transformEnveloped);

        $transformCanonical = $signatureDocument->createElement('Transform');
        $transformCanonical->setAttribute('Algorithm', 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315');
        $transforms->appendChild($transformCanonical);

        $digestMethod = $signatureDocument->createElement('DigestMethod');
        $digestMethod->setAttribute('Algorithm', 'http://www.w3.org/2000/09/xmldsig#sha1');
        $reference->appendChild($digestMethod);

        $this->appendTextElement($signatureDocument, $reference, 'DigestValue', $digestValue);

        $signedInfoCanonical = $signedInfo->C14N(false, false);
        $privateKey = openssl_pkey_get_private($certificateData['private_key_pem']);

        if (! $privateKey) {
            throw new RuntimeException('Nao foi possivel abrir a chave privada do certificado para assinar o XML.');
        }

        $signatureValue = '';

        if (! openssl_sign($signedInfoCanonical, $signatureValue, $privateKey, OPENSSL_ALGO_SHA1)) {
            throw new RuntimeException('Falha ao assinar o XML fiscal com o certificado da loja.');
        }

        $this->appendTextElement($signatureDocument, $signature, 'SignatureValue', base64_encode($signatureValue));

        $keyInfo = $signatureDocument->createElement('KeyInfo');
        $signature->appendChild($keyInfo);
        $x509Data = $signatureDocument->createElement('X509Data');
        $keyInfo->appendChild($x509Data);
        $this->appendTextElement($signatureDocument, $x509Data, 'X509Certificate', $certificateData['public_certificate_base64']);

        $importedSignature = $document->importNode($signature, true);
        $document->documentElement->appendChild($importedSignature);
    }

    private function appendTextElement(DOMDocument $document, DOMElement $parent, string $tag, string $value): void
    {
        $parent->appendChild($document->createElement($tag, $value));
    }

    private function appendOptionalTextElement(DOMDocument $document, DOMElement $parent, string $tag, ?string $value): void
    {
        $value = trim((string) $value);

        if ($value === '') {
            return;
        }

        $this->appendTextElement($document, $parent, $tag, $value);
    }

    private function onlyDigits(?string $value): string
    {
        return preg_replace('/\D+/', '', (string) $value);
    }

    private function normalizeSerie(?string $serie): string
    {
        $digits = $this->onlyDigits($serie);

        return $digits === '' ? '1' : substr($digits, -3);
    }

    private function generateRandomCode(int $paymentId): string
    {
        $base = (string) (($paymentId * 97) % 99999999);

        return str_pad($base, 8, '0', STR_PAD_LEFT);
    }

    private function calculateAccessKeyDigit(string $keyWithoutDigit): int
    {
        $multiplier = 2;
        $sum = 0;

        for ($index = strlen($keyWithoutDigit) - 1; $index >= 0; $index--) {
            $sum += (int) $keyWithoutDigit[$index] * $multiplier;
            $multiplier = $multiplier === 9 ? 2 : $multiplier + 1;
        }

        $remainder = $sum % 11;
        $digit = 11 - $remainder;

        return $digit >= 10 ? 0 : $digit;
    }

    private function normalizeGtIn(?string $barcode): string
    {
        $digits = $this->onlyDigits($barcode);

        if (in_array(strlen($digits), [8, 12, 13, 14], true)) {
            return $digits;
        }

        return 'SEM GTIN';
    }

    private function resolvePaymentData(string $paymentType): array
    {
        return match ($paymentType) {
            'dinheiro' => ['code' => '01', 'description' => null],
            'vale' => ['code' => '10', 'description' => null],
            'refeicao' => ['code' => '11', 'description' => null],
            'faturar' => ['code' => '90', 'description' => null],
            'maquina' => ['code' => '99', 'description' => 'MAQUINA'],
            default => ['code' => '99', 'description' => strtoupper(str_replace('_', ' ', trim($paymentType))) ?: 'OUTROS'],
        };
    }

    private function buildQrCodeUrl(
        ConfiguracaoFiscal $configuration,
        string $accessKey,
        string $baseUrl,
    ): string {
        $baseUrl = rtrim($baseUrl, '?');
        $tpAmb = $configuration->tb26_ambiente === 'producao' ? '1' : '2';
        $qrCodeVersion = '3';

        return $baseUrl . '?p=' . implode('|', [$accessKey, $qrCodeVersion, $tpAmb]);
    }

    private function optionalDigits(?string $value, ?int $expectedLength = null): ?string
    {
        $digits = $this->onlyDigits($value);

        if ($digits === '') {
            return null;
        }

        if ($expectedLength !== null && strlen($digits) !== $expectedLength) {
            return null;
        }

        return $digits;
    }

    private function requiredDigits(?string $value, int $expectedLength, string $fieldLabel): string
    {
        $digits = $this->optionalDigits($value, $expectedLength);

        if ($digits === null) {
            throw new RuntimeException(sprintf(
                '%s invalido para o schema fiscal. Informe exatamente %d digitos sem mascara.',
                $fieldLabel,
                $expectedLength
            ));
        }

        return $digits;
    }

    private function requiredStateRegistration(?string $value, string $fieldLabel): string
    {
        $value = strtoupper(trim((string) $value));

        if ($value === 'ISENTO') {
            return $value;
        }

        $digits = $this->onlyDigits($value);

        if (strlen($digits) < 2 || strlen($digits) > 14) {
            throw new RuntimeException(sprintf(
                '%s invalida para o schema fiscal. Informe apenas digitos ou ISENTO.',
                $fieldLabel
            ));
        }

        return $digits;
    }
}
