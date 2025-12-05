<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head, Link } from '@inertiajs/vue3'

const props = defineProps({
  article: { type: Object, required: true }
})
const cover = props.article.image ? `/storage/${props.article.image}` : '/assets/dashboard/berita-1.png'
</script>

<template>
  <div class="font-inter text-gray-900">
    <Header />
    <Head :title="article.title" />

    <main class="mt-20 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 mb-16">
      <Link :href="route('berita')" class="mb-4 inline-flex items-center gap-2 px-3 py-2 bg-white rounded shadow">← Kembali</Link>
      <article class="bg-white rounded-xl p-6 md:p-10 shadow">
        <img :src="cover" :alt="article.title" class="w-full h-64 md:h-96 object-cover rounded-lg mb-6" />
        <h1 class="text-2xl md:text-3xl font-bold text-[#155e3b]">{{ article.title }}</h1>
        <p class="text-sm text-gray-600 mt-1">{{ new Date(article.created_at).toLocaleDateString('id-ID') }}</p>
        <div class="mt-4 text-gray-800 whitespace-pre-line leading-7">{{ article.content }}</div>
      </article>
    </main>

    <Footer />
  </div>
</template>