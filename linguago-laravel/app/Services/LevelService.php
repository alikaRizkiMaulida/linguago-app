<?php
namespace App\Services;

use App\Models\LevelConfig;
use App\Models\User;

class LevelService
{
    public static function recalculate(User $user): void
    {
        $levelConfig = LevelConfig::where('min_xp', '<=', $user->total_xp)
            ->where('max_xp', '>=', $user->total_xp)
            ->orderBy('level', 'desc')
            ->first();

        if (!$levelConfig) {
            $highest = LevelConfig::orderBy('level', 'desc')->first();
            if ($highest && $user->total_xp > $highest->max_xp) {
                if ($user->level !== $highest->level) {
                    $user->level = $highest->level;
                    $user->saveQuietly();
                }
            }
            return;
        }

        if ($user->level !== $levelConfig->level) {
            $user->level = $levelConfig->level;
            $user->saveQuietly();
        }
    }
}
