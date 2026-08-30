<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UpdateProdutoCstSeeder extends Seeder
{
    public function run(): void
    {
        $total = DB::table('tb1_produto')->count();
        $alreadyUpdated = DB::table('tb1_produto')
            ->where('tb1_cst', '00')
            ->count();

        $updated = DB::table('tb1_produto')
            ->where(function ($query) {
                $query->whereNull('tb1_cst')
                    ->orWhere('tb1_cst', '!=', '00');
            })
            ->update([
                'tb1_cst' => '00',
                'updated_at' => now(),
            ]);

        $this->command?->info(sprintf(
            'tb1_produto.tb1_cst atualizado para 00. Total: %d | Ja estavam 00: %d | Alterados agora: %d',
            $total,
            $alreadyUpdated,
            $updated
        ));
    }
}
