<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserShadowingAttempt extends Model
{
    protected $table = 'user_shadowing_attempts';

    protected $fillable = [
        'user_id',
        'shadowing_id',
        'recording_url',
        'pronunciation_score',
        'feedback',
        'xp_earned',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function shadowingExercise()
    {
        return $this->belongsTo(ShadowingExercise::class, 'shadowing_id');
    }
}
