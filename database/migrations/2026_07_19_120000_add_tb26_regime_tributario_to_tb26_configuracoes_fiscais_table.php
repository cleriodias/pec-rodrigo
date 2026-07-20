<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('tb28_tributacoes_fiscais_produto_unidade') && ! Schema::hasTable('tb30_tributacoes_fiscais_produto_unidade')) {
            Schema::rename('tb28_tributacoes_fiscais_produto_unidade', 'tb30_tributacoes_fiscais_produto_unidade');
        }

        Schema::table('tb26_configuracoes_fiscais', function (Blueprint $table) {
            $table->string('tb26_regime_tributario', 30)->nullable()->after('tb26_crt');
        });
    }

    public function down(): void
    {
        Schema::table('tb26_configuracoes_fiscais', function (Blueprint $table) {
            $table->dropColumn('tb26_regime_tributario');
        });

        if (Schema::hasTable('tb30_tributacoes_fiscais_produto_unidade') && ! Schema::hasTable('tb28_tributacoes_fiscais_produto_unidade')) {
            Schema::rename('tb30_tributacoes_fiscais_produto_unidade', 'tb28_tributacoes_fiscais_produto_unidade');
        }
    }
};
