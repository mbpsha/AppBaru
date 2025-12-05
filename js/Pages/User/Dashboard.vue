<script setup>
import { onMounted, ref, watch } from 'vue'
import { usePage } from '@inertiajs/vue3'
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import HeroSection from '@/Components/User/HeroSection.vue'
import NewsCarousel from '@/Components/User/NewsCarousel.vue'
import FeatureSection from '@/Components/User/FeatureSection.vue'
import Popup from '@/Components/Popup.vue'

import Band1 from '*/dashboard/bawah1.png'
import Band2 from '*/dashboard/bawah2.png'
import Band3 from '*/dashboard/bawah3.png'
import FooterLogo from '*/dashboard/footer-logo.png'
import Profil from '*/dashboard/profil.png'

const page = usePage()

// Flash message handling
const showFlash = ref(false)
const flashMessage = ref('')
const flashType = ref('info')

watch(() => [page.props.flash?.message, page.props.flash?.warning], ([msg, warn]) => {
  if (msg) {
    flashMessage.value = msg
    flashType.value = 'success'
    showFlash.value = true
    setTimeout(() => showFlash.value = false, 4000)
  } else if (warn) {
    flashMessage.value = warn
    flashType.value = 'warning'
    showFlash.value = true
    setTimeout(() => showFlash.value = false, 6000)
  }
}, { immediate: true })

function scrollToNews() {
    const el = document.getElementById('news-section')
    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' })
}
onMounted(() => window.scrollTo({ top: 0 }))
</script>

<template>
    <div class="text-gray-900 font-inter">
        <!-- Popup Component -->
        <Popup />

        <!-- NAVBAR -->
        <Header />

    <!-- Flash Message Toast -->
    <Transition
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="translate-y-2 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-2 opacity-0"
    >
      <div v-if="showFlash" class="fixed z-50 px-4 py-3 rounded-lg shadow-lg top-20 right-4"
           :class="{
             'bg-green-100 text-green-800 border border-green-200': flashType === 'success',
             'bg-yellow-100 text-yellow-800 border border-yellow-200': flashType === 'warning'
           }">
        <div class="flex items-center gap-2">
          <svg v-if="flashType === 'success'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
          <svg v-if="flashType === 'warning'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
          </svg>
          <span class="text-sm font-medium">{{ flashMessage }}</span>
        </div>
      </div>
    </Transition>

    <!-- HERO -->
    <section class="mt-16">
        <HeroSection @readMore="scrollToNews" />
    </section>

    <!-- NEWS -->
    <section id="news-section" class="py-12">
        <div class="max-w-6xl px-4 mx-auto sm:px-6 lg:px-8">
            <NewsCarousel />
        </div>
    </section>

    <!-- TITLE CHIP -->
    <section class="mt-2">
        <div class="max-w-6xl px-4 mx-auto sm:px-6 lg:px-8">
            <div class="inline-block px-5 py-2 text-green-800 bg-green-100 border border-green-200 shadow-sm rounded-xl">
            <span class="font-semibold">Keunggulan Alat</span>
            </div>
        </div>
    </section>

    <!-- FEATURES -->
    <FeatureSection />

    <!-- IMAGE BAND -->
    <section class="py-10">
        <div class="grid max-w-6xl gap-4 px-4 mx-auto sm:px-6 lg:px-8 md:grid-cols-3">
            <div class="relative overflow-hidden rounded-xl">
            <img :src="Band1" alt="" class="object-cover w-full h-48 md:h-56">
            <div class="absolute inset-0 bg-black/35"></div>
            <div class="absolute inset-0 flex items-center justify-center">
                <span class="text-2xl font-bold text-white drop-shadow">Monitoring<br class="md:hidden"> Real time</span>
            </div>
            </div>
            <div class="relative overflow-hidden rounded-xl">
            <img :src="Band2" alt="" class="object-cover w-full h-48 md:h-56">
            <div class="absolute inset-0 bg-black/35"></div>
            <div class="absolute inset-0 flex items-center justify-center">
                <span class="text-2xl font-bold text-white drop-shadow">Irigasi<br class="md:hidden"> Otomatis</span>
            </div>
            </div>
            <div class="relative overflow-hidden rounded-xl">
            <img :src="Band3" alt="" class="object-cover w-full h-48 md:h-56">
            <div class="absolute inset-0 bg-black/35"></div>
            <div class="absolute inset-0 flex items-center justify-center">
                <span class="text-2xl font-bold text-white drop-shadow">Dashboard<br class="md:hidden"> Web</span>
            </div>
            </div>
        </div>
        </section>

        <!-- FOOTER -->
        <Footer />
    </div>
</template>
