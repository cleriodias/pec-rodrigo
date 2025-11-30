<?php

namespace App\Http\Controllers;

use App\Models\CashierClosure;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use Inertia\Response;

class CashierClosureController extends Controller
{
    public function index(Request $request): Response
    {
        $user = $request->user();
        $this->ensureCashier($user);

        $today = Carbon::today();
        $activeUnit = $request->session()->get('active_unit');
        $todayClosure = CashierClosure::where('user_id', $user->id)
            ->whereDate('closed_date', $today)
            ->latest('closed_at')
            ->first();

        $lastClosure = CashierClosure::where('user_id', $user->id)
            ->latest('closed_at')
            ->first();

        return Inertia::render('Cashier/Close', [
            'activeUnit' => $activeUnit,
            'todayClosure' => $todayClosure ? [
                'cash_amount' => $todayClosure->cash_amount,
                'card_amount' => $todayClosure->card_amount,
                'closed_at' => optional($todayClosure->closed_at)->toIso8601String(),
                'unit_name' => $todayClosure->unit_name,
            ] : null,
            'lastClosure' => $lastClosure ? [
                'cash_amount' => $lastClosure->cash_amount,
                'card_amount' => $lastClosure->card_amount,
                'closed_at' => optional($lastClosure->closed_at)->toIso8601String(),
                'unit_name' => $lastClosure->unit_name,
            ] : null,
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $user = $request->user();
        $this->ensureCashier($user);

        $validated = $request->validate([
            'cash_amount' => ['required', 'numeric', 'min:0'],
            'card_amount' => ['required', 'numeric', 'min:0'],
        ]);

        $today = Carbon::today();
        $activeUnit = $request->session()->get('active_unit');
        $unitId = $activeUnit['id'] ?? $user->tb2_id;
        $unitName = $activeUnit['name'] ?? optional($user->primaryUnit)->tb2_nome;

        $alreadyClosed = CashierClosure::where('user_id', $user->id)
            ->whereDate('closed_date', $today)
            ->exists();

        if ($alreadyClosed) {
            return redirect()
                ->route('cashier.close')
                ->withErrors([
                    'cash_amount' => 'O caixa já foi fechado hoje.',
                ]);
        }

        CashierClosure::create([
            'user_id' => $user->id,
            'unit_id' => $unitId,
            'unit_name' => $unitName,
            'cash_amount' => $validated['cash_amount'],
            'card_amount' => $validated['card_amount'],
            'closed_date' => $today->toDateString(),
            'closed_at' => now(),
        ]);

        Auth::guard('web')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()
            ->route('login')
            ->with('status', 'Fechamento concluído. Você poderá acessar novamente amanhã.');
    }

    private function ensureCashier(?User $user): void
    {
        if (! $user || (int) $user->funcao !== 3) {
            abort(403);
        }
    }
}
