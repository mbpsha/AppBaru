<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head, router } from '@inertiajs/vue3'
import { computed } from 'vue'

const props = defineProps({
  product: { type: Object, required: true },
  reviews: { type: Array, default: () => [] }
})

const fmt = (n) => new Intl.NumberFormat('id-ID',{style:'currency',currency:'IDR',maximumFractionDigits:0}).format(n)

function addToCart() {
  router.post(route('cart.add'), { id_produk: props.product.id_produk }, { preserveScroll: true })
}

const hasReviews = computed(() => props.reviews.length > 0)

function starsArray(rating) {
  return Array.from({ length: 5 }, (_, i) => i < rating)
}
</script>

<template>
  <div class="font-inter text-gray-900 bg-gray-50 min-h-screen">
    <Header />
    <Head :title="product.nama_produk" />

    <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 pt-24 pb-20">
      <!-- Tombol Kembali -->
      <div class="flex justify-end mb-4">
        <button
          @click="router.visit(route('shop'))"
          class="px-4 py-2 text-sm rounded-md bg-gray-200 hover:bg-gray-300 text-gray-700"
        >
          Kembali
        </button>
      </div>

      <div class="grid md:grid-cols-[340px_1fr] gap-10">
        <!-- Gambar -->
        <div class="rounded-xl bg-white p-6 shadow">
          <img
            :src="product.gambar || '/assets/dashboard/profil.png'"
            alt="Gambar Produk"
            class="w-full h-64 object-contain"
          />
        </div>

        <!-- Info Produk -->
        <div class="space-y-5">
          <h1 class="text-xl font-semibold leading-snug">
            {{ product.nama_produk }}
          </h1>

          <div class="space-y-2">
            <p class="text-2xl font-bold text-red-600">
              {{ fmt(product.harga) }}
            </p>
            <p class="text-sm text-gray-700">
              Stok: <span class="font-medium">{{ product.stok }}</span>
            </p>
            <p v-if="product.kategori" class="text-xs inline-block bg-green-100 text-green-700 px-3 py-1 rounded-full">
              {{ product.kategori }}
            </p>
            <p class="text-xs text-red-600 font-medium" v-if="product.stok === 0">
              Pre-Order estimasi 15 Hari
            </p>
          </div>

            <div class="flex gap-3">
              <button
                @click="addToCart"
                class="px-5 h-10 rounded-md bg-green-600 hover:bg-green-700 text-white text-sm flex items-center gap-2"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                Keranjang
              </button>

              <button
                class="px-5 h-10 rounded-md bg-green-100 hover:bg-green-200 text-green-700 text-sm font-medium"
                @click="router.visit(route('checkout.show', { id_produk: product.id_produk }) + '?qty=1')"
              >
                Beli Sekarang
              </button>
            </div>

          <!-- Deskripsi -->
          <section class="pt-4">
            <h2 class="text-sm font-semibold mb-2">Deskripsi Produk</h2>
            <div class="text-sm leading-relaxed text-gray-700 whitespace-pre-line">
              {{ product.deskripsi || 'Belum ada deskripsi.' }}
            </div>
          </section>
        </div>
      </div>

      <!-- Review -->
      <section class="mt-12">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-sm font-semibold">Review</h2>
          <button
            class="text-xs text-green-700 hover:underline"
            v-if="hasReviews"
            @click.prevent
          >
            Lihat Semua Ulasan
          </button>
        </div>

        <div v-if="!hasReviews" class="bg-white rounded-lg p-6 text-center text-sm text-gray-500 shadow">
          Belum ada review.
        </div>

        <div v-else class="space-y-4">
          <div
            v-for="r in reviews"
            :key="r.id"
            class="bg-white rounded-lg border border-gray-200 p-4 shadow-sm"
          >
            <p class="text-sm font-semibold mb-1">{{ r.nama }}</p>
            <div class="flex items-center gap-2 mb-2">
              <div class="flex">
                <svg
                  v-for="(filled,i) in starsArray(r.rating)"
                  :key="i"
                  :class="filled ? 'text-yellow-500' : 'text-gray-300'"
                  class="w-5 h-5"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                >
                  <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.967a1 1 0 00.95.69h4.175c.969 0 1.371 1.24.588 1.81l-3.38 2.455a1 1 0 00-.364 1.118l1.287 3.966c.3.922-.755 1.688-1.54 1.118l-3.38-2.454a1 1 0 00-1.175 0l-3.38 2.454c-.785.57-1.84-.196-1.54-1.118l1.287-3.966a1 1 0 00-.364-1.118L2.05 9.394c-.783-.57-.38-1.81.588-1.81h4.175a1 1 0 00.95-.69l1.286-3.967z"/>
                </svg>
              </div>
              <span class="text-xs text-gray-500">{{ r.tanggal }}</span>
            </div>
            <p class="text-xs text-gray-700 leading-relaxed">
              {{ r.isi }}
            </p>
          </div>
        </div>
      </section>
    </main>

    <Footer />
  </div>
</template>