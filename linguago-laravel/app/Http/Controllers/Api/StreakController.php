<?php

namespace App\Http\Controllers\Api;

use App\Helpers\NotificationHelper;
use App\Http\Controllers\Controller;
use App\Models\StreakLog;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;

class StreakController extends Controller
{
    /**
     * Ambil data streak user yang sedang login.
     * GET /api/streak
     *
     * Response: current_streak, longest_streak, has_learned_today,
     *           xp_earned_today, calendar minggu ini.
     */
    public function getStreak(Request $request)
    {
        $user  = $request->user();
        $today = Carbon::today();

        // Recalculate streak (jaga-jaga kalau user tidak buka app sehari+)
        $this->recalculateStreak($user);

        // Cek log hari ini
        $todayLog = StreakLog::where('user_id', $user->id)
            ->where('activity_date', $today->toDateString())
            ->first();

        // Ambil data 7 hari terakhir untuk kalender streak
        $weekStart = $today->copy()->startOfWeek(Carbon::MONDAY);
        $weekEnd   = $today->copy()->endOfWeek(Carbon::SUNDAY);

        $weekLogs = StreakLog::where('user_id', $user->id)
            ->whereBetween('activity_date', [$weekStart->toDateString(), $weekEnd->toDateString()])
            ->orderBy('activity_date')
            ->get()
            ->keyBy('activity_date');

        $calendar = [];
        for ($date = $weekStart->copy(); $date->lte($weekEnd); $date->addDay()) {
            $dateStr = $date->toDateString();
            $log     = $weekLogs->get($dateStr);

            $calendar[] = [
                'date'         => $dateStr,
                'day_name'     => $date->translatedFormat('D'),
                'has_learned'  => $log ? (bool) $log->has_learned : false,
                'xp_earned'    => $log ? $log->xp_earned_day : 0,
                'is_today'     => $date->isToday(),
                'is_future'    => $date->isFuture(),
            ];
        }

        return response()->json([
            'status' => 'success',
            'data'   => [
                'current_streak'    => $user->current_streak,
                'longest_streak'    => $user->longest_streak,
                'has_learned_today' => $todayLog ? (bool) $todayLog->has_learned : false,
                'xp_earned_today'   => $todayLog ? $todayLog->xp_earned_day : 0,
                'calendar'          => $calendar,
            ],
        ], 200);
    }

    /**
     * Catat aktivitas belajar hari ini (dipanggil dari frontend
     * setiap kali user menyelesaikan suatu aktivitas belajar).
     * POST /api/streak/checkin
     *
     * Body (optional): { "xp_earned": 10 }
     */
    public function checkIn(Request $request)
    {
        $request->validate([
            'xp_earned' => 'nullable|integer|min:0',
        ]);

        $user     = $request->user();
        $today    = Carbon::today()->toDateString();
        $xpEarned = $request->input('xp_earned', 0);

        // Upsert streak log hari ini
        $streakLog = StreakLog::updateOrCreate(
            [
                'user_id'       => $user->id,
                'activity_date' => $today,
            ],
            [
                'has_learned' => true,
            ]
        );

        // Tambah XP harian
        if ($xpEarned > 0) {
            $streakLog->increment('xp_earned_day', $xpEarned);
        }

        // Update streak di user
        $oldStreak = $user->current_streak;
        $this->recalculateStreak($user);

        // Kirim notifikasi streak di milestone tertentu
        $milestones = [3, 7, 14, 21, 30, 60, 100, 365];
        if ($user->current_streak > $oldStreak && in_array($user->current_streak, $milestones)) {
            NotificationHelper::streakNotification($user, $user->current_streak);
        }

        // Kirim notifikasi daily reward
        if ($xpEarned > 0) {
            NotificationHelper::dailyRewardNotification($user, $xpEarned, 0);
        }

        return response()->json([
            'status'  => 'success',
            'message' => 'Check-in berhasil!',
            'data'    => [
                'current_streak'    => $user->current_streak,
                'longest_streak'    => $user->longest_streak,
                'has_learned_today' => true,
                'xp_earned_today'   => $streakLog->fresh()->xp_earned_day,
            ],
        ], 200);
    }

    /**
     * Riwayat streak log dalam rentang tanggal.
     * GET /api/streak/history?start_date=2026-05-01&end_date=2026-05-31
     *
     * Default: 30 hari terakhir.
     */
    public function getHistory(Request $request)
    {
        $request->validate([
            'start_date' => 'nullable|date',
            'end_date'   => 'nullable|date|after_or_equal:start_date',
        ]);

        $user      = $request->user();
        $endDate   = $request->input('end_date', Carbon::today()->toDateString());
        $startDate = $request->input('start_date', Carbon::parse($endDate)->subDays(29)->toDateString());

        $logs = StreakLog::where('user_id', $user->id)
            ->whereBetween('activity_date', [$startDate, $endDate])
            ->orderBy('activity_date', 'asc')
            ->get()
            ->map(function ($log) {
                return [
                    'date'        => $log->activity_date,
                    'has_learned' => (bool) $log->has_learned,
                    'xp_earned'   => $log->xp_earned_day,
                ];
            });

        // Hitung statistik
        $totalDaysLearned = $logs->where('has_learned', true)->count();
        $totalXp          = $logs->sum('xp_earned');

        return response()->json([
            'status' => 'success',
            'data'   => [
                'start_date'         => $startDate,
                'end_date'           => $endDate,
                'total_days_learned' => $totalDaysLearned,
                'total_xp'           => $totalXp,
                'current_streak'     => $user->current_streak,
                'longest_streak'     => $user->longest_streak,
                'logs'               => $logs,
            ],
        ], 200);
    }

    /**
     * Ambil ringkasan statistik streak untuk profil user.
     * GET /api/streak/stats
     */
    public function getStats(Request $request)
    {
        $user = $request->user();

        // Recalculate untuk memastikan akurat
        $this->recalculateStreak($user);

        // Total hari belajar sepanjang waktu
        $totalDaysLearned = StreakLog::where('user_id', $user->id)
            ->where('has_learned', true)
            ->count();

        // Total XP dari streak logs
        $totalXpFromLogs = StreakLog::where('user_id', $user->id)
            ->sum('xp_earned_day');

        // Rata-rata XP per hari belajar
        $avgXpPerDay = $totalDaysLearned > 0
            ? round($totalXpFromLogs / $totalDaysLearned)
            : 0;

        // Streak bulan ini
        $monthStart = Carbon::today()->startOfMonth()->toDateString();
        $monthEnd   = Carbon::today()->endOfMonth()->toDateString();
        $daysLearnedThisMonth = StreakLog::where('user_id', $user->id)
            ->where('has_learned', true)
            ->whereBetween('activity_date', [$monthStart, $monthEnd])
            ->count();

        // Streak minggu ini
        $weekStart = Carbon::today()->startOfWeek(Carbon::MONDAY)->toDateString();
        $weekEnd   = Carbon::today()->endOfWeek(Carbon::SUNDAY)->toDateString();
        $daysLearnedThisWeek = StreakLog::where('user_id', $user->id)
            ->where('has_learned', true)
            ->whereBetween('activity_date', [$weekStart, $weekEnd])
            ->count();

        return response()->json([
            'status' => 'success',
            'data'   => [
                'current_streak'          => $user->current_streak,
                'longest_streak'          => $user->longest_streak,
                'total_days_learned'      => $totalDaysLearned,
                'total_xp'               => $totalXpFromLogs,
                'avg_xp_per_day'         => $avgXpPerDay,
                'days_learned_this_week'  => $daysLearnedThisWeek,
                'days_learned_this_month' => $daysLearnedThisMonth,
            ],
        ], 200);
    }

    /**
     * Recalculate current_streak berdasarkan data aktual di streak_logs.
     * Menjaga akurasi streak meskipun user tidak buka app beberapa hari.
     */
    private function recalculateStreak(User $user): void
    {
        $today = Carbon::today();

        // Ambil log hari ini
        $todayLog = StreakLog::where('user_id', $user->id)
            ->where('activity_date', $today->toDateString())
            ->where('has_learned', true)
            ->exists();

        // Hitung streak mundur dari hari ini (atau kemarin kalau hari ini belum belajar)
        $checkDate = $todayLog ? $today->copy() : $today->copy()->subDay();
        $streak = 0;

        while (true) {
            $learned = StreakLog::where('user_id', $user->id)
                ->where('activity_date', $checkDate->toDateString())
                ->where('has_learned', true)
                ->exists();

            if ($learned) {
                $streak++;
                $checkDate->subDay();
            } else {
                break;
            }

            // Safety: jangan loop lebih dari 365 hari
            if ($streak > 365) {
                break;
            }
        }

        $user->current_streak = $streak;

        if ($streak > $user->longest_streak) {
            $user->longest_streak = $streak;
        }

        $user->save();
    }
}
