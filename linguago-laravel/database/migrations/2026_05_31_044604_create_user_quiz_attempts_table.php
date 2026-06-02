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
        Schema::create('user_quiz_attempts', function (Blueprint $table) {
            $table->id();

            // Foreign Keys (Asumsi tabel users dan quizzes menggunakan tipe id() standar)
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('quiz_id')->constrained('quizzes')->onDelete('cascade');

            // Columns
            $table->integer('score')->default(0);
            $table->integer('stars')->default(0);
            $table->integer('correct_count')->default(0);
            $table->integer('wrong_count')->default(0);
            $table->integer('xp_earned')->default(0);
            $table->boolean('is_passed')->default(false);

            // Timestamps pengerjaan
            $table->dateTime('started_at')->nullable();
            $table->dateTime('finished_at')->nullable();

            // Timestamps Laravel (created_at & updated_at)
            $table->timestamps();

            // Composite Index
            $table->index(['user_id', 'quiz_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_quiz_attempts');
    }
};