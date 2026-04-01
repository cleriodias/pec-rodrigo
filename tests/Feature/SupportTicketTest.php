<?php

namespace Tests\Feature;

use App\Models\SupportTicket;
use App\Models\Unidade;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class SupportTicketTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_open_support_ticket_with_recording(): void
    {
        Storage::fake('local');

        $unit = Unidade::create([
            'tb2_nome' => 'Unidade Teste',
            'tb2_endereco' => 'Endereco Teste',
            'tb2_cep' => '72900-000',
            'tb2_fone' => '(61) 99999-9999',
            'tb2_cnpj' => '00.000.000/0001-00',
            'tb2_localizacao' => 'https://maps.example.com',
        ]);

        $user = User::factory()->create([
            'tb2_id' => $unit->tb2_id,
            'funcao' => 5,
            'funcao_original' => 5,
        ]);

        $response = $this
            ->actingAs($user)
            ->post(route('support.tickets.store'), [
                'title' => 'Erro no fechamento',
                'description' => 'Video mostrando a falha',
                'recording_file' => UploadedFile::fake()->create('gravacao.webm', 512, 'video/webm'),
            ]);

        $response->assertRedirect(route('support.tickets.index'));
        $this->assertDatabaseCount('tb18_chamados', 1);

        $ticket = SupportTicket::first();

        $this->assertNotNull($ticket);
        $this->assertTrue(Storage::disk('local')->exists($ticket->video_path));
    }

    public function test_only_master_can_watch_recording(): void
    {
        Storage::fake('local');
        Storage::disk('local')->put('support-tickets/teste.webm', 'video-teste');

        $unit = Unidade::create([
            'tb2_nome' => 'Unidade Teste',
            'tb2_endereco' => 'Endereco Teste',
            'tb2_cep' => '72900-000',
            'tb2_fone' => '(61) 99999-9999',
            'tb2_cnpj' => '00.000.000/0001-00',
            'tb2_localizacao' => 'https://maps.example.com',
        ]);

        $master = User::factory()->create([
            'tb2_id' => $unit->tb2_id,
            'funcao' => 0,
            'funcao_original' => 0,
        ]);

        $regularUser = User::factory()->create([
            'tb2_id' => $unit->tb2_id,
            'funcao' => 5,
            'funcao_original' => 5,
        ]);

        $ticket = SupportTicket::create([
            'user_id' => $regularUser->id,
            'unit_id' => $unit->tb2_id,
            'title' => 'Chamado com video',
            'description' => 'Descricao teste',
            'video_path' => 'support-tickets/teste.webm',
            'video_original_name' => 'teste.webm',
            'video_mime_type' => 'video/webm',
            'video_size' => 11,
            'status' => 'aberto',
        ]);

        $this
            ->actingAs($regularUser)
            ->get(route('support.tickets.video', $ticket))
            ->assertForbidden();

        $this
            ->actingAs($master)
            ->get(route('support.tickets.video', $ticket))
            ->assertOk();
    }
}
