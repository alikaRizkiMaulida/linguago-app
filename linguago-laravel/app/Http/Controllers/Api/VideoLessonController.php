<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Api\AchievementController;
use App\Models\VideoLesson;
use App\Models\UserVideoProgress;
use App\Models\Map_Node;
use App\Models\UserNodeProgress;
use App\Models\StreakLog;
use App\Models\User;
use App\Models\XpLog;
use App\Services\LevelService;
use Carbon\Carbon;
use Illuminate\Http\Request;

class VideoLessonController extends Controller
{
    /**
     * Get all video lessons with authenticated user's progress.
     * GET /api/video-lessons
     */
    public function index(Request $request)
    {
        $user = $request->user();

        $lessons = VideoLesson::with(['nodeVideo'])->get()->map(function ($lesson) use ($user) {
            $progress = UserVideoProgress::where('user_id', $user->id)
                ->where('video_id', $lesson->id)
                ->first();

            return [
                'id'               => $lesson->id,
                'node_id'          => $lesson->node_id,
                'title'            => $lesson->title,
                'video_url'        => $lesson->video_url,
                'thumbnail_url'    => $lesson->thumbnail_url,
                'duration_seconds' => $lesson->duration_seconds,
                'progress'         => $progress ? [
                    'watched_seconds' => $progress->watched_seconds,
                    'is_completed'    => (bool) $progress->is_completed,
                    'completed_at'    => $progress->completed_at,
                ] : [
                    'watched_seconds' => 0,
                    'is_completed'    => false,
                    'completed_at'    => null,
                ]
            ];
        });

        return response()->json([
            'status'  => 'success',
            'message' => 'Daftar video materi berhasil diambil',
            'data'    => $lessons,
        ], 200);
    }

    /**
     * Get detail of a single video lesson with user progress.
     * GET /api/video-lessons/{id}
     */
    public function show(Request $request, $id)
    {
        $user = $request->user();
        $lesson = VideoLesson::with(['nodeVideo'])->find($id);

        if (!$lesson) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Video materi tidak ditemukan',
            ], 404);
        }

        $progress = UserVideoProgress::where('user_id', $user->id)
            ->where('video_id', $lesson->id)
            ->first();

        return response()->json([
            'status' => 'success',
            'data'   => [
                'id'               => $lesson->id,
                'node_id'          => $lesson->node_id,
                'title'            => $lesson->title,
                'video_url'        => $lesson->video_url,
                'thumbnail_url'    => $lesson->thumbnail_url,
                'duration_seconds' => $lesson->duration_seconds,
                'progress'         => $progress ? [
                    'watched_seconds' => $progress->watched_seconds,
                    'is_completed'    => (bool) $progress->is_completed,
                    'completed_at'    => $progress->completed_at,
                ] : [
                    'watched_seconds' => 0,
                    'is_completed'    => false,
                    'completed_at'    => null,
                ]
            ]
        ], 200);
    }

    /**
     * Update watched progress and handle completion rewards/unlocks.
     * POST /api/video-lessons/{id}/progress
     */
    public function updateProgress(Request $request, $id)
    {
        $request->validate([
            'watched_seconds' => 'required|integer|min:0',
            'is_completed'    => 'nullable|boolean',
        ]);

        $user = $request->user();
        $lesson = VideoLesson::find($id);

        if (!$lesson) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Video materi tidak ditemukan',
            ], 404);
        }

        // Ambil atau buat record progress untuk video ini
        $progress = UserVideoProgress::firstOrCreate(
            [
                'user_id'  => $user->id,
                'video_id' => $lesson->id,
            ],
            [
                'watched_seconds' => 0,
                'is_completed'    => false,
            ]
        );

        $wasAlreadyCompleted = $progress->is_completed;
        $watchedSeconds = $request->watched_seconds;

        // Validasi agar watched_seconds tidak melampaui durasi video
        if ($lesson->duration_seconds > 0 && $watchedSeconds > $lesson->duration_seconds) {
            $watchedSeconds = $lesson->duration_seconds;
        }

        $progress->watched_seconds = $watchedSeconds;

        // Cek kondisi selesai:
        // 1. Dikirim langsung dari request: is_completed == true
        // 2. Durasi terpenuhi (minimal 90% durasi ditonton sebagai toleransi / fallback)
        $shouldMarkCompleted = $request->input('is_completed', false) || 
            ($lesson->duration_seconds > 0 && $watchedSeconds >= ($lesson->duration_seconds * 0.9));

        $xpEarned = 0;
        $gemsEarned = 0;
        $newlyEarnedAchievements = [];

        if ($shouldMarkCompleted && !$wasAlreadyCompleted) {
            $progress->is_completed = true;
            $progress->completed_at = Carbon::now();

            // Selesaikan Node terkait di Level Map
            $currentNode = Map_Node::find($lesson->node_id);
            if ($currentNode) {
                $xpEarned = $currentNode->reward_xp > 0 ? $currentNode->reward_xp : 10;
                $gemsEarned = $currentNode->reward_gems > 0 ? $currentNode->reward_gems : 0;

                // 1. Simpan progress node menjadi completed
                UserNodeProgress::updateOrCreate(
                    [
                        'user_id' => $user->id,
                        'node_id' => $currentNode->id,
                    ],
                    [
                        'status'       => 'completed',
                        'xp_earned'    => $xpEarned,
                        'completed_at' => Carbon::now(),
                    ]
                );

                // 2. Unlock Node berikutnya
                $nextNode = Map_Node::where('required_node_id', $currentNode->id)->first();
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
            } else {
                $xpEarned = 10; // Default XP
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
                'source_type' => 'video',
                'source_id'   => $progress->id,
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

        $progress->save();

        return response()->json([
            'status'  => 'success',
            'message' => 'Progres menonton berhasil diperbarui',
            'data'    => [
                'watched_seconds'           => $progress->watched_seconds,
                'is_completed'              => (bool) $progress->is_completed,
                'completed_at'              => $progress->completed_at,
                'xp_earned'                 => $xpEarned,
                'gems_earned'               => $gemsEarned,
                'newly_earned_achievements' => $newlyEarnedAchievements,
            ]
        ], 200);
    }

    /**
     * Update streak harian user (sama dengan QuizAttemptController).
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
