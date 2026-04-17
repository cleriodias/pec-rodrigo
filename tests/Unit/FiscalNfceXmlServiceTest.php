<?php

namespace Tests\Unit;

use App\Models\ConfiguracaoFiscal;
use App\Models\NotaFiscal;
use App\Models\Produto;
use App\Models\Unidade;
use App\Models\VendaPagamento;
use App\Support\FiscalNfceXmlService;
use App\Support\FiscalWebserviceResolverService;
use DOMDocument;
use DOMElement;
use App\Models\Venda;
use ReflectionClass;
use Tests\TestCase;

class FiscalNfceXmlServiceTest extends TestCase
{
    public function test_append_supplemental_info_adds_qrcode_and_url_chave(): void
    {
        $service = new FiscalNfceXmlService(new FiscalWebserviceResolverService());
        $reflection = new ReflectionClass($service);
        $method = $reflection->getMethod('appendSupplementalInfo');
        $method->setAccessible(true);

        $document = new DOMDocument('1.0', 'UTF-8');
        $nfe = $document->createElementNS('http://www.portalfiscal.inf.br/nfe', 'NFe');
        $document->appendChild($nfe);

        $config = new ConfiguracaoFiscal([
            'tb26_ambiente' => 'homologacao',
        ]);

        $method->invoke(
            $service,
            $document,
            $nfe,
            $config,
            '52260411222333000144650010000012341000012345',
            [
                'qr_code_url' => 'https://nfewebhomolog.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe',
                'consultation_url' => 'https://nfewebhomolog.sefaz.go.gov.br/nfeweb/sites/nfe/consulta-completa',
            ],
        );

        $xml = $document->saveXML();

        $this->assertNotFalse($xml);
        $this->assertStringContainsString('<infNFeSupl>', $xml);
        $this->assertStringContainsString(
            '<qrCode>https://nfewebhomolog.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe?p=52260411222333000144650010000012341000012345|3|2</qrCode>',
            $xml
        );
        $this->assertStringContainsString(
            '<urlChave>https://nfewebhomolog.sefaz.go.gov.br/nfeweb/sites/nfe/consulta-completa</urlChave>',
            $xml
        );
    }

    public function test_append_emitter_and_items_normalize_numeric_fields_for_schema(): void
    {
        $service = new FiscalNfceXmlService(new FiscalWebserviceResolverService());
        $reflection = new ReflectionClass($service);
        $appendEmitter = $reflection->getMethod('appendEmitter');
        $appendEmitter->setAccessible(true);
        $appendItems = $reflection->getMethod('appendItems');
        $appendItems->setAccessible(true);

        $document = new DOMDocument('1.0', 'UTF-8');
        $infNfe = $document->createElement('infNFe');
        $document->appendChild($infNfe);

        $config = new ConfiguracaoFiscal([
            'tb26_razao_social' => 'EMPRESA TESTE LTDA',
            'tb26_nome_fantasia' => 'EMPRESA TESTE',
            'tb26_logradouro' => 'RUA 1',
            'tb26_numero' => '10',
            'tb26_bairro' => 'CENTRO',
            'tb26_codigo_municipio' => '52.087-07',
            'tb26_municipio' => 'GOIANIA',
            'tb26_uf' => 'GO',
            'tb26_cep' => '74.000-000',
            'tb26_ie' => '12.345.678-9',
            'tb26_crt' => 1,
        ]);

        $product = new Produto([
            'tb1_ncm' => '19.05.9090',
            'tb1_cest' => '17.049.01',
            'tb1_cfop' => '5.102',
            'tb1_unidade_comercial' => 'UN',
            'tb1_unidade_tributavel' => 'UN',
            'tb1_origem' => 0,
            'tb1_csosn' => '102',
            'tb1_codbar' => '7891234567890',
        ]);

        $sale = new Venda([
            'tb1_id' => 10,
            'produto_nome' => 'COXINHA',
            'quantidade' => 1,
            'valor_unitario' => 7.5,
            'valor_total' => 7.5,
        ]);
        $sale->setRelation('produto', $product);

        $appendEmitter->invoke($service, $document, $infNfe, $config, '11222333000144');
        $appendItems->invoke($service, $document, $infNfe, collect([$sale]), 1);

        $xml = $document->saveXML();

        $this->assertNotFalse($xml);
        $this->assertStringContainsString('<cMun>5208707</cMun>', $xml);
        $this->assertStringContainsString('<CEP>74000000</CEP>', $xml);
        $this->assertStringContainsString('<IE>123456789</IE>', $xml);
        $this->assertStringContainsString('<NCM>19059090</NCM>', $xml);
        $this->assertStringContainsString('<CEST>1704901</CEST>', $xml);
        $this->assertStringContainsString('<CFOP>5102</CFOP>', $xml);
        $this->assertStringNotContainsString('<CNAE>', $xml);
    }

    public function test_append_emitter_only_includes_cnae_when_municipal_registration_exists(): void
    {
        $service = new FiscalNfceXmlService(new FiscalWebserviceResolverService());
        $reflection = new ReflectionClass($service);
        $appendEmitter = $reflection->getMethod('appendEmitter');
        $appendEmitter->setAccessible(true);

        $document = new DOMDocument('1.0', 'UTF-8');
        $infNfe = $document->createElement('infNFe');
        $document->appendChild($infNfe);

        $config = new ConfiguracaoFiscal([
            'tb26_razao_social' => 'EMPRESA TESTE LTDA',
            'tb26_nome_fantasia' => 'EMPRESA TESTE',
            'tb26_logradouro' => 'RUA 1',
            'tb26_numero' => '10',
            'tb26_bairro' => 'CENTRO',
            'tb26_codigo_municipio' => '5208707',
            'tb26_municipio' => 'GOIANIA',
            'tb26_uf' => 'GO',
            'tb26_cep' => '74000000',
            'tb26_ie' => '123456789',
            'tb26_im' => '998877',
            'tb26_cnae' => '4721102',
            'tb26_crt' => 1,
        ]);

        $appendEmitter->invoke($service, $document, $infNfe, $config, '11222333000144');

        $xml = $document->saveXML();

        $this->assertNotFalse($xml);
        $this->assertStringContainsString('<IM>998877</IM>', $xml);
        $this->assertStringContainsString('<CNAE>4721102</CNAE>', $xml);
    }

    public function test_append_payment_adds_xpag_for_maquina_and_specific_codes_for_vale(): void
    {
        $service = new FiscalNfceXmlService(new FiscalWebserviceResolverService());
        $reflection = new ReflectionClass($service);
        $appendPayment = $reflection->getMethod('appendPayment');
        $appendPayment->setAccessible(true);

        $machineDocument = new DOMDocument('1.0', 'UTF-8');
        $machineInfNfe = $machineDocument->createElement('infNFe');
        $machineDocument->appendChild($machineInfNfe);

        $machinePayment = new VendaPagamento([
            'tipo_pagamento' => 'maquina',
            'valor_total' => 4.2,
            'troco' => 0,
        ]);

        $appendPayment->invoke($service, $machineDocument, $machineInfNfe, $machinePayment);

        $machineXml = $machineDocument->saveXML();

        $this->assertNotFalse($machineXml);
        $this->assertStringContainsString('<tPag>99</tPag>', $machineXml);
        $this->assertStringContainsString('<xPag>MAQUINA</xPag>', $machineXml);

        $valeDocument = new DOMDocument('1.0', 'UTF-8');
        $valeInfNfe = $valeDocument->createElement('infNFe');
        $valeDocument->appendChild($valeInfNfe);

        $valePayment = new VendaPagamento([
            'tipo_pagamento' => 'vale',
            'valor_total' => 4.2,
            'troco' => 0,
        ]);

        $appendPayment->invoke($service, $valeDocument, $valeInfNfe, $valePayment);

        $valeXml = $valeDocument->saveXML();

        $this->assertNotFalse($valeXml);
        $this->assertStringContainsString('<tPag>10</tPag>', $valeXml);
        $this->assertStringNotContainsString('<xPag>', $valeXml);
    }

    public function test_build_signed_xml_keeps_official_root_order_with_supplemental_info_before_signature(): void
    {
        $service = new FiscalNfceXmlService(new FiscalWebserviceResolverService());

        $config = new ConfiguracaoFiscal([
            'tb26_ambiente' => 'homologacao',
            'tb26_uf' => 'GO',
            'tb26_codigo_municipio' => '5200258',
            'tb26_serie' => '1',
            'tb26_crt' => 1,
            'tb26_razao_social' => 'EMPRESA TESTE LTDA',
            'tb26_nome_fantasia' => 'EMPRESA TESTE',
            'tb26_logradouro' => 'RUA 1',
            'tb26_numero' => '10',
            'tb26_bairro' => 'CENTRO',
            'tb26_municipio' => 'AGUAS LINDAS DE GOIAS',
            'tb26_cep' => '72920076',
            'tb26_ie' => '123456789',
            'tb26_csc_id' => '1',
            'tb26_csc' => 'ABC123',
        ]);

        $product = new Produto([
            'tb1_ncm' => '19059090',
            'tb1_cfop' => '5102',
            'tb1_unidade_comercial' => 'UN',
            'tb1_unidade_tributavel' => 'UN',
            'tb1_origem' => 0,
            'tb1_csosn' => '102',
            'tb1_codbar' => null,
        ]);

        $sale = new Venda([
            'tb1_id' => 1,
            'id_unidade' => 3,
            'produto_nome' => 'PAO DE SAL',
            'quantidade' => 2,
            'valor_unitario' => 1.5,
            'valor_total' => 3.0,
        ]);
        $sale->setRelation('produto', $product);
        $sale->setRelation('unidade', new Unidade([
            'tb2_id' => 3,
            'tb2_nome' => 'BARRAGEM 1',
            'tb2_cnpj' => '62074471000156',
        ]));

        $payment = new VendaPagamento([
            'tb4_id' => 999,
            'tipo_pagamento' => 'dinheiro',
            'valor_total' => 3.0,
            'troco' => 0,
        ]);
        $payment->setRelation('vendas', collect([$sale]));

        $invoice = new NotaFiscal([
            'tb27_modelo' => 'nfce',
            'tb27_serie' => '1',
            'tb27_numero' => 1,
        ]);

        $certificateData = $this->createCertificateData();

        $result = $service->buildSignedXml($invoice, $payment, $configuration, $certificateData);

        $document = new DOMDocument();
        $loaded = @$document->loadXML($result['xml']);

        $this->assertTrue($loaded);

        $rootChildren = [];

        foreach ($document->documentElement->childNodes as $child) {
            if ($child instanceof DOMElement) {
                $rootChildren[] = $child->localName;
            }
        }

        $this->assertSame(['infNFe', 'infNFeSupl', 'Signature'], $rootChildren);
    }

    private function createCertificateData(): array
    {
        if (! function_exists('openssl_pkey_new') || ! function_exists('openssl_csr_new') || ! function_exists('openssl_csr_sign')) {
            $this->markTestSkipped('OpenSSL nao esta disponivel neste ambiente para gerar um certificado temporario de teste.');
        }

        $privateKey = openssl_pkey_new([
            'private_key_type' => OPENSSL_KEYTYPE_RSA,
            'private_key_bits' => 2048,
        ]);

        if ($privateKey === false) {
            $this->markTestSkipped('O ambiente atual nao permitiu gerar uma chave RSA temporaria para o teste de assinatura.');
        }

        $csr = openssl_csr_new([
            'commonName' => 'TESTE NFC-E',
            'organizationName' => 'PEC',
            'countryName' => 'BR',
        ], $privateKey);

        if ($csr === false) {
            $this->markTestSkipped('O ambiente atual nao permitiu gerar um CSR temporario para o teste de assinatura.');
        }

        $certificate = openssl_csr_sign($csr, null, $privateKey, 1);

        if ($certificate === false) {
            $this->markTestSkipped('O ambiente atual nao permitiu assinar um certificado temporario para o teste de assinatura.');
        }

        $certificatePem = '';
        $privateKeyPem = '';

        $this->assertTrue(openssl_x509_export($certificate, $certificatePem));
        $this->assertTrue(openssl_pkey_export($privateKey, $privateKeyPem));

        return [
            'certificate_pem' => $certificatePem,
            'private_key_pem' => $privateKeyPem,
            'public_certificate_base64' => trim(str_replace([
                '-----BEGIN CERTIFICATE-----',
                '-----END CERTIFICATE-----',
                "\r",
                "\n",
            ], '', $certificatePem)),
        ];
    }
}
