<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Product extends Model
{
    use HasFactory;

    protected $primaryKey = 'id_produk';

    protected $fillable = [
        'nama_produk',
        'deskripsi',
        'harga',
        'gambar',
        'stok',
    ];

    protected $casts = [
        'harga' => 'decimal:2',
        'stok' => 'integer',
    ];

    // Mutator for base64 image upload
    public function setGambarAttribute($value)
    {
        if ($value && preg_match('/^data:image\/(\w+);base64,/', $value, $type)) {
            // Extract base64 string
            $data = substr($value, strpos($value, ',') + 1);
            $data = base64_decode($data);

            // Generate unique filename
            $extension = $type[1] ?? 'png';
            $filename = 'product_' . time() . '_' . uniqid() . '.' . $extension;
            $path = 'products/' . $filename;

            // Save to storage/app/public/products
            Storage::disk('public')->put($path, $data);

            $this->attributes['gambar'] = $path;
        } elseif (is_string($value)) {
            $this->attributes['gambar'] = $value;
        }
    }

    // Accessor to get full URL
    public function getGambarUrlAttribute()
    {
        if ($this->gambar) {
            return asset('storage/' . $this->gambar);
        }
        return null;
    }

    // Relations
    public function reviews()
    {
        return $this->hasMany(Review::class, 'id_produk');
    }

    public function cartDetails()
    {
        return $this->hasMany(CartDetail::class, 'id_produk');
    }

    public function orderDetails()
    {
        return $this->hasMany(OrderDetail::class, 'id_produk');
    }
}
