<?php

namespace App\Helpers;

use App\Models\Notification;
use App\Models\User;

class NotificationHelper
{
    public static function send(User $user, string $type, string $title, ?string $body = null, ?array $data = null): Notification
    {
        return Notification::create([
            'user_id' => $user->id,
            'type'    => $type,
            'title'   => $title,
            'body'    => $body,
            'data'    => $data,
        ]);
    }

    public static function followNotification(User $follower, User $target): void
    {
        self::send(
            $target,
            'follow',
            'Pengikut Baru',
            $follower->name . ' mulai mengikuti kamu',
            ['follower_id' => $follower->id, 'follower_name' => $follower->name, 'follower_avatar' => $follower->avatar_url]
        );
    }

    public static function achievementNotification(User $user, string $achievementName): void
    {
        self::send(
            $user,
            'achievement',
            'Achievement Baru!',
            'Selamat! Kamu mendapatkan achievement "' . $achievementName . '"',
            ['achievement_name' => $achievementName]
        );
    }

    public static function streakNotification(User $user, int $streakCount): void
    {
        self::send(
            $user,
            'streak',
            'Streak ' . $streakCount . ' Hari!',
            'Kamu sudah aktif ' . $streakCount . ' hari berturut-turut. Pertahankan!',
            ['streak_count' => $streakCount]
        );
    }

    public static function chatNotification(User $receiver, User $sender, string $conversationId, string $messageContent): void
    {
        self::send(
            $receiver,
            'chat',
            'Pesan Baru dari ' . $sender->name,
            mb_substr($messageContent, 0, 100),
            ['sender_id' => $sender->id, 'sender_name' => $sender->name, 'conversation_id' => $conversationId]
        );
    }

    public static function dailyRewardNotification(User $user, int $xpReward, int $gemsReward): void
    {
        self::send(
            $user,
            'daily_reward',
            'Hadiah Harian!',
            'Kamu mendapatkan ' . $xpReward . ' XP dan ' . $gemsReward . ' gems',
            ['xp' => $xpReward, 'gems' => $gemsReward]
        );
    }
}
