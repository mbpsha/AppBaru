<script setup>
import { ref, reactive, onMounted } from 'vue'
import { router } from '@inertiajs/vue3'
import axios from 'axios'

import Logo from '*/dashboard/logo-ngundur.png'
import Background from '*/login/BackgroundWOverlay.png'

const props = defineProps({
    recaptchaSiteKey: {
        type: String,
        required: true
    }
})

const form = reactive({
    nama: '',
    username: '',
    email: '',
    password: '',
    password_confirmation: '',
    processing: false,
    errors: {}
})

const showPassword = ref(false)
const recaptchaLoaded = ref(false)

const togglePassword = () => {
    showPassword.value = !showPassword.value
}

function loadRecaptcha() {
    if (window.grecaptcha) {
        recaptchaLoaded.value = true
        return
    }

    const script = document.createElement('script')
    script.src = 'https://www.google.com/recaptcha/api.js'
    script.async = true
    script.defer = true
    script.onload = () => {
        recaptchaLoaded.value = true
    }
    document.head.appendChild(script)
}

onMounted(() => {
    loadRecaptcha()
})

async function submit(e) {
    // Prevent any default form submission
    if (e) e.preventDefault()

    form.processing = true
    form.errors = {}

    try {
        // First, get CSRF cookie to ensure session is initialized
        await axios.get('/sanctum/csrf-cookie')

        const response = await axios.post('/api/register', {
            nama: form.nama,
            username: form.username,
            email: form.email,
            password: form.password,
            password_confirmation: form.password_confirmation
        }, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })

        // Store token in localStorage
        localStorage.setItem('auth_token', response.data.token)
        localStorage.setItem('user', JSON.stringify(response.data.user))

        // Set default axios header for future requests
        axios.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`

        // Force reload to verification page to ensure session is properly set
        window.location.href = '/email/verify'
    } catch (error) {
        form.processing = false
        if (error.response?.data?.errors) {
            form.errors = error.response.data.errors
        } else if (error.response?.data?.message) {
            form.errors.email = error.response.data.message
        } else {
            form.errors.email = 'Registration failed. Please try again.'
        }
        form.password = ''
        form.password_confirmation = ''
        if (window.grecaptcha) {
            window.grecaptcha.reset()
        }
    }
}
</script>

<template>
    <div class="min-h-screen relative overflow-hidden">
        <!-- Background Image -->
        <div class="absolute inset-0" :style="{ backgroundImage: `url(${Background})`, backgroundSize: 'cover', backgroundPosition: 'center' }"></div>

        <!-- Logo -->
        <div class="relative z-10 flex justify-center pt-16 pb-8">
            <img :src="Logo" alt="NGUNDUR Logo" class="h-16 w-auto" />
        </div>

        <!-- Form Card -->
        <div class="relative z-10 flex justify-center px-4">
            <div class="w-full max-w-md rounded-xl shadow-lg p-8" style="background-color: #BCD6B1;">
                <h1 class="text-2xl font-semibold text-white mb-8 text-center">Create Your Account</h1>

                <form @submit.prevent="submit" class="space-y-6">
                    <div>
                        <label class="block text-sm font-medium text-white mb-2">Username</label>
                        <input
                            v-model="form.username"
                            type="text"
                            required
                            placeholder="Masukkan username Anda"
                            class="w-full px-4 py-2 bg-white border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                            :class="{ 'border-red-500': form.errors.username }"
                        />
                        <div v-if="form.errors.username" class="text-red-200 text-sm mt-1">{{ form.errors.username }}</div>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-white mb-2">E-mail</label>
                        <input
                            v-model="form.email"
                            type="email"
                            required
                            placeholder="Masukkan email Anda"
                            class="w-full px-4 py-2 bg-white border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                            :class="{ 'border-red-500': form.errors.email }"
                        />
                        <div v-if="form.errors.email" class="text-red-200 text-sm mt-1">{{ form.errors.email }}</div>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-white mb-2">Name</label>
                        <input
                            v-model="form.nama"
                            type="text"
                            required
                            placeholder="Masukkan nama lengkap Anda"
                            class="w-full px-4 py-2 bg-white border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                            :class="{ 'border-red-500': form.errors.nama }"
                        />
                        <div v-if="form.errors.nama" class="text-red-200 text-sm mt-1">{{ form.errors.nama }}</div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-white mb-2">Password</label>
                        <div class="relative">
                        <input
                            v-model="form.password"
                            :type="showPassword ? 'text' : 'password'"
                            required
                            placeholder="Minimal 8 karakter"
                            class="w-full px-4 py-2 bg-white border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                            :class="{ 'border-red-500': form.errors.password }"
                        />
                            <button
                                type="button"
                                class="absolute inset-y-0 right-0 px-3 flex items-center text-gray-500 hover:text-gray-700"
                                :aria-label="showPassword ? 'Hide password' : 'Show password'"
                                @click="togglePassword"
                            >
                                <!-- eye -->
                                <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M2.25 12s3.75-7.5 9.75-7.5 9.75 7.5 9.75 7.5-3.75 7.5-9.75 7.5S2.25 12 2.25 12z" />
                                    <circle cx="12" cy="12" r="3" stroke-width="2" stroke="currentColor" />
                                </svg>
                                <!-- eye-off -->
                                <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M3 3l18 18M10.58 10.58A3 3 0 0113.5 13.5M6.1 6.1C3.9 7.9 2.25 12 2.25 12s3.75 7.5 9.75 7.5c2.02 0 3.82-.52 5.34-1.38M13.42 13.42C12.99 13.8 12.52 14 12 14a3 3 0 01-3-3c0-.52.2-.99.58-1.42M17.9 17.9C20.1 16.1 21.75 12 21.75 12s-3.75-7.5-9.75-7.5c-1.03 0-2.01.15-2.93.42" />
                                </svg>
                            </button>
                        </div>
                        <div v-if="form.errors.password" class="text-red-200 text-sm mt-1">{{ form.errors.password }}</div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-white mb-2">Confirm Password</label>
                        <div class="relative">
                        <input
                            v-model="form.password_confirmation"
                            :type="showPassword ? 'text' : 'password'"
                            required
                            placeholder="Ketik ulang password"
                            class="w-full px-4 py-2 bg-white border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                            :class="{ 'border-red-500': form.errors.password_confirmation }"
                        />
                            <button
                                type="button"
                                class="absolute inset-y-0 right-0 px-3 flex items-center text-gray-500 hover:text-gray-700"
                                :aria-label="showPassword ? 'Hide password' : 'Show password'"
                                @click="togglePassword"
                            >
                                <!-- eye -->
                                <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M2.25 12s3.75-7.5 9.75-7.5 9.75 7.5 9.75 7.5-3.75 7.5-9.75 7.5S2.25 12 2.25 12z" />
                                    <circle cx="12" cy="12" r="3" stroke-width="2" stroke="currentColor" />
                                </svg>
                                <!-- eye-off -->
                                <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M3 3l18 18M10.58 10.58A3 3 0 0113.5 13.5M6.1 6.1C3.9 7.9 2.25 12 2.25 12s3.75 7.5 9.75 7.5c2.02 0 3.82-.52 5.34-1.38M13.42 13.42C12.99 13.8 12.52 14 12 14a3 3 0 01-3-3c0-.52.2-.99.58-1.42M17.9 17.9C20.1 16.1 21.75 12 21.75 12s-3.75-7.5-9.75-7.5c-1.03 0-2.01.15-2.93.42" />
                                </svg>
                            </button>
                        </div>
                        <div v-if="form.errors.password_confirmation" class="text-red-200 text-sm mt-1">{{ form.errors.password_confirmation }}</div>
                    </div>

                    <!-- reCAPTCHA -->
                    <div class="flex justify-center">
                        <div v-if="recaptchaLoaded"
                             class="g-recaptcha"
                             :data-sitekey="recaptchaSiteKey">
                        </div>
                        <div v-else class="text-white text-sm">Loading reCAPTCHA...</div>
                    </div>
                    <div v-if="form.errors['g-recaptcha-response']" class="text-red-200 text-sm text-center">
                        {{ form.errors['g-recaptcha-response'] }}
                    </div>

                    <button :disabled="form.processing" type="submit" class="w-full py-3 rounded-md bg-blue-600 text-white font-medium hover:bg-blue-700 transition-colors disabled:opacity-50">
                        {{ form.processing ? 'Creating account...' : 'Sign Up' }}
                    </button>
                </form>

                <p class="text-sm text-white mt-6 text-center">
                    I'm already a member!
                    <a :href="route('login')" class="text-blue-200 underline">Sign in</a>
                </p>
            </div>
        </div>
    </div>
</template>
