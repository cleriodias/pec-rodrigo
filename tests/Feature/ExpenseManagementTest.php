<?php

namespace Tests\Feature;

use App\Models\Expense;
use App\Models\Supplier;
use App\Models\Unidade;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExpenseManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_manager_can_store_expense_with_date_from_form(): void
    {
        $unit = $this->createActiveUnit();
        $manager = User::factory()->create([
            'funcao' => 1,
            'funcao_original' => 1,
            'tb2_id' => $unit->tb2_id,
        ]);
        $supplier = Supplier::create([
            'name' => 'Fornecedor Teste',
            'dispute' => false,
            'access_code' => 'F001',
        ]);

        $response = $this
            ->actingAs($manager)
            ->from(route('expenses.index'))
            ->post(route('expenses.store'), [
                'supplier_id' => $supplier->id,
                'expense_date' => '2026-04-27',
                'amount' => '45.90',
                'notes' => 'Compra emergencial',
            ]);

        $response
            ->assertRedirect(route('expenses.index'))
            ->assertSessionHasNoErrors();

        $this->assertSame(1, Expense::count());
        $this->assertDatabaseHas('expenses', [
            'supplier_id' => $supplier->id,
            'unit_id' => $unit->tb2_id,
            'user_id' => $manager->id,
            'expense_date' => '2026-04-27',
            'amount' => 45.90,
            'notes' => 'Compra emergencial',
        ]);
    }

    private function createActiveUnit(array $overrides = []): Unidade
    {
        return Unidade::query()->create(array_merge([
            'tb2_nome' => 'Loja Centro',
            'tb2_endereco' => 'Rua A, 10',
            'tb2_cep' => '01000-000',
            'tb2_fone' => '11999999999',
            'tb2_cnpj' => '12.345.678/0001-99',
            'tb2_localizacao' => 'Centro',
            'tb2_status' => 1,
        ], $overrides));
    }
}
