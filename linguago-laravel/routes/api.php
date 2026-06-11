<?php

use App\Http\Controllers\Api\AchievementController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ChatController;
use App\Http\Controllers\Api\CourseController;
use App\Http\Controllers\Api\FollowController;
use App\Http\Controllers\Api\LeaderboardController;
use App\Http\Controllers\Api\MapNodeController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\QuizAttemptController;
use App\Http\Controllers\Api\StreakController;
use App\Http\Controllers\Api\VideoLessonController;
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

    // Streak feature
    Route::get('/streak', [StreakController::class, 'getStreak']);
    Route::post('/streak/checkin', [StreakController::class, 'checkIn']);
    Route::get('/streak/history', [StreakController::class, 'getHistory']);
    Route::get('/streak/stats', [StreakController::class, 'getStats']);

    // Achievement & Badge feature
    Route::get('/achievements', [AchievementController::class, 'index']);
    Route::get('/achievements/earned', [AchievementController::class, 'earned']);
    Route::post('/achievements/check', [AchievementController::class, 'checkAndAward']);
    Route::get('/achievements/{achievementId}', [AchievementController::class, 'show']);

    // Leaderboard feature      
    Route::get('/leaderboard/public', [LeaderboardController::class, 'publicBoard']);
    Route::get('/leaderboard/friends', [LeaderboardController::class, 'friendsBoard']);
    Route::get('/leaderboard/level', [LeaderboardController::class, 'levelBoard']);

    // Video Lesson feature
    Route::get('/video-lessons', [VideoLessonController::class, 'index']);
    Route::get('/video-lessons/{id}', [VideoLessonController::class, 'show']);
    Route::post('/video-lessons/{id}/progress', [VideoLessonController::class, 'updateProgress']);

    // Level Map feature
    Route::get('/courses/{id}/level-map', [CourseController::class, 'levelMap']);
    Route::post('/map-nodes/{id}/complete', [MapNodeController::class, 'completeNode']);

    // Profile feature
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::put('/profile', [ProfileController::class, 'update']);
    Route::post('/profile/avatar', [ProfileController::class, 'uploadAvatar']);
    Route::delete('/profile/avatar', [ProfileController::class, 'deleteAvatar']);
    Route::post('/profile/password', [ProfileController::class, 'updatePassword']);

    // Chat feature
    Route::get('/conversations', [ChatController::class, 'index']);
    Route::post('/conversations', [ChatController::class, 'store']);
    Route::get('/conversations/{id}', [ChatController::class, 'show']);
    Route::get('/conversations/{id}/messages', [ChatController::class, 'messages']);
    Route::post('/conversations/{id}/messages', [ChatController::class, 'sendMessage']);

    // Notification feature
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);
    Route::put('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
    Route::put('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);
    Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);
    Route::delete('/notifications', [NotificationController::class, 'destroyAll']);
});

//course
Route::apiResource('courses', CourseController::class)->only(['index', 'show']);