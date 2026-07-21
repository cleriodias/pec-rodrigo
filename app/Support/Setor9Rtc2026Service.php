<?php

namespace App\Support;

use App\Models\Produto;
use App\Models\ProdutoTributacaoFiscalUnidade;
use App\Models\Unidade;
use Illuminate\Support\Facades\DB;

class Setor9Rtc2026Service
{
    private const UNIT_NAME = 'SETOR-9';

    public function sync(Produto $product, ?int $userId = null, string $reason = 'ncm_updated'): array
    {
        $unit = $this->setor9();

        if (! $unit) {
            return ['status' => 'unit_not_found'];
        }

        $rule = ProdutoTributacaoFiscalUnidade::query()
            ->where('tb1_id', $product->tb1_id)
            ->where('tb2_id', $unit->tb2_id)
            ->first();

        if ($rule?->tb28_rtc_manual) {
            return ['status' => 'manual', 'rule' => $rule];
        }

        $after = $this->classificationFor($product);
        $before = $rule ? $this->rtcValues($rule) : null;

        if ($before === $after) {
            return ['status' => 'unchanged', 'rule' => $rule];
        }

        $rule ??= new ProdutoTributacaoFiscalUnidade([
            'tb1_id' => $product->tb1_id,
            'tb2_id' => $unit->tb2_id,
        ]);
        $rule->fill($after);
        $rule->tb28_rtc_manual = false;
        $rule->save();

        DB::table('tb31_historico_tributacoes_fiscais_produto_unidade')->insert([
            'tb1_id' => $product->tb1_id,
            'tb2_id' => $unit->tb2_id,
            'user_id' => $userId,
            'tb31_motivo' => $reason,
            'tb31_antes' => $before ? json_encode($before) : null,
            'tb31_depois' => json_encode($after),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return ['status' => 'updated', 'rule' => $rule, 'before' => $before, 'after' => $after];
    }

    public function preview(): array
    {
        $unit = $this->setor9();
        if (! $unit) return ['available' => false];

        $rules = ProdutoTributacaoFiscalUnidade::query()->where('tb2_id', $unit->tb2_id)->get()->keyBy('tb1_id');
        $summary = ['create' => 0, 'update' => 0, 'unchanged' => 0, 'manual' => 0, 'without_ncm' => 0];
        $samples = [];

        Produto::query()->orderBy('tb1_id')->each(function (Produto $product) use ($rules, &$summary, &$samples) {
            $rule = $rules->get($product->tb1_id);
            if ($rule?->tb28_rtc_manual) { $summary['manual']++; return; }
            if (blank($product->tb1_ncm)) $summary['without_ncm']++;
            $after = $this->classificationFor($product);
            $before = $rule ? $this->rtcValues($rule) : null;
            if ($before === $after) { $summary['unchanged']++; return; }
            $summary[$before ? 'update' : 'create']++;
            if (count($samples) < 8) $samples[] = ['id' => $product->tb1_id, 'name' => $product->tb1_nome, 'ncm' => $product->tb1_ncm, 'before' => $before, 'after' => $after];
        });

        return ['available' => true, 'unit_id' => (int) $unit->tb2_id, 'summary' => $summary, 'samples' => $samples];
    }

    public function reclassify(?int $userId = null): array
    {
        $result = ['updated' => 0, 'unchanged' => 0, 'manual' => 0];
        DB::transaction(function () use (&$result, $userId) {
            Produto::query()->orderBy('tb1_id')->each(function (Produto $product) use (&$result, $userId) {
                $status = $this->sync($product, $userId, 'setor9_reclassification')['status'];
                $result[$status] = ($result[$status] ?? 0) + 1;
            });
        });
        return $result;
    }

    public function isSetor9(int $unitId): bool
    {
        return (int) ($this->setor9()?->tb2_id ?? 0) === $unitId;
    }

    private function setor9(): ?Unidade
    {
        return Unidade::query()->where('tb2_nome', self::UNIT_NAME)->first();
    }

    private function classificationFor(Produto $product): array
    {
        $ncm = preg_replace('/\D/', '', (string) $product->tb1_ncm);
        $name = mb_strtoupper((string) $product->tb1_nome, 'UTF-8');
        $zeroI = ['04011010','04011090','04012010','04012090','04014010','04015010','04021010','04021090','04022110','04022120','04022910','04022920','04051000','15171000','15132120','11062000','19030000','11022000','11031300','11041900','11042300','11010010','17011400','17019900','11041200','11042200','11029000','25010020','25010090'];
        if (in_array($ncm, $zeroI, true) || $this->startsWithAny($ncm, ['100620','100630','0901','21011','07133319','07133329','07133399','07133590','19021']) || ($ncm === '19059090' && preg_match('/\bPAO\s+(DE\s+)?SAL\b|\bPAO\s+FRANC/', $name)) || ($ncm === '04061090' && str_contains($name, 'REQUEIJAO'))) return $this->rule('200', '200003', 100);
        if ($this->startsWithAny($ncm, ['04072','0701','07020000','0703','0704','0705','0706','07070000','0708','0709','0710','0714','08011','0803','0804','0805','0806','0807','0808','0809','0810','0811','06'])) return $this->rule('200', '200014', 100);
        if (in_array($ncm, ['04032000','04039000','11081200'], true) || $this->startsWithAny($ncm, ['1101','1102','1105','1106','110311','110319','11041','11042','100','120','190220','190230','19059010']) || ($ncm === '22029900' && preg_match('/IOG|IOUR|LEITE\s+FERMENTADO/', $name)) || ($ncm === '20029000' && str_contains($name, 'EXTRATO'))) return $this->rule('200', '200034', 60);
        if (in_array($ncm, ['34011190','33061000','96032100','48181000','34011900','96190000'], true)) return $this->rule('200', '200035', 60);
        return $this->rule('000', '000001', 0);
    }

    private function rule(string $cst, string $cclass, float $reduction): array
    {
        return ['tb28_cst_ibs_cbs' => $cst, 'tb28_cclass_trib' => $cclass, 'tb28_aliquota_ibs_uf' => 0.1, 'tb28_aliquota_ibs_mun' => 0.0, 'tb28_aliquota_cbs' => 0.9, 'tb28_reducao_ibs_uf' => $reduction, 'tb28_reducao_ibs_mun' => $reduction, 'tb28_reducao_cbs' => $reduction, 'tb28_ativo' => true];
    }

    private function rtcValues(ProdutoTributacaoFiscalUnidade $rule): array
    {
        return [
            'tb28_cst_ibs_cbs' => (string) $rule->tb28_cst_ibs_cbs,
            'tb28_cclass_trib' => (string) $rule->tb28_cclass_trib,
            'tb28_aliquota_ibs_uf' => (float) $rule->tb28_aliquota_ibs_uf,
            'tb28_aliquota_ibs_mun' => (float) $rule->tb28_aliquota_ibs_mun,
            'tb28_aliquota_cbs' => (float) $rule->tb28_aliquota_cbs,
            'tb28_reducao_ibs_uf' => (float) $rule->tb28_reducao_ibs_uf,
            'tb28_reducao_ibs_mun' => (float) $rule->tb28_reducao_ibs_mun,
            'tb28_reducao_cbs' => (float) $rule->tb28_reducao_cbs,
            'tb28_ativo' => (bool) $rule->tb28_ativo,
        ];
    }

    private function startsWithAny(string $value, array $prefixes): bool
    {
        foreach ($prefixes as $prefix) if (str_starts_with($value, $prefix)) return true;
        return false;
    }
}