<?php

namespace App\Http\Controllers;

use App\Models\Produto;
use App\Models\User;
use App\Models\Venda;
use App\Models\VendaPagamento;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class SaleController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $user = $request->user();
        $unit = $request->session()->get('active_unit');

        if (!$unit) {
            throw ValidationException::withMessages([
                'unit' => 'Selecione uma unidade para registrar as vendas.',
            ]);
        }

        $validated = $request->validate([
            'items' => ['required', 'array', 'min:1'],
            'items.*.product_id' => ['required', 'integer', 'exists:tb1_produto,tb1_id'],
            'items.*.quantity' => ['required', 'integer', 'min:1', 'max:1000'],
            'tipo_pago' => [
                'required',
                'string',
                Rule::in(['maquina', 'dinheiro', 'vale', 'refeicao', 'faturar']),
            ],
            'vale_user_id' => ['nullable', 'integer', 'exists:users,id'],
            'valor_pago' => ['nullable', 'numeric', 'min:0'],
            'vale_type' => ['nullable', 'string', Rule::in(['vale', 'refeicao'])],
        ]);

        $selectedValeType = $validated['vale_type'] ?? 'vale';
        $finalPaymentType = $validated['tipo_pago'];
        $isValePayment = in_array($finalPaymentType, ['vale', 'refeicao'], true);

        if ($finalPaymentType === 'vale' && $selectedValeType === 'refeicao') {
            $finalPaymentType = 'refeicao';
        }

        if ($finalPaymentType === 'refeicao') {
            $selectedValeType = 'refeicao';
        }

        if ($isValePayment && empty($validated['vale_user_id'])) {
            throw ValidationException::withMessages([
                'vale_user_id' => 'Selecione o colaborador responsavel pelo vale.',
            ]);
        }

        if ($validated['tipo_pago'] === 'vale' && empty($validated['vale_type'])) {
            throw ValidationException::withMessages([
                'vale_type' => 'Selecione se o vale e Refeicao ou Vale tradicional.',
            ]);
        }

        $groupedItems = [];
        foreach ($validated['items'] as $item) {
            $productId = (int) $item['product_id'];
            $quantity = (int) $item['quantity'];
            $groupedItems[$productId] = ($groupedItems[$productId] ?? 0) + $quantity;
        }

        $dateTime = Carbon::now();
        $monthStart = $dateTime->copy()->startOfMonth();
        $monthEnd = $dateTime->copy()->endOfMonth();
        $isPaid = in_array($finalPaymentType, ['maquina', 'dinheiro'], true);
        $valeUserId = $isValePayment ? $validated['vale_user_id'] : null;
        $valeUserName = null;
        $valeUser = null;

        if ($valeUserId) {
            $valeUser = User::select('id', 'name', 'vr_cred')->find($valeUserId);
            $valeUserName = $valeUser?->name;
        }

        $itemsPayload = [];
        $requiresVrEligible = $finalPaymentType === 'refeicao';

        foreach ($groupedItems as $productId => $quantity) {
            $product = Produto::select('tb1_id', 'tb1_nome', 'tb1_vlr_venda', 'tb1_vr_credit')->findOrFail($productId);

            if ($requiresVrEligible && ! $product->tb1_vr_credit) {
                throw ValidationException::withMessages([
                    'items' => sprintf('O produto %s não está liberado para VR Crédito.', $product->tb1_nome),
                ]);
            }
            $unitPrice = (float) $product->tb1_vlr_venda;
            $total = round($unitPrice * $quantity, 2);

            $itemsPayload[] = [
                'product_id' => $product->tb1_id,
                'product_name' => $product->tb1_nome,
                'unit_price' => $unitPrice,
                'quantity' => $quantity,
                'subtotal' => $total,
            ];
        }

        $totalValue = collect($itemsPayload)->sum('subtotal');
        $valorPago = isset($validated['valor_pago']) ? (float) $validated['valor_pago'] : null;

        if ($finalPaymentType === 'refeicao' && $valeUserId) {
            if (! $valeUser) {
                throw ValidationException::withMessages([
                    'vale_user_id' => 'Colaborador selecionado nao foi encontrado.',
                ]);
            }

            $monthlyUsage = Venda::query()
                ->where('tipo_pago', 'refeicao')
                ->where('id_user_vale', $valeUserId)
                ->whereBetween('data_hora', [$monthStart, $monthEnd])
                ->sum('valor_total');

            $availableBalance = max(0, (float) $valeUser->vr_cred - (float) $monthlyUsage);

            if ($totalValue > $availableBalance) {
                throw ValidationException::withMessages([
                    'vale_user_id' => sprintf(
                        'Saldo de refeicao insuficiente. Disponivel: R$ %s',
                        number_format($availableBalance, 2, ',', '.')
                    ),
                ]);
            }
        }

        if ($finalPaymentType === 'dinheiro' && ($valorPago === null || $valorPago <= 0)) {
            throw ValidationException::withMessages([
                'valor_pago' => 'Informe o valor recebido em dinheiro.',
            ]);
        }

        if ($finalPaymentType !== 'dinheiro') {
            $valorPago = null;
        }

        $troco = 0;
        $cardComplement = 0;
        if ($finalPaymentType === 'dinheiro' && $valorPago !== null) {
            if ($valorPago >= $totalValue) {
                $troco = round($valorPago - $totalValue, 2);
            } else {
                $cardComplement = round($totalValue - $valorPago, 2);
            }
        }

        $payment = VendaPagamento::create([
            'valor_total' => $totalValue,
            'tipo_pagamento' => $finalPaymentType,
            'valor_pago' => $valorPago,
            'troco' => $troco,
            'dois_pgto' => $cardComplement,
        ]);

        foreach ($itemsPayload as $item) {
            Venda::create([
                'tb4_id' => $payment->tb4_id,
                'tb1_id' => $item['product_id'],
                'produto_nome' => $item['product_name'],
                'valor_unitario' => $item['unit_price'],
                'quantidade' => $item['quantity'],
                'valor_total' => $item['subtotal'],
                'data_hora' => $dateTime,
                'id_user_caixa' => $user->id,
                'id_user_vale' => $valeUserId,
                'id_unidade' => $unit['id'] ?? $user->tb2_id,
                'tipo_pago' => $finalPaymentType,
                'status_pago' => $isPaid,
            ]);
        }

        return response()->json([
            'sale' => [
                'items' => $itemsPayload,
                'total' => $totalValue,
                'date_time' => $dateTime->toIso8601String(),
                'tipo_pago' => $finalPaymentType,
                'status_pago' => $isPaid,
                'cashier_name' => $user->name,
                'unit_name' => $unit['name'] ?? null,
                'vale_user_name' => $valeUserName,
                'vale_type' => $isValePayment ? $selectedValeType : null,
                'payment' => [
                    'id' => $payment->tb4_id,
                    'valor_total' => $payment->valor_total,
                    'valor_pago' => $payment->valor_pago,
                    'troco' => $payment->troco,
                    'dois_pgto' => $payment->dois_pgto,
                    'tipo_pagamento' => $payment->tipo_pagamento,
                ],
            ],
        ]);
    }
}
