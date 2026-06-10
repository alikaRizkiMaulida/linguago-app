<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserNodeProgress extends Model
{
    protected $table = "user_node_progress";
    protected $fillable = [
        'user_id', 
        'node_id', 
        'status', 
        'score', 
        'stars', 
        'xp_earned', 
        'completed_at'
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }
    
    public function nodeProgress(){
        return $this->belongsTo(Map_Node::class, 'node_id');
    }
}