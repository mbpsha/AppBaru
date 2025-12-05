<script setup>
import { computed } from 'vue'
import F1 from '*/dashboard/keunggulan-alat-0.png'
import F2 from '*/dashboard/keunggulan-alat-1.png'
import F3 from '*/dashboard/keunggulan-alat-2.png'

const props = defineProps({ items: { type: Array, default: null } })

const defaults = [
  {
    title: 'Modular & Scalable',
    text: 'Stech Smart Garden dirancang dengan konsep modular dan scalable, sehingga mudah ditambahkan sensor atau fitur lain sesuai kebutuhan pengguna. Selain sensor kelembaban tanah yang sudah menjadi inti sistem, pengguna dapat menambahkan sensor suhu, kelembaban udara, intensitas cahaya, hingga pH dan nutrisi tanah untuk pemantauan yang lebih komprehensif. Seluruh sensor ini dapat diintegrasikan dengan dashboard web yang sudah tersedia, sehingga data tambahan langsung bisa divisualisasikan secara real-time.',
    image: F1, alt: 'Modular sprinkler'
  },
  {
    title: 'Hemat Energi',
    text: 'Varian Stech Smart Garden dengan panel surya mendukung operasi mandiri karena memanfaatkan energi matahari sebagai sumber daya utama. Dengan sistem ini, perangkat dapat berfungsi secara berkelanjutan tanpa bergantung pada listrik PLN, sehingga sangat cocok digunakan di daerah yang minim pasokan listrik atau di lahan terbuka yang jauh dari jaringan listrik. Selain lebih hemat biaya operasional, penggunaan panel surya juga menjadikan sistem ini ramah lingkungan karena mengurangi jejak karbon dan memaksimalkan pemanfaatan energi terbarukan.',
    image: F2, alt: 'Panel surya'
  },
  {
    title: 'Open Source & Edukatif',
    text: 'Stech Smart Garden dilengkapi dengan buku panduan perakitan dan source code yang dapat digunakan sebagai media pembelajaran IoT. Dengan adanya panduan ini, pengguna tidak hanya mendapatkan produk siap pakai, tetapi juga bisa memahami alur kerja sistem mulai dari instalasi komponen, integrasi sensor, hingga pengelolaan data pada dashboard. Source code yang disertakan bersifat terbuka sehingga dapat dipelajari, dimodifikasi, dan dikembangkan lebih lanjut sesuai kebutuhan, menjadikan produk ini tidak hanya bermanfaat secara praktis, tetapi juga edukatif bagi pelajar, mahasiswa, maupun siapa saja yang ingin mendalami teknologi IoT di bidang pertanian.',
    image: F3, alt: 'Buku panduan'
  }
]

const list = computed(() => props.items ?? defaults)

// === Uniform helpers (seragam semua) ===
function imageOnLeft(i) { return i % 2 === 0 }         // semua: gambar kiri
function isCircleImage() { return false }      // tidak ada gambar bulat
function showRowCenteredTitle() { return false } // tidak ada judul di tengah
</script>

<template>
  <section class="py-10">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="space-y-12">
        <div v-for="(f,i) in list" :key="i" class="grid lg:grid-cols-2 gap-8 items-center">
          <!-- IMAGE (seragam) -->
          <div :class="[ imageOnLeft(i) ? 'order-1' : 'order-2' ]">
            <div class="w-full h-56 md:h-64 rounded-2xl overflow-hidden shadow-md border border-gray-100">
              <img :src="f.image" :alt="f.alt" class="w-full h-full object-cover" />
            </div>
          </div>

          <!-- TEXT (seragam) -->
          <div :class="[ imageOnLeft() ? 'order-2' : 'order-1' ]"
              class="bg-white rounded-2xl shadow-md border border-gray-100 p-6">
            <h3 class="text-xl font-semibold text-gray-900">{{ f.title }}</h3>
            <p class="mt-3 text-gray-700">{{ f.text }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>