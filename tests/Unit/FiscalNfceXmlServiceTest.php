<?php

namespace Tests\Unit;

use App\Models\ConfiguracaoFiscal;
use App\Models\Produto;
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

    public function test_append_supplemental_info_keeps_existing_signature_before_it_in_nfe_root(): void
    {
        $service = new FiscalNfceXmlService(new FiscalWebserviceResolverService());
        $reflection = new ReflectionClass($service);
        $appendSupplementalInfo = $reflection->getMethod('appendSupplementalInfo');
        $appendSupplementalInfo->setAccessible(true);

        $document = new DOMDocument('1.0', 'UTF-8');
        $nfe = $document->createElementNS('http://www.portalfiscal.inf.br/nfe', 'NFe');
        $document->appendChild($nfe);
        $infNfe = $document->createElement('infNFe');
        $infNfe->setAttribute('Id', 'NFe52260411222333000144650010000012341000012345');
        $infNfe->setAttribute('versao', '4.00');
        $nfe->appendChild($infNfe);
        $infNfe->appendChild($document->createElement('ide'));
        $signature = $document->createElementNS('http://www.w3.org/2000/09/xmldsig#', 'Signature');
        $nfe->appendChild($signature);

        $config = new ConfiguracaoFiscal([
            'tb26_ambiente' => 'homologacao',
        ]);

        $appendSupplementalInfo->invoke(
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

        $rootChildren = [];

        foreach ($document->documentElement->childNodes as $child) {
            if ($child instanceof DOMElement) {
                $rootChildren[] = $child->localName;
            }
        }

        $this->assertSame(['infNFe', 'Signature', 'infNFeSupl'], $rootChildren);
    }
}
