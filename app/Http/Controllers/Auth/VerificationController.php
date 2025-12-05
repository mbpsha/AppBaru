<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Auth\Events\Verified;
use Illuminate\Foundation\Auth\EmailVerificationRequest;
use Illuminate\Http\Request;
use Inertia\Inertia;

class VerificationController extends Controller
{
    /**
     * Show the email verification notice page
     */
    public function notice(Request $request)
    {
        // If already verified, redirect to dashboard
        if ($request->user()->hasVerifiedEmail()) {
            return redirect()->route('dashboard')->with('message', 'Email Anda sudah terverifikasi.');
        }

        return Inertia::render('Auth/VerifyEmail');
    }

    /**
     * Handle email verification
     */
    public function verify(EmailVerificationRequest $request)
    {
        if ($request->user()->hasVerifiedEmail()) {
            return redirect()->route('dashboard')->with('message', 'Email sudah terverifikasi sebelumnya.');
        }

        if ($request->user()->markEmailAsVerified()) {
            event(new Verified($request->user()));
        }

        return redirect()->route('dashboard')->with('message', 'Email berhasil diverifikasi! Selamat datang di NGUNDUR.');
    }

    /**
     * Resend verification email
     */
    public function resend(Request $request)
    {
        if ($request->user()->hasVerifiedEmail()) {
            return back()->with('message', 'Email Anda sudah terverifikasi.');
        }

        $request->user()->sendEmailVerificationNotification();

        return back()->with('message', 'Link verifikasi baru telah dikirim ke email Anda!');
    }
}
