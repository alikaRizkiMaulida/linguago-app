<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LevelConfig extends Model
{
    protected $table = 'level_configs';

    protected $primaryKey = 'level';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        'level',
        'min_xp',
        'max_xp',
        'reward_gems',
    ];
}
