<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserQuizAttempt extends Model
{
    protected $table    = 'user_quiz_attempts';
    protected $fillable = [
        'user_id',
        'quiz_id',
        'score',
        'stars',
        'correct_count',
        'wrong_count',
        'xp_earned',
        'is_passed',
        'started_at',
        'finished_at',
    ];

    // Relasi ke User
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Relasi ke Quiz
    public function quiz()
    {
        return $this->belongsTo(Quizzes::class);
    }

    // Relasi ke UserAnswer
    public function answers()
    {
        return $this->hasMany(UserAnswer::class, 'attempt_id');
    }
}
