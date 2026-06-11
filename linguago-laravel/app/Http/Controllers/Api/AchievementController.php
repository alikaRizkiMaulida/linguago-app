<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Achievement;
use App\Models\Follow;
use App\Models\StreakLog;
use App\Models\User;
use App\Models\UserAchievement;
use App\Models\UserNodeProgress;
use App\Helpers\NotificationHelper;
use App\Services\LevelService;
use App\Models\UserQuizAttempt;
use App\Models\UserShadowingAttempt;
use App\Models\UserWritingProgress;
use App\Models\XpLog;
use Carbon\Carbon;
use Illuminate\Http\Request;

class AchievementController extends Controller
{
    /**
     * Semua achievement yang tersedia beserta status user (earned / belum).
     * GET /api/achievements
     */
    public function index(Request $request)
    {
        $user = $request->user();

        // Ambil achievement_id yang sudah didapat user
        $earnedIds = UserAchievement::where('user_id', $user->id)
            ->pluck('earned_at', 'achievement_id')
            ->toArray();

        $achievements = Achievement::orderBy('category')
            ->orderBy('condition_value')
            ->get()
            ->map(function ($ach) use ($user, $earnedIds) {
                $isEarned = array_key_exists($ach->id, $earnedIds);

                return [
                    'id'              => $ach->id,
                    'title'           => $ach->title,
                    'description'     => $ach->description,
                    'badge_icon_url'  => $ach->badge_icon_url,
                    'category'        => $ach->category,
                    'condition_type'  => $ach->condition_type,
                    'condition_value' => $ach->condition_value,
                    'reward_xp'       => $ach->reward_xp,
                    'reward_gems'     => $ach->reward_gems,
                    'is_earned'       => $isEarned,
                    'earned_at'       => $isEarned ? $earnedIds[$ach->id] : null,
                    'progress'        => $this->getProgress($user, $ach),
                ];
            });

        // Grouping per category
        $grouped = $achievements->groupBy('category');

        return response()->json([
            'status' => 'success',
            'data'   => [
                'total_earned' => collect($earnedIds)->count(),
                'total_achievements' => Achievement::count(),
                'categories' => $grouped,
            ],
        ], 200);
    }

    /**
     * Achievement yang sudah didapat user.
     * GET /api/achievements/earned
     */
    public function earned(Request $request)
    {
        $user = $request->user();

        $earned = $user->achievements()
            ->orderByPivot('earned_at', 'desc')
            ->get()
            ->map(function ($ach) {
                return [
                    'id'              => $ach->id,
                    'title'           => $ach->title,
                    'description'     => $ach->description,
                    'badge_icon_url'  => $ach->badge_icon_url,
                    'category'        => $ach->category,
                    'reward_xp'       => $ach->reward_xp,
                    'reward_gems'     => $ach->reward_gems,
                    'earned_at'       => $ach->pivot->earned_at,
                ];
            });

        return response()->json([
            'status' => 'success',
            'data'   => [
                'total_earned'   => $earned->count(),
                'achievements'   => $earned,
            ],
        ], 200);
    }

    /**
     * Detail satu achievement + progress user.
     * GET /api/achievements/{achievementId}
     */
    public function show(Request $request, $achievementId)
    {
        $user = $request->user();

        $ach = Achievement::find($achievementId);
        if (!$ach) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Achievement tidak ditemukan',
            ], 404);
        }

        $userAch = UserAchievement::where('user_id', $user->id)
            ->where('achievement_id', $achievementId)
            ->first();

        $progress = $this->getProgress($user, $ach);

        return response()->json([
            'status' => 'success',
            'data'   => [
                'id'              => $ach->id,
                'title'           => $ach->title,
                'description'     => $ach->description,
                'badge_icon_url'  => $ach->badge_icon_url,
                'category'        => $ach->category,
                'condition_type'  => $ach->condition_type,
                'condition_value' => $ach->condition_value,
                'reward_xp'       => $ach->reward_xp,
                'reward_gems'     => $ach->reward_gems,
                'is_earned'       => $userAch !== null,
                'earned_at'       => $userAch ? $userAch->earned_at : null,
                'progress'        => $progress,
            ],
        ], 200);
    }

    /**
     * Cek dan berikan achievement baru yang sudah memenuhi syarat.
     * POST /api/achievements/check
     *
     * Dipanggil setelah user menyelesaikan aktivitas (quiz, shadowing, dll).
     * Mengembalikan daftar achievement yang BARU didapat.
     */
    public function checkAndAward(Request $request)
    {
        $user = $request->user();

        $newlyEarned = $this->evaluateAchievements($user);

        if ($newlyEarned->isEmpty()) {
            return response()->json([
                'status'  => 'success',
                'message' => 'Belum ada achievement baru',
                'data'    => [
                    'newly_earned' => [],
                ],
            ], 200);
        }

        return response()->json([
            'status'  => 'success',
            'message' => 'Selamat! Kamu mendapat achievement baru!',
            'data'    => [
                'newly_earned' => $newlyEarned,
            ],
        ], 200);
    }

    /**
     * Evaluasi semua achievement dan berikan yang sudah qualify.
     * Mengembalikan collection achievement yang baru saja di-award.
     */
    public function evaluateAchievements(User $user)
    {
        // Achievement yang sudah dimiliki
        $earnedIds = UserAchievement::where('user_id', $user->id)
            ->pluck('achievement_id')
            ->toArray();

        // Achievement yang belum dimiliki
        $pending = Achievement::whereNotIn('id', $earnedIds)->get();

        $newlyEarned = collect();

        foreach ($pending as $ach) {
            $currentValue = $this->getCurrentValue($user, $ach->condition_type);

            if ($currentValue >= $ach->condition_value) {
                // Award achievement
                UserAchievement::create([
                    'user_id'        => $user->id,
                    'achievement_id' => $ach->id,
                    'earned_at'      => Carbon::now(),
                ]);

                // Berikan reward XP
                if ($ach->reward_xp > 0) {
                    $user->total_xp += $ach->reward_xp;

                    XpLog::create([
                        'user_id'     => $user->id,
                        'source_type' => 'achievement',
                        'source_id'   => $ach->id,
                        'xp_amount'   => $ach->reward_xp,
                    ]);
                }

                // Berikan reward gems
                if ($ach->reward_gems > 0) {
                    $user->gems += $ach->reward_gems;
                }

                $newlyEarned->push([
                    'id'             => $ach->id,
                    'title'          => $ach->title,
                    'description'    => $ach->description,
                    'badge_icon_url' => $ach->badge_icon_url,
                    'category'       => $ach->category,
                    'reward_xp'      => $ach->reward_xp,
                    'reward_gems'    => $ach->reward_gems,
                ]);
            }
        }

        // Simpan update XP & gems kalau ada
        if ($newlyEarned->isNotEmpty()) {
            $user->save();
            LevelService::recalculate($user);

            // Kirim notifikasi untuk setiap achievement baru
            foreach ($newlyEarned as $earned) {
                NotificationHelper::achievementNotification($user, $earned['title']);
            }
        }

        return $newlyEarned;
    }

    /**
     * Hitung nilai saat ini dari user untuk condition_type tertentu.
     */
    private function getCurrentValue(User $user, string $conditionType): int
    {
        return match ($conditionType) {
            'total_xp'            => $user->total_xp,
            'streak_days'         => $user->current_streak,
            'quiz_completed'      => UserQuizAttempt::where('user_id', $user->id)
                                        ->where('is_passed', true)
                                        ->distinct('quiz_id')
                                        ->count('quiz_id'),
            'writing_mastered'    => UserWritingProgress::where('user_id', $user->id)
                                        ->where('status', 'mastered')
                                        ->count(),
            'shadowing_completed' => UserShadowingAttempt::where('user_id', $user->id)
                                        ->distinct('shadowing_id')
                                        ->count('shadowing_id'),
            'followers_count'     => Follow::where('following_id', $user->id)->count(),
            default               => 0,
        };
    }

    /**
     * Hitung progress user menuju achievement (current / target).
     */
    private function getProgress(User $user, Achievement $ach): array
    {
        $current = $this->getCurrentValue($user, $ach->condition_type);
        $target  = $ach->condition_value;

        return [
            'current'    => min($current, $target),
            'target'     => $target,
            'percentage' => $target > 0 ? min(round(($current / $target) * 100), 100) : 0,
        ];
    }
}
