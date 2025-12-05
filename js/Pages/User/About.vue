<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head } from '@inertiajs/vue3'

// gunakan aset yang sama seperti sebelumnya
import Logo from '*/dashboard/logo-ngundur.png'
import Profil from '*/dashboard/profil.png'
</script>

<template>
  <div class="font-inter text-gray-900 bg-gray-100 min-h-screen">
    <Header />
    <Head title="Profil" />

    <!-- HERO (gaya seperti Blog.vue) -->
    <section
      class="mt-16 h-[260px] md:h-[320px] relative flex items-center bg-cover bg-right"
      style="background-image: linear-gradient(to bottom, rgba(128,128,128,0.65), rgba(128,128,128,0.65)), url('/assets/dashboard/bg-profil.jpg'); background-size: cover; background-position: center;"
    >
      <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-4xl md:text-5xl font-extrabold text-white drop-shadow">Profil</h1>
      </div>
    </section>

    <!-- KONTEN UTAMA DALAM CARD (seperti Blog.vue) -->
    <main class="relative max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 -mt-10 pb-16">
      <div class="relative overflow-hidden rounded-3xl bg-white shadow-2xl border border-gray-200">
        <!-- background samar -->
        <div
          class="absolute inset-0 pointer-events-none"
          style="background-image: url('/assets/dashboard/bg-profil.jpg'); background-size: cover; background-position: right center; opacity: 0.05; filter: blur(0.5px);"
        ></div>

        <div class="relative z-10 p-6 sm:p-10 lg:p-14">
          <div class="grid gap-10 md:grid-cols-[2fr_1fr] items-start">
            <!-- Artikel: tetap memakai informasi About.vue -->
            <article class="space-y-6 text-base leading-relaxed text-gray-700">
              <header class="space-y-3">
                <h2 class="inline-block text-3xl md:text-4xl font-extrabold text-green-700 bg-green-100 rounded-full px-5 py-2">
                  Tentang NGUNDUR
                </h2>
                <p class="text-sm text-gray-500">~IoT : Stech Smart Garden</p>
                <h3 class="text-2xl md:text-4xl font-semibold text-green-700 px-1">
                  NGUNDUR
                </h3>
              </header>

              <p>
                Ngundur Nguthik Tandur adalah sebuah inisiatif inovasi teknologi pertanian berbasis IoT yang berfokus pada penyiraman tanaman otomatis. Berlokasi di Jl. Ringroad Barat, Dowangan, Banyuraden, Gamping, Sleman, Daerah Istimewa Yogyakarta, brand ini hadir untuk mendukung pertanian modern yang lebih efisien, hemat air, dan ramah lingkungan.
              </p>
              <p>
                Proyek ini lahir dari ide mahasiswa Universitas Sebelas Maret (UNS) yang menerima hibah untuk mengembangkan solusi nyata bagi kebutuhan pertanian. Melihat tantangan petani dan masyarakat perkotaan dalam mengatur kebutuhan air tanaman, tim mengembangkan perangkat IoT yang mampu mengotomatisasi proses penyiraman secara cerdas dan real-time.
              </p>
              <p>
                Nama <b>Ngundur Nguthik Tandur</b> berasal dari bahasa Jawa yang berarti “mengairi tanaman”. Filosofi ini mencerminkan semangat untuk selalu dekat dengan alam, menjaga keberlanjutan, sekaligus menghadirkan sentuhan teknologi yang sederhana namun berdampak besar bagi kehidupan.
              </p>
            </article>

            <!-- Aside: logo -->
            <aside class="space-y-6">
                <img :src="Logo" alt="NGUNDUR" class="w-64 md:w-80 lg:w-96 object-contain mt-20 md:mt-60" />
            </aside>
          </div>

          <!-- Bagian kedua (gaya gradient seperti Blog.vue) -->
          <section class="mt-12 grid gap-8 rounded-2xl border border-green-100 bg-gradient-to-r from-green-700 via-green-600 to-green-500 p-8 text-white shadow-lg md:grid-cols-[1.2fr_0.8fr]">
            <!-- VISI & MISI (konten sama persis) -->
            <div class="space-y-4">
              <h3 class="text-3xl md:text-4xl font-extrabold">VISI & MISI NGUNDUR</h3>

              <h4 class="text-xl font-semibold">VISI NGUNDUR</h4>
              <p class="text-green-100/90">
                Menjadi pelopor teknologi penyiraman otomatis yang mendukung pertanian berkelanjutan
                dan mudah diakses oleh semua kalangan.
              </p>

              <h4 class="mt-4 text-xl font-semibold">MISI NGUNDUR</h4>
              <ul class="mt-2 space-y-2 text-green-50 max-w-2xl" style="text-align:justify;">
                <li>1. Menghadirkan solusi IoT yang efisien dan hemat sumber daya.</li>
                <li>2. Memberikan manfaat nyata bagi petani maupun penghobi berkebun.</li>
                <li>3. Mendorong teknologi ramah lingkungan untuk keberlanjutan pangan.</li>
                <li>4. Membangun kolaborasi antara akademik, industri, dan masyarakat.</li>
              </ul>
            </div>

            <!-- 3 Kartu gambar profil (konten asli) -->
            <div class="grid grid-cols-1 gap-4">
              <div class="bg-white/10 rounded-xl h-40 flex items-center justify-center shadow ring-1 ring-white/20">
                <img :src="Profil" alt="" class="h-20 w-20 object-contain" />
              </div>
              <div class="bg-white/10 rounded-xl h-40 flex items-center justify-center shadow ring-1 ring-white/20">
                <img :src="Profil" alt="" class="h-20 w-20 object-contain" />
              </div>
            </div>
          </section>
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>