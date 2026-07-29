<?php

namespace Tests\Feature;

use App\Models\ConfiguracaoFiscal;
use App\Models\NotaFiscal;
use App\Models\Produto;
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
        $this->assertStringContainsString('novo numero', session('success'));
    }
}
