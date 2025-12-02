<?php

namespace App\Http\Controllers;

use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class LanchoneteTerminalController extends Controller
{
    public function index(Request $request): Response|RedirectResponse
    {
        $user = $request->user();

        if (! $user) {
            return redirect()->route('login');
        }

        // Apenas perfil lanchonete (4) ou master (0) podem acessar.
        if (! in_array((int) $user->funcao, [0, 4], true)) {
            return redirect()->route('dashboard');
        }

        return Inertia::render('Lanchonete/Terminal');
    }
}
