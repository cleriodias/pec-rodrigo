<?php

namespace Tests\Unit;

use App\Support\FiscalCertificateService;
use App\Support\FiscalNfceTransmissionService;
use App\Support\FiscalWebserviceResolverService;
use ReflectionClass;
use Tests\TestCase;

class FiscalNfceTransmissionServiceTest extends TestCase
{
    public function test_parse_authorization_response_prefixes_cstat_in_error_message(): void
    {
        $service = new FiscalNfceTransmissionService(
            new FiscalCertificateService(),
            new FiscalWebserviceResolverService(),
        );

        $reflection = new ReflectionClass($service);
        $method = $reflection->getMethod('parseAuthorizationResponse');
        $method->setAccessible(true);

        $response = <<<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<retEnviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
    <tpAmb>2</tpAmb>
    <verAplic>GO2026001</verAplic>
    <cStat>225</cStat>
    <xMotivo>Rejeicao: Falha no Schema XML do lote de NFe</xMotivo>
    <cUF>52</cUF>
    <dhRecbto>2026-04-16T18:10:00-03:00</dhRecbto>
    <infRec>
        <nRec>522600000000001</nRec>
        <tMed>1</tMed>
    </infRec>
</retEnviNFe>
XML;

        $parsed = $method->invoke($service, $response);

        $this->assertSame('erro_transmissao', $parsed['status']);
        $this->assertSame(
            'cStat 225 - Rejeicao: Falha no Schema XML do lote de NFe',
            $parsed['message']
        );
        $this->assertSame('522600000000001', $parsed['receipt']);
    }
}
