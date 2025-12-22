<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\News;
use Illuminate\Http\Request;

class NewsController extends Controller
{
    public function index(Request $request)
    {
        $newsItems = News::orderBy('created_at', 'desc')->paginate(20);

        if ($request->expectsJson() || $request->is('api/*')) {
            // Map news items to include image_url
            $newsData = $newsItems->getCollection()->map(function ($news) {
                // Extract filename from path (e.g., "news/news_123.png" -> "news_123.png")
                $filename = basename($news->image ?? '');
                $apiImageUrl = $filename ? url('/api/images/news/' . $filename) : null;

                return [
                    'id' => $news->id,
                    'id_berita' => $news->id, // For backward compatibility
                    'title' => $news->title,
                    'judul' => $news->title, // For backward compatibility
                    'excerpt' => $news->excerpt,
                    'content' => $news->content,
                    'image' => $news->image,
                    'image_url' => $apiImageUrl, // Use API route with CORS
                    'is_published' => $news->is_published,
                    'status' => $news->is_published ? 'Published' : 'Draft',
                    'created_at' => $news->created_at,
                    'updated_at' => $news->updated_at,
                ];
            });

            return response()->json([
                'data' => $newsData
            ]);
        }

        return inertia('Admin/News/Index', [
            'news' => $newsItems
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
