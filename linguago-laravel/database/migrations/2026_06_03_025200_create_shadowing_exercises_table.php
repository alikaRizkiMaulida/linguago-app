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
        Schema::create('shadowing_exercises', function (Blueprint $table) {
            $table->id();
            $table->foreignId('node_id')->unique()->constrained('map_nodes')->onDelete('cascade');
            $table->string('title', 150);
            $table->string('audio_url', 500);
            $table->text('text_original');
            $table->text('text_translation')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('shadowing_exercises');
    }
};
