<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tb26_configuracoes_fiscais', function (Blueprint $table) {
            $table->boolean('tb26_rtc_2026_ativa')->default(false)->after('tb26_geracao_automatica_ativa');
        });

        Schema::create('tb30_tributacoes_fiscais_produto_unidade', function (Blueprint $table) {
            $table->bigIncrements('tb28_id');
            $table->unsignedBigInteger('tb1_id');
            $table->unsignedBigInteger('tb2_id');
            $table->string('tb28_csosn', 3)->nullable();
            $table->string('tb28_cst_icms', 3)->nullable();
            $table->decimal('tb28_aliquota_icms', 7, 4)->nullable();
            $table->string('tb28_cst_pis', 2)->nullable();
            $table->decimal('tb28_aliquota_pis', 7, 4)->nullable();
            $table->string('tb28_cst_cofins', 2)->nullable();
            $table->decimal('tb28_aliquota_cofins', 7, 4)->nullable();
            $table->string('tb28_cst_ibs_cbs', 3);
            $table->string('tb28_cclass_trib', 6);
            $table->decimal('tb28_aliquota_ibs_uf', 7, 4);
            $table->decimal('tb28_aliquota_ibs_mun', 7, 4)->default(0);
            $table->decimal('tb28_aliquota_cbs', 7, 4);
            $table->decimal('tb28_reducao_ibs_uf', 7, 4)->default(0);
            $table->decimal('tb28_reducao_ibs_mun', 7, 4)->default(0);
            $table->decimal('tb28_reducao_cbs', 7, 4)->default(0);
            $table->boolean('tb28_ativo')->default(true);
            $table->timestamps();
            $table->unique(['tb1_id', 'tb2_id'], 'tb30_produto_unidade_unique');
            $table->index(['tb2_id', 'tb28_ativo'], 'tb30_unidade_ativo_idx');
            $table->foreign('tb1_id')->references('tb1_id')->on('tb1_produto')->cascadeOnDelete();
            $table->foreign('tb2_id')->references('tb2_id')->on('tb2_unidades')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tb30_tributacoes_fiscais_produto_unidade');
        Schema::table('tb26_configuracoes_fiscais', function (Blueprint $table) {
            $table->dropColumn('tb26_rtc_2026_ativa');
        });
    }
};
