<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WritingExercise extends Model
{
    protected $table = 'writing_exercises';

    protected $fillable = [
        'node_id',
        'character',
        'character_name',
        'pronunciation',
        'stroke_order_image_url',
        'example_word',
        'example_meaning',
    ];

    public function mapNode()
    {
        return $this->belongsTo(Map_Node::class, 'node_id');
    }

    public function progresses()
    {
        return $this->hasMany(UserWritingProgress::class, 'writing_id');
    }
}
