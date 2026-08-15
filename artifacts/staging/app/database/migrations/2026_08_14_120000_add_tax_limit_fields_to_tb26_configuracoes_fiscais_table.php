<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tb26_configuracoes_fiscais', function (Blueprint $table) {
            $table->boolean('tb26_limite_imposto_ativo')->default(false)->after('tb26_exigir_tef_integrado');
            $table->decimal('tb26_limite_imposto_diario', 12, 2)->nullable()->after('tb26_limite_imposto_ativo');
            $table->decimal('tb26_limite_imposto_mensal', 12, 2)->nullable()->after('tb26_limite_imposto_diario');
            $table->string('tb26_limite_imposto_bloqueado_por', 20)->nullable()->after('tb26_limite_imposto_mensal');
            $table->timestamp('tb26_limite_imposto_bloqueado_em')->nullable()->after('tb26_limite_imposto_bloqueado_por');
        });
    }

    public function down(): void
    {
        Schema::table('tb26_configuracoes_fiscais', function (Blueprint $table) {
            $table->dropColumn([
                'tb26_limite_imposto_ativo',
                'tb26_limite_imposto_diario',
                'tb26_limite_imposto_mensal',
                'tb26_limite_imposto_bloqueado_por',
                'tb26_limite_imposto_bloqueado_em',
            ]);
        });
    }
};
