<?php

namespace App\Http\Controllers;

use App\Models\SalaryAdvance;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

class SalaryAdvanceController extends Controller
{
    public function index(Request $request): Response
    {
        $this->ensureManager($request->user());

        $advances = SalaryAdvance::with('user:id,name')
            ->latest()
            ->paginate(10);

        return Inertia::render('Finance/SalaryAdvanceIndex', [
            'advances' => $advances,
        ]);
    }

    public function create(Request $request): Response
    {
        $this->ensureManager($request->user());

        $users = User::orderBy('name')
            ->get(['id', 'name', 'salario']);

        return Inertia::render('Finance/SalaryAdvanceCreate', [
            'users' => $users->map(fn ($user) => [
                'id' => $user->id,
                'name' => $user->name,
                'salary_limit' => (float) ($user->salario ?? 0),
                'formatted_limit' => number_format((float) ($user->salario ?? 0), 2, ',', '.'),
            ]),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $this->ensureManager($request->user());

        $data = $request->validate([
            'user_id' => ['required', 'integer', 'exists:users,id'],
            'advance_date' => ['required', 'date'],
            'amount' => ['required', 'numeric', 'min:0.01'],
            'reason' => ['nullable', 'string', 'max:500'],
        ]);

        $user = User::select('id', 'salario', 'funcao')->findOrFail($data['user_id']);

        $totalTaken = SalaryAdvance::where('user_id', $user->id)->sum('amount');
        $totalDueAsVale = DB::table('tb3_vendas')
            ->where('id_user_vale', $user->id)
            ->where('tipo_pago', 'vale')
            ->sum('valor_total');

        $newTotal = $totalTaken + $totalDueAsVale + (float) $data['amount'];

        if ($newTotal > (float) ($user->salario ?? 0)) {
            throw ValidationException::withMessages([
                'amount' => 'Adiantamento excede o limite permitido para este usuario.',
            ]);
        }

        SalaryAdvance::create($data);

        return redirect()
            ->route('salary-advances.index')
            ->with('success', 'Adiantamento registrado com sucesso!');
    }

    public function destroy(Request $request, SalaryAdvance $salaryAdvance): RedirectResponse
    {
        $this->ensureManager($request->user());

        $salaryAdvance->delete();

        return redirect()
            ->route('salary-advances.index')
            ->with('success', 'Adiantamento excluido com sucesso!');
    }

    private function ensureManager($user): void
    {
        if (! $user || ! in_array((int) $user->funcao, [0, 1], true)) {
            abort(403);
        }
    }
}
