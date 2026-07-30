<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tb26_configuracoes_fiscais', function (Blueprint $table) {
            $table->boolean('tb26_exigir_tef_integrado')->default(false)->after('tb26_geracao_automatica_ativa');
        });

        Schema::table('tb4_vendas_pg', function (Blueprint $table) {
            $table->boolean('tef_integrado')->default(false)->after('dois_pgto');
            $table->string('tef_autorizacao', 20)->nullable()->after('tef_integrado');
            $table->string('tef_cnpj_credenciadora', 14)->nullable()->after('tef_autorizacao');
            $table->string('tef_bandeira', 2)->nullable()->after('tef_cnpj_credenciadora');
            $table->string('tef_terminal', 40)->nullable()->after('tef_bandeira');
            $table->timestamp('tef_transacao_em')->nullable()->after('tef_terminal');
            $table->json('tef_payload')->nullable()->after('tef_transacao_em');
        });
    }

    public function down(): void
    {
        Schema::table('tb4_vendas_pg', function (Blueprint $table) {
            $table->dropColumn([
                'tef_integrado',
                'tef_autorizacao',
                'tef_cnpj_credenciadora',
                'tef_bandeira',
                'tef_terminal',
                'tef_transacao_em',
                'tef_payload',
            ]);
        });

        Schema::table('tb26_configuracoes_fiscais', function (Blueprint $table) {
            $table->dropColumn('tb26_exigir_tef_integrado');
        });
    }
};
