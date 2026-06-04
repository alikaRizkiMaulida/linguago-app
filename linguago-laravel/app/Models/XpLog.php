<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class XpLog extends Model
{
    protected $table = 'xp_logs';

    // Disable updated_at since only created_at is present in DBML
    const UPDATED_AT = null;

    protected $fillable = [
        'user_id',
        'source_type',
        'source_id',
        'xp_amount',
        'created_at',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
