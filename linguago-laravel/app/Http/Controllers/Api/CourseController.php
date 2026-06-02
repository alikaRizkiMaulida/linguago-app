<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Course;
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