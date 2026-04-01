<?php

namespace App\Http\Controllers;

use App\Models\SupportTicket;
use App\Models\Unidade;
use App\Support\ManagementScope;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;
use Symfony\Component\HttpFoundation\BinaryFileResponse;

class SupportTicketController extends Controller
{
    public function index(Request $request): Response
    {
        $user = $request->user();
        $isMaster = ManagementScope::isMaster($user);

        $tickets = $isMaster
            ? SupportTicket::with([
                'user:id,name',
                'unit:tb2_id,tb2_nome',
            ])
                ->orderByDesc('id')
                ->get()
                ->map(fn (SupportTicket $ticket) => $this->mapTicket($ticket))
                ->values()
            : [];

        return Inertia::render('Support/TicketIndex', [
            'isMaster' => $isMaster,
            'tickets' => $tickets,
            'activeUnit' => $this->resolveActiveUnit($request),
            'maxUploadMb' => $this->maxUploadMegabytes(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $maxUploadKilobytes = $this->maxUploadKilobytes();

        $data = $request->validate([
            'title' => ['required', 'string', 'max:160'],
            'description' => ['nullable', 'string', 'max:2000'],
            'recording_file' => [
                'required',
                'file',
                'mimes:webm,mp4,mkv,mov',
                'max:' . $maxUploadKilobytes,
            ],
        ]);

        $file = $data['recording_file'];
        $path = $file->store('support-tickets', 'local');
        $activeUnit = $this->resolveActiveUnit($request);

        SupportTicket::create([
            'user_id' => $request->user()->id,
            'unit_id' => $activeUnit['id'] ?? null,
            'title' => $data['title'],
            'description' => $data['description'] ?: null,
            'video_path' => $path,
            'video_original_name' => $file->getClientOriginalName(),
            'video_mime_type' => $file->getClientMimeType() ?: 'video/webm',
            'video_size' => (int) $file->getSize(),
            'status' => 'aberto',
        ]);

        return redirect()
            ->route('support.tickets.index')
            ->with('success', 'Chamado enviado com sucesso!');
    }

    public function video(Request $request, SupportTicket $ticket): BinaryFileResponse
    {
        $this->ensureMaster($request->user());

        $disk = Storage::disk('local');
        if (! $disk->exists($ticket->video_path)) {
            abort(404);
        }

        $path = $disk->path($ticket->video_path);
        $filename = basename($ticket->video_original_name ?: ('chamado-' . $ticket->id . '.webm'));

        return response()->file($path, [
            'Content-Type' => $ticket->video_mime_type ?: 'video/webm',
            'Content-Disposition' => 'inline; filename="' . $filename . '"',
        ]);
    }

    private function mapTicket(SupportTicket $ticket): array
    {
        return [
            'id' => $ticket->id,
            'title' => $ticket->title,
            'description' => $ticket->description,
            'status' => $ticket->status,
            'video_size' => (int) $ticket->video_size,
            'video_original_name' => $ticket->video_original_name,
            'created_at' => optional($ticket->created_at)->toIso8601String(),
            'user' => $ticket->user
                ? [
                    'id' => $ticket->user->id,
                    'name' => $ticket->user->name,
                ]
                : null,
            'unit' => $ticket->unit
                ? [
                    'id' => $ticket->unit->tb2_id,
                    'name' => $ticket->unit->tb2_nome,
                ]
                : null,
            'video_url' => route('support.tickets.video', $ticket, false),
        ];
    }

    private function ensureMaster($user): void
    {
        if (! ManagementScope::isMaster($user)) {
            abort(403);
        }
    }

    private function resolveActiveUnit(Request $request): ?array
    {
        $sessionUnit = $request->session()->get('active_unit');

        if (is_array($sessionUnit)) {
            $unitId = $sessionUnit['id'] ?? $sessionUnit['tb2_id'] ?? null;
            if ($unitId) {
                return [
                    'id' => (int) $unitId,
                    'name' => (string) ($sessionUnit['name'] ?? $sessionUnit['tb2_nome'] ?? ''),
                ];
            }
        }

        if (is_object($sessionUnit)) {
            $unitId = $sessionUnit->id ?? $sessionUnit->tb2_id ?? null;
            if ($unitId) {
                return [
                    'id' => (int) $unitId,
                    'name' => (string) ($sessionUnit->name ?? $sessionUnit->tb2_nome ?? ''),
                ];
            }
        }

        $user = $request->user();
        $unitId = (int) ($user?->tb2_id ?? 0);
        if ($unitId <= 0) {
            return null;
        }

        $unit = Unidade::find($unitId, ['tb2_id', 'tb2_nome']);

        return [
            'id' => $unitId,
            'name' => $unit?->tb2_nome ?? ('Unidade #' . $unitId),
        ];
    }

    private function maxUploadKilobytes(): int
    {
        $uploadMax = $this->iniSizeToKilobytes((string) ini_get('upload_max_filesize'));
        $postMax = $this->iniSizeToKilobytes((string) ini_get('post_max_size'));

        $limits = array_filter([$uploadMax, $postMax], fn (int $value) => $value > 0);

        return $limits === [] ? 40960 : min($limits);
    }

    private function maxUploadMegabytes(): int
    {
        return max(1, (int) floor($this->maxUploadKilobytes() / 1024));
    }

    private function iniSizeToKilobytes(string $value): int
    {
        $normalized = trim(strtolower($value));
        if ($normalized === '') {
            return 0;
        }

        $unit = substr($normalized, -1);
        $number = (float) $normalized;

        return match ($unit) {
            'g' => (int) round($number * 1024 * 1024),
            'm' => (int) round($number * 1024),
            'k' => (int) round($number),
            default => (int) round($number / 1024),
        };
    }
}
