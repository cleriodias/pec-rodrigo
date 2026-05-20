<?php

namespace Tests\Feature;

use App\Models\CashierClosure;
use App\Models\Produto;
use App\Models\Unidade;
use App\Models\User;
use App\Models\Venda;
use App\Models\VendaPagamento;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CashierClosureOpenComandasTest extends TestCase
{
    use RefreshDatabase;

    protected function tearDown(): void
    {
        Carbon::setTestNow();

        parent::tearDown();
    }

    public function test_cashier_close_converts_open_comandas_to_faturar_and_clears_them(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-05-19 22:30:00'));

        $unit = $this->makeUnit('Setor-40');
        $cashier = $this->makeUser('Caixa', 3, $unit);
        $launcher = $this->makeUser('Lanchonete', 4, $unit);
        $productA = $this->makeProduct('PAO DE QUEIJO', 3.5);
        $productB = $this->makeProduct('CAFE', 2.0);
        $openedAt = Carbon::parse('2026-05-19 21:45:00');

        $saleA = $this->createOpenComandaSale($unit, $launcher, $productA, 3007, 2, $openedAt);
        $saleB = $this->createOpenComandaSale($unit, $launcher, $productB, 3007, 1, $openedAt->copy()->addMinutes(5));

        $response = $this
            ->actingAs($cashier)
            ->withSession($this->activeSessionPayload($unit, 3))
            ->post(route('cashier.close.store'), [
                'cash_amount' => 0,
                'card_amount' => 0,
                'open_comandas_observation' => 'Fechamento com baixa automatica de comanda.',
            ]);

        $response->assertRedirect(route('login'));

        $this->assertDatabaseHas('cashier_closures', [
            'user_id' => $cashier->id,
            'unit_id' => $unit->tb2_id,
            'open_comandas_observation' => 'Fechamento com baixa automatica de comanda.',
        ]);

        $this->assertDatabaseHas('tb4_vendas_pg', [
            'valor_total' => 9.0,
            'tipo_pagamento' => 'faturar',
            'valor_pago' => null,
            'troco' => 0,
            'dois_pgto' => 0,
        ]);

        $saleA->refresh();
        $saleB->refresh();

        $this->assertSame(1, $saleA->status);
        $this->assertSame(1, $saleB->status);
        $this->assertFalse((bool) $saleA->status_pago);
        $this->assertFalse((bool) $saleB->status_pago);
        $this->assertSame('faturar', $saleA->tipo_pago);
        $this->assertSame('faturar', $saleB->tipo_pago);
        $this->assertSame($cashier->id, $saleA->id_user_caixa);
        $this->assertSame($cashier->id, $saleB->id_user_caixa);
        $this->assertNotNull($saleA->tb4_id);
        $this->assertSame($saleA->tb4_id, $saleB->tb4_id);

        $this->assertSame(0, Venda::query()
            ->where('id_unidade', $unit->tb2_id)
            ->where('id_comanda', 3007)
            ->where('status', 0)
            ->count());
    }

    public function test_next_day_restrictions_do_not_keep_comanda_pending_after_cashier_close(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-05-19 22:30:00'));

        $unit = $this->makeUnit('Setor-41');
        $cashier = $this->makeUser('Caixa', 3, $unit);
        $launcher = $this->makeUser('Lanchonete', 4, $unit);
        $product = $this->makeProduct('SALGADO ASSADO', 5.0);
        $openedAt = Carbon::parse('2026-05-19 20:15:00');

        $this->createOpenComandaSale($unit, $launcher, $product, 3008, 1, $openedAt);

        $this
            ->actingAs($cashier)
            ->withSession($this->activeSessionPayload($unit, 3))
            ->post(route('cashier.close.store'), [
                'cash_amount' => 0,
                'card_amount' => 0,
                'open_comandas_observation' => 'Encerramento do turno com baixa em faturar.',
            ])
            ->assertRedirect(route('login'));

        Carbon::setTestNow(Carbon::parse('2026-05-20 08:00:00'));

        $response = $this
            ->actingAs($cashier)
            ->withSession($this->activeSessionPayload($unit, 3))
            ->getJson(route('sales.restrictions'));

        $response
            ->assertOk()
            ->assertJson([
                'requires_closure' => false,
                'pending_closure_date' => null,
                'pending_comandas' => [],
            ]);
    }

    private function createOpenComandaSale(
        Unidade $unit,
        User $launcher,
        Produto $product,
        int $comanda,
        int $quantity,
        Carbon $soldAt,
    ): Venda {
        $total = round((float) $product->tb1_vlr_venda * $quantity, 2);

        return Venda::create([
            'tb4_id' => null,
            'tb1_id' => $product->tb1_id,
            'id_comanda' => $comanda,
            'produto_nome' => $product->tb1_nome,
            'valor_unitario' => $product->tb1_vlr_venda,
            'quantidade' => $quantity,
            'valor_total' => $total,
            'data_hora' => $soldAt,
            'id_user_caixa' => null,
            'id_user_vale' => null,
            'id_lanc' => $launcher->id,
            'id_unidade' => $unit->tb2_id,
            'tipo_pago' => 'faturar',
            'status_pago' => false,
            'status' => 0,
            'created_at' => $soldAt,
            'updated_at' => $soldAt,
        ]);
    }

    private function makeUnit(string $name): Unidade
    {
        return Unidade::create([
            'tb2_nome' => $name,
            'tb2_endereco' => 'Endereco ' . $name,
            'tb2_cep' => '72900-000',
            'tb2_fone' => '(61) 99999-9999',
            'tb2_cnpj' => fake()->unique()->numerify('##.###.###/####-##'),
            'tb2_localizacao' => 'https://maps.example.com/' . fake()->slug(),
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

    private function makeProduct(string $name, float $price): Produto
    {
        return Produto::create([
            'tb1_nome' => $name,
            'tb1_vlr_custo' => max(0.5, round($price / 2, 2)),
            'tb1_vlr_venda' => $price,
            'tb1_codbar' => fake()->unique()->numerify('############'),
            'tb1_tipo' => 0,
            'tb1_status' => 1,
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
