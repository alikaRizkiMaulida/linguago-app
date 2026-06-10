<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Api\AchievementController;
use App\Models\Map_Node;
use App\Services\LevelService;
use App\Models\UserNodeProgress;
use App\Models\StreakLog;
use App\Models\User;
use App\Models\XpLog;
use Carbon\Carbon;
use Illuminate\Http\Request;

class MapNodeController extends Controller
{
    /**
     * Mark a map node as completed (generic for fun_fact or general nodes).
     * POST /api/map-nodes/{id}/complete
     */
    public function completeNode(Request $request, $id)
    {
        $user = $request->user();
        $node = Map_Node::find($id);

        if (!$node) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Node tidak ditemukan',
            ], 404);
        }

        // Cek progres sebelumnya
        $progress = UserNodeProgress::where('user_id', $user->id)
            ->where('node_id', $node->id)
            ->first();

        $wasAlreadyCompleted = $progress && $progress->status === 'completed';

        $xpEarned = 0;
        $gemsEarned = 0;
        $newlyEarnedAchievements = [];

        if (!$wasAlreadyCompleted) {
            $xpEarned = $node->reward_xp > 0 ? $node->reward_xp : 10;
            $gemsEarned = $node->reward_gems > 0 ? $node->reward_gems : 0;

            // 1. Simpan progress node menjadi completed
            $progress = UserNodeProgress::updateOrCreate(
                [
                    'user_id' => $user->id,
                    'node_id' => $node->id,
                ],
                [
                    'status'       => 'completed',
                    'xp_earned'    => $xpEarned,
                    'completed_at' => Carbon::now(),
                ]
            );

            // 2. Unlock Node berikutnya
            $nextNode = Map_Node::where('required_node_id', $node->id)->first();
            if ($nextNode) {
                UserNodeProgress::updateOrCreate(
                    [
                        'user_id' => $user->id,
                        'node_id' => $nextNode->id,
                    ],
                    [
                        'status' => 'unlocked',
                    ]
                );
            }

            // 3. Tambahkan XP dan Gems ke User
            $userModel = User::find($user->id);
            $userModel->total_xp += $xpEarned;
            if ($gemsEarned > 0) {
                $userModel->gems += $gemsEarned;
            }
            $userModel->save();
            LevelService::recalculate($userModel);

            // 4. Catat ke tabel xp_logs
            XpLog::create([
                'user_id'     => $user->id,
                'source_type' => 'node',
                'source_id'   => $node->id,
                'xp_amount'   => $xpEarned,
            ]);

            // 5. Update Streak harian
            $today = Carbon::today()->toDateString();
            $streakLog = StreakLog::updateOrCreate(
                [
                    'user_id'       => $user->id,
                    'activity_date' => $today,
                ],
                [
                    'has_learned' => true,
                ]
            );
            $streakLog->increment('xp_earned_day', $xpEarned);

            // Update streak di model user
            $this->updateStreak($userModel);

            // 6. Cek Achievements
            $achievementController = new AchievementController();
            $newlyEarnedAchievements = $achievementController->evaluateAchievements($userModel);
        }

        return response()->json([
            'status'  => 'success',
            'message' => 'Node berhasil diselesaikan!',
            'data'    => [
                'node_id'                   => $node->id,
                'status'                    => 'completed',
                'xp_earned'                 => $xpEarned,
                'gems_earned'               => $gemsEarned,
                'newly_earned_achievements' => $newlyEarnedAchievements,
            ]
        ], 200);
    }

    /**
     * Update streak harian user.
     */
    private function updateStreak(User $user): void
    {
        $today     = Carbon::today();
        $yesterday = Carbon::yesterday();

        $learnedYesterday = StreakLog::where('user_id', $user->id)
            ->where('activity_date', $yesterday->toDateString())
            ->where('has_learned', true)
            ->exists();

        if ($learnedYesterday) {
            $user->current_streak += 1;
        } else {
            $alreadyCountedToday = $user->current_streak > 0
                && StreakLog::where('user_id', $user->id)
                    ->where('activity_date', $today->toDateString())
                    ->where('has_learned', true)
                    ->exists();

            if (!$alreadyCountedToday) {
                $user->current_streak = 1;
            }
        }

        if ($user->current_streak > $user->longest_streak) {
            $user->longest_streak = $user->current_streak;
        }

        $user->save();
    }
}
