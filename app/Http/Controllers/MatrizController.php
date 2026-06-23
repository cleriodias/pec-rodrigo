<?php

namespace App\Http\Controllers;

use App\Models\Matriz;
use App\Support\ManagementScope;
use Inertia\Inertia;
use Inertia\Response;

class MatrizController extends Controller
{
    private function ensureAuthorized(): void
    {
        $user = request()->user();

        if (! ManagementScope::isManagement($user)) {
            abort(403, 'Acesso negado.');
        }
    }

    public function index(): Response
    {
        $this->ensureAuthorized();

        $user = request()->user();

        $matrizesQuery = Matriz::query()
            ->withCount('unidades')
            ->orderBy('tb30_nome');

        if (ManagementScope::isManager($user)) {
            $unitIds = ManagementScope::managedUnitIds($user)->all();

            if (empty($unitIds)) {
                $matrizesQuery->whereRaw('1 = 0');
            } else {
                $matrizesQuery->whereHas('unidades', function ($query) use ($unitIds) {
                    $query->whereIn('tb2_unidades.tb2_id', $unitIds);
                });
            }
        }

        $matrizes = $matrizesQuery
            ->with([
                'unidades' => function ($query) {
                    $query->select([
                        'tb2_id',
                        'tb2_nome',
                        'tb2_status',
                        'matriz_id',
                    ])->orderBy('tb2_nome');
                },
            ])
            ->paginate(10);

        return Inertia::render('Matrizes/Index', [
            'matrizes' => $matrizes,
        ]);
    }
}
