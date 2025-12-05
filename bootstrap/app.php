<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Support\Facades\Route;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
        // then: function () {
        //     Route::prefix('api')
        //         ->middleware('api')
        //         ->group(base_path('routes/auth.php'));
        // },
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->web(append: [
            \App\Http\Middleware\HandleInertiaRequests::class,
        ]);

        // Replace default CSRF middleware with custom one
        $middleware->validateCsrfTokens(except: [
            '/api/*', // Exclude all API routes from CSRF (using Bearer token instead)
            '/profile',
            '/cart',
            '/admin/orders/*/status',
            '/checkout/*/address',
            '/order/*/create',
        ]);

        $middleware->alias([
            'verified' => \App\Http\Middleware\EnsureEmailIsVerified::class,
            'admin' => \App\Http\Middleware\AdminMiddleware::class,
            'user.only' => \App\Http\Middleware\UserOnlyMiddleware::class,
            'role' => \App\Http\Middleware\CheckRole::class,
        ]);

        //
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })->create();
