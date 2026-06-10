<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Api\AchievementController;
use App\Models\Map_Node;
use App\Models\QuestionOptions;
use App\Models\Questions;
use App\Models\Quizzes;
use App\Models\StreakLog;
use App\Models\User;
use App\Models\UserAnswer;
use App\Models\UserNodeProgress;
use App\Models\UserQuizAttempt;
use App\Models\XpLog;
use App\Services\LevelService;
use Carbon\Carbon;
use Illuminate\Http\Request;

class QuizAttemptController extends Controller
{
    /**
     * Ambil data quiz lengkap dengan soal & pilihan jawaban.
     * GET /api/quiz/{quizId}
     */
    public function getQuiz(Request $request, $quizId)
    {
        $quiz = Quizzes::with(['questions' => function ($q) {
            $q->orderBy('soft_order', 'asc');
        }, 'questions.options' => function ($q) {
            $q->orderBy('soft_order', 'asc');
        }, 'mapNode'])->find($quizId);

        if (!$quiz) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Quiz tidak ditemukan',
            ], 404);
        }

        $userId = $request->user()->id;

        // Cek status node: apakah user sudah unlock node ini?
        $nodeProgress = UserNodeProgress::where('user_id', $userId)
            ->where('node_id', $quiz->node_id)
            ->first();

        // Hitung jumlah attempt sebelumnya
        $attemptCount = UserQuizAttempt::where('user_id', $userId)
            ->where('quiz_id', $quizId)
            ->count();

        // Best attempt (skor tertinggi)
        $bestAttempt = UserQuizAttempt::where('user_id', $userId)
            ->where('quiz_id', $quizId)
            ->orderByDesc('score')
            ->first();

        return response()->json([
            'status' => 'success',
            'data'   => [
                'quiz' => [
                    'id'            => $quiz->id,
                    'node_id'       => $quiz->node_id,
                    'title'         => $quiz->title,
                    'passing_score' => $quiz->passing_score,
                    'node_title'    => $quiz->mapNode ? $quiz->mapNode->title : null,
                ],
                'questions' => $quiz->questions->map(function ($question) {
                    return [
                        'id'                 => $question->id,
                        'question_text'      => $question->question_text,
                        'question_image_url' => $question->question_image_url,
                        'question_audio_url' => $question->question_audio_url,
                        'points'             => $question->points,
                        'options'            => $question->options->map(function ($opt) {
                            return [
                                'id'          => $opt->id,
                                'option_text' => $opt->option_text,
                                'sort_order'  => $opt->soft_order,
                            ];
                        }),
                    ];
                }),
                'total_questions' => $quiz->questions->count(),
                'node_status'     => $nodeProgress ? $nodeProgress->status : 'locked',
                'attempt_count'   => $attemptCount,
                'best_score'      => $bestAttempt ? $bestAttempt->score : null,
                'best_stars'      => $bestAttempt ? $bestAttempt->stars : null,
            ],
        ], 200);
    }

    /**
     * Submit jawaban quiz.
     * POST /api/quiz/submit
     */
    public function submitQuiz(Request $request)
    {
        // 1. Validasi request dari frontend
        $request->validate([
            'quiz_id'                      => 'required|exists:quizzes,id',
            'answers'                      => 'required|array',
            'answers.*.question_id'        => 'required|exists:questions,id',
            'answers.*.selected_option_id' => 'nullable|exists:question_options,id',
            'started_at'                   => 'required|date',
        ]);

        // Ambil user_id dari auth sanctum
        $userId = $request->user()->id;

        $quizId         = $request->quiz_id;
        $quiz           = Quizzes::findOrFail($quizId);
        $totalQuestions  = Questions::where('quiz_id', $quizId)->count();

        // 2. Inisialisasi hitungan awal
        $correctCount  = 0;
        $wrongCount    = 0;
        $answersToSave = [];

        // 3. Loop untuk cek jawaban user satu per satu
        foreach ($request->answers as $userAns) {
            $isCorrect = false;

            if (!empty($userAns['selected_option_id'])) {
                // Cek ke tabel question_options apakah option ini benar (is_correct == 1)
                $option = QuestionOptions::where('id', $userAns['selected_option_id'])
                    ->where('question_id', $userAns['question_id'])
                    ->first();

                if ($option && $option->is_correct) {
                    $isCorrect = true;
                    $correctCount++;
                } else {
                    $wrongCount++;
                }
            } else {
                // Jika user mengosongkan/skip jawaban
                $wrongCount++;
            }

            // Tampung dulu data jawaban buat disimpan nanti
            $answersToSave[] = [
                'question_id'        => $userAns['question_id'],
                'selected_option_id' => $userAns['selected_option_id'] ?? null,
                'is_correct'         => $isCorrect,
                'created_at'         => Carbon::now(),
                'updated_at'         => Carbon::now(),
            ];
        }

        // Antisipasi kalau total_questions di DB 0 biar gak error divide by zero
        $score = $totalQuestions > 0 ? round(($correctCount / $totalQuestions) * 100) : 0;

        // 4. Logika Hitung Bintang (Stars) ala Game Gamifikasi
        $stars = 0;
        if ($score == 100) {
            $stars = 3;
        } elseif ($score >= 85) {
            $stars = 2;
        } elseif ($score >= $quiz->passing_score) {
            $stars = 1;
        }

        // Cek kelulusan berdasarkan passing_score dari quiz
        $isPassed = $score >= $quiz->passing_score;

        // Hitung XP berdasarkan performa
        $xpEarned = 0;
        if ($isPassed) {
            $currentNode = Map_Node::find($quiz->node_id);
            $xpEarned = $currentNode ? $currentNode->reward_xp : 10;

            // Bonus XP untuk skor sempurna
            if ($score == 100) {
                $xpEarned += 20;
            }
        }

        // 5. Simpan data ke tabel user_quiz_attempts
        $attempt = UserQuizAttempt::create([
            'user_id'       => $userId,
            'quiz_id'       => $quizId,
            'score'         => $score,
            'stars'         => $stars,
            'correct_count' => $correctCount,
            'wrong_count'   => $wrongCount,
            'xp_earned'     => $xpEarned,
            'is_passed'     => $isPassed,
            'started_at'    => Carbon::parse($request->started_at),
            'finished_at'   => Carbon::now(),
        ]);

        // 6. Simpan semua jawaban detail ke tabel user_answers sekaligus
        foreach ($answersToSave as $key => $ans) {
            $answersToSave[$key]['attempt_id'] = $attempt->id;
        }
        UserAnswer::insert($answersToSave);

        // 7. Logika setelah lulus: unlock node, update XP, streak
        if ($isPassed) {
            $currentNodeId = $quiz->node_id;

            // a. Set Node saat ini jadi 'completed'
            UserNodeProgress::updateOrCreate(
                [
                    'user_id' => $userId,
                    'node_id' => $currentNodeId,
                ],
                [
                    'status'       => 'completed',
                    'score'        => $score,
                    'stars'        => $stars,
                    'xp_earned'    => $xpEarned,
                    'completed_at' => Carbon::now(),
                ]
            );

            // b. Cari & buka Node selanjutnya
            $nextNode = Map_Node::where('required_node_id', $currentNodeId)->first();
            if ($nextNode) {
                UserNodeProgress::updateOrCreate(
                    [
                        'user_id' => $userId,
                        'node_id' => $nextNode->id,
                    ],
                    [
                        'status' => 'unlocked',
                    ]
                );
            }

            // c. Update total_xp & gems di tabel users
            $user = User::find($userId);
            $user->total_xp += $xpEarned;

            // Tambah gems dari node reward
            $currentNode = Map_Node::find($currentNodeId);
            if ($currentNode && $currentNode->reward_gems > 0) {
                $user->gems += $currentNode->reward_gems;
            }

            $user->save();
            LevelService::recalculate($user);

            // d. Catat XP ke xp_logs
            XpLog::create([
                'user_id'     => $userId,
                'source_type' => 'quiz',
                'source_id'   => $attempt->id,
                'xp_amount'   => $xpEarned,
            ]);

            // e. Update streak log hari ini
            $today = Carbon::today()->toDateString();
            $streakLog = StreakLog::updateOrCreate(
                [
                    'user_id'       => $userId,
                    'activity_date' => $today,
                ],
                [
                    'has_learned' => true,
                ]
            );
            $streakLog->increment('xp_earned_day', $xpEarned);

            // f. Update streak di user
            $this->updateStreak($user);

            // g. Cek achievement baru
            $achievementController = new AchievementController();
            $newlyEarnedAchievements = $achievementController->evaluateAchievements($user);
        }

        // 8. Return JSON response yang informatif untuk frontend
        return response()->json([
            'status'  => 'success',
            'message' => $isPassed
                ? 'Selamat! Kamu lulus kuis!'
                : 'Yah, skor kamu belum cukup. Coba lagi yuk!',
            'data' => [
                'attempt_id'      => $attempt->id,
                'score'           => $score,
                'stars'           => $stars,
                'correct_count'   => $correctCount,
                'wrong_count'     => $wrongCount,
                'total_questions' => $totalQuestions,
                'xp_earned'       => $xpEarned,
                'is_passed'       => $isPassed,
                'newly_earned_achievements' => $isPassed ? ($newlyEarnedAchievements ?? []) : [],
            ],
        ], 200);
    }

    /**
     * Riwayat semua attempt quiz oleh user yang login.
     * GET /api/quiz/{quizId}/attempts
     */
    public function getAttemptHistory(Request $request, $quizId)
    {
        $userId = $request->user()->id;

        $quiz = Quizzes::find($quizId);
        if (!$quiz) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Quiz tidak ditemukan',
            ], 404);
        }

        $attempts = UserQuizAttempt::where('user_id', $userId)
            ->where('quiz_id', $quizId)
            ->orderByDesc('created_at')
            ->get()
            ->map(function ($attempt) {
                return [
                    'attempt_id'    => $attempt->id,
                    'score'         => $attempt->score,
                    'stars'         => $attempt->stars,
                    'correct_count' => $attempt->correct_count,
                    'wrong_count'   => $attempt->wrong_count,
                    'xp_earned'     => $attempt->xp_earned,
                    'is_passed'     => $attempt->is_passed,
                    'started_at'    => $attempt->started_at,
                    'finished_at'   => $attempt->finished_at,
                ];
            });

        return response()->json([
            'status' => 'success',
            'data'   => [
                'quiz_id'        => $quiz->id,
                'quiz_title'     => $quiz->title,
                'passing_score'  => $quiz->passing_score,
                'total_attempts' => $attempts->count(),
                'attempts'       => $attempts,
            ],
        ], 200);
    }

    /**
     * Detail review satu attempt (jawaban benar/salah per soal).
     * GET /api/quiz/attempts/{attemptId}/review
     */
    public function getAttemptReview(Request $request, $attemptId)
    {
        $userId = $request->user()->id;

        $attempt = UserQuizAttempt::with(['answers.question', 'answers.selectedOption', 'quiz'])
            ->where('id', $attemptId)
            ->where('user_id', $userId)
            ->first();

        if (!$attempt) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Attempt tidak ditemukan',
            ], 404);
        }

        $reviewAnswers = $attempt->answers->map(function ($answer) {
            $question    = $answer->question;
            // Ambil jawaban yang benar
            $correctOption = QuestionOptions::where('question_id', $question->id)
                ->where('is_correct', true)
                ->first();

            return [
                'question_id'        => $question->id,
                'question_text'      => $question->question_text,
                'question_image_url' => $question->question_image_url,
                'question_audio_url' => $question->question_audio_url,
                'explanation'        => $question->explanation,
                'selected_option'    => $answer->selectedOption ? [
                    'id'   => $answer->selectedOption->id,
                    'text' => $answer->selectedOption->option_text,
                ] : null,
                'correct_option' => $correctOption ? [
                    'id'   => $correctOption->id,
                    'text' => $correctOption->option_text,
                ] : null,
                'is_correct' => $answer->is_correct,
            ];
        });

        return response()->json([
            'status' => 'success',
            'data'   => [
                'attempt' => [
                    'id'            => $attempt->id,
                    'quiz_id'       => $attempt->quiz_id,
                    'quiz_title'    => $attempt->quiz->title,
                    'score'         => $attempt->score,
                    'stars'         => $attempt->stars,
                    'correct_count' => $attempt->correct_count,
                    'wrong_count'   => $attempt->wrong_count,
                    'xp_earned'     => $attempt->xp_earned,
                    'is_passed'     => $attempt->is_passed,
                    'started_at'    => $attempt->started_at,
                    'finished_at'   => $attempt->finished_at,
                ],
                'answers' => $reviewAnswers,
            ],
        ], 200);
    }

    /**
     * Update streak harian user.
     */
    private function updateStreak(User $user): void
    {
        $today     = Carbon::today();
        $yesterday = Carbon::yesterday();

        // Cek apakah kemarin ada aktivitas belajar
        $learnedYesterday = StreakLog::where('user_id', $user->id)
            ->where('activity_date', $yesterday->toDateString())
            ->where('has_learned', true)
            ->exists();

        if ($learnedYesterday) {
            // Lanjutkan streak
            $user->current_streak += 1;
        } else {
            // Cek hari ini sudah terhitung belum
            $alreadyCountedToday = $user->current_streak > 0
                && StreakLog::where('user_id', $user->id)
                    ->where('activity_date', $today->toDateString())
                    ->where('has_learned', true)
                    ->exists();

            if (!$alreadyCountedToday) {
                // Reset streak ke 1 (hari ini mulai baru)
                $user->current_streak = 1;
            }
        }

        // Update longest streak kalau lebih panjang
        if ($user->current_streak > $user->longest_streak) {
            $user->longest_streak = $user->current_streak;
        }

        $user->save();
    }
}