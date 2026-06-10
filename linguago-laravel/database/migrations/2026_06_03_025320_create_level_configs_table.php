<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('level_configs', function (Blueprint $table) {
            $table->integer('level')->primary();
            $table->integer('min_xp');
            $table->integer('max_xp');
            $table->integer('reward_gems')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('level_configs');
    }
};
