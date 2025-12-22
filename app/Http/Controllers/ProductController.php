<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Http\Requests\ProductRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class ProductController extends Controller
{
    // Public API methods
    public function index(Request $request)
    {
        // If it's an API request, return JSON
        if ($request->expectsJson() || $request->is('api/*')) {
            $products = Product::all()->map(function ($product) {
                // Extract filename from path (e.g., "products/product_123.png" -> "product_123.png")
                $filename = basename($product->gambar ?? '');
                $apiImageUrl = $filename ? url('/api/images/products/' . $filename) : null;

                return [
                    'id_produk' => $product->id_produk,
                    'nama_produk' => $product->nama_produk,
                    'deskripsi' => $product->deskripsi,
                    'harga' => $product->harga,
                    'stok' => $product->stok,
                    'gambar' => $product->gambar,
                    'gambar_url' => $apiImageUrl, // Use API route with CORS
                    'created_at' => $product->created_at,
                    'updated_at' => $product->updated_at,
                ];
            });

            return response()->json([
                'data' => $products
            ]);
        }

        // Otherwise return Inertia for web
        return Inertia::render('User/ProductList', [
            'products' => Product::all()
        ]);
    }

    public function show(Request $request, $id_produk)
    {
        $product = Product::with(['reviews.user'])
            ->where('id_produk', $id_produk)
            ->firstOrFail();

        $reviews = $product->reviews
            ->sortByDesc('created_at')
            ->map(fn($r) => [
                'id' => $r->id,
                'nama' => $r->user->name ?? 'Pengguna',
                'tanggal' => $r->created_at?->format('j F Y'),
                'rating' => (int) $r->rating,
                'isi' => $r->body ?? $r->komentar ?? '',
            ])->values();

        // If it's an API request, return JSON
        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'data' => [
                    'id_produk' => $product->id_produk,
                    'nama_produk' => $product->nama_produk,
                    'deskripsi' => $product->deskripsi,
                    'harga' => (int) $product->harga,
                    'stok' => (int) $product->stok,
                    'gambar' => $product->gambar,
                    'reviews' => $reviews,
                ]
            ]);
        }

        return Inertia::render('User/ProductDetail', [
            'product' => [
                'id_produk' => $product->id_produk,
                'nama_produk' => $product->nama_produk,
                'deskripsi' => $product->deskripsi,
                'harga' => (int) $product->harga,
                'stok' => (int) $product->stok,
                'gambar' => $product->gambar,
            ],
            'reviews' => $reviews,
        ]);
    }

    // Halaman Toko (User)
    public function shop()
    {
        $products = Product::select('id_produk', 'nama_produk', 'deskripsi', 'harga', 'stok', 'kategori', 'gambar')
            ->latest()
            ->paginate(12)
            ->withQueryString();

        return Inertia::render('User/Toko', [
            'products' => $products
        ]);
    }

    // Admin methods
    public function indexAdmin()
    {
        $products = Product::latest()->paginate(10);

        return Inertia::render('Admin/ProductsManagement', [
            'products' => $products
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/ProductsManagement');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_produk' => 'required|string|max:255',
            'deskripsi' => 'required|string',
            'harga' => 'required|numeric|min:0',
            'stok' => 'required|integer|min:0',
            'gambar' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:10240'
        ]);

        // Handle image upload
        if ($request->hasFile('gambar')) {
            $imagePath = $request->file('gambar')->store('products', 'public');
            $validated['gambar'] = '/storage/' . $imagePath;
        }

        Product::create($validated);

        return redirect()->back()->with('success', 'Product created successfully!');
    }

    public function edit($id)
    {
        $product = Product::findOrFail($id);
        return Inertia::render('Admin/ProductsManagement', [
            'product' => $product
        ]);
    }

    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        $validated = $request->validate([
            'nama_produk' => 'required|string|max:255',
            'deskripsi' => 'required|string',
            'harga' => 'required|numeric|min:0',
            'stok' => 'required|integer|min:0',
            'gambar' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:10240'
        ]);

        // Handle image upload
        if ($request->hasFile('gambar')) {
            // Delete old image if exists
            if ($product->gambar) {
                $oldPath = str_replace('/storage/', '', $product->gambar);
                Storage::disk('public')->delete($oldPath);
            }

            $imagePath = $request->file('gambar')->store('products', 'public');
            $validated['gambar'] = '/storage/' . $imagePath;
        } else {
            unset($validated['gambar']);
        }

        $product->update($validated);

        return redirect()->back()->with('success', 'Product updated successfully!');
    }

    public function destroy($id)
    {
        $product = Product::findOrFail($id);

        // Delete image if exists
        if ($product->gambar) {
            $imagePath = str_replace('/storage/', '', $product->gambar);
            Storage::disk('public')->delete($imagePath);
        }

        $product->delete();

        return redirect()->back()->with('success', 'Product deleted successfully!');
    }
}
