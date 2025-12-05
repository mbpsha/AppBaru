<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head } from '@inertiajs/vue3'
import { ref, computed } from 'vue'

import faqBG from '*/dashboard/blogfaq.png'

const activeTab = ref('produk')
const openedIndex = ref(null)

const heroStyle = computed(() => ({
  backgroundImage: `linear-gradient(to bottom, rgba(255,255,255,0), rgba(255,255,255,0)), url('${faqBG}')`,
  height: '400px',
  backgroundPosition: 'center 0px',
  backgroundSize: 'cover'
}))

const faqs = {
  produk: [
    {
      question: 'Apa itu Ngundur (Nguthik Tandur)?',
      answer:
        'Ngundur adalah perangkat IoT penyiram tanaman otomatis yang bekerja menggunakan sensor kelembapan tanah untuk menentukan kapan tanaman memerlukan air.'
    },
    {
      question: 'Bagaimana cara kerja sistem penyiraman otomatis?',
      answer:
        'Sensor akan membaca tingkat kelembapan tanah. Jika tanah terlalu kering, sistem akan mengaktifkan pompa air secara otomatis. Jika sudah cukup lembap, pompa akan berhenti.'
    },
    {
      question: 'Apakah alat ini bisa digunakan untuk berbagai jenis tanaman?',
      answer:
        'Ya, Ngundur dapat digunakan untuk berbagai jenis tanaman, baik skala rumah tangga, urban farming, hingga pertanian kecil'
    },
    {
      question: 'Apakah alat Ngundur membutuhkan listrik untuk bekerja?',
      answer: `Ya, Ngundur membutuhkan sumber energi. Terdapat dua pilihan jenis alat:
              • Tipe Panel Surya  – cocok untuk lokasi jauh dari listrik.
              • Tipe Listrik Langsung  - cocok untuk indoor atau area akses listrik stabil.`
    },
    {
      question: 'Apakah Ngundur bisa tetap bekerja saat cuaca mendung jika menggunakan panel surya?',
      answer:
        'Ya, Ngundur tetap bisa bekerja karena panel surya menyimpan daya pada baterai internal. Namun durasi operasional bergantung pada intensitas cahaya matahari.'
    }
  ],

  pembelian: [
    {
      question: 'Bagaimana cara membeli produk Ngundur “Nguthik Tandur”??',
      answer:
        'Anda dapat memilih produk pada halaman Toko Online, menambahkannya ke keranjang atau langsung klik Beli Sekarang, lalu menyelesaikan pembelian melalui proses checkout yang telah disediakan.'
    },
    {
      question: ' Metode pembayaran apa yang tersedia?',
      answer:
        'Pembayaran dapat dilakukan melalui  scan barcode QRIS yang telah disediakan.  Setelah pembayaran dilakukan, sistem admin akan memverifikasi transaksi Anda.'
    },
    {
      question: 'Apakah produk IoT tersedia ready stock atau pre-order?',
      answer:
        'Perangkat IoT Ngundur tersedia dalam sistem pre-order (PO) dengan estimasi waktu perakitan dan kalibrasi selama ±15 hari sebelum dikirimkan.'
    },
    {
      question: 'Bagaimana cara melacak status pesanan saya?',
      answer:
        'Anda dapat memantau status pesanan melalui akun Anda di menu Tracking Pesanan, mulai dari “Pembayaran Terverifikasi”, “Dalam Produksi”, “Dalam Pengiriman”, hingga “Beri Penilaian” setelah pesanan diterima.'
    },
    {
      question: 'Apakah produk memiliki garansi dan dukungan purna jual?',
      answer:
        'Ya. Produk mendapat garansi 30 hari untuk penggantian unit cacat dan 6 bulan garansi servis. Anda juga dapat menghubungi tim melalui kontak website untuk bantuan instalasi atau troubleshooting.'
    }
  ]
}

const visibleFaqs = computed(() => faqs[activeTab.value])

function setTab(tab) {
  activeTab.value = tab
  openedIndex.value = null // tutup semua ketika ganti tab
}

function toggle(idx) {
  openedIndex.value = openedIndex.value === idx ? null : idx
}
</script>

<template>
  <div class="font-inter text-gray-800 bg-white min-h-screen">
    <Header />
    <Head title="FAQ" />

    <section
      class="relative w-full flex items-center justify-center bg-cover"
        :style="heroStyle"
        >
      
      <div class="text-center">
        <h1
          class="text-[40px] md:text-[60px] font-extrabold text-white tracking-tight drop-shadow-lg leading-tight"
        >
          <span class="text-white">Frequently</span>
          <span class="text-[#a855f7] font-extrabold"> Asked Questions</span>
        </h1>

        <p class="text-white text-[18px] mt-2 tracking-wide">
          Pertanyaan yang sering diajukan seputar alat IoT penyiram tanaman otomatis
        </p>
      </div>
    </section>

    <!-- ================== CONTENT =================== -->
    <main class="relative max-w-6xl mx-auto px-6 sm:px-6 lg:px-8 -mt-10 pb-16">
      <div
        class="relative overflow-hidden rounded-3xl bg-white shadow-2xl border border-gray-200 p-10 md:p-14"
      >
        <div class="relative z-30">
          <h2 class="text-center text-5xl font-bold mb-10 tracking-wide">FAQ</h2>

          <!-- TAB -->
          <div class="flex justify-center gap-8 mb-12">
            <button
              class="text-sm font-semibold pb-1 tracking-wide transition"
              :class="
                activeTab === 'produk'
                  ? 'text-[#a855f7] border-b-2 border-[#a855f7]'
                  : 'text-gray-500'
              "
              @click="setTab('produk')"
            >
              PRODUK
            </button>

            <button
              class="text-sm font-semibold pb-1 tracking-wide transition"
              :class="
                activeTab === 'pembelian'
                  ? 'text-[#a855f7] border-b-2 border-[#a855f7]'
                  : 'text-gray-500'
              "
              @click="setTab('pembelian')"
            >
              PEMBELIAN
            </button>
          </div>

          <!-- FAQ LIST -->
          <div class="space-y-4">
            <div
              v-for="(item, idx) in visibleFaqs"
            :key="idx"
            class="relative rounded-2xl border border-gray-200 overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-200"
            >

            <button
                class="w-full px-6 py-5 flex items-center justify-between text-left"
                @click="toggle(idx)"
              >
                <h3 class="font-semibold text-[16px]">
                  {{ item.question }}
                </h3>
                <span class="text-xl text-gray-500">
                  {{ openedIndex === idx ? '−' : '+' }}
                </span>
            </button>

              <transition name="accordion">
                <div
                  v-if="openedIndex === idx"
                  class="px-6 pt-6 pb-6 bg-[#E2F2DA] border-t border-green-100 text-sm text-gray-700 whitespace-pre-line"
                >
                  {{ item.answer }}
                </div>
              </transition>
            </div>
          </div>
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>

<style scoped>
.accordion-enter-active,
.accordion-leave-active {
  overflow: hidden;
  /* atur kecepatan di sini */
  transition:
    max-height 0.35s ease,
    opacity 0.35s ease;
}

.accordion-enter-from,
.accordion-leave-to {
  max-height: 0;
  opacity: 0;
}

.accordion-enter-to,
.accordion-leave-from {
  max-height: 500px; /* cukup besar untuk isi jawaban */
  opacity: 1;
}
</style>