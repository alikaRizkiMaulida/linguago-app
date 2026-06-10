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
        Schema::create('user_shadowing_attempts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('shadowing_id')->constrained('shadowing_exercises')->onDelete('cascade');
            $table->string('recording_url', 500)->nullable();
            $table->integer('pronunciation_score')->default(0);
            $table->text('feedback')->nullable();
            $table->integer('xp_earned')->default(0);
            $table->timestamps();

            $table->index(['user_id', 'shadowing_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_shadowing_attempts');
    }
};
