<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Map_Node;
use App\Models\QuestionOptions;
use App\Models\Questions;
use App\Models\Quizzes;
use App\Models\UserAnswer;
use App\Models\UserNodeProgress;
use App\Models\UserQuizAttempt;
use Carbon\Carbon;
use Illuminate\Http\Request;

class QuizAttemptController extends Controller
{
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

        // Simulasi user_id (Nanti kalau sudah pakai Auth/Sanctum, ganti jadi auth()->id())
        $userId = 1;

        $quizId         = $request->quiz_id;
        $quiz           = Quizzes::findOrFail($quizId);
        $totalQuestions = Questions::where('quiz_id', $quizId)->count();

        // 2. Inisialisasi hitungan awal
        $correctCount  = 0;
        $wrongCount    = 0;
        $answersToSave = [];

        // 3. Loop untuk cek jawaban user satu per satu
        foreach ($request->answers as $userAns) {
            $isCorrect = false;

            if (! empty($userAns['selected_option_id'])) {
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
                'selected_option_id' => $userAns['selected_option_id'],
                'is_correct'         => $isCorrect,
                'created_at'         => Carbon::now(),
                'updated_at'         => Carbon::now(),
            ];
        }

        // Antisipasi kalau total_questions di DB 0 biar gak error devide by zero
        $score = $totalQuestions > 0 ? round(($correctCount / $totalQuestions) * 100) : 0;

        // 4. Logika Hitung Bintang (Stars) ala Game Gamifikasi
        $stars = 0;
        if ($score == 100) {
            $stars = 3;
        } elseif ($score >= 85) {
            $stars = 2;
        } elseif ($score >= $quiz->passing_score) { // Passing score dari kuis (misal 80)
            $stars = 1;
        }

                                  // Cek kelulusan
        $isPassed = $score >= 80; // Default passing score 80

        // 5. Simpan data ke tabel user_quiz_attempts
        $attempt = UserQuizAttempt::create([
            'user_id'       => $userId,
            'quiz_id'       => $quizId,
            'score'         => $score,
            'stars'         => $stars,
            'correct_count' => $correctCount,
            'wrong_count'   => $wrongCount,
            'xp_earned'     => $isPassed ? 50 : 0, // Dapet 50 XP cuma kalau lulus
            'is_passed'     => $isPassed,
            'started_at'    => Carbon::parse($request->started_at),
            'finished_at'   => Carbon::now(),
        ]);

        // 6. Simpan semua jawaban detail ke tabel user_answers sekaligus
        foreach ($answersToSave as $key => $ans) {
            $answersToSave[$key]['attempt_id'] = $attempt->id;
        }
        UserAnswer::insert($answersToSave);

        // [LOGIKA UNLOCK NODE & REWARD - SUDAH DISINKRONKAN DENGAN MODEL AL]
        if ($isPassed) {
            $currentNodeId = $quiz->node_id;

            // 1. Set Node saat ini jadi 'completed' (Gunakan kolom-kolom sesuai modelmu)
            UserNodeProgress::updateOrCreate(
                [
                    'user_id' => $userId,
                    'node_id' => $currentNodeId,
                ],
                [
                    'status'       => 'completed',
                    'score'        => $score,
                    'stars'        => $stars,
                    'xp_earned'    => 50,            // Tambahkan XP-nya ke progress node
                    'completed_at' => Carbon::now(), // Sesuaikan pake completed_at!
                ]
            );

            // 2. Cari Node SELANJUTNYA
            $nextNode = Map_Node::where('required_node_id', $currentNodeId)->first();

            if ($nextNode) {
                // 3. Buka kunci Node berikutnya (Cukup set status 'unlocked')
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
        }

        // 7. Return JSON response yang informatif untuk frontend
        return response()->json([
            'success' => true,
            'message' => $isPassed ? 'Selamat! Kamu lulus kuis!' : 'Yah, skor kamu belum cukup. Coba lagi yuk!',
            'data'    => [
                'attempt_id'    => $attempt->id,
                'score'         => $score,
                'stars'         => $stars,
                'correct_count' => $correctCount,
                'wrong_count'   => $wrongCount,
                'xp_earned'     => $attempt->xp_earned,
                'is_passed'     => $isPassed,
            ],
        ], 200);
    }
}