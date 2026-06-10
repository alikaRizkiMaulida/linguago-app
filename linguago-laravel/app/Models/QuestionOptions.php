<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class QuestionOptions extends Model
{
    protected $table= 'question_options';
    protected $fillable = [
        'question_id',
        'option_text',
        'is_correct',
        'soft_order'
    ];

    public function question(){
        return $this->belongsTo(Questions::class, 'question_id');
    }
}