<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\News;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;

class NewsController extends Controller
{
    // Untuk User - Tampilkan berita yang published
    public function index(Request $request)
    {
        // If it's an API request, return JSON with all news
        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'data' => News::latest()->get()
            ]);
        }

        // Otherwise return Inertia for web with published news only
        $news = News::published()
            ->latest()
            ->paginate(4)
            ->withQueryString();

        return Inertia::render('User/Berita', [
            'news' => $news
        ]);
    }

    // Untuk Admin - Tampilkan semua berita
    public function indexAdmin()
    {
        $news = News::latest()->paginate(10);

        return Inertia::render('Admin/NewsManagement', [
            'news' => $news
        ]);
    }

    // Tampilkan detail berita
    public function show(Request $request, $id)
    {
        $article = News::findOrFail($id);

        // If it's an API request, return JSON
        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'data' => $article
            ]);
        }

        return Inertia::render('User/BeritaDetail', [
            'article' => $article
        ]);
    }

    // Form create
    public function create()
    {
        return Inertia::render('Admin/NewsManagement');
    }

    // Store berita baru
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'excerpt' => 'required|string|max:500',
            'content' => 'required|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:10240',
            'is_published' => 'boolean',
        ]);

        // Upload image kalau ada
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('news', 'public');
            $validated['image'] = $path;
        }

        News::create($validated);

        return redirect()->route('admin.news.index')->with('success', 'Berita berhasil ditambahkan!');
    }

    // Form edit
    public function edit($id)
    {
        $article = News::findOrFail($id);

        return Inertia::render('Admin/NewsEdit', [
            'article' => $article
        ]);
    }

    // Update berita
    public function update(Request $request, $id)
    {
        $article = News::findOrFail($id);

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'excerpt' => 'required|string|max:500',
            'content' => 'required|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:10240',
            'is_published' => 'boolean',
        ]);

        // Upload image baru kalau ada
        if ($request->hasFile('image')) {
            // Hapus gambar lama
            if ($article->image) {
                Storage::disk('public')->delete($article->image);
            }
            $path = $request->file('image')->store('news', 'public');
            $validated['image'] = $path;
        }

        $article->update($validated);

        return redirect()->route('admin.news.index')->with('success', 'Berita berhasil diupdate!');
    }

    // Delete berita
    public function destroy($id)
    {
        $article = News::findOrFail($id);

        // Hapus gambar kalau ada
        if ($article->image) {
            Storage::disk('public')->delete($article->image);
        }

        $article->delete();

        return redirect()->route('admin.news.index')->with('success', 'Berita berhasil dihapus!');
    }
}
