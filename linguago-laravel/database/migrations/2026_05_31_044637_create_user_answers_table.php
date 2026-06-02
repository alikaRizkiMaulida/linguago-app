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
        Schema::create('user_answers', function (Blueprint $table) {
            $table->id();

            // Foreign Keys
            $table->foreignId('attempt_id')->constrained('user_quiz_attempts')->onDelete('cascade');
            $table->foreignId('question_id')->constrained('questions')->onDelete('cascade');

            // selected_option_id bisa null (jika siswa tidak menjawab / skipped)
            $table->foreignId('selected_option_id')->constrained('question_options')->onDelete('cascade');

            // Columns
            $table->boolean('is_correct')->default(false);

            // Timestamps Laravel (created_at & updated_at)
            $table->timestamps();

            // Unique Composite Index
            $table->unique(['attempt_id', 'question_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_answers');
    }
};