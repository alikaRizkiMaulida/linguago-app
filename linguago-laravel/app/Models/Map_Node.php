<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Map_Node extends Model
{
    protected $table    = 'map_nodes';
    protected $fillable = [
        'chapter_id', 
        'node_number', 
        'title', 
        'description', 
        'node_type', 
        'position_x', 
        'position_y', 
        'required_node_id', 
        'reward_xp', 
        'reward_gems', 
        'is_boss_node'
        ];

    public function chapter(){
        return $this->belongsTo(Chapter::class);
    }
        public function videoLesson()
    {
        return $this->hasOne(VideoLesson::class, 'node_id');
    }

    public function quizzes()
    {
        return $this->hasMany(Quizzes::class, 'node_id');
    }

    public function shadowingExercise()
    {
        return $this->hasOne(ShadowingExercise::class, 'node_id');
    }

    public function writingExercise()
    {
        return $this->hasOne(WritingExercise::class, 'node_id');
    }

    public function nodeProgresses()
    {
        return $this->hasMany(UserNodeProgress::class, 'node_id');
    }
}