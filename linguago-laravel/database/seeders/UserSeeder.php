<?php
namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'username' => 'user1',
            'email'    => 'user1@gmail.com',
            'password' => bcrypt('password'),
            'name'     => 'alika',
        ]);

        User::create([
            'username' => 'naimah',
            'email'    => 'naimah@gmail.com',
            'password' => bcrypt('naimah2007'),
            'name'     => 'naimah',
        ]);
    }
}