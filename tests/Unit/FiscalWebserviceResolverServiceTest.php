<?php

namespace Tests\Unit;

use App\Support\FiscalWebserviceResolverService;
use RuntimeException;
use Tests\TestCase;

class FiscalWebserviceResolverServiceTest extends TestCase
{
    public function test_resolves_nfce_endpoints_without_wsdl_in_service_url(): void
    {
        $service = new FiscalWebserviceResolverService();

        $endpoints = $service->resolveNfceEndpoints('go', 'homologacao');

        $this->assertSame(
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeAutorizacao4',
            $endpoints['authorization']
        );
        $this->assertSame(
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeAutorizacao4?wsdl',
            $endpoints['authorization_wsdl']
        );
        $this->assertSame(
            'https://nfewebhomolog.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe',
            $endpoints['qr_code_url']
        );
        $this->assertSame(
            'https://nfewebhomolog.sefaz.go.gov.br/nfeweb/sites/nfe/consulta-completa',
            $endpoints['consultation_url']
        );
    }

    public function test_throws_for_unsupported_uf(): void
    {
        $this->expectException(RuntimeException::class);

        $service = new FiscalWebserviceResolverService();
        $service->resolveNfceEndpoints('SP', 'homologacao');
    }
}
