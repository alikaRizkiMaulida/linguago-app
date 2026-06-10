<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Follow;
use App\Models\User;
use App\Models\XpLog;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LeaderboardController extends Controller
{
    /**
     * Leaderboard publik — semua user, diurutkan berdasarkan total_xp.
     * GET /api/leaderboard/public?period=all_time|weekly|monthly&limit=50
     */
    public function publicBoard(Request $request)
    {
        $user   = $request->user();
        $period = $request->query('period', 'all_time');
        $limit  = min((int) $request->query('limit', 50), 100);

        if ($period === 'all_time') {
            return $this->allTimePublic($user, $limit);
        }

        return $this->periodPublic($user, $period, $limit);
    }

    /**
     * Leaderboard pertemanan — hanya user yang saling follow (mutual).
     * GET /api/leaderboard/friends?period=all_time|weekly|monthly&limit=50
     */
    /**
     * Leaderboard berdasarkan level (desc) + XP (desc).
     * GET /api/leaderboard/level?limit=50
     */
    public function levelBoard(Request $request)
    {
        $user  = $request->user();
        $limit = min((int) $request->query('limit', 50), 100);

        $users = User::select('id', 'username', 'name', 'avatar_url', 'total_xp', 'level')
            ->orderByDesc('level')
            ->orderByDesc('total_xp')
            ->limit($limit)
            ->get();

        $rankings = $this->buildLevelRankings($users, $user);

        $myRank = User::where('level', '>', $user->level)
            ->orWhere(function ($q) use ($user) {
                $q->where('level', $user->level)
                  ->where('total_xp', '>', $user->total_xp);
            })
            ->count() + 1;

        return response()->json([
            'status' => 'success',
            'data'   => [
                'type'       => 'level',
                'my_rank'    => $myRank,
                'my_level'   => $user->level,
                'my_xp'      => $user->total_xp,
                'rankings'   => $rankings,
            ],
        ], 200);
    }

    public function friendsBoard(Request $request)
    {
        $user   = $request->user();
        $period = $request->query('period', 'all_time');
        $limit  = min((int) $request->query('limit', 50), 100);

        // Cari mutual friends: user A follow B DAN B follow A
        $mutualIds = $this->getMutualFriendIds($user->id);

        // Sertakan diri sendiri di leaderboard
        $mutualIds[] = $user->id;

        if ($period === 'all_time') {
            return $this->allTimeFriends($user, $mutualIds, $limit);
        }

        return $this->periodFriends($user, $mutualIds, $period, $limit);
    }

    // ================================================================
    //  ALL-TIME leaderboards (berdasarkan users.total_xp)
    // ================================================================

    private function allTimePublic(User $authUser, int $limit)
    {
        $users = User::select('id', 'username', 'name', 'avatar_url', 'total_xp', 'level')
            ->orderByDesc('total_xp')
            ->limit($limit)
            ->get();

        $rankings = $this->buildRankings($users, $authUser);
        $myRank   = $this->getMyAllTimeRank($authUser);

        return response()->json([
            'status' => 'success',
            'data'   => [
                'type'     => 'public',
                'period'   => 'all_time',
                'my_rank'  => $myRank,
                'my_xp'    => $authUser->total_xp,
                'rankings' => $rankings,
            ],
        ], 200);
    }

    private function allTimeFriends(User $authUser, array $friendIds, int $limit)
    {
        $users = User::select('id', 'username', 'name', 'avatar_url', 'total_xp', 'level')
            ->whereIn('id', $friendIds)
            ->orderByDesc('total_xp')
            ->limit($limit)
            ->get();

        $rankings = $this->buildRankings($users, $authUser);

        // Rank auth user di antara teman
        $myRank = $rankings->firstWhere('is_me', true);

        return response()->json([
            'status' => 'success',
            'data'   => [
                'type'          => 'friends',
                'period'        => 'all_time',
                'my_rank'       => $myRank ? $myRank['rank'] : null,
                'my_xp'         => $authUser->total_xp,
                'total_friends' => count($friendIds) - 1, // exclude self
                'rankings'      => $rankings,
            ],
        ], 200);
    }

    // ================================================================
    //  PERIOD leaderboards (weekly / monthly — berdasarkan xp_logs)
    // ================================================================

    private function periodPublic(User $authUser, string $period, int $limit)
    {
        [$startDate, $endDate] = $this->getPeriodRange($period);

        $rankings = $this->getXpRankings(null, $startDate, $endDate, $limit, $authUser);
        $myXp     = $this->getMyPeriodXp($authUser->id, $startDate, $endDate);
        $myRank   = $this->getMyPeriodRank($authUser->id, null, $startDate, $endDate);

        return response()->json([
            'status' => 'success',
            'data'   => [
                'type'       => 'public',
                'period'     => $period,
                'start_date' => $startDate,
                'end_date'   => $endDate,
                'my_rank'    => $myRank,
                'my_xp'      => $myXp,
                'rankings'   => $rankings,
            ],
        ], 200);
    }

    private function periodFriends(User $authUser, array $friendIds, string $period, int $limit)
    {
        [$startDate, $endDate] = $this->getPeriodRange($period);

        $rankings = $this->getXpRankings($friendIds, $startDate, $endDate, $limit, $authUser);
        $myXp     = $this->getMyPeriodXp($authUser->id, $startDate, $endDate);
        $myRank   = $this->getMyPeriodRank($authUser->id, $friendIds, $startDate, $endDate);

        return response()->json([
            'status' => 'success',
            'data'   => [
                'type'          => 'friends',
                'period'        => $period,
                'start_date'    => $startDate,
                'end_date'      => $endDate,
                'my_rank'       => $myRank,
                'my_xp'         => $myXp,
                'total_friends' => count($friendIds) - 1,
                'rankings'      => $rankings,
            ],
        ], 200);
    }

    // ================================================================
    //  Helper methods
    // ================================================================

    /**
     * Ambil ID user yang saling follow (mutual follow).
     */
    private function getMutualFriendIds(int $userId): array
    {
        // A follows B
        $followingIds = Follow::where('follower_id', $userId)->pluck('following_id');

        // B juga follows A (mutual)
        $mutualIds = Follow::where('following_id', $userId)
            ->whereIn('follower_id', $followingIds)
            ->pluck('follower_id')
            ->toArray();

        return $mutualIds;
    }

    /**
     * Build rankings array with rank number and is_me flag.
     */
    private function buildRankings($users, User $authUser)
    {
        $rank = 0;
        $prevXp = null;

        return $users->map(function ($u) use ($authUser, &$rank, &$prevXp) {
            // Same XP = same rank
            if ($u->total_xp !== $prevXp) {
                $rank++;
            }
            $prevXp = $u->total_xp;

            return [
                'rank'       => $rank,
                'user_id'    => $u->id,
                'username'   => $u->username,
                'name'       => $u->name,
                'avatar_url' => $u->avatar_url,
                'total_xp'   => $u->total_xp,
                'level'      => $u->level,
                'is_me'      => $u->id === $authUser->id,
            ];
        });
    }

    /**
     * Build level rankings with rank number and is_me flag.
     */
    private function buildLevelRankings($users, User $authUser)
    {
        $rank = 0;
        $prevLevel = null;
        $prevXp = null;

        return $users->map(function ($u) use ($authUser, &$rank, &$prevLevel, &$prevXp) {
            if ($u->level !== $prevLevel || $u->total_xp !== $prevXp) {
                $rank++;
            }
            $prevLevel = $u->level;
            $prevXp = $u->total_xp;

            return [
                'rank'       => $rank,
                'user_id'    => $u->id,
                'username'   => $u->username,
                'name'       => $u->name,
                'avatar_url' => $u->avatar_url,
                'level'      => $u->level,
                'total_xp'   => $u->total_xp,
                'is_me'      => $u->id === $authUser->id,
            ];
        });
    }

    /**
     * Get period date range.
     */
    private function getPeriodRange(string $period): array
    {
        $now = Carbon::now();

        return match ($period) {
            'weekly'  => [
                $now->copy()->startOfWeek(Carbon::MONDAY)->toDateTimeString(),
                $now->copy()->endOfWeek(Carbon::SUNDAY)->toDateTimeString(),
            ],
            'monthly' => [
                $now->copy()->startOfMonth()->toDateTimeString(),
                $now->copy()->endOfMonth()->toDateTimeString(),
            ],
            default   => [
                '1970-01-01 00:00:00',
                $now->toDateTimeString(),
            ],
        };
    }

    /**
     * Get XP rankings from xp_logs within a period.
     * If $userIds is null → all users (public). Otherwise filter by IDs.
     */
    private function getXpRankings(?array $userIds, string $startDate, string $endDate, int $limit, User $authUser)
    {
        $query = XpLog::select('xp_logs.user_id', DB::raw('SUM(xp_logs.xp_amount) as period_xp'))
            ->whereBetween('xp_logs.created_at', [$startDate, $endDate]);

        if ($userIds !== null) {
            $query->whereIn('xp_logs.user_id', $userIds);
        }

        $results = $query
            ->groupBy('xp_logs.user_id')
            ->orderByDesc('period_xp')
            ->limit($limit)
            ->get();

        // Load user info
        $userMap = User::whereIn('id', $results->pluck('user_id'))
            ->select('id', 'username', 'name', 'avatar_url', 'level')
            ->get()
            ->keyBy('id');

        $rank = 0;
        $prevXp = null;

        return $results->map(function ($row) use ($authUser, $userMap, &$rank, &$prevXp) {
            $u = $userMap->get($row->user_id);

            if ((int) $row->period_xp !== $prevXp) {
                $rank++;
            }
            $prevXp = (int) $row->period_xp;

            return [
                'rank'       => $rank,
                'user_id'    => $row->user_id,
                'username'   => $u ? $u->username : null,
                'name'       => $u ? $u->name : null,
                'avatar_url' => $u ? $u->avatar_url : null,
                'level'      => $u ? $u->level : null,
                'period_xp'  => (int) $row->period_xp,
                'is_me'      => $row->user_id === $authUser->id,
            ];
        });
    }

    /**
     * Get auth user's total XP within a period.
     */
    private function getMyPeriodXp(int $userId, string $startDate, string $endDate): int
    {
        return (int) XpLog::where('user_id', $userId)
            ->whereBetween('created_at', [$startDate, $endDate])
            ->sum('xp_amount');
    }

    /**
     * Get auth user's rank within a period.
     */
    private function getMyPeriodRank(int $userId, ?array $userIds, string $startDate, string $endDate): ?int
    {
        $myXp = $this->getMyPeriodXp($userId, $startDate, $endDate);

        $query = XpLog::select('user_id', DB::raw('SUM(xp_amount) as total'))
            ->whereBetween('created_at', [$startDate, $endDate]);

        if ($userIds !== null) {
            $query->whereIn('user_id', $userIds);
        }

        $higherCount = $query
            ->groupBy('user_id')
            ->havingRaw('SUM(xp_amount) > ?', [$myXp])
            ->get()
            ->count();

        return $higherCount + 1;
    }

    /**
     * Get auth user's all-time global rank (by total_xp).
     */
    private function getMyAllTimeRank(User $user): int
    {
        $higherCount = User::where('total_xp', '>', $user->total_xp)->count();
        return $higherCount + 1;
    }
}
