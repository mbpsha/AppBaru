<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3'
import { ref } from 'vue'
import Popup from '@/Components/Popup.vue'

const props = defineProps({
    status: String
})

const form = useForm({})
const isResending = ref(false)

function resendEmail() {
    isResending.value = true
    form.post(route('verification.send'), {
        preserveScroll: true,
        onFinish: () => {
            isResending.value = false
        }
    })
}
</script>

<template>
    <div class="flex items-center justify-center min-h-screen bg-gradient-to-br from-green-50 to-green-100">
        <Head title="Verifikasi Email" />
        <Popup />

        <div class="w-full max-w-md p-8 bg-white rounded-lg shadow-xl">
            <!-- Icon -->
            <div class="flex justify-center mb-6">
                <div class="flex items-center justify-center w-20 h-20 bg-green-100 rounded-full">
                    <svg class="w-10 h-10 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                    </svg>
                </div>
            </div>

            <!-- Title -->
            <h2 class="mb-4 text-2xl font-bold text-center text-gray-900">
                Verifikasi Email Anda
            </h2>

            <!-- Message -->
            <div class="mb-6 text-sm text-center text-gray-600">
                <p class="mb-3">
                    Terima kasih telah mendaftar! Sebelum melanjutkan, mohon verifikasi alamat email Anda dengan mengklik link yang baru saja kami kirimkan ke email Anda.
                </p>
                <p class="text-xs text-gray-500">
                    Jika Anda tidak menerima email, kami dapat mengirimkan ulang link verifikasi.
                </p>
            </div>

            <!-- Success Message -->
            <div v-if="status === 'verification-link-sent' || $page.props.flash?.message"
                 class="p-3 mb-4 text-sm text-green-800 bg-green-100 border border-green-200 rounded-lg">
                <svg class="inline w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
                {{ $page.props.flash?.message || 'Link verifikasi baru telah dikirim ke email Anda!' }}
            </div>

            <!-- Actions -->
            <div class="flex flex-col gap-3">
                <button @click="resendEmail"
                        :disabled="isResending || form.processing"
                        class="w-full px-4 py-3 text-sm font-semibold text-white transition bg-green-600 rounded-lg hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed">
                    <svg v-if="isResending || form.processing" class="inline w-4 h-4 mr-2 animate-spin" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    {{ isResending || form.processing ? 'Mengirim...' : 'Kirim Ulang Email Verifikasi' }}
                </button>

                <Link :href="route('logout')" method="post" as="button"
                      class="w-full px-4 py-3 text-sm font-medium text-center text-red-600 transition bg-red-50 rounded-lg hover:bg-red-100">
                    Logout
                </Link>
            </div>

            <!-- Help Text -->
            <div class="mt-6 text-xs text-center text-gray-500">
                <p>Cek folder spam/junk jika email tidak masuk dalam beberapa menit.</p>
            </div>
        </div>
    </div>
</template>
