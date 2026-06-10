<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ShadowingExercise extends Model
{
    protected $table = 'shadowing_exercises';

    protected $fillable = [
        'node_id',
        'title',
        'audio_url',
        'text_original',
        'text_translation',
    ];

    public function mapNode()
    {
        return $this->belongsTo(Map_Node::class, 'node_id');
    }

    public function attempts()
    {
        return $this->hasMany(UserShadowingAttempt::class, 'shadowing_id');
    }
}
