<?php

namespace Tests\Feature;

use App\Models\Produto;
use App\Models\Unidade;
use App\Models\User;
use App\Models\Venda;
use App\Models\VendaPagamento;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Inertia\Testing\AssertableInertia as Assert;
use Tests\TestCase;

class SalesReportLanchoneteTest extends TestCase
{
    use RefreshDatabase;

    protected function tearDown(): void
    {
        Carbon::setTestNow();

        parent::tearDown();
    }

    public function test_lanchonete_report_separates_paid_and_open_items_from_same_comanda(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-04-28 18:00:00'));

        $unit = $this->makeUnit('Setor 10');
        $manager = $this->makeUser('Gerente', 1, $unit, [$unit]);
        $cashierAmanda = $this->makeUser('Amanda', 3, $unit);
        $lanchoneteChaiene = $this->makeUser('Chaiene', 4, $unit);
        $lanchoneteJoseli = $this->makeUser('Joseli', 4, $unit);

        $morningPaymentTime = Carbon::parse('2026-04-28 10:40:00');
        $morningPayment = VendaPagamento::create([
            'valor_total' => 23,
            'tipo_pagamento' => 'maquina',
            'valor_pago' => null,
            'troco' => 0,
            'dois_pgto' => 0,
            'created_at' => $morningPaymentTime,
            'updated_at' => $morningPaymentTime,
        ]);

        $this->createSale(
            unit: $unit,
            product: $this->makeProduct('PAO DE QUEIJO GRANDE', 3),
            cashier: $cashierAmanda,
            launchedBy: $lanchoneteChaiene,
            payment: $morningPayment,
            comanda: 3007,
            quantity: 2,
            soldAt: Carbon::parse('2026-04-28 10:34:00'),
            status: 1,
            paymentType: 'maquina',
            paid: true,
        );

        $this->createSale(
            unit: $unit,
            product: $this->makeProduct('CAFE GRANDE', 4),
            cashier: $cashierAmanda,
            launchedBy: $lanchoneteChaiene,
            payment: $morningPayment,
            comanda: 3007,
            quantity: 2,
            soldAt: Carbon::parse('2026-04-28 10:34:00'),
            status: 1,
            paymentType: 'maquina',
            paid: true,
        );

        $this->createSale(
            unit: $unit,
            product: $this->makeProduct('PAO COM OVO', 4.5),
            cashier: $cashierAmanda,
            launchedBy: $lanchoneteChaiene,
            payment: $morningPayment,
            comanda: 3007,
            quantity: 1,
            soldAt: Carbon::parse('2026-04-28 10:34:00'),
            status: 1,
            paymentType: 'maquina',
            paid: true,
        );

        $this->createSale(
            unit: $unit,
            product: $this->makeProduct('ADICIONAL', 2),
            cashier: $cashierAmanda,
            launchedBy: $lanchoneteChaiene,
            payment: $morningPayment,
            comanda: 3007,
            quantity: 1,
            soldAt: Carbon::parse('2026-04-28 10:34:00'),
            status: 1,
            paymentType: 'maquina',
            paid: true,
        );

        $this->createSale(
            unit: $unit,
            product: $this->makeProduct('PAO DE SAL', 2.5),
            cashier: $cashierAmanda,
            launchedBy: $cashierAmanda,
            payment: $morningPayment,
            comanda: 3007,
            quantity: 1,
            soldAt: Carbon::parse('2026-04-28 10:34:00'),
            status: 1,
            paymentType: 'maquina',
            paid: true,
        );

        $this->createSale(
            unit: $unit,
            product: $this->makeProduct('SALGADO ASSADO', 5),
            cashier: null,
            launchedBy: $lanchoneteJoseli,
            payment: null,
            comanda: 3007,
            quantity: 1,
            soldAt: Carbon::parse('2026-04-28 17:33:00'),
            status: 0,
            paymentType: 'faturar',
            paid: false,
        );

        $response = $this
            ->actingAs($manager)
            ->withSession($this->activeSessionPayload($unit))
            ->get(route('reports.lanchonete', [
                'date' => '2026-04-28',
            ]));

        $response->assertOk()->assertInertia(fn (Assert $page) => $page
            ->component('Reports/Lanchonete')
            ->has('openComandas', 1)
            ->where('openComandas.0.comanda', 3007)
            ->where('openComandas.0.total', 5.0)
            ->where('openComandas.0.quantity', 1)
            ->has('openComandas.0.items', 1)
            ->where('openComandas.0.items.0.name', 'SALGADO ASSADO')
            ->where('openComandas.0.items.0.cashier', null)
            ->where('openComandas.0.items.0.launched_by', 'Joseli')
            ->has('closedComandas', 1)
            ->where('closedComandas.0.comanda', 3007)
            ->where('closedComandas.0.total', 23.0)
            ->where('closedComandas.0.quantity', 7)
            ->where('closedComandas.0.payment_type', 'maquina')
            ->has('closedComandas.0.items', 5)
        );
    }

    private function createSale(
        Unidade $unit,
        Produto $product,
        ?User $cashier,
        User $launchedBy,
        ?VendaPagamento $payment,
        int $comanda,
        int $quantity,
        Carbon $soldAt,
        int $status,
        string $paymentType,
        bool $paid,
    ): void {
        $total = round((float) $product->tb1_vlr_venda * $quantity, 2);

        Venda::create([
            'tb4_id' => $payment?->tb4_id,
            'tb1_id' => $product->tb1_id,
            'id_comanda' => $comanda,
            'produto_nome' => $product->tb1_nome,
            'valor_unitario' => $product->tb1_vlr_venda,
            'quantidade' => $quantity,
            'valor_total' => $total,
            'data_hora' => $soldAt,
            'id_user_caixa' => $cashier?->id,
            'id_user_vale' => null,
            'id_lanc' => $launchedBy->id,
            'id_unidade' => $unit->tb2_id,
            'tipo_pago' => $paymentType,
            'status_pago' => $paid,
            'status' => $status,
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

    private function makeUser(string $name, int $role, Unidade $primaryUnit, array $allowedUnits = []): User
    {
        $user = User::factory()->create([
            'name' => $name,
            'email' => fake()->unique()->safeEmail(),
            'funcao' => $role,
            'funcao_original' => $role,
            'tb2_id' => $primaryUnit->tb2_id,
        ]);

        $unitIds = collect($allowedUnits)
            ->prepend($primaryUnit)
            ->map(fn ($unit) => $unit instanceof Unidade ? $unit->tb2_id : (int) $unit)
            ->filter()
            ->unique()
            ->values()
            ->all();

        $user->units()->sync($unitIds);

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

    private function activeSessionPayload(Unidade $unit): array
    {
        return [
            'active_unit' => [
                'id' => $unit->tb2_id,
                'name' => $unit->tb2_nome,
                'address' => $unit->tb2_endereco,
                'cnpj' => $unit->tb2_cnpj,
            ],
            'active_role' => 1,
        ];
    }
}
