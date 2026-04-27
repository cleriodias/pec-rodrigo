<?php

namespace App\Http\Controllers;

use App\Models\Unidade;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class UnitSwitchController extends Controller
{
    private const ROLE_OPTIONS = [
        0 => 'MASTER',
        1 => 'GERENTE',
        2 => 'SUB-GERENTE',
        3 => 'CAIXA',
        4 => 'LANCHONETE',
        5 => 'FUNCIONARIO',
        6 => 'CLIENTE',
    ];

    public function index(Request $request): Response
    {
        return Inertia::render('Reports/SwitchUnit', $this->buildSwitchPayload($request));
    }

    public function update(Request $request): RedirectResponse
    {
        $user = $request->user();
        $this->ensureCanSwitchUnit($user);
        $originalRole = $this->originalRole($user);

        $validated = $request->validate([
            'unit_id' => ['required', 'integer'],
            'role' => ['required', 'integer', 'between:0,6'],
        ]);

        $units = $this->allowedUnits($user);
        $unit = $units->firstWhere('tb2_id', (int) $validated['unit_id']);
        $role = (int) $validated['role'];

        if (! $unit || $role < $originalRole || ! array_key_exists($role, self::ROLE_OPTIONS)) {
            abort(403);
        }

        if ((int) $user->funcao !== $role) {
            $user->funcao = $role;
            $user->save();
        }

        $request->session()->put('active_unit', [
            'id' => $unit->tb2_id,
            'name' => $unit->tb2_nome,
            'address' => $unit->tb2_endereco,
            'cnpj' => $unit->tb2_cnpj,
        ]);
        $request->session()->put('active_role', $role);

        $targetRoute = $role === 4 ? 'lanchonete.terminal' : 'dashboard';

        return redirect()->route($targetRoute)->with('success', 'Sessao atualizada com sucesso!');
    }

    public function dashboardOptions(Request $request): ?array
    {
        $user = $request->user();

        if (! $user || (int) $user->funcao !== 0) {
            return null;
        }

        return $this->buildSwitchPayload($request);
    }

    private function buildSwitchPayload(Request $request): array
    {
        $user = $request->user();
        $this->ensureCanSwitchUnit($user);
        $originalRole = $this->originalRole($user);
        $currentRole = (int) $user->funcao;
        $currentUnitId = (int) ($request->session()->get('active_unit.id') ?? $user->tb2_id ?? 0);

        $units = $this->allowedUnits($user)
            ->map(fn (Unidade $unit) => [
                'id' => (int) $unit->tb2_id,
                'name' => $unit->tb2_nome,
                'status' => (int) ($unit->tb2_status ?? 1),
                'status_label' => (int) ($unit->tb2_status ?? 1) === 1 ? 'Ativa' : 'Inativa',
                'active' => $currentUnitId === (int) $unit->tb2_id,
            ])
            ->values();

        $roles = collect(self::ROLE_OPTIONS)
            ->filter(fn (string $label, int $value) => $value >= $originalRole)
            ->map(fn (string $label, int $value) => [
                'value' => $value,
                'label' => $label,
                'active' => $currentRole === $value,
            ])
            ->values();

        $currentUnitName = $units->firstWhere('id', $currentUnitId)['name']
            ?? optional($user->primaryUnit)->tb2_nome
            ?? '---';

        return [
            'units' => $units,
            'roles' => $roles,
            'currentUnitId' => $currentUnitId,
            'currentUnitName' => $currentUnitName,
            'currentRole' => $currentRole,
            'currentRoleLabel' => self::ROLE_OPTIONS[$currentRole] ?? '---',
            'originalRole' => $originalRole,
            'originalRoleLabel' => self::ROLE_OPTIONS[$originalRole] ?? '---',
        ];
    }

    private function allowedUnits($user)
    {
        return Unidade::query()
            ->orderByDesc('tb2_status')
            ->orderBy('tb2_nome')
            ->get(['tb2_id', 'tb2_nome', 'tb2_endereco', 'tb2_cnpj', 'tb2_status']);
    }

    private function ensureCanSwitchUnit($user): void
    {
        $roleOriginal = $this->originalRole($user);

        if (! $user || ! in_array($roleOriginal, [0, 1, 2, 3], true)) {
            abort(403);
        }
    }

    private function originalRole($user): int
    {
        return (int) ($user?->funcao_original ?? $user?->funcao ?? -1);
    }
}
