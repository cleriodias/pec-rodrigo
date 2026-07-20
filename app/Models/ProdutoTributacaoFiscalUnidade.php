<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProdutoTributacaoFiscalUnidade extends Model
{
    use HasFactory;

    protected $table = 'tb30_tributacoes_fiscais_produto_unidade';
    protected $primaryKey = 'tb28_id';

    protected $fillable = [
        'tb1_id', 'tb2_id', 'tb28_csosn', 'tb28_cst_icms', 'tb28_aliquota_icms',
        'tb28_cst_pis', 'tb28_aliquota_pis', 'tb28_cst_cofins', 'tb28_aliquota_cofins',
        'tb28_cst_ibs_cbs', 'tb28_cclass_trib', 'tb28_aliquota_ibs_uf',
        'tb28_aliquota_ibs_mun', 'tb28_aliquota_cbs', 'tb28_reducao_ibs_uf',
        'tb28_reducao_ibs_mun', 'tb28_reducao_cbs', 'tb28_ativo',
    ];

    protected $casts = [
        'tb28_aliquota_icms' => 'float', 'tb28_aliquota_pis' => 'float',
        'tb28_aliquota_cofins' => 'float', 'tb28_aliquota_ibs_uf' => 'float',
        'tb28_aliquota_ibs_mun' => 'float', 'tb28_aliquota_cbs' => 'float',
        'tb28_reducao_ibs_uf' => 'float', 'tb28_reducao_ibs_mun' => 'float',
        'tb28_reducao_cbs' => 'float', 'tb28_ativo' => 'boolean',
    ];

    public function produto(): BelongsTo
    {
        return $this->belongsTo(Produto::class, 'tb1_id', 'tb1_id');
    }

    public function unidade(): BelongsTo
    {
        return $this->belongsTo(Unidade::class, 'tb2_id', 'tb2_id');
    }
}
