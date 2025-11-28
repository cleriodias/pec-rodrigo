<?php

namespace App\Http\Controllers;

use App\Models\VendaPagamento;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class SalesReportController extends Controller
{
    private const TYPE_META = [
        'dinheiro' => ['label' => 'Dinheiro', 'color' => '#16a34a'],
        'maquina' => ['label' => 'Máquina', 'color' => '#2563eb'],
        'vale' => ['label' => 'Vale', 'color' => '#f59e0b'],
        'faturar' => ['label' => 'Faturar', 'color' => '#0f172a'],
    ];

    public function today(Request $request): Response
    {
        $user = $request->user();
        if (!$user || !in_array((int) $user->funcao, [0, 1], true)) {
            abort(403);
        }

        $start = Carbon::today();
        $end = Carbon::today()->endOfDay();

        $payments = VendaPagamento::query()
            ->whereBetween('created_at', [$start, $end])
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

        return Inertia::render('Reports/SalesToday', [
            'meta' => self::TYPE_META,
            'chartData' => $chartData,
            'details' => $details,
            'totals' => $totals,
            'dateLabel' => $start->translatedFormat('d/m/Y'),
        ]);
    }
}
