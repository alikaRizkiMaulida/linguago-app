<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Course extends Model
{
    protected $table    = 'courses';
    protected $fillable = [
        'course_title', 
        'language', 
        'description', 
        'thumbnail_url'
    ];

     public function chapters(){
        return $this->hasMany(Chapter::class);
    }
}