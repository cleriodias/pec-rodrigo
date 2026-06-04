<?php

namespace Tests\Feature\Auth;

use App\Models\Unidade;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class InactiveUserAuthenticationTest extends TestCase
{
    use RefreshDatabase;

    public function test_inactive_user_cannot_authenticate(): void
    {
        $unit = $this->makeUnit('Loja Login');

        $user = User::factory()->create([
            'name' => 'Usuario Inativo',
            'email' => 'inativo@paoecafe83.com.br',
            'password' => '1234',
            'funcao' => 4,
            'funcao_original' => 4,
            'tb2_id' => $unit->tb2_id,
            'is_active' => false,
        ]);
        $user->units()->sync([$unit->tb2_id]);

        $response = $this
            ->from('/login')
            ->post('/login', [
                'username' => 'inativo',
                'password' => '1234',
                'unit_id' => $unit->tb2_id,
            ]);

        $response
            ->assertRedirect('/login')
            ->assertSessionHasErrors('username');

        $this->assertGuest();
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
