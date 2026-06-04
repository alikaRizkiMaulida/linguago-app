<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StreakLog extends Model
{
    protected $table = 'streak_logs';

    protected $fillable = [
        'user_id',
        'activity_date',
        'xp_earned_day',
        'has_learned',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
