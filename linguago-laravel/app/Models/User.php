<?php
namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

#[Fillable([
        'username',
        'email',
        'password',
        'name',
        'avatar_url',
        'total_xp',
        'level',
        'current_streak',
        'longest_streak',
        'gems',
    ])]

#[Hidden([
        'password',
        'remember_token',
    ])]

class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password'          => 'hashed',
        ];
    }

    public function streakLogs()
    {
        return $this->hasMany(StreakLog::class);
    }

    public function shadowingAttempts()
    {
        return $this->hasMany(UserShadowingAttempt::class);
    }

    public function writingProgresses()
    {
        return $this->hasMany(UserWritingProgress::class);
    }

    public function achievements()
    {
        return $this->belongsToMany(Achievement::class, 'user_achievements', 'user_id', 'achievement_id')
                    ->withPivot('earned_at');
    }

    public function followers()
    {
        return $this->belongsToMany(User::class, 'follows', 'following_id', 'follower_id')
                    ->withPivot('followed_at');
    }

    public function following()
    {
        return $this->belongsToMany(User::class, 'follows', 'follower_id', 'following_id')
                    ->withPivot('followed_at');
    }

    public function xpLogs()
    {
        return $this->hasMany(XpLog::class);
    }

    public function nodeProgresses()
    {
        return $this->hasMany(UserNodeProgress::class);
    }

    public function videoProgresses()
    {
        return $this->hasMany(UserVideoProgress::class);
    }

    public function quizAttempts()
    {
        return $this->hasMany(UserQuizAttempt::class);
    }
}