<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::table('tb30_tributacoes_fiscais_produto_unidade', function (Blueprint $table) {
            $table->boolean('tb28_rtc_manual')->default(false)->after('tb28_ativo');
        });
    }
    public function down(): void {
        Schema::table('tb30_tributacoes_fiscais_produto_unidade', function (Blueprint $table) {
            $table->dropColumn('tb28_rtc_manual');
        });
    }
};