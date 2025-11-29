<?php

namespace App\Http\Controllers;

use App\Models\Produto;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;

class ProductController extends Controller
{
    private const TYPE_LABELS = [
        0 => 'Indústria',
        1 => 'Balança',
        2 => 'Serviço',
    ];

    private const STATUS_LABELS = [
        0 => 'Inativo',
        1 => 'Ativo',
    ];

    public function index(Request $request): Response
    {
        $search = trim((string) $request->input('search', ''));
        $query = Produto::query();

        if ($search !== '') {
            $isNumeric = ctype_digit($search);
            $safeTerm = str_replace(['%', '_'], ['\%', '\_'], $search);
            $likeTerm = '%' . $safeTerm . '%';
            $numericTerm = $isNumeric ? (int) $search : null;
            $isLongNumeric = $isNumeric && mb_strlen($search) > 4;

            $query->where(function ($builder) use ($isNumeric, $isLongNumeric, $likeTerm, $numericTerm) {
                if ($isNumeric) {
                    if ($isLongNumeric) {
                        $builder->where('tb1_codbar', 'like', $likeTerm);
                    } else {
                        $builder->where('tb1_id', $numericTerm);
                    }

                    return;
                }

                $builder->where('tb1_nome', 'like', $likeTerm);
            });
        }

        $products = $query
            ->orderByDesc('tb1_favorito')
            ->orderByDesc('tb1_id')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Products/ProductIndex', [
            'products' => $products,
            'typeLabels' => self::TYPE_LABELS,
            'statusLabels' => self::STATUS_LABELS,
            'search' => $search,
        ]);
    }

    public function show(Produto $product): Response
    {
        return Inertia::render('Products/ProductShow', [
            'product' => $product,
            'typeLabels' => self::TYPE_LABELS,
            'statusLabels' => self::STATUS_LABELS,
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Products/ProductCreate', $this->formOptions());
    }

    public function store(Request $request)
    {
        $data = $this->validateProduct($request);

        $product = Produto::create($data);

        return Redirect::route('products.show', ['product' => $product->tb1_id])
            ->with('success', 'Produto cadastrado com sucesso!');
    }

    public function edit(Produto $product): Response
    {
        return Inertia::render('Products/ProductEdit', array_merge(
            ['product' => $product],
            $this->formOptions()
        ));
    }

    public function update(Request $request, Produto $product)
    {
        $data = $this->validateProduct($request, $product);

        $product->update($data);

        return Redirect::route('products.show', ['product' => $product->tb1_id])
            ->with('success', 'Produto atualizado com sucesso!');
    }

    public function destroy(Produto $product)
    {
        $product->delete();

        return Redirect::route('products.index')
            ->with('success', 'Produto removido com sucesso!');
    }

    public function toggleFavorite(Request $request, Produto $product)
    {
        $data = $request->validate([
            'favorite' => 'required|boolean',
        ]);

        $product->update([
            'tb1_favorito' => $data['favorite'],
        ]);

        return Redirect::back()->with('success', $data['favorite'] ? 'Produto marcado como favorito.' : 'Produto removido dos favoritos.');
    }

    public function favorites(): JsonResponse
    {
        $favorites = Produto::query()
            ->where('tb1_favorito', true)
            ->where('tb1_status', 1)
            ->orderBy('tb1_nome')
            ->get([
                'tb1_id',
                'tb1_nome',
                'tb1_codbar',
                'tb1_vlr_custo',
                'tb1_vlr_venda',
                'tb1_tipo',
                'tb1_status',
            ]);

        return response()->json($favorites);
    }

    public function search(Request $request): JsonResponse
    {
        $term = trim((string) $request->input('q', ''));

        $isNumeric = ctype_digit($term);

        if (mb_strlen($term) < 3 && !$isNumeric) {
            return response()->json([]);
        }

        $safeTerm = str_replace(['%', '_'], ['\\%', '\\_'], $term);
        $likeTerm = '%' . $safeTerm . '%';
        $numericTerm = $isNumeric ? (int) $term : null;
        $isLongNumeric = $isNumeric && mb_strlen($term) > 4;

        $products = Produto::query()
            ->where(function ($query) use ($isNumeric, $isLongNumeric, $likeTerm, $numericTerm) {
                if ($isNumeric) {
                    if ($isLongNumeric) {
                        $query->where('tb1_codbar', 'like', $likeTerm);
                    } else {
                        $query->where('tb1_id', $numericTerm);
                    }

                    return;
                }

                $query->where('tb1_nome', 'like', $likeTerm);
            })
            ->orderByDesc('tb1_status')
            ->orderBy('tb1_nome')
            ->limit(10)
            ->get([
                'tb1_id',
                'tb1_nome',
                'tb1_codbar',
                'tb1_vlr_custo',
                'tb1_vlr_venda',
                'tb1_tipo',
                'tb1_status',
            ]);

        return response()->json($products);
    }

    private function validateProduct(Request $request, ?Produto $product = null): array
    {
        return $request->validate(
            [
                'tb1_nome' => 'required|string|max:45',
                'tb1_vlr_custo' => 'required|numeric|min:0',
                'tb1_vlr_venda' => 'required|numeric|min:0|gte:tb1_vlr_custo',
                'tb1_codbar' => [
                    'required',
                    'string',
                    'max:64',
                    Rule::unique('tb1_produto', 'tb1_codbar')->ignore($product?->tb1_id, 'tb1_id'),
                ],
                'tb1_tipo' => [
                    'required',
                    'integer',
                    Rule::in(array_keys(self::TYPE_LABELS)),
                ],
                'tb1_status' => [
                    'required',
                    'integer',
                    Rule::in(array_keys(self::STATUS_LABELS)),
                ],
            ],
            [
                'tb1_nome.required' => 'Informe o nome do produto.',
                'tb1_nome.max' => 'O nome não pode exceder :max caracteres.',
                'tb1_vlr_custo.required' => 'Informe o valor de custo.',
                'tb1_vlr_custo.numeric' => 'O valor de custo deve ser numérico.',
                'tb1_vlr_custo.min' => 'O valor de custo deve ser maior ou igual a zero.',
                'tb1_vlr_venda.required' => 'Informe o valor de venda.',
                'tb1_vlr_venda.numeric' => 'O valor de venda deve ser numérico.',
                'tb1_vlr_venda.min' => 'O valor de venda deve ser maior ou igual a zero.',
                'tb1_vlr_venda.gte' => 'O valor de venda deve ser maior que o valor de custo.',
                'tb1_codbar.required' => 'Informe o código de barras.',
                'tb1_codbar.max' => 'O código de barras deve ter no máximo :max caracteres.',
                'tb1_codbar.unique' => 'Este código de barras já está cadastrado.',
                'tb1_tipo.required' => 'Selecione o tipo do produto.',
                'tb1_tipo.integer' => 'Tipo de produto inválido.',
                'tb1_tipo.in' => 'Tipo de produto não reconhecido.',
                'tb1_status.required' => 'Selecione o status do produto.',
                'tb1_status.integer' => 'Status inválido.',
                'tb1_status.in' => 'Status não reconhecido.',
            ]
        );
    }

    private function formOptions(): array
    {
        $format = fn (array $labels) => collect($labels)
            ->map(fn (string $label, int $value) => ['value' => $value, 'label' => $label])
            ->values()
            ->all();

        return [
            'typeOptions' => $format(self::TYPE_LABELS),
            'statusOptions' => $format(self::STATUS_LABELS),
        ];
    }
}
