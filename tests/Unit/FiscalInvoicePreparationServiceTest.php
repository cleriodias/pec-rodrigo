<?php

namespace Tests\Unit;

use App\Models\ConfiguracaoFiscal;
use App\Models\Produto;
use App\Models\Venda;
use App\Models\VendaPagamento;
use App\Support\FiscalCertificateService;
use App\Support\FiscalMunicipalityCodeService;
use App\Support\FiscalNfceXmlService;
use App\Support\FiscalInvoicePreparationService;
use App\Support\FiscalWebserviceResolverService;
use ReflectionClass;
use Tests\TestCase;

class FiscalInvoicePreparationServiceTest extends TestCase
{
    public function test_validate_payload_requires_unit_configuration(): void
    {
        $service = $this->makeService();
        $reflection = new ReflectionClass($service);
        $validatePayload = $reflection->getMethod('validatePayload');
        $validatePayload->setAccessible(true);

        $payment = $this->makePaymentWithFiscalProduct();

        $errors = $validatePayload->invoke($service, $payment, null, 'nfce');

        $this->assertSame(
            ['Configure a emissao fiscal da unidade antes de gerar a nota.'],
            $errors
        );
    }

    public function test_validate_payload_accepts_complete_configuration_and_product(): void
    {
        $service = $this->makeService();
        $reflection = new ReflectionClass($service);
        $validatePayload = $reflection->getMethod('validatePayload');
        $validatePayload->setAccessible(true);

        $payment = $this->makePaymentWithFiscalProduct();
        $config = $this->makeConfiguration();

        $errors = $validatePayload->invoke($service, $payment, $config, 'nfce');

        $this->assertSame([], $errors);
    }

    public function test_validate_payload_flags_product_without_required_tax_fields(): void
    {
        $service = $this->makeService();
        $reflection = new ReflectionClass($service);
        $validatePayload = $reflection->getMethod('validatePayload');
        $validatePayload->setAccessible(true);

        $payment = $this->makePaymentWithFiscalProduct([
            'tb1_ncm' => null,
            'tb1_cfop' => null,
            'tb1_csosn' => null,
            'tb1_cst' => null,
        ]);
        $config = $this->makeConfiguration();

        $errors = $validatePayload->invoke($service, $payment, $config, 'nfce');

        $this->assertCount(1, $errors);
        $this->assertStringContainsString('sem cadastro fiscal completo', $errors[0]);
        $this->assertStringContainsString('NCM', $errors[0]);
        $this->assertStringContainsString('CFOP', $errors[0]);
        $this->assertStringContainsString('CSOSN/CST', $errors[0]);
    }

    public function test_validate_payload_flags_certificate_from_another_store(): void
    {
        $service = $this->makeService();
        $reflection = new ReflectionClass($service);
        $validatePayload = $reflection->getMethod('validatePayload');
        $validatePayload->setAccessible(true);

        $payment = $this->makePaymentWithFiscalProduct([], '11.222.333/0001-44');
        $config = $this->makeConfiguration([
            'tb26_certificado_cnpj' => '99888777000166',
        ]);

        $errors = $validatePayload->invoke($service, $payment, $config, 'nfce');

        $this->assertContains(
            'O CNPJ do certificado nao pertence ao mesmo CNPJ base da loja da venda.',
            $errors
        );
    }

    public function test_validate_payload_flags_municipality_code_from_another_uf(): void
    {
        $service = $this->makeService();
        $reflection = new ReflectionClass($service);
        $validatePayload = $reflection->getMethod('validatePayload');
        $validatePayload->setAccessible(true);

        $payment = $this->makePaymentWithFiscalProduct();
        $config = $this->makeConfiguration([
            'tb26_uf' => 'GO',
            'tb26_codigo_municipio' => '5300108',
            'tb26_municipio' => 'AGUAS LINDAS DE GOIAS',
        ]);

        $errors = $validatePayload->invoke($service, $payment, $config, 'nfce');

        $this->assertContains(
            'O codigo do municipio IBGE 5300108 nao pertence a UF GO informada na configuracao fiscal. Use um codigo iniciado por 52.',
            $errors
        );
    }

    public function test_validate_payload_flags_invalid_state_registration(): void
    {
        $service = $this->makeService();
        $reflection = new ReflectionClass($service);
        $validatePayload = $reflection->getMethod('validatePayload');
        $validatePayload->setAccessible(true);

        $payment = $this->makePaymentWithFiscalProduct();
        $config = $this->makeConfiguration([
            'tb26_ie' => 'ABCD',
        ]);

        $errors = $validatePayload->invoke($service, $payment, $config, 'nfce');

        $this->assertContains(
            'A inscricao estadual da unidade esta invalida para emissao fiscal. Informe apenas digitos ou ISENTO.',
            $errors
        );
    }

    private function makePaymentWithFiscalProduct(
        array $productOverrides = [],
        string $unitCnpj = '11.222.333/0001-44',
    ): VendaPagamento
    {
        $product = new Produto(array_merge([
            'tb1_id' => 10,
            'tb1_nome' => 'COXINHA',
            'tb1_codbar' => '7891234567890',
            'tb1_ncm' => '19059090',
            'tb1_cest' => '1704901',
            'tb1_cfop' => '5102',
            'tb1_unidade_comercial' => 'UN',
            'tb1_unidade_tributavel' => 'UN',
            'tb1_origem' => 0,
            'tb1_csosn' => '102',
            'tb1_cst' => null,
            'tb1_aliquota_icms' => 0,
        ], $productOverrides));

        $sale = new Venda([
            'tb1_id' => 10,
            'produto_nome' => 'COXINHA',
            'quantidade' => 2,
            'valor_unitario' => 7.5,
            'valor_total' => 15,
        ]);
        $sale->setRelation('produto', $product);
        $sale->setRelation('unidade', new \App\Models\Unidade([
            'tb2_id' => 1,
            'tb2_nome' => 'LOJA TESTE',
            'tb2_cnpj' => $unitCnpj,
        ]));

        $payment = new VendaPagamento([
            'tb4_id' => 99,
            'valor_total' => 15,
            'tipo_pagamento' => 'dinheiro',
        ]);
        $payment->setRelation('vendas', collect([$sale]));

        return $payment;
    }

    private function makeConfiguration(array $overrides = []): ConfiguracaoFiscal
    {
        return new ConfiguracaoFiscal(array_merge([
            'tb2_id' => 1,
            'tb26_emitir_nfce' => true,
            'tb26_emitir_nfe' => false,
            'tb26_ambiente' => 'homologacao',
            'tb26_serie' => '1',
            'tb26_proximo_numero' => 1,
            'tb26_crt' => 1,
            'tb26_csc_id' => '1',
            'tb26_csc' => 'TOKENCSC',
            'tb26_certificado_tipo' => 'A1',
            'tb26_certificado_nome' => 'CERTIFICADO LOJA TESTE',
            'tb26_certificado_cnpj' => '11222333000144',
            'tb26_certificado_arquivo' => 'private/fiscal-certificados/1/certificado.pfx',
            'tb26_certificado_senha' => 'segredo',
            'tb26_razao_social' => 'EMPRESA TESTE LTDA',
            'tb26_ie' => '123456789',
            'tb26_logradouro' => 'RUA 1',
            'tb26_numero' => '10',
            'tb26_bairro' => 'CENTRO',
            'tb26_codigo_municipio' => '5300108',
            'tb26_municipio' => 'BRASILIA',
            'tb26_uf' => 'DF',
            'tb26_cep' => '70000000',
        ], $overrides));
    }

    private function makeService(): FiscalInvoicePreparationService
    {
        return new FiscalInvoicePreparationService(
            new FiscalCertificateService(),
            new FiscalNfceXmlService(new FiscalWebserviceResolverService()),
            new FiscalMunicipalityCodeService(),
        );
    }
}
