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
        Schema::create('user_writing_progress', function (Blueprint $table) {
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('writing_id')->constrained('writing_exercises')->onDelete('cascade');
            $table->string('status', 30)->default('learning');
            $table->integer('correct_count')->default(0);
            $table->integer('wrong_count')->default(0);
            $table->integer('xp_earned')->default(0);
            $table->dateTime('mastered_at')->nullable();
            $table->timestamp('updated_at')->nullable();

            $table->primary(['user_id', 'writing_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_writing_progress');
    }
};
