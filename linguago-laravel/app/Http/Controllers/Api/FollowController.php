<?php

namespace App\Http\Controllers\Api;

use App\Helpers\NotificationHelper;
use App\Http\Controllers\Controller;
use App\Models\Follow;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class FollowController extends Controller
{
    /**
     * Follow a user.
     * POST /api/follow/{userId}
     */
    public function follow(Request $request, $userId)
    {
        $authUser = $request->user();

        // Tidak bisa follow diri sendiri
        if ($authUser->id == $userId) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Kamu tidak bisa follow diri sendiri',
            ], 400);
        }

        // Cek apakah user yang mau di-follow ada
        $targetUser = User::find($userId);
        if (!$targetUser) {
            return response()->json([
                'status'  => 'error',
                'message' => 'User tidak ditemukan',
            ], 404);
        }

        // Cek apakah sudah follow
        $exists = Follow::where('follower_id', $authUser->id)
                        ->where('following_id', $userId)
                        ->exists();

        if ($exists) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Kamu sudah follow user ini',
            ], 409);
        }

        // Buat relasi follow
        Follow::create([
            'follower_id'  => $authUser->id,
            'following_id' => $userId,
            'followed_at'  => Carbon::now(),
        ]);

        // Kirim notifikasi
        NotificationHelper::followNotification($authUser, $targetUser);

        return response()->json([
            'status'  => 'success',
            'message' => 'Berhasil follow ' . $targetUser->name,
            'data'    => [
                'followers_count' => $targetUser->followers()->count(),
                'following_count' => $targetUser->following()->count(),
            ],
        ], 201);
    }

    /**
     * Unfollow a user.
     * DELETE /api/unfollow/{userId}
     */
    public function unfollow(Request $request, $userId)
    {
        $authUser = $request->user();

        $follow = Follow::where('follower_id', $authUser->id)
                        ->where('following_id', $userId)
                        ->first();

        if (!$follow) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Kamu belum follow user ini',
            ], 404);
        }

        $follow->delete();

        $targetUser = User::find($userId);

        return response()->json([
            'status'  => 'success',
            'message' => 'Berhasil unfollow ' . ($targetUser ? $targetUser->name : 'user'),
            'data'    => [
                'followers_count' => $targetUser ? $targetUser->followers()->count() : 0,
                'following_count' => $targetUser ? $targetUser->following()->count() : 0,
            ],
        ], 200);
    }

    /**
     * Toggle follow (follow jika belum, unfollow jika sudah).
     * POST /api/follow-toggle/{userId}
     */
    public function toggleFollow(Request $request, $userId)
    {
        $authUser = $request->user();

        if ($authUser->id == $userId) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Kamu tidak bisa follow diri sendiri',
            ], 400);
        }

        $targetUser = User::find($userId);
        if (!$targetUser) {
            return response()->json([
                'status'  => 'error',
                'message' => 'User tidak ditemukan',
            ], 404);
        }

        $follow = Follow::where('follower_id', $authUser->id)
                        ->where('following_id', $userId)
                        ->first();

        if ($follow) {
            // Sudah follow → unfollow
            $follow->delete();
            $isFollowing = false;
            $message = 'Berhasil unfollow ' . $targetUser->name;
        } else {
            // Belum follow → follow
            Follow::create([
                'follower_id'  => $authUser->id,
                'following_id' => $userId,
                'followed_at'  => Carbon::now(),
            ]);

            // Kirim notifikasi
            NotificationHelper::followNotification($authUser, $targetUser);

            $isFollowing = true;
            $message = 'Berhasil follow ' . $targetUser->name;
        }

        return response()->json([
            'status'       => 'success',
            'message'      => $message,
            'is_following' => $isFollowing,
            'data'         => [
                'followers_count' => $targetUser->followers()->count(),
                'following_count' => $targetUser->following()->count(),
            ],
        ], 200);
    }

    /**
     * Cek apakah auth user sudah follow user tertentu.
     * GET /api/follow-status/{userId}
     */
    public function checkFollowStatus(Request $request, $userId)
    {
        $authUser = $request->user();

        $isFollowing = Follow::where('follower_id', $authUser->id)
                             ->where('following_id', $userId)
                             ->exists();

        return response()->json([
            'status'       => 'success',
            'is_following' => $isFollowing,
        ], 200);
    }

    /**
     * Daftar followers dari user tertentu.
     * GET /api/users/{userId}/followers
     */
    public function getFollowers(Request $request, $userId)
    {
        $user = User::find($userId);
        if (!$user) {
            return response()->json([
                'status'  => 'error',
                'message' => 'User tidak ditemukan',
            ], 404);
        }

        $authUser = $request->user();

        $followers = $user->followers()
            ->select('users.id', 'users.username', 'users.name', 'users.avatar_url', 'users.level', 'users.total_xp')
            ->get()
            ->map(function ($follower) use ($authUser) {
                $follower->is_followed_by_me = $authUser
                    ? Follow::where('follower_id', $authUser->id)
                            ->where('following_id', $follower->id)
                            ->exists()
                    : false;
                return $follower;
            });

        return response()->json([
            'status' => 'success',
            'data'   => [
                'followers_count' => $followers->count(),
                'followers'       => $followers,
            ],
        ], 200);
    }

    /**
     * Daftar following dari user tertentu.
     * GET /api/users/{userId}/following
     */
    public function getFollowing(Request $request, $userId)
    {
        $user = User::find($userId);
        if (!$user) {
            return response()->json([
                'status'  => 'error',
                'message' => 'User tidak ditemukan',
            ], 404);
        }

        $authUser = $request->user();

        $following = $user->following()
            ->select('users.id', 'users.username', 'users.name', 'users.avatar_url', 'users.level', 'users.total_xp')
            ->get()
            ->map(function ($followed) use ($authUser) {
                $followed->is_followed_by_me = $authUser
                    ? Follow::where('follower_id', $authUser->id)
                            ->where('following_id', $followed->id)
                            ->exists()
                    : false;
                return $followed;
            });

        return response()->json([
            'status' => 'success',
            'data'   => [
                'following_count' => $following->count(),
                'following'       => $following,
            ],
        ], 200);
    }

    /**
     * Followers & following count dari user tertentu.
     * GET /api/users/{userId}/follow-counts
     */
    public function getFollowCounts($userId)
    {
        $user = User::find($userId);
        if (!$user) {
            return response()->json([
                'status'  => 'error',
                'message' => 'User tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data'   => [
                'followers_count' => $user->followers()->count(),
                'following_count' => $user->following()->count(),
            ],
        ], 200);
    }

    /**
     * Cari user berdasarkan username/name untuk di-follow.
     * GET /api/users/search?q=keyword
     */
    public function searchUsers(Request $request)
    {
        $query = $request->query('q', '');
        $authUser = $request->user();

        if (strlen($query) < 2) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Kata kunci pencarian minimal 2 karakter',
            ], 400);
        }

        $users = User::where('id', '!=', $authUser->id)
            ->where(function ($q) use ($query) {
                $q->where('username', 'LIKE', "%{$query}%")
                  ->orWhere('name', 'LIKE', "%{$query}%");
            })
            ->select('id', 'username', 'name', 'avatar_url', 'level', 'total_xp')
            ->limit(20)
            ->get()
            ->map(function ($user) use ($authUser) {
                $user->is_followed_by_me = Follow::where('follower_id', $authUser->id)
                                                 ->where('following_id', $user->id)
                                                 ->exists();
                return $user;
            });

        return response()->json([
            'status' => 'success',
            'data'   => $users,
        ], 200);
    }
}
