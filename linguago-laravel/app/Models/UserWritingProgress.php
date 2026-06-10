<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserWritingProgress extends Model
{
    protected $table = 'user_writing_progress';

    protected $fillable = [
        'user_id',
        'writing_id',
        'status',
        'correct_count',
        'wrong_count',
        'xp_earned',
        'mastered_at',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function writingExercise()
    {
        return $this->belongsTo(WritingExercise::class, 'writing_id');
    }
}
