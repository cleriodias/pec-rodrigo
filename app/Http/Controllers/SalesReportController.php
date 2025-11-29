<?php

namespace App\Http\Controllers;

use App\Models\SalaryAdvance;
use App\Models\Venda;
use App\Models\VendaPagamento;
use App\Models\User;
use App\Models\Unidade;
use Carbon\Carbon;
use Carbon\Exceptions\InvalidFormatException;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Inertia\Inertia;
use Inertia\Response;

class SalesReportController extends Controller
{
    private const TYPE_META = [
        'dinheiro' => ['label' => 'Dinheiro', 'color' => '#16a34a'],
        'maquina' => ['label' => 'Maquina', 'color' => '#2563eb'],
        'vale' => ['label' => 'Vale', 'color' => '#f59e0b'],
        'refeicao' => ['label' => 'Refeição', 'color' => '#facc15'],
        'faturar' => ['label' => 'Faturar', 'color' => '#0f172a'],
    ];

    public function today(Request $request): Response
    {
        $this->ensureManager($request);
        $user = $request->user();
        $availableUnits = $this->availableUnits($user);
        $requestedUnitId = $request->query('unit_id');
        $filterUnitId = $requestedUnitId !== null && $requestedUnitId !== '' ? (int) $requestedUnitId : null;

        if ($filterUnitId && !$availableUnits->contains(fn ($unit) => $unit['id'] === $filterUnitId)) {
            $filterUnitId = null;
        }

        $start = Carbon::today();
        $end = Carbon::today()->endOfDay();

        $payments = $this->fetchPayments($start, $end, $filterUnitId);
        [$totals, $details, $chartData] = $this->summarizePayments($payments);
        [$totals, $details] = $this->applyGlobalValeTotals($start, $end, $totals, $details, $filterUnitId);
        $chartData = $this->buildChartData($totals);

        $selectedUnit = $filterUnitId
            ? $availableUnits->firstWhere('id', $filterUnitId)
            : ['id' => null, 'name' => 'Todas as unidades'];

        return Inertia::render('Reports/SalesToday', [
            'meta' => self::TYPE_META,
            'chartData' => $chartData,
            'details' => $details,
            'totals' => $totals,
            'dateLabel' => $start->translatedFormat('d/m/Y'),
            'filterUnits' => $availableUnits->values(),
            'selectedUnitId' => $filterUnitId,
            'selectedUnit' => $selectedUnit,
        ]);
    }

    public function cashClosure(Request $request): Response
    {
        $this->ensureManager($request);
        $user = $request->user();
        $availableUnits = $this->availableUnits($user);

        $requestedUnitId = $request->query('unit_id');
        $filterUnitId = $requestedUnitId !== null && $requestedUnitId !== '' ? (int) $requestedUnitId : null;
        if ($filterUnitId && !$availableUnits->contains(fn ($unit) => $unit['id'] === $filterUnitId)) {
            $filterUnitId = null;
        }

        $dateInput = $request->query('date');
        $date = $this->parseDate($dateInput, 'Y-m-d', Carbon::today());
        $start = $date->copy()->startOfDay();
        $end = $date->copy()->endOfDay();
        $dateDisplay = $date->translatedFormat('d/m/Y');
        $dateValue = $date->format('Y-m-d');

        $paymentsQuery = VendaPagamento::query()
            ->whereBetween('created_at', [$start, $end])
            ->with(['vendas' => function ($query) use ($filterUnitId) {
                $query->select('tb3_id', 'tb4_id', 'id_user_caixa', 'id_unidade')
                    ->orderBy('tb3_id');

                if ($filterUnitId) {
                    $query->where('id_unidade', $filterUnitId);
                }
            }]);

        if ($filterUnitId) {
            $paymentsQuery->whereHas('vendas', function ($query) use ($filterUnitId) {
                $query->where('id_unidade', $filterUnitId);
            });
        }

        $payments = $paymentsQuery->get([
            'tb4_id',
            'valor_total',
            'tipo_pagamento',
            'valor_pago',
            'troco',
            'dois_pgto',
            'created_at',
        ]);

        $cashierIds = $payments
            ->map(fn (VendaPagamento $payment) => optional($payment->vendas->first())->id_user_caixa)
            ->filter()
            ->unique();

        $unitIds = $payments
            ->map(fn (VendaPagamento $payment) => optional($payment->vendas->first())->id_unidade)
            ->filter()
            ->unique();

        $cashiers = User::whereIn('id', $cashierIds)->get(['id', 'name'])->keyBy('id');
        $units = Unidade::whereIn('tb2_id', $unitIds)->get(['tb2_id', 'tb2_nome'])->keyBy('tb2_id');

        $grouped = [];

        foreach ($payments as $payment) {
            $firstSale = optional($payment->vendas->first());
            $cashierId = $firstSale?->id_user_caixa;
            $unitId = $firstSale?->id_unidade;

            if (!$cashierId) {
                continue;
            }

            if (!isset($grouped[$cashierId])) {
                $grouped[$cashierId] = [
                    'cashier_id' => $cashierId,
                    'cashier_name' => $cashiers[$cashierId]->name ?? 'Caixa #' . $cashierId,
                    'unit_name' => $unitId ? ($units[$unitId]->tb2_nome ?? ('Unidade #' . $unitId)) : '---',
                    'totals' => [
                        'dinheiro' => 0.0,
                        'maquina' => 0.0,
                        'vale' => 0.0,
                        'refeicao' => 0.0,
                        'faturar' => 0.0,
                    ],
                    'grand_total' => 0.0,
                ];
            }

            foreach ($this->breakdownPayment($payment) as $type => $amount) {
                $grouped[$cashierId]['totals'][$type] += $amount;
                $grouped[$cashierId]['grand_total'] += $amount;
            }
        }

        $records = collect($grouped)
            ->map(function (array $record) {
                $record['totals'] = array_map(fn ($value) => round($value, 2), $record['totals']);
                $record['grand_total'] = round($record['grand_total'], 2);

                return $record;
            })
            ->sortByDesc('grand_total')
            ->values();

        $selectedUnit = $filterUnitId
            ? $availableUnits->firstWhere('id', $filterUnitId)
            : ['id' => null, 'name' => 'Todas as unidades'];

        return Inertia::render('Reports/CashClosure', [
            'records' => $records,
            'dateValue' => $dateDisplay,
            'dateInputValue' => $dateValue,
            'filterUnits' => $availableUnits->values(),
            'selectedUnitId' => $filterUnitId,
            'selectedUnit' => $selectedUnit,
        ]);
    }

    public function period(Request $request): Response
    {
        $this->ensureManager($request);
        $unitId = $this->resolveUnitId($request);

        $mode = $request->query('mode', 'month') === 'day' ? 'day' : 'month';
        $dateValue = $request->query('date');

        if ($mode === 'day') {
            $date = $this->parseDate($dateValue, 'Y-m-d', Carbon::today());
            $start = $date->copy()->startOfDay();
            $end = $date->copy()->endOfDay();
            $dateValue = $date->format('Y-m-d');
        } else {
            $month = $this->parseDate($dateValue, 'Y-m', Carbon::today()->startOfMonth());
            $start = $month->copy()->startOfMonth();
            $end = $month->copy()->endOfMonth();
            $dateValue = $month->format('Y-m');
        }

        $payments = $this->fetchPayments($start, $end, $unitId);
        [$totals, $details, $chartData] = $this->summarizePayments($payments);
        [$totals, $details] = $this->applyGlobalValeTotals($start, $end, $totals, $details);
        $chartData = $this->buildChartData($totals);

        $dailyTotals = $payments
            ->groupBy(fn (VendaPagamento $payment) => $payment->created_at->format('Y-m-d'))
            ->map(function (Collection $group, string $date) {
                $carbon = Carbon::createFromFormat('Y-m-d', $date);

                return [
                    'date' => $date,
                    'label' => $carbon->translatedFormat('d/m/Y'),
                    'total' => round($group->sum('valor_total'), 2),
                ];
            })
            ->sortByDesc('date')
            ->values();

        return Inertia::render('Reports/SalesPeriod', [
            'meta' => self::TYPE_META,
            'chartData' => $chartData,
            'totals' => $totals,
            'details' => $details,
            'dailyTotals' => $dailyTotals,
            'mode' => $mode,
            'dateValue' => $dateValue,
            'startDate' => $start->toDateString(),
            'endDate' => $end->toDateString(),
        ]);
    }

    public function detailed(Request $request): Response
    {
        $this->ensureManager($request);
        $unitId = $this->resolveUnitId($request);

        $dateValue = $request->query('date');
        $date = $this->parseDate($dateValue, 'Y-m-d', Carbon::today());
        $start = $date->copy()->startOfDay();
        $end = $date->copy()->endOfDay();
        $dateValue = $date->format('Y-m-d');

        $payments = VendaPagamento::with(['vendas' => function ($query) {
            $query->orderBy('tb3_id')->select([
                'tb3_id',
                'tb4_id',
                'produto_nome',
                'valor_unitario',
                'quantidade',
                'valor_total',
                'data_hora',
            ]);
        }])
            ->whereBetween('created_at', [$start, $end])
            ->whereHas('vendas', function ($query) use ($unitId) {
                $query->where('id_unidade', $unitId);
            })
            ->orderByDesc('tb4_id')
            ->get([
                'tb4_id',
                'valor_total',
                'tipo_pagamento',
                'valor_pago',
                'troco',
                'dois_pgto',
                'created_at',
            ])
            ->map(function (VendaPagamento $payment) {
                return [
                    'tb4_id' => $payment->tb4_id,
                    'valor_total' => (float) $payment->valor_total,
                    'tipo_pagamento' => $payment->tipo_pagamento,
                    'valor_pago' => $payment->valor_pago,
                    'troco' => $payment->troco,
                    'dois_pgto' => $payment->dois_pgto,
                    'created_at' => $payment->created_at->toIso8601String(),
                    'items' => $payment->vendas
                        ->map(fn ($item) => [
                            'tb3_id' => $item->tb3_id,
                            'produto_nome' => $item->produto_nome,
                            'quantidade' => $item->quantidade,
                            'valor_unitario' => $item->valor_unitario,
                            'valor_total' => $item->valor_total,
                            'data_hora' => optional($item->data_hora)->toIso8601String(),
                        ])
                        ->values(),
                ];
            })
            ->values();

        return Inertia::render('Reports/SalesDetailed', [
            'payments' => $payments,
            'dateValue' => $dateValue,
        ]);
    }

    public function control(Request $request): Response
    {
        $this->ensureManager($request);
        $user = $request->user();
        $availableUnits = $this->availableUnits($user);

        $requestedUnitId = $request->query('unit_id');
        $filterUnitId = $requestedUnitId !== null && $requestedUnitId !== ''
            ? (int) $requestedUnitId
            : null;

        if ($filterUnitId && !$availableUnits->contains(fn ($unit) => $unit['id'] === $filterUnitId)) {
            $filterUnitId = null;
        }

        $start = Carbon::now()->startOfMonth();
        $end = Carbon::now()->endOfMonth();

        $payments = $this->fetchPayments($start, $end, $filterUnitId);
        $totalSales = (float) $payments->sum('valor_total');
        $globalValeTotals = $this->valeBreakdown($start, $end, null);
        $globalStandardVale = $globalValeTotals['vale'];
        $globalMealVale = $globalValeTotals['refeicao'];

        $valeTotals = $this->valeBreakdown($start, $end, $filterUnitId);
        $standardVale = $valeTotals['vale'];
        $mealVale = $valeTotals['refeicao'];
        $netSales = max(0, $totalSales - $standardVale - $mealVale);

        $totalPayrollGlobal = (float) User::sum('salario');
        $totalAdvancesGlobal = (float) SalaryAdvance::whereBetween('advance_date', [$start->toDateString(), $end->toDateString()])
            ->sum('amount');
        $netPayrollGlobal = max(0, $totalPayrollGlobal - $globalStandardVale - $globalMealVale - $totalAdvancesGlobal);

        $selectedUnit = $filterUnitId
            ? $availableUnits->firstWhere('id', $filterUnitId)
            : [
                'id' => null,
                'name' => 'Todas as unidades',
            ];

        return Inertia::render('Reports/ControlPanel', [
            'unit' => $selectedUnit,
            'filterUnits' => $availableUnits->values(),
            'selectedUnitId' => $filterUnitId,
            'period' => [
                'start' => $start->toDateString(),
                'end' => $end->toDateString(),
                'label' => $start->translatedFormat('d/m/Y') . ' - ' . $end->translatedFormat('d/m/Y'),
            ],
            'metrics' => [
                'total_sales' => round($totalSales, 2),
                'total_vale' => round($standardVale, 2),
                'total_refeicao' => round($mealVale, 2),
                'net_sales' => round($netSales, 2),
                'total_advances' => round($totalAdvancesGlobal, 2),
                'total_payroll' => round($totalPayrollGlobal, 2),
                'net_payroll' => round($netPayrollGlobal, 2),
            ],
        ]);
    }

    private function ensureManager(Request $request): void
    {
        $user = $request->user();

        if (!$user || !in_array((int) $user->funcao, [0, 1], true)) {
            abort(403);
        }
    }

    private function fetchPayments(Carbon $start, Carbon $end, ?int $unitId = null): Collection
    {
        $query = VendaPagamento::query()
            ->whereBetween('created_at', [$start, $end]);

        if ($unitId) {
            $query->whereHas('vendas', function ($subQuery) use ($unitId) {
                $subQuery->where('id_unidade', $unitId);
            });
        }

        return $query
            ->orderByDesc('tb4_id')
            ->get([
                'tb4_id',
                'valor_total',
                'tipo_pagamento',
                'valor_pago',
                'troco',
                'dois_pgto',
                'created_at',
            ]);
    }

    private function summarizePayments(Collection $payments): array
    {
        $totals = [
            'dinheiro' => 0.0,
            'maquina' => 0.0,
            'vale' => 0.0,
            'refeicao' => 0.0,
            'faturar' => 0.0,
        ];
        $details = [
            'dinheiro' => [],
            'maquina' => [],
            'vale' => [],
            'refeicao' => [],
            'faturar' => [],
        ];

        foreach ($payments as $payment) {
            $type = $payment->tipo_pagamento;
            $base = [
                'tb4_id' => $payment->tb4_id,
                'tipo_pagamento' => $type,
                'valor_total' => (float) $payment->valor_total,
                'valor_pago' => $payment->valor_pago,
                'troco' => $payment->troco,
                'dois_pgto' => $payment->dois_pgto,
                'created_at' => $payment->created_at->toIso8601String(),
                'origin' => $type,
            ];

            if ($type === 'dinheiro') {
                $cardPortion = max((float) $payment->dois_pgto, 0);
                $cashPortion = max((float) $payment->valor_total - $cardPortion, 0);

                if ($cashPortion > 0) {
                    $totals['dinheiro'] += $cashPortion;
                    $details['dinheiro'][] = array_merge($base, [
                        'applied_total' => $cashPortion,
                    ]);
                }

                if ($cardPortion > 0) {
                    $totals['maquina'] += $cardPortion;
                    $details['maquina'][] = array_merge($base, [
                        'applied_total' => $cardPortion,
                    ]);
                }

                continue;
            }

            if (!isset($totals[$type])) {
                continue;
            }

            $totals[$type] += (float) $payment->valor_total;
            $details[$type][] = array_merge($base, [
                'applied_total' => (float) $payment->valor_total,
            ]);
        }

        $chartData = $this->buildChartData($totals);

        return [$totals, $details, $chartData];
    }

    private function parseDate(?string $value, string $format, Carbon $fallback): Carbon
    {
        if (!$value) {
            return $fallback;
        }

        try {
            return Carbon::createFromFormat($format, $value);
        } catch (InvalidFormatException $exception) {
            return $fallback;
        }
    }

    private function resolveUnitId(Request $request): int
    {
        $unit = $request->session()->get('active_unit');

        if (isset($unit['id'])) {
            return (int) $unit['id'];
        }

        return (int) ($request->user()?->tb2_id ?? 0);
    }

    private function valeBreakdown(Carbon $start, Carbon $end, ?int $unitId = null): array
    {
        $query = Venda::query()
            ->whereIn('tipo_pago', ['vale', 'refeicao'])
            ->whereBetween('data_hora', [$start, $end])
            ->selectRaw('tipo_pago as tipo, SUM(valor_total) as total')
            ->groupBy('tipo');

        if ($unitId) {
            $query->where('id_unidade', $unitId);
        }

        $rows = $query->get();

        $totals = [
            'vale' => 0.0,
            'refeicao' => 0.0,
        ];

        foreach ($rows as $row) {
            $tipo = $row->tipo === 'refeicao' ? 'refeicao' : 'vale';
            $totals[$tipo] += (float) $row->total;
        }

        return $totals;
    }

    private function applyGlobalValeTotals(Carbon $start, Carbon $end, array $totals, array $details, ?int $unitId = null): array
    {
        $valeIds = $this->valeSaleIds($start, $end, 'vale', $unitId);
        $refeicaoIds = $this->valeSaleIds($start, $end, 'refeicao', $unitId);

        $globalPayments = $this->fetchPayments($start, $end, $unitId);

        $valePayments = $valeIds->isEmpty()
            ? collect()
            : $globalPayments->filter(fn (VendaPagamento $payment) => $valeIds->contains($payment->tb4_id));

        $refeicaoPayments = $refeicaoIds->isEmpty()
            ? collect()
            : $globalPayments->filter(fn (VendaPagamento $payment) => $refeicaoIds->contains($payment->tb4_id));

        if ($valePayments->isNotEmpty()) {
            $valePayments = $valePayments->map(function (VendaPagamento $payment) {
                $cloned = clone $payment;
                $cloned->tipo_pagamento = 'vale';

                return $cloned;
            });

            [$valeTotals, $valeDetails] = $this->summarizePayments($valePayments);
            $totals['vale'] = $valeTotals['vale'];
            $details['vale'] = $valeDetails['vale'];
        } else {
            $totals['vale'] = 0.0;
            $details['vale'] = [];
        }

        if ($refeicaoPayments->isNotEmpty()) {
            $refeicaoPayments = $refeicaoPayments->map(function (VendaPagamento $payment) {
                $cloned = clone $payment;
                $cloned->tipo_pagamento = 'refeicao';

                return $cloned;
            });

            [$refTotals, $refDetails] = $this->summarizePayments($refeicaoPayments);
            $totals['refeicao'] = $refTotals['refeicao'];
            $details['refeicao'] = $refDetails['refeicao'];
        } else {
            $totals['refeicao'] = 0.0;
            $details['refeicao'] = [];
        }

        return [$totals, $details];
    }

    private function valeSaleIds(Carbon $start, Carbon $end, string $type, ?int $unitId = null): Collection
    {
        $query = Venda::query()
            ->where('tipo_pago', $type)
            ->whereBetween('data_hora', [$start, $end])
            ->select('tb4_id');

        if ($unitId) {
            $query->where('id_unidade', $unitId);
        }

        return $query->pluck('tb4_id')->unique()->values();
    }

    private function buildChartData(array $totals, ?array $meta = null): Collection
    {
        $meta = $meta ?? self::TYPE_META;

        return collect($meta)
            ->map(function (array $metaData, string $type) use ($totals) {
                return [
                    'type' => $type,
                    'label' => $metaData['label'],
                    'color' => $metaData['color'],
                    'total' => round($totals[$type] ?? 0, 2),
                ];
            })
            ->values();
    }

    private function breakdownPayment(VendaPagamento $payment): array
    {
        $type = $payment->tipo_pagamento;

        if ($type === 'dinheiro') {
            $cardPortion = max((float) $payment->dois_pgto, 0);
            $cashPortion = max((float) $payment->valor_total - $cardPortion, 0);
            $entries = [];
            if ($cashPortion > 0) {
                $entries['dinheiro'] = $cashPortion;
            }
            if ($cardPortion > 0) {
                $entries['maquina'] = $cardPortion;
            }

            return $entries;
        }

        if (!array_key_exists($type, self::TYPE_META)) {
            return [];
        }

        $amount = max((float) $payment->valor_total, 0);

        return $amount > 0 ? [$type => $amount] : [];
    }

    private function availableUnits(User $user): Collection
    {
        $units = $user->units()
            ->select('tb2_unidades.tb2_id', 'tb2_unidades.tb2_nome')
            ->get();

        if ($user->tb2_id && !$units->contains('tb2_id', $user->tb2_id)) {
            $primary = Unidade::find($user->tb2_id, ['tb2_id', 'tb2_nome']);
            if ($primary) {
                $units->push($primary);
            }
        }

        return $units
            ->map(fn ($unit) => [
                'id' => (int) $unit->tb2_id,
                'name' => $unit->tb2_nome,
            ])
            ->unique('id')
            ->sortBy('name')
            ->values();
    }

}
