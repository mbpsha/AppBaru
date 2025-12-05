<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head, router, useForm } from '@inertiajs/vue3'
import { ref, computed, watch } from 'vue'

const props = defineProps({
  pendingReviews: { type: Array, default: () => [] },
  history: { type: Array, default: () => [] }
})

const activeTab = ref('review')
const showToast = ref(false)
const toastMsg = ref('')

const pending = computed(() => props.pendingReviews ?? [])
const historyList = computed(() => props.history ?? [])

const selectedDetailId = ref(pending.value[0]?.detail_id ?? null)

const currentItem = computed(() =>
  pending.value.find(o => o.detail_id === selectedDetailId.value) || null
)

const form = useForm({
  id_produk: currentItem.value?.id_produk ?? null,
  rating: 0,
  komentar: ''
})

watch(() => pending.value, (items) => {
  if (!items.length) {
    selectedDetailId.value = null
    return
  }
  if (!items.find(x => x.detail_id === selectedDetailId.value)) {
    selectedDetailId.value = items[0].detail_id
  }
}, { immediate: true })

watch(currentItem, (item) => {
  form.id_produk = item?.id_produk ?? null
  form.rating = 0
  form.komentar = ''
}, { immediate: true })

function setRating(v) {
  form.rating = v
}

function submitReview() {
  if (!currentItem.value) return
  if (!form.rating) return toast('Pilih rating terlebih dahulu.')

  form.post(route('reviews.store'), {
    preserveScroll: true,
    onSuccess: () => {
      toast('Terima kasih! Penilaianmu sudah terkirim.')
      activeTab.value = 'history'
    },
    onError: (errors) => {
      if (errors.rating) toast(errors.rating)
      else if (errors.id_produk) toast(errors.id_produk)
    }
  })
}

function buyAgain(it) {
  router.visit(`/checkout/${it.id_produk}?qty=1`, { preserveScroll: true })
}

function toast(message) {
  toastMsg.value = message
  showToast.value = true
  setTimeout(() => (showToast.value = false), 2200)
}
</script>

<template>
  <div class="min-h-screen text-gray-900 font-inter bg-gray-50">
    <Header />
    <Head title="Beri Penilaian" />

    <main class="max-w-5xl px-4 pt-24 pb-20 mx-auto sm:px-6 lg:px-8">
      <!-- Tabs -->
      <div class="flex items-center justify-center gap-10 mb-6">
        <button
          class="pb-2 text-sm font-semibold border-b-2"
          :class="activeTab==='review' ? 'text-green-700 border-green-600' : 'text-gray-500 border-transparent'"
          @click="activeTab='review'">
          Beri Penilaian
        </button>
        <button
          class="pb-2 text-sm font-semibold border-b-2"
          :class="activeTab==='history' ? 'text-green-700 border-green-600' : 'text-gray-500 border-transparent'"
          @click="activeTab='history'">
          Histori pembelian
        </button>
      </div>

      <!-- Beri Penilaian -->
      <section v-show="activeTab==='review'">
        <div v-if="currentItem" class="p-6 bg-white border shadow-sm rounded-2xl">
          <div v-if="pending.length > 1" class="flex flex-wrap gap-2 mb-6">
            <button
              v-for="item in pending"
              :key="item.detail_id"
              type="button"
              @click="selectedDetailId = item.detail_id"
              class="px-3 py-1 text-xs font-medium rounded-full border transition"
              :class="selectedDetailId === item.detail_id
                ? 'bg-green-100 border-green-500 text-green-700'
                : 'bg-gray-50 border-gray-200 text-gray-500 hover:border-green-400'">
              {{ item.name }}
            </button>
          </div>

          <!-- Header produk -->
          <div class="flex items-start gap-4">
            <img :src="currentItem.image" class="object-contain w-16 h-16 bg-white border rounded-md" alt="produk">
            <div class="flex-1">
              <p class="text-base font-semibold leading-tight">{{ currentItem.name }}</p>
              <p class="text-xs text-gray-600">{{ currentItem.note || 'Pesanan siap dinilai' }}</p>
              <p class="text-[11px] text-gray-400 mt-1">{{ currentItem.date }}</p>
            </div>
          </div>

          <!-- Nilai Produk -->
          <div class="mt-8 text-center">
            <p class="mb-3 text-sm font-semibold">Nilai Produk</p>
            <div class="flex items-center justify-center gap-3 text-4xl">
              <button v-for="i in 5" :key="i" @click="setRating(i)"
                      :class="i<=form.rating ? 'text-yellow-400' : 'text-gray-300'">★</button>
            </div>
            <p v-if="form.errors.rating" class="mt-2 text-sm text-red-600">{{ form.errors.rating }}</p>

            <!-- Ulasan -->
            <p class="mt-8 mb-2 text-sm font-semibold">Tulis Ulasan</p>
            <textarea v-model="form.komentar" rows="6"
                      class="w-full px-3 py-2 border rounded-xl bg-gray-50 focus:ring-green-500 focus:border-green-500"
                      placeholder="Ceritakan pengalamanmu (opsional)"></textarea>
            <p v-if="form.errors.komentar" class="mt-1 text-sm text-red-600">{{ form.errors.komentar }}</p>

            <button @click="submitReview"
                    :disabled="form.processing"
                    class="h-10 px-6 mt-6 text-sm font-medium text-white bg-green-600 rounded-md hover:bg-green-700 disabled:bg-gray-400">
              {{ form.processing ? 'Menyimpan...' : 'Kirim' }}
            </button>
          </div>
        </div>

        <p v-else class="py-10 text-sm text-center text-gray-500">
          Semua pesanan sudah dinilai. Terima kasih!
        </p>
      </section>

      <!-- Histori pembelian -->
      <section v-show="activeTab==='history'" class="space-y-4">
        <div v-for="it in historyList" :key="it.id" class="flex items-center gap-4 p-4 border border-green-100 bg-green-50/70 rounded-2xl">
          <img :src="it.image" alt="produk" class="object-contain w-16 h-16 bg-white border rounded-md" />
          <div class="flex-1">
            <p class="text-sm font-semibold leading-tight">
              {{ it.name }} <span class="font-normal text-gray-600"> {{ it.note }}</span>
            </p>
            <div class="mt-1 text-lg tracking-tight text-yellow-400">
              <span v-for="i in 5" :key="i">{{ i<= (it.rating ?? 0) ? '★' : '☆' }}</span>
            </div>
            <p v-if="it.reviewText" class="mt-1 text-xs text-gray-700 line-clamp-2">“{{ it.reviewText }}”</p>
            <p class="text-[11px] text-gray-500 mt-1">{{ it.date }}</p>
          </div>
          <button @click="buyAgain(it)"
                  class="px-4 py-2 text-sm text-green-700 bg-green-100 rounded-md hover:bg-green-200">
            Beli Lagi
          </button>
        </div>
        <p v-if="!historyList.length" class="py-6 text-sm text-center text-gray-500">
          Belum ada ulasan. Ayo beri penilaian setelah pesananmu selesai!
        </p>
      </section>
    </main>

    <Footer />

    <!-- Toast -->
    <transition name="fade">
      <div v-if="showToast" class="fixed px-4 py-2 text-sm text-white -translate-x-1/2 bg-green-600 rounded-md shadow bottom-6 left-1/2">
        {{ toastMsg }}
      </div>
    </transition>
  </div>
</template>

<style scoped>
.fade-enter-active,.fade-leave-active{transition:opacity .2s}
.fade-enter-from,.fade-leave-to{opacity:0}
</style>