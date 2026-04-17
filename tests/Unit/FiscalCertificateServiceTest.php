<?php

namespace Tests\Unit;

use App\Support\FiscalCertificateService;
use ReflectionClass;
use Tests\TestCase;

class FiscalCertificateServiceTest extends TestCase
{
    protected function tearDown(): void
    {
        @unlink(storage_path('app/private/fiscal-certificados/teste-certificado.pfx'));
        @rmdir(storage_path('app/private/fiscal-certificados'));

        parent::tearDown();
    }

    public function test_extracts_certificate_name_from_subject(): void
    {
        $service = new FiscalCertificateService();

        $name = $service->extractCertificateName([
            'subject' => [
                'CN' => 'EMPRESA TESTE LTDA',
            ],
        ]);

        $this->assertSame('EMPRESA TESTE LTDA', $name);
    }

    public function test_extracts_certificate_cnpj_from_serial_number(): void
    {
        $service = new FiscalCertificateService();

        $cnpj = $service->extractCertificateCnpj([
            'subject' => [
                'serialNumber' => 'CNPJ:11.222.333/0001-44',
            ],
        ]);

        $this->assertSame('11222333000144', $cnpj);
    }

    public function test_extracts_certificate_cnpj_from_subject_alt_name(): void
    {
        $service = new FiscalCertificateService();

        $cnpj = $service->extractCertificateCnpj([
            'extensions' => [
                'subjectAltName' => 'otherName:2.16.76.1.3.3=11222333000144',
            ],
        ]);

        $this->assertSame('11222333000144', $cnpj);
    }

    public function test_resolves_current_and_legacy_certificate_storage_paths(): void
    {
        $directory = storage_path('app/private/fiscal-certificados');

        if (! is_dir($directory)) {
            mkdir($directory, 0777, true);
        }

        $filePath = $directory . DIRECTORY_SEPARATOR . 'teste-certificado.pfx';
        file_put_contents($filePath, 'certificado-teste');

        $service = new FiscalCertificateService();
        $reflection = new ReflectionClass($service);
        $method = $reflection->getMethod('resolveStorageAbsolutePath');
        $method->setAccessible(true);

        $currentPath = $method->invoke($service, 'fiscal-certificados/teste-certificado.pfx');
        $legacyPath = $method->invoke($service, 'private/fiscal-certificados/teste-certificado.pfx');

        $expectedPath = str_replace(['/', '\\'], DIRECTORY_SEPARATOR, $filePath);
        $resolvedCurrentPath = str_replace(['/', '\\'], DIRECTORY_SEPARATOR, (string) $currentPath);
        $resolvedLegacyPath = str_replace(['/', '\\'], DIRECTORY_SEPARATOR, (string) $legacyPath);

        $this->assertSame($expectedPath, $resolvedCurrentPath);
        $this->assertSame($expectedPath, $resolvedLegacyPath);
    }
}
