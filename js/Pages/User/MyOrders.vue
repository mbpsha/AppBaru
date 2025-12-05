<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head, router } from '@inertiajs/vue3'
import { computed } from 'vue'

const props = defineProps({
  orders: { type: Array, required: true }
})

const fmt = (n) => new Intl.NumberFormat('id-ID', { style:'currency', currency:'IDR', maximumFractionDigits:0 }).format(n)

const statusColor = (status) => {
  const colors = {
    'pending': 'bg-yellow-100 text-yellow-800',
    'menunggu_verifikasi': 'bg-blue-100 text-blue-800',
    'diproses': 'bg-purple-100 text-purple-800',
    'dikirim': 'bg-indigo-100 text-indigo-800',
    'selesai': 'bg-green-100 text-green-800',
    'dibatalkan': 'bg-red-100 text-red-800'
  }
  return colors[status] || 'bg-gray-100 text-gray-800'
}

const statusText = (status) => {
  const text = {
    'pending': 'Menunggu Pembayaran',
    'diproses': 'Sedang Diproses',
    'dikirim': 'Sedang Dikirim',
    'selesai': 'Selesai',
    'dibatalkan': 'Dibatalkan'
  }
  return text[status] || status
}

const paymentStatusColor = (status) => {
  const colors = {
    'pending': 'text-yellow-600',
    'verified': 'text-green-600',
    'rejected': 'text-red-600'
  }
  return colors[status] || 'text-gray-600'
}

const paymentStatusText = (status) => {
  const text = {
    'pending': 'Menunggu Verifikasi',
    'verified': 'Terverifikasi',
    'rejected': 'Ditolak'
  }
  return text[status] || status
}
</script>

<template>
  <div class="min-h-screen text-gray-900 bg-gray-100 font-inter">
    <Header />
    <Head title="Pesanan Saya" />

    <main class="max-w-6xl px-4 pt-24 pb-16 mx-auto sm:px-6 lg:px-8">
      <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-bold">Pesanan Saya</h1>
        <button @click="router.visit('/toko')" class="px-4 py-2 text-sm text-white bg-green-600 rounded-md hover:bg-green-700">
          Belanja Lagi
        </button>
      </div>

      <!-- Empty State -->
      <div v-if="orders.length === 0" class="py-16 text-center bg-white rounded-lg shadow-sm">
        <svg class="w-24 h-24 mx-auto text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
        </svg>
        <h3 class="mt-4 text-lg font-semibold text-gray-600">Belum ada pesanan</h3>
        <p class="mt-2 text-sm text-gray-500">Yuk, mulai belanja produk berkualitas dari kami!</p>
        <button @click="router.visit('/toko')" class="px-6 py-2 mt-6 text-sm font-medium text-white bg-green-600 rounded-md hover:bg-green-700">
          Mulai Belanja
        </button>
      </div>

      <!-- Orders List -->
      <div v-else class="space-y-4">
        <div v-for="order in orders" :key="order.id_order"
            class="overflow-hidden bg-white border rounded-lg shadow-sm">

          <!-- Order Header -->
          <div class="flex items-center justify-between px-5 py-3 border-b bg-gray-50">
            <div class="flex items-center gap-4">
              <div>
                <p class="text-xs text-gray-500">Order ID</p>
                <p class="font-semibold">#{{ order.id_order }}</p>
              </div>
              <div class="w-px h-8 bg-gray-300"></div>
              <div>
                <p class="text-xs text-gray-500">Tanggal</p>
                <p class="text-sm font-medium">{{ order.tanggal }}</p>
              </div>
            </div>
            <div class="text-right">
              <span :class="['px-3 py-1 text-xs font-semibold rounded-full', statusColor(order.status)]">
                {{ statusText(order.status) }}
              </span>
            </div>
          </div>

          <!-- Order Content -->
          <div class="p-5">
            <!-- Products -->
            <div class="space-y-3">
              <div v-for="(product, idx) in order.products" :key="idx"
                  class="flex gap-4 pb-3 border-b last:border-b-0">
                <img :src="product.gambar"
                    @error="$event.target.src='/assets/dashboard/profil.png'"
                    class="object-contain w-20 h-20 border rounded-md"
                    alt="produk" />
                <div class="flex-1">
                  <p class="font-semibold line-clamp-2">{{ product.nama }}</p>
                  <div class="flex items-center gap-2 mt-1">
                    <span class="text-sm text-gray-600">{{ fmt(product.harga) }}</span>
                    <span class="text-xs text-gray-400">x{{ product.jumlah }}</span>
                  </div>
                </div>
                <div class="text-right">
                  <p class="text-sm font-semibold">{{ fmt(product.subtotal) }}</p>
                </div>
              </div>
            </div>

            <!-- Total & Payment Info -->
            <div class="flex items-end justify-between pt-4 mt-4 border-t">
              <div class="space-y-1">
                <!-- Payment Status -->
                <div v-if="order.payment_status" class="flex items-center gap-2 text-sm">
                  <svg class="w-4 h-4" :class="paymentStatusColor(order.payment_status)" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  <span class="text-gray-600">Status Pembayaran:</span>
                  <span :class="['font-semibold', paymentStatusColor(order.payment_status)]">
                    {{ paymentStatusText(order.payment_status) }}
                  </span>
                </div>
                <div v-else class="text-sm text-orange-600">
                  ⚠️ Belum upload bukti pembayaran
                </div>

                <!-- Bukti Transfer -->
                <div v-if="order.bukti_transfer" class="mt-2">
                  <a :href="order.bukti_transfer" target="_blank"
                    class="text-xs text-blue-600 underline hover:text-blue-800">
                    Lihat Bukti Transfer
                  </a>
                </div>

                <!-- Alamat Pengiriman -->
                <div v-if="order.alamat" class="pt-2 mt-2 text-xs text-gray-600 border-t">
                  <p class="font-semibold">Dikirim ke:</p>
                  <p>{{ order.alamat.nama_penerima }} ({{ order.alamat.no_telp }})</p>
                  <p class="line-clamp-2">{{ order.alamat.alamat_lengkap }}, {{ order.alamat.kota }}, {{ order.alamat.provinsi }} {{ order.alamat.kode_pos }}</p>
                </div>
                <div v-if="order.shipping" class="pt-2 mt-2 text-xs text-gray-600 border-t">
                  <p class="font-semibold">Detail Pengiriman</p>
                  <p>
                    {{ [order.shipping.courier, order.shipping.service].filter(Boolean).join(' ') || 'Kurir belum ditentukan' }}
                    <span v-if="order.shipping.etd">• ETD {{ order.shipping.etd }} hari</span>
                  </p>
                  <p>Ongkir: <span class="font-semibold">{{ fmt(order.shipping.cost || 0) }}</span></p>
                  <p v-if="order.shipping.is_estimated" class="text-[11px] text-orange-600">Estimasi ongkir otomatis</p>
                </div>
              </div>

              <!-- Total Harga -->
              <div class="text-right">
                <p class="text-xs text-gray-500">Total Pembayaran</p>
                <p class="text-2xl font-bold text-green-700">{{ fmt(order.total_harga) }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>