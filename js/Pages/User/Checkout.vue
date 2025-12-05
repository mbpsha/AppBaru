<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3'
import { ref, computed, watch } from 'vue'
import Qris from '*/dashboard/qrisNGUNDUR.jpg'

const props = defineProps({
  order_id: { type: Number, default: null }, // Order ID yang sudah dibuat (persistent)
  user: { type: Object, required: true },
  shipping: { type: Object, required: true },
  product: { type: Object, required: true },
  qty: { type: Number, default: 1 },
  summary: { type: Object, required: true }
})

const page = usePage()
const fmt = (n) => new Intl.NumberFormat('id-ID', { style:'currency', currency:'IDR', maximumFractionDigits:0 }).format(n)
const formatWeight = (weight) => {
  if (!weight) return ''
  const kg = weight / 1000
  return new Intl.NumberFormat('id-ID', { maximumFractionDigits: 2 }).format(kg)
}
const shippingQuoteText = computed(() => {
  const quote = props.shipping?.quote
  if (!quote) return 'Estimasi ongkir sementara'
  const courier = quote.courier ? `${quote.courier}${quote.service ? ' ' + quote.service : ''}` : null
  const etd = quote.etd ? `ETD ${quote.etd} hari` : null
  const suffix = quote.is_estimated ? ' (estimasi)' : ''
  const base = [courier, etd].filter(Boolean)
  return (base.length ? base.join(' • ') : 'Estimasi ongkir') + suffix
})

// Notification Pop-up State
const showNotification = ref(false)
const notification = ref(null)

// Watch untuk notification dari backend
watch(() => page.props.flash?.notification, (newNotif) => {
  if (newNotif) {
    notification.value = newNotif
    showNotification.value = true
  }
}, { immediate: true })

function closeNotification() {
  showNotification.value = false
  notification.value = null
}

function goToMyOrders() {
  router.visit('/pesanan-saya')
}

function openAddressForm() {
  router.visit(route('checkout.address', { id_produk: props.product.id_produk }) + `?qty=${props.qty}`)
}

// STEP 1: CREATE ORDER
const orderForm = useForm({
  qty: props.qty,
  id_alamat: props.user?.id_alamat || null,
  shipping_cost: props.shipping?.quote?.cost || props.summary?.ongkir || 0,
  admin_fee: props.summary?.admin || 5000,
  shipping_weight: props.summary?.weight || props.shipping?.quote?.weight || 1000,
  shipping_destination_city_id: props.shipping?.quote?.destination_city_id || 0,
  shipping_courier: props.summary?.courier || props.shipping?.quote?.courier || 'jne',
  shipping_service: props.summary?.service || props.shipping?.quote?.service || 'REG',
  shipping_etd: props.summary?.etd || props.shipping?.quote?.etd || '3-5',
  shipping_is_estimated: props.summary?.is_shipping_estimated || props.shipping?.quote?.is_estimated ? 1 : 0,
})
function createOrder() {
  console.log('Creating order with data:', orderForm.data())
  orderForm.post(route('order.create', { id_produk: props.product.id_produk }), {
    preserveScroll: false, // Allow page to scroll to top after order created
    preserveState: false,  // Force page re-render to show flash message
    onSuccess: (response) => {
      console.log('Order created successfully!', response)
      // Page will reload with flash message
    },
    onError: (errors) => {
      console.error('Order creation failed:', errors)
      alert('Gagal membuat pesanan: ' + JSON.stringify(errors))
    }
  })
}

// STEP 2: UPLOAD BUKTI (setelah order dibuat)
const payForm = useForm({
  trx_id: '',
  bukti_transfer: null,
  agree: false,
})
function onFileChange(e) {
  payForm.bukti_transfer = e.target.files?.[0] || null
}
function submitPayment() {
  // Gunakan order_id dari props (persistent) atau flash message
  const orderId = props.order_id || page.props.flash?.order_id

  if (!orderId) {
    alert('Silakan buat pesanan terlebih dahulu dengan klik tombol "Buat Pesanan".')
    return
  }

  payForm.post(route('payment.confirm', { id_order: orderId }), {
    forceFormData: true,
    preserveScroll: true,
    onSuccess: () => {
      payForm.reset('trx_id', 'bukti_transfer', 'agree')
    }
  })
}
</script>

<template>
  <div class="min-h-screen text-gray-900 bg-gray-100 font-inter">
    <Header />
    <Head title="Check Out" />

    <main class="max-w-5xl px-4 pt-24 pb-16 mx-auto sm:px-6 lg:px-8">
      <div class="flex items-center justify-between mb-4">
        <h1 class="text-lg font-semibold">Check Out</h1>
        <button @click="router.visit('/toko')" class="px-4 py-2 text-sm text-gray-700 bg-gray-200 rounded-md hover:bg-gray-300">
          Kembali
        </button>
      </div>

      <!-- Success Messages -->
      <div v-if="$page.props.flash?.message" class="px-4 py-2 mb-4 text-blue-800 bg-blue-100 rounded">
        {{ $page.props.flash.message }}
      </div>
      <div v-if="$page.props.flash?.error" class="px-4 py-2 mb-4 text-red-800 bg-red-100 rounded">
        {{ $page.props.flash.error }}
      </div>

      <!-- Notification Pop-up (Success Payment) -->
      <Transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="translate-y-4 opacity-0"
        enter-to-class="translate-y-0 opacity-100"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="translate-y-0 opacity-100"
        leave-to-class="translate-y-4 opacity-0"
      >
        <div v-if="showNotification && notification"
             class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50"
             @click="closeNotification">
          <div class="w-full max-w-md p-6 bg-white rounded-lg shadow-xl" @click.stop>
            <!-- Icon Success -->
            <div class="flex justify-center mb-4">
              <div class="flex items-center justify-center w-16 h-16 bg-green-100 rounded-full">
                <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
              </div>
            </div>

            <!-- Title & Message -->
            <h3 class="mb-2 text-xl font-bold text-center text-gray-900">
              {{ notification.title }}
            </h3>
            <p class="mb-6 text-sm text-center text-gray-600">
              {{ notification.message }}
            </p>

            <!-- Order Info -->
            <div class="p-3 mb-6 border rounded-lg bg-gray-50">
              <div class="flex justify-between text-sm">
                <span class="text-gray-600">Order ID:</span>
                <span class="font-semibold">#{{ notification.order_id }}</span>
              </div>
              <div class="flex justify-between text-sm">
                <span class="text-gray-600">Payment ID:</span>
                <span class="font-semibold">#{{ notification.payment_id }}</span>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex gap-3">
              <button @click="closeNotification"
                      class="flex-1 px-4 py-2 text-sm font-medium text-gray-700 bg-gray-200 rounded-md hover:bg-gray-300">
                Tutup
              </button>
              <button @click="goToMyOrders"
                      class="flex-1 px-4 py-2 text-sm font-medium text-white bg-green-600 rounded-md hover:bg-green-700">
                Lihat Pesanan Saya
              </button>
            </div>
          </div>
        </div>
      </Transition>

      <div class="p-5 bg-white border shadow-sm rounded-2xl md:p-6">
        <div class="grid md:grid-cols-[1fr_300px] gap-6">

          <!-- kiri: produk + alamat + ringkasan + konfirmasi -->
          <div class="space-y-4">
            <!-- Produk -->
            <div class="flex gap-4">
              <img :src="product.gambar_url || '/assets/dashboard/profil.png'"
                   class="object-contain w-24 h-24 border rounded-md" alt="produk"
                   @error="$event.target.src='/assets/dashboard/profil.png'" />
              <div class="flex-1">
                <p class="font-semibold leading-snug">{{ product.nama_produk }}</p>
                <p class="mt-1 text-xs text-gray-600 line-clamp-2">{{ product.deskripsi }}</p>
                <div class="mt-2 font-bold text-red-600">{{ fmt(product.harga) }}</div>
                <div class="mt-1 text-xs text-gray-600">Jumlah: <span class="font-medium">{{ qty }}</span></div>
                <div class="text-xs text-gray-600">Estimasi Tiba: <span class="font-medium">± 15 hari</span></div>
              </div>
            </div>

            <!-- Alamat untuk pesanan ini -->
            <div class="p-4 border border-green-100 rounded-lg bg-green-50">
              <div class="flex items-start justify-between gap-3">
                <div>
                  <p class="text-sm font-semibold">
                    {{ shipping.is_temp ? 'Alamat Pengiriman (Sementara)' : 'Alamat Saya' }}
                  </p>
                  <p class="mt-1 text-xs text-gray-700 whitespace-pre-line">
                    {{ shipping.name }}<br>
                    {{ shipping.text }}
                  </p>
                  <p class="text-[11px] text-gray-500 mt-1">
                    Telp: {{ shipping.phone || '-' }}
                  </p>
                  <div class="pt-3 mt-3 text-xs text-gray-600 border-t border-green-100">
                    <p class="font-semibold text-gray-700">Info Pengiriman</p>
                    <p>{{ shippingQuoteText }}</p>
                    <p v-if="shipping.quote && shipping.quote.weight" class="text-[11px] text-gray-500">
                      Berat dihitung: {{ formatWeight(shipping.quote.weight) }} kg
                    </p>
                  </div>
                </div>
                <button class="text-xs px-3 py-1.5 rounded-md bg-green-100 text-green-700 hover:bg-green-200"
                        @click="openAddressForm">
                  + Tambah Alamat Baru
                </button>
              </div>
            </div>

            <!-- Ringkasan -->
            <div class="p-4 text-sm border rounded-lg bg-gray-50">
              <div class="flex justify-between"><span>Harga Produk</span><span>{{ fmt(product.harga * qty) }}</span></div>
              <div class="flex justify-between"><span>Biaya Admin</span><span>{{ fmt(summary.admin) }}</span></div>
              <div class="flex justify-between"><span>Biaya Pengiriman</span><span>{{ fmt(summary.ongkir) }}</span></div>
              <p v-if="summary.courier || summary.service || summary.etd" class="mt-1 text-[11px] text-right text-gray-500">
                {{ [summary.courier, summary.service].filter(Boolean).join(' ') }}
                <span v-if="summary.etd">• ETD {{ summary.etd }} hari</span>
                <span v-if="summary.is_shipping_estimated" class="text-orange-600"> (estimasi)</span>
              </p>
              <div class="my-2 border-t"></div>
              <div class="flex justify-between font-semibold"><span>Total Harga</span><span>{{ fmt(summary.total) }}</span></div>
            </div>

            <!-- Tombol Buat Pesanan / Selesaikan Pembayaran -->
            <button @click="createOrder"
                    :disabled="orderForm.processing || order_id"
                    class="w-full h-10 text-sm font-medium text-white bg-green-600 rounded-md hover:bg-green-700 disabled:bg-gray-400 disabled:cursor-not-allowed">
              {{ orderForm.processing ? 'Memproses...' : (order_id ? '✓ Pesanan Dibuat - Silakan Upload Bukti Pembayaran' : 'Buat Pesanan') }}
            </button>

            <!-- Info Order (hanya muncul setelah order dibuat) -->
            <div v-if="order_id || $page.props.flash?.order_created" class="px-4 py-3 mt-2 border-l-4 border-red-500 rounded-md bg-red-50">
              <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <div>
                  <p class="text-sm font-semibold text-red-800">⚠️ Selesaikan Pembayaran</p>
                  <p class="text-xs text-red-700">Status: <strong>Menunggu Pembayaran</strong></p>
                </div>
              </div>
            </div>

            <!-- Konfirmasi Pembayaran -->
            <div class="mt-6">
              <div class="px-4 py-2 text-sm font-semibold text-white bg-green-800 rounded-t-lg">
                Konfirmasi Pembayaranmu
              </div>
              <div class="p-4 space-y-4 border border-t-0 rounded-b-lg">
                <div>
                  <label class="block mb-1 text-sm font-medium">ID Transaksional (Opsional)</label>
                  <input v-model="payForm.trx_id" type="text"
                         class="w-full px-3 py-2 border rounded-md bg-gray-50 focus:bg-white" placeholder="Nomor referensi transfer" />
                  <p v-if="payForm.errors.trx_id" class="mt-1 text-xs text-red-600">{{ payForm.errors.trx_id }}</p>
                </div>

                <div>
                  <label class="block mb-1 text-sm font-medium">Bukti Pembayaran <span class="text-red-500">*</span></label>
                  <input type="file" accept=".jpg,.jpeg,.png" @change="onFileChange"
                         class="block w-full text-sm file:mr-3 file:px-4 file:py-2 file:rounded-md file:bg-green-600 file:text-white file:hover:bg-green-700 file:border-0" />
                  <ul class="mt-2 text-[11px] text-gray-600 list-disc ml-4">
                    <li>Format: JPG, JPEG, PNG</li>
                    <li>Maksimal ukuran: 5 MB</li>
                    <li>Pastikan bukti pembayaran jelas dan dapat dibaca</li>
                  </ul>
                  <p v-if="payForm.errors.bukti_transfer" class="mt-1 text-xs text-red-600">{{ payForm.errors.bukti_transfer }}</p>
                </div>

                <label class="flex items-start gap-2 text-xs text-gray-700">
                  <input type="checkbox" v-model="payForm.agree" class="mt-0.5">
                  <span>Saya menyetujui bahwa informasi yang saya berikan adalah benar dan saya telah melakukan pembayaran sesuai dengan jumlah yang tertera</span>
                </label>
                <p v-if="payForm.errors.agree" class="-mt-2 text-xs text-red-600">{{ payForm.errors.agree }}</p>

                <div class="flex gap-3">
                  <button type="button" @click="submitPayment"
                          :disabled="payForm.processing || !payForm.bukti_transfer || !payForm.agree"
                          class="flex-1 h-10 text-sm text-white bg-blue-600 rounded-md hover:bg-blue-700 disabled:opacity-60">
                    {{ payForm.processing ? 'Mengirim...' : 'Konfirmasi Pembayaran' }}
                  </button>
                  <button type="button" @click="router.reload({ only: ['shipping','summary'] })"
                          class="flex-1 h-10 text-sm text-white rounded-md bg-red-500/90 hover:bg-red-600">
                    Reset Form
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- kanan: QRIS -->
          <aside class="p-4 border rounded-xl">
            <p class="mb-2 text-sm font-semibold text-center">QRIS</p>
            <img :src="Qris" alt="QRIS" class="object-contain w-full rounded-md" />
            <p class="text-[11px] text-gray-500 text-center mt-2">Scan QRIS untuk melakukan pembayaran</p>
          </aside>
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>
