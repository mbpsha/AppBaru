<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    protected $primaryKey = 'id_user';

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'nama',
        'username',
        'email',
        'no_telp',
        'alamat',
        'role',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    // Relations
    public function reviews()
    {
        return $this->hasMany(Review::class, 'id_user');
    }

    public function cart()
    {
        return $this->hasOne(Cart::class, 'id_user');
    }

    public function orders()
    {
        return $this->hasMany(Order::class, 'id_user');
    }

    public function addresses()
    {
        return $this->hasMany(Address::class, 'id_user', 'id_user');
    }

    public function defaultAddress()
    {
        return $this->hasOne(Address::class, 'id_user', 'id_user')
            ->where('is_default', true);
    }

    /**
     * Send the email verification notification using custom notification.
     *
     * @return void
     */
    public function sendEmailVerificationNotification()
    {
        $this->notify(new \App\Notifications\CustomVerifyEmail);
    }
}
