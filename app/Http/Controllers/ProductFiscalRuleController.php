<?php

namespace App\Http\Controllers;

use App\Models\Produto;
use App\Models\ProdutoTributacaoFiscalUnidade;
use App\Models\Unidade;
use App\Support\ManagementScope;
use App\Support\Setor9Rtc2026Service;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ProductFiscalRuleController extends Controller
{
    public function index(Request $request, Produto $product): Response
    {
        abort_unless(ManagementScope::isMaster($request->user()), 403, 'Somente o perfil Master pode consultar a tributacao fiscal por loja.');
        return Inertia::render('Products/ProductFiscalRules', [
            'product' => $product,
            'units' => Unidade::query()->active()->orderBy('tb2_nome')->get(['tb2_id', 'tb2_nome']),
            'rules' => $product->tributacoesFiscaisUnidade()->get()->keyBy('tb2_id')->map(fn ($rule) => $rule->toArray()),
        ]);
    }
    public function store(Request $request, Produto $product, Setor9Rtc2026Service $setor9Rtc2026Service): RedirectResponse
    {
        abort_unless(ManagementScope::isMaster($request->user()), 403, 'Somente o perfil Master pode alterar a tributacao fiscal por loja.');

        $data = $request->validate([
            'tb2_id' => ['required', 'integer', Rule::exists('tb2_unidades', 'tb2_id')],
            'tb28_csosn' => ['nullable', 'digits:3'],
            'tb28_cst_icms' => ['nullable', 'digits:2'],
            'tb28_aliquota_icms' => ['nullable', 'numeric', 'between:0,100'],
            'tb28_cst_pis' => ['nullable', 'digits:2'],
            'tb28_aliquota_pis' => ['nullable', 'numeric', 'between:0,100'],
            'tb28_cst_cofins' => ['nullable', 'digits:2'],
            'tb28_aliquota_cofins' => ['nullable', 'numeric', 'between:0,100'],
            'tb28_cst_ibs_cbs' => ['required', 'digits:3'],
            'tb28_cclass_trib' => ['required', 'digits:6'],
            'tb28_aliquota_ibs_uf' => ['required', 'numeric', 'between:0,100'],
            'tb28_aliquota_ibs_mun' => ['required', 'numeric', 'between:0,100'],
            'tb28_aliquota_cbs' => ['required', 'numeric', 'between:0,100'],
            'tb28_reducao_ibs_uf' => ['nullable', 'numeric', 'between:0,100'],
            'tb28_reducao_ibs_mun' => ['nullable', 'numeric', 'between:0,100'],
            'tb28_reducao_cbs' => ['nullable', 'numeric', 'between:0,100'],
            'tb28_ativo' => ['nullable', 'boolean'],
            'tb28_rtc_manual' => ['nullable', 'boolean'],
            'copy_to_unit_ids' => ['nullable', 'array'],
            'copy_to_unit_ids.*' => ['integer', Rule::exists('tb2_unidades', 'tb2_id')],
        ]);

        $values = collect($data)->except(['tb2_id', 'copy_to_unit_ids'])->all();
        $values['tb28_ativo'] = (bool) ($values['tb28_ativo'] ?? true);
        $values['tb28_rtc_manual'] = (bool) ($values['tb28_rtc_manual'] ?? false);
        $values['tb28_reducao_ibs_uf'] = $values['tb28_reducao_ibs_uf'] ?? 0;
        $values['tb28_reducao_ibs_mun'] = $values['tb28_reducao_ibs_mun'] ?? 0;
        $values['tb28_reducao_cbs'] = $values['tb28_reducao_cbs'] ?? 0;

        $unitIds = collect([$data['tb2_id']])
            ->merge($data['copy_to_unit_ids'] ?? [])
            ->unique()
            ->values();

        foreach ($unitIds as $unitId) {
            ProdutoTributacaoFiscalUnidade::query()->updateOrCreate(
                ['tb1_id' => $product->tb1_id, 'tb2_id' => $unitId],
                $values,
            );

            if ($setor9Rtc2026Service->isSetor9((int) $unitId) && ! $values['tb28_rtc_manual']) {
                $setor9Rtc2026Service->sync($product, (int) ($request->user()?->id ?? 0), 'manual_unlock');
            }
        }

        return back()->with('success', 'Tributacao fiscal por loja gravada com sucesso.');
    }
}
