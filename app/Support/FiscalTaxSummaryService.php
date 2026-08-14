<?php

namespace App\Support;

use App\Models\NotaFiscal;

class FiscalTaxSummaryService
{
    public static function forReceipt(?NotaFiscal $invoice, ?array $xmlSummary = null): ?array
    {
        if (is_array($xmlSummary)) {
            return self::normalize($xmlSummary);
        }

        if (! $invoice || ! is_array($invoice->tb27_payload)) {
            return null;
        }

        $items = $invoice->tb27_payload['itens'] ?? [];
        $taxSnapshots = $invoice->tb27_payload['tributacao_rtc_2026'] ?? [];

        if (! is_array($items) || ! is_array($taxSnapshots) || $items === [] || $taxSnapshots === []) {
            return null;
        }

        $summary = [
            'cbs' => 0.0,
            'ibs' => 0.0,
            'is' => 0.0,
        ];

        foreach ($items as $item) {
            if (! is_array($item)) {
                continue;
            }

            $productId = (string) ($item['produto_id'] ?? '');
            $tax = $taxSnapshots[$productId] ?? null;

            if (! is_array($tax)) {
                continue;
            }

            $base = (float) ($item['valor_total'] ?? 0);
            $ibsUfRate = self::effectiveRate($tax['aliquota_ibs_uf'] ?? 0, $tax['reducao_ibs_uf'] ?? 0);
            $ibsMunRate = self::effectiveRate($tax['aliquota_ibs_mun'] ?? 0, $tax['reducao_ibs_mun'] ?? 0);
            $cbsRate = self::effectiveRate($tax['aliquota_cbs'] ?? 0, $tax['reducao_cbs'] ?? 0);

            $summary['ibs'] += round($base * $ibsUfRate / 100, 2) + round($base * $ibsMunRate / 100, 2);
            $summary['cbs'] += round($base * $cbsRate / 100, 2);
        }

        return self::normalize($summary);
    }

    private static function normalize(array $summary): array
    {
        return [
            'cbs' => round((float) ($summary['cbs'] ?? 0), 2),
            'ibs' => round((float) ($summary['ibs'] ?? 0), 2),
            'is' => round((float) ($summary['is'] ?? 0), 2),
        ];
    }

    private static function effectiveRate(mixed $rate, mixed $reduction): float
    {
        return max(0, (float) $rate * (1 - max(0, min(100, (float) $reduction)) / 100));
    }
}
