<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('users')->insert([
            'username' => 'user1',
            'email'    => 'user1@gmail.com',
            'password' => Hash::make('password'),
            'name'     => 'alika',
        ]);
    }
}