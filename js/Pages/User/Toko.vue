<script setup>
import { router } from '@inertiajs/vue3'
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'

const props = defineProps({
  products: { type: Object, required: true },
  orderStatus: { type: String, default: null } // contoh: 'verified' | 'production' | 'shipping' | 'delivered'
})

const statusMap = {
  verified: 0,
  production: 1,
  shipping: 2,
  delivered: 3 // siap dinilai
}

// Index aktif (0..3)
const activeIndex = statusMap[props.orderStatus] ?? -1

const fmt = (n) => new Intl.NumberFormat('id-ID',{style:'currency',currency:'IDR',maximumFractionDigits:0}).format(n)

function addToCart(p){
  router.post(route('cart.add'), { id_produk: p.id_produk }, { preserveScroll: true })
}

function goToReviews() {
  router.visit(route('reviews.index'), { preserveScroll: true })
}
</script>

<template>
  <div class="font-inter text-gray-900">
    <Header />

    <section class="mt-20 max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
      <h1 class="text-lg font-semibold mb-4">Toko</h1>

      <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
        <div v-for="p in products.data" :key="p.id_produk"
             class="rounded-2xl bg-green-100 shadow-[8px_8px_0_0_rgba(0,0,0,0.08)] p-4">
          <button
            @click="router.visit(route('produk.show', p.id_produk))"
            class="h-44 w-full flex items-center justify-center"
          >
            <img :src="p.gambar || '/assets/dashboard/profil.png'" alt="" class="h-40 object-contain" />
          </button>
          <p class="mt-2 text-[12px] text-center leading-4 line-clamp-2">
            {{ p.nama_produk }}
          </p>
          <p class="mt-2 text-center text-red-600 font-bold">
            {{ fmt(p.harga) }}
          </p>
          <button
            @click="router.post(route('cart.add'), { id_produk: p.id_produk }, { preserveScroll: true })"
            class="mt-3 w-full h-9 rounded-md bg-green-600 hover:bg-green-700 text-white text-sm">
            Tambah ke Keranjang
          </button>
        </div>
      </div>

      <!-- Pagination sederhana -->
      <div class="mt-8 flex justify-center gap-3">
        <button v-if="products.prev_page_url" @click="router.visit(products.prev_page_url)" class="px-3 py-1 rounded border">
          Sebelumnya
        </button>
        <button v-if="products.next_page_url" @click="router.visit(products.next_page_url)" class="px-3 py-1 rounded border">
          Berikutnya
        </button>
      </div>

      <!-- Pesanan Saya -->
      <section class="mt-12">
        <h2 class="text-base font-semibold mb-4">Pesanan Saya</h2>

        <div class="rounded-2xl bg-white/70 backdrop-blur ring-1 ring-gray-200 p-6 shadow-sm">
          <p class="text-sm text-gray-500 mb-4">Status pesanan terakhir Anda</p>

          <div class="grid grid-cols-4 gap-4">
            <!-- Step 1 -->
            <div class="flex flex-col items-center text-center gap-2">
              <div :class="['w-14 h-14 grid place-items-center rounded-xl shadow-sm',
                           activeIndex >= 0 ? 'bg-green-100 text-green-600' : 'bg-gray-100 text-gray-400']">
                <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                  <path stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                        d="M9 12l2 2 4-4M12 22a10 10 0 110-20 10 10 0 010 20z"/>
                </svg>
              </div>
              <p :class="['text-xs', activeIndex >= 0 ? 'text-gray-800' : 'text-gray-400']">
                Pembayaran Terverifikasi
              </p>
            </div>

            <!-- Step 2 -->
            <div class="flex flex-col items-center text-center gap-2">
              <div :class="['w-14 h-14 grid place-items-center rounded-xl shadow-sm',
                           activeIndex >= 1 ? 'bg-green-100 text-green-600' : 'bg-gray-100 text-gray-400']">
                <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                  <path stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                        d="M9.75 3l.91 2.73M14.25 3l-.91 2.73M4 7h16M6 7l1.5 11h9L18 7M8 11h8"/>
                </svg>
              </div>
              <p :class="['text-xs', activeIndex >= 1 ? 'text-gray-800' : 'text-gray-400']">
                Dalam Produksi
              </p>
            </div>

            <!-- Step 3 -->
            <div class="flex flex-col items-center text-center gap-2">
              <div :class="['w-14 h-14 grid place-items-center rounded-xl shadow-sm',
                           activeIndex >= 2 ? 'bg-green-100 text-green-600' : 'bg-gray-100 text-gray-400']">
                <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                  <path stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                        d="M3 7h11v8H3zM14 10h4l3 3v2h-7v-5zM5 21a2 2 0 100-4 2 2 0 000 4zm10 0a2 2 0 100-4 2 2 0 000 4z"/>
                </svg>
              </div>
              <p :class="['text-xs', activeIndex >= 2 ? 'text-gray-800' : 'text-gray-400']">
                Dalam Pengiriman
              </p>
            </div>

            <!-- Step 4 (selalu aktif) -->
            <div class="flex flex-col items-center text-center gap-2">
              <button
                type="button"
                @click="goToReviews()"
                class="group focus:outline-none"
              >
                <div class="w-14 h-14 grid place-items-center rounded-xl shadow-sm transition bg-green-100 text-green-600 group-hover:scale-105">
                  <svg class="w-7 h-7" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                  </svg>
                </div>
              </button>
              <p
                @click="goToReviews()"
                class="text-xs text-green-700 font-medium underline cursor-pointer"
              >
                Beri Penilaian
              </p>
            </div>
          </div>
        </div>
      </section>
    </section>

    <Footer />
  </div>
</template>