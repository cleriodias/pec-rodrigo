<?php

namespace Tests\Feature;

use App\Models\ConfiguracaoFiscal;
use App\Models\NotaFiscal;
use App\Models\Produto;
use App\Models\ProdutoTributacaoFiscalUnidade;
use App\Models\Unidade;
use App\Models\User;
use App\Models\Venda;
use App\Models\VendaPagamento;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FiscalInvoiceRegenerationTest extends TestCase
{
    use RefreshDatabase;

    public function test_regenerating_with_new_number_consumes_next_fiscal_number(): void
    {
        $unit = Unidade::create([
            'tb2_nome' => 'Loja teste',
            'tb2_endereco' => 'Rua 1',
            'tb2_cep' => '72900-000',
            'tb2_fone' => '(61) 99999-9999',
            'tb2_cnpj' => '11.222.333/0001-44',
            'tb2_localizacao' => 'https://maps.example.com/loja-teste',
        ]);
        $admin = User::factory()->create([
            'funcao' => 0,
            'funcao_original' => 0,
            'tb2_id' => $unit->tb2_id,
        ]);
        $configuration = ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_emitir_nfce' => true,
            'tb26_emitir_nfe' => false,
            'tb26_ambiente' => 'homologacao',
            'tb26_serie' => '1',
            'tb26_proximo_numero' => 1380,
            'tb26_crt' => 1,
            'tb26_csc_id' => '1',
            'tb26_csc' => 'TOKENCSC',
            'tb26_certificado_tipo' => 'A1',
            'tb26_certificado_nome' => 'CERTIFICADO LOJA TESTE',
            'tb26_certificado_cnpj' => '11222333000144',
            'tb26_certificado_arquivo' => 'private/fiscal-certificados/1/certificado.pfx',
            'tb26_certificado_senha_compartilhada' => 'segredo',
            'tb26_razao_social' => 'EMPRESA TESTE LTDA',
            'tb26_ie' => '123456789',
            'tb26_logradouro' => 'RUA 1',
            'tb26_numero' => '10',
            'tb26_bairro' => 'CENTRO',
            'tb26_codigo_municipio' => '5300108',
            'tb26_municipio' => 'BRASILIA',
            'tb26_uf' => 'DF',
            'tb26_cep' => '70000000',
        ]);
        $product = Produto::create([
            'tb1_nome' => 'Produto fiscal',
            'tb1_vlr_custo' => 5,
            'tb1_vlr_venda' => 10,
            'tb1_codbar' => '7891000000000',
            'tb1_ncm' => '19059090',
            'tb1_cfop' => '5102',
            'tb1_unidade_comercial' => 'UN',
            'tb1_unidade_tributavel' => 'UN',
            'tb1_origem' => 0,
            'tb1_csosn' => '102',
            'tb1_tipo' => 0,
            'tb1_status' => 1,
        ]);
        $payment = VendaPagamento::create([
            'valor_total' => 10,
            'tipo_pagamento' => 'dinheiro',
            'valor_pago' => 10,
            'troco' => 0,
            'dois_pgto' => 0,
        ]);

        Venda::create([
            'tb4_id' => $payment->tb4_id,
            'tb1_id' => $product->tb1_id,
            'produto_nome' => $product->tb1_nome,
            'valor_unitario' => 10,
            'quantidade' => 1,
            'valor_total' => 10,
            'data_hora' => now(),
            'id_user_caixa' => $admin->id,
            'id_unidade' => $unit->tb2_id,
            'tipo_pago' => 'dinheiro',
            'status_pago' => true,
            'status' => 1,
        ]);

        $invoice = NotaFiscal::create([
            'tb4_id' => $payment->tb4_id,
            'tb2_id' => $unit->tb2_id,
            'tb26_id' => $configuration->tb26_id,
            'tb27_modelo' => 'nfce',
            'tb27_ambiente' => 'homologacao',
            'tb27_serie' => '1',
            'tb27_numero' => 1375,
            'tb27_status' => 'erro_transmissao',
            'tb27_payload' => [],
            'tb27_erros' => [],
            'tb27_chave_acesso' => 'old-access-key',
            'tb27_protocolo' => 'old-protocol',
            'tb27_recibo' => 'old-receipt',
            'tb27_xml_envio' => '<xml>old</xml>',
            'tb27_xml_retorno' => '<retorno>old</retorno>',
            'tb27_mensagem' => 'cStat 204 - Rejeicao: Duplicidade de NF-e',
        ]);

        $this
            ->actingAs($admin)
            ->from(route('settings.nfe', ['unit_id' => $unit->tb2_id]))
            ->post(route('settings.fiscal.invoices.regenerate', [
                'notaFiscal' => $invoice->tb27_id,
                'origin' => 'nfe',
                'unit_id' => $unit->tb2_id,
                'force_new_number' => 1,
            ]))
            ->assertRedirect();

        $invoice->refresh();
        $configuration->refresh();

        $this->assertSame(1380, $invoice->tb27_numero);
        $this->assertSame(1381, $configuration->tb26_proximo_numero);
        $this->assertNull($invoice->tb27_protocolo);
        $this->assertNull($invoice->tb27_recibo);
        $this->assertNull($invoice->tb27_xml_retorno);
        $this->assertStringContainsString('novo numero', session('success') ?? session('error'));
    }

    public function test_regenerating_invoice_refreshes_rtc_tax_snapshot_from_active_rule(): void
    {
        $unit = Unidade::create([
            'tb2_nome' => 'Loja teste',
            'tb2_endereco' => 'Rua 1',
            'tb2_cep' => '72900-000',
            'tb2_fone' => '(61) 99999-9999',
            'tb2_cnpj' => '11.222.333/0001-44',
            'tb2_localizacao' => 'https://maps.example.com/loja-teste',
        ]);
        $admin = User::factory()->create([
            'funcao' => 0,
            'funcao_original' => 0,
            'tb2_id' => $unit->tb2_id,
        ]);
        $configuration = ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_emitir_nfce' => true,
            'tb26_emitir_nfe' => false,
            'tb26_geracao_automatica_ativa' => true,
            'tb26_rtc_2026_ativa' => true,
            'tb26_ambiente' => 'homologacao',
            'tb26_serie' => '1',
            'tb26_proximo_numero' => 1380,
            'tb26_crt' => 3,
            'tb26_regime_tributario' => 'lucro_presumido',
            'tb26_csc_id' => '1',
            'tb26_csc' => 'TOKENCSC',
            'tb26_certificado_tipo' => 'A1',
            'tb26_certificado_nome' => 'CERTIFICADO LOJA TESTE',
            'tb26_certificado_cnpj' => '11222333000144',
            'tb26_certificado_arquivo' => 'private/fiscal-certificados/1/certificado.pfx',
            'tb26_certificado_senha_compartilhada' => 'segredo',
            'tb26_razao_social' => 'EMPRESA TESTE LTDA',
            'tb26_ie' => '123456789',
            'tb26_logradouro' => 'RUA 1',
            'tb26_numero' => '10',
            'tb26_bairro' => 'CENTRO',
            'tb26_codigo_municipio' => '5300108',
            'tb26_municipio' => 'BRASILIA',
            'tb26_uf' => 'DF',
            'tb26_cep' => '70000000',
        ]);
        $product = Produto::create([
            'tb1_nome' => 'Produto fiscal',
            'tb1_vlr_custo' => 5,
            'tb1_vlr_venda' => 10,
            'tb1_codbar' => '7891000000000',
            'tb1_ncm' => '19059090',
            'tb1_cfop' => '5102',
            'tb1_unidade_comercial' => 'UN',
            'tb1_unidade_tributavel' => 'UN',
            'tb1_origem' => 0,
            'tb1_cst' => '00',
            'tb1_tipo' => 0,
            'tb1_status' => 1,
        ]);
        ProdutoTributacaoFiscalUnidade::create([
            'tb1_id' => $product->tb1_id,
            'tb2_id' => $unit->tb2_id,
            'tb28_cst_icms' => '00',
            'tb28_aliquota_icms' => 0,
            'tb28_cst_pis' => '00',
            'tb28_aliquota_pis' => 0,
            'tb28_cst_cofins' => '00',
            'tb28_aliquota_cofins' => 0,
            'tb28_cst_ibs_cbs' => '000',
            'tb28_cclass_trib' => '000001',
            'tb28_aliquota_ibs_uf' => 0,
            'tb28_aliquota_ibs_mun' => 0,
            'tb28_aliquota_cbs' => 0,
            'tb28_reducao_ibs_uf' => 0,
            'tb28_reducao_ibs_mun' => 0,
            'tb28_reducao_cbs' => 0,
            'tb28_ativo' => true,
        ]);
        $payment = VendaPagamento::create([
            'valor_total' => 10,
            'tipo_pagamento' => 'dinheiro',
            'valor_pago' => 10,
            'troco' => 0,
            'dois_pgto' => 0,
        ]);

        Venda::create([
            'tb4_id' => $payment->tb4_id,
            'tb1_id' => $product->tb1_id,
            'produto_nome' => $product->tb1_nome,
            'valor_unitario' => 10,
            'quantidade' => 1,
            'valor_total' => 10,
            'data_hora' => now(),
            'id_user_caixa' => $admin->id,
            'id_unidade' => $unit->tb2_id,
            'tipo_pago' => 'dinheiro',
            'status_pago' => true,
            'status' => 1,
        ]);

        $invoice = NotaFiscal::create([
            'tb4_id' => $payment->tb4_id,
            'tb2_id' => $unit->tb2_id,
            'tb26_id' => $configuration->tb26_id,
            'tb27_modelo' => 'nfce',
            'tb27_ambiente' => 'homologacao',
            'tb27_serie' => '1',
            'tb27_numero' => 1375,
            'tb27_status' => 'erro_validacao',
            'tb27_payload' => [
                'tributacao_rtc_2026' => [
                    (string) $product->tb1_id => [
                        'regime_tributario' => 'lucro_presumido',
                        'cst_icms' => '00',
                        'aliquota_icms' => 0,
                        'cst_pis' => '01',
                        'aliquota_pis' => 0,
                        'cst_cofins' => '01',
                        'aliquota_cofins' => 0,
                        'cst_ibs_cbs' => '000',
                        'cclass_trib' => '000001',
                        'aliquota_ibs_uf' => 0,
                        'aliquota_ibs_mun' => 0,
                        'aliquota_cbs' => 0,
                    ],
                ],
            ],
            'tb27_erros' => [],
            'tb27_mensagem' => 'snapshot antigo',
        ]);

        $this
            ->actingAs($admin)
            ->from(route('settings.nfe', ['unit_id' => $unit->tb2_id]))
            ->post(route('settings.fiscal.invoices.regenerate', [
                'notaFiscal' => $invoice->tb27_id,
                'origin' => 'nfe',
                'unit_id' => $unit->tb2_id,
            ]))
            ->assertRedirect();

        $invoice->refresh();

        $snapshot = $invoice->tb27_payload['tributacao_rtc_2026'][(string) $product->tb1_id];
        $this->assertSame('00', $snapshot['cst_pis']);
        $this->assertSame('00', $snapshot['cst_cofins']);
    }
}
