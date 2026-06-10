<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserAnswer extends Model
{
    protected $table    = 'user_answers';
    protected $fillable = [
        'attempt_id',
        'question_id',
        'selected_option_id',
        'is_correct',
    ];

    // Relasi ke UserQuizAttempt
    public function attempt()
    {
        return $this->belongsTo(UserQuizAttempt::class, 'attempt_id');
    }

    // Relasi ke Question
    public function question()
    {
        return $this->belongsTo(Questions::class, 'question_id');
    }

    // Relasi ke QuestionOption (jawaban yang dipilih)
    public function selectedOption()
    {
        return $this->belongsTo(QuestionOptions::class, 'selected_option_id');
    }
}