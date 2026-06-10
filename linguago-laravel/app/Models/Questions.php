<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Questions extends Model
{
    protected $table = 'questions';

    protected $fillable = [
        'quiz_id',
        'question_text',
        'question_image_url',
        'question_audio_url',
        'explanation',
        'points',
        'soft_order'
    ];

    public function quiz(){
        return $this->belongsTo(Quizzes::class, 'quiz_id');
    }
    public function options() {
        return $this->hasMany(QuestionOptions::class, 'question_id');
    }
}