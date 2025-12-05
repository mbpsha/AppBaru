<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head, Link } from '@inertiajs/vue3'

const props = defineProps({
  news: { type: Object, required: true } // pagination dari controller
})

const cover = (img) => img ? `/storage/${img}` : '/assets/dashboard/berita-1.png'
</script>

<template>
  <div class="font-inter text-gray-900">
    <Header />
    <Head title="Berita" />

    <main class="mt-16 min-h-screen">
      <div class="w-full" style="background-image: linear-gradient(to bottom, rgba(255,255,255,0.45), rgba(236,253,245,0.08)), url('/assets/dashboard/bg-berita.jpg'); background-size: cover; background-position: center bottom;">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8 py-6 md:py-8">
          <h1 class="text-4xl md:text-5xl font-extrabold tracking-wide text-[#2D6A4F] mb-6 md:mb-8">
            BERITA PERTANIAN
          </h1>

          <!-- Daftar berita dari DB -->
          <div class="space-y-6">
            <article v-for="a in news.data" :key="a.id" class="relative overflow-hidden rounded-2xl bg-green-50/80 backdrop-blur-md shadow-lg ring-1 ring-green-200">
              <Link class="w-full text-left block" :href="route('berita.show', a.id)">
                <div class="p-4 md:p-6">
                  <div class="flex flex-col md:flex-row gap-4 md:gap-6 items-center">
                    <div class="shrink-0 rounded-lg overflow-hidden shadow-sm flex-none">
                      <img :src="cover(a.image)" :alt="a.title" class="w-40 h-28 md:w-48 md:h-32 object-cover rounded-lg" />
                    </div>
                    <div class="flex-1 min-w-0">
                      <h2 class="text-lg md:text-xl font-semibold text-[#155e3b]">{{ a.title }}</h2>
                      <p class="mt-2 text-sm md:text-base text-gray-700">{{ a.excerpt }}</p>
                      <div class="mt-3 md:mt-2 text-right">
                        <span class="inline-block text-sm font-medium text-[#196f3d] hover:underline">Baca Selengkapnya</span>
                      </div>
                    </div>
                  </div>
                </div>
              </Link>
            </article>

            <div v-if="news.data?.length === 0" class="p-8 text-center text-gray-500 bg-white/70 rounded-xl">
              Belum ada berita yang dipublikasikan.
            </div>
          </div>

          <!-- Pagination -->
          <div v-if="news.links && news.links.length > 3" class="mt-8 flex items-center justify-between">
            <div class="text-sm text-gray-600">Menampilkan {{ news.from }}–{{ news.to }} dari {{ news.total }}</div>
            <div class="flex items-center gap-2">
              <Link v-for="link in news.links" :key="link.label" :href="link.url || '#'"
                    class="px-3 py-1 rounded border"
                    :class="link.active ? 'bg-green-700 text-white border-green-700' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'"
                    v-html="link.label" />
            </div>
          </div>
        </div>

        <Footer />
      </div>
    </main>
  </div>
</template>