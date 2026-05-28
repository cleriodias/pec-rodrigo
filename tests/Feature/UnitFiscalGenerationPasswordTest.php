<?php

namespace Tests\Feature;

use App\Models\ConfiguracaoFiscal;
use App\Models\Unidade;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UnitFiscalGenerationPasswordTest extends TestCase
{
    use RefreshDatabase;

    public function test_fiscal_generation_activation_requires_current_password(): void
    {
        $unit = $this->makeUnit();
        $admin = $this->makeMaster($unit);

        ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_geracao_automatica_ativa' => false,
        ]);

        $response = $this
            ->actingAs($admin)
            ->from(route('units.index'))
            ->patch(route('units.fiscal-generation.toggle', ['unit' => $unit->tb2_id]));

        $response
            ->assertRedirect(route('units.index'))
            ->assertSessionHasErrors('current_password');

        $this->assertFalse(
            (bool) ConfiguracaoFiscal::where('tb2_id', $unit->tb2_id)
                ->value('tb26_geracao_automatica_ativa')
        );
    }

    public function test_fiscal_generation_activation_rejects_wrong_password(): void
    {
        $unit = $this->makeUnit();
        $admin = $this->makeMaster($unit);

        ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_geracao_automatica_ativa' => false,
        ]);

        $response = $this
            ->actingAs($admin)
            ->from(route('units.index'))
            ->patch(route('units.fiscal-generation.toggle', ['unit' => $unit->tb2_id]), [
                'current_password' => 'senha-errada',
            ]);

        $response
            ->assertRedirect(route('units.index'))
            ->assertSessionHasErrors('current_password');

        $this->assertFalse(
            (bool) ConfiguracaoFiscal::where('tb2_id', $unit->tb2_id)
                ->value('tb26_geracao_automatica_ativa')
        );
    }

    public function test_fiscal_generation_activation_accepts_current_password(): void
    {
        $unit = $this->makeUnit();
        $admin = $this->makeMaster($unit);

        ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_geracao_automatica_ativa' => false,
        ]);

        $response = $this
            ->actingAs($admin)
            ->from(route('units.index'))
            ->patch(route('units.fiscal-generation.toggle', ['unit' => $unit->tb2_id]), [
                'current_password' => 'password',
            ]);

        $response
            ->assertRedirect(route('units.index'))
            ->assertSessionHasNoErrors()
            ->assertSessionHas('success', 'Geracao automatica de notas ativada com sucesso.');

        $this->assertTrue(
            (bool) ConfiguracaoFiscal::where('tb2_id', $unit->tb2_id)
                ->value('tb26_geracao_automatica_ativa')
        );
    }

    public function test_fiscal_generation_deactivation_does_not_require_password(): void
    {
        $unit = $this->makeUnit();
        $admin = $this->makeMaster($unit);

        ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_geracao_automatica_ativa' => true,
        ]);

        $response = $this
            ->actingAs($admin)
            ->from(route('units.index'))
            ->patch(route('units.fiscal-generation.toggle', ['unit' => $unit->tb2_id]));

        $response
            ->assertRedirect(route('units.index'))
            ->assertSessionHasNoErrors()
            ->assertSessionHas('success', 'Geracao automatica de notas desativada com sucesso.');

        $this->assertFalse(
            (bool) ConfiguracaoFiscal::where('tb2_id', $unit->tb2_id)
                ->value('tb26_geracao_automatica_ativa')
        );
    }

    public function test_manager_cannot_activate_fiscal_generation_from_units_toggle(): void
    {
        $unit = $this->makeUnit();
        $manager = $this->makeManager($unit);

        ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_geracao_automatica_ativa' => false,
        ]);

        $response = $this
            ->actingAs($manager)
            ->from(route('units.index'))
            ->patch(route('units.fiscal-generation.toggle', ['unit' => $unit->tb2_id]), [
                'current_password' => 'password',
            ]);

        $response->assertForbidden();

        $this->assertFalse(
            (bool) ConfiguracaoFiscal::where('tb2_id', $unit->tb2_id)
                ->value('tb26_geracao_automatica_ativa')
        );
    }

    public function test_manager_fiscal_configuration_save_does_not_activate_generation(): void
    {
        $unit = $this->makeUnit();
        $manager = $this->makeManager($unit);

        ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_geracao_automatica_ativa' => false,
            'tb26_ambiente' => 'homologacao',
            'tb26_serie' => '1',
            'tb26_proximo_numero' => 1,
        ]);

        $response = $this
            ->actingAs($manager)
            ->from(route('settings.fiscal', ['unit_id' => $unit->tb2_id]))
            ->post(route('settings.fiscal.update'), [
                'tb2_id' => $unit->tb2_id,
                'tb26_emitir_nfe' => false,
                'tb26_emitir_nfce' => false,
                'tb26_ambiente' => 'homologacao',
                'tb26_serie' => '1',
                'tb26_proximo_numero' => 2,
            ]);

        $response
            ->assertRedirect(route('settings.fiscal', ['unit_id' => $unit->tb2_id]))
            ->assertSessionHasNoErrors()
            ->assertSessionHas('success', 'Configuracao fiscal atualizada com sucesso.');

        $this->assertFalse(
            (bool) ConfiguracaoFiscal::where('tb2_id', $unit->tb2_id)
                ->value('tb26_geracao_automatica_ativa')
        );
    }

    public function test_manager_cannot_activate_fiscal_generation_from_fiscal_configuration(): void
    {
        $unit = $this->makeUnit();
        $manager = $this->makeManager($unit);

        ConfiguracaoFiscal::create([
            'tb2_id' => $unit->tb2_id,
            'tb26_geracao_automatica_ativa' => false,
            'tb26_ambiente' => 'homologacao',
            'tb26_serie' => '1',
            'tb26_proximo_numero' => 1,
        ]);

        $response = $this
            ->actingAs($manager)
            ->from(route('settings.fiscal', ['unit_id' => $unit->tb2_id]))
            ->post(route('settings.fiscal.update'), [
                'tb2_id' => $unit->tb2_id,
                'tb26_emitir_nfe' => false,
                'tb26_emitir_nfce' => false,
                'tb26_geracao_automatica_ativa' => true,
                'tb26_ambiente' => 'homologacao',
                'tb26_serie' => '1',
                'tb26_proximo_numero' => 2,
            ]);

        $response
            ->assertRedirect(route('settings.fiscal', ['unit_id' => $unit->tb2_id]))
            ->assertSessionHasErrors('tb26_geracao_automatica_ativa');

        $this->assertFalse(
            (bool) ConfiguracaoFiscal::where('tb2_id', $unit->tb2_id)
                ->value('tb26_geracao_automatica_ativa')
        );
    }

    private function makeUnit(): Unidade
    {
        return Unidade::create([
            'tb2_nome' => 'Loja Fiscal',
            'tb2_endereco' => 'Endereco Loja Fiscal',
            'tb2_cep' => '72900-000',
            'tb2_fone' => '(61) 99999-9999',
            'tb2_cnpj' => '12.345.678/0001-99',
            'tb2_localizacao' => 'https://maps.example.com',
            'tb2_status' => 1,
        ]);
    }

    private function makeMaster(Unidade $unit): User
    {
        return $this->makeUser($unit, 0);
    }

    private function makeManager(Unidade $unit): User
    {
        return $this->makeUser($unit, 1);
    }

    private function makeUser(Unidade $unit, int $role): User
    {
        return User::factory()->create([
            'funcao' => $role,
            'funcao_original' => $role,
            'tb2_id' => $unit->tb2_id,
        ]);
    }
}
