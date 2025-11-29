<?php

namespace App\Http\Controllers;

use App\Models\VendaPagamento;
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
        'faturar' => ['label' => 'Faturar', 'color' => '#0f172a'],
    ];

    public function today(Request $request): Response
    {
        $this->ensureManager($request);
        $unitId = $this->resolveUnitId($request);

        $start = Carbon::today();
        $end = Carbon::today()->endOfDay();

        $payments = $this->fetchPayments($start, $end, $unitId);
        [$totals, $details, $chartData] = $this->summarizePayments($payments);

        return Inertia::render('Reports/SalesToday', [
            'meta' => self::TYPE_META,
            'chartData' => $chartData,
            'details' => $details,
            'totals' => $totals,
            'dateLabel' => $start->translatedFormat('d/m/Y'),
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

    private function ensureManager(Request $request): void
    {
        $user = $request->user();

        if (!$user || !in_array((int) $user->funcao, [0, 1], true)) {
            abort(403);
        }
    }

    private function fetchPayments(Carbon $start, Carbon $end, int $unitId): Collection
    {
        return VendaPagamento::query()
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
            ]);
    }

    private function summarizePayments(Collection $payments): array
    {
        $totals = [
            'dinheiro' => 0.0,
            'maquina' => 0.0,
            'vale' => 0.0,
            'faturar' => 0.0,
        ];
        $details = [
            'dinheiro' => [],
            'maquina' => [],
            'vale' => [],
            'faturar' => [],
        ];

        foreach ($payments as $payment) {
            $base = [
                'tb4_id' => $payment->tb4_id,
                'tipo_pagamento' => $payment->tipo_pagamento,
                'valor_total' => (float) $payment->valor_total,
                'valor_pago' => $payment->valor_pago,
                'troco' => $payment->troco,
                'dois_pgto' => $payment->dois_pgto,
                'created_at' => $payment->created_at->toIso8601String(),
            ];

            if ($payment->tipo_pagamento === 'dinheiro') {
                $cardPortion = max((float) $payment->dois_pgto, 0);
                $cashPortion = max((float) $payment->valor_total - $cardPortion, 0);

                if ($cashPortion > 0) {
                    $totals['dinheiro'] += $cashPortion;
                    $details['dinheiro'][] = array_merge($base, [
                        'applied_total' => $cashPortion,
                        'origin' => 'dinheiro',
                    ]);
                }

                if ($cardPortion > 0) {
                    $totals['maquina'] += $cardPortion;
                    $details['maquina'][] = array_merge($base, [
                        'applied_total' => $cardPortion,
                        'origin' => 'dinheiro',
                    ]);
                }

                continue;
            }

            $type = $payment->tipo_pagamento;
            if (!isset($totals[$type])) {
                continue;
            }

            $totals[$type] += (float) $payment->valor_total;
            $details[$type][] = array_merge($base, [
                'applied_total' => (float) $payment->valor_total,
                'origin' => $type,
            ]);
        }

        $chartData = collect(self::TYPE_META)
            ->map(function (array $meta, string $type) use ($totals) {
                return [
                    'type' => $type,
                    'label' => $meta['label'],
                    'color' => $meta['color'],
                    'total' => round($totals[$type] ?? 0, 2),
                ];
            })
            ->values();

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
}
