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
        Schema::create('writing_exercises', function (Blueprint $table) {
            $table->id();
            $table->foreignId('node_id')->unique()->constrained('map_nodes')->onDelete('cascade');
            $table->string('character', 20);
            $table->string('character_name', 100)->nullable();
            $table->string('pronunciation', 100)->nullable();
            $table->string('stroke_order_image_url', 500)->nullable();
            $table->string('example_word', 100)->nullable();
            $table->string('example_meaning', 100)->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('writing_exercises');
    }
};
