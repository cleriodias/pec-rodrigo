<?php

namespace App\Http\Controllers;

use App\Models\TipoProduto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

class ProductTypeController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Products/ProductTypeIndex', [
            'productTypes' => TipoProduto::query()
                ->withCount('produtos')
                ->orderBy('tb32_nome')
                ->get(),
        ]);
    }

    public function store(Request $request)
    {
        TipoProduto::create($this->validatedData($request));

        return Redirect::route('product-types.index')
            ->with('success', 'Tipo de produto cadastrado com sucesso!');
    }

    public function update(Request $request, TipoProduto $productType)
    {
        $productType->update($this->validatedData($request, $productType));

        return Redirect::route('product-types.index')
            ->with('success', 'Tipo de produto atualizado com sucesso!');
    }

    public function destroy(TipoProduto $productType)
    {
        if ($productType->produtos()->exists()) {
            throw ValidationException::withMessages([
                'productType' => 'Este tipo nao pode ser removido porque existem produtos vinculados a ele.',
            ]);
        }

        $productType->delete();

        return Redirect::route('product-types.index')
            ->with('success', 'Tipo de produto removido com sucesso!');
    }

    private function validatedData(Request $request, ?TipoProduto $productType = null): array
    {
        $request->merge([
            'tb32_nome' => trim((string) $request->input('tb32_nome')),
            'tb32_ncm' => preg_replace('/\D+/', '', (string) $request->input('tb32_ncm')),
        ]);

        return $request->validate(
            [
                'tb32_nome' => [
                    'required',
                    'string',
                    'max:50',
                    Rule::unique('tb32_tipo_produto', 'tb32_nome')->ignore($productType?->tb32_id, 'tb32_id'),
                ],
                'tb32_ncm' => ['required', 'string', 'size:8'],
            ],
            [
                'tb32_nome.required' => 'Informe o nome do tipo de produto.',
                'tb32_nome.max' => 'O nome nao pode exceder :max caracteres.',
                'tb32_nome.unique' => 'Este nome ja esta cadastrado.',
                'tb32_ncm.required' => 'Informe o NCM.',
                'tb32_ncm.size' => 'O NCM deve ter exatamente 8 digitos.',
            ],
        );
    }
}
