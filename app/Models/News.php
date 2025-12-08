<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class News extends Model
{
    protected $table = 'news';

    protected $fillable = [
        'title',
        'excerpt',
        'content',
        'image',
        'is_published',
    ];

    protected $casts = [
        'is_published' => 'boolean',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    // Mutator for base64 image upload
    public function setImageAttribute($value)
    {
        if ($value && preg_match('/^data:image\/(\w+);base64,/', $value, $type)) {
            // Extract base64 string
            $data = substr($value, strpos($value, ',') + 1);
            $data = base64_decode($data);

            // Generate unique filename
            $extension = $type[1] ?? 'png';
            $filename = 'news_' . time() . '_' . uniqid() . '.' . $extension;
            $path = 'news/' . $filename;

            // Save to storage/app/public/news
            Storage::disk('public')->put($path, $data);

            $this->attributes['image'] = $path;
        } elseif (is_string($value)) {
            $this->attributes['image'] = $value;
        }
    }

    // Accessor to get full URL
    public function getImageUrlAttribute()
    {
        if ($this->image) {
            return asset('storage/' . $this->image);
        }
        return null;
    }

    // Scope untuk filter berita yang published
    public function scopePublished($query)
    {
        return $query->where('is_published', true);
    }

    // Scope untuk berita terbaru
    public function scopeLatest($query)
    {
        return $query->orderBy('created_at', 'desc');
    }
}
