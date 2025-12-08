<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\News;
use Illuminate\Http\Request;

class NewsController extends Controller
{
    public function index(Request $request)
    {
        $news = News::orderBy('created_at', 'desc')->paginate(20);

        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'data' => $news
            ]);
        }

        return inertia('Admin/News/Index', [
            'news' => $news
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'excerpt' => 'nullable|string',
            'content' => 'required|string',
            'image' => 'nullable|string',
            'is_published' => 'nullable|boolean',
        ]);

        $news = News::create($validated);

        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'message' => 'News created successfully!',
                'data' => $news
            ], 201);
        }

        return redirect()->route('admin.news.index')->with('success', 'Berita berhasil ditambahkan!');
    }

    public function update(Request $request, News $news)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'excerpt' => 'nullable|string',
            'content' => 'required|string',
            'image' => 'nullable|string',
            'is_published' => 'nullable|boolean',
        ]);

        $news->update($validated);

        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'message' => 'News updated successfully!',
                'data' => $news->fresh()
            ]);
        }

        return redirect()->route('admin.news.index')->with('success', 'Berita berhasil diupdate!');
    }

    public function destroy(Request $request, News $news)
    {
        $news->delete();

        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'message' => 'News deleted successfully!'
            ]);
        }

        return redirect()->route('admin.news.index')->with('success', 'Berita berhasil dihapus!');
    }
}
