<script setup>
import BgHero from '*/dashboard/bg-depan01.png'
defineEmits(['readMore'])
</script>

<template>
  <!-- offset dari header fixed -->
  <section class="relative mt-16">
    <!-- 🔹 Full width tanpa max-w -->
    <div class="relative w-full h-[560px] md:h-[620px] overflow-hidden rounded-b-[36px] sm:rounded-b-[48px] shadow-md">

      <!-- Background image -->
      <img
        :src="BgHero"
        alt="Leaves"
        class="absolute inset-0 w-full h-full object-cover"
      />

      <!-- Kabut putih atas -->
      <div class="absolute inset-x-0 top-0 h-40 bg-gradient-to-b from-white/80 via-white/40 to-transparent"></div>
      <div class="absolute inset-0 bg-gradient-to-b from-black/10 via-transparent to-black/20"></div>

      <!-- 🔹 Posisi konten (teks di kiri) -->
      <div class="relative z-10 h-full flex items-center pl-8 sm:pl-20 md:pl-28">
        <div class="max-w-2xl">
          <h1
            class="text-white font-Urbanist tracking-tight leading-[0.95]
                  text-[clamp(2.6rem,7vw,6rem)] font-semibold"
          >
            Stech Smart<br />Garden
          </h1>

          <p
            class="mt-4 max-w-[36rem] text-white/90 font-inter
                  text-[clamp(0.95rem,1.8vw,1.125rem)]"
          >
            Stech Smart Garden adalah sistem irigasi otomatis berbasis IoT skala kecil
            yang dirancang untuk membantu petani dan masyarakat yang hobi berkebun
            dalam mengelola kebutuhan air secara efisien.
          </p>

          <div class="mt-6 flex flex-wrap items-center gap-3">
            <a
              :href="route('toko')"
              class="px-6 py-2.5 rounded-full bg-green-500 hover:bg-green-600
                  text-white font-medium shadow transition"
            >
              Beli Sekarang
            </a>
            <button
              type="button"
              @click="$emit('readMore')"
              class="px-6 py-2.5 rounded-full border border-white/70
                  text-white/95 bg-white/10 hover:bg-white hover:text-green-700
                    backdrop-blur-sm transition"
            >
              Baca Lengkap
            </button>
          </div>
        </div>
      </div>

      <!-- Fade bawah halus -->
      <div class="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-white/70 to-transparent"></div>
    </div>
  </section>
</template>