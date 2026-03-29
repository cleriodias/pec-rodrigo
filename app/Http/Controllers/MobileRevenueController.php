<?php

namespace App\Http\Controllers;

use App\Models\SalaryAdvance;
use App\Models\User;
use App\Models\Venda;
use App\Models\VendaPagamento;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MobileRevenueController extends Controller
{
    public function dashboard(Request $request): JsonResponse
    {
        $reference = $this->resolveReferenceDate($request);
        $todayStart = $reference->copy()->startOfDay();
        $todayEnd = $reference->copy()->endOfDay();
        $monthStart = $reference->copy()->startOfMonth();
        $monthEnd = $reference->copy()->endOfDay();

        return response()->json([
            'generated_at' => now()->toIso8601String(),
            'reference_date' => $reference->toDateString(),
            'daily' => $this->buildSummary($todayStart, $todayEnd, false),
            'monthly' => $this->buildSummary($monthStart, $monthEnd, true),
            'charts' => [
                'daily' => $this->buildDailyChart($reference),
                'monthly' => $this->buildMonthlyChart($reference),
            ],
        ]);
    }

    public function daily(Request $request): JsonResponse
    {
        $reference = $this->resolveReferenceDate($request);
        $start = $reference->copy()->startOfDay();
        $end = $reference->copy()->endOfDay();

        return response()->json([
            'generated_at' => now()->toIso8601String(),
            'reference_date' => $reference->toDateString(),
            'summary' => $this->buildSummary($start, $end, false),
            'chart' => $this->buildDailyChart($reference),
        ]);
    }

    public function monthly(Request $request): JsonResponse
    {
        $reference = $this->resolveReferenceDate($request);
        $start = $reference->copy()->startOfMonth();
        $end = $reference->copy()->endOfDay();

        return response()->json([
            'generated_at' => now()->toIso8601String(),
            'reference_date' => $reference->toDateString(),
            'summary' => $this->buildSummary($start, $end, true),
            'chart' => $this->buildMonthlyChart($reference),
        ]);
    }

    private function buildSummary(Carbon $start, Carbon $end, bool $includePayroll): array
    {
        $payments = VendaPagamento::query()
            ->whereBetween('created_at', [$start, $end])
            ->get([
                'tb4_id',
                'valor_total',
                'tipo_pagamento',
                'dois_pgto',
            ]);

        $paymentTotals = $this->paymentBreakdown($payments);
        $valeTotals = $this->valeBreakdown($start, $end);
        $payrollTotal = $includePayroll ? (float) User::sum('salario') : 0.0;
        $advancesTotal = $includePayroll
            ? (float) SalaryAdvance::query()
                ->whereBetween('advance_date', [$start->toDateString(), $end->toDateString()])
                ->sum('amount')
            : 0.0;

        $entries = round($paymentTotals['dinheiro'] + $paymentTotals['cartao'], 2);

        $secondary = [
            [
                'key' => 'vale',
                'label' => 'Vale',
                'total' => round($valeTotals['vale'], 2),
            ],
            [
                'key' => 'refeicao',
                'label' => 'Refeicao',
                'total' => round($valeTotals['refeicao'], 2),
            ],
        ];

        if ($includePayroll) {
            $secondary[] = [
                'key' => 'folha',
                'label' => 'Folha',
                'total' => round($payrollTotal, 2),
            ];
            $secondary[] = [
                'key' => 'adiantamentos',
                'label' => 'Adiantamentos',
                'total' => round($advancesTotal, 2),
            ];
        }

        return [
            'period' => [
                'start' => $start->toDateString(),
                'end' => $end->toDateString(),
                'label' => $start->translatedFormat('d/m/Y') . ' - ' . $end->translatedFormat('d/m/Y'),
            ],
            'entries_total' => $entries,
            'entry_share' => [
                'dinheiro_percentual' => $entries > 0 ? round(($paymentTotals['dinheiro'] / $entries) * 100, 1) : 0.0,
                'cartao_percentual' => $entries > 0 ? round(($paymentTotals['cartao'] / $entries) * 100, 1) : 0.0,
            ],
            'highlights' => [
                [
                    'key' => 'dinheiro',
                    'label' => 'Dinheiro',
                    'total' => round($paymentTotals['dinheiro'], 2),
                ],
                [
                    'key' => 'cartao',
                    'label' => 'Cartao',
                    'total' => round($paymentTotals['cartao'], 2),
                ],
            ],
            'secondary' => $secondary,
        ];
    }

    private function buildDailyChart(Carbon $reference): array
    {
        return collect(range(6, 0))
            ->map(function (int $daysAgo) use ($reference) {
                $date = $reference->copy()->subDays($daysAgo);
                $start = $date->copy()->startOfDay();
                $end = $date->copy()->endOfDay();

                return $this->buildChartPoint(
                    $date->translatedFormat('d/m'),
                    $start,
                    $end,
                );
            })
            ->values()
            ->all();
    }

    private function buildMonthlyChart(Carbon $reference): array
    {
        return collect(range(5, 0))
            ->map(function (int $monthsAgo) use ($reference) {
                $month = $reference->copy()->subMonths($monthsAgo);
                return $this->buildChartPoint(
                    mb_strtoupper($month->translatedFormat('M')),
                    $month->copy()->startOfMonth(),
                    $month->copy()->endOfMonth(),
                );
            })
            ->push(
                $this->buildChartPoint(
                    'ATUAL',
                    $reference->copy()->startOfMonth(),
                    $reference->copy()->endOfDay(),
                ),
            )
            ->values()
            ->all();
    }

    private function buildChartPoint(string $label, Carbon $start, Carbon $end): array
    {
        $payments = VendaPagamento::query()
            ->whereBetween('created_at', [$start, $end])
            ->get([
                'tb4_id',
                'valor_total',
                'tipo_pagamento',
                'dois_pgto',
            ]);

        $paymentTotals = $this->paymentBreakdown($payments);
        $valeTotals = $this->valeBreakdown($start, $end);

        return [
            'label' => $label,
            'dinheiro' => round($paymentTotals['dinheiro'], 2),
            'cartao' => round($paymentTotals['cartao'], 2),
            'vale' => round($valeTotals['vale'], 2),
            'refeicao' => round($valeTotals['refeicao'], 2),
        ];
    }

    private function paymentBreakdown($payments): array
    {
        $totals = [
            'dinheiro' => 0.0,
            'cartao' => 0.0,
        ];

        foreach ($payments as $payment) {
            if ($payment->tipo_pagamento === 'dinheiro') {
                $cardPortion = max((float) $payment->dois_pgto, 0);
                $cashPortion = max((float) $payment->valor_total - $cardPortion, 0);
                $totals['dinheiro'] += $cashPortion;
                $totals['cartao'] += $cardPortion;
                continue;
            }

            if ($payment->tipo_pagamento === 'maquina') {
                $totals['cartao'] += max((float) $payment->valor_total, 0);
            }
        }

        return $totals;
    }

    private function valeBreakdown(Carbon $start, Carbon $end): array
    {
        $rows = Venda::query()
            ->whereIn('tipo_pago', ['vale', 'refeicao'])
            ->whereBetween('data_hora', [$start, $end])
            ->selectRaw('tipo_pago as tipo, SUM(valor_total) as total')
            ->groupBy('tipo_pago')
            ->get();

        $totals = [
            'vale' => 0.0,
            'refeicao' => 0.0,
        ];

        foreach ($rows as $row) {
            $type = $row->tipo === 'refeicao' ? 'refeicao' : 'vale';
            $totals[$type] += (float) $row->total;
        }

        return $totals;
    }

    private function resolveReferenceDate(Request $request): Carbon
    {
        $date = trim((string) $request->query('date', ''));

        if ($date === '') {
            return Carbon::now();
        }

        try {
            return Carbon::parse($date);
        } catch (\Throwable $exception) {
            return Carbon::now();
        }
    }
}
