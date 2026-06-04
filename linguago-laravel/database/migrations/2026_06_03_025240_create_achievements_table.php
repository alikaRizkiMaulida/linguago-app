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
        Schema::create('achievements', function (Blueprint $table) {
            $table->id();
            $table->string('title', 100);
            $table->text('description')->nullable();
            $table->string('badge_icon_url', 500)->nullable();
            $table->string('category', 50);
            $table->string('condition_type', 50);
            $table->integer('condition_value')->default(0);
            $table->integer('reward_xp')->default(0);
            $table->integer('reward_gems')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('achievements');
    }
};
