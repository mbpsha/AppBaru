<script setup>
import FooterBg from '*/dashboard/footer-logo.png'
</script>

<template>
    <footer class="relative mt-10">
        <div class="relative bg-gradient-to-r from-green-800 to-green-700 text-white">
        <div class="absolute inset-y-0 right-0 w-1/3 opacity-30 hidden md:block">
            <img :src="FooterBg" alt="" class="w-full h-full object-cover">
        </div>

        <div class="relative max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10 grid md:grid-cols-2 gap-8">
            <div>
            <h4 class="text-xl font-semibold">NGUNDUR</h4>
            <p class="mt-3 text-sm leading-7 text-white/90">
                Jl. Ringroad Barat, Dowangan, Banyuraden,<br>
                Gamping, Sleman, Daerah Istimewa Yogyakarta
            </p>
            <div class="mt-4 space-y-1 text-sm text-white/90">
                <p><span class="font-semibold">Phone</span> +62 000-000-000</p>
                <p><span class="font-semibold">WA</span> +62 000-000-000</p>
                <p><span class="font-semibold">Hours</span> Senin–Jum'at 09.00–16.00</p>
            </div>
            <div class="mt-6 h-px bg-white/30 max-w-sm"></div>
            <p class="mt-4 text-xs text-white/70">© 2025 NGUNDUR</p>
            </div>

            <div class="flex items-center justify-end"></div>
        </div>
        </div>
    </footer>
</template>