<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserVideoProgress extends Model
{
    protected $table = 'user_video_progress';
    protected $fillable = [
        'user_id',
        'video_id',
        'watched_seconds',
        'is_completed',
        'completed_at'
    ];

    public function user(){
      return $this->belongsTo(User::class);
    }

    public function video(){
        return $this->belongsTo(VideoLesson::class, 'video_id');
    }
}