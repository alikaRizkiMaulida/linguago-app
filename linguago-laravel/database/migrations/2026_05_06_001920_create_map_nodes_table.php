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
        Schema::create('map_nodes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chapter_id')->constrained('chapters')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('node_number')->nullable();
            $table->string('title')->nullable();
            $table->text('description'); 
            $table->string('node_type')->nullable();
            $table->integer('position_x')->default(0);
            $table->integer('position_y')->default(0);
            $table->foreignId('required_node_id')->nullable()->constrained('map_nodes')->onDelete('set null');
            $table->integer('reward_xp')->default(10);
            $table->integer('reward_gems')->default(0);
            $table->boolean('is_boss_node')->default(false);
            $table->unique(['chapter_id', 'node_number']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('map_nodes');
    }
};