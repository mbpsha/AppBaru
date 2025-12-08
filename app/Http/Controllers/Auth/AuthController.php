<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Models\News;
use Inertia\Inertia;

class AuthController extends Controller
{
    public function showLogin()
    {
        return Inertia::render('Auth/Login');
    }

    public function showRegister()
    {
        return Inertia::render('Auth/Register', [
            'recaptchaSiteKey' => config('captcha.sitekey')
        ]);
    }

    public function login(Request $request)
    {
        $request->validate([
            'login' => 'required|string',
            'password' => 'required'
        ]);

        $loginField = $request->login;

        // Check if input is email or username
        $user = User::where('email', $loginField)
                   ->orWhere('username', $loginField)
                   ->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'login' => ['The provided credentials are incorrect.'],
            ]);
        }

        Auth::login($user);

        // Generate Sanctum token
        $token = $user->createToken('auth-token')->plainTextToken;
        $verified = $user->hasVerifiedEmail();

        // Return JSON with Sanctum token (untuk Postman & API)
        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'message' => 'Login successful!',
                'user' => $user,
                'token' => $token,
                'redirect' => $user->role === 'admin' ? route('admin.dashboard') : route('dashboard')
            ], 200);
        }

        // Web: Redirect based on user role
        if ($user->role === 'admin') {
            return redirect()->route('admin.dashboard')->with('message', 'Login successful!');
        }

        return redirect()->route('dashboard')->with('message', 'Login successful!');
    }

    public function register(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:255',
            'username' => 'required|string|max:255|unique:users',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'role' => 'nullable|in:admin,user'
        ]);

        $user = User::create([
            'nama' => $request->nama,
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role ?? 'user'
        ]);

        Auth::login($user);

        // Generate Sanctum token
        $token = $user->createToken('auth-token')->plainTextToken;

        // Return JSON with Sanctum token (untuk Postman & API)
        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'message' => 'Registrasi berhasil!',
                'user' => $user,
                'token' => $token,
                'redirect' => $user->role === 'admin' ? route('admin.dashboard') : route('dashboard')
            ], 200);
        }

        // Web: Redirect based on role
        if ($user->role === 'admin') {
            return redirect()->route('admin.dashboard')->with('message', 'Registrasi berhasil!');
        }

        return redirect()->route('dashboard')->with('message', 'Registrasi berhasil!');
    }

    public function logout(Request $request)
    {
        $user = $request->user();

        // Revoke all Sanctum tokens
        if ($user) {
            $user->tokens()->delete();
        }

        // Only invalidate session if it exists (for web requests)
        if ($request->hasSession()) {
            $request->session()->invalidate();
            $request->session()->regenerateToken();
        }

        // Return JSON for API (Postman)
        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'message' => 'Logout successful!'
            ], 200);
        }

        // Web: Redirect to dashboard
        return redirect()->route('dashboard');
    }

    // ============================================
    // API METHODS (Full Token-Based Authentication)
    // ============================================

    public function apiLogin(Request $request)
    {
        $request->validate([
            'login' => 'required|string',
            'password' => 'required'
        ]);

        $loginField = $request->login;

        // Check if input is email or username
        $user = User::where('email', $loginField)
                   ->orWhere('username', $loginField)
                   ->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'The provided credentials are incorrect.',
                'errors' => [
                    'login' => ['The provided credentials are incorrect.']
                ]
            ], 401);
        }

        // Login user to create session with remember token
        Auth::login($user, true);

        // Regenerate session to prevent session fixation
        $request->session()->regenerate();

        // Generate Sanctum token
        $token = $user->createToken('auth-token')->plainTextToken;
        $verified = $user->hasVerifiedEmail();

        return response()->json([
            'message' => 'Login successful!',
            'user' => $user,
            'token' => $token,
            'redirect' => $user->role === 'admin' ? '/admin/dashboard' : '/dashboard'
        ], 200);
    }

    public function apiRegister(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:255',
            'username' => 'required|string|max:255|unique:users',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'role' => 'nullable|in:admin,user'
        ]);

        $user = User::create([
            'nama' => $request->nama,
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role ?? 'user'
        ]);

        // Login user to create session with remember token
        Auth::login($user, true);

        // Regenerate session to prevent session fixation
        $request->session()->regenerate();

        // Generate Sanctum token
        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'Registrasi berhasil!',
            'user' => $user,
            'token' => $token,
            'redirect' => $user->role === 'admin' ? '/admin/dashboard' : '/dashboard'
        ], 201);
    }

    public function apiLogout(Request $request)
    {
        $user = $request->user();

        // Revoke all Sanctum tokens
        if ($user) {
            $user->tokens()->delete();
        }

        // Logout from session (important!)
        Auth::guard('web')->logout();

        // Invalidate session
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json([
            'message' => 'Logout successful!'
        ], 200);
    }

    public function blog()
    {
        return Inertia::render('User/Blog');
    }

    public function about()
    {
        return Inertia::render('User/About');
    }

    public function dashboard()
    {
        $latestNews = News::published()->latest()->take(5)->get();
        return Inertia::render('User/Dashboard', [
            'latestNews' => $latestNews
        ]);
    }

    public function berita()
    {
        $latestNews = News::published()->latest()->take(5)->get();
        return Inertia::render('User/Berita', [
            'latestNews' => $latestNews
        ]);
    }
}
