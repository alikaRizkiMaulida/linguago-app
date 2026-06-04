<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Quizzes extends Model
{
    protected $table = 'quizzes';
    protected $fillable = [
        'node_id',
        'title',
        'passing_score'
    ];

    public function mapNode(){
        return $this->belongsTo(Map_Node::class, 'node_id');
    }
    
    public function questions(){
        return $this->hasMany(Questions::class, 'quiz_id');
    }

    public function attempts(){
        return $this->hasMany(UserQuizAttempt::class, 'quiz_id');
    }
}