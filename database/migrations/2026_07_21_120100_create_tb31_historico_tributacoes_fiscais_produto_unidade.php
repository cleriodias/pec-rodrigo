<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('tb31_historico_tributacoes_fiscais_produto_unidade', function (Blueprint $table) {
            $table->bigIncrements('tb31_id');
            $table->unsignedBigInteger('tb1_id');
            $table->unsignedBigInteger('tb2_id');
            $table->unsignedBigInteger('user_id')->nullable();
            $table->string('tb31_motivo', 50);
            $table->json('tb31_antes')->nullable();
            $table->json('tb31_depois');
            $table->timestamps();
            $table->index(['tb1_id', 'tb2_id'], 'tb31_produto_unidade_idx');
        });
    }
    public function down(): void { Schema::dropIfExists('tb31_historico_tributacoes_fiscais_produto_unidade'); }
};