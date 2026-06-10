<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Chapter extends Model
{
    protected $table    = 'chapters';
    protected $fillable = [
        'course_id', 
        'chapter_number', 
        'chapter_title', 
        'description'
    ];

    public function course(){
        return $this->belongsTo(Course::class);
    }
    public function mapNodes(){
        return $this->hasMany(Map_Node::class, 'chapter_id');
    }
}