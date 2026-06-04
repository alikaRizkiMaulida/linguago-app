<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CourseController;
use App\Http\Controllers\Api\FollowController;
use App\Http\Controllers\Api\QuizAttemptController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

//auth user
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

//grouping auth sanctum
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    // Follow feature
    Route::post('/follow/{userId}', [FollowController::class, 'follow']);
    Route::delete('/unfollow/{userId}', [FollowController::class, 'unfollow']);
    Route::post('/follow-toggle/{userId}', [FollowController::class, 'toggleFollow']);
    Route::get('/follow-status/{userId}', [FollowController::class, 'checkFollowStatus']);
    Route::get('/users/{userId}/followers', [FollowController::class, 'getFollowers']);
    Route::get('/users/{userId}/following', [FollowController::class, 'getFollowing']);
    Route::get('/users/{userId}/follow-counts', [FollowController::class, 'getFollowCounts']);
    Route::get('/users/search', [FollowController::class, 'searchUsers']);

    // Quiz feature
    Route::get('/quiz/{quizId}', [QuizAttemptController::class, 'getQuiz']);
    Route::post('/quiz/submit', [QuizAttemptController::class, 'submitQuiz']);
    Route::get('/quiz/{quizId}/attempts', [QuizAttemptController::class, 'getAttemptHistory']);
    Route::get('/quiz/attempts/{attemptId}/review', [QuizAttemptController::class, 'getAttemptReview']);
});

//course
Route::apiResource('courses', CourseController::class)->only(['index', 'show']); 
