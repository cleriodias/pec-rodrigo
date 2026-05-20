<?php

namespace Tests\Feature;

use App\Models\Produto;
use App\Models\Unidade;
use App\Models\User;
use App\Models\Venda;
use App\Support\FiscalInvoicePreparationService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Mockery\MockInterface;
use Tests\TestCase;

class SaleComandaLockingTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->mock(FiscalInvoicePreparationService::class, function (MockInterface $mock) {
            $mock->shouldReceive('prepareForPayment')->andReturn(null);
        });
    }

    public function test_lanchonete_cannot_add_item_while_comanda_is_being_received(): void
    {
        $unit = $this->makeUnit('Loja Comanda');
        $user = $this->makeUser('Lanchonete', 4, $unit);
        $product = $this->makeProduct(12, 'Torta salgada', 8.00);
        $lock = Cache::lock($this->comandaLockKey($unit->tb2_id, 3000), 10);

        $this->assertTrue($lock->get());

        try {
            $response = $this
                ->actingAs($user)
                ->withSession($this->activeSessionPayload($unit, 4))
                ->postJson(route('sales.comandas.add-item', ['codigo' => 3000]), [
                    'product_id' => $product->tb1_id,
                    'quantity' => 1,
                    'access_user_id' => $user->id,
                ]);

            $response
                ->assertStatus(409)
                ->assertJsonPath('message', 'A comanda esta em recebimento no caixa. Aguarde a finalizacao e recarregue.');

            $this->assertDatabaseCount('tb3_vendas', 0);
        } finally {
            $lock->release();
        }
    }

    public function test_cashier_cannot_finalize_comanda_while_it_is_locked(): void
    {
        $unit = $this->makeUnit('Loja Caixa');
        $cashier = $this->makeUser('Caixa', 3, $unit);
        $lanchonete = $this->makeUser('Lanchonete', 4, $unit);
        $product = $this->makeProduct(18, 'Bolo caseiro', 8.00);

        Venda::create([
            'tb1_id' => $product->tb1_id,
            'id_comanda' => 3000,
            'produto_nome' => $product->tb1_nome,
            'valor_unitario' => 8.00,
            'quantidade' => 1,
            'valor_total' => 8.00,
            'data_hora' => now(),
            'id_user_caixa' => null,
            'id_user_vale' => null,
            'id_lanc' => $lanchonete->id,
            'id_unidade' => $unit->tb2_id,
            'tipo_pago' => 'faturar',
            'status_pago' => false,
            'status' => 0,
        ]);

        $lock = Cache::lock($this->comandaLockKey($unit->tb2_id, 3000), 10);

        $this->assertTrue($lock->get());

        try {
            $response = $this
                ->actingAs($cashier)
                ->withSession($this->activeSessionPayload($unit, 3))
                ->postJson(route('sales.store'), [
                    'tipo_pago' => 'maquina',
                    'comanda_codigo' => 3000,
                    'items' => [
                        [
                            'product_id' => $product->tb1_id,
                            'quantity' => 1,
                            'unit_price' => 8.00,
                        ],
                    ],
                ]);

            $response
                ->assertStatus(422)
                ->assertJsonValidationErrors(['comanda_codigo']);

            $this->assertDatabaseCount('tb4_vendas_pg', 0);
            $this->assertDatabaseHas('tb3_vendas', [
                'id_comanda' => 3000,
                'status' => 0,
            ]);
        } finally {
            $lock->release();
        }
    }

    public function test_cashier_receives_all_open_items_of_comanda_in_one_transaction(): void
    {
        $unit = $this->makeUnit('Loja Centro');
        $cashier = $this->makeUser('Caixa', 3, $unit);
        $lanchonete = $this->makeUser('Lanchonete', 4, $unit);
        $itemA = $this->makeProduct(31, 'Item 8', 8.00);
        $itemB = $this->makeProduct(32, 'Item 6', 6.00);

        Venda::create([
            'tb1_id' => $itemA->tb1_id,
            'id_comanda' => 3001,
            'produto_nome' => $itemA->tb1_nome,
            'valor_unitario' => 8.00,
            'quantidade' => 1,
            'valor_total' => 8.00,
            'data_hora' => now()->subMinutes(3),
            'id_user_caixa' => null,
            'id_user_vale' => null,
            'id_lanc' => $lanchonete->id,
            'id_unidade' => $unit->tb2_id,
            'tipo_pago' => 'faturar',
            'status_pago' => false,
            'status' => 0,
        ]);

        Venda::create([
            'tb1_id' => $itemB->tb1_id,
            'id_comanda' => 3001,
            'produto_nome' => $itemB->tb1_nome,
            'valor_unitario' => 6.00,
            'quantidade' => 1,
            'valor_total' => 6.00,
            'data_hora' => now()->subMinute(),
            'id_user_caixa' => null,
            'id_user_vale' => null,
            'id_lanc' => $lanchonete->id,
            'id_unidade' => $unit->tb2_id,
            'tipo_pago' => 'faturar',
            'status_pago' => false,
            'status' => 0,
        ]);

        $response = $this
            ->actingAs($cashier)
            ->withSession($this->activeSessionPayload($unit, 3))
            ->postJson(route('sales.store'), [
                'tipo_pago' => 'maquina',
                'comanda_codigo' => 3001,
                'items' => [
                    [
                        'product_id' => $itemA->tb1_id,
                        'quantity' => 1,
                        'unit_price' => 8.00,
                    ],
                ],
            ]);

        $response
            ->assertOk()
            ->assertJsonPath('sale.total', 14.0)
            ->assertJsonPath('sale.comanda', 3001);

        $paymentId = (int) $response->json('sale.id');

        $this->assertDatabaseHas('tb4_vendas_pg', [
            'tb4_id' => $paymentId,
            'valor_total' => 14.00,
            'tipo_pagamento' => 'maquina',
        ]);

        $this->assertDatabaseHas('tb3_vendas', [
            'id_comanda' => 3001,
            'tb1_id' => $itemA->tb1_id,
            'tb4_id' => $paymentId,
            'status' => 1,
        ]);

        $this->assertDatabaseHas('tb3_vendas', [
            'id_comanda' => 3001,
            'tb1_id' => $itemB->tb1_id,
            'tb4_id' => $paymentId,
            'status' => 1,
        ]);
    }

    private function comandaLockKey(int $unitId, int $codigo): string
    {
        return sprintf('sale-comanda-unit-%d-codigo-%d', $unitId, $codigo);
    }

    private function makeUnit(string $name): Unidade
    {
        return Unidade::create([
            'tb2_nome' => $name,
            'tb2_endereco' => 'Endereco '.$name,
            'tb2_cep' => '72900-000',
            'tb2_fone' => '(61) 99999-9999',
            'tb2_cnpj' => fake()->unique()->numerify('##.###.###/####-##'),
            'tb2_localizacao' => 'https://maps.example.com/'.fake()->slug(),
        ]);
    }

    private function makeUser(string $name, int $role, Unidade $unit): User
    {
        $user = User::factory()->create([
            'name' => $name,
            'email' => fake()->unique()->safeEmail(),
            'funcao' => $role,
            'funcao_original' => $role,
            'tb2_id' => $unit->tb2_id,
        ]);

        $user->units()->sync([$unit->tb2_id]);

        return $user;
    }

    private function makeProduct(int $id, string $name, float $salePrice): Produto
    {
        return Produto::create([
            'tb1_id' => $id,
            'tb1_nome' => $name,
            'tb1_vlr_custo' => 0,
            'tb1_vlr_venda' => $salePrice,
            'tb1_codbar' => fake()->unique()->numerify('############'),
            'tb1_tipo' => 0,
            'tb1_status' => 1,
            'tb1_vr_credit' => false,
        ]);
    }

    private function activeSessionPayload(Unidade $unit, int $role): array
    {
        return [
            'active_unit' => [
                'id' => $unit->tb2_id,
                'name' => $unit->tb2_nome,
                'address' => $unit->tb2_endereco,
                'cnpj' => $unit->tb2_cnpj,
            ],
            'active_role' => $role,
        ];
    }
}
