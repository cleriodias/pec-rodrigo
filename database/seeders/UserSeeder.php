<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = [
            [
                'name' => 'Clerio',
                'email' => 'cleriodias@gmail.com',
                'password' => Hash::make('08001010'),
                'hr_ini' => '00:00:00',
                'hr_fim' => '23:00:00',
                'funcao' => 0,
                'tb2_id' => 1,
            ],
            [
                'name' => 'Rodrigo',
                'email' => 'trucadoturbinado@gmail.com',
                'password' => Hash::make('08001010'),
                'hr_ini' => '00:00:00',
                'hr_fim' => '23:00:00',
                'funcao' => 0,
                'tb2_id' => 1,
            ],
            [
                'name' => 'Selma',
                'email' => 'paoecaf83@gmail.com',
                'password' => Hash::make('025879'),
                'hr_ini' => '00:00:00',
                'hr_fim' => '23:00:00',
                'funcao' => 3,
                'tb2_id' => 1,
            ],
        ];

        foreach ($users as $payload) {
            User::updateOrCreate(
                ['email' => $payload['email']],
                $payload
            );
        }
    }
}
