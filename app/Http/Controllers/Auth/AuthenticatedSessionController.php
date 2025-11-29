<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Models\Unidade;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

class AuthenticatedSessionController extends Controller
{
    /**
     * Display the login view.
     */
    public function create(): Response
    {
        return Inertia::render('Auth/Login', [
            'canResetPassword' => Route::has('password.request'),
            'status' => session('status'),
            'units' => Unidade::orderBy('tb2_nome')->get(['tb2_id', 'tb2_nome']),
        ]);
    }

    /**
     * Handle an incoming authentication request.
     */
    public function store(LoginRequest $request): RedirectResponse
    {
        $request->authenticate();

        $request->session()->regenerate();

        $unitId = (int) $request->input('unit_id');
        $user = $request->user();
        $hasAccess = $user->units()->where('tb2_unidades.tb2_id', $unitId)->exists() || (int) $user->tb2_id === $unitId;

        if (! $hasAccess) {
            Auth::logout();

            throw ValidationException::withMessages([
                'unit_id' => 'Você não tem acesso a esta unidade.',
            ]);
        }

        $selectedUnit = Unidade::select('tb2_id', 'tb2_nome')->findOrFail($unitId);

        $request->session()->put('active_unit', [
            'id' => $selectedUnit->tb2_id,
            'name' => $selectedUnit->tb2_nome,
        ]);

        if ($user->funcao_original === null) {
            $user->forceFill(['funcao_original' => $user->funcao])->save();
        }

        return redirect()->intended(route('dashboard', absolute: false));
    }

    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request): RedirectResponse
    {
        Auth::guard('web')->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect('/');
    }
}
