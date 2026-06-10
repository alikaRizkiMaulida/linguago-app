<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Course;
use App\Models\Map_Node;
use App\Models\UserNodeProgress;
use Illuminate\Http\Request;

class CourseController extends Controller
{
    public function index()
    {
        // Mengambil semua course beserta relasinya (Eager Loading)
        $courses = Course::with([
            'chapters.mapNodes.videoLesson',
            'chapters.mapNodes.quizzes.questions.options',
        ])->get();

        if (! $courses) {
            return response()->json([
                'success' => false,
                'message' => 'Course tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'List Data Materi Berhasil Diambil',
            'data'    => $courses,
        ], 200);
    }

    public function show($id)
    {
        $course = Course::with([
            'chapters.mapNodes.videoLesson',
            'chapters.mapNodes.quizzes.questions.options',
        ])->find($id);

        if (! $course) {
            return response()->json([
                'success' => false,
                'message' => ' detail Course tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data'    => $course,
        ], 200);
    }

    public function levelMap(Request $request, $id)
    {
        $user = $request->user();

        // Load fun facts data
        $funFacts = [];
        $funFactFile = database_path('data/fun_fact.json');
        if (file_exists($funFactFile)) {
            $funFacts = json_decode(file_get_contents($funFactFile), true);
        }

        // Load the course with its chapters and map nodes
        $course = Course::with([
            'chapters' => function ($query) {
                $query->orderBy('chapter_number', 'asc');
            },
            'chapters.mapNodes' => function ($query) {
                $query->orderBy('node_number', 'asc');
            },
            'chapters.mapNodes.videoLesson',
            'chapters.mapNodes.quizzes'
        ])->find($id);

        if (!$course) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Course tidak ditemukan',
            ], 404);
        }

        // For each map node, resolve the user's progress dynamically
        foreach ($course->chapters as $chapter) {
            foreach ($chapter->mapNodes as $node) {
                // Find user progress
                $progress = UserNodeProgress::where('user_id', $user->id)
                    ->where('node_id', $node->id)
                    ->first();

                if ($progress) {
                    $node->user_progress = [
                        'status'       => $progress->status,
                        'score'        => $progress->score,
                        'stars'        => $progress->stars,
                        'xp_earned'    => $progress->xp_earned,
                        'completed_at' => $progress->completed_at,
                    ];
                } else {
                    // Resolve dynamically
                    $status = 'locked';
                    if (is_null($node->required_node_id)) {
                        // The very first node is unlocked
                        $status = 'unlocked';
                    } else {
                        // Check if the prerequisite node is completed
                        $reqProgress = UserNodeProgress::where('user_id', $user->id)
                            ->where('node_id', $node->required_node_id)
                            ->first();
                        if ($reqProgress && $reqProgress->status === 'completed') {
                            $status = 'unlocked';
                        }
                    }

                    $node->user_progress = [
                        'status'       => $status,
                        'score'        => null,
                        'stars'        => null,
                        'xp_earned'    => null,
                        'completed_at' => null,
                    ];
                }

                // Add quiz detail if present
                $quiz = $node->quizzes->first();
                if ($quiz) {
                    $node->quiz_details = [
                        'id'            => $quiz->id,
                        'title'         => $quiz->title,
                        'passing_score' => $quiz->passing_score,
                        'questions_count' => $quiz->questions()->count(),
                    ];
                } else {
                    $node->quiz_details = null;
                }

                // Load fun fact cards if type is fun_fact
                $node->fun_fact_cards = null;
                if ($node->node_type === 'fun_fact') {
                    foreach ($funFacts as $factGroup) {
                        if ($factGroup['node_title'] === $node->title) {
                            $node->fun_fact_cards = $factGroup['cards'];
                            break;
                        }
                    }
                }

                // Unset the full quizzes relation to keep payload clean
                unset($node->quizzes);
            }
        }

        return response()->json([
            'status' => 'success',
            'data'   => [
                'course' => [
                    'id'           => $course->id,
                    'course_title' => $course->course_title,
                    'language'     => $course->language,
                    'description'  => $course->description,
                ],
                'user' => [
                    'total_xp'       => $user->total_xp,
                    'gems'           => $user->gems,
                    'current_streak' => $user->current_streak,
                ],
                'chapters' => $course->chapters->map(function ($chapter) {
                    return [
                        'id'             => $chapter->id,
                        'chapter_number' => $chapter->chapter_number,
                        'chapter_title'  => $chapter->chapter_title,
                        'description'    => $chapter->description,
                        'nodes'          => $chapter->mapNodes->map(function ($node) {
                            return [
                                'id'               => $node->id,
                                'node_number'      => $node->node_number,
                                'title'            => $node->title,
                                'description'      => $node->description,
                                'node_type'        => $node->node_type,
                                'position_x'       => $node->position_x,
                                'position_y'       => $node->position_y,
                                'reward_xp'        => $node->reward_xp,
                                'reward_gems'      => $node->reward_gems,
                                'is_boss_node'     => (bool)$node->is_boss_node,
                                'required_node_id' => $node->required_node_id,
                                'user_progress'    => $node->user_progress,
                                'video_lesson'     => $node->videoLesson ? [
                                    'id'               => $node->videoLesson->id,
                                    'title'            => $node->videoLesson->title,
                                    'video_url'        => $node->videoLesson->video_url,
                                    'thumbnail_url'    => $node->videoLesson->thumbnail_url,
                                    'duration_seconds' => $node->videoLesson->duration_seconds,
                                ] : null,
                                'quiz'             => $node->quiz_details,
                                'fun_fact'         => $node->fun_fact_cards,
                            ];
                        }),
                    ];
                }),
            ],
        ], 200);
    }

    public function store(Request $request)
    {

    }

    public function update(Request $request, $id)
    {

    }

    public function destroy($id)
    {

    }
}