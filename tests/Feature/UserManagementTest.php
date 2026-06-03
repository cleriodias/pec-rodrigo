<?php

namespace Tests\Feature;

use App\Models\Unidade;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_edit_user_updates_funcao_original_with_new_role(): void
    {
        $unit = $this->makeUnit('Loja Gestao');

        $manager = User::factory()->create([
            'name' => 'Master Gestao',
            'email' => 'master.gestao@example.com',
            'funcao' => 0,
            'funcao_original' => 0,
            'tb2_id' => $unit->tb2_id,
        ]);
        $manager->units()->sync([$unit->tb2_id]);

        $targetUser = User::factory()->create([
            'name' => 'Usuario Teste',
            'email' => 'usuario.teste@example.com',
            'funcao' => 5,
            'funcao_original' => 5,
            'tb2_id' => $unit->tb2_id,
            'hr_ini' => '08:00',
            'hr_fim' => '17:00',
            'salario' => 1518.00,
            'vr_cred' => 350.00,
        ]);
        $targetUser->units()->sync([$unit->tb2_id]);

        $response = $this
            ->actingAs($manager)
            ->put(route('users.update', ['user' => $targetUser->id]), [
                'name' => 'Usuario Ajustado',
                'email' => 'usuario.ajustado@example.com',
                'funcao' => 3,
                'hr_ini' => '09:00',
                'hr_fim' => '18:00',
                'salario' => 2100.50,
                'vr_cred' => 420.75,
                'tb2_id' => [$unit->tb2_id],
            ]);

        $response->assertRedirect(route('users.show', ['user' => $targetUser->id]));

        $this->assertDatabaseHas('users', [
            'id' => $targetUser->id,
            'name' => 'Usuario Ajustado',
            'email' => 'usuario.ajustado@example.com',
            'funcao' => 3,
            'funcao_original' => 3,
            'tb2_id' => $unit->tb2_id,
        ]);
    }

    public function test_manager_can_inactivate_and_reactivate_user(): void
    {
        $unit = $this->makeUnit('Loja Ativacao');

        $manager = User::factory()->create([
            'name' => 'Master Ativacao',
            'email' => 'master.ativacao@example.com',
            'funcao' => 0,
            'funcao_original' => 0,
            'tb2_id' => $unit->tb2_id,
            'is_active' => true,
        ]);
        $manager->units()->sync([$unit->tb2_id]);

        $targetUser = User::factory()->create([
            'name' => 'Usuario Ativo',
            'email' => 'usuario.ativo@example.com',
            'funcao' => 4,
            'funcao_original' => 4,
            'tb2_id' => $unit->tb2_id,
            'is_active' => true,
        ]);
        $targetUser->units()->sync([$unit->tb2_id]);

        $this->actingAs($manager)
            ->from(route('users.index'))
            ->patch(route('users.toggle-active', ['user' => $targetUser->id]))
            ->assertRedirect(route('users.index'));

        $this->assertDatabaseHas('users', [
            'id' => $targetUser->id,
            'is_active' => false,
        ]);

        $this->actingAs($manager)
            ->from(route('users.index'))
            ->patch(route('users.toggle-active', ['user' => $targetUser->id]))
            ->assertRedirect(route('users.index'));

        $this->assertDatabaseHas('users', [
            'id' => $targetUser->id,
            'is_active' => true,
        ]);
    }

    public function test_manager_cannot_inactivate_own_user(): void
    {
        $unit = $this->makeUnit('Loja Propria');

        $manager = User::factory()->create([
            'name' => 'Master Proprio',
            'email' => 'master.proprio@example.com',
            'funcao' => 0,
            'funcao_original' => 0,
            'tb2_id' => $unit->tb2_id,
            'is_active' => true,
        ]);
        $manager->units()->sync([$unit->tb2_id]);

        $this->actingAs($manager)
            ->from(route('users.edit', ['user' => $manager->id]))
            ->patch(route('users.toggle-active', ['user' => $manager->id]))
            ->assertRedirect(route('users.edit', ['user' => $manager->id]))
            ->assertSessionHas('error', 'Nao e possivel inativar o proprio usuario.');

        $this->assertDatabaseHas('users', [
            'id' => $manager->id,
            'is_active' => true,
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
            'tb2_status' => 1,
        ]);
    }
}
