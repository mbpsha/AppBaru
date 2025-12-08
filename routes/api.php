<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Auth\AuthController;

// ============================================
// AUTH ROUTES (Sanctum Token Authentication)
// ============================================

// Guest Routes - Wrapped with session middleware for session creation
Route::middleware(['web'])->group(function () {
    Route::post('/register', [AuthController::class, 'apiRegister'])->name('api.register');
    Route::post('/login', [AuthController::class, 'apiLogin'])->name('api.login');

    // Public Product & News Routes (no auth required)
    Route::get('/products', [\App\Http\Controllers\ProductController::class, 'index'])->name('api.products.index');
    Route::get('/products/{id}', [\App\Http\Controllers\ProductController::class, 'show'])->name('api.products.show');
    Route::get('/news', [\App\Http\Controllers\NewsController::class, 'index'])->name('api.news.index');
    Route::get('/news/{id}', [\App\Http\Controllers\NewsController::class, 'show'])->name('api.news.show');
});

// Protected Routes (Sanctum Token Required) - Also need web middleware for session
Route::middleware(['web', 'auth:sanctum'])->group(function () {
    Route::post('/logout', [AuthController::class, 'apiLogout'])->name('api.logout');
    Route::get('/user', fn() => response()->json(request()->user()))->name('api.user');

    // Profile endpoints for API/Postman (returns JSON)
    Route::get('/profile', [\App\Http\Controllers\ProfileController::class, 'show'])->name('api.profile.show');
    Route::put('/profile', [\App\Http\Controllers\ProfileController::class, 'update'])->name('api.profile.update');

    // RajaOngkir Shipping Cost API
    Route::post('/rajaongkir/cost', function(\Illuminate\Http\Request $request) {
        $validated = $request->validate([
            'origin' => 'nullable|integer',
            'destination' => 'required|integer',
            'weight' => 'required|integer|min:1',
            'courier' => 'required|string|in:jne,pos,tiki,jnt,sicepat,anteraja',
        ]);

        Log::info('RajaOngkir API request', [
            'destination' => $validated['destination'],
            'weight' => $validated['weight'],
            'courier' => $validated['courier']
        ]);

        $rajaOngkir = app(\App\Services\RajaOngkirService::class);

        // Use the service's calculateCost method
        $result = $rajaOngkir->calculateCost(
            (int) $validated['destination'],
            (int) $validated['weight'],
            $validated['courier']
        );

        Log::info('RajaOngkir API result', ['result' => $result]);

        if (!$result) {
            Log::error('RajaOngkir calculateCost returned null', [
                'destination' => $validated['destination'],
                'weight' => $validated['weight'],
                'courier' => $validated['courier']
            ]);

            // Return fallback cost
            $fallbackCost = (int) config('rajaongkir.fallback_cost', 20000);
            return response()->json([
                'rajaongkir' => [
                    'status' => ['code' => 200, 'description' => 'OK (Fallback)'],
                    'results' => [[
                        'code' => strtoupper($validated['courier']),
                        'name' => strtoupper($validated['courier']),
                        'costs' => [[
                            'service' => 'REG',
                            'description' => 'Regular (Estimasi)',
                            'cost' => [[
                                'value' => $fallbackCost,
                                'etd' => '3-5',
                                'note' => 'Estimasi ongkir otomatis'
                            ]]
                        ]]
                    ]]
                ]
            ]);
        }

        // Format response to match expected structure
        return response()->json([
            'rajaongkir' => [
                'status' => ['code' => 200, 'description' => 'OK'],
                'results' => [[
                    'code' => $result['courier'],
                    'name' => strtoupper($result['courier']),
                    'costs' => [[
                        'service' => $result['service'],
                        'description' => $result['description'] ?? '',
                        'cost' => [[
                            'value' => $result['value'],
                            'etd' => $result['etd'],
                            'note' => ''
                        ]]
                    ]]
                ]]
            ]
        ]);
    })->name('api.rajaongkir.cost');

    // ============================================
    // USER ROUTES (Sanctum Token Required)
    // ============================================

    // Cart API - untuk Postman/Testing
    Route::get('/cart', [\App\Http\Controllers\CartController::class, 'index'])->name('api.cart.index');
    Route::post('/cart', [\App\Http\Controllers\CartController::class, 'add'])->name('api.cart.add');
    Route::put('/cart/detail/{id_detail_keranjang}', [\App\Http\Controllers\CartController::class, 'update'])->name('api.cart.update');
    Route::delete('/cart/detail/{id_detail_keranjang}', [\App\Http\Controllers\CartController::class, 'remove'])->name('api.cart.remove');

    // Checkout API - untuk Postman/Testing
    Route::get('/checkout/{id_produk}', [\App\Http\Controllers\CheckoutController::class, 'show'])->name('api.checkout.show');
    Route::get('/checkout/{id_produk}/address', [\App\Http\Controllers\CheckoutController::class, 'showAddressForm'])->name('api.checkout.address');
    Route::post('/checkout/{id_produk}/address', [\App\Http\Controllers\CheckoutController::class, 'saveAddress'])->name('api.checkout.address.save');

    // User Orders - API untuk Postman/Testing
    Route::post('/orders', [\App\Http\Controllers\OrderController::class, 'store'])->name('api.orders.store');
    Route::get('/orders', [\App\Http\Controllers\OrderController::class, 'index'])->name('api.orders.index');
    Route::get('/orders/{id}', [\App\Http\Controllers\OrderController::class, 'show'])->name('api.orders.show');

    // Payment Confirmation - API
    Route::post('/payments', [\App\Http\Controllers\PaymentController::class, 'store'])->name('api.payments.store');

    // ============================================
    // ADMIN ROUTES (Sanctum + Admin Role Check)
    // ============================================
    Route::middleware('role:admin')->group(function () {
        // Admin Order Management
        Route::get('/admin/orders', [\App\Http\Controllers\Admin\OrderController::class, 'index'])->name('api.admin.orders.index');
        Route::get('/admin/orders/{order}', [\App\Http\Controllers\Admin\OrderController::class, 'show'])->name('api.admin.orders.show');
        Route::put('/admin/orders/{order}/status', [\App\Http\Controllers\Admin\OrderController::class, 'updateStatus'])->name('api.admin.orders.updateStatus');

        // Admin Payment Verification
        Route::put('/admin/payments/{payment}/verify', [\App\Http\Controllers\Admin\PaymentController::class, 'verify'])->name('api.admin.payments.verify');

        // Admin Product Management
        Route::get('/admin/products', [\App\Http\Controllers\Admin\ProductController::class, 'index'])->name('api.admin.products.index');
        Route::get('/admin/products/create', [\App\Http\Controllers\Admin\ProductController::class, 'create'])->name('api.admin.products.create');
        Route::post('/admin/products', [\App\Http\Controllers\Admin\ProductController::class, 'store'])->name('api.admin.products.store');
        Route::put('/admin/products/{product}', [\App\Http\Controllers\Admin\ProductController::class, 'update'])->name('api.admin.products.update');
        Route::delete('/admin/products/{product}', [\App\Http\Controllers\Admin\ProductController::class, 'destroy'])->name('api.admin.products.destroy');

        // Admin News Management
        Route::get('/admin/news', [\App\Http\Controllers\Admin\NewsController::class, 'index'])->name('api.admin.news.index');
        Route::post('/admin/news', [\App\Http\Controllers\Admin\NewsController::class, 'store'])->name('api.admin.news.store');
        Route::put('/admin/news/{news}', [\App\Http\Controllers\Admin\NewsController::class, 'update'])->name('api.admin.news.update');
        Route::delete('/admin/news/{news}', [\App\Http\Controllers\Admin\NewsController::class, 'destroy'])->name('api.admin.news.destroy');

        // Admin Dashboard Statistics
        Route::get('/admin/dashboard/stats', function() {
            return response()->json([
                'total_products' => \App\Models\Product::count(),
                'total_orders' => \App\Models\Order::count(),
                'total_users' => \App\Models\User::where('role', 'user')->count(),
                'total_revenue' => \App\Models\Order::where('status', 'completed')->sum('total_harga'),
            ]);
        })->name('api.admin.dashboard.stats');
    });
});

