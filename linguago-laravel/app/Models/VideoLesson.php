<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VideoLesson extends Model
{
    protected $table = 'video_lessons';
    protected $fillable = [
        'node_id', 
        'title', 
        'video_url', 
        'thumbnail_url', 
        'duration_seconds'
    ];

    public function nodeVideo(){
        return $this->belongsTo(Map_Node::class, 'node_id');
    }
}