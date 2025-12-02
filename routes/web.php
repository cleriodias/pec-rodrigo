<?php

use App\Http\Controllers\CashierClosureController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProductDiscardController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\RoleSwitchController;
use App\Http\Controllers\SaleController;
use App\Http\Controllers\SalesReportController;
use App\Http\Controllers\SalaryAdvanceController;
use App\Http\Controllers\UnitController;
use App\Http\Controllers\UnitSwitchController;
use App\Http\Controllers\UserController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
    Route::get('/settings', function () {
        $user = auth()->user();
        if (! $user || (int) $user->funcao !== 0) {
            abort(403);
        }

        return Inertia::render('Settings/Config');
    })->name('settings.config');
    Route::get('/settings/profile-access', function () {
        $user = auth()->user();
        if (! $user || (int) $user->funcao !== 0) {
            abort(403);
        }

        return Inertia::render('Settings/ProfileAccess');
    })->name('settings.profile-access');
    Route::get('/settings/menu-order', function () {
        $user = auth()->user();
        if (! $user || (int) $user->funcao !== 0) {
            abort(403);
        }

        return Inertia::render('Settings/MenuOrder');
    })->name('settings.menu-order');

    Route::get('/users', [UserController::class, 'index'])->name('users.index');
    Route::get('/show-user/{user}', [UserController::class, 'show'])->name('users.show');
    Route::get('/create-user', [UserController::class, 'create'])->name('users.create');
    route::post('/store-user', [UserController::class, 'store'])->name('users.store');
    Route::get('/edit-user/{user}', [UserController::class, 'edit'])->name('users.edit');
    route::put('/update-user/{user}', [UserController::class, 'update'])->name('users.update');
    route::delete('/destroy-user/{user}', [UserController::class, 'destroy'])->name('users.destroy');
    Route::get('/users/search', [UserController::class, 'search'])->name('users.search');
    Route::post('/users/{user}/reset-password', [UserController::class, 'resetPassword'])->name('users.reset-password');

    Route::get('/units', [UnitController::class, 'index'])->name('units.index');
    Route::get('/units/create', [UnitController::class, 'create'])->name('units.create');
    Route::post('/units', [UnitController::class, 'store'])->name('units.store');
    Route::get('/units/{unit}', [UnitController::class, 'show'])->name('units.show');
    Route::get('/units/{unit}/edit', [UnitController::class, 'edit'])->name('units.edit');
    Route::put('/units/{unit}', [UnitController::class, 'update'])->name('units.update');
    Route::delete('/units/{unit}', [UnitController::class, 'destroy'])->name('units.destroy');

    Route::get('/products/discard', [ProductDiscardController::class, 'index'])->name('products.discard');
    Route::post('/products/discard', [ProductDiscardController::class, 'store'])->name('products.discard.store');
    Route::get('/products/search', [ProductController::class, 'search'])->name('products.search');
    Route::get('/products/favorites', [ProductController::class, 'favorites'])->name('products.favorites');
    Route::post('/products/{product}/favorite', [ProductController::class, 'toggleFavorite'])->name('products.favorite');
    Route::resource('products', ProductController::class);
    Route::get('/sales/open-comandas', [SaleController::class, 'openComandas'])->name('sales.open-comandas');
    Route::get('/sales/comandas/{codigo}/items', [SaleController::class, 'comandaItems'])->name('sales.comandas.items');
    Route::post('/sales', [SaleController::class, 'store'])->name('sales.store');
    Route::get('/reports/sales-today', [SalesReportController::class, 'today'])->name('reports.sales.today');
    Route::get('/reports/sales-period', [SalesReportController::class, 'period'])->name('reports.sales.period');
    Route::get('/reports/sales-detailed', [SalesReportController::class, 'detailed'])->name('reports.sales.detailed');
    Route::get('/reports/cash-closure', [SalesReportController::class, 'cashClosure'])->name('reports.cash.closure');
    Route::get('/reports/control', [SalesReportController::class, 'control'])->name('reports.control');
    Route::get('/reports/switch-unit', [UnitSwitchController::class, 'index'])->name('reports.switch-unit');
    Route::post('/reports/switch-unit', [UnitSwitchController::class, 'update'])->name('reports.switch-unit.update');
    Route::get('/reports/switch-role', [RoleSwitchController::class, 'index'])->name('reports.switch-role');
    Route::post('/reports/switch-role', [RoleSwitchController::class, 'update'])->name('reports.switch-role.update');
    Route::get('/salary-advances', [SalaryAdvanceController::class, 'index'])->name('salary-advances.index');
    Route::get('/salary-advances/create', [SalaryAdvanceController::class, 'create'])->name('salary-advances.create');
    Route::post('/salary-advances', [SalaryAdvanceController::class, 'store'])->name('salary-advances.store');
    Route::delete('/salary-advances/{salaryAdvance}', [SalaryAdvanceController::class, 'destroy'])->name('salary-advances.destroy');
    Route::get('/cashier/close', [CashierClosureController::class, 'index'])->name('cashier.close');
    Route::post('/cashier/close', [CashierClosureController::class, 'store'])->name('cashier.close.store');
});

require __DIR__.'/auth.php';
